# Прогресс сессии / Handoff (Claude Code ↔ Cursor)

Файл для синхронизации контекста при переключении между Claude Code и Cursor. Обновляется автоматически в конце каждой сессии.

---

## Последнее обновление

- **Дата:** 2026-03-14
- **Среда:** Cursor

---

## Что сделано в последней сессии

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

1. **Задеплоить** текущие изменения (supabase.ts + userSlice), проверить на продакшне Google OAuth и загрузку ингредиентов
2. **Проверить Redirect URLs** в Supabase: Auth → URL Configuration — в списке должен быть `https://what2eat-ruby.vercel.app`
3. **Перейти на Stripe Live** — заменить `pk_test_` на `pk_live_` ключи перед реальным запуском
4. **Запустить E2E тесты** после стабилизации (`npx playwright test`)

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
