-- Migration 010: расширение базы рецептов
-- 17 новых блюд: русские классики, салаты, десерты, завтраки, средиземноморская, азиатская кухня
-- Ожидаемый результат: ~148 блюд / ~165 рецептов

-- ============================================================
-- Новые ингредиенты
-- ============================================================
INSERT INTO ingredients (name, category) VALUES
  ('Ванилин',         'spices'),
  ('Кумин',           'spices'),
  ('Шафран',          'spices'),
  ('Бадьян',          'spices'),
  ('Кардамон',        'spices'),
  ('Гвоздика',        'spices'),
  ('Тахини',          'other'),
  ('Кунжут',          'other'),
  ('Желатин',         'other'),
  ('Рыбный соус',     'other'),
  ('Сахарная пудра',  'other'),
  ('Сода',            'other'),
  ('Печенье',         'cereals'),
  ('Креветки',        'meat'),
  ('Мидии',           'meat'),
  ('Кальмары',        'meat')
ON CONFLICT (name) DO NOTHING;

-- ============================================================
-- 1. Бефстроганов
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Бефстроганов',
  'Классическое русское блюдо — нежная говядина в сметанно-томатном соусе. Подаётся с картофелем или рисом.',
  'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=520&fit=crop&q=80',
  60, 'medium', 4, 600.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Бефстроганов'
  AND i.name IN ('Говядина','Лук','Сметана','Томатная паста','Мука','Масло сливочное','Масло растительное','Соль','Перец черный','Лавровый лист')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Говядину нарезать поперёк волокон ломтиками 1 см, отбить и нарезать полосками 0,5 см. Посолить и поперчить."},
    {"step":2,"description":"Лук нарезать полукольцами, обжарить на сливочном масле до золотистого цвета (5–7 мин), переложить."},
    {"step":3,"description":"Сковороду раскалить до высокой температуры, обжарить полоски говядины в один слой по 1–2 мин с каждой стороны."},
    {"step":4,"description":"Присыпать мясо мукой, перемешать и жарить ещё 1–2 минуты."},
    {"step":5,"description":"Добавить обжаренный лук, влить 200 мл воды или бульона, перемешать."},
    {"step":6,"description":"Добавить томатную пасту и сметану, перемешать до однородного соуса."},
    {"step":7,"description":"Тушить под крышкой на среднем огне 15–20 минут до мягкости мяса."},
    {"step":8,"description":"Добавить лавровый лист, проверить на соль. Перед подачей лавровый лист убрать. Подавать с картофелем или рисом."}]'
FROM dishes d WHERE d.name = 'Бефстроганов'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Говядина'           THEN 600
    WHEN 'Лук'                THEN 2
    WHEN 'Сметана'            THEN 200
    WHEN 'Томатная паста'     THEN 1
    WHEN 'Мука'               THEN 2
    WHEN 'Масло сливочное'    THEN 50
    WHEN 'Масло растительное' THEN 2
    WHEN 'Соль'               THEN 1
    WHEN 'Перец черный'       THEN 0.5
    WHEN 'Лавровый лист'      THEN 2
  END,
  CASE i.name
    WHEN 'Говядина'           THEN 'г'
    WHEN 'Лук'                THEN 'шт'
    WHEN 'Сметана'            THEN 'г'
    WHEN 'Томатная паста'     THEN 'ст.л.'
    WHEN 'Мука'               THEN 'ст.л.'
    WHEN 'Масло сливочное'    THEN 'г'
    WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'               THEN 'ч.л.'
    WHEN 'Перец черный'       THEN 'ч.л.'
    WHEN 'Лавровый лист'      THEN 'шт'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Бефстроганов'
  AND i.name IN ('Говядина','Лук','Сметана','Томатная паста','Мука','Масло сливочное','Масло растительное','Соль','Перец черный','Лавровый лист')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 2. Рассольник
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Рассольник',
  'Наваристый русский суп с перловой крупой, солёными огурцами и говядиной. Подаётся со сметаной.',
  'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80',
  90, 'medium', 4, 250.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рассольник'
  AND i.name IN ('Говядина','Перловка','Картофель','Морковь','Лук','Огурцы','Томатная паста','Масло растительное','Соль','Перец черный','Лавровый лист','Петрушка','Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Перловку промыть и замочить в холодной воде на 1 час. Говядину залить 2 л холодной воды, довести до кипения, снять пену."},
    {"step":2,"description":"Варить говядину 40–50 мин. Мясо вынуть, бульон процедить. В кипящий бульон добавить перловку, варить 20 минут."},
    {"step":3,"description":"Картофель нарезать кубиками, добавить в суп, варить 10 минут."},
    {"step":4,"description":"Лук нарезать мелко, морковь натереть на тёрке. Обжарить на масле 5–7 мин, добавить томатную пасту, жарить 2 мин."},
    {"step":5,"description":"Огурцы нарезать кубиками, добавить к зажарке, тушить 3–4 минуты. Переложить зажарку в суп."},
    {"step":6,"description":"Мясо снять с кости, нарезать кусочками, вернуть в суп. Добавить лавровый лист и перец."},
    {"step":7,"description":"Посолить по вкусу, варить ещё 5–7 минут. Подавать с петрушкой и сметаной."}]'
