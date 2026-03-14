-- ============================================================
-- Migration 012: расширение базы рецептов — 25 новых блюд
-- Акцент: частые продукты (грибы, творог, фарш, рыба, капуста)
-- чтобы алгоритм coverage находил больше совпадений
-- ============================================================

-- ============================================================
-- Новые ингредиенты
-- ============================================================
INSERT INTO ingredients (name, category) VALUES
  ('Рыба',        'meat'),
  ('Семга',       'meat'),
  ('Хлеб',        'cereals'),
  ('Сухари',      'cereals'),
  ('Тунец',       'meat'),
  ('Перловка',    'cereals'),
  ('Зелень',      'vegetables'),
  ('Кориандр',    'spices'),
  ('Чечевица',    'cereals'),
  ('Сахар',       'spices'),
  ('Уксус',       'other'),
  ('Лавровый лист', 'spices')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- ГРУППА 1: Грибные блюда
-- ============================================================

-- 1. Суп грибной
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Суп грибной',
  'Ароматный суп из шампиньонов с картофелем и сметаной — быстрый и сытный обед.',
  'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80',
  35, 'easy', 4, 180.00, TRUE, FALSE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп грибной'
  AND i.name IN ('Грибы','Картофель','Лук','Морковь','Сметана','Соль','Перец черный','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Грибы нарезать ломтиками, лук — кубиками, морковь натереть на крупной тёрке. Обжарить лук с морковью на масле 5 мин, добавить грибы, жарить ещё 7–8 мин до испарения жидкости."},
    {"step":2,"description":"Налить в кастрюлю 1,5 л воды, довести до кипения. Картофель нарезать кубиками и добавить в бульон, варить 10 мин."},
    {"step":3,"description":"Добавить обжаренные грибы с овощами, посолить и поперчить, варить ещё 7 минут."},
    {"step":4,"description":"Снять с огня, дать настояться 5 мин. Подавать со сметаной и свежей зеленью."}]'
FROM dishes d WHERE d.name = 'Суп грибной';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Грибы'             THEN 400 WHEN 'Картофель'         THEN 3
    WHEN 'Лук'               THEN 1   WHEN 'Морковь'           THEN 1
    WHEN 'Сметана'           THEN 100 WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5 WHEN 'Масло растительное' THEN 2
  END,
  CASE i.name
    WHEN 'Грибы'             THEN 'г'    WHEN 'Картофель'         THEN 'шт'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Морковь'           THEN 'шт'
    WHEN 'Сметана'           THEN 'г'    WHEN 'Соль'              THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.' WHEN 'Масло растительное' THEN 'ст.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп грибной'
  AND i.name IN ('Грибы','Картофель','Лук','Морковь','Сметана','Соль','Перец черный','Масло растительное')
ON CONFLICT DO NOTHING;

-- 2. Жульен с курицей и грибами
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Жульен с курицей и грибами',
  'Нежные кусочки курицы с грибами, запечённые в сметанном соусе под сырной корочкой.',
  'https://images.unsplash.com/photo-1604152135912-04a022e23696?w=400&h=520&fit=crop&q=80',
  40, 'medium', 4, 350.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Жульен с курицей и грибами'
  AND i.name IN ('Курица','Грибы','Сметана','Сыр','Лук','Мука','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Куриное филе отварить или обжарить до готовности, остудить и нарезать небольшими кубиками."},
    {"step":2,"description":"Грибы и лук нарезать, обжарить на сливочном масле до золотистого цвета (8–10 мин). Добавить муку, перемешать."},
    {"step":3,"description":"Влить сметану, посолить и поперчить. Тушить 3–4 мин до загустения соуса."},
    {"step":4,"description":"Добавить курицу, перемешать. Разложить по порционным кокотницам или небольшой форме."},
    {"step":5,"description":"Посыпать тёртым сыром. Запекать в духовке при 180°C 15–20 мин до золотистой корочки."}]'
