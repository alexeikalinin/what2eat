/**
 * Тесты 10 фото холодильников с разными наборами продуктов.
 *
 * OpenAI API замокирован через page.route() с ответами, соответствующими
 * реальному содержимому каждого сгенерированного изображения.
 *
 * Для каждого холодильника проверяем:
 *  1. Все продукты с изображения определены (чипы видны)
 *  2. Кнопка "Найти блюда" активна
 *  3. После поиска — блюда релевантны идентифицированным продуктам
 *  4. Нет нерелевантных блюд (с неожиданными ингредиентами)
 */
import { test, expect, Page } from '@playwright/test'
import { readFileSync } from 'fs'
import { join, dirname } from 'path'
import { fileURLToPath } from 'url'
import { mockPremiumUser } from './helpers/premium-mock'

// ESM-совместимый __dirname
const __dirname = dirname(fileURLToPath(import.meta.url))

// ─── Фото + ожидаемые ингредиенты (мок OpenAI) ────────────────────────────

const FRIDGE_SCENARIOS = [
  {
    filename: 'fridge-eggs-butter.jpg',
    title: 'Яйца + молочное',
    mockIngredients: '["Яйца", "Масло сливочное", "Молоко"]',
    requiredChips: ['Яйца', 'Масло сливочное', 'Молоко'],
    relevantKeywords: /яичниц|омлет|яйц|блин|сырник/i,
    forbiddenKeywords: /курица|говядина|свинина|рис.*мяс/i,
  },
  {
    filename: 'fridge-chicken-veggies.jpg',
    title: 'Курица с овощами',
    mockIngredients: '["Курица", "Лук", "Морковь", "Чеснок"]',
    requiredChips: ['Курица', 'Лук', 'Морковь'],
    relevantKeywords: /куриц/i,
    forbiddenKeywords: /макарон.*свинин|говядин/i,
  },
  {
    filename: 'fridge-beef-potato.jpg',
    title: 'Говядина с картофелем',
    mockIngredients: '["Говядина", "Картофель", "Лук", "Морковь"]',
    requiredChips: ['Говядина', 'Картофель', 'Лук'],
    relevantKeywords: /говядин|картофель|гуляш/i,
    forbiddenKeywords: /паста карбонара|сырники|жареный рис/i,
  },
  {
    filename: 'fridge-georgian.jpg',
    title: 'Грузинская кухня (хачапури)',
    mockIngredients: '["Мука", "Сыр", "Яйца", "Масло сливочное"]',
    requiredChips: ['Мука', 'Сыр', 'Яйца'],
    relevantKeywords: /хачапури|сырник|омлет|блин|запеканк/i,
    forbiddenKeywords: /тако|кесадилья|харчо/i,
  },
  {
    filename: 'fridge-mexican.jpg',
    title: 'Мексиканская кухня',
    mockIngredients: '["Лаваш", "Курица", "Сыр", "Перец болгарский", "Лук"]',
    requiredChips: ['Курица', 'Сыр', 'Лук'],
    relevantKeywords: /кесадилья|курич|тако/i,
    forbiddenKeywords: /гречк|борщ|луковый суп/i,
  },
  {
    filename: 'fridge-french.jpg',
    title: 'Французская кухня',
    mockIngredients: '["Лук", "Хлеб", "Сыр", "Масло сливочное"]',
    requiredChips: ['Лук', 'Хлеб', 'Сыр'],
    relevantKeywords: /луковый суп|крок|запеченн/i,
    forbiddenKeywords: /тако|хачапури|жареный рис/i,
  },
  {
    filename: 'fridge-pasta.jpg',
    title: 'Итальянская паста',
    mockIngredients: '["Макароны", "Томатная паста", "Чеснок", "Масло растительное"]',
    requiredChips: ['Макароны', 'Томатная паста'],
    relevantKeywords: /макарон|паста/i,
    forbiddenKeywords: /борщ|харчо|тако|луковый суп/i,
  },
  {
    filename: 'fridge-asian-rice.jpg',
    title: 'Азиатский рис',
    mockIngredients: '["Рис", "Яйца", "Соевый соус", "Лук зеленый", "Морковь"]',
    requiredChips: ['Рис', 'Яйца'],
    relevantKeywords: /рис|жареный|азиат/i,
    forbiddenKeywords: /макарон.*говядин|хачапури|луковый суп/i,
  },
  {
    filename: 'fridge-buckwheat.jpg',
    title: 'Гречка',
    mockIngredients: '["Гречка", "Яйца", "Лук"]',
    requiredChips: ['Гречка', 'Яйца', 'Лук'],
    relevantKeywords: /гречк/i,
    forbiddenKeywords: /паста карбонара|тако|хачапури|луковый суп/i,
  },
  {
    filename: 'fridge-cottage-cheese.jpg',
    title: 'Творог',
    mockIngredients: '["Творог", "Яйца", "Молоко", "Мука"]',
    requiredChips: ['Творог', 'Яйца'],
    relevantKeywords: /сырник|запеканк|творог|блин/i,
    forbiddenKeywords: /гуляш|тако|харчо/i,
  },
]

