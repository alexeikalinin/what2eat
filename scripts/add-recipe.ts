/**
 * Скрипт для добавления рецептов из веба в seed.sql
 *
 * Использование (скажи Claude Code):
 *   "Добавь борщ с сайта povarenok.ru/recipes/show/1234/"
 *   "Добавь 5 итальянских рецептов"
 *
 * Claude Code сам находит рецепты через WebSearch + WebFetch и вызывает parseRecipe().
 *
 * Логика:
 * 1. Загрузить страницу с рецептом
 * 2. Извлечь JSON-LD (@type: "Recipe") или разобрать HTML вручную
 * 3. Нормализовать ингредиенты под известные из seed.sql
 * 4. Сгенерировать SQL-блок и дописать в seed.sql
 */

import * as fs from 'fs'
import * as path from 'path'

const SEED_PATH = path.join(__dirname, '../database/seed.sql')

interface ParsedRecipe {
  name: string
  description: string
  imageUrl: string
  cookingTime: number       // в минутах
  difficulty: 'easy' | 'medium' | 'hard'
  servings: number
  estimatedCost?: number
  isVegetarian: boolean
  isVegan: boolean
  cuisineType: 'russian' | 'italian' | 'asian' | 'eastern_european' | 'other'
  mealType: 'breakfast' | 'lunch' | 'dinner' | 'snack'
  ingredients: Array<{
    name: string       // нормализованное имя из seed.sql
    quantity: number
    unit: string
  }>
  steps: string[]
}

/**
 * Генерирует SQL-блок для нового рецепта.
 * Использует subquery-подход (по имени) — устойчив к изменению ID.
 */
export function generateRecipeSQL(recipe: ParsedRecipe): string {
  const escapeSql = (s: string) => s.replace(/'/g, "''")
  const name = escapeSql(recipe.name)

  const stepsJson = JSON.stringify(
    recipe.steps.map((description, i) => ({ step: i + 1, description }))
  ).replace(/'/g, "''")

  const ingredientNames = recipe.ingredients.map(i => `'${escapeSql(i.name)}'`).join(', ')

  const caseQuantity = recipe.ingredients
    .map(i => `WHEN '${escapeSql(i.name)}' THEN ${i.quantity}`)
    .join(' ')

  const caseUnit = recipe.ingredients
    .map(i => `WHEN '${escapeSql(i.name)}' THEN '${escapeSql(i.unit)}'`)
    .join(' ')

  return `
-- ${recipe.name}
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('${name}', '${escapeSql(recipe.description)}', '${recipe.imageUrl}', ${recipe.cookingTime}, '${recipe.difficulty}', ${recipe.servings}, ${recipe.estimatedCost ?? 'NULL'}, ${recipe.isVegetarian ? 1 : 0}, ${recipe.isVegan ? 1 : 0}, '${recipe.cuisineType}', '${recipe.mealType}');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = '${name}' AND i.name IN (${ingredientNames});

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '${stepsJson}'
FROM dishes d WHERE d.name = '${name}';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name ${caseQuantity} END,
  CASE i.name ${caseUnit} END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = '${name}' AND i.name IN (${ingredientNames});
`.trim()
}

/**
 * Дописывает сгенерированный SQL в seed.sql
 */
export function appendToSeed(sql: string): void {
  fs.appendFileSync(SEED_PATH, '\n\n' + sql + '\n')
  console.log(`✅ Рецепт добавлен в ${SEED_PATH}`)
}

/**
 * Пример использования — Claude Code заполняет эту функцию данными с сайта
 */
function main() {
  const example: ParsedRecipe = {
    name: 'Пример рецепта',
    description: 'Описание блюда',
    imageUrl: 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=520&fit=crop&q=80',
    cookingTime: 30,
    difficulty: 'easy',
    servings: 4,
    estimatedCost: 8,
    isVegetarian: false,
    isVegan: false,
    cuisineType: 'russian',
    mealType: 'dinner',
    ingredients: [
      { name: 'Курица', quantity: 500, unit: 'г' },
      { name: 'Соль', quantity: 1, unit: 'ч.л.' },
    ],
    steps: [
      'Нарезать курицу кусочками',
      'Обжарить на масле до готовности',
    ],
  }

  const sql = generateRecipeSQL(example)
  console.log('Сгенерированный SQL:\n')
  console.log(sql)
  // appendToSeed(sql)  // раскомментировать для записи в файл
}

main()
