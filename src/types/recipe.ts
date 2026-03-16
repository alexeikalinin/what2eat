import { Difficulty } from './dish'

export interface RecipeStep {
  step: number
  description: string
}

export interface RecipeIngredient {
  ingredient_id: number
  ingredient_name: string
  ingredient_name_en?: string | null
  quantity: number
  unit: string
}

export interface Recipe {
  id: number
  dish_id: number
  dish_name: string
  dish_name_en?: string | null
  title: string
  title_en?: string | null
  source_url?: string | null
  instructions: RecipeStep[]
  instructions_en?: string | null
  ingredients: RecipeIngredient[]
  cooking_time: number
  difficulty: Difficulty
  servings: number
  image_url: string | null
}