FROM dishes d WHERE d.name = 'Рассольник'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Говядина'           THEN 400
    WHEN 'Перловка'           THEN 80
    WHEN 'Картофель'          THEN 3
    WHEN 'Морковь'            THEN 1
    WHEN 'Лук'                THEN 1
    WHEN 'Огурцы'             THEN 3
    WHEN 'Томатная паста'     THEN 1
    WHEN 'Масло растительное' THEN 2
    WHEN 'Соль'               THEN 1
    WHEN 'Перец черный'       THEN 0.25
    WHEN 'Лавровый лист'      THEN 2
    WHEN 'Петрушка'           THEN 20
    WHEN 'Сметана'            THEN 100
  END,
  CASE i.name
    WHEN 'Говядина'           THEN 'г'
    WHEN 'Перловка'           THEN 'г'
    WHEN 'Картофель'          THEN 'шт'
    WHEN 'Морковь'            THEN 'шт'
    WHEN 'Лук'                THEN 'шт'
    WHEN 'Огурцы'             THEN 'шт'
    WHEN 'Томатная паста'     THEN 'ст.л.'
    WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'               THEN 'ч.л.'
    WHEN 'Перец черный'       THEN 'ч.л.'
    WHEN 'Лавровый лист'      THEN 'шт'
    WHEN 'Петрушка'           THEN 'г'
    WHEN 'Сметана'            THEN 'г'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рассольник'
  AND i.name IN ('Говядина','Перловка','Картофель','Морковь','Лук','Огурцы','Томатная паста','Масло растительное','Соль','Перец черный','Лавровый лист','Петрушка','Сметана')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 3. Вареники с картофелем
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Вареники с картофелем',
  'Украинские вареники с нежной картофельной начинкой и жареным луком. Подаются со сметаной.',
  'https://images.unsplash.com/photo-1565299543923-37dd37887442?w=400&h=520&fit=crop&q=80',
  75, 'medium', 4, 150.00, TRUE, FALSE, 'eastern_european', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Вареники с картофелем'
  AND i.name IN ('Мука','Яйца','Масло растительное','Соль','Картофель','Лук','Масло сливочное','Перец черный','Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Замесить тесто: муку смешать с солью (1 ч.л.), добавить яйцо, масло растительное и 180 мл горячей воды. Вымесить до гладкости, завернуть в плёнку на 30 минут."},
    {"step":2,"description":"Картофель очистить, сварить в подсоленной воде до мягкости (20 мин). Воду слить."},
    {"step":3,"description":"Один лук нарезать мелко, обжарить на сливочном масле до золотого цвета. Добавить к картофелю."},
    {"step":4,"description":"Размять картофель с луком в пюре, посолить и поперчить. Остудить."},
    {"step":5,"description":"Тесто раскатать до 2–3 мм, стаканом вырезать кружки диаметром ~7 см."},
    {"step":6,"description":"На каждый кружок выложить 1 ч.л. начинки, сложить пополам, плотно защипнуть края."},
    {"step":7,"description":"Варить вареники в кипящей подсоленной воде 3–4 минуты после всплытия."},
    {"step":8,"description":"Второй лук нарезать кольцами, обжарить на сливочном масле — для подачи. Полить вареники жареным луком со сметаной."}]'
FROM dishes d WHERE d.name = 'Вареники с картофелем'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Мука'               THEN 400
    WHEN 'Яйца'               THEN 1
    WHEN 'Масло растительное' THEN 1
    WHEN 'Соль'               THEN 1.5
    WHEN 'Картофель'          THEN 600
    WHEN 'Лук'                THEN 2
    WHEN 'Масло сливочное'    THEN 60
    WHEN 'Перец черный'       THEN 0.5
    WHEN 'Сметана'            THEN 150
  END,
  CASE i.name
    WHEN 'Мука'               THEN 'г'
    WHEN 'Яйца'               THEN 'шт'
    WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'               THEN 'ч.л.'
    WHEN 'Картофель'          THEN 'г'
    WHEN 'Лук'                THEN 'шт'
    WHEN 'Масло сливочное'    THEN 'г'
    WHEN 'Перец черный'       THEN 'ч.л.'
    WHEN 'Сметана'            THEN 'г'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Вареники с картофелем'
  AND i.name IN ('Мука','Яйца','Масло растительное','Соль','Картофель','Лук','Масло сливочное','Перец черный','Сметана')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 4. Драники
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Драники',
  'Белорусские картофельные оладьи с хрустящей корочкой. Подаются горячими со сметаной.',
  'https://images.unsplash.com/photo-1559847844-5315695dadae?w=400&h=520&fit=crop&q=80',
  40, 'easy', 4, 100.00, TRUE, FALSE, 'eastern_european', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Драники'
  AND i.name IN ('Картофель','Лук','Яйца','Мука','Соль','Перец черный','Масло растительное','Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'По-белорусски',
  '[{"step":1,"description":"Картофель и лук очистить, натереть на мелкой тёрке. Лук добавляют сразу — это предотвращает потемнение картофеля."},
    {"step":2,"description":"Массу откинуть на сито или марлю, хорошо отжать лишний сок."},
    {"step":3,"description":"В отжатую массу добавить яйцо, муку, соль, перец. Перемешать."},
    {"step":4,"description":"Сковороду разогреть на среднем огне, влить масло слоем 3–4 мм."},
    {"step":5,"description":"Ложкой выкладывать порции теста, разравнивая до круглой формы ~8 см."},
    {"step":6,"description":"Жарить 3–4 минуты до золотистой корочки, перевернуть, жарить ещё 3–4 минуты."},
    {"step":7,"description":"Выкладывать на бумажное полотенце. Подавать горячими со сметаной."}]'
