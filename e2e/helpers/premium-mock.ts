/**
 * Хелперы для E2E тестов:
 * — mockPremiumUser: имитирует Premium-пользователя через route-мок Supabase
 * — waitForApp: ждёт полной загрузки приложения
 */
import { Page } from '@playwright/test'

const SUPABASE_URL = 'https://zfiyhhsknwpilamljhqu.supabase.co'

const FAKE_USER = {
  id: 'e2e-test-user-id',
  aud: 'authenticated',
  role: 'authenticated',
  email: 'e2e@what2eat.test',
  email_confirmed_at: '2024-01-01T00:00:00.000Z',
  created_at: '2024-01-01T00:00:00.000Z',
  updated_at: '2024-01-01T00:00:00.000Z',
}

/**
 * Мокирует Supabase API для имитации Premium-пользователя.
 * Вызывать до page.goto()!
 */
export async function mockPremiumUser(page: Page) {
  // Supabase JS сначала читает сессию из localStorage (sb-{ref}-auth-token),
  // и только при промахе делает сетевой запрос. Поэтому кладём сессию в
  // localStorage через addInitScript (выполняется до любого JS страницы).
  const fakeSession = {
    access_token: 'fake-e2e-access-token',
    token_type: 'bearer',
    expires_in: 86400,
    expires_at: Math.floor(Date.now() / 1000) + 86400,
    refresh_token: 'fake-e2e-refresh-token',
    user: FAKE_USER,
  }
  await page.addInitScript((session) => {
    localStorage.setItem('sb-zfiyhhsknwpilamljhqu-auth-token', JSON.stringify(session))
  }, fakeSession)

  // Мок auth session endpoint (на случай если всё-таки пойдёт в сеть)
  await page.route(`${SUPABASE_URL}/auth/v1/session`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(fakeSession),
    })
  })

  // Мок token refresh
  await page.route(`${SUPABASE_URL}/auth/v1/token*`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(fakeSession),
    })
  })

  // Мок user_profiles → plan: premium
  await page.route(`${SUPABASE_URL}/rest/v1/user_profiles*`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({ id: FAKE_USER.id, plan: 'premium', created_at: '2024-01-01T00:00:00.000Z' }),
    })
  })

  // Мок usage_counters → нулевое использование
  await page.route(`${SUPABASE_URL}/rest/v1/usage_counters*`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(null),
    })
  })

  // Мок rpc для инкремента (если вызывается в тестах)
  await page.route(`${SUPABASE_URL}/rest/v1/rpc/**`, async (route) => {
    await route.fulfill({ status: 200, contentType: 'application/json', body: 'null' })
  })

  // Мок ingredients — полный список, не зависит от сети
  await page.route(`${SUPABASE_URL}/rest/v1/ingredients*`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(MOCK_INGREDIENTS),
    })
  })
}

// Полный список ингредиентов (снепшот из Supabase, 2026-03-12)
const MOCK_INGREDIENTS = [
  { id: 72, name: 'Авокадо', category: 'vegetables', show_in_selector: false, image_url: null },
  { id: 102, name: 'Арахис', category: 'other', show_in_selector: false, image_url: null },
  { id: 76, name: 'Базилик', category: 'vegetables', show_in_selector: false, image_url: null },
  { id: 17, name: 'Баклажаны', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 116, name: 'Баранина', category: 'meat', show_in_selector: true, image_url: null },
  { id: 23, name: 'Брокколи', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 115, name: 'Вино красное', category: 'other', show_in_selector: true, image_url: null },
  { id: 2, name: 'Говядина', category: 'meat', show_in_selector: true, image_url: null },
  { id: 47, name: 'Горох', category: 'cereals', show_in_selector: false, image_url: null },
  { id: 5, name: 'Гречка', category: 'cereals', show_in_selector: true, image_url: null },
  { id: 39, name: 'Грибы', category: 'vegetables', show_in_selector: false, image_url: null },
  { id: 60, name: 'Индейка', category: 'meat', show_in_selector: false, image_url: null },
  { id: 16, name: 'Кабачки', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 15, name: 'Капуста', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 11, name: 'Картофель', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 1, name: 'Курица', category: 'meat', show_in_selector: true, image_url: null },
  { id: 8, name: 'Лук', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 25, name: 'Лук зеленый', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 4, name: 'Макароны', category: 'cereals', show_in_selector: true, image_url: null },
  { id: 34, name: 'Масло растительное', category: 'other', show_in_selector: true, image_url: null },
  { id: 35, name: 'Масло сливочное', category: 'dairy', show_in_selector: true, image_url: null },
  { id: 28, name: 'Молоко', category: 'dairy', show_in_selector: true, image_url: null },
  { id: 9, name: 'Морковь', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 41, name: 'Мука', category: 'cereals', show_in_selector: false, image_url: null },
  { id: 107, name: 'Нут', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 7, name: 'Овсянка', category: 'cereals', show_in_selector: true, image_url: null },
  { id: 14, name: 'Огурцы', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 12, name: 'Перец болгарский', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 114, name: 'Перец острый', category: 'spices', show_in_selector: true, image_url: null },
  { id: 33, name: 'Перец черный', category: 'spices', show_in_selector: true, image_url: null },
  { id: 21, name: 'Петрушка', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 10, name: 'Помидоры', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 6, name: 'Рис', category: 'cereals', show_in_selector: true, image_url: null },
  { id: 18, name: 'Свекла', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 3, name: 'Свинина', category: 'meat', show_in_selector: true, image_url: null },
  { id: 26, name: 'Сельдерей', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 30, name: 'Сметана', category: 'dairy', show_in_selector: true, image_url: null },
  { id: 42, name: 'Соевый соус', category: 'spices', show_in_selector: false, image_url: null },
  { id: 32, name: 'Соль', category: 'spices', show_in_selector: true, image_url: null },
  { id: 37, name: 'Сосиски', category: 'meat', show_in_selector: true, image_url: null },
  { id: 29, name: 'Сыр', category: 'dairy', show_in_selector: true, image_url: null },
  { id: 38, name: 'Творог', category: 'dairy', show_in_selector: false, image_url: null },
  { id: 43, name: 'Томатная паста', category: 'other', show_in_selector: false, image_url: null },
  { id: 27, name: 'Тыква', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 20, name: 'Укроп', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 36, name: 'Фарш', category: 'meat', show_in_selector: true, image_url: null },
  { id: 24, name: 'Цветная капуста', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 13, name: 'Чеснок', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 22, name: 'Шпинат', category: 'vegetables', show_in_selector: true, image_url: null },
  { id: 31, name: 'Яйца', category: 'dairy', show_in_selector: true, image_url: null },
]

/** Ждёт полной загрузки приложения */
export async function waitForApp(page: Page) {
  await page.waitForSelector('text=Сфотографируйте холодильник', { timeout: 30000 })
}
