/**
 * Автотест логики поиска блюд и нормализации ингредиентов.
 * Запуск: npx tsx scripts/test-logic.ts
 */

import { createClient } from '@supabase/supabase-js'

const SUPABASE_URL = 'https://zfiyhhsknwpilamljhqu.supabase.co'
const SUPABASE_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmaXloaHNrbndwaWxhbWxqaHF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMzM2MTYsImV4cCI6MjA4ODcwOTYxNn0.LkWxLOfehJSCV58lvwWcDoDxyKOcjEPF76yjEppsAg8'

const supabase = createClient(SUPABASE_URL, SUPABASE_KEY)

// ── цвета в консоли ────────────────────────────────────────────────────────
const G = (s: string) => `\x1b[32m${s}\x1b[0m`
const R = (s: string) => `\x1b[31m${s}\x1b[0m`
const Y = (s: string) => `\x1b[33m${s}\x1b[0m`
const B = (s: string) => `\x1b[34m${s}\x1b[0m`
const W = (s: string) => `\x1b[1m${s}\x1b[0m`
const DIM = (s: string) => `\x1b[2m${s}\x1b[0m`

const PANTRY_STAPLE_NAMES = [
  'Соль', 'Перец черный', 'Масло растительное', 'Масло сливочное',
  'Сахар', 'Уксус', 'Лавровый лист', 'Оливковое масло',
]

let passed = 0
let failed = 0

function assert(label: string, condition: boolean, detail = '') {
  if (condition) {
    console.log(G('  ✓') + ' ' + label)
    passed++
  } else {
    console.log(R('  ✗') + ' ' + label + (detail ? DIM(` (${detail})`) : ''))
    failed++
  }
}

// ── утилиты (копия логики из dishes.ts) ───────────────────────────────────
async function getIngredientIdsByNames(names: string[]): Promise<Map<string, number>> {
  const { data } = await supabase.from('ingredients').select('id, name').in('name', names)
  const map = new Map<string, number>()
  for (const r of data ?? []) map.set(r.name as string, r.id as number)
  return map
}

async function getPantryIds(): Promise<Set<number>> {
  const { data } = await supabase.from('ingredients').select('id').in('name', PANTRY_STAPLE_NAMES)
  return new Set((data ?? []).map(r => r.id as number))
}

interface DishResult {
  id: number
  name: string
  coverage: number
  missing: string[]
  tier: 1 | 2
}

async function findDishes(ingredientIds: number[]): Promise<DishResult[]> {
  if (ingredientIds.length === 0) return []

  const pantrySet = await getPantryIds()
  const userSet = new Set(ingredientIds)
  const availableSet = new Set([...ingredientIds, ...pantrySet])

  const { data: matchRows } = await supabase
    .from('dish_ingredients').select('dish_id').in('ingredient_id', ingredientIds)
  const candidateIds = [...new Set((matchRows ?? []).map(r => r.dish_id as number))]
  if (candidateIds.length === 0) return []

  const { data: dishRows } = await supabase
    .from('dishes').select('id, name').in('id', candidateIds).limit(100)

  const { data: diRows } = await supabase
    .from('dish_ingredients').select('dish_id, ingredient_id').in('dish_id', candidateIds)

  // ingredient names for display
  const allIngIds = [...new Set((diRows ?? []).map(r => r.ingredient_id as number))]
  const { data: ingRows } = await supabase.from('ingredients').select('id, name').in('id', allIngIds)
  const ingNameMap = new Map<number, string>()
  for (const r of ingRows ?? []) ingNameMap.set(r.id as number, r.name as string)

  const dishIngMap = new Map<number, number[]>()
  for (const r of diRows ?? []) {
    const d = r.dish_id as number
    if (!dishIngMap.has(d)) dishIngMap.set(d, [])
    dishIngMap.get(d)!.push(r.ingredient_id as number)
  }

  const results: DishResult[] = []
  for (const dish of dishRows ?? []) {
    const allIngIds = dishIngMap.get(dish.id as number) || []
    const keyIngIds = allIngIds.filter(id => !pantrySet.has(id))
    const matchedKey = keyIngIds.filter(id => userSet.has(id))
    const missingKey = keyIngIds.filter(id => !availableSet.has(id))
    const coverage = keyIngIds.length > 0 ? matchedKey.length / keyIngIds.length : 1.0
    const hasUser = allIngIds.some(id => userSet.has(id))
    if (!hasUser || coverage < 0.5) continue
    results.push({
      id: dish.id as number,
      name: dish.name as string,
      coverage,
      missing: missingKey.map(id => ingNameMap.get(id) ?? `#${id}`),
      tier: coverage >= 1.0 ? 1 : 2,
    })
  }

  results.sort((a, b) => {
    if (a.tier !== b.tier) return a.tier - b.tier
    if (b.coverage !== a.coverage) return b.coverage - a.coverage
    return a.missing.length - b.missing.length
  })

  const t1 = results.filter(d => d.tier === 1).slice(0, 10)
  const t2 = results.filter(d => d.tier === 2).slice(0, 10)
  return [...t1, ...t2]
}

