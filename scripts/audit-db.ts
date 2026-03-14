#!/usr/bin/env tsx
/**
 * DB Audit Script — проверяет целостность данных базы данных What2Eat
 * Запуск: npx tsx scripts/audit-db.ts
 *
 * Проверки:
 *  1. Каждое блюдо имеет ≥1 ингредиент в dish_ingredients
 *  2. Каждое блюдо имеет рецепт в recipes
 *  3. Все ingredient_id в dish_ingredients существуют в ingredients
 *  4. Все ingredient_id в recipe_ingredients существуют в ingredients
 *  5. Все рецепты имеют валидный JSON в instructions
 *  6. Семантика: название блюда соответствует его ингредиентам
 *  7. Нет блюд без cooking_time или difficulty
 */
import initSqlJs from 'sql.js'
import { readFileSync } from 'fs'
import { fileURLToPath } from 'url'
import { dirname, join } from 'path'

const __filename = fileURLToPath(import.meta.url)
const __dirname = dirname(__filename)
const root = join(__dirname, '..')

// ─── Цвета вывода ────────────────────────────────────────────────────────────
const R = '\x1b[31m'
const G = '\x1b[32m'
const Y = '\x1b[33m'
const B = '\x1b[34m'
const RST = '\x1b[0m'

let errors = 0
let warnings = 0

function pass(msg: string) {
  console.log(`${G}  ✓${RST} ${msg}`)
}
function fail(msg: string) {
  console.log(`${R}  ✗ ОШИБКА:${RST} ${msg}`)
  errors++
}
function warn(msg: string) {
  console.log(`${Y}  ⚠ ПРЕДУПРЕЖДЕНИЕ:${RST} ${msg}`)
  warnings++
}
function section(msg: string) {
  console.log(`\n${B}▶ ${msg}${RST}`)
}

// ─── Инициализация БД ────────────────────────────────────────────────────────
async function setupDb() {
  const SQL = await initSqlJs()
  const db = new SQL.Database()

  const schemaPath = join(root, 'database/schema.sql')
  const seedPath = join(root, 'database/seed.sql')

  const schema = readFileSync(schemaPath, 'utf8')
  const seed = readFileSync(seedPath, 'utf8')

  // Схема: побитово, чтобы игнорировать duplicate column / already exists
  for (const stmt of schema.split(';')) {
    const s = stmt.trim()
    if (!s) continue
    try {
      db.run(s)
    } catch (e) {
      const msg = (e as { message?: string }).message ?? ''
      if (
        !msg.includes('already exists') &&
        !msg.includes('duplicate column name')
      ) {
        console.warn('Schema warning:', s.substring(0, 60), msg)
      }
    }
  }

  // Seed целиком (содержит ; внутри JSON-строк)
  db.run(seed)

  return db
}

// ─── Хелперы запросов ────────────────────────────────────────────────────────
function queryAll<T extends Record<string, unknown>>(
  db: ReturnType<Awaited<ReturnType<typeof initSqlJs>>['Database']['prototype']['constructor']['prototype']['constructor']>,
  sql: string,
  params: unknown[] = []
): T[] {
  // sql.js не имеет строгой типизации — используем any
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const stmt = (db as any).prepare(sql)
  if (params.length) stmt.bind(params)
  const rows: T[] = []
  while (stmt.step()) {
    rows.push(stmt.getAsObject() as T)
  }
  stmt.free()
  return rows
}

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function queryOne<T extends Record<string, unknown>>(db: any, sql: string, params: unknown[] = []): T | null {
  const rows = queryAll<T>(db, sql, params)
  return rows[0] ?? null
}

// ─── Семантические правила: keyword в названии → ожидаемый ингредиент ────────
const SEMANTIC_RULES: Array<{ pattern: RegExp; ingredient: string }> = [
  { pattern: /курич|курицей|с курицей/i, ingredient: 'Курица' },
  { pattern: /говяд|говядиной/i, ingredient: 'Говядина' },
  { pattern: /свинин|свининой/i, ingredient: 'Свинина' },
  { pattern: /фарш/i, ingredient: 'Фарш' },
  { pattern: /сосиск/i, ingredient: 'Сосиски' },
  { pattern: /яичниц|яйцами|яиц/i, ingredient: 'Яйца' },
  { pattern: /гречк/i, ingredient: 'Гречка' },
  { pattern: /^рис\b|с рисом|рис с/i, ingredient: 'Рис' },
  { pattern: /макарон/i, ingredient: 'Макароны' },
  { pattern: /картофель|картофел/i, ingredient: 'Картофель' },
  { pattern: /с сыром|сырный/i, ingredient: 'Сыр' },
  { pattern: /с молоком|на молоке/i, ingredient: 'Молоко' },
  { pattern: /с овсянк|овсяная/i, ingredient: 'Овсянка' },
]

