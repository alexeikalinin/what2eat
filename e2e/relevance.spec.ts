/**
 * Тесты релевантности блюд — главная логика приложения:
 * выбранные ингредиенты ДОЛЖНЫ соответствовать рекомендованным блюдам.
 *
 * Принцип: если выбраны яйца + гречка → должна быть "Гречка с яичницей",
 * НЕ должно быть "Курица" или "Говядина" в составе рекомендованных.
 */
import { test, expect, Page } from '@playwright/test'
import { mockPremiumUser } from './helpers/premium-mock'

// ─── Вспомогательные функции ─────────────────────────────────────────────────

async function waitForAppReady(page: Page) {
  await page.waitForSelector('text=Сфотографируйте холодильник', { timeout: 30000 })
}

async function expandIngredientAccordion(page: Page) {
  const summary = page.locator('.MuiAccordionSummary-root').first()
  const expanded = await summary.getAttribute('aria-expanded')
  if (expanded !== 'true') {
    await summary.click()
  }
  // Ингредиенты — Grid item (Box+Typography), а НЕ MuiChip
  await page.locator('.MuiAccordionDetails-root .MuiGrid-item').first().waitFor({ state: 'visible', timeout: 10000 })
}

async function selectIngredient(page: Page, name: string) {
  await expandIngredientAccordion(page)
  const item = page.locator('.MuiAccordionDetails-root .MuiGrid-item').filter({ hasText: name }).first()
  await item.scrollIntoViewIfNeeded()
  await item.click()
}

async function findDishes(page: Page) {
  await page.getByRole('button', { name: /Найти блюда/ }).click()
  // Ждём результата свайп-дека (блюда, пусто, или ошибка)
  await expect(
    page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)
  ).toBeVisible({ timeout: 15000 })
}

/**
 * Возвращает список названий блюд, видимых в свайп-деке.
 * SwipeCard рендерит alt текст у img с именем блюда.
 */
async function getVisibleDishNames(page: Page): Promise<string[]> {
  // Ждём карточек (могут быть стэкованы)
  const cards = page.locator('.MuiBox-root img[alt]').filter({
    hasNot: page.locator('[alt=""]'),
  })
  const count = await cards.count()
  const names: string[] = []
  for (let i = 0; i < count; i++) {
    const alt = await cards.nth(i).getAttribute('alt')
    if (alt && alt.trim()) names.push(alt.trim())
  }
  return [...new Set(names)]
}

/**
 * Свайпает все карточки лайком и собирает все названия блюд за сессию.
 * Это единственный надёжный способ увидеть все блюда в деке (TinderCard показывает по 1).
 */
async function collectAllDishNames(page: Page): Promise<string[]> {
  const allNames: Set<string> = new Set()

  // Сначала собираем видимые
  const visibleNames = await getVisibleDishNames(page)
  visibleNames.forEach(n => allNames.add(n))

  // Прокликиваем все карточки
  const likeBtn = page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })

  for (let i = 0; i < 30; i++) {
    const done = await page.getByText(/Все просмотрены|Посмотреть результаты/).isVisible().catch(() => false)
    if (done) break
    const visible = await likeBtn.isVisible({ timeout: 1000 }).catch(() => false)
    if (!visible) break

    // Захватываем имя текущей карточки перед свайпом
    const names = await getVisibleDishNames(page)
    names.forEach(n => allNames.add(n))

    await likeBtn.click()
    // Ждём смены карточки
    await page.waitForTimeout(400)
  }

  return [...allNames]
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