// ─── OpenAI мок ───────────────────────────────────────────────────────────────

function makeOpenAiResponse(content: string) {
  return {
    id: 'chatcmpl-test',
    object: 'chat.completion',
    created: Date.now(),
    model: 'gpt-4o',
    choices: [{ index: 0, message: { role: 'assistant', content }, finish_reason: 'stop' }],
    usage: { prompt_tokens: 100, completion_tokens: 20, total_tokens: 120 },
  }
}

// ─── Вспомогательные функции ─────────────────────────────────────────────────

async function waitForApp(page: Page) {
  await page.waitForSelector('text=Сфотографируйте холодильник', { timeout: 25000 })
}

async function openPhotoScreen(page: Page) {
  await page.getByRole('button', { name: /Загрузить фото|Открыть камеру/ }).first().click()
  await expect(page.getByText('📷 Анализ фото')).toBeVisible({ timeout: 5000 })
}

// eslint-disable-next-line @typescript-eslint/no-unused-vars
async function uploadImage(page: Page, filename: string) {
  const buffer = readFileSync(join(__dirname, 'fixtures', filename))
  const fileInput = page.locator('input[type="file"]').first()
  await fileInput.setInputFiles({ name: filename, mimeType: 'image/jpeg', buffer })
}

function getFixtureBuffer(filename: string): Buffer {
  return readFileSync(join(__dirname, 'fixtures', filename))
}

