import { supabase } from './supabase'
import { Dish, Ingredient } from '../types'

// Базовые ингредиенты (специи, масла) — расширяем поиск
async function getBasicIngredientIds(): Promise<number[]> {
  const basicNames = ['Соль', 'Перец черный', 'Масло растительное', 'Масло сливочное']
  const { data } = await supabase
    .from('ingredients')
    .select('id')
    .in('name', basicNames)
  return (data ?? []).map((r) => r.id as number)
}

export interface FindDishesOptions {
  allowMissing?: number
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
    description: (row.description as string) || null,
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
  const autoMissing = Math.max(1, Math.ceil(ingredientIds.length / 3))
  const { allowMissing = autoMissing, vegetarianOnly = false, veganOnly = false } = options

  if (ingredientIds.length === 0) return []

  try {
    const basicIngredientIds = await getBasicIngredientIds()
    const allAllowedIngredients = [...ingredientIds, ...basicIngredientIds]

    // Step 1: candidate dish IDs — dishes that have at least one selected ingredient
    const { data: matchRows, error: matchError } = await supabase
      .from('dish_ingredients')
      .select('dish_id')
      .in('ingredient_id', ingredientIds)

    if (matchError) throw matchError
    const candidateIds = [...new Set((matchRows ?? []).map((r) => r.dish_id as number))]
    if (candidateIds.length === 0) return []

    // Step 2: fetch full dish info for candidates
    let dishQuery = supabase
      .from('dishes')
      .select('id, name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan')
      .in('id', candidateIds)
      .limit(50)

    if (veganOnly) dishQuery = dishQuery.eq('is_vegan', true)
    else if (vegetarianOnly) dishQuery = dishQuery.eq('is_vegetarian', true)

    const { data: dishRows, error: dishError } = await dishQuery
    if (dishError) throw dishError

    const candidateDishes = (dishRows ?? []).map(rowToDish)

    // Step 3: fetch ALL dish_ingredients for candidates in one batch
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

    // Step 4: load ingredient details for all unique IDs
    const allUniqueIngIds = [...new Set([...dishIngredientsMap.values()].flat())]
    const ingredientDetailsMap = new Map<number, Ingredient>()
    if (allUniqueIngIds.length > 0) {
      const { data: ingDetails } = await supabase
        .from('ingredients')
        .select('id, name, category, image_url')
        .in('id', allUniqueIngIds)
      for (const r of ingDetails ?? []) {
        ingredientDetailsMap.set(r.id as number, {
          id: r.id as number,
          name: r.name as string,
          category: r.category as Ingredient['category'],
          image_url: (r.image_url as string) || null,
          show_in_selector: true,
        })
      }
    }

    // Step 5: JS filtering
    const validDishes: (Dish & { _missingIds: number[] })[] = []
    for (const dish of candidateDishes) {
      const dishIngredientIds = dishIngredientsMap.get(dish.id) || []
      const disallowedIngredients = dishIngredientIds.filter(
        (id) => !allAllowedIngredients.includes(id)
      )
      const hasSelectedIngredient = dishIngredientIds.some((id) => ingredientIds.includes(id))
      const acceptDish = allowMissing > 0
        ? disallowedIngredients.length <= allowMissing && hasSelectedIngredient
        : disallowedIngredients.length === 0 && hasSelectedIngredient

      if (acceptDish) {
        const matchCount = dishIngredientIds.filter((id) => ingredientIds.includes(id)).length
        const dishIngredients = dishIngredientIds
          .map((id) => ingredientDetailsMap.get(id))
          .filter(Boolean) as Ingredient[]
        validDishes.push({
          ...dish,
          ingredients: dishIngredients,
          match_count: matchCount,
          _missingIds: disallowedIngredients,
        })
      }
    }

    // Load details for missing ingredients
    const allMissingIds = [...new Set(validDishes.flatMap((d) => d._missingIds))]
    const missingDetailsMap = new Map<number, Ingredient>()
    if (allMissingIds.length > 0) {
      const { data: missingDetails } = await supabase
        .from('ingredients')
        .select('id, name, category, image_url')
        .in('id', allMissingIds)
      for (const r of missingDetails ?? []) {
        missingDetailsMap.set(r.id as number, {
          id: r.id as number,
          name: r.name as string,
          category: r.category as Ingredient['category'],
          image_url: (r.image_url as string) || null,
          show_in_selector: true,
        })
      }
    }

    return validDishes
      .sort((a, b) => {
        if (b.match_count! !== a.match_count!) return b.match_count! - a.match_count!
        if (a._missingIds.length !== b._missingIds.length) return a._missingIds.length - b._missingIds.length
        return a.name.localeCompare(b.name)
      })
      .slice(0, 15)
      .map(({ _missingIds, ...dish }) => {
        const missing = _missingIds.map((id) => missingDetailsMap.get(id)).filter(Boolean) as Ingredient[]
        return { ...dish, missing_ingredients: missing.length > 0 ? missing : undefined }
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
      .select('id, name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, dish_ingredients(ingredient_id)')
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
        .select('id, name, category, image_url')
        .in('id', allIngIds)
      for (const r of ingData ?? []) {
        ingMap.set(r.id as number, {
          id: r.id as number,
          name: r.name as string,
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
      .select('id, name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, dish_ingredients(ingredient_id)')
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
      const { data: ingData } = await supabase.from('ingredients').select('id, name, category, image_url').in('id', allIngIds)
      for (const r of ingData ?? []) {
        ingMap.set(r.id as number, { id: r.id as number, name: r.name as string, category: r.category as Ingredient['category'], image_url: (r.image_url as string) || null, show_in_selector: true })
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
  try {
    let query = supabase
      .from('dishes')
      .select('id, name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan')

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
    return dishes.sort(() => Math.random() - 0.5).slice(0, 20)
  } catch (error) {
    console.error('Error getting dishes by focus:', error)
    return []
  }
}

export async function getQuickDishes(limit = 50): Promise<Dish[]> {
  try {
    const { data, error } = await supabase
      .from('dishes')
      .select('id, name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan')
      .lte('cooking_time', 60)
      .order('cooking_time')
      .limit(limit)
    if (error) throw error
    return (data ?? []).map((row) => rowToDish(row as Record<string, unknown>))
  } catch (error) {
    console.error('Error getting quick dishes:', error)
    return []
  }
}

export async function getDishOfDay(): Promise<Dish | null> {
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
      .select('id, name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan')
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
  try {
    const { data, error } = await supabase
      .from('dishes')
      .select('id, name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, dish_ingredients(ingredient_id, ingredients(id, name, category, image_url))')
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
