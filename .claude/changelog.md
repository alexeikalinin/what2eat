# What2Eat — Changelog

---

## [2026-03-10] feature: Freemium монетизация (Stripe + Supabase)

**Описание:** Полная реализация Free/Premium подписок. Supabase Auth, OpenAI прокси, Stripe Checkout, paywall gates в компонентах.
**Изменения:**
- `src/services/supabase.ts` — Supabase client, getUserProfile, getUsageToday, incrementUsage
- `src/services/stripe.ts` — createCheckoutSession()
- `src/store/slices/userSlice.ts` — user, plan ('guest'|'free'|'premium'|'loading'), usageToday
- `src/hooks/usePlan.ts` — canSwipe(), canUseAIPhoto(), canUseCalories(), canUseWeeklyPlanner(), canUseAdvancedFilters(), canUseFullRandomizer()
- `src/components/AuthModal/` — email + Google OAuth форма
- `src/components/PaywallModal/` — таблица фич + Stripe кнопка
- `src/store/index.ts` — добавлен userSlice
- `src/App.tsx` — initAuth, onAuthStateChange, stripe redirect handling, AuthModal/PaywallModal
- `src/components/Layout/Layout.tsx` — UserAvatar с Premium badge, Login кнопка, Lock на Планировщике
- `src/services/openai.ts` — прокси через Supabase Edge Function, фолбэк на прямой вызов
- `src/components/SwipeDeck/SwipeDeck.tsx` — лимит 10 свайпов/день, PaywallModal при превышении
- `src/components/SearchFilters/SearchFilters.tsx` — lock на веган/бюджет/докупить для Free
- `src/components/PhotoUpload/PhotoUpload.tsx` — lock на AI фото (1/день) и калории (Premium)
- `src/components/WeeklyPlanner/WeeklyPlanner.tsx` — полный paywall gate для Free
- `src/components/RandomizerFocus/RandomizerFocusScreen.tsx` — lock на время/сложность/вегетарианское для Free
- `supabase/functions/openai-proxy/` — Edge Function: JWT verify, план-проверка, счётчики, прокси к OpenAI
- `supabase/functions/create-checkout/` — Edge Function: Stripe Checkout Session
- `supabase/functions/stripe-webhook/` — Edge Function: обновление плана при оплате
- `supabase/migrations/001_user_profiles.sql` — таблица user_profiles + trigger
- `supabase/migrations/002_usage_counters.sql` — таблица usage_counters + RPC increment_usage
- `@supabase/supabase-js`, `@stripe/stripe-js` добавлены в dependencies
- `.env` обновлён (OpenAI ключ очищен), `.env.example` создан

**Free лимиты:** 10 свайпов/день, 1 AI фото/день
**Гостевые лимиты:** localStorage (обходимо — OK для MVP)
**Статус:** закрыт

---

## [2026-03-09] feature: Рандомайзер с фокусом

**Описание:** Добавлен экран настройки рандомайзера вместо прямого рандомного выбора.
**Изменения:**
- Новый Redux slice `randomizerSlice.ts` с состоянием `RandomizerFocus`
- Новая функция `getDishesByFocus()` в `services/dishes.ts`
- Новый thunk `randomizeDishesByFocus` (заменил `randomizeMeatDishes`)
- Новый компонент `RandomizerFocus/RandomizerFocusScreen.tsx` с MUI ToggleButtonGroup
- App.tsx: новый view `'randomizer_focus'`, кнопка "Случайное" → экран фокуса
**Файлы:** `src/store/slices/randomizerSlice.ts`, `src/store/slices/dishesSlice.ts`, `src/services/dishes.ts`, `src/components/RandomizerFocus/`, `src/App.tsx`
**Статус:** закрыт

---

## [2026-03-09] feature: Расширение базы данных (60+ блюд)

**Описание:** Добавлены поля `cuisine_type` и `meal_type`, исправлены дублирующиеся изображения, добавлены 21 новое блюдо + 11 ингредиентов.
**Изменения:**
- `schema.sql`: ALTER TABLE для cuisine_type/meal_type (идемпотентно)
- `seed.sql`: UPDATE-исправления дублей картинок, backfill для 40 существующих блюд
- Добавлены: Творог, Грибы, Бекон, Мука, Соевый соус, Томатная паста, Лимон, Имбирь, Пармезан, Горох, Лапша
- Новые блюда: завтраки (4), итальянские (4), азиатские (3), русские супы (5), гарниры (5) и другие
**Файлы:** `database/schema.sql`, `database/seed.sql`
**Статус:** закрыт

---

## [2026-03-09] fix: Баг "Докупить" — показывался всегда

**Проблема:** Значок "Докупить" появлялся на карточках даже когда были блюда с полным набором ингредиентов.
**Решение:** В `findDishesByIngredients()` — сначала ищем "идеальные" блюда (`perfectDishes.length === 0` → тогда показываем с недостающими). "Докупить" только как запасной вариант.
**Файлы:** `src/services/dishes.ts`
**Статус:** закрыт

---

## [2026-03-09] fix: SwipeDeck — карточки пропадали после 7 свайпов

