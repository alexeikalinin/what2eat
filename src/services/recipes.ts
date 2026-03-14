import { supabase, isSupabaseConfigured } from './supabase'
import { Recipe, RecipeStep, RecipeIngredient } from '../types'

type DishRow = {
  name: string
  cooking_time: number
  difficulty: string
  servings: number
  image_url: string | null
}

async function buildRecipe(recipeData: {
  id: number
  dish_id: number
  title: string
  source_url?: string | null
  instructions: string
  dishes: unknown
}): Promise<Recipe> {
  const dish = recipeData.dishes as DishRow

  let instructions: RecipeStep[] = []
  try {
    instructions = JSON.parse(recipeData.instructions) as RecipeStep[]
  } catch (e) {
    console.error('Error parsing instructions:', e)
  }

  const { data: ingData } = await supabase
    .from('recipe_ingredients')
    .select('ingredient_id, quantity, unit, ingredients!inner(name)')
    .eq('recipe_id', recipeData.id)
    .order('ingredient_id')

  const ingredients: RecipeIngredient[] = (ingData ?? []).map((row) => ({
    ingredient_id: row.ingredient_id as number,
    ingredient_name: ((row.ingredients as unknown) as { name: string }).name,
    quantity: row.quantity as number,
    unit: row.unit as string,
  }))

  return {
    id: recipeData.id,
    dish_id: recipeData.dish_id,
    dish_name: dish.name,
    title: recipeData.title ?? 'Классический',
    source_url: recipeData.source_url ?? null,
    instructions,
    ingredients,
    cooking_time: dish.cooking_time,
    difficulty: dish.difficulty as Recipe['difficulty'],
    servings: dish.servings,
    image_url: dish.image_url || null,
  }
}

/** Возвращает первый (или единственный) рецепт блюда */
export async function getRecipeByDishId(dishId: number): Promise<Recipe | null> {
  if (!isSupabaseConfigured()) return null
  const recipes = await getAllRecipesForDish(dishId)
  return recipes[0] ?? null
}

/** Возвращает ВСЕ варианты рецептов блюда (для показа Рецепт 1 / Рецепт 2 …) */
export async function getAllRecipesForDish(dishId: number): Promise<Recipe[]> {
  if (!isSupabaseConfigured()) return []
  const { data, error } = await supabase
    .from('recipes')
    .select('id, dish_id, title, source_url, instructions, dishes!inner(name, cooking_time, difficulty, servings, image_url)')
    .eq('dish_id', dishId)
    .order('id')

  if (error) {
    console.error('Error fetching recipes:', error)
    return []
  }
  if (!data || data.length === 0) return []

  const results: Recipe[] = []
  for (const row of data) {
    const recipe = await buildRecipe(row as Parameters<typeof buildRecipe>[0])
    results.push(recipe)
  }
  return results
}
