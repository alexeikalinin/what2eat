Ты помогаешь добавить новый рецепт в базу данных What2Eat (Supabase).

## Шаг 1 — Сбор данных

Если аргументы переданы через $ARGUMENTS — разбери их как название блюда. Иначе запроси у пользователя:

**Обязательные поля:**
- Название блюда (уникальное)
- Кухня (`russian` / `italian` / `asian` / `georgian` / `mediterranean` / `eastern_european` / `mexican` / `french` / `other`)
- Тип приёма пищи (`breakfast` / `lunch` / `dinner` / `snack`)
- Время приготовления (минуты)
- Сложность (`easy` / `medium` / `hard`)
- Краткое описание (1–2 предложения)
- Вегетарианское? (да/нет)
- Веганское? (да/нет)
- Ингредиенты (список — название + количество + единица)
- Шаги приготовления (пронумерованный список)

**Опциональные поля:**
- Название варианта рецепта (по умолчанию "Классический")
- Ссылка на источник (URL)
- Порций (по умолчанию 4)
- Примерная стоимость (руб)
- Unsplash photo ID (например `photo-1547592166-6d74a4ccbe73`) — если не указан, подбери подходящий из похожих блюд в БД

## Шаг 2 — Проверка существующих данных

Прочитай файл `/Users/alexei.kalinin/Documents/VibeCoding/What2Eat/supabase/migrations/004_recipe_seed.sql` (первые 60 строк) чтобы понять список уже существующих ингредиентов.

Для каждого ингредиента из нового рецепта определи:
- **Уже есть в БД** → использовать как есть
- **Нет в БД** → добавить через `INSERT INTO ingredients ... ON CONFLICT (name) DO NOTHING`

Категории ингредиентов: `meat` / `cereals` / `vegetables` / `dairy` / `spices` / `other`

## Шаг 3 — Генерация SQL миграции

Определи номер следующей миграции: найди последний файл в `/Users/alexei.kalinin/Documents/VibeCoding/What2Eat/supabase/migrations/` и увеличь номер на 1.

Создай файл `/Users/alexei.kalinin/Documents/VibeCoding/What2Eat/supabase/migrations/NNN_add_<slug>.sql` по шаблону:

```sql
-- ============================================================
-- Migration NNN: Добавление блюда "<Название>"
-- ============================================================

-- Новые ингредиенты (если есть)
INSERT INTO ingredients (name, category, image_url, show_in_selector) VALUES
  ('Новый ингредиент', 'vegetables', NULL, TRUE)
ON CONFLICT (name) DO NOTHING;

-- Блюдо
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES (
  'Название',
  'Описание',
  'https://images.unsplash.com/photo-XXXXXXXX?w=400&h=520&fit=crop&q=80',
  30, 'medium', 4, NULL, FALSE, FALSE, 'russian', 'dinner'
) ON CONFLICT DO NOTHING;

-- Связи блюдо → ингредиенты
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Название' AND i.name IN ('Ингредиент 1', 'Ингредиент 2')
ON CONFLICT DO NOTHING;

-- Рецепт
INSERT INTO recipes (dish_id, title, source_url, instructions)
SELECT d.id,
  'Классический',
  NULL,
  '[
    {"step": 1, "description": "Шаг 1"},
    {"step": 2, "description": "Шаг 2"}
  ]'
FROM dishes d WHERE d.name = 'Название'
ON CONFLICT DO NOTHING;

-- Количества ингредиентов в рецепте
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Ингредиент 1' THEN 200
    WHEN 'Ингредиент 2' THEN 2
  END,
  CASE i.name
    WHEN 'Ингредиент 1' THEN 'г'
    WHEN 'Ингредиент 2' THEN 'шт'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Название' AND i.name IN ('Ингредиент 1', 'Ингредиент 2')
ON CONFLICT DO NOTHING;
```

## Шаг 4 — Применение миграции

Выполни команду:
```bash
SUPABASE_ACCESS_TOKEN=sbp_9ced2d4f8890f39843ecb9fee70e8519100446aa npx supabase db push
```

Рабочая директория: `/Users/alexei.kalinin/Documents/VibeCoding/What2Eat`

## Шаг 5 — Проверка

После успешного применения выполни проверочный запрос через Node.js:
```javascript
// Убедись что блюдо появилось и рецепт загружается корректно
const { data } = await supabase.from('dishes').select('id, name, cuisine_type').eq('name', 'Название').maybeSingle()
const { count } = await supabase.from('recipes').select('*', { count: 'exact', head: true }).eq('dish_id', data.id)
console.log(`✓ Добавлено: ${data.name} (id=${data.id}), рецептов: ${count}`)
```

Для Node.js используй:
```
import { createClient } from '/Users/alexei.kalinin/Documents/VibeCoding/What2Eat/node_modules/@supabase/supabase-js/dist/index.mjs'
const supabase = createClient('https://zfiyhhsknwpilamljhqu.supabase.co', 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmaXloaHNrbndwaWxhbWxqaHF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMzM2MTYsImV4cCI6MjA4ODcwOTYxNn0.LkWxLOfehJSCV58lvwWcDoDxyKOcjEPF76yjEppsAg8')
```

## Шаг 6 — Отчёт

Выведи итог:
```
✅ Добавлено: <Название> (<кухня>, <тип приёма пищи>, <время> мин)
📁 Миграция: supabase/migrations/NNN_add_<slug>.sql
🧂 Новые ингредиенты: <список или "нет">
📋 Шагов в рецепте: N
```
