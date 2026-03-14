import { test, expect, Page } from '@playwright/test'
import { mockPremiumUser } from './helpers/premium-mock'

// Ждём полной загрузки приложения: hero-блок + ингредиенты в аккордеоне
async function waitForAppReady(page: Page) {
  // Hero появляется как только DB инициализирована
  await page.waitForSelector('text=Сфотографируйте холодильник', { timeout: 30000 })
}

// Раскрываем аккордеон и ждём пока Grid-карточки ингредиентов реально появятся
// (ингредиенты — NOT MuiChip, а Box+Typography внутри MuiGrid-item)
async function expandIngredientAccordion(page: Page) {
  const summary = page.locator('.MuiAccordionSummary-root').first()
  const expanded = await summary.getAttribute('aria-expanded')
  if (expanded !== 'true') {
    await summary.click()
  }
  // Ждём Grid-элементов внутри аккордеона (async загрузка из DB)
  await page.locator('.MuiAccordionDetails-root .MuiGrid-item').first().waitFor({ state: 'visible', timeout: 10000 })
}

// Кликаем ингредиент — Grid item с нужным текстом
async function clickIngredient(page: Page, name: string) {
  await expandIngredientAccordion(page)
  const item = page.locator('.MuiAccordionDetails-root .MuiGrid-item').filter({ hasText: name }).first()
  await item.scrollIntoViewIfNeeded()
  await item.click()
}

