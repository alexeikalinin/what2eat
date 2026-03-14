-- ============================================================
-- 005_more_recipes.sql
-- Расширение базы рецептов + исправление изображений
-- ============================================================

-- ============================================================
-- ИСПРАВЛЕНИЕ ИЗОБРАЖЕНИЙ существующих блюд
-- ============================================================

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1574494315329-1e5a05a31b34?w=400&h=520&fit=crop&q=80'
WHERE name = 'Лазанья';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80'
WHERE name = 'Сациви с курицей';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1553163147-622ab57be1c7?w=400&h=520&fit=crop&q=80'
WHERE name = 'Суп харчо';

-- ============================================================
-- НОВЫЕ ИНГРЕДИЕНТЫ
-- ============================================================

INSERT INTO ingredients (name, category, image_url) VALUES
('Моцарелла', 'dairy', NULL),
('Базилик', 'spices', NULL),
('Сливки', 'dairy', NULL),
('Орехи грецкие', 'other', NULL),
('Кокосовое молоко', 'other', NULL),
('Паприка', 'spices', NULL),
('Перец острый', 'spices', NULL),
('Вино красное', 'other', NULL),
('Баранина', 'meat', NULL)
ON CONFLICT DO NOTHING;

-- ============================================================
-- ИТАЛЬЯНСКАЯ КУХНЯ (+6 блюд → итого 10)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Пицца Маргарита',
 'Классическая итальянская пицца с томатным соусом и моцареллой',
 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=520&fit=crop&q=80',
 30, 'easy', 2, 11.00, TRUE, FALSE, 'italian', 'dinner'),

('Тирамису',
 'Нежный итальянский десерт из маскарпоне, кофе и савоярди',
 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=520&fit=crop&q=80',
 30, 'medium', 6, 12.00, TRUE, FALSE, 'italian', 'snack'),

('Минестроне',
 'Густой итальянский суп с овощами, фасолью и пастой',
 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=520&fit=crop&q=80',
 45, 'easy', 4, 7.00, TRUE, TRUE, 'italian', 'lunch'),

('Паста с грибами в сливочном соусе',
 'Паста фетучини с шампиньонами в нежном сливочном соусе',
 'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=400&h=520&fit=crop&q=80',
 25, 'easy', 2, 10.00, TRUE, FALSE, 'italian', 'dinner'),

('Ньокки с соусом Песто',
 'Картофельные клёцки с ароматным соусом из базилика',
 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=520&fit=crop&q=80',
 40, 'medium', 2, 10.00, TRUE, FALSE, 'italian', 'dinner'),

('Паста Аматричана',
 'Паста с томатным соусом, беконом и пармезаном',
 'https://images.unsplash.com/photo-1555396273-122e7a6ce434?w=400&h=520&fit=crop&q=80',
 30, 'easy', 2, 11.00, FALSE, FALSE, 'italian', 'dinner')

ON CONFLICT DO NOTHING;