// ─── Основная функция аудита ─────────────────────────────────────────────────
async function runAudit() {
  console.log(`${B}═══════════════════════════════════════════`)
  console.log('  What2Eat — Аудит базы данных')
  console.log(`═══════════════════════════════════════════${RST}`)

  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const db: any = await setupDb()

  // ─── 0. Общая статистика ──────────────────────────────────────────────────
  section('Статистика')
  const stats = ['dishes', 'ingredients', 'recipes', 'dish_ingredients', 'recipe_ingredients']
  for (const table of stats) {
    const row = queryOne<{ cnt: number }>(db, `SELECT COUNT(*) as cnt FROM ${table}`)
    console.log(`  ${table}: ${row?.cnt ?? 0}`)
  }

  // ─── 1. Каждое блюдо имеет ≥1 ингредиент ────────────────────────────────
  section('Проверка 1: Блюда без ингредиентов в dish_ingredients')
  const dishesNoIngredients = queryAll<{ id: number; name: string }>(db, `
    SELECT d.id, d.name FROM dishes d
    WHERE d.id NOT IN (SELECT DISTINCT dish_id FROM dish_ingredients)
    ORDER BY d.id
  `)
  if (dishesNoIngredients.length === 0) {
    pass('Все блюда имеют ≥1 ингредиент')
  } else {
    for (const d of dishesNoIngredients) {
      fail(`Блюдо id=${d.id} "${d.name}" не имеет ни одного ингредиента в dish_ingredients`)
    }
  }

  // ─── 2. Каждое блюдо имеет рецепт ────────────────────────────────────────
  section('Проверка 2: Блюда без рецептов')
  const dishesNoRecipe = queryAll<{ id: number; name: string }>(db, `
    SELECT d.id, d.name FROM dishes d
    WHERE d.id NOT IN (SELECT dish_id FROM recipes)
    ORDER BY d.id
  `)
  if (dishesNoRecipe.length === 0) {
    pass('Все блюда имеют рецепт')
  } else {
    for (const d of dishesNoRecipe) {
      warn(`Блюдо id=${d.id} "${d.name}" не имеет рецепта`)
    }
  }

  // ─── 3. Нет оборванных ingredient_id в dish_ingredients ──────────────────
  section('Проверка 3: Оборванные ingredient_id в dish_ingredients')
  const orphanDishIngredients = queryAll<{ dish_id: number; ingredient_id: number }>(db, `
    SELECT di.dish_id, di.ingredient_id
    FROM dish_ingredients di
    WHERE di.ingredient_id NOT IN (SELECT id FROM ingredients)
  `)
  if (orphanDishIngredients.length === 0) {
    pass('Все ingredient_id в dish_ingredients существуют')
  } else {
    for (const r of orphanDishIngredients) {
      fail(`dish_id=${r.dish_id} ссылается на несуществующий ingredient_id=${r.ingredient_id}`)
    }
  }

  // ─── 4. Нет оборванных ingredient_id в recipe_ingredients ────────────────
  section('Проверка 4: Оборванные ingredient_id в recipe_ingredients')
  const orphanRecipeIngredients = queryAll<{ recipe_id: number; ingredient_id: number }>(db, `
    SELECT ri.recipe_id, ri.ingredient_id
    FROM recipe_ingredients ri
    WHERE ri.ingredient_id NOT IN (SELECT id FROM ingredients)
  `)
  if (orphanRecipeIngredients.length === 0) {
    pass('Все ingredient_id в recipe_ingredients существуют')
  } else {
    for (const r of orphanRecipeIngredients) {
      fail(`recipe_id=${r.recipe_id} ссылается на несуществующий ingredient_id=${r.ingredient_id}`)
    }
  }

  // ─── 5. Валидный JSON в instructions ─────────────────────────────────────
  section('Проверка 5: Валидность JSON в recipes.instructions')
  const allRecipes = queryAll<{ id: number; dish_id: number; instructions: string }>(db, `
    SELECT r.id, r.dish_id, r.instructions FROM recipes r
  `)
  let jsonOk = 0
  for (const rec of allRecipes) {
    try {
      const parsed = JSON.parse(rec.instructions)
      if (!Array.isArray(parsed)) {
        fail(`recipe id=${rec.id} (dish_id=${rec.dish_id}): instructions не является массивом`)
      } else if (parsed.length === 0) {
        warn(`recipe id=${rec.id} (dish_id=${rec.dish_id}): instructions — пустой массив`)
      } else {
        jsonOk++
      }
    } catch {
      fail(`recipe id=${rec.id} (dish_id=${rec.dish_id}): некорректный JSON в instructions`)
    }
  }
  if (jsonOk > 0) pass(`${jsonOk} рецептов с валидным JSON`)

  // ─── 6. Обязательные поля блюд ───────────────────────────────────────────
  section('Проверка 6: Обязательные поля блюд')
  const badFields = queryAll<{ id: number; name: string }>(db, `
    SELECT id, name FROM dishes
    WHERE cooking_time IS NULL OR cooking_time <= 0
       OR difficulty IS NULL OR difficulty = ''
       OR servings IS NULL OR servings <= 0
  `)
  if (badFields.length === 0) {
    pass('Все блюда имеют корректные cooking_time, difficulty, servings')
  } else {
    for (const d of badFields) {
      fail(`Блюдо id=${d.id} "${d.name}" имеет пустые обязательные поля`)
    }
  }

  // ─── 7. Семантическая проверка ────────────────────────────────────────────
  section('Проверка 7: Соответствие названия блюда его ингредиентам')
  const allDishes = queryAll<{ id: number; name: string }>(db, 'SELECT id, name FROM dishes ORDER BY id')
  let semanticOk = 0
  let semanticSkipped = 0

  for (const dish of allDishes) {
    const matchedRules = SEMANTIC_RULES.filter(r => r.pattern.test(dish.name))
    if (matchedRules.length === 0) {
      semanticSkipped++
      continue
    }

    // Получаем все имена ингредиентов блюда
    const dishIngredients = queryAll<{ name: string }>(db, `
      SELECT i.name FROM ingredients i
      JOIN dish_ingredients di ON i.id = di.ingredient_id
      WHERE di.dish_id = ?
    `, [dish.id])
    const ingNames = dishIngredients.map(i => i.name)

    for (const rule of matchedRules) {
      if (!ingNames.includes(rule.ingredient)) {
        fail(
          `Блюдо id=${dish.id} "${dish.name}": по названию ожидается ингредиент "${rule.ingredient}", ` +
          `но его нет в dish_ingredients. Фактические ингредиенты: [${ingNames.join(', ')}]`
        )
      } else {
        semanticOk++
      }
    }
  }
  if (semanticOk > 0) pass(`${semanticOk} семантических соответствий проверено`)
  if (semanticSkipped > 0) console.log(`  (${semanticSkipped} блюд пропущено — нет правил для их названий)`)

  // ─── 8. Проверка recipe_ingredients vs dish_ingredients ──────────────────
  section('Проверка 8: Совпадение ингредиентов recipe_ingredients и dish_ingredients')
  const recipes = queryAll<{ id: number; dish_id: number }>(db, 'SELECT id, dish_id FROM recipes')
  let riMismatch = 0
  for (const recipe of recipes) {
    const riIds = queryAll<{ ingredient_id: number }>(db,
      'SELECT ingredient_id FROM recipe_ingredients WHERE recipe_id = ?',
      [recipe.id]
    ).map(r => r.ingredient_id)

    if (riIds.length === 0) continue // recipe_ingredients не заполнены — это нормально для старых блюд

    const diIds = queryAll<{ ingredient_id: number }>(db,
      'SELECT ingredient_id FROM dish_ingredients WHERE dish_id = ?',
      [recipe.dish_id]
    ).map(r => r.ingredient_id)

    const notInDI = riIds.filter(id => !diIds.includes(id))
    if (notInDI.length > 0) {
      const ingNames = notInDI.map(id => {
        const ing = queryOne<{ name: string }>(db, 'SELECT name FROM ingredients WHERE id = ?', [id])
        return ing ? ing.name : `id=${id}`
      })
      warn(
        `recipe id=${recipe.id} (dish_id=${recipe.dish_id}): ` +
        `ингредиенты из recipe_ingredients отсутствуют в dish_ingredients: [${ingNames.join(', ')}]`
      )
      riMismatch++
    }
  }
  if (riMismatch === 0) pass('recipe_ingredients и dish_ingredients согласованы')

  // ─── Итог ─────────────────────────────────────────────────────────────────
  console.log(`\n${B}═══════════════════════════════════════════${RST}`)
  if (errors === 0 && warnings === 0) {
    console.log(`${G}  ✓ Аудит пройден без ошибок и предупреждений!${RST}`)
  } else {
    if (errors > 0) console.log(`${R}  ✗ Ошибок: ${errors}${RST}`)
    if (warnings > 0) console.log(`${Y}  ⚠ Предупреждений: ${warnings}${RST}`)
  }
  console.log(`${B}═══════════════════════════════════════════${RST}\n`)

  db.close()
  process.exit(errors > 0 ? 1 : 0)
}

runAudit().catch(err => {
  console.error('Fatal error:', err)
  process.exit(1)
})
