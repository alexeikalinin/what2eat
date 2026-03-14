# Прогресс сессии / Handoff (Claude Code ↔ Cursor)

Файл для синхронизации контекста при переключении между Claude Code и Cursor. Обновляется автоматически в конце каждой сессии.

---

## Последнее обновление

- **Дата:** 2026-03-14
- **Среда:** Claude Code

---

## Сессия 2026-03-14 (Claude Code) — аудит инфраструктуры

### Что проверено и сделано
- **Аудит миграций через REST API:** все 9 миграций (001–009) подтверждены в базе: 131 блюдо, 149 рецептов, 18 блюд с 2+ вариантами, колонки `cuisine_type`/`meal_type`/`title`/`source_url` присутствуют.
- **Edge Functions:** все 3 задеплоены и отвечают корректно (`openai-proxy` 401, `create-checkout` 401, `stripe-webhook` 400 без подписи).
- **Google OAuth:** `/auth/v1/authorize?provider=google` вернул 302 — провайдер включён.
- **`src/services/supabase.ts`:** убраны debug `console.log` (два `console.log('[Supabase]...')`).
- **Локальный сервер:** запущен на `http://localhost:3002` (3000 и 3001 заняты другим проектом).
- **Vercel:** деплой по адресу `https://what2eat-ruby.vercel.app`, конфиг в `vercel.json`.

### Нерешённые вопросы этой сессии
- **Edge Function secrets** (`OPENAI_API_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`) — без PAT проверить программно нельзя. Нужно вручную проверить: Supabase Dashboard → Edge Functions → Manage Secrets.
- **Vercel env vars** — убедиться что `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, `VITE_STRIPE_PUBLISHABLE_KEY`, `VITE_STRIPE_PRICE_ID` заданы для Production **и что был сделан Redeploy** после добавления.
- **Supabase Redirect URLs** — добавить `http://localhost:3002` (или `http://localhost:*`) для локального теста OAuth.

---

## Лог предыдущих правок (Cursor 2026-03-14)

Ниже — все правки, сделанные в Cursor 2026-03-14, без изменения функционала (только дизайн, фиксы auth/env, UX).

### Auth и Supabase
- **`src/services/supabase.ts`:** приведение URL и anon key к строкам (`String().trim()`), строка `"undefined"` считается пустым ключом; PKCE для OAuth; кастомный `sanitizedFetch` (нормализация заголовков и URL); опции auth (flowType: 'pkce', storageKey, persistSession и т.д.).
- **`src/patch-headers.ts`:** новый файл — патч `Headers.prototype.set` (приведение имени/значения к строке) до инициализации Supabase, обход "Invalid value" в браузерах/расширениях.
- **`src/main.tsx`:** первая строка — `import './patch-headers'`, чтобы патч выполнялся до загрузки остального кода.
- **`src/store/slices/userSlice.ts`:** в `loginWithGoogle` — явный `redirectTo` от `window.location.origin`, комментарий про Redirect URLs в Supabase.
- **`src/services/ingredients.ts`, `dishes.ts`, `recipes.ts`:** в начале функций добавлена проверка `isSupabaseConfigured()` с ранним возвратом (пустой массив/null), чтобы не слать запросы при отсутствующем ключе.
- **`src/App.tsx`:** импорт `isSupabaseConfigured`; баннер-предупреждение при не настроенном Supabase (подсказка про .env и Vercel).
- **`.env.example`:** уточнены комментарии (скопировать в .env, откуда брать URL и ключ).
- **`docs/PROGRESS.md`:** обновлены блоки про env, Redirect URLs, 401, следующие шаги.