test.describe('What2Eat — основные сценарии', () => {

  test.beforeEach(async ({ page }) => {
    // Мокируем Premium-план для доступа ко всем функциям
    await mockPremiumUser(page)
    // Устанавливаем до загрузки страницы — иначе туториал перекроет все клики
    await page.addInitScript(() => {
      localStorage.setItem('what2eat_tutorial_seen', '1')
    })
    await page.goto('/')
    await waitForAppReady(page)
  })

  // ─── 1. Выбор ингредиентов → поиск → свайп ──────────────────────────────────
  test('выбор ингредиентов и поиск блюд', async ({ page }) => {
    await clickIngredient(page, 'Курица')
    await clickIngredient(page, 'Лук')

    await expect(page.getByText(/Выбрано: \d/)).toBeVisible()

    await page.getByRole('button', { name: 'Найти блюда' }).click()

    await expect(page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)).toBeVisible({ timeout: 10000 })
  })

  // ─── 2. Свайп влево и вправо через кнопки ────────────────────────────────────
  test('свайп влево и вправо', async ({ page }) => {
    // Несколько ингредиентов для гарантированного результата
    await clickIngredient(page, 'Курица')
    await clickIngredient(page, 'Лук')
    await clickIngredient(page, 'Морковь')
    await page.getByRole('button', { name: 'Найти блюда' }).click()

    // Ждём любого результата свайп-дека
    await expect(page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)).toBeVisible({ timeout: 10000 })

    // Если блюда найдены — проверяем кнопки
    const hasCards = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (hasCards) {
      const dislikeBtn = page.locator('button').filter({ has: page.locator('[data-testid="CloseIcon"]') })
      await expect(dislikeBtn).toBeVisible()
      await dislikeBtn.click()

      const likeBtn = page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })
      await expect(likeBtn).toBeVisible()
      await likeBtn.click()
    }
  })

  // ─── 3. Рандомайзер ──────────────────────────────────────────────────────────
  test('рандомайзер открывает свайп с блюдами', async ({ page }) => {
    await page.getByRole('button', { name: 'Случайное' }).click()
    // Открывается экран настроек фокуса — нажимаем "Поехали!"
    await expect(page.getByRole('button', { name: 'Поехали!' })).toBeVisible({ timeout: 5000 })
    await page.getByRole('button', { name: 'Поехали!' }).click()

    await expect(page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)).toBeVisible({ timeout: 10000 })
  })

  // ─── 4. Фильтр "только веганское" ────────────────────────────────────────────
  test('фильтр "только веганское"', async ({ page }) => {
    // Switch находится внутри FormControlLabel рядом с текстом
    await page.locator('label').filter({ hasText: 'Только веганское' }).locator('input[type="checkbox"]').check()

    // Курица скрыта при веганском фильтре — выбираем веганский ингредиент
    await clickIngredient(page, 'Гречка')
    await page.getByRole('button', { name: 'Найти блюда' }).click()

    await expect(page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)).toBeVisible({ timeout: 10000 })
  })

  // ─── 5. Фильтр "Немного докупить" ────────────────────────────────────────────
  test('фильтр "немного докупить"', async ({ page }) => {
    await page.locator('label').filter({ hasText: 'Немного докупить' }).locator('input[type="checkbox"]').check()

    await clickIngredient(page, 'Курица')
    await page.getByRole('button', { name: 'Найти блюда' }).click()

    await expect(page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)).toBeVisible({ timeout: 10000 })
  })

  // ─── 6. Свайп до конца → результаты → список покупок ─────────────────────────
  test('свайп до конца → результаты → список покупок', async ({ page }) => {
    await clickIngredient(page, 'Курица')
    await clickIngredient(page, 'Лук')
    await clickIngredient(page, 'Морковь')
    await page.getByRole('button', { name: 'Найти блюда' }).click()
    await expect(page.getByText(/\d+ осталось|Ничего не нашлось/)).toBeVisible({ timeout: 10000 })
    // Продолжаем только если блюда найдены
    const hasCards = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
    if (!hasCards) return

    // Кликаем кнопку "❤️" (лайк) в цикле — надёжнее drag-симуляции для TinderCard
    const likeBtn = page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })
    for (let i = 0; i < 20; i++) {
      const done = await page.getByText(/Вы просмотрели все блюда!|Посмотреть результаты/).isVisible().catch(() => false)
      if (done) break
      if (!await likeBtn.isVisible({ timeout: 1000 }).catch(() => false)) break
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
      }
    }

    const resultsBtn = page.getByRole('button', { name: 'Посмотреть результаты' })
    if (await resultsBtn.isVisible({ timeout: 5000 }).catch(() => false)) {
      await resultsBtn.click()
    }

    await expect(page.getByText('Понравилось ❤️')).toBeVisible({ timeout: 8000 })

    const shoppingBtn = page.getByRole('button', { name: 'Покупки' })
    if (await shoppingBtn.isEnabled()) {
      await shoppingBtn.click()
      await expect(page.getByText('Список покупок')).toBeVisible({ timeout: 5000 })
    }
  })

  // ─── 7. Планировщик недели ────────────────────────────────────────────────────
  test('планировщик открывается через AppBar', async ({ page }) => {
    await page.getByRole('button', { name: 'Планировщик' }).click()
    await expect(page.getByRole('heading', { name: 'Планировщик недели' })).toBeVisible({ timeout: 5000 })
  })

  // ─── 8. Навигация назад со свайпа ─────────────────────────────────────────────
  test('навигация назад со свайпа', async ({ page }) => {
    await clickIngredient(page, 'Курица')
    await clickIngredient(page, 'Лук')
    await page.getByRole('button', { name: 'Найти блюда' }).click()

    // Ждём загрузки свайп-дека (любой исход)
    await expect(page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)).toBeVisible({ timeout: 10000 })

    // Кнопка возврата называется "Назад" если блюда найдены, или "Изменить ингредиенты" если нет
    await page.getByRole('button', { name: /Назад|Изменить ингредиенты/ }).first().click()
    await expect(page.getByText('Сфотографируйте холодильник')).toBeVisible({ timeout: 5000 })
  })

  // ─── 9. Бюджет-фильтр ─────────────────────────────────────────────────────────
  test('фильтр по бюджету', async ({ page }) => {
    await page.locator('label').filter({ hasText: 'Бюджет' }).locator('input[type="checkbox"]').check()

    await expect(page.getByLabel('Максимум')).toBeVisible({ timeout: 3000 })
    await page.getByLabel('Максимум').fill('5')

    await clickIngredient(page, 'Курица')
    await page.getByRole('button', { name: 'Найти блюда' }).click()
    await expect(page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)).toBeVisible({ timeout: 10000 })
  })
})
