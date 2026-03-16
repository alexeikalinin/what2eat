import { supabase, isSupabaseConfigured } from './supabase'
import { Dish, Ingredient } from '../types'

// Кухонные базовые — всегда считаются "есть в наличии", не влияют на coverage
// Только имена, которые реально существуют в таблице ingredients
const PANTRY_STAPLE_NAMES = [
  'Соль', 'Перец черный', 'Масло растительное', 'Масло сливочное',
  'Сахар', 'Уксус', 'Лавровый лист', 'Оливковое масло',
]

let _cachedPantryIds: number[] | null = null
export function resetPantryCache() { _cachedPantryIds = null }

async function getPantryIngredientIds(): Promise<number[]> {
  if (_cachedPantryIds) return _cachedPantryIds
  if (!isSupabaseConfigured()) return []
  const { data } = await supabase
    .from('ingredients')
    .select('id')
    .in('name', PANTRY_STAPLE_NAMES)
  _cachedPantryIds = (data ?? []).map((r) => r.id as number)
  return _cachedPantryIds
}

export interface FindDishesOptions {
  vegetarianOnly?: boolean
  veganOnly?: boolean
}

export interface RandomizerFocus {
  cuisine: 'any' | 'russian' | 'italian' | 'asian' | 'eastern_european' | 'mediterranean' | 'georgian' | 'mexican' | 'french'
  mealType: 'any' | 'breakfast' | 'lunch' | 'dinner' | 'snack'
  cookingTime: 'any' | 'quick' | 'medium' | 'slow' // quick<=20, medium 21-45, slow>45
  difficulty: 'any' | 'easy' | 'medium' | 'hard'
  vegetarianOnly: boolean
}

function rowToDish(row: Record<string, unknown>): Dish {
  return {
    id: row.id as number,
    name: row.name as string,
    name_en: (row.name_en as string) || null,
    description: (row.description as string) || null,
    description_en: (row.description_en as string) || null,
    image_url: (row.image_url as string) || null,
    cooking_time: row.cooking_time as number,
    difficulty: row.difficulty as Dish['difficulty'],
    servings: row.servings as number,
    estimated_cost: (row.estimated_cost as number) ?? null,
    is_vegetarian: Boolean(row.is_vegetarian),
    is_vegan: Boolean(row.is_vegan),
  }
}

