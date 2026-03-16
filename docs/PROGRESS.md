# What2Eat — Session Progress

## Дата: 2026-03-16

## Статус: ЗАВЕРШЕНО ✅

---

## Что сделано в этой сессии

### 1. Автоматический аудит изображений — 135 блюд исправлено
- `scripts/audit-images.ts` — GPT-4o Vision (detail:low) проверяет каждое Unsplash фото
- Оценка 1-10 по соответствию название ↔ фото, при score < 6 генерируется DALL-E 3
- ASCII slugify для Supabase Storage (кириллица → `dish-{id}-{id}.png`)
- 135 блюд заменены: вареные яйца → не бокал вина, борщ → не морковный суп, и т.д.

### 2. EN-режим — полные исправления
- Ингредиенты после AI-анализа фото показываются на английском
- Сложность: `DIFFICULTY_LABELS` → `difficultyLabel(t)` во всех компонентах (SwipeCard, DishCard, RecipeView)
- Варианты рецептов: `RECIPE_TITLE_EN` map + `recipeTitle()` в lang.ts
- Калории: автоподсчёт из ингредиентов рецепта без загрузки фото
- Анимация ❤️ при свайпе вправо (framer-motion)

### 3. Перевод описаний 170 блюд
- `scripts/translate-descriptions.ts` — GPT-4o-mini, батчи по 20, ~$0.01
- Все 170 блюд теперь имеют `description_en` в Supabase

### 4. Фикс селектора ингредиентов (овощи не отображались)
- Причина: `import_recipes.py` добавил ~950 recipe-only ингредиентов с `show_in_selector=true`
- Supabase лимит 1000 строк обрезал vegetables/spices (алфавитно после 'other')
- Migration 020: `UPDATE ingredients SET show_in_selector=false WHERE id>=180 AND category='other'`
- Результат: 70 ингредиентов в селекторе, все 6 категорий видны

---

## Состояние БД
- `dishes`: 170 записей, все с `name_en` ✅, все с `description_en` ✅
- `ingredients`: ~1300 записей, все с `name_en` ✅, 70 в селекторе
- `dish-images` bucket: 150+ DALL-E 3 фото ✅
- Migrations applied: 001–020

## Сборка
`npm run build` — ✅ чистая сборка

## Git
Последний коммит: `8652ba9 feat: translate all 170 dish descriptions to English`
Все изменения запушены на `main` → Vercel деплой автоматически.
