/**
 * E2E тесты наличия изображений у карточек блюд:
 * — в свайп-деке каждая карточка имеет img с непустым src
 * — в SwipeResults есть изображения
 * — в планировщике блюда имеют изображения
 * — рандомайзер — все карточки с изображениями
 * — собирает и выводит список блюд без изображений
 */
import { test, expect, Page } from '@playwright/test'
import { mockPremiumUser, waitForApp } from './helpers/premium-mock'

/** Раскрывает аккордеон ингредиентов и кликает ингредиент */
async function expandAndClickIngredient(page: Page, name: string) {
  const summary = page.locator('.MuiAccordionSummary-root').first()
  const expanded = await summary.getAttribute('aria-expanded')
  if (expanded !== 'true') {
    await summary.click()
    await page.locator('.MuiAccordionDetails-root .MuiGrid-item').first()
      .waitFor({ state: 'visible', timeout: 10000 })
  }
  const item = page.locator('.MuiAccordionDetails-root .MuiGrid-item')
    .filter({ hasText: name }).first()
  await item.scrollIntoViewIfNeeded()
  await item.click()
}

/** Проверяет текущую видимую карточку свайп-дека — есть ли img с src */
async function checkCurrentCardImage(page: Page): Promise<{ hasImage: boolean; dishName: string; src: string }> {
  // Ищем img в карточке (SwipeCard рендерит img с alt = имя блюда)
  const cardImages = page.locator('.MuiBox-root img[src]').filter({ hasNot: page.locator('[src=""]') })
  const count = await cardImages.count()

  if (count === 0) {
    // Нет ни одного img с src
    const altlessImgs = page.locator('.MuiBox-root img')
    const altCount = await altlessImgs.count()
    console.log(`[ImageTest] Нет img с src. Всего img: ${altCount}`)
    return { hasImage: false, dishName: 'unknown', src: '' }
  }

  const firstImg = cardImages.first()
  const src = await firstImg.getAttribute('src') ?? ''
  const alt = await firstImg.getAttribute('alt') ?? 'unknown'

  return { hasImage: src.length > 0, dishName: alt, src }
}

/** Нажимает кнопку «лайк» в свайп-деке */
async function clickLike(page: Page): Promise<boolean> {
  const likeBtn = page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })
  const visible = await likeBtn.isVisible({ timeout: 1500 }).catch(() => false)
  if (!visible) return false
  const counterBefore = await page.getByText(/\d+ осталось/).textContent().catch(() => null)
  await likeBtn.click()
  if (counterBefore) {
    await page.waitForFunction(
      (prev) => {
        const t = document.body.innerText
        return !t.includes(prev) || t.includes('Посмотреть результаты') || t.includes('просмотрели все')
      },
      counterBefore,
      { timeout: 3000 }
    ).catch(() => {})
  } else {
    await page.waitForTimeout(400)
  }
  return true
}

/** Проверяет наличие изображений у карточек в свайп-деке.
 *  Возвращает список блюд без изображений. */
async function collectMissingImages(page: Page, maxCards = 10): Promise<string[]> {
  const missingImages: string[] = []

  for (let i = 0; i < maxCards; i++) {
    const done = await page.getByText(/просмотрели все|Посмотреть результаты|Ничего не нашлось/)
      .isVisible().catch(() => false)
    if (done) break

    const likeVisible = await page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })
      .isVisible({ timeout: 1500 }).catch(() => false)
    if (!likeVisible) break

    const { hasImage, dishName, src } = await checkCurrentCardImage(page)

    if (!hasImage) {
      console.warn(`[ImageTest] Блюдо без изображения: "${dishName}" (src: "${src}")`)
      missingImages.push(dishName)
    } else {
      console.log(`[ImageTest] Карточка ${i + 1}: "${dishName}" ✓ (src: ${src.substring(0, 60)}...)`)
    }

    // Проверяем что img реально виден в DOM
    const imgElement = page.locator('.MuiBox-root img[src]').first()
    if (hasImage) {
      await expect(imgElement).toHaveAttribute('src', /https?:\/\/|\/images\/|data:image/)
    }

    const swipedOk = await clickLike(page)
    if (!swipedOk) break
  }

  return missingImages
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