FROM dishes d WHERE d.name = 'Драники'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Картофель'          THEN 1000
    WHEN 'Лук'                THEN 1
    WHEN 'Яйца'               THEN 1
    WHEN 'Мука'               THEN 3
    WHEN 'Соль'               THEN 1
    WHEN 'Перец черный'       THEN 0.25
    WHEN 'Масло растительное' THEN 80
    WHEN 'Сметана'            THEN 200
  END,
  CASE i.name
    WHEN 'Картофель'          THEN 'г'
    WHEN 'Лук'                THEN 'шт'
    WHEN 'Яйца'               THEN 'шт'
    WHEN 'Мука'               THEN 'ст.л.'
    WHEN 'Соль'               THEN 'ч.л.'
    WHEN 'Перец черный'       THEN 'ч.л.'
    WHEN 'Масло растительное' THEN 'мл'
    WHEN 'Сметана'            THEN 'г'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Драники'
  AND i.name IN ('Картофель','Лук','Яйца','Мука','Соль','Перец черный','Масло растительное','Сметана')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 5. Салат Оливье
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Салат Оливье',
  'Главный салат российского застолья — картофель, яйца, колбаса и горошек под майонезом.',
  'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80',
  45, 'easy', 4, 300.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Салат Оливье'
  AND i.name IN ('Колбаса','Картофель','Морковь','Яйца','Огурцы','Горошек','Лук','Майонез','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Картофель и морковь сварить в мундире в подсоленной воде (картофель 20–25 мин, морковь 25–30 мин). Остудить, очистить."},
    {"step":2,"description":"Яйца сварить вкрутую (10 мин), остудить в холодной воде, очистить."},
    {"step":3,"description":"Все ингредиенты нарезать аккуратными кубиками 5–7 мм: картофель, морковь, яйца, колбасу, огурцы."},
    {"step":4,"description":"Лук нарезать очень мелко. Горошек откинуть на дуршлаг."},
    {"step":5,"description":"Смешать все ингредиенты с майонезом, посолить и поперчить по вкусу."},
    {"step":6,"description":"Убрать в холодильник минимум на 1 час. Перед подачей перемешать."}]'
FROM dishes d WHERE d.name = 'Салат Оливье'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Колбаса'      THEN 300
    WHEN 'Картофель'    THEN 3
    WHEN 'Морковь'      THEN 2
    WHEN 'Яйца'         THEN 4
    WHEN 'Огурцы'       THEN 3
    WHEN 'Горошек'      THEN 200
    WHEN 'Лук'          THEN 0.5
    WHEN 'Майонез'      THEN 150
    WHEN 'Соль'         THEN 0.5
    WHEN 'Перец черный' THEN 0.25
  END,
  CASE i.name
    WHEN 'Колбаса'      THEN 'г'
    WHEN 'Картофель'    THEN 'шт'
    WHEN 'Морковь'      THEN 'шт'
    WHEN 'Яйца'         THEN 'шт'
    WHEN 'Огурцы'       THEN 'шт'
    WHEN 'Горошек'      THEN 'г'
    WHEN 'Лук'          THEN 'шт'
    WHEN 'Майонез'      THEN 'г'
    WHEN 'Соль'         THEN 'ч.л.'
    WHEN 'Перец черный' THEN 'ч.л.'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Салат Оливье'
  AND i.name IN ('Колбаса','Картофель','Морковь','Яйца','Огурцы','Горошек','Лук','Майонез','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 6. Медовик
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Медовик',
  'Легендарный советский медовый торт из тонких коржей на водяной бане со сметанным кремом.',
  'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=520&fit=crop&q=80',
  120, 'hard', 8, 400.00, TRUE, FALSE, 'russian', 'snack')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Медовик'
  AND i.name IN ('Мёд','Сахар','Масло сливочное','Яйца','Сода','Мука','Сметана','Сахарная пудра')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический советский',
  '[{"step":1,"description":"На водяной бане растопить 100 г масла, добавить 3 ст.л. мёда и 200 г сахара. Помешивая, растворить сахар (3–5 мин), не доводя до кипения."},
    {"step":2,"description":"Снять с огня, добавить 1,5 ч.л. соды — масса побелеет и увеличится. Дать остыть до тёплого."},
    {"step":3,"description":"По одному ввести 3 яйца, каждый раз тщательно перемешивая."},
    {"step":4,"description":"Постепенно ввести просеянные 500 г муки, замесить мягкое тесто. Разделить на 8 частей, убрать в холодильник на 30 минут."},
    {"step":5,"description":"Каждую часть раскатать до 2 мм на пергаменте, вырезать круг 22 см. Обрезки сохранить."},
    {"step":6,"description":"Выпекать каждый корж при 180°C 4–5 минут до золотистого цвета. Остудить. Обрезки тоже запечь."},
    {"step":7,"description":"Взбить 700 г сметаны с 150 г сахарной пудры до загустения."},
    {"step":8,"description":"Собрать торт: промазать каждый корж кремом, сложить стопкой. Покрыть кремом верх и бока."},
    {"step":9,"description":"Запечённые обрезки измельчить в крошку, обсыпать торт. Убрать в холодильник минимум на 8 часов."}]'
FROM dishes d WHERE d.name = 'Медовик'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Мёд'             THEN 3
    WHEN 'Сахар'           THEN 200
    WHEN 'Масло сливочное' THEN 100
    WHEN 'Яйца'            THEN 3
    WHEN 'Сода'            THEN 1.5
    WHEN 'Мука'            THEN 500
    WHEN 'Сметана'         THEN 700
    WHEN 'Сахарная пудра'  THEN 150
  END,
  CASE i.name
    WHEN 'Мёд'             THEN 'ст.л.'
    WHEN 'Сахар'           THEN 'г'
    WHEN 'Масло сливочное' THEN 'г'
    WHEN 'Яйца'            THEN 'шт'
    WHEN 'Сода'            THEN 'ч.л.'
    WHEN 'Мука'            THEN 'г'
    WHEN 'Сметана'         THEN 'г'
    WHEN 'Сахарная пудра'  THEN 'г'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Медовик'
  AND i.name IN ('Мёд','Сахар','Масло сливочное','Яйца','Сода','Мука','Сметана','Сахарная пудра')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 7. Блинчики с мясом
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Блинчики с мясом',
  'Тонкие русские блины с сочной мясной начинкой из говяжьего фарша с луком, обжаренные до румяной корочки.',
  'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400&h=520&fit=crop&q=80',
  75, 'medium', 4, 350.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Блинчики с мясом'
  AND i.name IN ('Молоко','Мука','Яйца','Масло растительное','Соль','Сахар','Фарш','Лук','Масло сливочное','Перец черный','Укроп','Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Яйца взбить с 1 ч.л. соли и 1 ч.л. сахара, добавить 500 мл молока, 200 г муки и 2 ст.л. масла. Перемешать до однородности, дать постоять 15 минут."},
    {"step":2,"description":"Выпекать тонкие блины на горячей сковороде по 1–2 мин с каждой стороны. Выйдет 12–14 блинов."},
    {"step":3,"description":"Лук нарезать мелко, обжарить на сливочном масле до мягкости (5 мин)."},
    {"step":4,"description":"Добавить фарш к луку, разбить комки. Обжаривать 8–10 минут до готовности. Посолить, поперчить, добавить рубленый укроп. Остудить."},
    {"step":5,"description":"На каждый блин выложить 1,5–2 ст.л. начинки, завернуть конвертом: подогнуть боковые края, затем свернуть рулетом."},
    {"step":6,"description":"Обжарить блинчики на сковороде с маслом по 2 мин с каждой стороны до румяной корочки."},
    {"step":7,"description":"Подавать горячими со сметаной."}]'
