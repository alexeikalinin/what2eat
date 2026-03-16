import { Language } from '../i18n'
import { Dish, Ingredient } from '../types'

/** Return localised dish name */
export function dishName(dish: Dish, lang: Language): string {
  return (lang === 'en' && dish.name_en) ? dish.name_en : dish.name
}

/** Return localised dish description */
export function dishDesc(dish: Dish, lang: Language): string | null {
  return (lang === 'en' && dish.description_en) ? dish.description_en : dish.description
}

/** Return localised recipe instructions JSON string → parsed steps */
export function recipeInstructions(
  instructionsRu: string,
  instructionsEnRaw: string | null | undefined,
  lang: Language,
): Array<{ step: number; description: string }> {
  const raw = lang === 'en' && instructionsEnRaw ? instructionsEnRaw : instructionsRu
  try {
    return JSON.parse(raw)
  } catch {
    return []
  }
}

/** Return localised recipe title */
export function recipeTitle(titleRu: string | null, titleEn: string | null | undefined, lang: Language): string {
  return (lang === 'en' && titleEn) ? titleEn : (titleRu ?? '')
}

/** Return localised ingredient name */
export function ingredientName(ingredient: Ingredient, lang: Language): string {
  return (lang === 'en' && ingredient.name_en) ? ingredient.name_en : ingredient.name
}
