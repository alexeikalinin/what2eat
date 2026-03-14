import { Ingredient } from './ingredient'

export type Difficulty = 'easy' | 'medium' | 'hard'
export type CuisineType = 'russian' | 'italian' | 'asian' | 'eastern_european' | 'mediterranean' | 'georgian' | 'mexican' | 'french' | 'other'
export type MealType = 'breakfast' | 'lunch' | 'dinner' | 'snack'

export interface Dish {
  id: number
  name: string
  description: string | null
  image_url: string | null
  cooking_time: number
  difficulty: Difficulty
  servings: number
  estimated_cost: number | null
  is_vegetarian: boolean
  is_vegan: boolean
  cuisine_type?: CuisineType
  meal_type?: MealType
  ingredients?: Ingredient[]
  match_count?: number
  missing_ingredients?: Ingredient[]
}