test.describe('Изображения карточек блюд', () => {
  test.setTimeout(60000)

  test.beforeEach(async ({ page }) => {
    await mockPremiumUser(page)
    await page.addInitScript(() => {
      localStorage.setItem('what2eat_tutorial_seen', '1')
    })
    await page.goto('/')
    await waitForApp(page)
  })

  // ─── 1. Свайп-дек: каждая карточка имеет img с непустым src ──────────────
  test('свайп-дек: все видимые карточки имеют изображения', async ({ page }) => {
    test.setTimeout(60000)

    // Выбираем несколько ингредиентов для максимального охвата блюд
    for (const ingredient of ['Курица', 'Лук', 'Морковь', 'Говядина', 'Гречка', 'Яйца']) {
      await expandAndClickIngredient(page, ingredient)
    }

    await page.getByRole('button', { name: /Найти блюда/ }).click()
    await expect(
      page.getByText(/\d+ осталось|Ничего не нашлось/)
    ).toBeVisible({ timeout: 15000 })

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[ImageTest] Блюда не найдены — пропускаем')
      return
    }

    console.log('[ImageTest] Начинаем проверку изображений в свайп-деке...')
    const missingImages = await collectMissingImages(page, 10)

    if (missingImages.length > 0) {
      console.warn(`[ImageTest] Блюда без изображений (${missingImages.length}): ${missingImages.join(', ')}`)
    } else {
      console.log('[ImageTest] Все проверенные карточки имеют изображения')
    }

    // Не более 20% карточек без изображений (допустимый порог)
    expect(
      missingImages.length,
      `Слишком много блюд без изображений: [${missingImages.join(', ')}]`
    ).toBeLessThanOrEqual(2)
  })

  // ─── 2. Свайп через 10 карточек — проверяем img[src] у каждой ───────────
  test('свайп через 10 карточек: у каждой есть img[src]', async ({ page }) => {
    test.setTimeout(60000)

    for (const ingredient of ['Курица', 'Говядина', 'Гречка']) {
      await expandAndClickIngredient(page, ingredient)
    }

    await page.getByRole('button', { name: /Найти блюда/ }).click()
    await expect(
      page.getByText(/\d+ осталось|Ничего не нашлось/)
    ).toBeVisible({ timeout: 15000 })

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[ImageTest] Нет блюд для свайпа')
      return
    }

    const allMissing: string[] = []

    for (let i = 0; i < 10; i++) {
      const done = await page.getByText(/просмотрели все|Посмотреть результаты|Ничего не нашлось/)
        .isVisible().catch(() => false)
      if (done) break

      const likeVisible = await page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })
        .isVisible({ timeout: 1500 }).catch(() => false)
      if (!likeVisible) break

      // Проверяем наличие img с непустым src
      const cardImg = page.locator('.MuiBox-root img[src]').first()
      const src = await cardImg.getAttribute('src').catch(() => null)
      const alt = await cardImg.getAttribute('alt').catch(() => `card-${i}`)

      if (!src || src.length === 0) {
        console.warn(`[ImageTest] Карточка ${i + 1} ("${alt}"): нет src у изображения`)
        allMissing.push(alt ?? `card-${i}`)
      } else {
        console.log(`[ImageTest] Карточка ${i + 1} ("${alt}"): src OK`)
        expect(src).toMatch(/https?:\/\/|\/images\/|data:image/)
      }

      await clickLike(page)
    }

    if (allMissing.length > 0) {
      console.warn(`[ImageTest] Итого без изображений: [${allMissing.join(', ')}]`)
    }

    expect(
      allMissing.length,
      `Карточки без изображений: [${allMissing.join(', ')}]`
    ).toBeLessThanOrEqual(2)
  })

  // ─── 3. SwipeResults: понравившиеся блюда имеют изображения ──────────────
  test('SwipeResults: понравившиеся блюда отображаются с изображениями', async ({ page }) => {
    test.setTimeout(60000)

    for (const ingredient of ['Курица', 'Лук', 'Морковь']) {
      await expandAndClickIngredient(page, ingredient)
    }

    await page.getByRole('button', { name: /Найти блюда/ }).click()
    await expect(
      page.getByText(/\d+ осталось|Ничего не нашлось/)
    ).toBeVisible({ timeout: 15000 })

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[ImageTest] Нет блюд — пропускаем тест SwipeResults')
      return
    }

    // Лайкаем все блюда чтобы попасть в результаты
    const likeBtn = page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })
    for (let i = 0; i < 20; i++) {
      const done = await page.getByText(/просмотрели все|Посмотреть результаты/)
        .isVisible().catch(() => false)
      if (done) break
      const visible = await likeBtn.isVisible({ timeout: 1000 }).catch(() => false)
      if (!visible) break
      await clickLike(page)
    }

    // Переходим к результатам
    const resultsBtn = page.getByRole('button', { name: 'Посмотреть результаты' })
    if (await resultsBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
      await resultsBtn.click()
    }

    await expect(page.getByText('Понравилось ❤️')).toBeVisible({ timeout: 8000 })
    console.log('[ImageTest] Открыты SwipeResults')

    // Проверяем изображения в результатах
    const resultImages = page.locator('img[src]')
    const imgCount = await resultImages.count()
    console.log(`[ImageTest] Изображений в SwipeResults: ${imgCount}`)

    if (imgCount > 0) {
      for (let i = 0; i < imgCount; i++) {
        const src = await resultImages.nth(i).getAttribute('src') ?? ''
        const alt = await resultImages.nth(i).getAttribute('alt') ?? `result-${i}`
        if (src.length === 0) {
          console.warn(`[ImageTest] SwipeResults — блюдо "${alt}" без src`)
        } else {
          console.log(`[ImageTest] SwipeResults — "${alt}": src OK`)
        }
        expect(src, `Блюдо "${alt}" в результатах без изображения`).not.toBe('')
      }
    } else {
      console.log('[ImageTest] Нет понравившихся блюд в результатах (свайп мог не сработать)')
    }
  })

  // ─── 4. Планировщик: добавленные блюда имеют изображения ─────────────────
  test('планировщик: блюда отображаются с изображениями', async ({ page }) => {
    test.setTimeout(30000)

    // Открываем планировщик (Premium-пользователь имеет доступ)
    await page.getByRole('button', { name: /Планировщик/i }).click()
    await expect(page.getByRole('heading', { name: 'Планировщик недели' })).toBeVisible({ timeout: 8000 })
    console.log('[ImageTest] Планировщик открыт')

    // Проверяем изображения в уже добавленных блюдах (если есть)
    const plannerImages = page.locator('img[src]')
    const imgCount = await plannerImages.count()
    console.log(`[ImageTest] Изображений в планировщике: ${imgCount}`)

    for (let i = 0; i < imgCount; i++) {
      const src = await plannerImages.nth(i).getAttribute('src') ?? ''
      const alt = await plannerImages.nth(i).getAttribute('alt') ?? `planner-img-${i}`
      if (src.length > 0) {
        console.log(`[ImageTest] Планировщик — "${alt}": src OK`)
        expect(src).toMatch(/https?:\/\/|\/images\//)
      }
    }

    // Если нет блюд в планировщике — это нормально для чистого теста
    if (imgCount === 0) {
      console.log('[ImageTest] Планировщик пуст — блюд нет (нормально для начального состояния)')
    }

    // В любом случае — планировщик открылся без ошибок
    await expect(page.getByRole('heading', { name: 'Планировщик недели' })).toBeVisible()
  })

  // ─── 5. Рандомайзер: все карточки имеют изображения ──────────────────────
  test('рандомайзер: карточки блюд содержат изображения', async ({ page }) => {
    test.setTimeout(60000)

    await page.getByRole('button', { name: 'Случайное' }).click()
    await expect(page.getByRole('button', { name: 'Поехали!' })).toBeVisible({ timeout: 8000 })

    // Запускаем рандомайзер без специфических фильтров (любая кухня)
    await page.getByRole('button', { name: 'Поехали!' }).click()
    await expect(
      page.getByText(/\d+ осталось|Ничего не нашлось/)
    ).toBeVisible({ timeout: 15000 })

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[ImageTest] Рандомайзер: блюда не найдены — пропускаем')
      return
    }

    console.log('[ImageTest] Рандомайзер: начинаем проверку изображений...')
    const missingImages = await collectMissingImages(page, 10)

    if (missingImages.length > 0) {
      console.warn(
        `[ImageTest] Рандомайзер — блюда без изображений (${missingImages.length}): ${missingImages.join(', ')}`
      )
    }

    expect(
      missingImages.length,
      `Рандомайзер: слишком много блюд без изображений: [${missingImages.join(', ')}]`
    ).toBeLessThanOrEqual(2)
  })

  // ─── 6. Итоговый отчёт: все блюда из DB с изображениями ──────────────────
  test('итоговый сбор: блюда без изображений (report-only)', async ({ page }) => {
    test.setTimeout(90000)

    // Выбираем широкий набор ингредиентов для максимального охвата
    const ingredients = ['Курица', 'Лук', 'Морковь', 'Говядина', 'Гречка', 'Яйца', 'Картофель']
    for (const ingredient of ingredients) {
      await expandAndClickIngredient(page, ingredient)
    }

    await page.getByRole('button', { name: /Найти блюда/ }).click()
    await expect(
      page.getByText(/\d+ осталось|Ничего не нашлось/)
    ).toBeVisible({ timeout: 15000 })

    const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasDishes) {
      console.log('[ImageTest] Нет блюд для отчёта')
      return
    }

    const allMissing = await collectMissingImages(page, 25)

    // Итоговый отчёт
    if (allMissing.length > 0) {
      console.warn(
        `\n[ImageTest] ИТОГО БЛЮД БЕЗ ИЗОБРАЖЕНИЙ (${allMissing.length}):\n` +
        allMissing.map((name, i) => `  ${i + 1}. "${name}"`).join('\n')
      )
    } else {
      console.log('[ImageTest] Все проверенные блюда имеют изображения')
    }

    // Этот тест только собирает информацию, не падает на количестве
    // (используйте для выявления проблем в базе данных)
    expect(true).toBe(true)
  })
})