-- dish_ingredients
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Пицца Маргарита' AND i.name IN ('Мука','Моцарелла','Помидоры','Томатная паста','Масло растительное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тирамису' AND i.name IN ('Яйца','Сметана','Сыр','Кофе')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Минестроне' AND i.name IN ('Фасоль','Помидоры','Морковь','Лук','Чеснок','Кабачки','Макароны','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паста с грибами в сливочном соусе' AND i.name IN ('Макароны','Грибы','Сливки','Пармезан','Чеснок','Масло сливочное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Ньокки с соусом Песто' AND i.name IN ('Картофель','Мука','Яйца','Базилик','Пармезан','Масло растительное','Чеснок')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паста Аматричана' AND i.name IN ('Макароны','Бекон','Помидоры','Томатная паста','Пармезан','Перец острый')
ON CONFLICT DO NOTHING;

-- recipes
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замесить тесто из муки, воды, соли и масла — 10 минут месить до эластичности. Дать отдохнуть 30 минут."},{"step":2,"description":"Разогреть духовку до 250°C. Раскатать тесто тонко на противне."},{"step":3,"description":"Намазать томатным соусом, посолить, добавить базилик."},{"step":4,"description":"Выложить нарезанную моцареллу и ломтики помидоров."},{"step":5,"description":"Сбрызнуть оливковым маслом. Запекать 10-12 минут до румяной корочки."},{"step":6,"description":"Подавать сразу, нарезав на 4-6 частей."}]'
FROM dishes WHERE name = 'Пицца Маргарита'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Заварить крепкий эспрессо, охладить. Смешать с ложкой ликёра (опционально)."},{"step":2,"description":"Отделить желтки от белков. Взбить желтки с сахаром добела."},{"step":3,"description":"Добавить маскарпоне к желткам и аккуратно перемешать до однородности."},{"step":4,"description":"Взбить белки в крепкую пену, аккуратно ввести в крем."},{"step":5,"description":"Быстро обмакнуть савоярди в кофе и выложить слоем в форму."},{"step":6,"description":"Нанести слой крема, затем ещё слой печенья и крема. Присыпать какао. Убрать в холодильник на 4 часа."}]'
FROM dishes WHERE name = 'Тирамису'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать лук, морковь, кабачок кубиками, чеснок мелко."},{"step":2,"description":"Обжарить лук и морковь в масле 5 минут."},{"step":3,"description":"Добавить кабачок и помидоры, тушить ещё 5 минут."},{"step":4,"description":"Залить 1,5 л воды или бульона, добавить фасоль (из банки или отварную)."},{"step":5,"description":"Когда закипит, добавить мелкую пасту или ломаные спагетти."},{"step":6,"description":"Варить 10 минут до готовности пасты. Подавать с тёртым пармезаном."}]'
FROM dishes WHERE name = 'Минестроне'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать шампиньоны пластинами, чеснок мелко."},{"step":2,"description":"Обжарить чеснок на сливочном масле 1 минуту."},{"step":3,"description":"Добавить грибы, обжаривать 7-8 минут до испарения жидкости."},{"step":4,"description":"Влить сливки, довести до кипения, убавить огонь."},{"step":5,"description":"Отварить пасту до состояния аль денте. Слить, оставив 100 мл воды."},{"step":6,"description":"Соединить пасту с соусом, добавить пармезан. Подавать горячим."}]'
FROM dishes WHERE name = 'Паста с грибами в сливочном соусе'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить картофель в мундире, остудить, очистить."},{"step":2,"description":"Протереть картофель через пресс, добавить муку, яйцо, соль — замесить мягкое тесто."},{"step":3,"description":"Скатать колбаски диаметром 2 см, нарезать на кусочки 2 см. Надавить вилкой."},{"step":4,"description":"Отварить ньокки в подсоленной воде: они готовы, как всплывут (3-4 минуты)."},{"step":5,"description":"Смолоть базилик, пармезан, чеснок и масло в блендере до соуса."},{"step":6,"description":"Перемешать ньокки с песто. Подавать сразу."}]'
FROM dishes WHERE name = 'Ньокки с соусом Песто'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать бекон полосками и обжарить до хруста. Убрать на тарелку."},{"step":2,"description":"В жире от бекона обжарить нарезанный лук и чеснок 3 минуты."},{"step":3,"description":"Добавить томатную пасту, помидоры, острый перец. Тушить 15 минут."},{"step":4,"description":"Отварить спагетти до аль денте."},{"step":5,"description":"Смешать пасту с соусом, добавить бекон."},{"step":6,"description":"Подавать с тёртым пармезаном."}]'
FROM dishes WHERE name = 'Паста Аматричана'
ON CONFLICT DO NOTHING;

-- ============================================================
-- ГРУЗИНСКАЯ КУХНЯ (+5 блюд → итого 8)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Хинкали с мясом',
 'Сочные грузинские пельмени с бульоном внутри — есть нужно руками',
 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=400&h=520&fit=crop&q=80',
 90, 'hard', 4, 12.00, FALSE, FALSE, 'georgian', 'dinner'),

('Чкмерули',
 'Курица в сливочно-чесночном соусе — классика грузинских ресторанов',
 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80',
 45, 'medium', 2, 13.00, FALSE, FALSE, 'georgian', 'dinner'),

('Лобиани',
 'Грузинская лепёшка с сытной начинкой из пряной фасоли',
 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=520&fit=crop&q=80',
 50, 'medium', 4, 5.00, TRUE, FALSE, 'georgian', 'snack'),

('Шашлык из свинины',
 'Сочный шашлык на углях — король кавказского гриля',
 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80',
 60, 'medium', 4, 16.00, FALSE, FALSE, 'georgian', 'dinner'),

('Аджапсандали',
 'Грузинское овощное рагу из баклажанов, перца и помидоров',
 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80',
 45, 'easy', 4, 6.00, TRUE, TRUE, 'georgian', 'dinner')

ON CONFLICT DO NOTHING;

-- dish_ingredients Georgian
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Хинкали с мясом' AND i.name IN ('Говядина','Свинина','Лук','Мука','Перец черный','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Чкмерули' AND i.name IN ('Курица','Сливки','Чеснок','Масло сливочное','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Лобиани' AND i.name IN ('Мука','Фасоль','Лук','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Шашлык из свинины' AND i.name IN ('Свинина','Лук','Соль','Перец черный','Лимон')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Аджапсандали' AND i.name IN ('Баклажаны','Перец болгарский','Помидоры','Лук','Чеснок','Масло растительное','Петрушка')
ON CONFLICT DO NOTHING;

-- recipes Georgian
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замесить крутое тесто из муки, воды и соли. Дать отдохнуть 30 минут."},{"step":2,"description":"Смешать говяжий и свиной фарш с мелко нарезанным луком, добавить бульон, соль и перец."},{"step":3,"description":"Раскатать тесто тонко, вырезать круги диаметром 12-14 см."},{"step":4,"description":"Выложить фарш в центр, собрать края теста в складки наверху — получится мешочек."},{"step":5,"description":"Отварить хинкали в большом количестве подсоленной воды 10-12 минут."},{"step":6,"description":"Есть руками: откусить краешек, выпить бульон, затем съесть остальное. Посыпать чёрным перцем."}]'
FROM dishes WHERE name = 'Хинкали с мясом'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Разделить курицу на части или использовать целую, разрезав пополам — сделать надрезы для пропитки."},{"step":2,"description":"Обжарить курицу на сковороде с обеих сторон по 7-10 минут до золотистой корочки."},{"step":3,"description":"Смешать сливки с давлёным чесноком, солью и перцем."},{"step":4,"description":"Залить курицу сливочным соусом, накрыть крышкой."},{"step":5,"description":"Тушить на медленном огне 20-25 минут — соус должен загустеть."},{"step":6,"description":"Подавать прямо в сковороде с лавашом или рисом."}]'
FROM dishes WHERE name = 'Чкмерули'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замочить красную фасоль на ночь, отварить до мягкости (или взять готовую консервированную)."},{"step":2,"description":"Обжарить лук до золотистости, смешать с фасолью."},{"step":3,"description":"Приправить кориандром, перцем, солью — начинка должна быть ароматной."},{"step":4,"description":"Замесить мягкое дрожжевое тесто, разделить на колобки, раскатать в лепёшки."},{"step":5,"description":"Положить начинку, защипнуть края, перевернуть и раскатать снова в плоскую лепёшку."},{"step":6,"description":"Жарить на сухой сковороде по 3-4 минуты с каждой стороны. Смазать маслом."}]'
FROM dishes WHERE name = 'Лобиани'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать свинину кусками 4×4 см. Лук — крупными кольцами."},{"step":2,"description":"Смешать мясо с луком, солью, чёрным перцем, соком лимона."},{"step":3,"description":"Мариновать минимум 3 часа, лучше — ночь."},{"step":4,"description":"Нанизать на шампуры, чередуя мясо с кольцами лука."},{"step":5,"description":"Жарить над углями (без открытого огня) 20-25 минут, регулярно переворачивая."},{"step":6,"description":"Готовность проверить надрезом — сок должен быть прозрачным. Подавать с лавашом и зеленью."}]'
FROM dishes WHERE name = 'Шашлык из свинины'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать баклажаны кубиками, посолить, оставить на 15 минут — смыть горечь."},{"step":2,"description":"Нарезать лук полукольцами, перец — полосками, помидоры — кубиками."},{"step":3,"description":"Обжарить лук в масле 5 минут, добавить баклажаны, жарить 10 минут."},{"step":4,"description":"Добавить перец, помидоры и чеснок, перемешать."},{"step":5,"description":"Тушить на медленном огне 25-30 минут под крышкой."},{"step":6,"description":"В конце добавить зелень. Подавать тёплым или комнатной температуры."}]'
FROM dishes WHERE name = 'Аджапсандали'
ON CONFLICT DO NOTHING;

-- ============================================================
-- АЗИАТСКАЯ КУХНЯ (+5 блюд → итого 8)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Куриный рамен',
 'Японский суп с лапшой, яйцом и сочной курицей в бульоне умами',
 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400&h=520&fit=crop&q=80',
 50, 'medium', 2, 12.00, FALSE, FALSE, 'asian', 'lunch'),