FROM dishes d WHERE d.name = 'Блинчики с мясом'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Молоко'             THEN 500
    WHEN 'Мука'               THEN 200
    WHEN 'Яйца'               THEN 3
    WHEN 'Масло растительное' THEN 3
    WHEN 'Соль'               THEN 1
    WHEN 'Сахар'              THEN 1
    WHEN 'Фарш'               THEN 500
    WHEN 'Лук'                THEN 2
    WHEN 'Масло сливочное'    THEN 30
    WHEN 'Перец черный'       THEN 0.5
    WHEN 'Укроп'              THEN 20
    WHEN 'Сметана'            THEN 150
  END,
  CASE i.name
    WHEN 'Молоко'             THEN 'мл'
    WHEN 'Мука'               THEN 'г'
    WHEN 'Яйца'               THEN 'шт'
    WHEN 'Масло растительное' THEN 'ст.л.'
    WHEN 'Соль'               THEN 'ч.л.'
    WHEN 'Сахар'              THEN 'ч.л.'
    WHEN 'Фарш'               THEN 'г'
    WHEN 'Лук'                THEN 'шт'
    WHEN 'Масло сливочное'    THEN 'г'
    WHEN 'Перец черный'       THEN 'ч.л.'
    WHEN 'Укроп'              THEN 'г'
    WHEN 'Сметана'            THEN 'г'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Блинчики с мясом'
  AND i.name IN ('Молоко','Мука','Яйца','Масло растительное','Соль','Сахар','Фарш','Лук','Масло сливочное','Перец черный','Укроп','Сметана')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 8. Греческий салат
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Греческий салат',
  'Традиционный средиземноморский салат хориатики: помидоры, огурцы, маслины, брынза и оливковое масло.',
  'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=520&fit=crop&q=80',
  15, 'easy', 4, 350.00, TRUE, FALSE, 'mediterranean', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Греческий салат'
  AND i.name IN ('Помидоры','Огурцы','Перец болгарский','Оливки','Фета','Оливковое масло','Уксус','Орегано','Лук')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Традиционный хориатики',
  '[{"step":1,"description":"Помидоры нарезать крупными дольками, огурцы — полукольцами толщиной 1 см."},
    {"step":2,"description":"Лук нарезать тонкими кольцами. Перец — полосками."},
    {"step":3,"description":"Смешать овощи в миске с маслинами."},
    {"step":4,"description":"Заправить оливковым маслом, красным винным уксусом, посыпать орегано и солью."},
    {"step":5,"description":"Сверху положить блок феты целиком (не крошить). Полить маслом и посыпать орегано. Подавать немедленно."}]'
FROM dishes d WHERE d.name = 'Греческий салат'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Помидоры'         THEN 4
    WHEN 'Огурцы'           THEN 2
    WHEN 'Перец болгарский' THEN 1
    WHEN 'Оливки'           THEN 100
    WHEN 'Фета'             THEN 200
    WHEN 'Оливковое масло'  THEN 60
    WHEN 'Уксус'            THEN 1
    WHEN 'Орегано'          THEN 1
    WHEN 'Лук'              THEN 1
  END,
  CASE i.name
    WHEN 'Помидоры'         THEN 'шт'
    WHEN 'Огурцы'           THEN 'шт'
    WHEN 'Перец болгарский' THEN 'шт'
    WHEN 'Оливки'           THEN 'г'
    WHEN 'Фета'             THEN 'г'
    WHEN 'Оливковое масло'  THEN 'мл'
    WHEN 'Уксус'            THEN 'ст.л.'
    WHEN 'Орегано'          THEN 'ч.л.'
    WHEN 'Лук'              THEN 'шт'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Греческий салат'
  AND i.name IN ('Помидоры','Огурцы','Перец болгарский','Оливки','Фета','Оливковое масло','Уксус','Орегано','Лук')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 9. Салат Цезарь с курицей
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Салат Цезарь с курицей',
  'Хрустящий романо с куриным филе на гриле, гренками и соусом Цезарь с пармезаном.',
  'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=400&h=520&fit=crop&q=80',
  30, 'medium', 4, 500.00, FALSE, FALSE, 'other', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Салат Цезарь с курицей'
  AND i.name IN ('Курица','Листья салата','Пармезан','Хлеб','Майонез','Чеснок','Лимон','Оливковое масло','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'С куриным филе на гриле',
  '[{"step":1,"description":"Хлеб нарезать кубиками 1,5 см, сбрызнуть оливковым маслом, посыпать тёртым пармезаном. Запекать при 180°C 12–15 мин до золотистого цвета."},
    {"step":2,"description":"Куриное филе посолить, поперчить. Обжарить на гриле или сковороде 5–6 мин с каждой стороны до готовности. Дать отдохнуть 3 мин, нарезать."},
    {"step":3,"description":"Приготовить заправку: майонез смешать с мелко натёртым чесноком, лимонным соком и 2 ст.л. тёртого пармезана. Посолить."},
    {"step":4,"description":"Листья романо нарвать руками, выложить в миску. Добавить заправку, перемешать."},
    {"step":5,"description":"Выложить на тарелку, добавить гренки и ломтики курицы. Посыпать пармезаном."}]'