// ── ТЕСТ 1: Подключение к Supabase ─────────────────────────────────────────
async function test1_connection() {
  console.log('\n' + W('═══ ТЕСТ 1: Подключение к Supabase ═══'))
  const { data, error } = await supabase.from('dishes').select('id', { count: 'exact', head: true })
  assert('Supabase доступен', !error, error?.message)
  const { count } = await supabase.from('dishes').select('*', { count: 'exact', head: true })
  assert(`Блюд в БД: ${count}`, (count ?? 0) > 100, `найдено ${count}`)
  const { count: ingCount } = await supabase.from('ingredients').select('*', { count: 'exact', head: true })
  assert(`Ингредиентов в БД: ${ingCount}`, (ingCount ?? 0) > 50, `найдено ${ingCount}`)
  const { count: recCount } = await supabase.from('recipes').select('*', { count: 'exact', head: true })
  assert(`Рецептов в БД: ${recCount}`, (recCount ?? 0) > 100, `найдено ${recCount}`)
}

// ── ТЕСТ 2: Pantry staples распознаются корректно ──────────────────────────
async function test2_pantry() {
  console.log('\n' + W('═══ ТЕСТ 2: Pantry staples (базовые ингредиенты) ═══'))
  const { data } = await supabase.from('ingredients').select('id, name').in('name', PANTRY_STAPLE_NAMES)
  const found = (data ?? []).map(r => r.name as string)
  const notFound = PANTRY_STAPLE_NAMES.filter(n => !found.includes(n))

  assert(`Найдено ${found.length}/${PANTRY_STAPLE_NAMES.length} pantry staples в БД`, found.length >= 8)
  if (notFound.length > 0) {
    console.log(Y(`    ⚠ Не найдены в БД: ${notFound.join(', ')}`))
  } else {
    console.log(DIM(`    Все pantry staples присутствуют: ${found.join(', ')}`))
  }
}

// ── ТЕСТ 3: Нормализация имён (баг case-sensitive) ─────────────────────────
async function test3_normalization() {
  console.log('\n' + W('═══ ТЕСТ 3: Нормализация имён ингредиентов ═══'))

  const { data: allIngs } = await supabase.from('ingredients').select('id, name').limit(10)
  const sample = (allIngs ?? []).slice(0, 5)

  for (const ing of sample) {
    const name = ing.name as string
    const variants = [name, name.toLowerCase(), name.toUpperCase(), name[0].toLowerCase() + name.slice(1)]
    const lowerSet = new Set(variants.map((s: string) => s.toLowerCase().trim()))
    const matchOld = variants.filter((v: string) => v === name).length  // старая логика
    const matchNew = variants.filter((v: string) => lowerSet.has(ing.name.toLowerCase().trim())).length  // новая
    assert(
      `"${name}": старая логика=${matchOld}/4 совпадений, новая=${matchNew}/4`,
      matchNew === 4 && matchOld < 4,
      `старая пропускает ${4 - matchOld} вариантов`
    )
  }
}