('Карри с курицей',
 'Сливочное тайское карри с курицей и кокосовым молоком',
 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=520&fit=crop&q=80',
 35, 'easy', 4, 13.00, FALSE, FALSE, 'asian', 'dinner'),

('Пад Тай с курицей',
 'Тайская рисовая лапша с курицей, яйцом и арахисом',
 'https://images.unsplash.com/photo-1559314809-0d155014e29e?w=400&h=520&fit=crop&q=80',
 25, 'medium', 2, 11.00, FALSE, FALSE, 'asian', 'dinner'),

('Суп Том Ям',
 'Острый тайский суп с лемонграссом, грибами и морепродуктами',
 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80',
 35, 'medium', 2, 14.00, FALSE, FALSE, 'asian', 'lunch'),

('Говядина по-китайски',
 'Тонко нарезанная говядина в устричном соусе с овощами',
 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=520&fit=crop&q=80',
 25, 'easy', 2, 13.00, FALSE, FALSE, 'asian', 'dinner')

ON CONFLICT DO NOTHING;

-- dish_ingredients Asian
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Куриный рамен' AND i.name IN ('Курица','Лапша','Яйца','Соевый соус','Имбирь','Чеснок','Лук')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Карри с курицей' AND i.name IN ('Курица','Кокосовое молоко','Перец болгарский','Лук','Чеснок','Имбирь','Рис')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Пад Тай с курицей' AND i.name IN ('Курица','Лапша','Яйца','Соевый соус','Лук','Перец болгарский')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп Том Ям' AND i.name IN ('Грибы','Помидоры','Лимон','Имбирь','Чеснок','Лук')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Говядина по-китайски' AND i.name IN ('Говядина','Соевый соус','Чеснок','Имбирь','Перец болгарский','Лук','Масло растительное')
ON CONFLICT DO NOTHING;

