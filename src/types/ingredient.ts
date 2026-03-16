export type IngredientCategory =
  | 'meat'
  | 'cereals'
  | 'vegetables'
  | 'dairy'
  | 'spices'
  | 'other'

export interface Ingredient {
  id: number
  name: string
  name_en?: string | null
  category: IngredientCategory
  image_url: string | null
  show_in_selector: boolean
}

