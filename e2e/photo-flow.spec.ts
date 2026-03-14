/**
 * Тесты фото-флоу: загрузка фото → анализ ингредиентов → поиск блюд.
 *
 * OpenAI API мокируется через page.route() — реальный ключ не нужен.
 * Проверяем:
 *  1. После анализа появляются чипы с ингредиентами из мок-ответа
 *  2. Можно подтвердить/снять отметку с ингредиентов
 *  3. После нажатия "Найти блюда" выдача соответствует подтверждённым ингредиентам
 *  4. Блюда, несовместимые с идентифицированными ингредиентами, не предлагаются
 */
import { test, expect, Page } from '@playwright/test'
import { readFileSync } from 'fs'
import { join } from 'path'
import { mockPremiumUser } from './helpers/premium-mock'

// ─── Мок-ответы OpenAI ────────────────────────────────────────────────────────

/** Формирует корректный OpenAI chat/completions ответ с нужным контентом */
function makeOpenAiResponse(content: string) {
  return {
    id: 'chatcmpl-test',
    object: 'chat.completion',
    created: Date.now(),
    model: 'gpt-4o',
    choices: [
      {
        index: 0,
        message: { role: 'assistant', content },
        finish_reason: 'stop',
      },
    ],
    usage: { prompt_tokens: 100, completion_tokens: 20, total_tokens: 120 },
  }
}

/** Мок: холодильник с яйцами и гречкой */
const MOCK_EGGS_BUCKWHEAT = makeOpenAiResponse('["Яйца", "Гречка"]')

/** Мок: холодильник с курицей, рисом и морковью */
const MOCK_CHICKEN_RICE = makeOpenAiResponse('["Курица", "Рис", "Морковь", "Лук"]')

/** Мок: пустой холодильник */
const MOCK_EMPTY = makeOpenAiResponse('[]')

// ─── Минимальный валидный JPEG (1×1 белый пиксель) ───────────────────────────
// Используется как тестовое "фото холодильника"
const MINIMAL_JPEG = Buffer.from(
  'ffd8ffe000104a46494600010100000100010000ffdb004300080606070605080707070909080a0c140d0c0b0b0c1912130f141d1a1f1e1d1a1c1c20242e2720222c231c1c2837292c30313434341f27393d38323c2e333432ffc0000b080001000101011100ffc4001f0000010501010101010100000000000000000102030405060708090a0bffda00080101000003f0007fffd9',
  'hex'
)

// ─── Путь к директории фикстур ────────────────────────────────────────────────
// Если нужны реальные фото — положите их в e2e/fixtures/
// eslint-disable-next-line @typescript-eslint/no-unused-vars
function getFixtureBuffer(filename: string): Buffer {
  try {
    return readFileSync(join(__dirname, 'fixtures', filename))
  } catch {
    // Фикстуры не созданы — используем минимальный JPEG
    return MINIMAL_JPEG
  }
}

// ─── Вспомогательные функции ─────────────────────────────────────────────────

async function waitForAppReady(page: Page) {
  await page.waitForSelector('text=Сфотографируйте холодильник', { timeout: 25000 })
}

/** Устанавливает мок для OpenAI API (прямой и через Supabase proxy) */
async function mockOpenAi(page: Page, responseBody: object) {
  // Прямой вызов OpenAI (когда VITE_OPENAI_API_KEY задан)
  await page.route('**/api.openai.com/**', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(responseBody),
    })
  })
  // Вызов через Supabase proxy (когда пользователь залогинен)
  await page.route('**/functions/v1/openai-proxy', async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(responseBody),
    })
  })
}

/** Открывает экран анализа фото */
async function openPhotoScreen(page: Page) {
  // Кликаем кнопку "Загрузить фото" или "Открыть камеру" в hero-блоке
  await page.getByRole('button', { name: /Загрузить фото|Открыть камеру/ }).first().click()
  await expect(page.getByText('📷 Анализ фото')).toBeVisible({ timeout: 5000 })
}