FROM dishes d WHERE d.name = 'Салат Цезарь с курицей'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Курица'          THEN 600
    WHEN 'Листья салата'   THEN 2
    WHEN 'Пармезан'        THEN 80
    WHEN 'Хлеб'            THEN 4
    WHEN 'Майонез'         THEN 100
    WHEN 'Чеснок'          THEN 2
    WHEN 'Лимон'           THEN 0.5
    WHEN 'Оливковое масло' THEN 40
    WHEN 'Соль'            THEN 0.5
    WHEN 'Перец черный'    THEN 0.25
  END,
  CASE i.name
    WHEN 'Курица'          THEN 'г'
    WHEN 'Листья салата'   THEN 'головки'
    WHEN 'Пармезан'        THEN 'г'
    WHEN 'Хлеб'            THEN 'ломтя'
    WHEN 'Майонез'         THEN 'г'
    WHEN 'Чеснок'          THEN 'зубчика'
    WHEN 'Лимон'           THEN 'шт'
    WHEN 'Оливковое масло' THEN 'мл'
    WHEN 'Соль'            THEN 'ч.л.'
    WHEN 'Перец черный'    THEN 'ч.л.'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Салат Цезарь с курицей'
  AND i.name IN ('Курица','Листья салата','Пармезан','Хлеб','Майонез','Чеснок','Лимон','Оливковое масло','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 10. Панна котта
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Панна котта',
  'Нежный итальянский десерт из ванильных сливок с ягодным соусом — элегантно и просто.',
  'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=520&fit=crop&q=80',
  30, 'easy', 4, 250.00, TRUE, FALSE, 'italian', 'snack')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Панна котта'
  AND i.name IN ('Сливки','Молоко','Сахар','Желатин','Ванилин','Сахарная пудра')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классическая',
  '[{"step":1,"description":"Желатин залить 50 мл холодного молока, оставить набухать 10 минут."},
    {"step":2,"description":"Сливки смешать с оставшимся молоком, сахаром и ванилином. Нагреть на среднем огне до 80°C (не кипятить), помешивая."},
    {"step":3,"description":"Снять с огня, добавить набухший желатин. Перемешать до полного растворения."},
    {"step":4,"description":"Разлить по формочкам или стаканам. Остудить до комнатной температуры, затем убрать в холодильник на 4–6 часов."},
    {"step":5,"description":"Приготовить ягодный соус: ягоды взбить блендером с сахарной пудрой."},
    {"step":6,"description":"Подавать прямо в стакане или аккуратно перевернуть на тарелку. Полить ягодным соусом."}]'
FROM dishes d WHERE d.name = 'Панна котта'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Сливки'        THEN 500
    WHEN 'Молоко'        THEN 250
    WHEN 'Сахар'         THEN 80
    WHEN 'Желатин'       THEN 10
    WHEN 'Ванилин'       THEN 1
    WHEN 'Сахарная пудра'THEN 2
  END,
  CASE i.name
    WHEN 'Сливки'        THEN 'мл'
    WHEN 'Молоко'        THEN 'мл'
    WHEN 'Сахар'         THEN 'г'
    WHEN 'Желатин'       THEN 'г'
    WHEN 'Ванилин'       THEN 'ч.л.'
    WHEN 'Сахарная пудра'THEN 'ст.л.'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Панна котта'
  AND i.name IN ('Сливки','Молоко','Сахар','Желатин','Ванилин','Сахарная пудра')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 11. Авокадо тост
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Авокадо тост',
  'Трендовый завтрак: хрустящий цельнозерновой тост с кремом из спелого авокадо и помидорами черри.',
  'https://images.unsplash.com/photo-1603046891744-1f45a4f85ed1?w=400&h=520&fit=crop&q=80',
  10, 'easy', 2, 300.00, TRUE, TRUE, 'other', 'breakfast')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Авокадо тост'
  AND i.name IN ('Авокадо','Хлеб','Лимон','Чеснок','Оливковое масло','Помидоры черри','Перец черный','Соль','Кунжут')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Базовый',
  '[{"step":1,"description":"Хлеб поджарить в тостере или на сухой сковороде до хруста."},
    {"step":2,"description":"Тост немедленно натереть разрезанным зубчиком чеснока."},
    {"step":3,"description":"Авокадо разрезать, удалить косточку. Мякоть размять вилкой с лимонным соком, солью и перцем."},
    {"step":4,"description":"Намазать пасту из авокадо на горячий тост."},
    {"step":5,"description":"Помидоры черри разрезать пополам, выложить сверху."},
    {"step":6,"description":"Сбрызнуть оливковым маслом, посыпать кунжутом и щепоткой хлопьев чили (если есть). Подавать сразу."}]'
FROM dishes d WHERE d.name = 'Авокадо тост'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Авокадо'         THEN 3
    WHEN 'Хлеб'            THEN 4
    WHEN 'Лимон'           THEN 0.5
    WHEN 'Чеснок'          THEN 1
    WHEN 'Оливковое масло' THEN 1
    WHEN 'Помидоры черри'  THEN 100
    WHEN 'Перец черный'    THEN 0.25
    WHEN 'Соль'            THEN 0.5
    WHEN 'Кунжут'          THEN 1
  END,
  CASE i.name
    WHEN 'Авокадо'         THEN 'шт'
    WHEN 'Хлеб'            THEN 'ломтя'
    WHEN 'Лимон'           THEN 'шт'
    WHEN 'Чеснок'          THEN 'зубчик'
    WHEN 'Оливковое масло' THEN 'ст.л.'
    WHEN 'Помидоры черри'  THEN 'г'
    WHEN 'Перец черный'    THEN 'ч.л.'
    WHEN 'Соль'            THEN 'ч.л.'
    WHEN 'Кунжут'          THEN 'ч.л.'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Авокадо тост'
  AND i.name IN ('Авокадо','Хлеб','Лимон','Чеснок','Оливковое масло','Помидоры черри','Перец черный','Соль','Кунжут')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 12. Хумус домашний
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Хумус домашний',
  'Кремовый ближневосточный дип из нута с тахини, чесноком и лимоном — для хлеба и овощей.',
  'https://images.unsplash.com/photo-1561043433-aaf687c4cf04?w=400&h=520&fit=crop&q=80',
  20, 'easy', 4, 200.00, TRUE, TRUE, 'mediterranean', 'snack')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Хумус домашний'
  AND i.name IN ('Нут','Тахини','Чеснок','Лимон','Оливковое масло','Кумин','Паприка','Петрушка','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Нут (из банки) откинуть на дуршлаг, промыть. Оставить несколько ложек жидкости из банки."},
    {"step":2,"description":"В блендер: тахини, лимонный сок, чеснок, 2 ст.л. воды. Взбивать 1 минуту до посветления."},
    {"step":3,"description":"Добавить нут, кумин, соль. Взбивать 3–4 минуты, подливая жидкость от нута до получения пышной однородной массы."},
    {"step":4,"description":"Выложить в тарелку, сделать ложкой углубление. Полить оливковым маслом."},
    {"step":5,"description":"Посыпать паприкой и рубленой петрушкой. Подавать с питой или свежими овощами."}]'
