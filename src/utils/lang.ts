import { Language } from '../i18n'
import { Dish, Ingredient } from '../types'

/** Commonly used Russian recipe variant titles → English */
const RECIPE_TITLE_EN: Record<string, string> = {
  'Классический': 'Classic',
  'Вегетарианский': 'Vegetarian',
  'Французский омлет': 'French-style',
  'Болтунья (scrambled)': 'Scrambled',
  'Щи кислые': 'Sour cabbage soup',
  'Плов узбекский': 'Uzbek-style',
  'С беконом': 'With bacon',
  'Сливочный': 'Creamy',
  'Диетический': 'Light',
  'Острый': 'Spicy',
  'Быстрый': 'Quick',
  'По-деревенски': 'Country-style',
  'Со сметаной': 'With sour cream',
  'С сыром': 'With cheese',
  'С грибами': 'With mushrooms',
  'Грибной': 'Mushroom',
  'Мясной': 'Meaty',
  'Лёгкий': 'Light',
  'По-домашнему': 'Homestyle',
  'Азиатский': 'Asian',
  'Итальянский': 'Italian',
}

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
  if (lang === 'en') {
    return titleEn ?? (titleRu ? (RECIPE_TITLE_EN[titleRu] ?? titleRu) : '')
  }
  return titleRu ?? ''
}

/** Return localised difficulty label */
// eslint-disable-next-line @typescript-eslint/no-explicit-any
export function difficultyLabel(difficulty: string, t: (key: any) => string): string {
  if (difficulty === 'easy') return t('difficulty_easy')
  if (difficulty === 'medium') return t('difficulty_medium')
  if (difficulty === 'hard') return t('difficulty_hard')
  return difficulty
}

/** Return localised ingredient name */
export function ingredientName(ingredient: Ingredient, lang: Language): string {
  return (lang === 'en' && ingredient.name_en) ? ingredient.name_en : ingredient.name
}