-- recipes Asian
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить курицу в воде с имбирём, луком и соевым соусом — 30 минут. Бульон — основа рамена."},{"step":2,"description":"Достать курицу, разобрать на волокна. Процедить бульон."},{"step":3,"description":"Отдельно отварить яйца всмятку (6-7 минут), охладить, очистить."},{"step":4,"description":"Отварить лапшу согласно инструкции."},{"step":5,"description":"Разложить лапшу по глубоким тарелкам, залить горячим бульоном."},{"step":6,"description":"Выложить курицу, половинки яйца, добавить нарезанный зелёный лук."}]'
FROM dishes WHERE name = 'Куриный рамен'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать курицу кубиками, лук — полукольцами, перец — полосками."},{"step":2,"description":"Обжарить лук и перец в масле 5 минут, добавить чеснок и имбирь."},{"step":3,"description":"Добавить курицу, обжарить до белого цвета — 5-7 минут."},{"step":4,"description":"Добавить пасту карри (1-2 ст. л.), перемешать. Жарить 1 минуту."},{"step":5,"description":"Влить кокосовое молоко, довести до кипения, тушить 15 минут."},{"step":6,"description":"Подавать с отварным рисом, украсить свежей кинзой."}]'
FROM dishes WHERE name = 'Карри с курицей'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Залить рисовую лапшу кипятком на 5 минут, слить."},{"step":2,"description":"Обжарить нарезанную курицу в масле до готовности, убрать."},{"step":3,"description":"В том же воке обжарить лук и перец 3 минуты."},{"step":4,"description":"Добавить лапшу, перемешать. Сдвинуть в сторону, разбить яйца и перемешать."},{"step":5,"description":"Смешать всё вместе, добавить курицу и соевый соус."},{"step":6,"description":"Подавать сразу, посыпать арахисом и нарезанным луком."}]'
FROM dishes WHERE name = 'Пад Тай с курицей'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать лемонграсс, имбирь и чеснок. Обжарить в масле 2 минуты."},{"step":2,"description":"Залить 800 мл воды или рыбного бульона, довести до кипения."},{"step":3,"description":"Добавить нарезанные шампиньоны, помидоры черри."},{"step":4,"description":"Варить 10 минут, добавить сок лайма (лимона)."},{"step":5,"description":"Добавить острый перец по вкусу, соль."},{"step":6,"description":"Подавать горячим, украсить листьями кинзы."}]'
FROM dishes WHERE name = 'Суп Том Ям'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать говядину тонкими полосками поперёк волокон."},{"step":2,"description":"Замариновать в соевом соусе, имбире и чесноке — 15 минут."},{"step":3,"description":"Нарезать перец полосками, лук — полукольцами."},{"step":4,"description":"Разогреть вок до максимума, обжарить говядину за 2-3 минуты на сильном огне."},{"step":5,"description":"Добавить овощи, жарить ещё 3-4 минуты, помешивая."},{"step":6,"description":"Подавать с варёным рисом."}]'
FROM dishes WHERE name = 'Говядина по-китайски'
ON CONFLICT DO NOTHING;

-- ============================================================
-- МЕКСИКАНСКАЯ КУХНЯ (+4 блюда → итого 7)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Буррито с курицей',
 'Большая лепёшка с курицей, рисом, фасолью и сальсой',
 'https://images.unsplash.com/photo-1626700051175-6818013e1d4f?w=400&h=520&fit=crop&q=80',
 30, 'easy', 2, 10.00, FALSE, FALSE, 'mexican', 'lunch'),

('Чили кон карне',
 'Сытное мексиканское рагу с говядиной, фасолью и перцем',
 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80',
 60, 'easy', 4, 11.00, FALSE, FALSE, 'mexican', 'dinner'),

('Начос с сальсой',
 'Хрустящие кукурузные чипсы с сальсой, авокадо и сыром',
 'https://images.unsplash.com/photo-1582169296194-e4d644c48063?w=400&h=520&fit=crop&q=80',
 15, 'easy', 2, 8.00, TRUE, FALSE, 'mexican', 'snack'),

('Фахитас с говядиной',
 'Сочная говядина с перцем в тёплой лепёшке',
 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80',
 25, 'easy', 2, 12.00, FALSE, FALSE, 'mexican', 'dinner')

ON CONFLICT DO NOTHING;

-- dish_ingredients Mexican
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Буррито с курицей' AND i.name IN ('Курица','Рис','Фасоль','Помидоры','Сыр','Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Чили кон карне' AND i.name IN ('Говядина','Фасоль','Помидоры','Перец болгарский','Лук','Чеснок','Томатная паста','Паприка')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Начос с сальсой' AND i.name IN ('Помидоры','Лук','Чеснок','Сыр','Перец острый')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Фахитас с говядиной' AND i.name IN ('Говядина','Перец болгарский','Лук','Чеснок','Лимон','Паприка','Масло растительное')
ON CONFLICT DO NOTHING;