export async function findDishesByIngredients(
  ingredientIds: number[],
  options: FindDishesOptions = {}
): Promise<Dish[]> {
  if (!isSupabaseConfigured()) return []
  const { vegetarianOnly = false, veganOnly = false } = options

  if (ingredientIds.length === 0) return []

  try {
    const pantryIds = await getPantryIngredientIds()
    const pantrySet = new Set(pantryIds)
    const userSet = new Set(ingredientIds)
    // Everything user has + pantry staples = "available"
    const availableSet = new Set([...ingredientIds, ...pantryIds])

    // Step 1: candidates — dishes with at least one user-selected ingredient
    const { data: matchRows, error: matchError } = await supabase
      .from('dish_ingredients')
      .select('dish_id')
      .in('ingredient_id', ingredientIds)

    if (matchError) throw matchError
    const candidateIds = [...new Set((matchRows ?? []).map((r) => r.dish_id as number))]
    if (candidateIds.length === 0) return []

    // Step 2: full dish info
    let dishQuery = supabase
      .from('dishes')
      .select('id, name, name_en, description, description_en, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan')
      .in('id', candidateIds)
      .limit(100)

    if (veganOnly) dishQuery = dishQuery.eq('is_vegan', true)
    else if (vegetarianOnly) dishQuery = dishQuery.eq('is_vegetarian', true)

    const { data: dishRows, error: dishError } = await dishQuery
    if (dishError) throw dishError
    const candidateDishes = (dishRows ?? []).map(rowToDish)

    // Step 3: all dish_ingredients for candidates in one batch
    const { data: diRows, error: diError } = await supabase
      .from('dish_ingredients')
      .select('dish_id, ingredient_id')
      .in('dish_id', candidateIds)
    if (diError) throw diError

    const dishIngredientsMap = new Map<number, number[]>()
    for (const row of diRows ?? []) {
      const dId = row.dish_id as number
      if (!dishIngredientsMap.has(dId)) dishIngredientsMap.set(dId, [])
      dishIngredientsMap.get(dId)!.push(row.ingredient_id as number)
    }

    // Step 4: ingredient details
    const allUniqueIngIds = [...new Set([...dishIngredientsMap.values()].flat())]
    const ingredientDetailsMap = new Map<number, Ingredient>()
    if (allUniqueIngIds.length > 0) {
      const { data: ingDetails } = await supabase
        .from('ingredients')
        .select('id, name, name_en, category, image_url')
        .in('id', allUniqueIngIds)
      for (const r of ingDetails ?? []) {
        ingredientDetailsMap.set(r.id as number, {
          id: r.id as number,
          name: r.name as string,
          name_en: (r.name_en as string) || null,
          category: r.category as Ingredient['category'],
          image_url: (r.image_url as string) || null,
          show_in_selector: true,
        })
      }
    }

    // Step 4b: fetch user ingredient names for fuzzy matching
    // "Сливочные помидоры" (user) should cover "Помидоры" (dish ingredient)
    const { data: userIngDetails } = await supabase
      .from('ingredients').select('id, name').in('id', ingredientIds)
    const userIngNamesLower = (userIngDetails ?? []).map((r) => (r.name as string).toLowerCase())

    // Fuzzy check: dish ingredient id is "covered" if any user ingredient name
    // contains the dish ingredient name as a substring (min 3 chars)
    function isFuzzyCovered(dishIngId: number): boolean {
      if (userSet.has(dishIngId)) return true
      const ing = ingredientDetailsMap.get(dishIngId)
      if (!ing) return false
      const dishName = ing.name.toLowerCase()
      if (dishName.length < 3) return false
      return userIngNamesLower.some((un) => un.includes(dishName))
    }

    // Step 5: score by coverage of KEY ingredients (excluding pantry staples)
    type ScoredDish = Dish & { _missingIds: number[]; _coverage: number }
    const scoredDishes: ScoredDish[] = []
    const seenNames = new Set<string>()  // deduplicate dishes with identical names

    for (const dish of candidateDishes) {
      // Skip duplicate dish names (keep highest coverage later via sort)
      const nameLower = dish.name.toLowerCase()
      if (seenNames.has(nameLower)) continue

      const allDishIngIds = dishIngredientsMap.get(dish.id) || []

      // Key ingredients = dish ingredients that are NOT pantry staples
      const keyIngIds = allDishIngIds.filter((id) => !pantrySet.has(id))

      // How many key ingredients does the user have? (exact + fuzzy)
      const matchedKeyIds = keyIngIds.filter((id) => isFuzzyCovered(id))

      // What's missing? Key ingredients not available (not pantry, not exact, not fuzzy)
      const missingKeyIds = keyIngIds.filter((id) => !availableSet.has(id) && !isFuzzyCovered(id))

      // Coverage: 1.0 = can cook right now, 0.5 = half the key ingredients available
      const coverage = keyIngIds.length > 0 ? matchedKeyIds.length / keyIngIds.length : 1.0

      // Show only if: user has at least one ingredient AND coverage >= 50%
      const hasUserIngredient = allDishIngIds.some((id) => userSet.has(id) || isFuzzyCovered(id))
      if (!hasUserIngredient || coverage < 0.5) continue

      seenNames.add(nameLower)

      const dishIngredients = allDishIngIds
        .map((id) => ingredientDetailsMap.get(id))
        .filter(Boolean) as Ingredient[]

      scoredDishes.push({
        ...dish,
        ingredients: dishIngredients,
        match_count: matchedKeyIds.length,
        _coverage: coverage,
        _missingIds: missingKeyIds,
      })
    }

    // Sort: Tier 1 (coverage=1) first, then by coverage desc, then by missing count asc, then by cooking_time asc
    scoredDishes.sort((a, b) => {
      const aTier = a._coverage >= 1.0 ? 0 : 1
      const bTier = b._coverage >= 1.0 ? 0 : 1
      if (aTier !== bTier) return aTier - bTier
      if (b._coverage !== a._coverage) return b._coverage - a._coverage
      if (a._missingIds.length !== b._missingIds.length) return a._missingIds.length - b._missingIds.length
      return a.cooking_time - b.cooking_time
    })

    // Cap: 10 from tier1 + 10 from tier2
    const tier1 = scoredDishes.filter((d) => d._coverage >= 1.0).slice(0, 10)
    const tier2 = scoredDishes.filter((d) => d._coverage < 1.0).slice(0, 10)
    const finalDishes = [...tier1, ...tier2]

    // Resolve missing ingredient names (batch)
    const allMissingIds = [...new Set(finalDishes.flatMap((d) => d._missingIds))]
    const missingDetailsMap = new Map<number, Ingredient>()
    if (allMissingIds.length > 0) {
      const { data: missingDetails } = await supabase
        .from('ingredients')
        .select('id, name, name_en, category, image_url')
        .in('id', allMissingIds)
      for (const r of missingDetails ?? []) {
        missingDetailsMap.set(r.id as number, {
          id: r.id as number,
          name: r.name as string,
          name_en: (r.name_en as string) || null,
          category: r.category as Ingredient['category'],
          image_url: (r.image_url as string) || null,
          show_in_selector: true,
        })
      }
    }

    return finalDishes.map(({ _missingIds, _coverage, ...dish }) => {
      const missing = _missingIds.map((id) => missingDetailsMap.get(id)).filter(Boolean) as Ingredient[]
      return {
        ...dish,
        coverage: _coverage,
        missing_ingredients: missing.length > 0 ? missing : undefined,
      }
    })
  } catch (error) {
    console.error('Error finding dishes:', error)
    return []
  }
}