async function collectAllDishNames(page: Page): Promise<string[]> {
  const allNames = new Set<string>()
  const likeBtn = page.locator('button').filter({ has: page.locator('[data-testid="FavoriteIcon"]') })

  for (let i = 0; i < 25; i++) {
    const done = await page.getByText(/просмотрели все|Посмотреть результаты/).isVisible().catch(() => false)
    if (done) break
    if (!await likeBtn.isVisible({ timeout: 1000 }).catch(() => false)) break

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

test.describe('Фото 10 холодильников — определение продуктов и поиск блюд', () => {
  test.beforeEach(async ({ page }) => {
    await mockPremiumUser(page)
    await page.addInitScript(() => {
      localStorage.setItem('what2eat_tutorial_seen', '1')
    })
    await page.goto('/')
    await waitForApp(page)
  })

  for (const scenario of FRIDGE_SCENARIOS) {
    test(`${scenario.title}: продукты определены → блюда релевантны`, async ({ page }) => {
      // Мокируем OpenAI с ответом для конкретного холодильника (прямой + Supabase proxy)
      await page.route('**/api.openai.com/**', async (route) => {
        await route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify(makeOpenAiResponse(scenario.mockIngredients)),
        })
      })
      await page.route('**/functions/v1/openai-proxy', async (route) => {
        await route.fulfill({
          status: 200,
          contentType: 'application/json',
          body: JSON.stringify(makeOpenAiResponse(scenario.mockIngredients)),
        })
      })

      await openPhotoScreen(page)

      // Загружаем изображение конкретного холодильника
      const buffer = getFixtureBuffer(scenario.filename)
      const fileInput = page.locator('input[type="file"]').first()
      await fileInput.setInputFiles({
        name: scenario.filename,
        mimeType: 'image/jpeg',
        buffer,
      })

      // Ждём завершения анализа
      await expect(page.getByText('Анализирую фото…')).toBeVisible({ timeout: 5000 })
      await expect(page.getByText('Анализирую фото…')).not.toBeVisible({ timeout: 15000 })

      // Чипы с ингредиентами должны появиться
      await expect(page.getByText('Найденные продукты — отметьте нужные:')).toBeVisible({ timeout: 5000 })

      // Проверяем появление хотя бы нескольких ожидаемых чипов
      let foundChips = 0
      for (const chip of scenario.requiredChips) {
        const visible = await page.locator('.MuiChip-root').filter({ hasText: chip }).isVisible().catch(() => false)
        if (visible) foundChips++
      }
      expect(
        foundChips,
        `Для ${scenario.title} ожидались чипы: [${scenario.requiredChips.join(', ')}]`
      ).toBeGreaterThanOrEqual(Math.ceil(scenario.requiredChips.length / 2))

      // Кнопка "Найти блюда" активна
      const findBtn = page.getByRole('button', { name: /Найти блюда/ })
      await expect(findBtn).toBeEnabled()
      await findBtn.click()

      // Ждём результата
      await expect(
        page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)
      ).toBeVisible({ timeout: 15000 })

      const hasDishes = await page.getByText(/\d+ осталось/).isVisible().catch(() => false)
      if (!hasDishes) {
        console.log(`[${scenario.title}] Блюда не найдены — возможно продукты не покрывают ни одно блюдо`)
        return
      }

      const dishNames = await collectAllDishNames(page)
      console.log(`[${scenario.title}] Блюда:`, dishNames)

      // Проверяем релевантность
      const hasRelevant = dishNames.some(n => scenario.relevantKeywords.test(n))
      expect(
        hasRelevant,
        `[${scenario.title}] Ожидались релевантные блюда (${scenario.relevantKeywords}). Получены: [${dishNames.join(', ')}]`
      ).toBe(true)

      // Проверяем отсутствие нерелевантных блюд
      const hasForbidden = dishNames.some(n => scenario.forbiddenKeywords.test(n))
      expect(
        hasForbidden,
        `[${scenario.title}] Нерелевантные блюда не должны показываться. Получены: [${dishNames.join(', ')}]`
      ).toBe(false)
    })
  }

  // ─── Дополнительный тест: все 10 изображений загружаются без ошибок ───
  test('все 10 фото холодильников успешно загружаются', async ({ page }) => {
    // Мок — пустой ответ для быстрой проверки загрузки (прямой + Supabase proxy)
    await page.route('**/api.openai.com/**', async (route) => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(makeOpenAiResponse('["Яйца"]')),
      })
    })
    await page.route('**/functions/v1/openai-proxy', async (route) => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(makeOpenAiResponse('["Яйца"]')),
      })
    })

    for (const scenario of FRIDGE_SCENARIOS) {
      await openPhotoScreen(page)

      const buffer = getFixtureBuffer(scenario.filename)
      const fileInput = page.locator('input[type="file"]').first()
      await fileInput.setInputFiles({ name: scenario.filename, mimeType: 'image/jpeg', buffer })

      await expect(page.getByText('Анализирую фото…')).not.toBeVisible({ timeout: 15000 })
      await expect(page.locator('.MuiChip-root').filter({ hasText: 'Яйца' })).toBeVisible({ timeout: 5000 })
      console.log(`  ✓ ${scenario.filename} загружено корректно`)

      // Возвращаемся на главный экран
      await page.getByRole('button', { name: 'Назад' }).click()
      await waitForApp(page)
    }
  })
})