FROM dishes d WHERE d.name = 'Хумус домашний'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Нут'             THEN 400
    WHEN 'Тахини'          THEN 60
    WHEN 'Чеснок'          THEN 2
    WHEN 'Лимон'           THEN 1
    WHEN 'Оливковое масло' THEN 40
    WHEN 'Кумин'           THEN 0.5
    WHEN 'Паприка'         THEN 0.5
    WHEN 'Петрушка'        THEN 10
    WHEN 'Соль'            THEN 0.5
  END,
  CASE i.name
    WHEN 'Нут'             THEN 'г'
    WHEN 'Тахини'          THEN 'г'
    WHEN 'Чеснок'          THEN 'зубчика'
    WHEN 'Лимон'           THEN 'шт'
    WHEN 'Оливковое масло' THEN 'мл'
    WHEN 'Кумин'           THEN 'ч.л.'
    WHEN 'Паприка'         THEN 'ч.л.'
    WHEN 'Петрушка'        THEN 'г'
    WHEN 'Соль'            THEN 'ч.л.'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Хумус домашний'
  AND i.name IN ('Нут','Тахини','Чеснок','Лимон','Оливковое масло','Кумин','Паприка','Петрушка','Соль')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 13. Газпачо
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Газпачо',
  'Освежающий холодный испанский суп из свежих томатов, огурцов и перца. Идеален летом.',
  'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=400&h=520&fit=crop&q=80',
  20, 'easy', 4, 300.00, TRUE, TRUE, 'mediterranean', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Газпачо'
  AND i.name IN ('Помидоры','Огурцы','Перец болгарский','Лук','Чеснок','Хлеб','Оливковое масло','Уксус','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Андалузский',
  '[{"step":1,"description":"Хлеб замочить в холодной воде на 5 минут, затем хорошо отжать."},
    {"step":2,"description":"Помидоры нарезать крупно, удалив плодоножку. Огурцы очистить, перец очистить от семян."},
    {"step":3,"description":"Все овощи, хлеб, чеснок, оливковое масло и уксус поместить в блендер."},
    {"step":4,"description":"Взбивать 2–3 минуты на максимальной скорости до однородности."},
    {"step":5,"description":"Протереть через мелкое сито для шелковистой текстуры. Посолить, поперчить."},
    {"step":6,"description":"Убрать в холодильник минимум на 3–4 часа. Подавать в холодных тарелках, сбрызнув маслом."}]'
