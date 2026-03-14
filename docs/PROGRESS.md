# Прогресс сессии / Handoff (Claude Code ↔ Cursor)

Файл для синхронизации контекста при переключении между Claude Code и Cursor. Обновляется автоматически в конце каждой сессии.

---

## Последнее обновление

- **Дата:** 2026-03-14
- **Среда:** Claude Code

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

- `Error fetching ingredients: Object` на продакшне — причина пока не установлена. GRANT выдан, env vars правильные (`https://zf...`, KEY: true). Диагностический лог в коде (ветка main, коммит a18563d). **Следующий шаг:** посмотреть точный текст ошибки в консоли после деплоя.
- `_getSessionFromURL → fetch Invalid value` — Google OAuth не завершается успехом. Google provider включён в Supabase. Возможно связано с ошибкой ingredients (Supabase не инициализируется корректно).
- Debug логи в коде (временно): `src/services/supabase.ts` (убраны линтером), `src/services/ingredients.ts`, `src/services/dishes.ts` — **убрать после диагностики**.

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

1. **Починить `Error fetching ingredients`** — посмотреть точный текст ошибки в консоли (диаг. лог уже в коде), устранить причину
2. **Убрать debug логи** из `ingredients.ts` и `dishes.ts` после диагностики
3. **Проверить Google OAuth** на продакшне — должно заработать после фикса Supabase
4. **Перейти на Stripe Live** — заменить `pk_test_` на `pk_live_` ключи перед реальным запуском
5. **Запустить E2E тесты** после стабилизации (`npx playwright test`)

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

- Почему `Error fetching ingredients` несмотря на правильные env vars и GRANT? Нужен текст ошибки из консоли.
- E2E тесты писались под sql.js — нужно обновить под Supabase-архитектуру.
- `recipe_ingredients` для блюд 1-40 содержат hardcoded ID с ошибками — pre-existing bug, не трогать.
