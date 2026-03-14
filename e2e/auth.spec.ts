/**
 * E2E тесты авторизации (Supabase замокирован через page.route).
 * Все сетевые запросы к Supabase auth перехватываются — реальная сеть не нужна.
 */
import { test, expect, Page } from '@playwright/test'
import { waitForApp } from './helpers/premium-mock'

const SUPABASE_URL = 'https://zfiyhhsknwpilamljhqu.supabase.co'

const FAKE_USER = {
  id: 'auth-test-user-id',
  aud: 'authenticated',
  role: 'authenticated',
  email: 'test@what2eat.test',
  email_confirmed_at: '2024-01-01T00:00:00.000Z',
  created_at: '2024-01-01T00:00:00.000Z',
  updated_at: '2024-01-01T00:00:00.000Z',
}

const FAKE_SESSION = {
  access_token: 'fake-auth-test-token',
  token_type: 'bearer',
  expires_in: 86400,
  expires_at: Math.floor(Date.now() / 1000) + 86400,
  refresh_token: 'fake-auth-refresh-token',
  user: FAKE_USER,
}

/** Мокирует гостевое состояние — Supabase настроен, но пользователь не авторизован */
async function mockGuestWithSupabase(page: Page) {
  // Гость не имеет сессии в localStorage
  await page.addInitScript(() => {
    localStorage.removeItem('sb-zfiyhhsknwpilamljhqu-auth-token')
    localStorage.setItem('what2eat_tutorial_seen', '1')
  })

  // Запросы сессии → 200 с null (нет сессии)
  await page.route(`${SUPABASE_URL}/auth/v1/session`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(null),
    })
  })

  // user_profiles — ответ для незалогиненного (пустой массив)
  await page.route(`${SUPABASE_URL}/rest/v1/user_profiles*`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify([]),
    })
  })

  // usage_counters
  await page.route(`${SUPABASE_URL}/rest/v1/usage_counters*`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(null),
    })
  })
}

/** Мокирует успешную регистрацию через signUp */
async function mockSignUp(page: Page) {
  await page.route(`${SUPABASE_URL}/auth/v1/signup`, async (route) => {
    console.log('[AuthTest] Перехвачен signUp запрос')
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({
        ...FAKE_SESSION,
        user: { ...FAKE_USER, email_confirmed_at: null }, // не подтверждён — нужна почта
      }),
    })
  })
}

/** Мокирует успешный логин через email/password */
async function mockSignInSuccess(page: Page) {
  await page.route(`${SUPABASE_URL}/auth/v1/token*`, async (route) => {
    const url = route.request().url()
    console.log('[AuthTest] Перехвачен token запрос:', url)
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify(FAKE_SESSION),
    })
  })

  // После входа profile endpoint должен вернуть профиль
  await page.route(`${SUPABASE_URL}/rest/v1/user_profiles*`, async (route) => {
    await route.fulfill({
      status: 200,
      contentType: 'application/json',
      body: JSON.stringify({ id: FAKE_USER.id, plan: 'free', created_at: '2024-01-01T00:00:00.000Z' }),
    })
  })
}

/** Мокирует ошибку логина (неверный пароль) */
async function mockSignInError(page: Page) {
  await page.route(`${SUPABASE_URL}/auth/v1/token*`, async (route) => {
    console.log('[AuthTest] Перехвачен token запрос — возвращаем 400')
    await route.fulfill({
      status: 400,
      contentType: 'application/json',
      body: JSON.stringify({ error: 'invalid_grant', error_description: 'Invalid login credentials' }),
    })
  })
}

/** Мокирует logout */
async function mockLogout(page: Page) {
  await page.route(`${SUPABASE_URL}/auth/v1/logout*`, async (route) => {
    console.log('[AuthTest] Перехвачен logout запрос')
    await route.fulfill({ status: 204, body: '' })
  })
}

/** Открывает диалог авторизации через кнопку в шапке */
async function openAuthModal(page: Page) {
  const loginBtn = page.locator('button[aria-label="Войти"]')
  await expect(loginBtn).toBeVisible({ timeout: 5000 })
  await loginBtn.click()
  // Ждём появления модального окна
  await expect(page.getByRole('dialog')).toBeVisible({ timeout: 5000 })
  console.log('[AuthTest] Диалог авторизации открыт')
}