-- recipes Mexican
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать куриную грудку полосками, обжарить с паприкой и чесноком до готовности."},{"step":2,"description":"Отварить рис. Разогреть фасоль (из банки) с щепоткой соли и тмина."},{"step":3,"description":"Нарезать помидоры кубиками, смешать с луком и соком лайма — простая сальса."},{"step":4,"description":"Подогреть тортилью на сухой сковороде 30 секунд с каждой стороны."},{"step":5,"description":"Выложить на тортилью рис, фасоль, курицу, сальсу и сметану."},{"step":6,"description":"Завернуть плотным рулетом, подвернув края. Подавать целым или разрезав пополам."}]'
FROM dishes WHERE name = 'Буррито с курицей'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать говядину мелкими кубиками, лук и перец — мелко."},{"step":2,"description":"Обжарить говядину партиями до румяной корочки, убрать."},{"step":3,"description":"В том же масле обжарить лук, чеснок и перец 5 минут."},{"step":4,"description":"Добавить томатную пасту, помидоры, паприку, острый перец."},{"step":5,"description":"Вернуть мясо, добавить фасоль и 300 мл воды. Тушить 40 минут."},{"step":6,"description":"Подавать с рисом, тортильей или чипсами начос."}]'
FROM dishes WHERE name = 'Чили кон карне'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать помидоры, лук и острый перец мелко — это сальса. Добавить сок лайма и соль."},{"step":2,"description":"Очистить авокадо, размять вилкой с соком лайма и солью — гуакамоле."},{"step":3,"description":"Натереть сыр на тёрке."},{"step":4,"description":"Разложить начос на противне, посыпать сыром."},{"step":5,"description":"Запечь при 200°C 5 минут до расплавления сыра."},{"step":6,"description":"Подавать с сальсой и гуакамоле."}]'
FROM dishes WHERE name = 'Начос с сальсой'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать говядину тонкими полосками, замариновать в лимонном соке, паприке и чесноке — 30 минут."},{"step":2,"description":"Нарезать перец и лук полосками."},{"step":3,"description":"Раскалить сковороду до максимума, обжарить говядину 3 минуты."},{"step":4,"description":"Добавить овощи, жарить ещё 4-5 минут на сильном огне."},{"step":5,"description":"Подогреть тортильи."},{"step":6,"description":"Подавать начинку в отдельной тарелке с тортильями, сальсой и сметаной."}]'
FROM dishes WHERE name = 'Фахитас с говядиной'
ON CONFLICT DO NOTHING;

-- ============================================================
-- ФРАНЦУЗСКАЯ КУХНЯ (+4 блюда → итого 7)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Киш Лорен',
 'Открытый французский пирог с беконом, сыром и сливочной начинкой',
 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400&h=520&fit=crop&q=80',
 60, 'medium', 6, 10.00, FALSE, FALSE, 'french', 'lunch'),

('Бёф Бургиньон',
 'Говядина, тушёная в красном вине с грибами и морковью',
 'https://images.unsplash.com/photo-1544025162-d76538415e0f?w=400&h=520&fit=crop&q=80',
 180, 'hard', 4, 18.00, FALSE, FALSE, 'french', 'dinner'),

('Французские тосты',
 'Золотистые гренки с яйцом и молоком — сладкий завтрак по-французски',
 'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400&h=520&fit=crop&q=80',
 15, 'easy', 2, 4.00, TRUE, FALSE, 'french', 'breakfast'),

('Суп Буйабес',
 'Прованский рыбный суп с шафраном и морепродуктами',
 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80',
 60, 'hard', 4, 20.00, FALSE, FALSE, 'french', 'lunch')

ON CONFLICT DO NOTHING;

-- dish_ingredients French
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Киш Лорен' AND i.name IN ('Мука','Бекон','Сыр','Яйца','Сливки','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Бёф Бургиньон' AND i.name IN ('Говядина','Вино красное','Грибы','Морковь','Лук','Чеснок','Масло сливочное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Французские тосты' AND i.name IN ('Хлеб','Яйца','Молоко','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп Буйабес' AND i.name IN ('Семга','Помидоры','Лук','Чеснок','Лимон','Масло растительное','Соль')
ON CONFLICT DO NOTHING;

-- recipes French
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Приготовить песочное тесто: смешать муку, холодное масло, щепотку соли. Добавить воды — замесить тесто. Убрать в холодильник 30 минут."},{"step":2,"description":"Раскатать тесто, выложить в форму, наколоть вилкой. Слепо запечь при 180°C 15 минут."},{"step":3,"description":"Нарезать бекон полосками, обжарить до хруста."},{"step":4,"description":"Смешать яйца и сливки, добавить тёртый сыр, соль и перец."},{"step":5,"description":"Выложить бекон на тесто, залить сливочной смесью."},{"step":6,"description":"Запекать при 170°C 25-30 минут до золотистого цвета и схватившейся начинки."}]'
FROM dishes WHERE name = 'Киш Лорен'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать говядину кубиками 4×4 см, обсушить бумажным полотенцем."},{"step":2,"description":"Обжарить партиями до румяной корочки. Важно — не тушить, а именно жарить."},{"step":3,"description":"В том же казане обжарить нарезанный лук, морковь и чеснок."},{"step":4,"description":"Вернуть мясо, залить красным вином. Тушить 30 минут без крышки."},{"step":5,"description":"Добавить воды до покрытия мяса, добавить грибы. Тушить 1,5-2 часа."},{"step":6,"description":"Подавать с хлебом или картофельным пюре."}]'
FROM dishes WHERE name = 'Бёф Бургиньон'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Взбить яйца с молоком, щепоткой соли и сахара (по желанию)."},{"step":2,"description":"Нарезать хлеб ломтями толщиной 2-3 см. Вчерашний батон подходит лучше."},{"step":3,"description":"Обмакнуть каждый ломоть в яичную смесь с обеих сторон — дать пропитаться."},{"step":4,"description":"Растопить сливочное масло на сковороде на среднем огне."},{"step":5,"description":"Обжаривать тосты по 2-3 минуты с каждой стороны до золотистой корочки."},{"step":6,"description":"Подавать с мёдом, ягодами или вареньем."}]'
FROM dishes WHERE name = 'Французские тосты'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать лук и чеснок, обжарить в масле до мягкости."},{"step":2,"description":"Добавить нарезанные помидоры, тушить 10 минут."},{"step":3,"description":"Залить 1 л воды или рыбного бульона, довести до кипения."},{"step":4,"description":"Добавить нарезанное рыбное филе и варить 10-15 минут."},{"step":5,"description":"Добавить сок лимона, соль, перец и шафран (по наличию)."},{"step":6,"description":"Подавать горячим с хрустящим хлебом и соусом руй."}]'
FROM dishes WHERE name = 'Суп Буйабес'
ON CONFLICT DO NOTHING;