### Свайпы (дизайн по образцу TashaD16/what2eat)
- **`src/components/SwipeDeck/SwipeDeck.tsx`:** импорт `AnimatePresence`; варианты `btnContainerVariants` и `btnItemVariant` для анимации кнопок (stagger + spring); колода обёрнута в `AnimatePresence`, каждая карта в `motion.div` с initial/animate (opacity, scale); два слоя подсветки за колодой (радиальный градиент + пульсация `swipeGlowPulse`); кнопки 68×68 с полупрозрачным фоном и свечением (красный/зелёный); бейдж «осталось» — полупрозрачный фон, обводка, текст в стиле «Осталось: N».
- **`src/components/SwipeDeck/SwipeCard.tsx`:** состояние `imgLoaded`; скелетон загрузки изображения (`Skeleton`), плавное появление фото (opacity 0.4s); оверлеи COOK/SKIP с обводкой, тенью, `backdropFilter: blur(6px)`.

### Рецепты и карточки блюд (дизайн по образцу TashaD16, палитра проекта)
- **`src/components/RecipeView/RecipeView.tsx`:** двухколоночный layout (Grid): левая колонка — ингредиенты в `Paper` (оранжевый оттенок, бордер, тень, List/ListItem); правая — шаги приготовления в `Paper` (оранжевый оттенок, разделители между шагами); чипы времени/порций/сложности перенесены в левый блок; импорт `List`, `ListItem`.
- **`src/components/DishList/DishCard.tsx`:** у карточки заданы borderRadius 3, бордер и тень в оранжевых тонах; высота изображения 200px; чипы времени/порций — variant outlined с оранжевым бордером; кнопка «Посмотреть рецепт» — тень и скругление.

### Прочее
- **`src/components/AuthModal/AuthModal.tsx`:** под кнопкой Google добавлена подсказка: «Не видите свои аккаунты? Откройте сайт в браузере (Safari или Chrome), а не во встроенном окне мессенджера.»

---

## Что сделано в последней сессии (ранее)

- **Миграция на Supabase:** sql.js полностью убран, все данные в PostgreSQL (Supabase). `src/services/database.ts` — заглушка.
- **Freemium архитектура:** guest/free/premium планы, лимиты свайпов и AI фото, `src/store/slices/userSlice.ts`, `src/hooks/usePlan.ts`
- **Auth:** Google OAuth через Supabase (`src/components/AuthModal/`)
- **Stripe подписки:** checkout, webhook, `src/components/PaywallModal/`, Edge Functions
- **RandomizerFocus:** фильтр по кухне/типу/времени/сложности (`src/components/RandomizerFocus/`)
- **Supabase Edge Functions:** `openai-proxy`, `create-checkout`, `stripe-webhook`
- **Multiple recipe variants:** одно блюдо → N рецептов (recipes.dish_id не UNIQUE), переключатель в RecipeView
- **Деплой на Vercel:** `https://what2eat-ruby.vercel.app`
- **Настройка OAuth:** Supabase Site URL + Redirect URLs, Google Cloud Console redirect URIs и JS origins
- **Google provider в Supabase:** включён, добавлены Client ID и Client Secret
- **GRANT доступа к таблицам:** выдан SELECT для anon/authenticated ролей
- **Фикс OAuth/ingredients (Cursor):** ошибки `fetch Invalid value` и `Headers: Invalid value` — в `src/services/supabase.ts` URL и anon key приводятся к строкам (`String().trim()`), включён PKCE для OAuth (`flowType: 'pkce'`), явные auth-опции. OAuth redirectTo в userSlice с комментарием про Redirect URLs в Supabase.

---

## Текущее состояние проекта

