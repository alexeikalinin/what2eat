import { Language } from '../i18n'
import { Dish, Ingredient } from '../types'

/** Commonly used Russian recipe variant titles → English */
const RECIPE_TITLE_EN: Record<string, string> = {
  'Классический': 'Classic',
  'Классическая': 'Classic',
  'Вегетарианский': 'Vegetarian',
  'Вегетарианская': 'Vegetarian',
  'Французский омлет': 'French-style',
  'Болтунья (scrambled)': 'Scrambled',
  'Щи кислые': 'Sour cabbage soup',
  'Плов узбекский': 'Uzbek-style',
  'С беконом': 'With bacon',
  'Сливочный': 'Creamy',
  'Сливочная': 'Creamy',
  'Диетический': 'Light',
  'Диетическая': 'Light',
  'Острый': 'Spicy',
  'Острая': 'Spicy',
  'Быстрый': 'Quick',
  'Быстрая': 'Quick',
  'По-деревенски': 'Country-style',
  'Со сметаной': 'With sour cream',
  'С сыром': 'With cheese',
  'С грибами': 'With mushrooms',
  'Грибной': 'Mushroom',
  'Грибная': 'Mushroom',
  'Мясной': 'Meaty',
  'Мясная': 'Meaty',
  'Лёгкий': 'Light',
  'Лёгкая': 'Light',
  'По-домашнему': 'Homestyle',
  'Азиатский': 'Asian',
  'Азиатская': 'Asian',
  'Итальянский': 'Italian',
  'Итальянская': 'Italian',
  'Узбекский': 'Uzbek-style',
  'Узбекская': 'Uzbek-style',
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

/** Translate Russian recipe units to English */
const UNIT_EN: Record<string, string> = {
  'г': 'g',
  'гр': 'g',
  'кг': 'kg',
  'мл': 'ml',
  'л': 'l',
  'шт': 'pcs',
  'шт.': 'pcs',
  'ч.л.': 'tsp',
  'ч. л.': 'tsp',
  'ст.л.': 'tbsp',
  'ст. л.': 'tbsp',
  'стакан': 'cup',
  'стакана': 'cups',
  'стаканов': 'cups',
  'щепотка': 'pinch',
  'щепотки': 'pinch',
  'по вкусу': 'to taste',
  'зубчик': 'clove',
  'зубчика': 'cloves',
  'зубчиков': 'cloves',
  'веточка': 'sprig',
  'веточки': 'sprigs',
  'листик': 'leaf',
  'листа': 'leaves',
  'листьев': 'leaves',
  'ломтик': 'slice',
  'ломтика': 'slices',
  'горсть': 'handful',
}

export function translateUnit(unit: string, lang: Language): string {
  if (lang !== 'en') return unit
  return UNIT_EN[unit.trim()] ?? unit
}