**Проблема:** После N свайпов колода становилась пустой (видны только кнопки), хотя блюда ещё оставались. `topDishIndex = dishes.length - 1 - currentIndex` указывал на скрытую карточку.
**Решение:** `topDishIndex = currentIndex` (верхняя карточка всегда `dishes[currentIndex]`). Добавлен явный `zIndex: dishes.length - index` для правильного стекирования. Кнопки свайпа теперь тоже используют `currentIndex`.
**Файлы:** `src/components/SwipeDeck/SwipeDeck.tsx`
**Статус:** закрыт

---

## [2026-03-09] fix: Мало кухонь в рандомайзере

**Проблема:** В RandomizerFocusScreen отображались только 3 кухни: Русская, Итальянская, Азиатская.
**Решение:** Добавлены кнопки "Восточноевропейская" и "Средиземноморская". Также добавлены 4 средиземноморских блюда в seed.sql (Греческий салат, Хумус, Рататуй, Дзадзики).
**Файлы:** `src/components/RandomizerFocus/RandomizerFocusScreen.tsx`, `database/seed.sql`
**Статус:** закрыт

---

## [2026-03-09] issue: Hardcoded ID в recipe_ingredients для блюд 1-40

**Проблема:** Существующие `recipe_ingredients` для первых 40 блюд используют захардкоженные ID ингредиентов. Комментарии неверны (например, написано "Масло растительное", а ID указывает на другой ингредиент).
**Решение:** Не трогаем, чтобы не сломать существующие рецепты. Все новые записи используют subquery-паттерн по имени.
**Файлы:** `database/seed.sql`
**Статус:** открыт (низкий приоритет)

---

## [2026-03-09] feature: Утилита add-recipe

**Описание:** Создан скрипт для добавления новых рецептов через структурированный объект TypeScript.
**Файлы:** `scripts/add-recipe.ts`
**Статус:** закрыт

---

---

## [2026-03-10] issue: Supabase миграции — нет IPv6 на хост-машине

**Проблема:** Supabase-проект `zfiyhhsknwpilamljhqu` разрешается только по IPv6 (`db.zfiyhhsknwpilamljhqu.supabase.co` → AAAA `2a05:d014:1c06:5f4e:f53b:6240:46d:25cf`). IPv4 A-записи нет. Машина разработки без IPv6 — `psql` и `supabase db push` завершаются с `no route to host`. REST API (`https://zfiyhhsknwpilamljhqu.supabase.co`) работает через HTTPS/IPv4.
**Решение:** Два варианта — (A) personal access token для `supabase link` + `db push`, (B) пользователь запускает SQL-файл вручную через Dashboard SQL Editor.
**Файлы:** `supabase/migrations/003_recipe_database.sql`, `supabase/migrations/004_recipe_seed.sql`
**Статус:** открыт


---

## [2026-03-11] feature: UX-доработки — unlikeDish, SVG-заглушки с эмодзи, секция "Идеи на сегодня"

**Проблема:** 3 UX-проблемы: (1) нельзя убрать блюдо из "Понравилось"; (2) карточки рандомайзера без фото показывали мелкий SVG 400×300 без смысловых иконок; (3) под кнопками поиска на главном экране пустое пространство.
**Решение:**
1. `unlikeDish` reducer в `swipeSlice.ts` — фильтрует `likedDishIds`. В `SwipeResults.tsx` — `IconButton` с `DeleteOutline` в позиции `absolute top:8 right:8` над каждой карточкой.
2. SVG-заглушка расширена до `400×520` (portrait). Добавлен `pickFoodEmoji()` с ~18 паттернами (суп→🍲, рис→🍚, паста→🍝, курица→🍗 и т.д.). Эмодзи 72px + название 22px.
3. Новые функции `getQuickDishes(limit)` и `getDishOfDay()` в `services/dishes.ts`. Новый компонент `QuickIdeas` (блюдо дня + горизонтальный скролл быстрых блюд ≤20 мин). Интегрирован в `App.tsx` после кнопок поиска.
**Файлы:** `src/store/slices/swipeSlice.ts`, `src/components/SwipeResults/SwipeResults.tsx`, `src/utils/imageUtils.ts`, `src/services/dishes.ts`, `src/components/QuickIdeas/QuickIdeas.tsx`, `src/components/QuickIdeas/index.ts`, `src/App.tsx`
**Статус:** закрыт

---

## [2026-03-11] fix: Supabase migration — FK violation recipe_ingredients

**Проблема:** `recipe_ingredients` для блюд 1-40 использовали хардкоженые `recipe_id` (1-40), рассчитывая на строгий SERIAL-порядок. Если хоть один из 40 recipe-INSERT пропускался (ON CONFLICT / ошибка), sequence уходил не туда и `recipe_id=33` не существовало. Также `instructions JSONB` давал лишнюю строгость.
**Решение:**
1. Изменил `instructions` с `JSONB` на `TEXT` в схеме (003)
2. Удалил все хардкоженые INSERT для `recipe_ingredients` блюд 1-40 (они и в SQLite имели неверные ingredient_id — известный баг)
3. Оставил только name-based subquery inserts для новых блюд (41-94)
**Файлы:** `supabase/migrations/003_recipe_database.sql`, `supabase/migrations/004_recipe_seed.sql`, `supabase/migrations/ALL_run_in_sql_editor.sql`
**Статус:** закрыт — нужно повторно запустить ALL_run_in_sql_editor.sql