-- ============================================================
-- ВОСТОЧНОЕВРОПЕЙСКАЯ КУХНЯ (+4 блюда → итого 7)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Голубцы с мясом',
 'Сочный фарш с рисом, завёрнутый в капустные листья и тушёный в соусе',
 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80',
 90, 'medium', 4, 10.00, FALSE, FALSE, 'eastern_european', 'dinner'),

('Польский бигос',
 'Польское рагу из квашеной капусты, свинины и копчёной колбасы',
 'https://images.unsplash.com/photo-1555396273-122e7a6ce434?w=400&h=520&fit=crop&q=80',
 120, 'medium', 6, 9.00, FALSE, FALSE, 'eastern_european', 'dinner'),

('Свекольник холодный',
 'Освежающий польский суп на кефире со свёклой и огурцами',
 'https://images.unsplash.com/photo-1547592166-23ac786af7ea?w=400&h=520&fit=crop&q=80',
 25, 'easy', 4, 4.00, TRUE, FALSE, 'eastern_european', 'lunch'),

('Чешский гуляш',
 'Говядина в густом пивном соусе с кнедликами',
 'https://images.unsplash.com/photo-1574484284823-73b5e4b5d5b8?w=400&h=520&fit=crop&q=80',
 90, 'medium', 4, 14.00, FALSE, FALSE, 'eastern_european', 'dinner')

ON CONFLICT DO NOTHING;

-- dish_ingredients Eastern European
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Голубцы с мясом' AND i.name IN ('Капуста','Фарш','Рис','Лук','Морковь','Томатная паста','Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Польский бигос' AND i.name IN ('Капуста','Свинина','Сосиски','Морковь','Лук','Томатная паста')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Свекольник холодный' AND i.name IN ('Свекла','Огурцы','Яйца','Лук зеленый','Редис','Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Чешский гуляш' AND i.name IN ('Говядина','Лук','Морковь','Томатная паста','Паприка','Масло растительное')
ON CONFLICT DO NOTHING;

-- recipes Eastern European
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Аккуратно отделить крупные листья капусты, бланшировать в кипятке 3-5 минут до гибкости."},{"step":2,"description":"Смешать фарш с варёным рисом, пассерованным луком и морковью. Посолить, поперчить."},{"step":3,"description":"Завернуть начинку в капустные листья конвертиком."},{"step":4,"description":"Обжарить голубцы в масле с двух сторон до румяного цвета."},{"step":5,"description":"Приготовить соус: томатная паста + вода + сметана. Залить голубцы."},{"step":6,"description":"Тушить под крышкой 40-50 минут на медленном огне."}]'
FROM dishes WHERE name = 'Голубцы с мясом'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать свинину кубиками, колбасу — кружочками."},{"step":2,"description":"Обжарить свинину до румяности, добавить лук и морковь, обжарить ещё 5 минут."},{"step":3,"description":"Отжать квашеную капусту от рассола, добавить к мясу."},{"step":4,"description":"Добавить колбасу, томатную пасту и 300 мл воды."},{"step":5,"description":"Тушить на медленном огне 1-1,5 часа — бигос должен стать тёмным и ароматным."},{"step":6,"description":"Настоящий бигос вкуснее на следующий день. Подавать с хлебом."}]'
FROM dishes WHERE name = 'Польский бигос'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить свёклу в кожуре до мягкости (40-50 мин) или запечь в духовке. Охладить, натереть."},{"step":2,"description":"Отварить яйца вкрутую, охладить, порезать."},{"step":3,"description":"Нарезать огурцы, редис и зелёный лук."},{"step":4,"description":"Смешать кефир со сметаной в соотношении 3:1, приправить."},{"step":5,"description":"Добавить все овощи в кефирную основу, перемешать."},{"step":6,"description":"Подавать холодным, положив яйца сверху."}]'
FROM dishes WHERE name = 'Свекольник холодный'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать говядину кубиками, лук — полукольцами."},{"step":2,"description":"Обжарить говядину до корочки на сильном огне. Убрать."},{"step":3,"description":"Обжарить лук до золотистости, добавить морковь, тушить 5 минут."},{"step":4,"description":"Вернуть мясо, добавить паприку, томатную пасту и 300 мл тёмного пива."},{"step":5,"description":"Тушить 1,5-2 часа на медленном огне до мягкости говядины."},{"step":6,"description":"Подавать с хлебными кнедликами или картофельными галушками."}]'
FROM dishes WHERE name = 'Чешский гуляш'
ON CONFLICT DO NOTHING;

-- ============================================================
-- СРЕДИЗЕМНОМОРСКАЯ КУХНЯ (+4 блюда → итого 8)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Шакшука',
 'Яйца, сваренные в остром томатном соусе с перцем — израильский завтрак',
 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=520&fit=crop&q=80',
 25, 'easy', 2, 6.00, TRUE, FALSE, 'mediterranean', 'breakfast'),