FROM dishes d WHERE d.name = 'Газпачо'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Помидоры'         THEN 1000
    WHEN 'Огурцы'           THEN 2
    WHEN 'Перец болгарский' THEN 1
    WHEN 'Лук'              THEN 0.5
    WHEN 'Чеснок'           THEN 2
    WHEN 'Хлеб'             THEN 80
    WHEN 'Оливковое масло'  THEN 60
    WHEN 'Уксус'            THEN 2
    WHEN 'Соль'             THEN 1
    WHEN 'Перец черный'     THEN 0.25
  END,
  CASE i.name
    WHEN 'Помидоры'         THEN 'г'
    WHEN 'Огурцы'           THEN 'шт'
    WHEN 'Перец болгарский' THEN 'шт'
    WHEN 'Лук'              THEN 'шт'
    WHEN 'Чеснок'           THEN 'зубчика'
    WHEN 'Хлеб'             THEN 'г'
    WHEN 'Оливковое масло'  THEN 'мл'
    WHEN 'Уксус'            THEN 'ст.л.'
    WHEN 'Соль'             THEN 'ч.л.'
    WHEN 'Перец черный'     THEN 'ч.л.'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Газпачо'
  AND i.name IN ('Помидоры','Огурцы','Перец болгарский','Лук','Чеснок','Хлеб','Оливковое масло','Уксус','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 14. Паэлья с морепродуктами
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Паэлья с морепродуктами',
  'Испанская паэлья с креветками, мидиями и кальмарами на шафрановом рисе с socarrat.',
  'https://images.unsplash.com/photo-1534080564583-6be75777b70a?w=400&h=520&fit=crop&q=80',
  60, 'hard', 4, 800.00, FALSE, FALSE, 'mediterranean', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паэлья с морепродуктами'
  AND i.name IN ('Рис','Креветки','Мидии','Кальмары','Лук','Чеснок','Помидоры','Перец болгарский','Шафран','Паприка','Оливковое масло','Лимон','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Испанская',
  '[{"step":1,"description":"Шафран растворить в 50 мл горячей воды, оставить на 10 мин. Нагреть 800 мл рыбного бульона или воды с кубиком, держать горячим."},
    {"step":2,"description":"Разогреть оливковое масло в паэльере или широкой сковороде. Обжарить креветки и кальмары 1–2 мин (убрать). Обжарить мидии до открытия (убрать)."},
    {"step":3,"description":"В той же сковороде обжарить лук и чеснок 3 мин. Добавить перец и помидоры, тушить 5 мин."},
    {"step":4,"description":"Добавить паприку, всыпать рис, перемешать — обжаривать 2 мин."},
    {"step":5,"description":"Влить горячий бульон с шафраном. Посолить. Распределить ровно, НЕ ПЕРЕМЕШИВАТЬ. Варить на среднем огне 15–18 минут."},
    {"step":6,"description":"Разложить морепродукты сверху. Поднять огонь до сильного на 2 мин для образования хрустящей корочки (сокаррат)."},
    {"step":7,"description":"Снять с огня, накрыть фольгой на 5 мин. Подавать с дольками лимона."}]'
FROM dishes d WHERE d.name = 'Паэлья с морепродуктами'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Рис'              THEN 300
    WHEN 'Креветки'         THEN 300
    WHEN 'Мидии'            THEN 400
    WHEN 'Кальмары'         THEN 200
    WHEN 'Лук'              THEN 1
    WHEN 'Чеснок'           THEN 4
    WHEN 'Помидоры'         THEN 3
    WHEN 'Перец болгарский' THEN 1
    WHEN 'Шафран'           THEN 0.5
    WHEN 'Паприка'          THEN 1
    WHEN 'Оливковое масло'  THEN 60
    WHEN 'Лимон'            THEN 1
    WHEN 'Соль'             THEN 1
    WHEN 'Перец черный'     THEN 0.25
  END,
  CASE i.name
    WHEN 'Рис'              THEN 'г'
    WHEN 'Креветки'         THEN 'г'
    WHEN 'Мидии'            THEN 'г'
    WHEN 'Кальмары'         THEN 'г'
    WHEN 'Лук'              THEN 'шт'
    WHEN 'Чеснок'           THEN 'зубчика'
    WHEN 'Помидоры'         THEN 'шт'
    WHEN 'Перец болгарский' THEN 'шт'
    WHEN 'Шафран'           THEN 'ч.л.'
    WHEN 'Паприка'          THEN 'ч.л.'
    WHEN 'Оливковое масло'  THEN 'мл'
    WHEN 'Лимон'            THEN 'шт'
    WHEN 'Соль'             THEN 'ч.л.'
    WHEN 'Перец черный'     THEN 'ч.л.'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Паэлья с морепродуктами'
  AND i.name IN ('Рис','Креветки','Мидии','Кальмары','Лук','Чеснок','Помидоры','Перец болгарский','Шафран','Паприка','Оливковое масло','Лимон','Соль','Перец черный')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 15. Суп Фо бо
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Суп Фо бо',
  'Вьетнамский говяжий суп с рисовой лапшой на насыщенном пряном бульоне с анисом и корицей.',
  'https://images.unsplash.com/photo-1559628233-100c798642d7?w=400&h=520&fit=crop&q=80',
  180, 'hard', 4, 550.00, FALSE, FALSE, 'asian', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп Фо бо'
  AND i.name IN ('Говядина','Лапша','Лук','Имбирь','Бадьян','Корица','Гвоздика','Соль','Сахар','Лук зеленый','Перец чили','Лимон')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Аутентичный',
  '[{"step":1,"description":"Говяжьи кости (1 кг) залить холодной водой, довести до кипения, варить 3 мин. Воду слить, кости промыть — первичная варка убирает пену."},
    {"step":2,"description":"Лук и имбирь (5 см) обжечь прямо над огнём или в духовке под грилем до почернения корочки. Почернелое соскоблить."},
    {"step":3,"description":"Специи (бадьян, корицу, гвоздику) обжарить в сухой сковороде 1–2 мин до аромата, связать в марлю."},
    {"step":4,"description":"Кости залить 3 л воды, довести до кипения. Добавить лук, имбирь, мешочек со специями. Варить на медленном огне 2,5–3 часа."},
    {"step":5,"description":"Добавить рыбный соус (2 ст.л.), сахар (1 ст.л.), соль по вкусу. Бульон процедить."},
    {"step":6,"description":"Рисовую лапшу залить кипятком на 3–5 мин до мягкости (или по инструкции). Тонко нарезать 300 г говядины."},
    {"step":7,"description":"В миски: лапша + сырые ломтики говядины. Залить кипящим бульоном (говядина дойдёт от температуры бульона). Посыпать зелёным луком. Подавать с чили и лимоном."}]'