export async function getAllDishes(): Promise<Dish[]> {
  try {
    const { data, error } = await supabase
      .from('dishes')
      .select('id, name, name_en, description, description_en, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, dish_ingredients(ingredient_id)')
      .order('name')

    if (error) throw error

    const dishes = (data ?? []).map((row) => {
      const ingIds = ((row.dish_ingredients as unknown) as { ingredient_id: number }[]).map((di) => di.ingredient_id)
      return { ...rowToDish(row as Record<string, unknown>), _ingIds: ingIds }
    })

    // Load ingredient details
    const allIngIds = [...new Set(dishes.flatMap((d) => d._ingIds))]
    const ingMap = new Map<number, Ingredient>()
    if (allIngIds.length > 0) {
      const { data: ingData } = await supabase
        .from('ingredients')
        .select('id, name, name_en, category, image_url')
        .in('id', allIngIds)
      for (const r of ingData ?? []) {
        ingMap.set(r.id as number, {
          id: r.id as number,
          name: r.name as string,
          name_en: (r.name_en as string) || null,
          category: r.category as Ingredient['category'],
          image_url: (r.image_url as string) || null,
          show_in_selector: true,
        })
      }
    }

    return dishes.map(({ _ingIds, ...dish }) => ({
      ...dish,
      ingredients: _ingIds.map((id) => ingMap.get(id)).filter(Boolean) as Ingredient[],
    }))
  } catch (error) {
    console.error('Error getting all dishes:', error)
    return []
  }
}

export async function getDishesWithMeat(): Promise<Dish[]> {
  try {
    const { data: meatIngs } = await supabase
      .from('ingredients')
      .select('id')
      .eq('category', 'meat')
    const meatIds = (meatIngs ?? []).map((r) => r.id as number)
    if (meatIds.length === 0) return []

    const { data: diRows } = await supabase
      .from('dish_ingredients')
      .select('dish_id')
      .in('ingredient_id', meatIds)
    const dishIds = [...new Set((diRows ?? []).map((r) => r.dish_id as number))]
    if (dishIds.length === 0) return []

    const { data, error } = await supabase
      .from('dishes')
      .select('id, name, name_en, description, description_en, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, dish_ingredients(ingredient_id)')
      .in('id', dishIds)
      .order('name')
    if (error) throw error

    const dishes = (data ?? []).map((row) => {
      const ingIds = ((row.dish_ingredients as unknown) as { ingredient_id: number }[]).map((di) => di.ingredient_id)
      return { ...rowToDish(row as Record<string, unknown>), _ingIds: ingIds }
    })

    const allIngIds = [...new Set(dishes.flatMap((d) => d._ingIds))]
    const ingMap = new Map<number, Ingredient>()
    if (allIngIds.length > 0) {
      const { data: ingData } = await supabase.from('ingredients').select('id, name, name_en, category, image_url').in('id', allIngIds)
      for (const r of ingData ?? []) {
        ingMap.set(r.id as number, { id: r.id as number, name: r.name as string, name_en: (r.name_en as string) || null, category: r.category as Ingredient['category'], image_url: (r.image_url as string) || null, show_in_selector: true })
      }
    }

    return dishes.map(({ _ingIds, ...dish }) => ({
      ...dish,
      ingredients: _ingIds.map((id) => ingMap.get(id)).filter(Boolean) as Ingredient[],
    }))
  } catch (error) {
    console.error('Error getting dishes with meat:', error)
    return []
  }
}

