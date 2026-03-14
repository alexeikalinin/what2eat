-- ============================================================
-- Migration 006: "Пустой холодильник" — simple quick dishes
-- Previously only in local SQLite seed.sql
-- ============================================================

-- Extra ingredients needed for these dishes
INSERT INTO ingredients (name, category, image_url, show_in_selector) VALUES
  ('Манная крупа', 'cereals', NULL, FALSE),
  ('Пшено',        'cereals', NULL, FALSE),
  ('Колбаса',      'meat',    NULL, FALSE),
  ('Вермишель',    'cereals', NULL, FALSE)
ON CONFLICT (name) DO NOTHING;

-- 18 simple dishes
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
  ('Яичница',               'Простая яичница-глазунья — 5 минут и готово',               'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 5,  'easy', 1, 1.00,  TRUE,  FALSE, 'russian', 'breakfast'),
  ('Омлет',                 'Классический омлет из яиц с молоком',                       'https://images.unsplash.com/photo-1553481187-be93c21490a9?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 2.00,  TRUE,  FALSE, 'russian', 'breakfast'),
  ('Вареные яйца',          'Яйца всмятку или вкрутую — самый простой завтрак',          'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 1.00,  TRUE,  FALSE, 'russian', 'breakfast'),
  ('Яичница с помидорами',  'Яичница с обжаренными помидорами',                          'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 2.00,  TRUE,  FALSE, 'russian', 'breakfast'),
  ('Яичница с колбасой',    'Яичница с поджаренной колбасой — классика завтрака',        'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 3.00,  FALSE, FALSE, 'russian', 'breakfast'),
  ('Картофельное пюре',     'Нежное пюре из картофеля с молоком и маслом',              'https://images.unsplash.com/photo-1574484284823-73b5e4b5d5b8?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 2.00,  TRUE,  FALSE, 'russian', 'lunch'),
  ('Жареный картофель',     'Хрустящий жареный картофель с луком',                      'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 2.00,  TRUE,  TRUE,  'russian', 'lunch'),
  ('Суп картофельный',      'Простой картофельный суп с луком и морковью',              'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 2.00,  TRUE,  TRUE,  'russian', 'lunch'),
  ('Рисовая каша на молоке','Нежная молочная каша из риса',                             'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 25, 'easy', 2, 1.50,  TRUE,  FALSE, 'russian', 'breakfast'),
  ('Манная каша',           'Классическая манная каша на молоке',                       'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 1.00,  TRUE,  FALSE, 'russian', 'breakfast'),
  ('Пшённая каша',          'Пшённая каша на молоке с маслом',                         'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 1.50,  TRUE,  FALSE, 'russian', 'breakfast'),
  ('Гречневая каша',        'Рассыпчатая гречка с маслом',                             'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 1.50,  TRUE,  FALSE, 'russian', 'lunch'),
  ('Макароны с маслом',     'Отварные макароны с маслом и солью — выручает всегда',     'https://images.unsplash.com/photo-1618164435735-2cfee3e07c36?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 1.00,  TRUE,  FALSE, 'russian', 'lunch'),
  ('Тосты с сыром',         'Хлеб с расплавленным сыром — быстрый перекус',            'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 5,  'easy', 2, 2.00,  TRUE,  FALSE, 'other',   'breakfast'),
  ('Гренки яичные',         'Хлеб, обжаренный в яично-молочном кляре',                 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 2.00,  TRUE,  FALSE, 'other',   'breakfast'),
  ('Бутерброды с колбасой', 'Простые бутерброды — быстрый перекус за 5 минут',         'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 5,  'easy', 2, 3.00,  FALSE, FALSE, 'russian', 'breakfast'),
  ('Творог со сметаной',    'Свежий творог со сметаной — полезный завтрак без готовки','https://images.unsplash.com/photo-1571748982800-fa51086c2a08?w=400&h=520&fit=crop&q=80', 5,  'easy', 2, 3.00,  TRUE,  FALSE, 'russian', 'breakfast'),
  ('Суп с вермишелью',      'Лёгкий суп с вермишелью и овощами',                       'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 2.50,  TRUE,  FALSE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

-- dish_ingredients (subquery-based — safe against ID shifts)
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Яичница' AND i.name IN ('Яйца', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Омлет' AND i.name IN ('Яйца', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Вареные яйца' AND i.name IN ('Яйца', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Яичница с помидорами' AND i.name IN ('Яйца', 'Помидоры', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Яичница с колбасой' AND i.name IN ('Яйца', 'Колбаса', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Картофельное пюре' AND i.name IN ('Картофель', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Жареный картофель' AND i.name IN ('Картофель', 'Лук', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп картофельный' AND i.name IN ('Картофель', 'Лук', 'Морковь', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рисовая каша на молоке' AND i.name IN ('Рис', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Манная каша' AND i.name IN ('Манная крупа', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Пшённая каша' AND i.name IN ('Пшено', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гречневая каша' AND i.name IN ('Гречка', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Макароны с маслом' AND i.name IN ('Макароны', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тосты с сыром' AND i.name IN ('Хлеб', 'Сыр', 'Масло сливочное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гренки яичные' AND i.name IN ('Хлеб', 'Яйца', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Бутерброды с колбасой' AND i.name IN ('Хлеб', 'Колбаса', 'Масло сливочное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Творог со сметаной' AND i.name IN ('Творог', 'Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп с вермишелью' AND i.name IN ('Макароны', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Recipes
INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Разогреть сковороду с растительным маслом на среднем огне"},
  {"step": 2, "description": "Аккуратно разбить яйца на сковороду, не перемешивая"},
  {"step": 3, "description": "Посолить по вкусу"},
  {"step": 4, "description": "Жарить 2-3 минуты до застывания белка, желток оставить жидким"},
  {"step": 5, "description": "Подавать горячей прямо со сковороды"}
]' FROM dishes d WHERE d.name = 'Яичница'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Взбить яйца с молоком и щепоткой соли"},
  {"step": 2, "description": "Растопить сливочное масло в сковороде на среднем огне"},
  {"step": 3, "description": "Вылить яичную смесь, накрыть крышкой"},
  {"step": 4, "description": "Готовить 3-4 минуты, не мешая, до застывания"},
  {"step": 5, "description": "Сложить пополам лопаткой и подавать"}
]' FROM dishes d WHERE d.name = 'Омлет'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Залить яйца холодной водой в кастрюле"},
  {"step": 2, "description": "Довести до кипения, варить 4 мин (всмятку) или 8 мин (вкрутую)"},
  {"step": 3, "description": "Переложить в холодную воду на 2 минуты — так легче чистить"},
  {"step": 4, "description": "Очистить и подавать с солью"}
]' FROM dishes d WHERE d.name = 'Вареные яйца'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать помидоры кружочками или дольками"},
  {"step": 2, "description": "Обжарить помидоры на масле 1-2 минуты"},
  {"step": 3, "description": "Разбить яйца поверх помидоров, посолить"},
  {"step": 4, "description": "Накрыть крышкой и готовить 2-3 минуты до готовности белка"},
  {"step": 5, "description": "Подавать горячей с зеленью по желанию"}
]' FROM dishes d WHERE d.name = 'Яичница с помидорами'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать колбасу кружочками или соломкой"},
  {"step": 2, "description": "Обжарить колбасу на масле 2-3 минуты до румяности"},
  {"step": 3, "description": "Разбить яйца поверх колбасы, посолить"},
  {"step": 4, "description": "Жарить 2-3 минуты до готовности белка"},
  {"step": 5, "description": "Подавать горячей"}
]' FROM dishes d WHERE d.name = 'Яичница с колбасой'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Очистить и нарезать картофель кубиками"},
  {"step": 2, "description": "Отварить в подсоленной воде до мягкости (15-20 мин)"},
  {"step": 3, "description": "Слить воду, добавить сливочное масло"},
  {"step": 4, "description": "Разогреть молоко и влить к картофелю"},
  {"step": 5, "description": "Тщательно размять толкушкой до однородной массы"},
  {"step": 6, "description": "Посолить по вкусу, подавать горячим"}
]' FROM dishes d WHERE d.name = 'Картофельное пюре'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Очистить и нарезать картофель ломтиками или брусочками"},
  {"step": 2, "description": "Нарезать лук полукольцами"},
  {"step": 3, "description": "Разогреть масло в сковороде на среднем огне"},
  {"step": 4, "description": "Выложить картофель и жарить 10 минут без перемешивания"},
  {"step": 5, "description": "Перевернуть, добавить лук, жарить ещё 10-15 минут"},
  {"step": 6, "description": "Посолить, подавать горячим"}
]' FROM dishes d WHERE d.name = 'Жареный картофель'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать картофель кубиками, лук и морковь"},
  {"step": 2, "description": "Обжарить лук и морковь в кастрюле на масле 5 минут"},
  {"step": 3, "description": "Залить 1.5 л воды, довести до кипения"},
  {"step": 4, "description": "Добавить картофель, варить 15-20 минут до мягкости"},
  {"step": 5, "description": "Посолить, поперчить по вкусу"},
  {"step": 6, "description": "Подавать горячим, по желанию добавить сметану"}
]' FROM dishes d WHERE d.name = 'Суп картофельный'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Промыть рис несколько раз"},
  {"step": 2, "description": "Довести молоко до кипения в кастрюле с толстым дном"},
  {"step": 3, "description": "Всыпать рис, убавить огонь"},
  {"step": 4, "description": "Варить, помешивая, 20-25 минут до мягкости"},
  {"step": 5, "description": "Добавить масло и соль по вкусу, подавать горячей"}
]' FROM dishes d WHERE d.name = 'Рисовая каша на молоке'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Довести молоко до кипения"},
  {"step": 2, "description": "Тонкой струйкой всыпать манную крупу, непрерывно мешая"},
  {"step": 3, "description": "Убавить огонь и варить 5-7 минут, постоянно помешивая"},
  {"step": 4, "description": "Добавить масло и щепотку соли"},
  {"step": 5, "description": "Подавать горячей, можно добавить варенье или мёд"}
]' FROM dishes d WHERE d.name = 'Манная каша'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Промыть пшено, залить молоком"},
  {"step": 2, "description": "Довести до кипения на среднем огне"},
  {"step": 3, "description": "Убавить огонь, варить 20 минут, помешивая"},
  {"step": 4, "description": "Добавить масло и соль, снять с огня"},
  {"step": 5, "description": "Накрыть крышкой и дать настояться 5 минут"}
]' FROM dishes d WHERE d.name = 'Пшённая каша'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Промыть гречку, залить кипятком 1:2"},
  {"step": 2, "description": "Поставить на средний огонь, довести до кипения"},
  {"step": 3, "description": "Убавить огонь, варить под крышкой 15-20 минут"},
  {"step": 4, "description": "Дождаться, пока вода полностью впитается"},
  {"step": 5, "description": "Добавить сливочное масло и соль, подавать"}
]' FROM dishes d WHERE d.name = 'Гречневая каша'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отварить макароны в подсоленной воде по инструкции"},
  {"step": 2, "description": "Слить воду, оставив пару ложек"},
  {"step": 3, "description": "Добавить сливочное масло в горячие макароны"},
  {"step": 4, "description": "Перемешать до полного таяния масла"},
  {"step": 5, "description": "Посолить по вкусу, подавать горячими"}
]' FROM dishes d WHERE d.name = 'Макароны с маслом'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать хлеб ломтиками"},
  {"step": 2, "description": "Положить ломтик сыра на каждый кусок"},
  {"step": 3, "description": "Обжарить на сковороде с маслом до расплавления сыра"},
  {"step": 4, "description": "Или поставить в микроволновку на 30 секунд"},
  {"step": 5, "description": "Подавать горячими"}
]' FROM dishes d WHERE d.name = 'Тосты с сыром'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Взбить яйца с молоком и щепоткой соли"},
  {"step": 2, "description": "Обмакнуть ломтики хлеба в яичную смесь с двух сторон"},
  {"step": 3, "description": "Растопить масло на сковороде"},
  {"step": 4, "description": "Обжарить гренки по 2-3 минуты с каждой стороны до золотистого цвета"},
  {"step": 5, "description": "Подавать горячими, по желанию посыпать сахаром"}
]' FROM dishes d WHERE d.name = 'Гренки яичные'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать хлеб ломтиками"},
  {"step": 2, "description": "Намазать сливочное масло на каждый ломоть"},
  {"step": 3, "description": "Нарезать колбасу тонкими кружочками"},
  {"step": 4, "description": "Разложить колбасу на хлеб"},
  {"step": 5, "description": "Подавать с чаем или кофе"}
]' FROM dishes d WHERE d.name = 'Бутерброды с колбасой'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Выложить творог в миску или на тарелку"},
  {"step": 2, "description": "Добавить сметану по вкусу"},
  {"step": 3, "description": "По желанию добавить щепотку соли или ложку мёда"},
  {"step": 4, "description": "Подавать сразу — готово!"}
]' FROM dishes d WHERE d.name = 'Творог со сметаной'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать морковь и лук"},
  {"step": 2, "description": "Обжарить лук и морковь на масле 5 минут"},
  {"step": 3, "description": "Нарезать картофель кубиками, добавить в кастрюлю"},
  {"step": 4, "description": "Залить 1.5 л кипятка, варить 10 минут"},
  {"step": 5, "description": "Добавить вермишель, варить 5-7 минут до готовности"},
  {"step": 6, "description": "Посолить, подавать горячим"}
]' FROM dishes d WHERE d.name = 'Суп с вермишелью'
ON CONFLICT DO NOTHING;
