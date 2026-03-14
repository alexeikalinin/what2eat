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
- **Env (Vercel):** `VITE_SUPABASE_URL`, `VITE_SUPABASE_ANON_KEY`, `VITE_STRIPE_PUBLISHABLE_KEY`, `VITE_STRIPE_PRICE_ID`
- **Stripe:** тестовый режим (`pk_test_`)

---

## Известные проблемы / в процессе

- **Исправлено в коде (нужен деплой):** `Error fetching ingredients` и `_getSessionFromURL → fetch Invalid value` / `Headers: Invalid value` — причина: в Headers/fetch передавались не-строки. В supabase.ts добавлены `String().trim()` для URL и ключа и auth с PKCE. После деплоя проверить вход через Google и загрузку ингредиентов.
- В Supabase Dashboard → Authentication → URL Configuration в **Redirect URLs** должна быть строка `https://what2eat-ruby.vercel.app` (и при необходимости `https://what2eat-ruby.vercel.app/**`).

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
