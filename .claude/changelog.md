# What2Eat — Changelog

---

## [2026-03-15] fix: Флеш "Ничего не нашлось" + комплексный фикс изображений

**Проблема 1:** При поиске блюд на долю секунды мелькал экран "Ничего не нашлось" до загрузки результатов.
**Решение:** Добавлен флаг `searchComplete: boolean` в `dishesSlice`. SwipeDeck показывает спиннер пока `loading || !searchComplete`. Экран "ничего не нашлось" появляется только после реального завершения поиска с пустым результатом.
**Файлы:** `src/store/slices/dishesSlice.ts`, `src/components/SwipeDeck/SwipeDeck.tsx`

**Проблема 2:** Изображения блюд не соответствовали блюдам (особенно те, у которых нет code-side override).
**Решение A:** Добавлены 20+ новых паттернов в `DISH_IMAGE_OVERRIDES` — теперь покрыты: Гречка, Медовик, Драники, Паэлья, Хумус, Панна котта, Чизкейк, Газпачо, Бефстроганов, Лагман, Авокадо, Вареники, Чечевица и другие.
**Решение B:** Создана migration 013 — UPDATE по ILIKE-шаблонам для всех типов блюд, устанавливает правильные Unsplash-фото в БД.
**Файлы:** `src/utils/imageUtils.ts`, `supabase/migrations/013_fix_all_dish_images.sql`

---

## [2026-03-15] data: Migration 012 — расширение базы рецептов (+25 блюд, +12 ингредиентов)

**Описание:** 25 новых блюд с полными рецептами, акцент на частые продукты из холодильника (грибы, творог, фарш, рыба, капуста) для максимизации coverage-совпадений.
**Файл:** `supabase/migrations/012_expand_recipes.sql`
**Также:** 12 новых override-паттернов в `src/utils/imageUtils.ts` (жульен, голубцы, капуста тушёная, рагу, морковь по-корейски, запеканка, тефтели, семга)
**Новые блюда:**
- Грибные: Суп грибной, Жульен с курицей и грибами, Гречка с грибами, Макароны с грибами в сметане
- Фарш/котлеты: Котлеты домашние, Тефтели в сметанном соусе, Голубцы, Куриные котлеты
- Курица: Курица в сметане, Куриная лапша
- Рыба: Рыба запечённая с лимоном, Уха, Семга с овощами
- Яичные: Омлет с грибами, Омлет с сыром и помидорами, Яичница с грибами
- Творог: Сырники, Творожная запеканка
- Капуста/овощи: Капуста тушёная с морковью, Рагу из овощей
- Салаты: Салат из свеклы с чесноком, Морковь по-корейски
- Супы: Гороховый суп со свининой, Суп из чечевицы
- Запеканка картофельная с фаршем
**Новые ингредиенты (12):** Рыба, Семга, Хлеб, Сухари, Тунец, Перловка, Зелень, Кориандр, Чечевица, Сахар, Уксус, Лавровый лист
**После миграции:** ~173 блюда / ~190 рецептов

---

## [2026-03-14] data: Migration 010 — расширение базы рецептов (+17 блюд)

**Описание:** 17 новых блюд с полными рецептами и ингредиентами. После миграции: ~148 блюд / ~165 рецептов.
**Файл:** `supabase/migrations/010_more_recipes.sql`
**Новые блюда:**
- Русские классики: Бефстроганов, Рассольник, Салат Оливье, Медовик, Блинчики с мясом
- Восточноевропейские: Вареники с картофелем, Драники
- Средиземноморские/испанские: Греческий салат, Газпачо, Паэлья с морепродуктами, Хумус домашний
- Интернациональные: Салат Цезарь с курицей, Авокадо тост
- Итальянские: Панна котта
- Азиатские: Суп Фо бо
- Американские: Чизкейк Нью-Йорк, Яйца Бенедикт
**Новые ингредиенты (16):** Ванилин, Кумин, Шафран, Бадьян, Кардамон, Гвоздика, Тахини, Кунжут, Желатин, Рыбный соус, Сахарная пудра, Сода, Печенье, Креветки, Мидии, Кальмары

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