('Фалафель',
 'Хрустящие шарики из нута со специями — веганская классика',
 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80',
 45, 'medium', 4, 5.00, TRUE, TRUE, 'mediterranean', 'lunch'),

('Долма',
 'Виноградные листья с начинкой из риса, мяса и ароматных трав',
 'https://images.unsplash.com/photo-1544025162-d76538415e0f?w=400&h=520&fit=crop&q=80',
 90, 'hard', 4, 12.00, FALSE, FALSE, 'mediterranean', 'dinner'),

('Тажин с курицей',
 'Марокканское блюдо из курицы с лимоном и оливками',
 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80',
 70, 'medium', 4, 14.00, FALSE, FALSE, 'mediterranean', 'dinner')

ON CONFLICT DO NOTHING;

-- dish_ingredients Mediterranean
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Шакшука' AND i.name IN ('Яйца','Помидоры','Перец болгарский','Лук','Чеснок','Томатная паста','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Фалафель' AND i.name IN ('Нут','Лук','Чеснок','Петрушка','Мука','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Долма' AND i.name IN ('Фарш','Рис','Лук','Помидоры','Петрушка','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тажин с курицей' AND i.name IN ('Курица','Лук','Чеснок','Лимон','Помидоры','Масло растительное')
ON CONFLICT DO NOTHING;

-- recipes Mediterranean
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать лук полукольцами, перец полосками, чеснок — мелко."},{"step":2,"description":"Обжарить лук и перец на масле 5 минут. Добавить чеснок."},{"step":3,"description":"Добавить томатную пасту и нарезанные помидоры. Тушить 10 минут."},{"step":4,"description":"Добавить паприку, острый перец, соль — соус должен быть густым."},{"step":5,"description":"Сделать углубления в соусе ложкой, вбить яйца."},{"step":6,"description":"Накрыть крышкой, готовить на слабом огне 5-7 минут. Желток слегка жидким. Подавать с хлебом."}]'
FROM dishes WHERE name = 'Шакшука'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замочить нут на ночь. Слить воду."},{"step":2,"description":"Измельчить нут, лук, чеснок и зелень в блендере — не до пасты, нужна текстура."},{"step":3,"description":"Добавить муку, кумин, кориандр, соль. Перемешать."},{"step":4,"description":"Дать постоять в холодильнике 30 минут — масса станет плотнее."},{"step":5,"description":"Сформировать шарики или котлетки диаметром 3-4 см."},{"step":6,"description":"Жарить во фритюре при 170°C 3-4 минуты до золотистости. Подавать с питой и хумусом."}]'
FROM dishes WHERE name = 'Фалафель'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Смешать фарш с отварным рисом, луком, петрушкой, солью и перцем."},{"step":2,"description":"Промыть виноградные листья (из банки или свежие бланшированные)."},{"step":3,"description":"Выложить начинку у основания листа, завернуть: сначала края, потом рулетик."},{"step":4,"description":"Выложить долму плотными рядами в кастрюлю."},{"step":5,"description":"Залить горячей водой наполовину, добавить масло и соль. Накрыть тарелкой-прессом."},{"step":6,"description":"Тушить 45-60 минут. Подавать со сметаной или йогуртом."}]'
FROM dishes WHERE name = 'Долма'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать курицу на части, натереть смесью специй (зира, кориандр, паприка, соль)."},{"step":2,"description":"Обжарить курицу до золотистой корочки, убрать."},{"step":3,"description":"Обжарить нарезанный лук и чеснок 5 минут."},{"step":4,"description":"Добавить нарезанные помидоры, тушить 5 минут."},{"step":5,"description":"Вернуть курицу, добавить ломтики лимона и немного воды."},{"step":6,"description":"Тушить 40-45 минут. Подавать с кус-кусом или рисом и зеленью."}]'
FROM dishes WHERE name = 'Тажин с курицей'
ON CONFLICT DO NOTHING;

-- ============================================================
-- РУССКАЯ КУХНЯ — дополнительные блюда (+5 блюд)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Пельмени домашние с говядиной',
 'Классические пельмени с говяжим и свиным фаршем — домашний рецепт',
 'https://images.unsplash.com/photo-1585032226651-759b792d2727?w=400&h=520&fit=crop&q=80',
 120, 'hard', 6, 11.00, FALSE, FALSE, 'russian', 'dinner'),