FROM dishes d WHERE d.name = 'Жульен с курицей и грибами';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Курица'            THEN 400 WHEN 'Грибы'             THEN 300
    WHEN 'Сметана'           THEN 200 WHEN 'Сыр'               THEN 150
    WHEN 'Лук'               THEN 2   WHEN 'Мука'              THEN 2
    WHEN 'Масло сливочное'   THEN 40  WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Курица'            THEN 'г'    WHEN 'Грибы'             THEN 'г'
    WHEN 'Сметана'           THEN 'г'    WHEN 'Сыр'               THEN 'г'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Мука'              THEN 'ст.л.'
    WHEN 'Масло сливочное'   THEN 'г'    WHEN 'Соль'              THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Жульен с курицей и грибами'
  AND i.name IN ('Курица','Грибы','Сметана','Сыр','Лук','Мука','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 3. Гречка с грибами
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Гречка с грибами',
  'Рассыпчатая гречка с обжаренными грибами и луком — сытное вегетарианское блюдо.',
  'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400&h=520&fit=crop&q=80',
  30, 'easy', 4, 150.00, TRUE, TRUE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гречка с грибами'
  AND i.name IN ('Гречка','Грибы','Лук','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Гречку промыть, залить 2 стаканами воды, посолить, довести до кипения. Варить на малом огне под крышкой 15–18 мин до полного впитывания воды."},
    {"step":2,"description":"Грибы нарезать ломтиками, лук — полукольцами. Обжарить лук на масле 3 мин, добавить грибы, жарить до золотистого цвета 8–10 мин."},
    {"step":3,"description":"Добавить поджарку к готовой гречке, перемешать. Поперчить по вкусу. Подавать горячим."}]'
FROM dishes d WHERE d.name = 'Гречка с грибами';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Гречка'            THEN 250 WHEN 'Грибы'             THEN 300
    WHEN 'Лук'               THEN 2   WHEN 'Масло растительное' THEN 3
    WHEN 'Соль'              THEN 1   WHEN 'Перец черный'       THEN 0.5
  END,
  CASE i.name
    WHEN 'Гречка'            THEN 'г'    WHEN 'Грибы'             THEN 'г'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Перец черный'       THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гречка с грибами'
  AND i.name IN ('Гречка','Грибы','Лук','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 4. Макароны с грибами в сметане
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Макароны с грибами в сметане',
  'Паста с нежными шампиньонами в сливочно-сметанном соусе — быстрый ужин за 25 минут.',
  'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=520&fit=crop&q=80',
  25, 'easy', 4, 200.00, TRUE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Макароны с грибами в сметане'
  AND i.name IN ('Макароны','Грибы','Лук','Сметана','Чеснок','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Отварить макароны в подсолённой воде согласно инструкции на упаковке. Слить воду, оставив 50 мл."},
    {"step":2,"description":"Грибы нарезать ломтиками, лук — кубиками, чеснок измельчить. Обжарить лук и грибы на сливочном масле 8–10 мин."},
    {"step":3,"description":"Добавить чеснок, жарить 1 мин. Влить сметану, посолить и поперчить, тушить 3 мин."},
    {"step":4,"description":"Добавить макароны и 50 мл отвара, перемешать, прогреть 2 мин. Подавать горячим."}]'
FROM dishes d WHERE d.name = 'Макароны с грибами в сметане';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Макароны'          THEN 300 WHEN 'Грибы'             THEN 300
    WHEN 'Лук'               THEN 1   WHEN 'Сметана'           THEN 150
    WHEN 'Чеснок'            THEN 2   WHEN 'Масло сливочное'   THEN 30
    WHEN 'Соль'              THEN 1   WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Макароны'          THEN 'г'    WHEN 'Грибы'             THEN 'г'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Сметана'           THEN 'г'
    WHEN 'Чеснок'            THEN 'зуб.' WHEN 'Масло сливочное'   THEN 'г'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Макароны с грибами в сметане'
  AND i.name IN ('Макароны','Грибы','Лук','Сметана','Чеснок','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 2: Котлеты и тефтели
-- ============================================================

-- 5. Котлеты домашние
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Котлеты домашние',
  'Сочные котлеты из смешанного фарша с луком — классика домашней кухни.',
  'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80',
  40, 'medium', 4, 400.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Котлеты домашние'
  AND i.name IN ('Фарш','Лук','Яйца','Хлеб','Молоко','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Хлеб замочить в молоке на 5–7 мин, затем отжать. Лук мелко нарубить или натереть на тёрке."},
    {"step":2,"description":"Смешать фарш с отжатым хлебом, луком, яйцом, солью и перцем. Вымешать до однородности."},
    {"step":3,"description":"Влажными руками сформировать котлеты толщиной 2 см. Обвалять в муке или сухарях (по желанию)."},
    {"step":4,"description":"Обжарить на масле на среднем огне по 4–5 мин с каждой стороны до корочки."},
    {"step":5,"description":"Накрыть крышкой, убавить огонь, дотушить 5 мин. Подавать с любым гарниром."}]'
FROM dishes d WHERE d.name = 'Котлеты домашние';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Фарш'              THEN 600 WHEN 'Лук'               THEN 1
    WHEN 'Яйца'              THEN 1   WHEN 'Хлеб'              THEN 2
    WHEN 'Молоко'            THEN 100 WHEN 'Масло растительное' THEN 3
    WHEN 'Соль'              THEN 1   WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Фарш'              THEN 'г'    WHEN 'Лук'               THEN 'шт'
    WHEN 'Яйца'              THEN 'шт'   WHEN 'Хлеб'              THEN 'ломтика'
    WHEN 'Молоко'            THEN 'мл'   WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Котлеты домашние'
  AND i.name IN ('Фарш','Лук','Яйца','Хлеб','Молоко','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 6. Тефтели в сметанном соусе
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Тефтели в сметанном соусе',
  'Мясные шарики из фарша с рисом, тушёные в нежном сметанном соусе.',
  'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80',
  55, 'medium', 4, 380.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тефтели в сметанном соусе'
  AND i.name IN ('Фарш','Рис','Лук','Яйца','Сметана','Томатная паста','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Рис промыть и отварить до полуготовности 10 мин. Остудить. Лук мелко нарезать."},
    {"step":2,"description":"Смешать фарш, рис, лук, яйцо, соль и перец. Вымесить. Сформировать тефтели диаметром 4 см."},
    {"step":3,"description":"Обжарить тефтели на масле со всех сторон до корочки (5–6 мин)."},
    {"step":4,"description":"Для соуса: смешать сметану с томатной пастой и 200 мл воды. Залить тефтели соусом."},
    {"step":5,"description":"Тушить под крышкой на малом огне 20–25 мин. Подавать с картофелем или гречкой."}]'
FROM dishes d WHERE d.name = 'Тефтели в сметанном соусе';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Фарш'              THEN 500 WHEN 'Рис'               THEN 100
    WHEN 'Лук'               THEN 1   WHEN 'Яйца'              THEN 1
    WHEN 'Сметана'           THEN 200 WHEN 'Томатная паста'    THEN 2
    WHEN 'Масло растительное' THEN 2  WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Фарш'              THEN 'г'    WHEN 'Рис'               THEN 'г'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Яйца'              THEN 'шт'
    WHEN 'Сметана'           THEN 'г'    WHEN 'Томатная паста'    THEN 'ст.л.'
    WHEN 'Масло растительное' THEN 'ст.л.' WHEN 'Соль'            THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Тефтели в сметанном соусе'
  AND i.name IN ('Фарш','Рис','Лук','Яйца','Сметана','Томатная паста','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 7. Голубцы
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Голубцы',
  'Капустные рулетики с начинкой из риса и мясного фарша, тушёные в томатно-сметанном соусе.',
  'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80',
  90, 'hard', 4, 450.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Голубцы'
  AND i.name IN ('Капуста','Фарш','Рис','Лук','Морковь','Помидоры','Томатная паста','Сметана','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Капусту опустить в кипящую воду целым кочаном на 5–7 мин, чтобы листья стали мягкими. Снять листья, срезать толстые прожилки."},
    {"step":2,"description":"Рис промыть и отварить до полуготовности. Лук мелко нарезать, смешать с фаршем, рисом, солью и перцем."},
    {"step":3,"description":"На каждый лист выложить 2 ст.л. начинки, завернуть в рулетик, подвернув края."},
    {"step":4,"description":"Морковь натереть, лук нарезать, обжарить до мягкости. Добавить томатную пасту и помидоры."},
    {"step":5,"description":"Сложить голубцы в кастрюлю плотно, залить соусом и добавить сметану. Долить воды, чтобы покрыть."},
    {"step":6,"description":"Тушить под крышкой на малом огне 40–50 мин. Подавать горячими со сметаной."}]'
FROM dishes d WHERE d.name = 'Голубцы';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Капуста'           THEN 1    WHEN 'Фарш'              THEN 500
    WHEN 'Рис'               THEN 150  WHEN 'Лук'               THEN 2
    WHEN 'Морковь'           THEN 2    WHEN 'Помидоры'          THEN 2
    WHEN 'Томатная паста'    THEN 2    WHEN 'Сметана'           THEN 200
    WHEN 'Масло растительное' THEN 2   WHEN 'Соль'              THEN 1.5
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Капуста'           THEN 'кочан' WHEN 'Фарш'              THEN 'г'
    WHEN 'Рис'               THEN 'г'     WHEN 'Лук'               THEN 'шт'
    WHEN 'Морковь'           THEN 'шт'    WHEN 'Помидоры'          THEN 'шт'
    WHEN 'Томатная паста'    THEN 'ст.л.' WHEN 'Сметана'           THEN 'г'
    WHEN 'Масло растительное' THEN 'ст.л.' WHEN 'Соль'             THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Голубцы'
  AND i.name IN ('Капуста','Фарш','Рис','Лук','Морковь','Помидоры','Томатная паста','Сметана','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 3: Курица
-- ============================================================

-- 8. Курица в сметане
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Курица в сметане',
  'Мягкая курица, тушёная в сметанном соусе с луком и чесноком — простой и вкусный ужин.',
  'https://images.unsplash.com/photo-1598103442097-8b74394b95c3?w=400&h=520&fit=crop&q=80',
  40, 'easy', 4, 350.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Курица в сметане'
  AND i.name IN ('Курица','Сметана','Лук','Чеснок','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Курицу нарезать порционными кусками, посолить и поперчить. Обжарить на масле по 4–5 мин с каждой стороны до румяной корочки."},
    {"step":2,"description":"Лук нарезать полукольцами, обжарить в том же сотейнике 3–4 мин до мягкости. Добавить измельчённый чеснок."},
    {"step":3,"description":"Вернуть курицу в сотейник, добавить сметану и 100 мл воды. Накрыть крышкой."},
    {"step":4,"description":"Тушить на малом огне 20–25 мин. Проверить на соль. Подавать с гречкой, рисом или картофелем."}]'
FROM dishes d WHERE d.name = 'Курица в сметане';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Курица'            THEN 700 WHEN 'Сметана'           THEN 250
    WHEN 'Лук'               THEN 2   WHEN 'Чеснок'            THEN 3
    WHEN 'Масло растительное' THEN 2  WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Курица'            THEN 'г'    WHEN 'Сметана'           THEN 'г'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Чеснок'            THEN 'зуб.'
    WHEN 'Масло растительное' THEN 'ст.л.' WHEN 'Соль'            THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Курица в сметане'
  AND i.name IN ('Курица','Сметана','Лук','Чеснок','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 9. Куриная лапша
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Куриная лапша',
  'Домашний суп с куриным бульоном, лапшой и овощами — тёплый и сытный.',
  'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80',
  50, 'easy', 4, 280.00, FALSE, FALSE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Куриная лапша'
  AND i.name IN ('Курица','Лапша','Морковь','Лук','Картофель','Укроп','Соль','Перец черный','Лавровый лист')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Курицу залить 2 л холодной воды, довести до кипения, снять пену. Добавить целую морковь и луковицу. Варить 30–35 мин."},
    {"step":2,"description":"Курицу и овощи вынуть. Бульон посолить. Морковь нарезать кружочками, курицу разобрать на кусочки. Лук выбросить."},
    {"step":3,"description":"Картофель нарезать кубиками, добавить в бульон. Варить 10 мин."},
    {"step":4,"description":"Добавить лапшу, варить согласно времени на упаковке (2–4 мин). Вернуть курицу и морковь."},
    {"step":5,"description":"Добавить лавровый лист, поперчить. Снять с огня, настоять 5 мин. Подавать с укропом."}]'
FROM dishes d WHERE d.name = 'Куриная лапша';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Курица'            THEN 500 WHEN 'Лапша'             THEN 100
    WHEN 'Морковь'           THEN 1   WHEN 'Лук'               THEN 1
    WHEN 'Картофель'         THEN 2   WHEN 'Укроп'             THEN 20
    WHEN 'Соль'              THEN 1   WHEN 'Перец черный'      THEN 0.5
    WHEN 'Лавровый лист'     THEN 2
  END,
  CASE i.name
    WHEN 'Курица'            THEN 'г'    WHEN 'Лапша'             THEN 'г'
    WHEN 'Морковь'           THEN 'шт'   WHEN 'Лук'               THEN 'шт'
    WHEN 'Картофель'         THEN 'шт'   WHEN 'Укроп'             THEN 'г'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Перец черный'      THEN 'ч.л.'
    WHEN 'Лавровый лист'     THEN 'шт'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Куриная лапша'
  AND i.name IN ('Курица','Лапша','Морковь','Лук','Картофель','Укроп','Соль','Перец черный','Лавровый лист')
ON CONFLICT DO NOTHING;

-- 10. Куриные котлеты
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Куриные котлеты',
  'Нежные котлеты из куриного фарша — мягкие, сочные, подходят для всей семьи.',
  'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80',
  35, 'easy', 4, 320.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Куриные котлеты'
  AND i.name IN ('Курица','Лук','Яйца','Хлеб','Молоко','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Куриное филе пропустить через мясорубку или измельчить в блендере. Хлеб замочить в молоке на 5 мин, отжать."},
    {"step":2,"description":"Смешать куриный фарш, хлеб, мелко нарезанный лук, яйцо, соль и перец. Хорошо вымесить."},
    {"step":3,"description":"Сформировать котлеты плоской овальной формы. Обжарить на масле по 4–5 мин с каждой стороны."},
    {"step":4,"description":"Накрыть крышкой и довести до готовности ещё 5 мин на малом огне. Подавать с любым гарниром."}]'
FROM dishes d WHERE d.name = 'Куриные котлеты';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Курица'            THEN 600 WHEN 'Лук'               THEN 1
    WHEN 'Яйца'              THEN 1   WHEN 'Хлеб'              THEN 2
    WHEN 'Молоко'            THEN 80  WHEN 'Масло растительное' THEN 3
    WHEN 'Соль'              THEN 1   WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Курица'            THEN 'г'    WHEN 'Лук'               THEN 'шт'
    WHEN 'Яйца'              THEN 'шт'   WHEN 'Хлеб'              THEN 'ломтика'
    WHEN 'Молоко'            THEN 'мл'   WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Куриные котлеты'
  AND i.name IN ('Курица','Лук','Яйца','Хлеб','Молоко','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 4: Рыба
-- ============================================================

-- 11. Рыба запечённая с лимоном
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Рыба запечённая с лимоном',
  'Нежная белая рыба, запечённая с лимоном и чесноком — диетическое и вкусное блюдо.',
  'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80',
  30, 'easy', 4, 400.00, FALSE, FALSE, 'other', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рыба запечённая с лимоном'
  AND i.name IN ('Рыба','Лимон','Чеснок','Масло растительное','Укроп','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Рыбу вымыть, обсушить бумажным полотенцем. Сделать надрезы на коже. Натереть солью и перцем снаружи и внутри."},
    {"step":2,"description":"Чеснок мелко нарубить или выдавить, смешать с оливковым маслом и половиной лимонного сока."},
    {"step":3,"description":"Смазать рыбу смесью с чесноком. Внутрь вложить ломтики лимона и укроп."},
    {"step":4,"description":"Запекать в духовке при 200°C 20–25 мин (зависит от размера рыбы). Подавать горячей с овощами."}]'
FROM dishes d WHERE d.name = 'Рыба запечённая с лимоном';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Рыба'              THEN 600 WHEN 'Лимон'             THEN 1
    WHEN 'Чеснок'            THEN 3   WHEN 'Масло растительное' THEN 2
    WHEN 'Укроп'             THEN 20  WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Рыба'              THEN 'г'    WHEN 'Лимон'             THEN 'шт'
    WHEN 'Чеснок'            THEN 'зуб.' WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Укроп'             THEN 'г'    WHEN 'Соль'              THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рыба запечённая с лимоном'
  AND i.name IN ('Рыба','Лимон','Чеснок','Масло растительное','Укроп','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 12. Уха
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Уха',
  'Прозрачный ароматный рыбный суп с картофелем, морковью и зеленью.',
  'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80',
  45, 'easy', 4, 350.00, FALSE, FALSE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Уха'
  AND i.name IN ('Рыба','Картофель','Морковь','Лук','Укроп','Петрушка','Лавровый лист','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Рыбу очистить, промыть. Голову и хвост (если есть) залить 2 л воды, довести до кипения, варить 20 мин для бульона. Процедить."},
    {"step":2,"description":"В бульон добавить целую луковицу, морковь и лавровый лист. Картофель нарезать кубиками, добавить в суп, варить 10 мин."},
    {"step":3,"description":"Добавить нарезанное рыбное филе, варить 7–10 мин до готовности."},
    {"step":4,"description":"Посолить, поперчить. Удалить лук и лавровый лист. Подавать с укропом и петрушкой."}]'
FROM dishes d WHERE d.name = 'Уха';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Рыба'              THEN 500 WHEN 'Картофель'         THEN 3
    WHEN 'Морковь'           THEN 1   WHEN 'Лук'               THEN 1
    WHEN 'Укроп'             THEN 15  WHEN 'Петрушка'          THEN 15
    WHEN 'Лавровый лист'     THEN 2   WHEN 'Соль'              THEN 1.5
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Рыба'              THEN 'г'    WHEN 'Картофель'         THEN 'шт'
    WHEN 'Морковь'           THEN 'шт'   WHEN 'Лук'               THEN 'шт'
    WHEN 'Укроп'             THEN 'г'    WHEN 'Петрушка'          THEN 'г'
    WHEN 'Лавровый лист'     THEN 'шт'   WHEN 'Соль'              THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Уха'
  AND i.name IN ('Рыба','Картофель','Морковь','Лук','Укроп','Петрушка','Лавровый лист','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 13. Семга с овощами
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Семга с овощами',
  'Стейк сёмги, запечённый с кабачками и помидорами — полезное и нарядное блюдо.',
  'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80',
  30, 'easy', 2, 800.00, FALSE, FALSE, 'other', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Семга с овощами'
  AND i.name IN ('Семга','Кабачки','Помидоры','Лимон','Чеснок','Укроп','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Стейки сёмги посолить, поперчить. Сбрызнуть лимонным соком и масло оливковым, оставить мариноваться 10 мин."},
    {"step":2,"description":"Кабачки нарезать кружочками, помидоры — дольками. Выложить на застеленный бумагой противень."},
    {"step":3,"description":"Сверху выложить стейки сёмги. Посыпать мелко нарезанным чесноком и укропом."},
    {"step":4,"description":"Запекать при 190°C 18–22 мин до готовности рыбы. Подавать немедленно."}]'
FROM dishes d WHERE d.name = 'Семга с овощами';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Семга'             THEN 400 WHEN 'Кабачки'           THEN 1
    WHEN 'Помидоры'          THEN 2   WHEN 'Лимон'             THEN 0.5
    WHEN 'Чеснок'            THEN 2   WHEN 'Укроп'             THEN 15
    WHEN 'Масло растительное' THEN 2  WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Семга'             THEN 'г'    WHEN 'Кабачки'           THEN 'шт'
    WHEN 'Помидоры'          THEN 'шт'   WHEN 'Лимон'             THEN 'шт'
    WHEN 'Чеснок'            THEN 'зуб.' WHEN 'Укроп'             THEN 'г'
    WHEN 'Масло растительное' THEN 'ст.л.' WHEN 'Соль'            THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Семга с овощами'
  AND i.name IN ('Семга','Кабачки','Помидоры','Лимон','Чеснок','Укроп','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 5: Быстрые яичные блюда
-- ============================================================

-- 14. Омлет с грибами
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Омлет с грибами',
  'Пышный омлет с обжаренными шампиньонами — сытный и быстрый завтрак.',
  'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=400&h=520&fit=crop&q=80',
  15, 'easy', 2, 150.00, TRUE, FALSE, 'russian', 'breakfast')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Омлет с грибами'
  AND i.name IN ('Яйца','Грибы','Молоко','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Грибы нарезать тонкими ломтиками. Обжарить на масле 5–6 мин до золотистого цвета, посолить. Отложить."},
    {"step":2,"description":"Яйца взбить с молоком, добавить соль и щепотку перца."},
    {"step":3,"description":"На сковороду выложить сливочное масло, растопить на среднем огне. Влить яичную смесь."},
    {"step":4,"description":"Когда края схватятся, выложить грибы на половину омлета. Сложить омлет пополам, подержать ещё 1 мин."}]'
FROM dishes d WHERE d.name = 'Омлет с грибами';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Яйца'              THEN 3   WHEN 'Грибы'             THEN 150
    WHEN 'Молоко'            THEN 50  WHEN 'Масло сливочное'   THEN 20
    WHEN 'Соль'              THEN 0.5 WHEN 'Перец черный'      THEN 0.2
  END,
  CASE i.name
    WHEN 'Яйца'              THEN 'шт'   WHEN 'Грибы'             THEN 'г'
    WHEN 'Молоко'            THEN 'мл'   WHEN 'Масло сливочное'   THEN 'г'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Омлет с грибами'
  AND i.name IN ('Яйца','Грибы','Молоко','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 15. Омлет с сыром и помидорами
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Омлет с сыром и помидорами',
  'Сочный омлет с плавленым сыром и свежими помидорами — идеальный завтрак.',
  'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=400&h=520&fit=crop&q=80',
  10, 'easy', 2, 130.00, TRUE, FALSE, 'other', 'breakfast')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Омлет с сыром и помидорами'
  AND i.name IN ('Яйца','Сыр','Помидоры','Молоко','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Яйца взбить с молоком и щепоткой соли. Помидор нарезать небольшими кубиками, сыр натереть."},
    {"step":2,"description":"Растопить сливочное масло на сковороде. Влить яичную смесь на средний огонь."},
    {"step":3,"description":"Когда основа схватится, выложить помидоры и посыпать сыром."},
    {"step":4,"description":"Накрыть крышкой на 1–2 мин, пока сыр расплавится. Сложить пополам и подавать."}]'
FROM dishes d WHERE d.name = 'Омлет с сыром и помидорами';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Яйца'              THEN 3   WHEN 'Сыр'               THEN 50
    WHEN 'Помидоры'          THEN 1   WHEN 'Молоко'            THEN 40
    WHEN 'Масло сливочное'   THEN 15  WHEN 'Соль'              THEN 0.3
  END,
  CASE i.name
    WHEN 'Яйца'              THEN 'шт'   WHEN 'Сыр'               THEN 'г'
    WHEN 'Помидоры'          THEN 'шт'   WHEN 'Молоко'            THEN 'мл'
    WHEN 'Масло сливочное'   THEN 'г'    WHEN 'Соль'              THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Омлет с сыром и помидорами'
  AND i.name IN ('Яйца','Сыр','Помидоры','Молоко','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

-- 16. Яичница с грибами
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Яичница с грибами',
  'Яичница-глазунья с обжаренными грибами — простой и сытный завтрак.',
  'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400&h=520&fit=crop&q=80',
  12, 'easy', 2, 120.00, TRUE, FALSE, 'russian', 'breakfast')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Яичница с грибами'
  AND i.name IN ('Яйца','Грибы','Лук','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Грибы нарезать ломтиками, лук — мелко. Обжарить лук на масле 2 мин, добавить грибы, жарить 5–6 мин до румяности."},
    {"step":2,"description":"Посолить, поперчить. Сдвинуть грибы к краю сковороды или выложить поверх них пустое место."},
    {"step":3,"description":"Аккуратно разбить яйца, стараясь не задеть желток. Жарить 3–4 мин до готовности белка. Подавать сразу."}]'
FROM dishes d WHERE d.name = 'Яичница с грибами';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Яйца'              THEN 2   WHEN 'Грибы'             THEN 150
    WHEN 'Лук'               THEN 0.5 WHEN 'Масло сливочное'   THEN 15
    WHEN 'Соль'              THEN 0.5 WHEN 'Перец черный'      THEN 0.2
  END,
  CASE i.name
    WHEN 'Яйца'              THEN 'шт'   WHEN 'Грибы'             THEN 'г'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Масло сливочное'   THEN 'г'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Яичница с грибами'
  AND i.name IN ('Яйца','Грибы','Лук','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 6: Творог
-- ============================================================

-- 17. Сырники
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Сырники',
  'Классические творожные оладьи — нежные внутри, румяные снаружи. Подаются со сметаной.',
  'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80',
  25, 'easy', 4, 200.00, TRUE, FALSE, 'russian', 'breakfast')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Сырники'
  AND i.name IN ('Творог','Яйца','Мука','Сахар','Сметана','Масло растительное','Соль','Ванилин')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Творог протереть через сито или разомнуть вилкой до однородности. Добавить яйцо, сахар, щепотку соли и ванилин."},
    {"step":2,"description":"Добавить муку и быстро замесить мягкое тесто. Оно должно держать форму — если липнет, добавить ещё немного муки."},
    {"step":3,"description":"Присыпать руки мукой, сформировать небольшие круглые сырники толщиной 1,5 см."},
    {"step":4,"description":"Обжарить на масле на среднем огне по 3–4 мин с каждой стороны до золотистой корочки."},
    {"step":5,"description":"Подавать горячими со сметаной, вареньем или свежими ягодами."}]'
FROM dishes d WHERE d.name = 'Сырники';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Творог'            THEN 500 WHEN 'Яйца'              THEN 2
    WHEN 'Мука'              THEN 4   WHEN 'Сахар'             THEN 3
    WHEN 'Сметана'           THEN 100 WHEN 'Масло растительное' THEN 3
    WHEN 'Соль'              THEN 0.3 WHEN 'Ванилин'           THEN 0.5
  END,
  CASE i.name
    WHEN 'Творог'            THEN 'г'    WHEN 'Яйца'              THEN 'шт'
    WHEN 'Мука'              THEN 'ст.л.' WHEN 'Сахар'             THEN 'ст.л.'
    WHEN 'Сметана'           THEN 'г'    WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Ванилин'           THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Сырники'
  AND i.name IN ('Творог','Яйца','Мука','Сахар','Сметана','Масло растительное','Соль','Ванилин')
ON CONFLICT DO NOTHING;

-- 18. Творожная запеканка
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Творожная запеканка',
  'Нежная запеканка из творога — сытный завтрак или десерт без лишних хлопот.',
  'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80',
  55, 'easy', 6, 220.00, TRUE, FALSE, 'russian', 'breakfast')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Творожная запеканка'
  AND i.name IN ('Творог','Яйца','Молоко','Мука','Сахар','Масло сливочное','Сметана','Ванилин','Сода')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Творог протереть или измельчить блендером. Яйца взбить с сахаром до пышности."},
    {"step":2,"description":"Смешать творог, яичную смесь, молоко, муку, ванилин и щепотку соды. Перемешать до однородности."},
    {"step":3,"description":"Форму для запекания смазать сливочным маслом. Вылить тесто."},
    {"step":4,"description":"Поверхность смазать сметаной для румяной корочки. Запекать при 180°C 35–40 мин."},
    {"step":5,"description":"Дать остыть 10 мин перед нарезкой. Подавать тёплой или холодной."}]'
FROM dishes d WHERE d.name = 'Творожная запеканка';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Творог'            THEN 500 WHEN 'Яйца'              THEN 3
    WHEN 'Молоко'            THEN 100 WHEN 'Мука'              THEN 3
    WHEN 'Сахар'             THEN 4   WHEN 'Масло сливочное'   THEN 30
    WHEN 'Сметана'           THEN 50  WHEN 'Ванилин'           THEN 0.5
    WHEN 'Сода'              THEN 0.5
  END,
  CASE i.name
    WHEN 'Творог'            THEN 'г'    WHEN 'Яйца'              THEN 'шт'
    WHEN 'Молоко'            THEN 'мл'   WHEN 'Мука'              THEN 'ст.л.'
    WHEN 'Сахар'             THEN 'ст.л.' WHEN 'Масло сливочное'  THEN 'г'
    WHEN 'Сметана'           THEN 'г'    WHEN 'Ванилин'           THEN 'ч.л.'
    WHEN 'Сода'              THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Творожная запеканка'
  AND i.name IN ('Творог','Яйца','Молоко','Мука','Сахар','Масло сливочное','Сметана','Ванилин','Сода')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 7: Капуста и овощи
-- ============================================================

-- 19. Капуста тушёная с морковью
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Капуста тушёная с морковью',
  'Мягкая тушёная капуста с морковью и томатной пастой — простой постный гарнир.',
  'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=520&fit=crop&q=80',
  30, 'easy', 4, 100.00, TRUE, TRUE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Капуста тушёная с морковью'
  AND i.name IN ('Капуста','Морковь','Лук','Томатная паста','Масло растительное','Соль','Перец черный','Лавровый лист')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Капусту нашинковать, лук нарезать полукольцами, морковь натереть на крупной тёрке."},
    {"step":2,"description":"Обжарить лук с морковью на масле 5 мин. Добавить капусту, перемешать."},
    {"step":3,"description":"Влить 100 мл воды, добавить томатную пасту, соль, перец и лавровый лист."},
    {"step":4,"description":"Накрыть крышкой и тушить на малом огне 20–25 мин, периодически помешивая, до мягкости капусты. Подавать как гарнир."}]'
FROM dishes d WHERE d.name = 'Капуста тушёная с морковью';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Капуста'           THEN 0.5  WHEN 'Морковь'           THEN 1
    WHEN 'Лук'               THEN 1    WHEN 'Томатная паста'    THEN 2
    WHEN 'Масло растительное' THEN 3   WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5  WHEN 'Лавровый лист'     THEN 1
  END,
  CASE i.name
    WHEN 'Капуста'           THEN 'кочан' WHEN 'Морковь'           THEN 'шт'
    WHEN 'Лук'               THEN 'шт'    WHEN 'Томатная паста'    THEN 'ст.л.'
    WHEN 'Масло растительное' THEN 'ст.л.' WHEN 'Соль'             THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'  WHEN 'Лавровый лист'     THEN 'шт'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Капуста тушёная с морковью'
  AND i.name IN ('Капуста','Морковь','Лук','Томатная паста','Масло растительное','Соль','Перец черный','Лавровый лист')
ON CONFLICT DO NOTHING;

-- 20. Рагу из овощей
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Рагу из овощей',
  'Летнее рагу из кабачков, баклажанов и помидоров — лёгкое и ароматное.',
  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80',
  40, 'easy', 4, 200.00, TRUE, TRUE, 'other', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рагу из овощей'
  AND i.name IN ('Кабачки','Баклажаны','Помидоры','Лук','Чеснок','Перец болгарский','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Баклажаны нарезать кубиками, посолить, оставить на 10 мин, затем отжать и промыть."},
    {"step":2,"description":"Кабачки, помидоры и перец нарезать кубиками. Лук — полукольцами, чеснок измельчить."},
    {"step":3,"description":"Обжарить лук 3 мин, добавить баклажаны и перец, жарить 7 мин. Добавить кабачки, тушить 5 мин."},
    {"step":4,"description":"Добавить помидоры и чеснок, посолить, поперчить. Тушить всё вместе 15 мин на среднем огне до готовности. Подавать тёплым или холодным."}]'
FROM dishes d WHERE d.name = 'Рагу из овощей';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Кабачки'           THEN 1   WHEN 'Баклажаны'         THEN 1
    WHEN 'Помидоры'          THEN 3   WHEN 'Лук'               THEN 2
    WHEN 'Чеснок'            THEN 3   WHEN 'Перец болгарский'  THEN 1
    WHEN 'Масло растительное' THEN 3  WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Кабачки'           THEN 'шт'   WHEN 'Баклажаны'         THEN 'шт'
    WHEN 'Помидоры'          THEN 'шт'   WHEN 'Лук'               THEN 'шт'
    WHEN 'Чеснок'            THEN 'зуб.' WHEN 'Перец болгарский'  THEN 'шт'
    WHEN 'Масло растительное' THEN 'ст.л.' WHEN 'Соль'            THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рагу из овощей'
  AND i.name IN ('Кабачки','Баклажаны','Помидоры','Лук','Чеснок','Перец болгарский','Масло растительное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 8: Салаты
-- ============================================================

-- 21. Салат из свеклы с чесноком
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Салат из свеклы с чесноком',
  'Простой и вкусный свекольный салат с чесноком и сметаной — готовится за 15 минут.',
  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80',
  15, 'easy', 4, 80.00, TRUE, FALSE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Салат из свеклы с чесноком'
  AND i.name IN ('Свекла','Чеснок','Сметана','Соль','Сахар')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Свеклу отварить до готовности (45–60 мин) или запечь в фольге (60–80 мин при 200°C). Охладить, очистить."},
    {"step":2,"description":"Свеклу натереть на крупной тёрке. Чеснок выдавить или мелко нарубить."},
    {"step":3,"description":"Смешать свеклу с чесноком и сметаной. Посолить, добавить щепотку сахара. Перемешать."},
    {"step":4,"description":"Дать настояться 15–20 мин в холодильнике. Подавать как закуску или гарнир."}]'
FROM dishes d WHERE d.name = 'Салат из свеклы с чесноком';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Свекла'            THEN 3   WHEN 'Чеснок'            THEN 2
    WHEN 'Сметана'           THEN 100 WHEN 'Соль'              THEN 0.5
    WHEN 'Сахар'             THEN 0.5
  END,
  CASE i.name
    WHEN 'Свекла'            THEN 'шт'   WHEN 'Чеснок'            THEN 'зуб.'
    WHEN 'Сметана'           THEN 'г'    WHEN 'Соль'              THEN 'ч.л.'
    WHEN 'Сахар'             THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Салат из свеклы с чесноком'
  AND i.name IN ('Свекла','Чеснок','Сметана','Соль','Сахар')
ON CONFLICT DO NOTHING;

-- 22. Морковь по-корейски
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Морковь по-корейски',
  'Маринованная морковь с чесноком и специями — пикантная закуска или гарнир.',
  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80',
  15, 'easy', 4, 80.00, TRUE, TRUE, 'asian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Морковь по-корейски'
  AND i.name IN ('Морковь','Чеснок','Соевый соус','Масло растительное','Уксус','Соль','Сахар','Перец черный','Кориандр')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Морковь натереть на корейской тёрке (длинными тонкими полосками). Посолить, оставить на 20 мин, затем слегка отжать."},
    {"step":2,"description":"Чеснок измельчить. Смешать уксус, сахар, соевый соус, перец и кориандр."},
    {"step":3,"description":"Масло раскалить на сковороде до лёгкого дымка. Залить горячим маслом морковь с чесноком — должно шипеть."},
    {"step":4,"description":"Добавить маринад, тщательно перемешать. Убрать в холодильник на 2–4 часа для маринования."}]'
FROM dishes d WHERE d.name = 'Морковь по-корейски';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Морковь'           THEN 4   WHEN 'Чеснок'            THEN 3
    WHEN 'Соевый соус'       THEN 2   WHEN 'Масло растительное' THEN 3
    WHEN 'Уксус'             THEN 1   WHEN 'Соль'              THEN 1
    WHEN 'Сахар'             THEN 1   WHEN 'Перец черный'      THEN 0.5
    WHEN 'Кориандр'          THEN 1
  END,
  CASE i.name
    WHEN 'Морковь'           THEN 'шт'   WHEN 'Чеснок'            THEN 'зуб.'
    WHEN 'Соевый соус'       THEN 'ст.л.' WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Уксус'             THEN 'ст.л.' WHEN 'Соль'              THEN 'ч.л.'
    WHEN 'Сахар'             THEN 'ч.л.' WHEN 'Перец черный'      THEN 'ч.л.'
    WHEN 'Кориандр'          THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Морковь по-корейски'
  AND i.name IN ('Морковь','Чеснок','Соевый соус','Масло растительное','Уксус','Соль','Сахар','Перец черный','Кориандр')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 9: Супы
-- ============================================================

-- 23. Гороховый суп со свининой
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Гороховый суп со свининой',
  'Густой наваристый суп из гороха со свининой и копчёностями.',
  'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80',
  100, 'medium', 6, 300.00, FALSE, FALSE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гороховый суп со свининой'
  AND i.name IN ('Горох','Свинина','Картофель','Морковь','Лук','Масло растительное','Соль','Перец черный','Лавровый лист','Укроп')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Горох замочить на 4–6 часов или на ночь. Слить воду."},
    {"step":2,"description":"Свинину залить 2,5 л воды, довести до кипения, снять пену. Варить 40 мин."},
    {"step":3,"description":"Добавить замоченный горох, варить ещё 30–40 мин до мягкости."},
    {"step":4,"description":"Картофель нарезать кубиками, добавить в суп, варить 10 мин."},
    {"step":5,"description":"Лук и морковь обжарить на масле, добавить в суп. Посолить, добавить лавровый лист."},
    {"step":6,"description":"Мясо вынуть, нарезать кусочками, вернуть. Варить ещё 5 мин. Подавать с укропом."}]'
FROM dishes d WHERE d.name = 'Гороховый суп со свининой';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Горох'             THEN 300 WHEN 'Свинина'           THEN 400
    WHEN 'Картофель'         THEN 3   WHEN 'Морковь'           THEN 1
    WHEN 'Лук'               THEN 1   WHEN 'Масло растительное' THEN 2
    WHEN 'Соль'              THEN 1.5 WHEN 'Перец черный'      THEN 0.5
    WHEN 'Лавровый лист'     THEN 2   WHEN 'Укроп'             THEN 15
  END,
  CASE i.name
    WHEN 'Горох'             THEN 'г'    WHEN 'Свинина'           THEN 'г'
    WHEN 'Картофель'         THEN 'шт'   WHEN 'Морковь'           THEN 'шт'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'              THEN 'ч.л.' WHEN 'Перец черный'      THEN 'ч.л.'
    WHEN 'Лавровый лист'     THEN 'шт'   WHEN 'Укроп'             THEN 'г'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гороховый суп со свининой'
  AND i.name IN ('Горох','Свинина','Картофель','Морковь','Лук','Масло растительное','Соль','Перец черный','Лавровый лист','Укроп')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУППА 10: Запеканки и разное
-- ============================================================

-- 24. Запеканка картофельная с фаршем
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Запеканка картофельная с фаршем',
  'Слоистая запеканка из картофеля и мясного фарша с сырной корочкой.',
  'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=520&fit=crop&q=80',
  70, 'medium', 6, 400.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Запеканка картофельная с фаршем'
  AND i.name IN ('Картофель','Фарш','Лук','Сыр','Яйца','Молоко','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Картофель нарезать тонкими ломтиками. Лук нарезать мелко."},
    {"step":2,"description":"Фарш обжарить с луком до готовности, посолить и поперчить."},
    {"step":3,"description":"Форму смазать маслом. Выложить половину картофеля, посолить. Сверху — весь фарш с луком."},
    {"step":4,"description":"Накрыть оставшимся картофелем. Взбить яйца с молоком, посолить. Залить запеканку."},
    {"step":5,"description":"Посыпать тёртым сыром. Запекать при 180°C 45–50 мин до готовности картофеля и румяной корочки."}]'
FROM dishes d WHERE d.name = 'Запеканка картофельная с фаршем';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Картофель'         THEN 6   WHEN 'Фарш'              THEN 400
    WHEN 'Лук'               THEN 2   WHEN 'Сыр'               THEN 150
    WHEN 'Яйца'              THEN 2   WHEN 'Молоко'            THEN 150
    WHEN 'Масло сливочное'   THEN 20  WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5
  END,
  CASE i.name
    WHEN 'Картофель'         THEN 'шт'   WHEN 'Фарш'              THEN 'г'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Сыр'               THEN 'г'
    WHEN 'Яйца'              THEN 'шт'   WHEN 'Молоко'            THEN 'мл'
    WHEN 'Масло сливочное'   THEN 'г'    WHEN 'Соль'              THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Запеканка картофельная с фаршем'
  AND i.name IN ('Картофель','Фарш','Лук','Сыр','Яйца','Молоко','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- 25. Суп из чечевицы
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Суп из чечевицы',
  'Насыщенный суп из красной чечевицы с морковью и специями — быстро и питательно.',
  'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80',
  35, 'easy', 4, 150.00, TRUE, TRUE, 'other', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп из чечевицы'
  AND i.name IN ('Чечевица','Морковь','Лук','Чеснок','Помидоры','Томатная паста','Масло растительное','Соль','Перец черный','Кумин')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Чечевицу промыть. Лук и морковь нарезать кубиками, чеснок измельчить."},
    {"step":2,"description":"Обжарить лук на масле 3 мин, добавить морковь, жарить ещё 3 мин. Добавить чеснок и кумин, жарить 1 мин."},
    {"step":3,"description":"Добавить помидоры и томатную пасту, потушить 3–4 мин."},
    {"step":4,"description":"Всыпать чечевицу, влить 1,5 л воды. Посолить, поперчить. Варить 20–25 мин до мягкости чечевицы."},
    {"step":5,"description":"Часть супа можно пробить блендером для кремовой текстуры. Подавать с зеленью и лимоном."}]'
FROM dishes d WHERE d.name = 'Суп из чечевицы';

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Чечевица'          THEN 250 WHEN 'Морковь'           THEN 2
    WHEN 'Лук'               THEN 1   WHEN 'Чеснок'            THEN 3
    WHEN 'Помидоры'          THEN 2   WHEN 'Томатная паста'    THEN 1
    WHEN 'Масло растительное' THEN 2  WHEN 'Соль'              THEN 1
    WHEN 'Перец черный'      THEN 0.5 WHEN 'Кумин'             THEN 1
  END,
  CASE i.name
    WHEN 'Чечевица'          THEN 'г'    WHEN 'Морковь'           THEN 'шт'
    WHEN 'Лук'               THEN 'шт'   WHEN 'Чеснок'            THEN 'зуб.'
    WHEN 'Помидоры'          THEN 'шт'   WHEN 'Томатная паста'    THEN 'ст.л.'
    WHEN 'Масло растительное' THEN 'ст.л.' WHEN 'Соль'            THEN 'ч.л.'
    WHEN 'Перец черный'      THEN 'ч.л.' WHEN 'Кумин'             THEN 'ч.л.'
  END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп из чечевицы'
  AND i.name IN ('Чечевица','Морковь','Лук','Чеснок','Помидоры','Томатная паста','Масло растительное','Соль','Перец черный','Кумин')
ON CONFLICT DO NOTHING;
-- ============================================================
-- Migration 013: Комплексный фикс изображений всех блюд
-- Устанавливаем правильные Unsplash-фото для каждого блюда по названию
-- Порядок UPDATE-ов: от специфичных к общим, чтобы не перезаписывать
-- ============================================================

-- ============================================================
-- Яичные блюда
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%яичниц%' OR name ILIKE '%глазунь%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%яйца бенедикт%' OR name ILIKE '%яйца пашот%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%омлет%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1582169296194-e4d644c48063?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%вареные яйца%' OR name ILIKE '%яйца вареные%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%яичница%' OR name ILIKE '%яичниц%';

-- ============================================================
-- Супы
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%борщ%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%щи%' OR name ILIKE '%солянка%' OR name ILIKE '%харчо%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%рассольник%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%суп%' OR name ILIKE '%уха%' OR name ILIKE '%бульон%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%окрошк%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%газпачо%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%фо бо%' OR name ILIKE '%рамен%' OR name ILIKE '%мисо%';

-- ============================================================
-- Паста / лапша / макароны
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%паста%' OR name ILIKE '%спагетти%' OR name ILIKE '%феттучин%'
   OR name ILIKE '%карбонар%' OR name ILIKE '%болонь%' OR name ILIKE '%лазань%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%макарон%' OR name ILIKE '%лапш%' OR name ILIKE '%вермишел%' OR name ILIKE '%лагман%';

-- ============================================================
-- Пицца
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%пицц%';

-- ============================================================
-- Курица
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1598103442097-8b74394b95c3?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%курица%' OR name ILIKE '%куриц%' OR name ILIKE '%цыплёнок%' OR name ILIKE '%цыпл%';

-- ============================================================
-- Котлеты / тефтели / мясные блюда
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%котлет%' OR name ILIKE '%биток%' OR name ILIKE '%фрикадел%'
   OR name ILIKE '%тефтел%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%бефстроганов%';

-- ============================================================
-- Стейк / мясо гриль
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%стейк%' OR name ILIKE '%шашлык%' OR name ILIKE '%гриль%' OR name ILIKE '%барбекю%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%говядин%' OR name ILIKE '%свинин%';

-- ============================================================
-- Плов / рис
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%плов%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%ризотто%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80'
WHERE (name ILIKE '%рис%' OR name ILIKE '%рисов%') AND name NOT ILIKE '%ризотто%';

-- ============================================================
-- Паэлья
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534080564583-6be75777b70a?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%паэл%';

-- ============================================================
-- Картофель / пюре / запеканка
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%картоф%' OR name ILIKE '%пюре%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%запеканк%' AND (name ILIKE '%картоф%' OR name ILIKE '%мясо%' OR name ILIKE '%фарш%');

-- ============================================================
-- Рыба / морепродукты
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%сёмг%' OR name ILIKE '%семг%' OR name ILIKE '%лосос%' OR name ILIKE '%форел%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%рыб%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%суши%' OR name ILIKE '%ролл%';

-- ============================================================
-- Блины / оладьи / драники
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299543923-37dd37887442?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%блин%' OR name ILIKE '%оладь%' OR name ILIKE '%панкейк%' OR name ILIKE '%драник%';

-- ============================================================
-- Каши
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%каша%' OR name ILIKE '%овсян%' OR name ILIKE '%гречн%' OR name ILIKE '%манн%'
   OR name ILIKE '%пшённ%' OR name ILIKE '%гречк%';

-- ============================================================
-- Салаты
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%салат%';

-- ============================================================
-- Пельмени / вареники / хинкали
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%пельмен%' OR name ILIKE '%вареник%' OR name ILIKE '%манты%' OR name ILIKE '%хинкал%';

-- ============================================================
-- Голубцы / тушёная капуста
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%голубц%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%капуст%' AND (name ILIKE '%туш%' OR name ILIKE '%морков%');

-- ============================================================
-- Жульен
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1604152135912-04a022e23696?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%жульен%';

-- ============================================================
-- Хумус / дип
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1517191434949-5e90cd67d2b6?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%хумус%';

-- ============================================================
-- Авокадо тост
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1541519227354-08fa5d50c820?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%авокадо%';

-- ============================================================
-- Тосты / бутерброды / сэндвичи
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1484723091739-30990ca54c6b?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%тост%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1481070414801-51fd732d7184?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%бутерброд%' OR name ILIKE '%сэндвич%';

-- ============================================================
-- Творог / сырники / запеканка творожная
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%сырник%' OR name ILIKE '%творог%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%запеканк%' AND name ILIKE '%творог%';

-- ============================================================
-- Десерты / выпечка
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%чизкейк%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%медовик%' OR name ILIKE '%торт%' OR name ILIKE '%кекс%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%панна%' OR name ILIKE '%желе%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%пирог%' OR name ILIKE '%пирожк%';

-- ============================================================
-- Рагу / овощные блюда
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%рагу%' OR name ILIKE '%рататуй%';

-- ============================================================
-- Бургеры / тако / мексика
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%бургер%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%тако%' OR name ILIKE '%бурито%';

-- ============================================================
-- Яйца Бенедикт (переопределяем после общего яиц)
-- ============================================================
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%бенедикт%';

-- Финальная проверка: блюда без изображения получают дефолтное красивое фото еды
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=520&fit=crop&q=80'
WHERE image_url IS NULL OR image_url = '';