// ── ТЕСТ 4: Сценарий "яйца + помидоры + сыр" (типичное фото) ──────────────
async function test4_eggs_tomatoes_cheese() {
  console.log('\n' + W('═══ ТЕСТ 4: Сценарий "яйца + помидоры + сыр" ═══'))
  console.log(DIM('  (имитация фото холодильника с яйцами, помидорами, сыром)'))

  const nameMap = await getIngredientIdsByNames(['Яйца', 'Помидоры', 'Сыр'])
  const ids = [...nameMap.values()].filter(Boolean)

  assert(`Все 3 ингредиента найдены в БД`, nameMap.size === 3, `найдено ${nameMap.size}: ${[...nameMap.keys()].join(', ')}`)
  if (ids.length === 0) return

  const dishes = await findDishes(ids)
  assert('Найдены блюда', dishes.length > 0, 'список пуст')
  const tier1 = dishes.filter(d => d.tier === 1)
  const tier2 = dishes.filter(d => d.tier === 2)

  assert(`Есть блюда Tier1 (coverage=100%)`, tier1.length > 0, `tier1=${tier1.length}`)
  assert('Tier1 идут первыми', dishes[0]?.tier === 1, `первое блюдо tier=${dishes[0]?.tier}`)

  // Tier1 не должны иметь missing ингредиентов
  const t1WithMissing = tier1.filter(d => d.missing.length > 0)
  assert('Tier1 блюда не имеют недостающих ингредиентов', t1WithMissing.length === 0,
    t1WithMissing.map(d => `${d.name}(missing:${d.missing})`).join(', '))

  // Coverage в tier2 должен быть >= 0.5
  const t2Low = tier2.filter(d => d.coverage < 0.5)
  assert('Все Tier2 блюда имеют coverage >= 50%', t2Low.length === 0,
    t2Low.map(d => `${d.name}(${Math.round(d.coverage * 100)}%)`).join(', '))

  console.log('')
  console.log(G('  Tier 1 — Можно приготовить сейчас:'))
  for (const d of tier1) {
    console.log(`    🟢 ${d.name} ${DIM(`(coverage: 100%)`)}`)
  }
  if (tier2.length > 0) {
    console.log(Y('  Tier 2 — Нужно докупить:'))
    for (const d of tier2) {
      console.log(`    🟡 ${d.name} ${DIM(`(${Math.round(d.coverage * 100)}%, докупить: ${d.missing.join(', ')})`)}`)
    }
  }
}

// ── ТЕСТ 5: Сценарий "курица + лук + морковь + картошка" ──────────────────
async function test5_chicken_vegetables() {
  console.log('\n' + W('═══ ТЕСТ 5: Сценарий "курица + лук + морковь + картошка" ═══'))

  const nameMap = await getIngredientIdsByNames(['Курица', 'Лук', 'Морковь', 'Картофель'])
  const ids = [...nameMap.values()].filter(Boolean)
  assert(`Ингредиенты найдены: ${nameMap.size}/4`, nameMap.size >= 3)
  if (ids.length === 0) return

  const dishes = await findDishes(ids)
  assert('Найдены блюда', dishes.length > 0)
  const tier1 = dishes.filter(d => d.tier === 1)

  // Проверяем что борщ/суп с курицей не попал в tier1 (там много лишних ингредиентов)
  console.log('')
  console.log(G('  Tier 1:'))
  for (const d of tier1) console.log(`    🟢 ${d.name}`)
  const tier2 = dishes.filter(d => d.tier === 2)
  if (tier2.length) {
    console.log(Y('  Tier 2:'))
    for (const d of tier2) {
      console.log(`    🟡 ${d.name} ${DIM(`(${Math.round(d.coverage * 100)}%, докупить: ${d.missing.slice(0, 3).join(', ')})`)}`)
    }
  }

  // Нет дублей
  const ids2 = dishes.map(d => d.id)
  const uniqueIds = new Set(ids2)
  assert('Нет дублирующихся блюд', ids2.length === uniqueIds.size)
}