('Расстегай с рыбой',
 'Открытый пирожок с рыбной начинкой — русская кулинарная классика',
 'https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=400&h=520&fit=crop&q=80',
 60, 'medium', 6, 9.00, FALSE, FALSE, 'russian', 'snack'),

('Капустный пирог',
 'Дрожжевой пирог с капустой и яйцом — бабушкин рецепт',
 'https://images.unsplash.com/photo-1565958011703-44f9829ba187?w=400&h=520&fit=crop&q=80',
 90, 'medium', 8, 6.00, TRUE, FALSE, 'russian', 'snack'),

('Рыба в кляре',
 'Сочные кусочки рыбы в хрустящем кляре — просто и вкусно',
 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80',
 30, 'easy', 2, 10.00, FALSE, FALSE, 'russian', 'dinner'),

('Окрошка на кефире',
 'Холодный летний суп с овощами и мясом на кефире — освежающее блюдо',
 'https://images.unsplash.com/photo-1547592166-23ac786af7ea?w=400&h=520&fit=crop&q=80',
 20, 'easy', 4, 5.00, FALSE, FALSE, 'russian', 'lunch')

ON CONFLICT DO NOTHING;

-- dish_ingredients Russian extras
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Пельмени домашние с говядиной' AND i.name IN ('Говядина','Свинина','Лук','Мука','Яйца','Соль','Перец черный')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Расстегай с рыбой' AND i.name IN ('Мука','Семга','Рис','Масло сливочное','Яйца','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Капустный пирог' AND i.name IN ('Мука','Капуста','Яйца','Масло сливочное','Соль','Лук')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рыба в кляре' AND i.name IN ('Семга','Мука','Яйца','Молоко','Масло растительное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Окрошка на кефире' AND i.name IN ('Картофель','Огурцы','Редис','Яйца','Лук зеленый','Укроп','Сосиски','Сметана')
ON CONFLICT DO NOTHING;

-- recipes Russian extras
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замесить крутое тесто из муки, воды, яйца и соли. Дать отдохнуть 30 минут под плёнкой."},{"step":2,"description":"Прокрутить говядину и свинину через мясорубку вместе с луком."},{"step":3,"description":"Добавить в фарш соль, перец и немного воды для сочности."},{"step":4,"description":"Раскатать тесто тонко, вырезать кружки стаканом диаметром 7 см."},{"step":5,"description":"Выложить начинку, сложить пополам и слепить края, затем скрепить концы."},{"step":6,"description":"Варить в подсоленной воде 6-8 минут после всплытия. Подавать со сметаной."}]'
FROM dishes WHERE name = 'Пельмени домашние с говядиной'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замесить дрожжевое тесто, дать подойти 1 час в тепле."},{"step":2,"description":"Нарезать рыбное филе кубиками, смешать с отварным рисом, маслом и солью."},{"step":3,"description":"Разделить тесто на порции, раскатать лепёшки."},{"step":4,"description":"Выложить начинку в центр, сформировать лодочку с открытым верхом."},{"step":5,"description":"Дать расстояться 20 минут. Смазать яйцом."},{"step":6,"description":"Запекать при 200°C 20-25 минут до золотистого цвета."}]'
FROM dishes WHERE name = 'Расстегай с рыбой'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нашинковать капусту, потушить с маслом и луком 20 минут. Посолить, добавить вареные рубленые яйца."},{"step":2,"description":"Замесить дрожжевое тесто, дать подойти 1-1,5 часа."},{"step":3,"description":"Разделить тесто на две части. Раскатать один пласт — дно пирога."},{"step":4,"description":"Выложить начинку равномерно, накрыть вторым пластом теста."},{"step":5,"description":"Защипать края, сделать надрез или дырочку в центре."},{"step":6,"description":"Дать расстояться 20 минут, смазать яйцом. Запекать при 180°C 30-35 минут."}]'
FROM dishes WHERE name = 'Капустный пирог'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать рыбное филе кусочками, посолить и поперчить."},{"step":2,"description":"Приготовить кляр: взбить яйца, добавить молоко и муку — должно быть без комков."},{"step":3,"description":"Обмакнуть каждый кусочек рыбы в кляр."},{"step":4,"description":"Разогреть масло в сковороде — оно должно быть горячим."},{"step":5,"description":"Обжаривать кусочки по 3-4 минуты с каждой стороны до румяной корочки."},{"step":6,"description":"Выложить на бумажное полотенце. Подавать с лимоном и зеленью."}]'
FROM dishes WHERE name = 'Рыба в кляре'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить картофель и яйца, охладить и нарезать кубиками."},{"step":2,"description":"Нарезать свежие огурцы и редис тонкими ломтиками, зелёный лук — мелко."},{"step":3,"description":"Нарезать отварные сосиски или варёную колбасу кубиками."},{"step":4,"description":"Смешать все ингредиенты в кастрюле, залить кефиром."},{"step":5,"description":"Добавить сметану, соль, укроп. При желании разбавить холодной кипячёной водой."},{"step":6,"description":"Охладить перед подачей минимум 30 минут. Подавать холодным."}]'
FROM dishes WHERE name = 'Окрошка на кефире'
ON CONFLICT DO NOTHING;
