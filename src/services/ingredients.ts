import { supabase } from './supabase'
import { Ingredient } from '../types'

export async function getAllIngredients(): Promise<Ingredient[]> {
  const { data, error } = await supabase
    .from('ingredients')
    .select('id, name, category, image_url, show_in_selector')
    .order('category')
    .order('name')

  if (error) {
    console.error('Error fetching ingredients:', error)
    return []
  }

  return (data ?? []).map((row) => ({
    id: row.id as number,
    name: row.name as string,
    category: row.category as Ingredient['category'],
    image_url: (row.image_url as string) || null,
    show_in_selector: Boolean(row.show_in_selector),
  }))
}

export async function getIngredientsByCategory(
  category: Ingredient['category']
): Promise<Ingredient[]> {
  const { data, error } = await supabase
    .from('ingredients')
    .select('id, name, category, image_url, show_in_selector')
    .eq('category', category)
    .order('name')

  if (error) {
    console.error('Error fetching ingredients by category:', error)
    return []
  }

  return (data ?? []).map((row) => ({
    id: row.id as number,
    name: row.name as string,
    category: row.category as Ingredient['category'],
    image_url: (row.image_url as string) || null,
    show_in_selector: Boolean(row.show_in_selector),
  }))
}

export async function searchIngredients(query: string): Promise<Ingredient[]> {
  const { data, error } = await supabase
    .from('ingredients')
    .select('id, name, category, image_url, show_in_selector')
    .ilike('name', `%${query}%`)
    .order('name')

  if (error) {
    console.error('Error searching ingredients:', error)
    return []
  }

  return (data ?? []).map((row) => ({
    id: row.id as number,
    name: row.name as string,
    category: row.category as Ingredient['category'],
    image_url: (row.image_url as string) || null,
    show_in_selector: Boolean(row.show_in_selector),
  }))
}