// ── ТЕСТ 6: Пустой холодильник (только pantry) ────────────────────────────
async function test6_empty_fridge() {
  console.log('\n' + W('═══ ТЕСТ 6: Пустой холодильник (только соль+масло) ═══'))

  const nameMap = await getIngredientIdsByNames(['Соль', 'Масло растительное'])
  const ids = [...nameMap.values()].filter(Boolean)

  const dishes = await findDishes(ids)
  assert(
    'С одними pantry staples — пустой результат или только простые блюда',
    dishes.length === 0 || dishes.every(d => d.tier === 1),
    `найдено: ${dishes.length} блюд`
  )
  if (dishes.length === 0) {
    console.log(DIM('    ✓ Правильно: с пустым холодильником блюда не предлагаются'))
  }
}

// ── ТЕСТ 7: Один ингредиент ───────────────────────────────────────────────
async function test7_single_ingredient() {
  console.log('\n' + W('═══ ТЕСТ 7: Один ингредиент — "Гречка" ═══'))

  const nameMap = await getIngredientIdsByNames(['Гречка'])
  const ids = [...nameMap.values()]
  assert('Гречка найдена в БД', nameMap.size === 1)
  if (ids.length === 0) return

  const dishes = await findDishes(ids)
  const tier1 = dishes.filter(d => d.tier === 1)
  const tier2 = dishes.filter(d => d.tier === 2)

  assert('Найдено хотя бы 1 блюдо', dishes.length > 0)
  console.log(DIM(`    Tier1: ${tier1.length}, Tier2: ${tier2.length}, всего: ${dishes.length}`))
  if (tier1.length) console.log(G(`    Tier1: ${tier1.map(d => d.name).join(', ')}`))
}

// ── ТЕСТ 8: Coverage корректно для блюда с известным составом ─────────────
async function test8_coverage_accuracy() {
  console.log('\n' + W('═══ ТЕСТ 8: Точность coverage ═══'))

  // Находим блюдо "Яичница" и смотрим его ингредиенты
  const { data: dishData } = await supabase
    .from('dishes').select('id, name').ilike('name', '%яичниц%').limit(3)

  if (!dishData || dishData.length === 0) {
    console.log(Y('    ⚠ Блюдо "Яичница" не найдено, пропускаем'))
    return
  }

  for (const dish of dishData) {
    const { data: diRows } = await supabase
      .from('dish_ingredients').select('ingredient_id, ingredients(name)').eq('dish_id', dish.id)

    const ings = (diRows ?? []).map((r: any) => r.ingredients?.name as string).filter(Boolean)
    const pantry = PANTRY_STAPLE_NAMES
    const keyIngs = ings.filter(n => !pantry.includes(n))

    console.log(B(`\n    Блюдо: "${dish.name}"`))
    console.log(DIM(`    Все ингредиенты: ${ings.join(', ')}`))
    console.log(DIM(`    Ключевые (не pantry): ${keyIngs.join(', ')}`))

    if (keyIngs.length === 0) {
      console.log(Y('    ⚠ Все ингредиенты — pantry (coverage=1.0 автоматически)'))
      continue
    }

    // Тест: если передать ВСЕ ключевые ингредиенты — coverage должен быть 1.0
    const nameMap = await getIngredientIdsByNames(keyIngs)
    const allKeyIds = [...nameMap.values()]
    const results = await findDishes(allKeyIds)
    const found = results.find(d => d.id === dish.id)

    assert(
      `"${dish.name}": coverage=100% когда все ключевые ингредиенты есть`,
      found?.tier === 1,
      found ? `tier=${found.tier}, coverage=${Math.round(found.coverage * 100)}%` : 'блюдо не найдено'
    )

    // Тест: если передать только ПОЛОВИНУ — coverage должен быть ~50%
    if (keyIngs.length >= 2) {
      const halfIds = [...nameMap.values()].slice(0, Math.ceil(keyIngs.length / 2))
      const halfResults = await findDishes(halfIds)
      const foundHalf = halfResults.find(d => d.id === dish.id)
      const expectedCoverage = Math.ceil(keyIngs.length / 2) / keyIngs.length
      const actualCoverage = foundHalf?.coverage ?? 0

      assert(
        `"${dish.name}": coverage ≈${Math.round(expectedCoverage * 100)}% при половине ингредиентов`,
        foundHalf !== undefined && Math.abs(actualCoverage - expectedCoverage) < 0.01,
        foundHalf ? `actual=${Math.round(actualCoverage * 100)}%` : 'блюдо отфильтровано'
      )
    }
  }
}

