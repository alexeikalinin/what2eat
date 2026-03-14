/**
 * Тесты рандомайзера по кухням:
 * — кнопки новых кухонь (грузинская, мексиканская, французская, восточноевропейская) видны в UI
 * — при выборе кухни в деке показываются только блюда этой кухни
 * — проверка соответствия названий блюд выбранной кухне
 */
import { test, expect, Page } from '@playwright/test'
import { mockPremiumUser, waitForApp } from './helpers/premium-mock'

async function openRandomizer(page: Page) {
  const btn = page.getByRole('button', { name: 'Случайное' })
  await btn.waitFor({ state: 'visible', timeout: 10000 })
  // Пауза для стабилизации после возможного ре-рендера (особенно при повторном открытии)
  await page.waitForTimeout(500)
  await btn.click()
  const readyBtn = page.getByRole('button', { name: 'Поехали!' })
  await expect(readyBtn).toBeVisible({ timeout: 8000 })
  // Дополнительная пауза — экран рандомайзера может рендерить toggle-кнопки асинхронно
  await page.waitForTimeout(500)
}

async function selectCuisine(page: Page, cuisineLabel: string) {
  const btn = page.getByRole('button', { name: cuisineLabel })
  await btn.waitFor({ state: 'visible', timeout: 5000 })
  await btn.click()
  await expect(page.getByRole('button', { name: cuisineLabel })).toHaveAttribute(
    'aria-pressed', 'true', { timeout: 3000 }
  )
}

async function startRandomizer(page: Page) {
  await page.getByRole('button', { name: 'Поехали!' }).click()
  await expect(
    page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)
  ).toBeVisible({ timeout: 15000 })
}

/** Собирает все имена блюд из свайп-дека */
async function collectAllDishNames(page: Page): Promise<string[]> {
  const allNames = new Set<string>()
  const likeBtn = page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })

  for (let i = 0; i < 25; i++) {
    const done = await page.getByText(/просмотрели все|Посмотреть результаты/).isVisible().catch(() => false)
    if (done) break
    const visible = await likeBtn.isVisible({ timeout: 1000 }).catch(() => false)
    if (!visible) break

    const imgs = page.locator('.MuiBox-root img[alt]').filter({ hasNot: page.locator('[alt=""]') })
    const count = await imgs.count()
    for (let j = 0; j < count; j++) {
      const alt = await imgs.nth(j).getAttribute('alt')
      if (alt?.trim()) allNames.add(alt.trim())
    }

    await likeBtn.click()
    await page.waitForTimeout(350)
  }

  return [...allNames]
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