FROM dishes d WHERE d.name = 'Суп Фо бо'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Говядина'    THEN 700
    WHEN 'Лапша'       THEN 300
    WHEN 'Лук'         THEN 2
    WHEN 'Имбирь'      THEN 50
    WHEN 'Бадьян'      THEN 3
    WHEN 'Корица'      THEN 1
    WHEN 'Гвоздика'    THEN 3
    WHEN 'Соль'        THEN 1
    WHEN 'Сахар'       THEN 1
    WHEN 'Лук зеленый' THEN 30
    WHEN 'Перец чили'  THEN 1
    WHEN 'Лимон'       THEN 2
  END,
  CASE i.name
    WHEN 'Говядина'    THEN 'г'
    WHEN 'Лапша'       THEN 'г'
    WHEN 'Лук'         THEN 'шт'
    WHEN 'Имбирь'      THEN 'г'
    WHEN 'Бадьян'      THEN 'звёздочки'
    WHEN 'Корица'      THEN 'палочка'
    WHEN 'Гвоздика'    THEN 'шт'
    WHEN 'Соль'        THEN 'ч.л.'
    WHEN 'Сахар'       THEN 'ст.л.'
    WHEN 'Лук зеленый' THEN 'г'
    WHEN 'Перец чили'  THEN 'шт'
    WHEN 'Лимон'       THEN 'шт'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп Фо бо'
  AND i.name IN ('Говядина','Лапша','Лук','Имбирь','Бадьян','Корица','Гвоздика','Соль','Сахар','Лук зеленый','Перец чили','Лимон')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 16. Чизкейк Нью-Йорк
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Чизкейк Нью-Йорк',
  'Классический американский чизкейк с нежной сливочной начинкой и печенным основанием. Выпекается на водяной бане.',
  'https://images.unsplash.com/photo-1508737027454-e6454ef45afd?w=400&h=520&fit=crop&q=80',
  120, 'hard', 8, 600.00, TRUE, FALSE, 'other', 'snack')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Чизкейк Нью-Йорк'
  AND i.name IN ('Печенье','Масло сливочное','Сахар','Творожный сыр','Яйца','Сметана','Ванилин','Мука','Лимон')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'Классический',
  '[{"step":1,"description":"Печенье (200 г) измельчить в крошку. Смешать с растопленным маслом (80 г). Утрамбовать в разъёмную форму 22 см. Запечь при 175°C 10 мин. Остудить."},
    {"step":2,"description":"Духовку разогреть до 160°C. На нижний уровень поставить противень с кипятком (водяная баня)."},
    {"step":3,"description":"Творожный сыр (900 г) взбить с сахаром (200 г) до однородности. Добавить муку (2 ст.л.), ваниль, лимонный сок."},
    {"step":4,"description":"По одному добавить 4 яйца и 2 желтка, каждый раз тщательно перемешивая. Добавить сметану (200 г). НЕ перевзбивать."},
    {"step":5,"description":"Вылить начинку на остывший корж. Поставить форму в духовку над противнем с водой."},
    {"step":6,"description":"Выпекать 80–90 минут. Центр должен чуть покачиваться. Выключить духовку, оставить дверцу приоткрытой на 1 час."},
    {"step":7,"description":"Достать, остудить до комнатной температуры, накрыть плёнкой и убрать в холодильник минимум на 8 часов или ночь."}]'
FROM dishes d WHERE d.name = 'Чизкейк Нью-Йорк'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Печенье'        THEN 200
    WHEN 'Масло сливочное'THEN 80
    WHEN 'Сахар'          THEN 200
    WHEN 'Творожный сыр'  THEN 900
    WHEN 'Яйца'           THEN 4
    WHEN 'Сметана'        THEN 200
    WHEN 'Ванилин'        THEN 1
    WHEN 'Мука'           THEN 2
    WHEN 'Лимон'          THEN 0.5
  END,
  CASE i.name
    WHEN 'Печенье'        THEN 'г'
    WHEN 'Масло сливочное'THEN 'г'
    WHEN 'Сахар'          THEN 'г'
    WHEN 'Творожный сыр'  THEN 'г'
    WHEN 'Яйца'           THEN 'шт'
    WHEN 'Сметана'        THEN 'г'
    WHEN 'Ванилин'        THEN 'ч.л.'
    WHEN 'Мука'           THEN 'ст.л.'
    WHEN 'Лимон'          THEN 'шт'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Чизкейк Нью-Йорк'
  AND i.name IN ('Печенье','Масло сливочное','Сахар','Творожный сыр','Яйца','Сметана','Ванилин','Мука','Лимон')
ON CONFLICT DO NOTHING;

-- ============================================================
-- 17. Яйца Бенедикт
-- ============================================================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Яйца Бенедикт',
  'Классический американский завтрак: яйца пашот с беконом на маффинах под голландским соусом.',
  'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80',
  30, 'hard', 2, 450.00, FALSE, FALSE, 'other', 'breakfast')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Яйца Бенедикт'
  AND i.name IN ('Яйца','Бекон','Хлеб','Масло сливочное','Лимон','Горчица','Уксус','Перец черный','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, title, instructions)
SELECT d.id, 'С голландским соусом',
  '[{"step":1,"description":"Голландский соус: растопить 150 г сливочного масла. В блендере взбить 3 желтка с 1 ст.л. лимонного сока и 0,5 ч.л. горчицы. При работающем блендере влить горячее масло тонкой струйкой. Посолить. Соус должен загустеть."},
    {"step":2,"description":"Бекон обжарить на сковороде по 2 мин с каждой стороны."},
    {"step":3,"description":"Хлеб или маффины разрезать пополам, поджарить в тостере."},
    {"step":4,"description":"Яйца пашот: в сотейнике нагреть воду с 1 ст.л. уксуса (не кипятить — 80°C). Разбить яйцо в чашку. Сделать воронку ложкой, аккуратно опустить яйцо. Варить 3–4 минуты. Белок схватится, желток останется мягким."},
    {"step":5,"description":"Сборка: на тост положить бекон, сверху — яйцо пашот, полить голландским соусом. Посыпать перцем."}]'
FROM dishes d WHERE d.name = 'Яйца Бенедикт'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name
    WHEN 'Яйца'            THEN 8
    WHEN 'Бекон'           THEN 8
    WHEN 'Хлеб'            THEN 4
    WHEN 'Масло сливочное' THEN 150
    WHEN 'Лимон'           THEN 0.5
    WHEN 'Горчица'         THEN 0.5
    WHEN 'Уксус'           THEN 1
    WHEN 'Перец черный'    THEN 0.25
    WHEN 'Соль'            THEN 0.25
  END,
  CASE i.name
    WHEN 'Яйца'            THEN 'шт'
    WHEN 'Бекон'           THEN 'ломтей'
    WHEN 'Хлеб'            THEN 'ломтя'
    WHEN 'Масло сливочное' THEN 'г'
    WHEN 'Лимон'           THEN 'шт'
    WHEN 'Горчица'         THEN 'ч.л.'
    WHEN 'Уксус'           THEN 'ст.л.'
    WHEN 'Перец черный'    THEN 'ч.л.'
    WHEN 'Соль'            THEN 'ч.л.'
  END
FROM recipes r
JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Яйца Бенедикт'
  AND i.name IN ('Яйца','Бекон','Хлеб','Масло сливочное','Лимон','Горчица','Уксус','Перец черный','Соль')
ON CONFLICT DO NOTHING;