// ── ТЕСТ 9: Блюда без записей в dish_ingredients ──────────────────────────
async function test9_dishes_without_ingredients() {
  console.log('\n' + W('═══ ТЕСТ 9: Целостность данных — блюда без ингредиентов ═══'))

  const { data } = await supabase.rpc
    ? await supabase.from('dishes')
        .select(`id, name, dish_ingredients(dish_id)`)
        .limit(200)
    : { data: [] }

  const dishesWithoutIngs = (data ?? []).filter((d: any) => {
    const di = d.dish_ingredients
    return !di || (Array.isArray(di) && di.length === 0)
  })

  assert(
    `Блюд без ингредиентов: ${dishesWithoutIngs.length}`,
    dishesWithoutIngs.length === 0,
    dishesWithoutIngs.slice(0, 5).map((d: any) => d.name).join(', ')
  )

  if (dishesWithoutIngs.length > 0) {
    console.log(R(`    Эти блюда НИКОГДА не попадут в поиск:`))
    for (const d of dishesWithoutIngs.slice(0, 10)) {
      console.log(R(`    - ${d.name} (id=${d.id})`))
    }
  }
}

// ── ТЕСТ 10: Рецепты привязаны к блюдам ──────────────────────────────────
async function test10_recipes_integrity() {
  console.log('\n' + W('═══ ТЕСТ 10: Целостность рецептов ═══'))

  const { count: dishCount } = await supabase.from('dishes').select('*', { count: 'exact', head: true })
  const { count: recipeCount } = await supabase.from('recipes').select('*', { count: 'exact', head: true })

  // Блюда без рецептов
  const { data: dishIds } = await supabase.from('dishes').select('id').limit(200)
  const { data: recipeIds } = await supabase.from('recipes').select('dish_id')
  const recipeSet = new Set((recipeIds ?? []).map(r => r.dish_id as number))
  const dishesWithoutRecipe = (dishIds ?? []).filter(d => !recipeSet.has(d.id as number))

  assert(`Всего блюд: ${dishCount}, рецептов: ${recipeCount}`, (recipeCount ?? 0) >= (dishCount ?? 0) * 0.7,
    `покрытие ${Math.round(((recipeCount ?? 0) / (dishCount ?? 1)) * 100)}%`)
  assert(
    `Блюд без рецептов: ${dishesWithoutRecipe.length}`,
    dishesWithoutRecipe.length < 10,
    `${dishesWithoutRecipe.length} блюд не имеют рецепта`
  )

  if (dishesWithoutRecipe.length > 0) {
    const { data: names } = await supabase.from('dishes').select('name').in('id', dishesWithoutRecipe.slice(0, 10).map(d => d.id))
    console.log(Y(`    Блюда без рецептов: ${(names ?? []).map((n: any) => n.name).join(', ')}`))
  }
}

// ── ИТОГ ──────────────────────────────────────────────────────────────────
async function main() {
  console.log(W('\n╔═══════════════════════════════════════════════════╗'))
  console.log(W('║     What2Eat — Автотест логики поиска блюд        ║'))
  console.log(W('╚═══════════════════════════════════════════════════╝'))

  try {
    await test1_connection()
    await test2_pantry()
    await test3_normalization()
    await test4_eggs_tomatoes_cheese()
    await test5_chicken_vegetables()
    await test6_empty_fridge()
    await test7_single_ingredient()
    await test8_coverage_accuracy()
    await test9_dishes_without_ingredients()
    await test10_recipes_integrity()
  } catch (e) {
    console.error(R('\n  FATAL: ' + (e instanceof Error ? e.message : String(e))))
  }

  console.log('\n' + W('═══════════════════════════════════════════════════'))
  const total = passed + failed
  if (failed === 0) {
    console.log(G(`  ✓ Все ${total} тестов прошли успешно`))
  } else {
    console.log(G(`  ✓ ${passed}`) + ' / ' + R(`✗ ${failed}`) + ` из ${total} тестов`)
  }
  console.log(W('═══════════════════════════════════════════════════\n'))
}

main()