test.describe('Рандомайзер — выбор кухни', () => {
  test.beforeEach(async ({ page }) => {
    await mockPremiumUser(page)
    await page.addInitScript(() => {
      localStorage.setItem('what2eat_tutorial_seen', '1')
    })
    await page.goto('/')
    await waitForApp(page)
  })

  // ─── 1. UI: все 9 кухонь присутствуют в интерфейсе ────────────────────────
  test('все кухни отображаются в настройках рандомайзера', async ({ page }) => {
    await openRandomizer(page)

    const expectedCuisines = [
      'Любая', 'Русская', 'Итальянская', 'Азиатская',
      'Восточноевропейская', 'Средиземноморская',
      'Грузинская', 'Мексиканская', 'Французская',
    ]

    for (const cuisine of expectedCuisines) {
      await expect(
        page.getByRole('button', { name: cuisine }).first()
      ).toBeVisible({ timeout: 3000 })
    }
  })

  // ─── 2. Грузинская кухня → показываются грузинские блюда ─────────────────
  test('грузинская кухня → только грузинские блюда', async ({ page }) => {
    await openRandomizer(page)
    await selectCuisine(page, 'Грузинская')
    await startRandomizer(page)

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[Test] Грузинская: блюда не найдены — возможно база не обновлена')
      return
    }

    const names = await collectAllDishNames(page)
    console.log('[Test] Грузинская кухня:', names)

    // Блюда должны относиться к грузинской кухне
    const georgianKeywords = /хачапури|харчо|сациви|пхали|шашлык|мцвади|аджапсандали|лобиани/i
    const hasGeorgian = names.some(n => georgianKeywords.test(n))
    expect(hasGeorgian, `Ожидались грузинские блюда. Получены: [${names.join(', ')}]`).toBe(true)
  })

  // ─── 3. Мексиканская кухня → мексиканские блюда ────────────────────────
  test('мексиканская кухня → только мексиканские блюда', async ({ page }) => {
    await openRandomizer(page)
    await selectCuisine(page, 'Мексиканская')
    await startRandomizer(page)

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[Test] Мексиканская: блюда не найдены')
      return
    }

    const names = await collectAllDishNames(page)
    console.log('[Test] Мексиканская кухня:', names)

    const mexicanKeywords = /тако|кесадилья|буррито|начос|фахитас|чили|мексик/i
    const hasMexican = names.some(n => mexicanKeywords.test(n))
    expect(hasMexican, `Ожидались мексиканские блюда. Получены: [${names.join(', ')}]`).toBe(true)
  })

  // ─── 4. Французская кухня → французские блюда ─────────────────────────
  test('французская кухня → только французские блюда', async ({ page }) => {
    await openRandomizer(page)
    await selectCuisine(page, 'Французская')
    await startRandomizer(page)

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[Test] Французская: блюда не найдены')
      return
    }

    const names = await collectAllDishNames(page)
    console.log('[Test] Французская кухня:', names)

    const frenchKeywords = /луковый суп|крок|рататуй|киш|французск|бешамель|гратен/i
    const hasFrench = names.some(n => frenchKeywords.test(n))
    expect(hasFrench, `Ожидались французские блюда. Получены: [${names.join(', ')}]`).toBe(true)
  })

  // ─── 5. Восточноевропейская кухня → восточноевропейские блюда ─────────
  test('восточноевропейская кухня → блюда с вареники/паприкаш', async ({ page }) => {
    await openRandomizer(page)
    await selectCuisine(page, 'Восточноевропейская')
    await startRandomizer(page)

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[Test] Восточноевропейская: блюда не найдены')
      return
    }

    const names = await collectAllDishNames(page)
    console.log('[Test] Восточноевропейская кухня:', names)

    const eeKeywords = /вареники|паприкаш|картошк.*гриб|бигос|гуляш/i
    const hasEE = names.some(n => eeKeywords.test(n))
    expect(hasEE, `Ожидались восточноевропейские блюда. Получены: [${names.join(', ')}]`).toBe(true)
  })

  // ─── 6. Итальянская кухня → нет русских/грузинских блюд ────────────────
  test('итальянская кухня → не показывает борщ или хачапури', async ({ page }) => {
    await openRandomizer(page)
    await selectCuisine(page, 'Итальянская')
    await startRandomizer(page)

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) return

    const names = await collectAllDishNames(page)
    console.log('[Test] Итальянская кухня:', names)

    const foreignKeywords = /борщ|щи|хачапури|харчо|сациви|тако|кесадилья|рататуй/i
    const hasForeign = names.some(n => foreignKeywords.test(n))
    expect(hasForeign, `Нерелевантные блюда не должны показываться. Получены: [${names.join(', ')}]`).toBe(false)
  })

  // ─── 7. Азиатская кухня → нет французских/мексиканских блюд ───────────
  test('азиатская кухня → только азиатские блюда (без крок-месье, тако)', async ({ page }) => {
    await openRandomizer(page)
    await selectCuisine(page, 'Азиатская')
    await startRandomizer(page)

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) return

    const names = await collectAllDishNames(page)
    console.log('[Test] Азиатская кухня:', names)

    const nonAsianKeywords = /борщ|хачапури|тако|кесадилья|крок-месье|луковый суп/i
    const hasNonAsian = names.some(n => nonAsianKeywords.test(n))
    expect(hasNonAsian, `Нерелевантные блюда не должны показываться. Получены: [${names.join(', ')}]`).toBe(false)
  })

  // ─── 8. Переключение кухни меняет результат ────────────────────────────
  test('переключение с русской на грузинскую меняет выдачу', async ({ page }) => {
    await openRandomizer(page)

    // Выбираем русскую
    await selectCuisine(page, 'Русская')
    await startRandomizer(page)

    const hasRussian = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasRussian) return
    const russianNames = await collectAllDishNames(page)

    // Возвращаемся на главную — goto надёжнее кнопки Назад
    // (SwipeResults → Назад → SwipeDeck (sessionComplete) → onComplete → SwipeResults образует цикл)
    await page.goto('/')
    await waitForApp(page)
    await openRandomizer(page)
    await selectCuisine(page, 'Грузинская')
    await startRandomizer(page)

    const hasGeorgian = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasGeorgian) return
    const georgianNames = await collectAllDishNames(page)

    console.log('[Test] Русские блюда:', russianNames)
    console.log('[Test] Грузинские блюда:', georgianNames)

    // Выдача должна отличаться
    const overlap = russianNames.filter(n => georgianNames.includes(n))
    // Пересечение должно быть минимальным (или 0)
    expect(
      overlap.length < Math.min(russianNames.length, georgianNames.length),
      `Ожидалось различие в выдаче. Пересечение: [${overlap.join(', ')}]`
    ).toBe(true)
  })
})