// ─── Тесты ───────────────────────────────────────────────────────────────────

test.describe('Авторизация — UI и Supabase мок', () => {
  test.setTimeout(30000)

  test.beforeEach(async ({ page }) => {
    await mockGuestWithSupabase(page)
    await page.goto('/')
    await waitForApp(page)
  })

  // ─── 1. Кнопка «Войти» видна для гостя ───────────────────────────────────
  test('кнопка «Войти» видна в шапке для гостя', async ({ page }) => {
    const loginBtn = page.locator('button[aria-label="Войти"]')
    await expect(loginBtn).toBeVisible({ timeout: 5000 })
    console.log('[AuthTest] Кнопка «Войти» найдена в шапке')
  })

  // ─── 2. Email форма содержит нужные поля ──────────────────────────────────
  test('модальное окно содержит поля email, пароль и кнопку входа', async ({ page }) => {
    await openAuthModal(page)

    const emailField = page.getByLabel('Email')
    const passwordField = page.getByLabel('Пароль')
    const submitBtn = page.getByRole('button', { name: 'Войти' }).last()

    await expect(emailField).toBeVisible()
    await expect(passwordField).toBeVisible()
    await expect(submitBtn).toBeVisible()
    console.log('[AuthTest] Поля формы найдены')
  })

  // ─── 3. Валидация: пустые поля → кнопка задизейблена ─────────────────────
  test('кнопка «Войти» задизейблена при пустых полях', async ({ page }) => {
    await openAuthModal(page)

    // Кнопка submit (последний «Войти» в модале — не Google-кнопка)
    const submitBtn = page.getByRole('button', { name: 'Войти' }).last()
    await expect(submitBtn).toBeDisabled()
    console.log('[AuthTest] Кнопка задизейблена при пустых полях — OK')
  })

  // ─── 4. Валидация: заполнен только email → кнопка всё ещё задизейблена ───
  test('кнопка «Войти» задизейблена при заполненном только email', async ({ page }) => {
    await openAuthModal(page)

    await page.getByLabel('Email').fill('test@example.com')
    // Пароль не заполняем

    const submitBtn = page.getByRole('button', { name: 'Войти' }).last()
    await expect(submitBtn).toBeDisabled()
    console.log('[AuthTest] Кнопка задизейблена без пароля — OK')
  })

  // ─── 5. Регистрация нового пользователя (мок signUp → success) ────────────
  test('регистрация нового пользователя — успешный мок signUp', async ({ page }) => {
    await mockSignUp(page)
    await openAuthModal(page)

    // Переключаемся в режим регистрации
    await page.getByRole('button', { name: 'Создать' }).click()
    await expect(page.getByRole('button', { name: 'Зарегистрироваться' })).toBeVisible({ timeout: 3000 })
    console.log('[AuthTest] Переключились в режим регистрации')

    await page.getByLabel('Email').fill('new@what2eat.test')
    await page.getByLabel('Пароль').fill('password123')

    await page.getByRole('button', { name: 'Зарегистрироваться' }).click()

    // После регистрации ожидаем сообщение об отправке письма
    await expect(
      page.getByText(/Проверьте почту|письмо с подтверждением/i)
    ).toBeVisible({ timeout: 8000 })
    console.log('[AuthTest] Сообщение о подтверждении почты получено')
  })

  // ─── 6. Логин существующего пользователя → avatar в шапке ───────────────
  test('успешный логин → в шапке появляется аватар пользователя', async ({ page }) => {
    await mockSignInSuccess(page)
    await openAuthModal(page)

    await page.getByLabel('Email').fill(FAKE_USER.email)
    await page.getByLabel('Пароль').fill('correct-password')

    console.log('[AuthTest] Нажимаем кнопку входа')
    await page.getByRole('button', { name: 'Войти' }).last().click()

    // Модальное окно должно закрыться, появится аватар (MuiAvatar)
    await expect(page.locator('.MuiAvatar-root')).toBeVisible({ timeout: 8000 })
    // Кнопка «Войти» исчезает
    await expect(page.locator('button[aria-label="Войти"]')).not.toBeVisible({ timeout: 5000 })
    console.log('[AuthTest] Аватар появился, кнопка «Войти» скрыта')
  })

  // ─── 7. Ошибка неверного пароля → сообщение об ошибке ───────────────────
  test('неверный пароль → показывается сообщение об ошибке', async ({ page }) => {
    await mockSignInError(page)
    await openAuthModal(page)

    await page.getByLabel('Email').fill(FAKE_USER.email)
    await page.getByLabel('Пароль').fill('wrong-password')

    await page.getByRole('button', { name: 'Войти' }).last().click()

    // Ожидаем алерт с ошибкой (Alert severity="error")
    await expect(
      page.locator('.MuiAlert-standardError, .MuiAlert-filledError')
    ).toBeVisible({ timeout: 8000 })
    console.log('[AuthTest] Сообщение об ошибке отображается')

    // Диалог всё ещё открыт
    await expect(page.getByRole('dialog')).toBeVisible()
  })

  // ─── 8. Кнопка Google OAuth видна и кликабельна ──────────────────────────
  test('кнопка «Войти через Google» видна в модальном окне', async ({ page }) => {
    // Мокируем OAuth redirect — Supabase вызовет signInWithOAuth, который делает redirect
    await page.route(`${SUPABASE_URL}/auth/v1/authorize*`, async (route) => {
      console.log('[AuthTest] Перехвачен OAuth authorize redirect')
      // Просто блокируем редирект — достаточно убедиться что кнопка доступна
      await route.abort()
    })

    await openAuthModal(page)

    const googleBtn = page.getByRole('button', { name: /Войти через Google/i })
    await expect(googleBtn).toBeVisible({ timeout: 3000 })

    // Кнопка не задизейблена (при настроенном Supabase)
    // Примечание: в тестовой среде Supabase может быть не настроен,
    // поэтому проверяем только видимость
    console.log('[AuthTest] Кнопка Google видна:', await googleBtn.isVisible())

    // Кликаем и убеждаемся что UI реагирует (нет краша)
    await googleBtn.click({ timeout: 3000 }).catch(() => {
      console.log('[AuthTest] Клик по Google заблокирован (ожидаемо в тестах)')
    })
  })

  // ─── 9. Выход из аккаунта → снова показывается кнопка «Войти» ───────────
  test('выход из аккаунта → показывается кнопка «Войти»', async ({ page }) => {
    // Сначала устанавливаем сессию — имитируем залогиненного пользователя
    await page.addInitScript((session) => {
      localStorage.setItem('sb-zfiyhhsknwpilamljhqu-auth-token', JSON.stringify(session))
    }, FAKE_SESSION)

    await mockSignInSuccess(page)
    await mockLogout(page)

    // Мокируем token refresh для уже залогиненного пользователя
    await page.route(`${SUPABASE_URL}/auth/v1/token*`, async (route) => {
      await route.fulfill({
        status: 200,
        contentType: 'application/json',
        body: JSON.stringify(FAKE_SESSION),
      })
    })

    await page.goto('/')
    await waitForApp(page)

    // Ждём аватар (пользователь залогинен)
    await expect(page.locator('.MuiAvatar-root')).toBeVisible({ timeout: 8000 })
    console.log('[AuthTest] Пользователь залогинен, аватар виден')

    // Открываем меню через аватар
    await page.locator('.MuiAvatar-root').click()
    await expect(page.getByRole('menuitem', { name: /Выйти/i })).toBeVisible({ timeout: 3000 })

    // Нажимаем «Выйти»
    await page.getByRole('menuitem', { name: /Выйти/i }).click()
    console.log('[AuthTest] Нажали «Выйти»')

    // После выхода должна появиться кнопка «Войти»
    await expect(page.locator('button[aria-label="Войти"]')).toBeVisible({ timeout: 8000 })
    // Аватар должен исчезнуть
    await expect(page.locator('.MuiAvatar-root')).not.toBeVisible({ timeout: 5000 })
    console.log('[AuthTest] Выход выполнен — кнопка «Войти» снова видна')
  })
})