test.describe('Релевантность рекомендаций блюд', () => {
  test.beforeEach(async ({ page }) => {
    await mockPremiumUser(page)
    await page.addInitScript(() => {
      localStorage.setItem('what2eat_tutorial_seen', '1')
    })
    await page.goto('/')
    await waitForAppReady(page)
  })

  // ─── Тест 1: Яйца + Гречка → только яично-гречневые блюда ───────────────
  test('яйца + гречка → рекомендуются только яично-гречневые блюда', async ({ page }) => {
    await selectIngredient(page, 'Яйца')
    await selectIngredient(page, 'Гречка')
    await findDishes(page)

    const hasDishes = await page.getByText(/\d+ блюд осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      // Если блюд нет — это тоже ошибка: яйца+гречка должны давать результат
      const empty = await page.getByText('В базе нет подходящих блюд').isVisible().catch(() => false)
      expect(empty, 'Яйца + Гречка должны давать хотя бы одно блюдо').toBe(false)
      return
    }

    const dishNames = await collectAllDishNames(page)
    console.log('[Test] Блюда для Яйца + Гречка:', dishNames)

    // ДОЛЖНЫ содержать гречневое или яично-гречневое блюдо
    const hasRelevant = dishNames.some(n =>
      /гречк/i.test(n) && (/яичниц|яйц/i.test(n) || /варен/i.test(n))
    )
    expect(hasRelevant, `Ожидалось блюдо с гречкой и яйцами. Получены: [${dishNames.join(', ')}]`).toBe(true)

    // НЕ должны содержать мясные блюда без яиц
    const hasMeatOnly = dishNames.some(n =>
      /с курицей|со свининой|с говядиной|с фаршем/i.test(n) && !/яичниц|яйц/i.test(n)
    )
    expect(hasMeatOnly, `Мясные блюда без яиц не должны рекомендоваться. Получены: [${dishNames.join(', ')}]`).toBe(false)
  })

  // ─── Тест 2: Курица + Рис → рисово-куриные блюда ────────────────────────
  test('курица + рис → рекомендуются рисово-куриные блюда', async ({ page }) => {
    await selectIngredient(page, 'Курица')
    await selectIngredient(page, 'Рис')
    await findDishes(page)

    const hasDishes = await page.getByText(/\d+ блюд осталось/).isVisible().catch(() => false)
    if (!hasDishes) return

    const dishNames = await collectAllDishNames(page)
    console.log('[Test] Блюда для Курица + Рис:', dishNames)

    // ДОЛЖНЫ быть блюда с рисом и курицей
    const hasRelevant = dishNames.some(n => /рис/i.test(n) && /курич|курицей/i.test(n))
    expect(hasRelevant, `Ожидалось блюдо с рисом и курицей. Получены: [${dishNames.join(', ')}]`).toBe(true)

    // НЕ должны быть блюда со свининой или говядиной (их нет в выборе)
    const hasPork = dishNames.some(n => /свинин/i.test(n))
    const hasBeef = dishNames.some(n => /говядин/i.test(n))
    expect(hasPork, `Свинина не должна рекомендоваться. Получены: [${dishNames.join(', ')}]`).toBe(false)
    expect(hasBeef, `Говядина не должна рекомендоваться. Получены: [${dishNames.join(', ')}]`).toBe(false)
  })

  // ─── Тест 3: Только Макароны → макаронные блюда ───────────────────────────
  test('только макароны → рекомендуются макаронные блюда', async ({ page }) => {
    await selectIngredient(page, 'Макароны')
    await findDishes(page)

    const hasDishes = await page.getByText(/\d+ блюд осталось/).isVisible().catch(() => false)
    if (!hasDishes) return

    const dishNames = await collectAllDishNames(page)
    console.log('[Test] Блюда для Макароны:', dishNames)

    // ВСЕ блюда должны быть макаронными
    const nonPasta = dishNames.filter(n => !/макарон/i.test(n))
    expect(nonPasta.length, `Немакаронные блюда не должны появляться. Нерелевантные: [${nonPasta.join(', ')}]`).toBe(0)
  })

  // ─── Тест 4: Макароны + Сыр → "Макароны с сыром" обязательно ─────────────
  test('макароны + сыр → "Макароны с сыром" в выдаче', async ({ page }) => {
    await selectIngredient(page, 'Макароны')
    await selectIngredient(page, 'Сыр')
    await findDishes(page)

    const hasDishes = await page.getByText(/\d+ блюд осталось/).isVisible().catch(() => false)
    if (!hasDishes) return

    const dishNames = await collectAllDishNames(page)
    console.log('[Test] Блюда для Макароны + Сыр:', dishNames)

    const hasCheeseAndPasta = dishNames.some(n => /макарон.*сыр|сыр.*макарон/i.test(n))
    expect(hasCheeseAndPasta, `"Макароны с сыром" должны быть в выдаче. Получены: [${dishNames.join(', ')}]`).toBe(true)
  })

  // ─── Тест 5: Просмотр рецепта найденного блюда ───────────────────────────
  test('можно открыть рецепт блюда из результатов поиска', async ({ page }) => {
    await selectIngredient(page, 'Курица')
    await selectIngredient(page, 'Лук')
    await findDishes(page)

    const hasDishes = await page.getByText(/\d+ блюд осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[Test] Блюда не найдены — тест пропущен')
      return
    }

    // Кликаем кнопку "info" или на саму карточку для просмотра рецепта
    const infoBtn = page.locator('button').filter({ has: page.locator('[data-testid="InfoOutlinedIcon"]') }).first()
    if (await infoBtn.isVisible({ timeout: 2000 }).catch(() => false)) {
      await infoBtn.click()
    } else {
      // Альтернатива — клик по карточке напрямую
      const card = page.locator('.MuiBox-root img[alt]').first()
      await card.click()
    }

    // Рецепт должен содержать заголовок и шаги
    await expect(page.getByText(/Рецепт|шаг|Шаг/i)).toBeVisible({ timeout: 8000 })
  })

  // ─── Тест 6: Сосиски + Картофель ─────────────────────────────────────────
  test('сосиски + картофель → блюда с сосисками и/или картофелем', async ({ page }) => {
    await selectIngredient(page, 'Сосиски')
    await selectIngredient(page, 'Картофель')
    await findDishes(page)

    const hasDishes = await page.getByText(/\d+ блюд осталось/).isVisible().catch(() => false)
    if (!hasDishes) return

    const dishNames = await collectAllDishNames(page)
    console.log('[Test] Блюда для Сосиски + Картофель:', dishNames)

    // Все блюда должны содержать сосиски или картофель (но не курицу без оснований)
    const hasUnrelated = dishNames.some(n =>
      /с курицей|с говядиной|со свининой/i.test(n) && !/картофель|сосиск/i.test(n)
    )
    expect(hasUnrelated, `Нерелевантные блюда не должны появляться. Получены: [${dishNames.join(', ')}]`).toBe(false)
  })
})