export function randomizeDishes(dishes: Dish[]): Dish[] {
  if (dishes.length === 0) return []
  const shuffled = [...dishes].sort(() => Math.random() - 0.5)
  return shuffled.slice(0, Math.min(20, shuffled.length))
}

export async function getDishesByFocus(focus: RandomizerFocus): Promise<Dish[]> {
  if (!isSupabaseConfigured()) return []
  try {
    let query = supabase
      .from('dishes')
      .select('id, name, name_en, description, description_en, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan')

    if (focus.cuisine !== 'any') query = query.eq('cuisine_type', focus.cuisine)
    if (focus.mealType !== 'any') query = query.eq('meal_type', focus.mealType)
    if (focus.cookingTime === 'quick') query = query.lte('cooking_time', 20)
    else if (focus.cookingTime === 'medium') query = query.gt('cooking_time', 20).lte('cooking_time', 45)
    else if (focus.cookingTime === 'slow') query = query.gt('cooking_time', 45)
    if (focus.difficulty !== 'any') query = query.eq('difficulty', focus.difficulty)
    if (focus.vegetarianOnly) query = query.eq('is_vegetarian', true)

    // Fetch more than needed, then shuffle in JS (Supabase JS doesn't support ORDER BY RANDOM())
    const { data, error } = await query.limit(100)
    if (error) throw error

    const dishes = (data ?? []).map((row) => rowToDish(row as Record<string, unknown>))
    // Fisher-Yates shuffle (unbiased)
    for (let i = dishes.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [dishes[i], dishes[j]] = [dishes[j], dishes[i]]
    }
    return dishes.slice(0, 20)
  } catch (error) {
    console.error('Error getting dishes by focus:', error)
    return []
  }
}

export async function getQuickDishes(limit = 50): Promise<Dish[]> {
  if (!isSupabaseConfigured()) return []
  try {
    const { data, error } = await supabase
      .from('dishes')
      .select('id, name, name_en, description, description_en, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan')
      .lte('cooking_time', 60)
      .order('cooking_time')
      .limit(limit)
    if (error) throw error
    return (data ?? []).map((row) => rowToDish(row as Record<string, unknown>))
  } catch (error) {
    console.error('Error getting quick dishes:', (error as {message?:string,code?:string})?.message, (error as {code?:string})?.code)
    return []
  }
}

export async function getDishOfDay(): Promise<Dish | null> {
  if (!isSupabaseConfigured()) return null
  try {
    const { count } = await supabase.from('dishes').select('*', { count: 'exact', head: true })
    const total = count ?? 0
    if (total === 0) return null

    const now = new Date()
    const start = new Date(now.getFullYear(), 0, 0)
    const dayOfYear = Math.floor((now.getTime() - start.getTime()) / 86400000)
    const offset = dayOfYear % total

    const { data, error } = await supabase
      .from('dishes')
      .select('id, name, name_en, description, description_en, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan')
      .order('id')
      .range(offset, offset)
    if (error) throw error
    if (!data || data.length === 0) return null
    return rowToDish(data[0] as Record<string, unknown>)
  } catch (error) {
    console.error('Error getting dish of day:', error)
    return null
  }
}

export async function getDishById(dishId: number): Promise<Dish | null> {
  if (!isSupabaseConfigured()) return null
  try {
    const { data, error } = await supabase
      .from('dishes')
      .select('id, name, name_en, description, description_en, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, dish_ingredients(ingredient_id, ingredients(id, name, name_en, category, image_url))')
      .eq('id', dishId)
      .maybeSingle()
    if (error) throw error
    if (!data) return null

    const ingredients = ((data.dish_ingredients as unknown) as Array<{
      ingredient_id: number
      ingredients: { id: number; name: string; category: string; image_url: string | null }
    }>).map((di) => ({
      id: di.ingredients.id,
      name: di.ingredients.name,
      category: di.ingredients.category as Ingredient['category'],
      image_url: di.ingredients.image_url || null,
      show_in_selector: true,
    }))

    return { ...rowToDish(data as Record<string, unknown>), ingredients }
  } catch (error) {
    console.error('Error getting dish by id:', error)
    return null
  }
}