- **Репозиторий:** https://github.com/alexeikalinin/what2eat
- **Продакшн:** https://what2eat-ruby.vercel.app
- **Ветка:** main
- **Стек:** React 18, TypeScript, Vite, Redux Toolkit, MUI v5, Supabase (PostgreSQL), Stripe
- **DB:** Supabase project `zfiyhhsknwpilamljhqu` — 131 блюдо, 149 рецептов
- **Env (Vercel):** обязательно задать для **Production** (и при необходимости Preview): `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, `VITE_STRIPE_PUBLISHABLE_KEY`, `VITE_STRIPE_PRICE_ID`. Vite подставляет их **на этапе сборки** — без них в билде окажется строка `undefined` и запросы дадут 401 / Invalid API key.
- **Stripe:** тестовый режим (`pk_test_`)

---

## Известные проблемы / в процессе

- **401 / Invalid API key undefined:** если в Vercel не заданы `VITE_SUPABASE_URL` и `VITE_SUPABASE_ANON_KEY` при сборке, в коде подставляется строка `"undefined"`. В коде добавлена обработка (считаем ключ отсутствующим, запросы не уходят). **Решение:** в Vercel → Project → Settings → Environment Variables добавить для Production (и включить "Expose to Build") переменные `VITE_SUPABASE_URL` и `VITE_SUPABASE_ANON_KEY`, затем сделать **Redeploy** (новый билд с правильными значениями).
- В Supabase Dashboard → Authentication → URL Configuration в **Redirect URLs** должны быть и продакшн, и локальные адреса, например: `https://what2eat-ruby.vercel.app`, `http://localhost:3000`, `http://localhost:3001`. Иначе после входа через Google редирект уйдёт только на первый из списка (часто прод).

---

## Supabase миграции (все применены в SQL Editor)

| Файл | Содержимое |
|------|-----------|
| 001_user_profiles.sql | Таблица user_profiles |
| 002_usage_counters.sql | Счётчики использования |
| 003_recipe_database.sql | Схема БД + RLS политики |
| 004_recipe_seed.sql | ~115 блюд |
| 005_more_recipes.sql | 30+ блюд (грузинские, итальянские, азиатские…) |
| 006_local_only_dishes.sql | 18 быстрых блюд (яичница, каши…) |
| 007_multi_recipe_variants.sql | Убран UNIQUE(dish_id), добавлены title/source_url |
| 008_recipe_variants.sql | 18 вторых вариантов рецептов |
| 009_fix_duplicate_images.sql | Уникальные фото для ~35 блюд |
| ALL_run_in_sql_editor.sql | Всё вместе (idempotent) |

---

## Следующие шаги

1. **Проверить Edge Function secrets** вручную: Supabase Dashboard → Edge Functions → Manage Secrets (`OPENAI_API_KEY`, `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `STRIPE_PRICE_ID`)
2. **Добавить Redirect URL** для локала в Supabase: Auth → URL Configuration → `http://localhost:3002` (или `http://localhost:*`)
3. **Проверить Google OAuth локально** на `http://localhost:3002` — кнопка «Войти через Google»
4. **Vercel Redeploy** если env vars менялись — обязателен для Vite-переменных
5. **Перейти на Stripe Live** перед реальным запуском (`pk_test_` → `pk_live_`)
6. **E2E тесты** обновить под Supabase-архитектуру (`npx playwright test`)

---

## Ключевые файлы

| Файл | Назначение |
|------|-----------|
| `src/services/supabase.ts` | Supabase client + getUserProfile/getUsageToday |
| `src/services/ingredients.ts` | getAllIngredients (Supabase) |
| `src/services/dishes.ts` | findDishesByIngredients, getDishesByFocus |
| `src/services/recipes.ts` | getRecipeByDishId, getAllRecipesForDish |
| `src/store/slices/userSlice.ts` | Auth + plan management |
| `src/hooks/usePlan.ts` | Gate-проверки (canSwipe, canUseAIPhoto…) |
| `src/components/AuthModal/` | Google OAuth + email auth |
| `src/components/PaywallModal/` | Stripe checkout |
| `supabase/functions/` | Edge Functions (openai-proxy, create-checkout, stripe-webhook) |

---

## Открытые вопросы

- E2E тесты писались под sql.js — нужно обновить под Supabase-архитектуру.
- `recipe_ingredients` для блюд 1-40 содержат hardcoded ID с ошибками — pre-existing bug, не трогать.