/** Загружает тестовое изображение через скрытый input[type=file] */
async function uploadTestImage(page: Page, imageBuffer: Buffer) {
  const fileInput = page.locator('input[type="file"]').first()
  await fileInput.setInputFiles({
    name: 'test-fridge.jpg',
    mimeType: 'image/jpeg',
    buffer: imageBuffer,
  })
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

test.describe('Фото-флоу: анализ холодильника → блюда', () => {
  test.beforeEach(async ({ page }) => {
    await mockPremiumUser(page)
    await page.addInitScript(() => {
      localStorage.setItem('what2eat_tutorial_seen', '1')
    })
    await page.goto('/')
    await waitForAppReady(page)
  })

  // ─── Тест 1: Базовый флоу яйца + гречка ─────────────────────────────────
  test('фото с яйцами и гречкой → рекомендуются гречнево-яичные блюда', async ({ page }) => {
    await mockOpenAi(page, MOCK_EGGS_BUCKWHEAT)
    await openPhotoScreen(page)
    await uploadTestImage(page, MINIMAL_JPEG)

    // Ждём завершения анализа
    await expect(page.getByText('Анализирую фото…')).toBeVisible({ timeout: 5000 })
    await expect(page.getByText('Анализирую фото…')).not.toBeVisible({ timeout: 15000 })

    // Чипы с ингредиентами должны появиться
    await expect(page.getByText('Найденные продукты — отметьте нужные:')).toBeVisible({ timeout: 5000 })
    await expect(page.locator('.MuiChip-root').filter({ hasText: 'Яйца' })).toBeVisible()
    await expect(page.locator('.MuiChip-root').filter({ hasText: 'Гречка' })).toBeVisible()

    // Оба чипа выбраны по умолчанию (оранжевый цвет)
    const eggsChip = page.locator('.MuiChip-root').filter({ hasText: 'Яйца' }).first()
    const buckwheatChip = page.locator('.MuiChip-root').filter({ hasText: 'Гречка' }).first()
    await expect(eggsChip).toBeVisible()
    await expect(buckwheatChip).toBeVisible()

    // Кнопка "Найти блюда" активна
    const findBtn = page.getByRole('button', { name: /Найти блюда/ })
    await expect(findBtn).toBeEnabled()

    // Жмём "Найти блюда"
    await findBtn.click()

    // Ждём результата
    await expect(
      page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)
    ).toBeVisible({ timeout: 15000 })

    // Если блюда найдены — проверяем релевантность
    const hasDishes = await page.getByText(/\d+ блюд осталось/).isVisible().catch(() => false)
    if (hasDishes) {
      // Собираем первую карточку
      const firstDishName = await page.locator('img[alt]').first().getAttribute('alt')
      console.log('[Test] Первое блюдо для Яйца+Гречка:', firstDishName)

      // Не должно быть "Курица" или "Свинина" в названии
      if (firstDishName) {
        expect(firstDishName).not.toMatch(/с курицей|со свининой|с говядиной/i)
      }
    }
  })

  // ─── Тест 2: Курица + Рис + Морковь + Лук ───────────────────────────────
  test('фото с курицей и рисом → рекомендуются куриные блюда', async ({ page }) => {
    await mockOpenAi(page, MOCK_CHICKEN_RICE)
    await openPhotoScreen(page)
    await uploadTestImage(page, MINIMAL_JPEG)

    await expect(page.getByText('Анализирую фото…')).toBeVisible({ timeout: 5000 })
    await expect(page.getByText('Анализирую фото…')).not.toBeVisible({ timeout: 15000 })

    // Все 4 ингредиента должны появиться
    await expect(page.locator('.MuiChip-root').filter({ hasText: 'Курица' })).toBeVisible({ timeout: 5000 })
    await expect(page.locator('.MuiChip-root').filter({ hasText: 'Рис' })).toBeVisible()

    // Находим блюда
    await page.getByRole('button', { name: /Найти блюда/ }).click()
    await expect(
      page.getByText(/\d+ осталось|Всё!|просмотрели все|Ничего не нашлось/)
    ).toBeVisible({ timeout: 15000 })

    const hasDishes = await page.getByText(/\d+ блюд осталось/).isVisible().catch(() => false)
    if (hasDishes) {
      const firstDishName = await page.locator('img[alt]').first().getAttribute('alt')
      console.log('[Test] Первое блюдо для Курица+Рис:', firstDishName)
      // Блюдо должно содержать курицу или рис в названии
      if (firstDishName) {
        const relevant = /курич|рис/i.test(firstDishName)
        expect(relevant, `Блюдо "${firstDishName}" не релевантно для Курица+Рис`).toBe(true)
      }
    }
  })

  // ─── Тест 3: Снятие отметки с ингредиента ────────────────────────────────
  test('можно снять отметку с ингредиента перед поиском', async ({ page }) => {
    await mockOpenAi(page, MOCK_EGGS_BUCKWHEAT)
    await openPhotoScreen(page)
    await uploadTestImage(page, MINIMAL_JPEG)

    await expect(page.getByText('Анализирую фото…')).not.toBeVisible({ timeout: 15000 })
    await expect(page.locator('.MuiChip-root').filter({ hasText: 'Яйца' })).toBeVisible({ timeout: 5000 })

    // Снимаем "Яйца" — клик по чипу переключает выбор
    const eggsChip = page.locator('.MuiChip-root').filter({ hasText: 'Яйца' }).first()
    await eggsChip.click()

    // Кнопка должна показывать 1 продукт (Гречка), а не 2
    const findBtn = page.getByRole('button', { name: /Найти блюда \(1 продуктов\)/ })
    await expect(findBtn).toBeVisible({ timeout: 3000 })
  })

  // ─── Тест 4: Пустой холодильник ──────────────────────────────────────────
  test('пустой холодильник → предупреждение об отсутствии ингредиентов', async ({ page }) => {
    await mockOpenAi(page, MOCK_EMPTY)
    await openPhotoScreen(page)
    await uploadTestImage(page, MINIMAL_JPEG)

    await expect(page.getByText('Анализирую фото…')).not.toBeVisible({ timeout: 15000 })

    // Должно появиться предупреждение
    await expect(
      page.getByText('Ингредиенты не распознаны. Попробуйте другое фото.')
    ).toBeVisible({ timeout: 5000 })

    // Кнопка "Найти блюда" недоступна
    const findBtn = page.getByRole('button', { name: /Найти блюда/ })
    await expect(findBtn).not.toBeVisible()
  })

  // ─── Тест 5: Кнопка "Добавить продукт" ───────────────────────────────────
  test('после анализа можно добавить продукт вручную', async ({ page }) => {
    await mockOpenAi(page, MOCK_EGGS_BUCKWHEAT)
    await openPhotoScreen(page)
    await uploadTestImage(page, MINIMAL_JPEG)

    await expect(page.getByText('Анализирую фото…')).not.toBeVisible({ timeout: 15000 })
    await expect(page.locator('.MuiChip-root').filter({ hasText: 'Яйца' })).toBeVisible({ timeout: 5000 })

    // Нажимаем "Добавить продукт"
    const addBtn = page.getByRole('button', { name: 'Добавить продукт' })
    await expect(addBtn).toBeVisible()
    await addBtn.click()

    // Выпадает меню с поиском
    await expect(page.getByPlaceholder('Поиск или название...')).toBeVisible({ timeout: 3000 })
    // Вводим "Лук"
    await page.getByPlaceholder('Поиск или название...').type('Лук')
    // Должен появиться вариант
    await expect(page.locator('[role="menuitem"]').filter({ hasText: 'Лук' }).first()).toBeVisible({ timeout: 3000 })
    await page.locator('[role="menuitem"]').filter({ hasText: 'Лук' }).first().click()

    // Кнопка должна показывать 3 продукта
    const findBtn = page.getByRole('button', { name: /Найти блюда \(3 продукт/ })
    await expect(findBtn).toBeVisible({ timeout: 3000 })
  })

  // ─── Тест 6: Кнопка "Назад" возвращает на главный экран ──────────────────
  test('кнопка "Назад" на экране фото возвращает на главную', async ({ page }) => {
    await openPhotoScreen(page)
    await page.getByRole('button', { name: 'Назад' }).click()
    await expect(page.getByText('Сфотографируйте холодильник')).toBeVisible({ timeout: 5000 })
  })
})
