-- ============================================================
-- What2Eat: Recipe database schema (PostgreSQL)
-- ============================================================

CREATE TABLE IF NOT EXISTS ingredients (
  id               SERIAL PRIMARY KEY,
  name             TEXT UNIQUE NOT NULL,
  category         TEXT NOT NULL CHECK (category IN ('meat','cereals','vegetables','dairy','spices','other')),
  image_url        TEXT,
  show_in_selector BOOLEAN NOT NULL DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS dishes (
  id             SERIAL PRIMARY KEY,
  name           TEXT NOT NULL,
  description    TEXT,
  image_url      TEXT,
  cooking_time   INTEGER NOT NULL,
  difficulty     TEXT NOT NULL CHECK (difficulty IN ('easy','medium','hard')),
  servings       INTEGER NOT NULL DEFAULT 4,
  estimated_cost NUMERIC(8,2),
  is_vegetarian  BOOLEAN NOT NULL DEFAULT FALSE,
  is_vegan       BOOLEAN NOT NULL DEFAULT FALSE,
  cuisine_type   TEXT NOT NULL DEFAULT 'russian',
  meal_type      TEXT NOT NULL DEFAULT 'dinner'
);

CREATE TABLE IF NOT EXISTS dish_ingredients (
  dish_id       INTEGER NOT NULL REFERENCES dishes(id)      ON DELETE CASCADE,
  ingredient_id INTEGER NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
  PRIMARY KEY (dish_id, ingredient_id)
);

-- instructions stored as TEXT (parsed by JS at read time)
CREATE TABLE IF NOT EXISTS recipes (
  id           SERIAL PRIMARY KEY,
  dish_id      INTEGER NOT NULL UNIQUE REFERENCES dishes(id) ON DELETE CASCADE,
  instructions TEXT NOT NULL DEFAULT '[]'
);

CREATE TABLE IF NOT EXISTS recipe_ingredients (
  recipe_id     INTEGER NOT NULL REFERENCES recipes(id)     ON DELETE CASCADE,
  ingredient_id INTEGER NOT NULL REFERENCES ingredients(id) ON DELETE CASCADE,
  quantity      NUMERIC(10,2) NOT NULL,
  unit          TEXT NOT NULL,
  PRIMARY KEY (recipe_id, ingredient_id)
);

CREATE INDEX IF NOT EXISTS idx_dish_ingredients_dish_id       ON dish_ingredients(dish_id);
CREATE INDEX IF NOT EXISTS idx_dish_ingredients_ingredient_id ON dish_ingredients(ingredient_id);
CREATE INDEX IF NOT EXISTS idx_ingredients_category           ON ingredients(category);
CREATE INDEX IF NOT EXISTS idx_recipe_ingredients_recipe_id   ON recipe_ingredients(recipe_id);
CREATE INDEX IF NOT EXISTS idx_dishes_cuisine                 ON dishes(cuisine_type);
CREATE INDEX IF NOT EXISTS idx_dishes_meal                    ON dishes(meal_type);

-- RLS: public read, service_role write
ALTER TABLE ingredients        ENABLE ROW LEVEL SECURITY;
ALTER TABLE dishes             ENABLE ROW LEVEL SECURITY;
ALTER TABLE dish_ingredients   ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipes            ENABLE ROW LEVEL SECURITY;
ALTER TABLE recipe_ingredients ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public read ingredients"        ON ingredients        FOR SELECT USING (true);
CREATE POLICY "Public read dishes"             ON dishes             FOR SELECT USING (true);
CREATE POLICY "Public read dish_ingredients"   ON dish_ingredients   FOR SELECT USING (true);
CREATE POLICY "Public read recipes"            ON recipes            FOR SELECT USING (true);
CREATE POLICY "Public read recipe_ingredients" ON recipe_ingredients FOR SELECT USING (true);

CREATE POLICY "Service write ingredients"        ON ingredients        FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "Service write dishes"             ON dishes             FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "Service write dish_ingredients"   ON dish_ingredients   FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "Service write recipes"            ON recipes            FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY "Service write recipe_ingredients" ON recipe_ingredients FOR ALL USING (auth.role() = 'service_role');
-- PostgreSQL seed for What2Eat
-- Auto-converted from SQLite seed.sql
-- recipe_ingredients for dishes 1-40 REMOVED (had wrong ingredient IDs)
-- Use name-based subqueries for all new dishes

-- Начальные данные для базы данных "ЧтоЕсть"

-- Ингредиенты
INSERT INTO ingredients (name, category, image_url) VALUES
('Курица', 'meat', '/images/ingredients/chicken.jpg'),
('Говядина', 'meat', '/images/ingredients/beef.jpg'),
('Свинина', 'meat', '/images/ingredients/pork.jpg'),
('Макароны', 'cereals', '/images/ingredients/pasta.jpg'),
('Гречка', 'cereals', '/images/ingredients/buckwheat.jpg'),
('Рис', 'cereals', '/images/ingredients/rice.jpg'),
('Овсянка', 'cereals', '/images/ingredients/oatmeal.jpg'),
('Лук', 'vegetables', '/images/ingredients/onion.jpg'),
('Морковь', 'vegetables', '/images/ingredients/carrot.jpg'),
('Помидоры', 'vegetables', '/images/ingredients/tomatoes.jpg'),
('Картофель', 'vegetables', '/images/ingredients/potato.jpg'),
('Перец болгарский', 'vegetables', '/images/ingredients/bell-pepper.jpg'),
('Чеснок', 'vegetables', '/images/ingredients/garlic.jpg'),
('Огурцы', 'vegetables', '/images/ingredients/cucumber.jpg'),
('Капуста', 'vegetables', '/images/ingredients/cabbage.jpg'),
('Кабачки', 'vegetables', '/images/ingredients/zucchini.jpg'),
('Баклажаны', 'vegetables', '/images/ingredients/eggplant.jpg'),
('Свекла', 'vegetables', '/images/ingredients/beetroot.jpg'),
('Редис', 'vegetables', '/images/ingredients/radish.jpg'),
('Укроп', 'vegetables', '/images/ingredients/dill.jpg'),
('Петрушка', 'vegetables', '/images/ingredients/parsley.jpg'),
('Шпинат', 'vegetables', '/images/ingredients/spinach.jpg'),
('Брокколи', 'vegetables', '/images/ingredients/broccoli.jpg'),
('Цветная капуста', 'vegetables', '/images/ingredients/cauliflower.jpg'),
('Лук зеленый', 'vegetables', '/images/ingredients/green-onion.jpg'),
('Сельдерей', 'vegetables', '/images/ingredients/celery.jpg'),
('Тыква', 'vegetables', '/images/ingredients/pumpkin.jpg'),
('Молоко', 'dairy', '/images/ingredients/milk.jpg'),
('Сыр', 'dairy', '/images/ingredients/cheese.jpg'),
('Сметана', 'dairy', '/images/ingredients/sour-cream.jpg'),
('Яйца', 'dairy', '/images/ingredients/eggs.jpg'),
('Соль', 'spices', '/images/ingredients/salt.jpg'),
('Перец черный', 'spices', '/images/ingredients/black-pepper.jpg'),
('Масло растительное', 'other', '/images/ingredients/vegetable-oil.jpg'),
('Масло сливочное', 'dairy', '/images/ingredients/butter.jpg'),
('Фарш', 'meat', '/images/ingredients/minced-meat.jpg'),
('Сосиски', 'meat', '/images/ingredients/sausages.jpg')
ON CONFLICT DO NOTHING;

-- Блюда
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan) VALUES
('Макароны с курицей', 'Сытное и простое блюдо из макарон и курицы', 'https://images.unsplash.com/photo-1563379906659-ee70c0c47ba6?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 8.00, FALSE, FALSE),
('Гречка с курицей', 'Классическое блюдо русской кухни', 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80', 40, 'easy', 4, 8.00, FALSE, FALSE),
('Рис с курицей', 'Вкусное блюдо из риса и курицы', 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 8.00, FALSE, FALSE),
('Макароны по-флотски', 'Макароны с говяжьим фаршем', 'https://images.unsplash.com/photo-1555396273-122e7a6ce434?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 9.00, FALSE, FALSE),
('Гречневая каша с мясом', 'Сытная гречка с говядиной', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80', 50, 'medium', 4, 10.00, FALSE, FALSE),
('Картофель с курицей', 'Запеченный картофель с курицей', 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80', 45, 'easy', 4, 9.00, FALSE, FALSE),
('Макароны с говядиной', 'Макароны с тушеной говядиной', 'https://images.unsplash.com/photo-1551218372-a8789b81b253?w=400&h=520&fit=crop&q=80', 45, 'medium', 4, 11.00, FALSE, FALSE),
('Макароны со свининой', 'Макароны с обжаренной свининой', 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 10.00, FALSE, FALSE),
('Рис с говядиной', 'Рис с тушеной говядиной', 'https://images.unsplash.com/photo-1544025162-d76538415e0f?w=400&h=520&fit=crop&q=80', 50, 'medium', 4, 11.00, FALSE, FALSE),
('Рис со свининой', 'Рис с обжаренной свининой', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 40, 'easy', 4, 10.00, FALSE, FALSE),
('Гречка со свининой', 'Гречка с обжаренной свининой', 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80', 45, 'easy', 4, 10.00, FALSE, FALSE),
('Овсянка с курицей', 'Овсяная каша с курицей', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 7.00, FALSE, FALSE),
('Овсянка с говядиной', 'Овсяная каша с говядиной', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 40, 'medium', 4, 9.00, FALSE, FALSE),
('Овсянка со свининой', 'Овсяная каша со свининой', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 8.00, FALSE, FALSE),
('Картофель с говядиной', 'Запеченный картофель с говядиной', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 55, 'medium', 4, 12.00, FALSE, FALSE),
('Картофель со свининой', 'Запеченный картофель со свининой', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 50, 'easy', 4, 10.00, FALSE, FALSE),
('Макароны с яичницей', 'Макароны с жареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 20, 'easy', 4, 4.00, TRUE, FALSE),
('Гречка с яичницей', 'Гречка с жареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 4.00, TRUE, FALSE),
('Рис с яичницей', 'Рис с жареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 4.00, TRUE, FALSE),
('Картофель с яичницей', 'Картофель с жареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 4.00, TRUE, FALSE),
('Макароны с вареными яйцами', 'Макароны с вареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 20, 'easy', 4, 3.00, TRUE, FALSE),
('Гречка с вареными яйцами', 'Гречка с вареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 3.00, TRUE, FALSE),
('Рис с вареными яйцами', 'Рис с вареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 3.00, TRUE, FALSE),
('Картофель с вареными яйцами', 'Картофель с вареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 4.00, TRUE, FALSE),
('Макароны с овощами', 'Макароны с помидорами, луком и морковью', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 5.00, TRUE, TRUE),
('Гречка с овощами', 'Гречка с морковью, луком и помидорами', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 4.00, TRUE, TRUE),
('Рис с овощами', 'Рис с морковью, луком и помидорами', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 4.00, TRUE, TRUE),
('Картофель с овощами', 'Запеченный картофель с овощами', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80', 40, 'easy', 4, 4.00, TRUE, TRUE),
('Макароны с сыром', 'Макароны с тертым сыром', 'https://images.unsplash.com/photo-1618164435735-2cfee3e07c36?w=400&h=520&fit=crop&q=80', 20, 'easy', 4, 5.00, TRUE, FALSE),
('Гречка с грибами и луком', 'Гречка с обжаренными грибами и луком', 'https://images.unsplash.com/photo-1506807803488-8eafc15316c9?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 4.00, TRUE, TRUE),
('Рис с курицей и овощами', 'Рис с курицей, морковью и луком', 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&h=520&fit=crop&q=80', 40, 'easy', 4, 9.00, FALSE, FALSE),
('Картофель с курицей и овощами', 'Запеченный картофель с курицей и овощами', 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80', 50, 'medium', 4, 10.00, FALSE, FALSE),
('Овсяная каша с молоком', 'Классическая овсяная каша на молоке', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 2.00, TRUE, FALSE),
('Котлеты из фарша', 'Классические котлеты из мясного фарша', 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 9.00, FALSE, FALSE),
('Макароны с сосисками', 'Простое и сытное блюдо из макарон и сосисок', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 20, 'easy', 4, 6.00, FALSE, FALSE),
('Сосиски с картофелем', 'Жареные сосиски с картофелем', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 7.00, FALSE, FALSE),
('Сосиски с гречкой', 'Гречка с жареными сосисками', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 7.00, FALSE, FALSE),
('Сосиски с рисом', 'Рис с жареными сосисками', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 7.00, FALSE, FALSE),
('Фарш с макаронами', 'Макароны с мясным фаршем и луком', 'https://images.unsplash.com/photo-1555396273-122e7a6ce434?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 8.00, FALSE, FALSE),
('Фарш с картофелем', 'Жареный фарш с картофелем', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 8.00, FALSE, FALSE)
ON CONFLICT DO NOTHING;

-- Связи блюд и ингредиентов
-- Макароны с курицей (id=1)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(1, 1), -- Курица
(1, 4), -- Макароны
(1, 8), -- Лук
(1, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Гречка с курицей (id=2)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(2, 1), -- Курица
(2, 5), -- Гречка
(2, 8), -- Лук
(2, 9), -- Морковь
(2, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Рис с курицей (id=3)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(3, 1), -- Курица
(3, 6), -- Рис
(3, 8), -- Лук
(3, 9), -- Морковь
(3, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Макароны по-флотски (id=4)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(4, 2), -- Говядина
(4, 4), -- Макароны
(4, 8), -- Лук
(4, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Гречневая каша с мясом (id=5)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(5, 2), -- Говядина
(5, 5), -- Гречка
(5, 8), -- Лук
(5, 9), -- Морковь
(5, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Картофель с курицей (id=6)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(6, 1), -- Курица
(6, 11), -- Картофель
(6, 8), -- Лук
(6, 13), -- Чеснок
(6, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Макароны с говядиной (id=7)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(7, 2), -- Говядина
(7, 4), -- Макароны
(7, 8), -- Лук
(7, 9), -- Морковь
(7, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Макароны со свининой (id=8)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(8, 3), -- Свинина
(8, 4), -- Макароны
(8, 8), -- Лук
(8, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Рис с говядиной (id=9)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(9, 2), -- Говядина
(9, 6), -- Рис
(9, 8), -- Лук
(9, 9), -- Морковь
(9, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Рис со свининой (id=10)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(10, 3), -- Свинина
(10, 6), -- Рис
(10, 8), -- Лук
(10, 9), -- Морковь
(10, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Гречка со свининой (id=11)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(11, 3), -- Свинина
(11, 5), -- Гречка
(11, 8), -- Лук
(11, 9), -- Морковь
(11, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Овсянка с курицей (id=12)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(12, 1), -- Курица
(12, 7), -- Овсянка
(12, 8), -- Лук
(12, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Овсянка с говядиной (id=13)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(13, 2), -- Говядина
(13, 7), -- Овсянка
(13, 8), -- Лук
(13, 9), -- Морковь
(13, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Овсянка со свининой (id=14)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(14, 3), -- Свинина
(14, 7), -- Овсянка
(14, 8), -- Лук
(14, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Картофель с говядиной (id=15)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(15, 2), -- Говядина
(15, 11), -- Картофель
(15, 8), -- Лук
(15, 13), -- Чеснок
(15, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Картофель со свининой (id=16)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(16, 3), -- Свинина
(16, 11), -- Картофель
(16, 8), -- Лук
(16, 13), -- Чеснок
(16, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Макароны с яичницей (id=17)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(17, 31), -- Яйца
(17, 4), -- Макароны
(17, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Гречка с яичницей (id=18)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(18, 31), -- Яйца
(18, 5), -- Гречка
(18, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Рис с яичницей (id=19)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(19, 31), -- Яйца
(19, 6), -- Рис
(19, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Картофель с яичницей (id=20)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(20, 31), -- Яйца
(20, 11), -- Картофель
(20, 8), -- Лук
(20, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Макароны с вареными яйцами (id=21)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(21, 31), -- Яйца
(21, 4)
ON CONFLICT DO NOTHING; -- Макароны

-- Гречка с вареными яйцами (id=22)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(22, 31), -- Яйца
(22, 5)
ON CONFLICT DO NOTHING; -- Гречка

-- Рис с вареными яйцами (id=23)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(23, 31), -- Яйца
(23, 6)
ON CONFLICT DO NOTHING; -- Рис

-- Картофель с вареными яйцами (id=24)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(24, 31), -- Яйца
(24, 11)
ON CONFLICT DO NOTHING; -- Картофель

-- Макароны с овощами (id=25)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(25, 4), -- Макароны
(25, 10), -- Помидоры
(25, 8), -- Лук
(25, 9), -- Морковь
(25, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Гречка с овощами (id=26)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(26, 5), -- Гречка
(26, 9), -- Морковь
(26, 8), -- Лук
(26, 10), -- Помидоры
(26, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Рис с овощами (id=27)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(27, 6), -- Рис
(27, 9), -- Морковь
(27, 8), -- Лук
(27, 10), -- Помидоры
(27, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Картофель с овощами (id=28)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(28, 11), -- Картофель
(28, 9), -- Морковь
(28, 8), -- Лук
(28, 10), -- Помидоры
(28, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Макароны с сыром (id=29)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(29, 4), -- Макароны
(29, 29)
ON CONFLICT DO NOTHING; -- Сыр

-- Гречка с грибами и луком (id=30)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(30, 5), -- Гречка
(30, 8), -- Лук
(30, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Рис с курицей и овощами (id=31)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(31, 6), -- Рис
(31, 1), -- Курица
(31, 9), -- Морковь
(31, 8), -- Лук
(31, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Картофель с курицей и овощами (id=32)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(32, 11), -- Картофель
(32, 1), -- Курица
(32, 9), -- Морковь
(32, 8), -- Лук
(32, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Овсяная каша с молоком (id=33)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(33, 7), -- Овсянка
(33, 28)
ON CONFLICT DO NOTHING; -- Молоко

-- Котлеты из фарша (id=34)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(34, 36), -- Фарш
(34, 8), -- Лук
(34, 31), -- Яйца
(34, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Макароны с сосисками (id=35)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(35, 4), -- Макароны
(35, 37), -- Сосиски
(35, 8), -- Лук
(35, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Сосиски с картофелем (id=36)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(36, 37), -- Сосиски
(36, 11), -- Картофель
(36, 8), -- Лук
(36, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Сосиски с гречкой (id=37)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(37, 37), -- Сосиски
(37, 5), -- Гречка
(37, 8), -- Лук
(37, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Сосиски с рисом (id=38)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(38, 37), -- Сосиски
(38, 6), -- Рис
(38, 8), -- Лук
(38, 9), -- Морковь
(38, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Фарш с макаронами (id=39)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(39, 36), -- Фарш
(39, 4), -- Макароны
(39, 8), -- Лук
(39, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Фарш с картофелем (id=40)
INSERT INTO dish_ingredients (dish_id, ingredient_id) VALUES
(40, 36), -- Фарш
(40, 11), -- Картофель
(40, 8), -- Лук
(40, 9), -- Морковь
(40, 34)
ON CONFLICT DO NOTHING; -- Масло растительное

-- Рецепты
INSERT INTO recipes (dish_id, instructions) VALUES
(1, '[
  {"step": 1, "description": "Нарезать курицу кубиками среднего размера"},
  {"step": 2, "description": "Нарезать лук полукольцами"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить лук до прозрачности, затем добавить курицу"},
  {"step": 5, "description": "Обжарить курицу до золотистого цвета, посолить и поперчить"},
  {"step": 6, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 7, "description": "Смешать готовые макароны с курицей и подавать горячим"}
]'),

(2, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать курицу кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить лук и морковь на сковороде"},
  {"step": 4, "description": "Добавить курицу и обжарить до готовности"},
  {"step": 5, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовую гречку с курицей и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(3, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать курицу кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить лук и морковь на сковороде"},
  {"step": 4, "description": "Добавить курицу и обжарить до готовности"},
  {"step": 5, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовый рис с курицей и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(4, '[
  {"step": 1, "description": "Нарезать лук мелко"},
  {"step": 2, "description": "Обжарить лук на сковороде до золотистого цвета"},
  {"step": 3, "description": "Добавить мясной фарш и обжарить до готовности"},
  {"step": 4, "description": "Посолить и поперчить по вкусу"},
  {"step": 5, "description": "Отварить макароны согласно инструкции"},
  {"step": 6, "description": "Смешать макароны с фаршем и подавать"}
]'),

(5, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать говядину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить мясо до образования корочки"},
  {"step": 4, "description": "Добавить лук и морковь, тушить 10 минут"},
  {"step": 5, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовую гречку с мясом и овощами"},
  {"step": 7, "description": "Тушить еще 5 минут и подавать"}
]'),

(6, '[
  {"step": 1, "description": "Нарезать картофель крупными кубиками"},
  {"step": 2, "description": "Нарезать курицу кубиками, лук и чеснок"},
  {"step": 3, "description": "Смешать все ингредиенты с растительным маслом"},
  {"step": 4, "description": "Посолить, поперчить, добавить специи"},
  {"step": 5, "description": "Выложить на противень и запекать при 200°C 35-40 минут"},
  {"step": 6, "description": "Подавать горячим"}
]'),

(7, '[
  {"step": 1, "description": "Нарезать говядину кубиками среднего размера"},
  {"step": 2, "description": "Нарезать лук и морковь"},
  {"step": 3, "description": "Обжарить говядину до образования корочки"},
  {"step": 4, "description": "Добавить лук и морковь, тушить 15 минут"},
  {"step": 5, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 6, "description": "Смешать готовые макароны с мясом и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(8, '[
  {"step": 1, "description": "Нарезать свинину кубиками среднего размера"},
  {"step": 2, "description": "Нарезать лук полукольцами"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить лук до прозрачности, затем добавить свинину"},
  {"step": 5, "description": "Обжарить свинину до готовности, посолить и поперчить"},
  {"step": 6, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 7, "description": "Смешать готовые макароны со свининой и подавать горячим"}
]'),

(9, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать говядину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить говядину до образования корочки"},
  {"step": 4, "description": "Добавить лук и морковь, тушить 10 минут"},
  {"step": 5, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовый рис с мясом и овощами"},
  {"step": 7, "description": "Тушить еще 5 минут и подавать"}
]'),

(10, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать свинину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить лук и морковь на сковороде"},
  {"step": 4, "description": "Добавить свинину и обжарить до готовности"},
  {"step": 5, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовый рис со свининой и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(11, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать свинину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить лук и морковь на сковороде"},
  {"step": 4, "description": "Добавить свинину и обжарить до готовности"},
  {"step": 5, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовую гречку со свининой и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(12, '[
  {"step": 1, "description": "Залить овсянку водой или молоком в соотношении 1:2"},
  {"step": 2, "description": "Нарезать курицу кубиками, лук"},
  {"step": 3, "description": "Обжарить лук на сковороде"},
  {"step": 4, "description": "Добавить курицу и обжарить до готовности"},
  {"step": 5, "description": "Варить овсянку на медленном огне 10-15 минут"},
  {"step": 6, "description": "Смешать готовую овсянку с курицей и луком"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(13, '[
  {"step": 1, "description": "Залить овсянку водой или молоком в соотношении 1:2"},
  {"step": 2, "description": "Нарезать говядину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить мясо до образования корочки"},
  {"step": 4, "description": "Добавить лук и морковь, тушить 10 минут"},
  {"step": 5, "description": "Варить овсянку на медленном огне 10-15 минут"},
  {"step": 6, "description": "Смешать готовую овсянку с мясом и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(14, '[
  {"step": 1, "description": "Залить овсянку водой или молоком в соотношении 1:2"},
  {"step": 2, "description": "Нарезать свинину кубиками, лук"},
  {"step": 3, "description": "Обжарить лук на сковороде"},
  {"step": 4, "description": "Добавить свинину и обжарить до готовности"},
  {"step": 5, "description": "Варить овсянку на медленном огне 10-15 минут"},
  {"step": 6, "description": "Смешать готовую овсянку со свининой и луком"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(15, '[
  {"step": 1, "description": "Нарезать картофель крупными кубиками"},
  {"step": 2, "description": "Нарезать говядину кубиками, лук и чеснок"},
  {"step": 3, "description": "Обжарить говядину до образования корочки"},
  {"step": 4, "description": "Смешать картофель, мясо, лук и чеснок с растительным маслом"},
  {"step": 5, "description": "Посолить, поперчить, добавить специи"},
  {"step": 6, "description": "Выложить на противень и запекать при 200°C 45-50 минут"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(16, '[
  {"step": 1, "description": "Нарезать картофель крупными кубиками"},
  {"step": 2, "description": "Нарезать свинину кубиками, лук и чеснок"},
  {"step": 3, "description": "Смешать все ингредиенты с растительным маслом"},
  {"step": 4, "description": "Посолить, поперчить, добавить специи"},
  {"step": 5, "description": "Выложить на противень и запекать при 200°C 40-45 минут"},
  {"step": 6, "description": "Подавать горячим"}
]'),

(17, '[
  {"step": 1, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 2, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 3, "description": "Разбить яйца в миску, посолить и взбить вилкой"},
  {"step": 4, "description": "Вылить яйца на сковороду и жарить, помешивая, до готовности"},
  {"step": 5, "description": "Смешать готовые макароны с яичницей"},
  {"step": 6, "description": "Подавать горячим"}
]'),

(18, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Разбить яйца в миску, посолить и взбить вилкой"},
  {"step": 5, "description": "Вылить яйца на сковороду и жарить, помешивая, до готовности"},
  {"step": 6, "description": "Смешать готовую гречку с яичницей и подавать"}
]'),

(19, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Разбить яйца в миску, посолить и взбить вилкой"},
  {"step": 5, "description": "Вылить яйца на сковороду и жарить, помешивая, до готовности"},
  {"step": 6, "description": "Смешать готовый рис с яичницей и подавать"}
]'),

(20, '[
  {"step": 1, "description": "Отварить картофель в мундире или очищенный до готовности"},
  {"step": 2, "description": "Нарезать картофель кубиками, лук"},
  {"step": 3, "description": "Обжарить картофель с луком на сковороде"},
  {"step": 4, "description": "Разбить яйца в миску, посолить и взбить вилкой"},
  {"step": 5, "description": "Вылить яйца на картофель и жарить, помешивая, до готовности"},
  {"step": 6, "description": "Подавать горячим"}
]'),

(21, '[
  {"step": 1, "description": "Отварить яйца вкрутую (7-8 минут после закипания)"},
  {"step": 2, "description": "Охладить яйца в холодной воде и очистить"},
  {"step": 3, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 4, "description": "Нарезать яйца кубиками или дольками"},
  {"step": 5, "description": "Смешать макароны с яйцами"},
  {"step": 6, "description": "Подавать, можно добавить масло или сметану"}
]'),

(22, '[
  {"step": 1, "description": "Отварить яйца вкрутую (7-8 минут после закипания)"},
  {"step": 2, "description": "Охладить яйца в холодной воде и очистить"},
  {"step": 3, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 4, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 5, "description": "Нарезать яйца кубиками или дольками"},
  {"step": 6, "description": "Смешать готовую гречку с яйцами и подавать"}
]'),

(23, '[
  {"step": 1, "description": "Отварить яйца вкрутую (7-8 минут после закипания)"},
  {"step": 2, "description": "Охладить яйца в холодной воде и очистить"},
  {"step": 3, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 4, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 5, "description": "Нарезать яйца кубиками или дольками"},
  {"step": 6, "description": "Смешать готовый рис с яйцами и подавать"}
]'),

(24, '[
  {"step": 1, "description": "Отварить яйца вкрутую (7-8 минут после закипания)"},
  {"step": 2, "description": "Охладить яйца в холодной воде и очистить"},
  {"step": 3, "description": "Отварить картофель до готовности"},
  {"step": 4, "description": "Нарезать картофель кубиками"},
  {"step": 5, "description": "Нарезать яйца кубиками или дольками"},
  {"step": 6, "description": "Смешать картофель с яйцами, можно добавить масло или сметану"},
  {"step": 7, "description": "Подавать"}
]'),

(33, '[
  {"step": 1, "description": "Влить молоко в кастрюлю и довести до кипения"},
  {"step": 2, "description": "Добавить овсянку в кипящее молоко"},
  {"step": 3, "description": "Варить на медленном огне, помешивая, 10-15 минут"},
  {"step": 4, "description": "Добавить соль по вкусу"},
  {"step": 5, "description": "Подавать горячей, можно добавить масло"}
]'),

(34, '[
  {"step": 1, "description": "Нарезать лук мелко"},
  {"step": 2, "description": "Смешать фарш с луком, яйцом, солью и перцем"},
  {"step": 3, "description": "Хорошо вымесить фарш до однородной массы"},
  {"step": 4, "description": "Сформировать котлеты округлой формы"},
  {"step": 5, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 6, "description": "Обжарить котлеты с обеих сторон до золотистой корочки"},
  {"step": 7, "description": "Уменьшить огонь и довести до готовности под крышкой 10-15 минут"},
  {"step": 8, "description": "Подавать горячими"}
]'),

(35, '[
  {"step": 1, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 2, "description": "Нарезать сосиски кружочками, лук полукольцами"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить лук до прозрачности"},
  {"step": 5, "description": "Добавить сосиски и обжарить до золотистого цвета"},
  {"step": 6, "description": "Посолить и поперчить по вкусу"},
  {"step": 7, "description": "Смешать готовые макароны с сосисками и луком"},
  {"step": 8, "description": "Подавать горячим"}
]'),

(36, '[
  {"step": 1, "description": "Очистить и нарезать картофель кубиками"},
  {"step": 2, "description": "Нарезать сосиски кружочками, лук полукольцами"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить картофель до золотистого цвета"},
  {"step": 5, "description": "Добавить лук и обжарить еще 5 минут"},
  {"step": 6, "description": "Добавить сосиски и обжарить все вместе 5-7 минут"},
  {"step": 7, "description": "Посолить и поперчить по вкусу"},
  {"step": 8, "description": "Подавать горячим"}
]'),

(37, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 3, "description": "Нарезать сосиски кружочками, лук полукольцами"},
  {"step": 4, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 5, "description": "Обжарить лук до прозрачности"},
  {"step": 6, "description": "Добавить сосиски и обжарить до золотистого цвета"},
  {"step": 7, "description": "Смешать готовую гречку с сосисками и луком"},
  {"step": 8, "description": "Посолить и поперчить по вкусу"},
  {"step": 9, "description": "Подавать горячим"}
]'),

(38, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 3, "description": "Нарезать сосиски кружочками, лук и морковь"},
  {"step": 4, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 5, "description": "Обжарить лук и морковь до мягкости"},
  {"step": 6, "description": "Добавить сосиски и обжарить до золотистого цвета"},
  {"step": 7, "description": "Смешать готовый рис с сосисками и овощами"},
  {"step": 8, "description": "Посолить и поперчить по вкусу"},
  {"step": 9, "description": "Подавать горячим"}
]'),

(39, '[
  {"step": 1, "description": "Нарезать лук мелко"},
  {"step": 2, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 3, "description": "Обжарить лук до золотистого цвета"},
  {"step": 4, "description": "Добавить фарш и обжарить, разминая вилкой, до готовности"},
  {"step": 5, "description": "Посолить и поперчить по вкусу"},
  {"step": 6, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 7, "description": "Смешать готовые макароны с фаршем"},
  {"step": 8, "description": "Подавать горячим"}
]'),

(40, '[
  {"step": 1, "description": "Очистить и нарезать картофель кубиками"},
  {"step": 2, "description": "Нарезать лук и морковь"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить лук и морковь до мягкости"},
  {"step": 5, "description": "Добавить фарш и обжарить, разминая вилкой, до готовности"},
  {"step": 6, "description": "Добавить картофель и обжарить все вместе 10-15 минут"},
  {"step": 7, "description": "Налить немного воды, накрыть крышкой и тушить до готовности картофеля"},
  {"step": 8, "description": "Посолить и поперчить по вкусу"},
  {"step": 9, "description": "Подавать горячим"}
]')
ON CONFLICT DO NOTHING;

-- Ингредиенты для рецептов (с количеством)
-- Макароны с курицей
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1606756790138-261d2b21cd75?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1551218372-a8789b81b253?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1544025162-d76538415e0f?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с вареными яйцами';
-- Исправление изображений: овощные блюда
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с овощами';

-- Установка meal_type для завтраков среди существующих блюд
UPDATE dishes SET meal_type = 'breakfast' WHERE name IN (
  'Макароны с яичницей', 'Гречка с яичницей', 'Рис с яичницей', 'Картофель с яичницей',
  'Макароны с вареными яйцами', 'Гречка с вареными яйцами', 'Рис с вареными яйцами',
  'Картофель с вареными яйцами', 'Овсяная каша с молоком');
-- Установка meal_type для обедов
UPDATE dishes SET meal_type = 'lunch' WHERE name IN ('Гречка с грибами и луком');

-- Новые ингредиенты
INSERT INTO ingredients (name, category, image_url) VALUES
('Творог', 'dairy', '/images/ingredients/cottage-cheese.jpg'),
('Грибы', 'vegetables', '/images/ingredients/mushrooms.jpg'),
('Бекон', 'meat', '/images/ingredients/bacon.jpg'),
('Мука', 'cereals', '/images/ingredients/flour.jpg'),
('Соевый соус', 'spices', '/images/ingredients/soy-sauce.jpg'),
('Томатная паста', 'other', '/images/ingredients/tomato-paste.jpg'),
('Лимон', 'vegetables', '/images/ingredients/lemon.jpg'),
('Имбирь', 'spices', '/images/ingredients/ginger.jpg'),
('Пармезан', 'dairy', '/images/ingredients/parmesan.jpg'),
('Горох', 'cereals', '/images/ingredients/peas.jpg'),
('Лапша', 'cereals', '/images/ingredients/noodles.jpg')
ON CONFLICT DO NOTHING;

-- ===========================
-- Новые блюда: завтраки
-- ===========================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Блины', 'Тонкие русские блины на молоке — классика завтрака', 'https://images.unsplash.com/photo-1519620831337-5e58b8e06bdb?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 3.00, TRUE, FALSE, 'russian', 'breakfast'),
('Сырники', 'Творожные сырники с румяной корочкой и сметаной', 'https://images.unsplash.com/photo-1568051243858-533a607809a5?w=400&h=520&fit=crop&q=80', 30, 'easy', 2, 4.00, TRUE, FALSE, 'russian', 'breakfast'),
('Омлет с сыром', 'Пышный омлет с тертым сыром и зеленью', 'https://images.unsplash.com/photo-1553481187-be93c21490a9?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 3.00, TRUE, FALSE, 'russian', 'breakfast'),
('Творожная запеканка', 'Нежная запеканка из творога, запеченная в духовке', 'https://images.unsplash.com/photo-1571748982800-fa51086c2a08?w=400&h=520&fit=crop&q=80', 50, 'easy', 4, 4.00, TRUE, FALSE, 'russian', 'breakfast')
ON CONFLICT DO NOTHING;

-- ===========================
-- Новые блюда: итальянская кухня
-- ===========================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Паста Карбонара', 'Классическая итальянская паста с беконом, яйцом и пармезаном', 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400&h=520&fit=crop&q=80', 25, 'medium', 2, 12.00, FALSE, FALSE, 'italian', 'dinner'),
('Ризотто с грибами', 'Кремовое ризотто с шампиньонами и пармезаном', 'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=400&h=520&fit=crop&q=80', 40, 'medium', 2, 11.00, TRUE, FALSE, 'italian', 'dinner'),
('Паста Болоньезе', 'Паста с густым мясным соусом болоньезе', 'https://images.unsplash.com/photo-1551183053-bf91798d047e?w=400&h=520&fit=crop&q=80', 55, 'medium', 4, 13.00, FALSE, FALSE, 'italian', 'dinner'),
('Лазанья', 'Слоёная лазанья с мясным фаршем и соусом бешамель', 'https://images.unsplash.com/photo-1574894709920-11b28be1e68e?w=400&h=520&fit=crop&q=80', 80, 'hard', 6, 15.00, FALSE, FALSE, 'italian', 'dinner')
ON CONFLICT DO NOTHING;

-- ===========================
-- Новые блюда: азиатская кухня
-- ===========================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Жареный рис с яйцом', 'Китайский жареный рис с яйцом и овощами', 'https://images.unsplash.com/photo-1603133872657-e48a571a0b69?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 5.00, TRUE, FALSE, 'asian', 'lunch'),
('Курица терияки', 'Сочная курица в соусе терияки с рисом', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=520&fit=crop&q=80', 30, 'easy', 2, 10.00, FALSE, FALSE, 'asian', 'dinner'),
('Лапша удон с овощами', 'Густая удон-лапша с овощами в соевом соусе', 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 8.00, TRUE, TRUE, 'asian', 'lunch')
ON CONFLICT DO NOTHING;

-- ===========================
-- Новые блюда: русские супы
-- ===========================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Борщ', 'Наваристый борщ со свёклой, капустой и говядиной', 'https://images.unsplash.com/photo-1547592166-23ac786af7ea?w=400&h=520&fit=crop&q=80', 90, 'medium', 6, 10.00, FALSE, FALSE, 'russian', 'lunch'),
('Щи из капусты', 'Классические щи из свежей капусты с говядиной', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 75, 'easy', 6, 9.00, FALSE, FALSE, 'russian', 'lunch'),
('Солянка', 'Густая кисло-соленая солянка с мясом и огурцами', 'https://images.unsplash.com/photo-1547592180-85f173990888?w=400&h=520&fit=crop&q=80', 60, 'medium', 4, 12.00, FALSE, FALSE, 'russian', 'lunch'),
('Гороховый суп', 'Наваристый суп из гороха с беконом', 'https://images.unsplash.com/photo-1547592166-aa6e0bd2e3a0?w=400&h=520&fit=crop&q=80', 90, 'easy', 6, 8.00, FALSE, FALSE, 'russian', 'lunch'),
('Куриный суп', 'Лёгкий куриный суп с овощами и вермишелью', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 50, 'easy', 4, 8.00, FALSE, FALSE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

-- ===========================
-- Новые блюда: русские основные блюда
-- ===========================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Пельмени домашние', 'Домашние пельмени с мясным фаршем в сметане', 'https://images.unsplash.com/photo-1585032226651-759b792d2727?w=400&h=520&fit=crop&q=80', 120, 'hard', 6, 10.00, FALSE, FALSE, 'russian', 'dinner'),
('Говяжий гуляш', 'Тушеная говядина в томатном соусе с картофелем', 'https://images.unsplash.com/photo-1574484284823-73b5e4b5d5b8?w=400&h=520&fit=crop&q=80', 90, 'medium', 4, 14.00, FALSE, FALSE, 'russian', 'dinner'),
('Тефтели в соусе', 'Нежные тефтели из фарша в томатном соусе', 'https://images.unsplash.com/photo-1557116571-5780e2d41e34?w=400&h=520&fit=crop&q=80', 50, 'medium', 4, 10.00, FALSE, FALSE, 'russian', 'dinner'),
('Картофельная запеканка', 'Запеканка из картофеля с фаршем и сыром', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 65, 'easy', 4, 9.00, FALSE, FALSE, 'russian', 'dinner')
ON CONFLICT DO NOTHING;

-- ===========================
-- Связи: новые блюда и ингредиенты
-- ===========================
-- Блины
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Блины' AND i.name IN ('Мука', 'Молоко', 'Яйца', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

-- Сырники
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Сырники' AND i.name IN ('Творог', 'Яйца', 'Мука', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Омлет с сыром
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Омлет с сыром' AND i.name IN ('Яйца', 'Молоко', 'Сыр', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

-- Творожная запеканка
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Творожная запеканка' AND i.name IN ('Творог', 'Яйца', 'Мука', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

-- Паста Карбонара
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паста Карбонара' AND i.name IN ('Макароны', 'Бекон', 'Яйца', 'Пармезан', 'Соль', 'Перец черный')
ON CONFLICT DO NOTHING;

-- Ризотто с грибами
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Ризотто с грибами' AND i.name IN ('Рис', 'Грибы', 'Лук', 'Пармезан', 'Масло сливочное', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Паста Болоньезе
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паста Болоньезе' AND i.name IN ('Макароны', 'Фарш', 'Помидоры', 'Томатная паста', 'Лук', 'Морковь', 'Сельдерей', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Лазанья
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Лазанья' AND i.name IN ('Мука', 'Фарш', 'Помидоры', 'Томатная паста', 'Молоко', 'Масло сливочное', 'Сыр', 'Лук', 'Соль')
ON CONFLICT DO NOTHING;

-- Жареный рис с яйцом
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Жареный рис с яйцом' AND i.name IN ('Рис', 'Яйца', 'Лук зеленый', 'Соевый соус', 'Масло растительное', 'Морковь', 'Соль')
ON CONFLICT DO NOTHING;

-- Курица терияки
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Курица терияки' AND i.name IN ('Курица', 'Соевый соус', 'Рис', 'Имбирь', 'Чеснок', 'Масло растительное')
ON CONFLICT DO NOTHING;

-- Лапша удон с овощами
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Лапша удон с овощами' AND i.name IN ('Лапша', 'Морковь', 'Перец болгарский', 'Лук', 'Соевый соус', 'Масло растительное')
ON CONFLICT DO NOTHING;

-- Борщ
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Борщ' AND i.name IN ('Говядина', 'Свекла', 'Капуста', 'Картофель', 'Морковь', 'Лук', 'Томатная паста', 'Масло растительное', 'Сметана', 'Соль')
ON CONFLICT DO NOTHING;

-- Щи из капусты
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Щи из капусты' AND i.name IN ('Говядина', 'Капуста', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Сметана', 'Соль')
ON CONFLICT DO NOTHING;

-- Солянка
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Солянка' AND i.name IN ('Говядина', 'Сосиски', 'Лук', 'Огурцы', 'Томатная паста', 'Лимон', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Гороховый суп
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гороховый суп' AND i.name IN ('Горох', 'Бекон', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Куриный суп
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Куриный суп' AND i.name IN ('Курица', 'Лапша', 'Картофель', 'Морковь', 'Лук', 'Соль', 'Перец черный')
ON CONFLICT DO NOTHING;

-- Пельмени домашние
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Пельмени домашние' AND i.name IN ('Фарш', 'Мука', 'Яйца', 'Лук', 'Соль', 'Перец черный', 'Масло сливочное', 'Сметана')
ON CONFLICT DO NOTHING;

-- Говяжий гуляш
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Говяжий гуляш' AND i.name IN ('Говядина', 'Томатная паста', 'Лук', 'Морковь', 'Картофель', 'Масло растительное', 'Соль', 'Перец черный')
ON CONFLICT DO NOTHING;

-- Тефтели в соусе
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тефтели в соусе' AND i.name IN ('Фарш', 'Рис', 'Лук', 'Яйца', 'Томатная паста', 'Масло растительное', 'Соль', 'Перец черный')
ON CONFLICT DO NOTHING;

-- Картофельная запеканка
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Картофельная запеканка' AND i.name IN ('Картофель', 'Фарш', 'Сыр', 'Лук', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

-- ===========================
-- Рецепты: новые блюда
-- ===========================
INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Смешать муку, молоко, яйца и щепотку соли в жидкое тесто"},
  {"step": 2, "description": "Добавить растопленное сливочное масло, перемешать"},
  {"step": 3, "description": "Дать тесту постоять 15 минут"},
  {"step": 4, "description": "Раскалить сковороду и смазать маслом"},
  {"step": 5, "description": "Налить тонкий слой теста, обжарить 1-2 минуты с каждой стороны"},
  {"step": 6, "description": "Подавать с вареньем, сметаной или медом"}
]' FROM dishes d WHERE d.name = 'Блины'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отжать творог через марлю, чтобы убрать лишнюю влагу"},
  {"step": 2, "description": "Смешать творог с яйцом, мукой и солью до однородной массы"},
  {"step": 3, "description": "Слепить небольшие круглые лепёшки, обвалять в муке"},
  {"step": 4, "description": "Обжарить на растительном масле до золотистой корочки с обеих сторон"},
  {"step": 5, "description": "Подавать со сметаной или вареньем"}
]' FROM dishes d WHERE d.name = 'Сырники'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Взбить яйца с молоком и солью венчиком"},
  {"step": 2, "description": "Натереть сыр на терке"},
  {"step": 3, "description": "Растопить сливочное масло на сковороде на среднем огне"},
  {"step": 4, "description": "Вылить яичную смесь, накрыть крышкой"},
  {"step": 5, "description": "Через 3 минуты посыпать сыром, готовить ещё 2 минуты"},
  {"step": 6, "description": "Сложить омлет пополам и подавать горячим"}
]' FROM dishes d WHERE d.name = 'Омлет с сыром'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Смешать творог с яйцами, мукой, молоком и щепоткой соли"},
  {"step": 2, "description": "Смазать форму для запекания сливочным маслом"},
  {"step": 3, "description": "Выложить творожную смесь ровным слоем"},
  {"step": 4, "description": "Запекать при 180°C в течение 35-40 минут до золотистой корочки"},
  {"step": 5, "description": "Дать остыть 10 минут, нарезать порциями и подавать со сметаной"}
]' FROM dishes d WHERE d.name = 'Творожная запеканка'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать бекон полосками и обжарить на сухой сковороде"},
  {"step": 2, "description": "Отварить макароны аль денте, сохранить стакан воды от варки"},
  {"step": 3, "description": "Взбить яйца с тертым пармезаном и черным перцем"},
  {"step": 4, "description": "Снять сковороду с огня, добавить горячие макароны к бекону"},
  {"step": 5, "description": "Быстро влить яичную смесь, перемешивая — яйца должны загустеть, но не свернуться"},
  {"step": 6, "description": "При необходимости добавить немного воды от варки, подавать немедленно"}
]' FROM dishes d WHERE d.name = 'Паста Карбонара'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Обжарить лук в смеси масел до прозрачности"},
  {"step": 2, "description": "Добавить нарезанные грибы, жарить 5-7 минут"},
  {"step": 3, "description": "Добавить рис и обжарить 2 минуты, помешивая"},
  {"step": 4, "description": "Влить горячий бульон по одному половнику, постоянно помешивая"},
  {"step": 5, "description": "Повторять добавление бульона по мере впитывания (около 20 минут)"},
  {"step": 6, "description": "Снять с огня, добавить сливочное масло и тертый пармезан, перемешать"}
]' FROM dishes d WHERE d.name = 'Ризотто с грибами'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Обжарить фарш на растительном масле, разбивая комки"},
  {"step": 2, "description": "Добавить мелко нарезанные лук, морковь и сельдерей, тушить 10 минут"},
  {"step": 3, "description": "Добавить помидоры и томатную пасту, перемешать"},
  {"step": 4, "description": "Тушить соус на медленном огне 30-40 минут, помешивая"},
  {"step": 5, "description": "Отварить макароны аль денте"},
  {"step": 6, "description": "Смешать пасту с соусом, подавать с тертым сыром"}
]' FROM dishes d WHERE d.name = 'Паста Болоньезе'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Приготовить тесто для листов лазаньи из муки, яиц и соли, раскатать тонко"},
  {"step": 2, "description": "Обжарить фарш с луком, добавить томатную пасту и помидоры, тушить 20 минут"},
  {"step": 3, "description": "Приготовить соус бешамель: обжарить муку в масле, влить молоко, варить до густоты"},
  {"step": 4, "description": "Смазать форму, выложить слой теста, слой мясного соуса, слой бешамель"},
  {"step": 5, "description": "Повторить слои 3-4 раза, сверху посыпать тертым сыром"},
  {"step": 6, "description": "Запекать при 180°C 35-40 минут до золотистой корочки"}
]' FROM dishes d WHERE d.name = 'Лазанья'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отварить рис заранее и остудить (желательно вчерашний)"},
  {"step": 2, "description": "Разогреть масло на большой сковороде на сильном огне"},
  {"step": 3, "description": "Обжарить нарезанную морковь и зеленый лук 2 минуты"},
  {"step": 4, "description": "Добавить рис, жарить помешивая 3-4 минуты"},
  {"step": 5, "description": "Сдвинуть рис в сторону, разбить яйца и быстро перемешать"},
  {"step": 6, "description": "Добавить соевый соус, перемешать все вместе и подавать"}
]' FROM dishes d WHERE d.name = 'Жареный рис с яйцом'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать курицу крупными кусочками"},
  {"step": 2, "description": "Смешать соевый соус, тертый имбирь и чеснок для маринада"},
  {"step": 3, "description": "Замариновать курицу на 20 минут"},
  {"step": 4, "description": "Обжарить курицу на масле до золотистого цвета с каждой стороны"},
  {"step": 5, "description": "Влить оставшийся маринад, тушить 5-7 минут до загустения соуса"},
  {"step": 6, "description": "Подавать с отварным рисом, полив соусом терияки"}
]' FROM dishes d WHERE d.name = 'Курица терияки'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать морковь соломкой, болгарский перец полосками, лук полукольцами"},
  {"step": 2, "description": "Обжарить овощи на масле 3-4 минуты на сильном огне"},
  {"step": 3, "description": "Отварить лапшу по инструкции на упаковке"},
  {"step": 4, "description": "Добавить лапшу к овощам на сковороде"},
  {"step": 5, "description": "Влить соевый соус, перемешать и прогреть 2 минуты"},
  {"step": 6, "description": "Подавать горячей, по желанию добавить кунжут"}
]' FROM dishes d WHERE d.name = 'Лапша удон с овощами'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отварить говядину целым куском 1.5 часа, снимая пену"},
  {"step": 2, "description": "Натереть свеклу на крупной терке, обжарить с томатной пастой 10 минут"},
  {"step": 3, "description": "В бульон добавить нарезанный картофель, варить 15 минут"},
  {"step": 4, "description": "Добавить нашинкованную капусту, пассерованные лук и морковь"},
  {"step": 5, "description": "Добавить свеклу с томатом, варить еще 10 минут"},
  {"step": 6, "description": "Посолить, дать настояться 20 минут, подавать со сметаной"}
]' FROM dishes d WHERE d.name = 'Борщ'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Сварить говядину в 2.5 л воды, снять пену, варить 1 час"},
  {"step": 2, "description": "Обжарить лук и морковь до золотистого цвета"},
  {"step": 3, "description": "В бульон добавить нарезанный картофель, варить 10 минут"},
  {"step": 4, "description": "Добавить нашинкованную капусту и пассерованные овощи"},
  {"step": 5, "description": "Варить до мягкости капусты, посолить по вкусу"},
  {"step": 6, "description": "Подавать горячими со сметаной и черным хлебом"}
]' FROM dishes d WHERE d.name = 'Щи из капусты'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать говядину кубиками, сосиски кружочками"},
  {"step": 2, "description": "Обжарить говядину, добавить лук и жарить до золотистого"},
  {"step": 3, "description": "Добавить нарезанные соленые огурцы и томатную пасту"},
  {"step": 4, "description": "Залить горячим бульоном или водой, тушить 30 минут"},
  {"step": 5, "description": "Добавить сосиски, варить еще 10 минут"},
  {"step": 6, "description": "Подавать с долькой лимона и сметаной"}
]' FROM dishes d WHERE d.name = 'Солянка'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Замочить горох на ночь или на 4 часа"},
  {"step": 2, "description": "Нарезать бекон кубиками, обжарить до хруста"},
  {"step": 3, "description": "Обжарить лук и морковь до золотистого"},
  {"step": 4, "description": "В кастрюле отварить горох 40-50 минут до мягкости"},
  {"step": 5, "description": "Добавить картофель, бекон и пассерованные овощи, варить 15 минут"},
  {"step": 6, "description": "Посолить, можно пюрировать часть супа для густоты"}
]' FROM dishes d WHERE d.name = 'Гороховый суп'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Залить курицу холодной водой, довести до кипения, снять пену"},
  {"step": 2, "description": "Варить на медленном огне 30 минут"},
  {"step": 3, "description": "Добавить нарезанные картофель и морковь"},
  {"step": 4, "description": "Добавить целую луковицу, варить еще 15 минут"},
  {"step": 5, "description": "Добавить лапшу, варить до готовности 5-7 минут"},
  {"step": 6, "description": "Посолить, поперчить, убрать луковицу, подавать горячим"}
]' FROM dishes d WHERE d.name = 'Куриный суп'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Приготовить тесто: смешать муку, яйцо, воду и соль, вымесить"},
  {"step": 2, "description": "Для начинки: смешать фарш с мелко нарезанным луком, посолить и поперчить"},
  {"step": 3, "description": "Раскатать тесто тонко, вырезать кружки стаканом"},
  {"step": 4, "description": "Положить начинку на каждый кружок, слепить пельмени"},
  {"step": 5, "description": "Отварить пельмени в подсоленной воде 5-7 минут после всплытия"},
  {"step": 6, "description": "Подавать со сметаной, маслом или уксусом"}
]' FROM dishes d WHERE d.name = 'Пельмени домашние'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать говядину кубиками 3x3 см"},
  {"step": 2, "description": "Обжарить мясо на сильном огне до румяной корочки"},
  {"step": 3, "description": "Добавить нарезанный лук и морковь, обжаривать 5 минут"},
  {"step": 4, "description": "Добавить томатную пасту и горячую воду, тушить 40 минут"},
  {"step": 5, "description": "Добавить картофель, тушить ещё 20 минут до мягкости"},
  {"step": 6, "description": "Посолить, поперчить, подавать с хлебом"}
]' FROM dishes d WHERE d.name = 'Говяжий гуляш'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Смешать фарш с вареным рисом, яйцом, мелко нарезанным луком, посолить"},
  {"step": 2, "description": "Слепить небольшие шарики-тефтели"},
  {"step": 3, "description": "Обжарить тефтели на масле со всех сторон"},
  {"step": 4, "description": "Приготовить соус: томатная паста с водой, посолить"},
  {"step": 5, "description": "Залить тефтели соусом, тушить под крышкой 20 минут"},
  {"step": 6, "description": "Подавать с гречкой, рисом или картофелем"}
]' FROM dishes d WHERE d.name = 'Тефтели в соусе'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отварить картофель до полуготовности, нарезать кружками"},
  {"step": 2, "description": "Обжарить фарш с луком, посолить и поперчить"},
  {"step": 3, "description": "В форму выложить слой картофеля, затем слой фарша"},
  {"step": 4, "description": "Залить смесью молока и яйца"},
  {"step": 5, "description": "Посыпать тертым сыром"},
  {"step": 6, "description": "Запекать при 180°C 35-40 минут до золотистой корочки"}
]' FROM dishes d WHERE d.name = 'Картофельная запеканка'
ON CONFLICT DO NOTHING;

-- ===========================
-- Ингредиенты рецептов: новые блюда
-- ===========================
-- Блины
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Мука' THEN 300 WHEN 'Молоко' THEN 500 WHEN 'Яйца' THEN 2
              WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Мука' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Яйца' THEN 'шт'
              WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Блины' AND i.name IN ('Мука', 'Молоко', 'Яйца', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

-- Сырники
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Творог' THEN 500 WHEN 'Яйца' THEN 1 WHEN 'Мука' THEN 60
              WHEN 'Масло растительное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Творог' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Мука' THEN 'г'
              WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Сырники' AND i.name IN ('Творог', 'Яйца', 'Мука', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Омлет с сыром
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 3 WHEN 'Молоко' THEN 60 WHEN 'Сыр' THEN 50
              WHEN 'Масло сливочное' THEN 15 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Молоко' THEN 'мл' WHEN 'Сыр' THEN 'г'
              WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Омлет с сыром' AND i.name IN ('Яйца', 'Молоко', 'Сыр', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

-- Творожная запеканка
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Творог' THEN 600 WHEN 'Яйца' THEN 2 WHEN 'Мука' THEN 50
              WHEN 'Молоко' THEN 100 WHEN 'Масло сливочное' THEN 20 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Творог' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Мука' THEN 'г'
              WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Творожная запеканка' AND i.name IN ('Творог', 'Яйца', 'Мука', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

-- Паста Карбонара
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 200 WHEN 'Бекон' THEN 150 WHEN 'Яйца' THEN 2
              WHEN 'Пармезан' THEN 50 WHEN 'Соль' THEN 0.5 WHEN 'Перец черный' THEN 0.5 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Бекон' THEN 'г' WHEN 'Яйца' THEN 'шт'
              WHEN 'Пармезан' THEN 'г' WHEN 'Соль' THEN 'ч.л.' WHEN 'Перец черный' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Паста Карбонара' AND i.name IN ('Макароны', 'Бекон', 'Яйца', 'Пармезан', 'Соль', 'Перец черный')
ON CONFLICT DO NOTHING;

-- Ризотто с грибами
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 200 WHEN 'Грибы' THEN 300 WHEN 'Лук' THEN 1
              WHEN 'Пармезан' THEN 50 WHEN 'Масло сливочное' THEN 40 WHEN 'Масло растительное' THEN 30
              WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Грибы' THEN 'г' WHEN 'Лук' THEN 'шт'
              WHEN 'Пармезан' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Ризотто с грибами' AND i.name IN ('Рис', 'Грибы', 'Лук', 'Пармезан', 'Масло сливочное', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Паста Болоньезе
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 400 WHEN 'Фарш' THEN 500 WHEN 'Помидоры' THEN 400
              WHEN 'Томатная паста' THEN 50 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1
              WHEN 'Сельдерей' THEN 2 WHEN 'Масло растительное' THEN 30 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Фарш' THEN 'г' WHEN 'Помидоры' THEN 'г'
              WHEN 'Томатная паста' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт'
              WHEN 'Сельдерей' THEN 'стебля' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Паста Болоньезе' AND i.name IN ('Макароны', 'Фарш', 'Помидоры', 'Томатная паста', 'Лук', 'Морковь', 'Сельдерей', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Лазанья
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Мука' THEN 300 WHEN 'Фарш' THEN 600 WHEN 'Помидоры' THEN 400
              WHEN 'Томатная паста' THEN 70 WHEN 'Молоко' THEN 500 WHEN 'Масло сливочное' THEN 50
              WHEN 'Сыр' THEN 150 WHEN 'Лук' THEN 1 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Мука' THEN 'г' WHEN 'Фарш' THEN 'г' WHEN 'Помидоры' THEN 'г'
              WHEN 'Томатная паста' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г'
              WHEN 'Сыр' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Лазанья' AND i.name IN ('Мука', 'Фарш', 'Помидоры', 'Томатная паста', 'Молоко', 'Масло сливочное', 'Сыр', 'Лук', 'Соль')
ON CONFLICT DO NOTHING;

-- Жареный рис с яйцом
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 200 WHEN 'Яйца' THEN 2 WHEN 'Лук зеленый' THEN 30
              WHEN 'Соевый соус' THEN 30 WHEN 'Масло растительное' THEN 30 WHEN 'Морковь' THEN 1
              WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Лук зеленый' THEN 'г'
              WHEN 'Соевый соус' THEN 'мл' WHEN 'Масло растительное' THEN 'мл' WHEN 'Морковь' THEN 'шт'
              WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Жареный рис с яйцом' AND i.name IN ('Рис', 'Яйца', 'Лук зеленый', 'Соевый соус', 'Масло растительное', 'Морковь', 'Соль')
ON CONFLICT DO NOTHING;

-- Курица терияки
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Курица' THEN 500 WHEN 'Соевый соус' THEN 60 WHEN 'Рис' THEN 200
              WHEN 'Имбирь' THEN 10 WHEN 'Чеснок' THEN 2 WHEN 'Масло растительное' THEN 20 END,
  CASE i.name WHEN 'Курица' THEN 'г' WHEN 'Соевый соус' THEN 'мл' WHEN 'Рис' THEN 'г'
              WHEN 'Имбирь' THEN 'г' WHEN 'Чеснок' THEN 'зубчика' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Курица терияки' AND i.name IN ('Курица', 'Соевый соус', 'Рис', 'Имбирь', 'Чеснок', 'Масло растительное')
ON CONFLICT DO NOTHING;

-- Лапша удон с овощами
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Лапша' THEN 200 WHEN 'Морковь' THEN 1 WHEN 'Перец болгарский' THEN 1
              WHEN 'Лук' THEN 1 WHEN 'Соевый соус' THEN 40 WHEN 'Масло растительное' THEN 20 END,
  CASE i.name WHEN 'Лапша' THEN 'г' WHEN 'Морковь' THEN 'шт' WHEN 'Перец болгарский' THEN 'шт'
              WHEN 'Лук' THEN 'шт' WHEN 'Соевый соус' THEN 'мл' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Лапша удон с овощами' AND i.name IN ('Лапша', 'Морковь', 'Перец болгарский', 'Лук', 'Соевый соус', 'Масло растительное')
ON CONFLICT DO NOTHING;

-- Борщ
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 500 WHEN 'Свекла' THEN 2 WHEN 'Капуста' THEN 300
              WHEN 'Картофель' THEN 3 WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1
              WHEN 'Томатная паста' THEN 50 WHEN 'Масло растительное' THEN 30
              WHEN 'Сметана' THEN 100 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Свекла' THEN 'шт' WHEN 'Капуста' THEN 'г'
              WHEN 'Картофель' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт'
              WHEN 'Томатная паста' THEN 'г' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Сметана' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Борщ' AND i.name IN ('Говядина', 'Свекла', 'Капуста', 'Картофель', 'Морковь', 'Лук', 'Томатная паста', 'Масло растительное', 'Сметана', 'Соль')
ON CONFLICT DO NOTHING;

-- Щи из капусты
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 400 WHEN 'Капуста' THEN 400 WHEN 'Картофель' THEN 3
              WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 30
              WHEN 'Сметана' THEN 80 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Капуста' THEN 'г' WHEN 'Картофель' THEN 'шт'
              WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Сметана' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Щи из капусты' AND i.name IN ('Говядина', 'Капуста', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Сметана', 'Соль')
ON CONFLICT DO NOTHING;

-- Солянка
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 300 WHEN 'Сосиски' THEN 3 WHEN 'Лук' THEN 2
              WHEN 'Огурцы' THEN 3 WHEN 'Томатная паста' THEN 60 WHEN 'Лимон' THEN 0.5
              WHEN 'Масло растительное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Сосиски' THEN 'шт' WHEN 'Лук' THEN 'шт'
              WHEN 'Огурцы' THEN 'шт' WHEN 'Томатная паста' THEN 'г' WHEN 'Лимон' THEN 'шт'
              WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Солянка' AND i.name IN ('Говядина', 'Сосиски', 'Лук', 'Огурцы', 'Томатная паста', 'Лимон', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Гороховый суп
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Горох' THEN 300 WHEN 'Бекон' THEN 200 WHEN 'Картофель' THEN 3
              WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 30
              WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Горох' THEN 'г' WHEN 'Бекон' THEN 'г' WHEN 'Картофель' THEN 'шт'
              WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гороховый суп' AND i.name IN ('Горох', 'Бекон', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- Куриный суп
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Курица' THEN 500 WHEN 'Лапша' THEN 100 WHEN 'Картофель' THEN 3
              WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Соль' THEN 1
              WHEN 'Перец черный' THEN 0.5 END,
  CASE i.name WHEN 'Курица' THEN 'г' WHEN 'Лапша' THEN 'г' WHEN 'Картофель' THEN 'шт'
              WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Соль' THEN 'ч.л.'
              WHEN 'Перец черный' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Куриный суп' AND i.name IN ('Курица', 'Лапша', 'Картофель', 'Морковь', 'Лук', 'Соль', 'Перец черный')
ON CONFLICT DO NOTHING;

-- Пельмени домашние
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Фарш' THEN 500 WHEN 'Мука' THEN 400 WHEN 'Яйца' THEN 1
              WHEN 'Лук' THEN 1 WHEN 'Соль' THEN 1 WHEN 'Перец черный' THEN 0.5
              WHEN 'Масло сливочное' THEN 30 WHEN 'Сметана' THEN 100 END,
  CASE i.name WHEN 'Фарш' THEN 'г' WHEN 'Мука' THEN 'г' WHEN 'Яйца' THEN 'шт'
              WHEN 'Лук' THEN 'шт' WHEN 'Соль' THEN 'ч.л.' WHEN 'Перец черный' THEN 'ч.л.'
              WHEN 'Масло сливочное' THEN 'г' WHEN 'Сметана' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Пельмени домашние' AND i.name IN ('Фарш', 'Мука', 'Яйца', 'Лук', 'Соль', 'Перец черный', 'Масло сливочное', 'Сметана')
ON CONFLICT DO NOTHING;

-- Говяжий гуляш
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 600 WHEN 'Томатная паста' THEN 60 WHEN 'Лук' THEN 2
              WHEN 'Морковь' THEN 1 WHEN 'Картофель' THEN 4 WHEN 'Масло растительное' THEN 40
              WHEN 'Соль' THEN 1 WHEN 'Перец черный' THEN 0.5 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Томатная паста' THEN 'г' WHEN 'Лук' THEN 'шт'
              WHEN 'Морковь' THEN 'шт' WHEN 'Картофель' THEN 'шт' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Соль' THEN 'ч.л.' WHEN 'Перец черный' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Говяжий гуляш' AND i.name IN ('Говядина', 'Томатная паста', 'Лук', 'Морковь', 'Картофель', 'Масло растительное', 'Соль', 'Перец черный')
ON CONFLICT DO NOTHING;

-- Тефтели в соусе
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Фарш' THEN 500 WHEN 'Рис' THEN 80 WHEN 'Лук' THEN 1
              WHEN 'Яйца' THEN 1 WHEN 'Томатная паста' THEN 60 WHEN 'Масло растительное' THEN 30
              WHEN 'Соль' THEN 1 WHEN 'Перец черный' THEN 0.5 END,
  CASE i.name WHEN 'Фарш' THEN 'г' WHEN 'Рис' THEN 'г' WHEN 'Лук' THEN 'шт'
              WHEN 'Яйца' THEN 'шт' WHEN 'Томатная паста' THEN 'г' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Соль' THEN 'ч.л.' WHEN 'Перец черный' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Тефтели в соусе' AND i.name IN ('Фарш', 'Рис', 'Лук', 'Яйца', 'Томатная паста', 'Масло растительное', 'Соль', 'Перец черный')
ON CONFLICT DO NOTHING;

-- Картофельная запеканка
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 800 WHEN 'Фарш' THEN 400 WHEN 'Сыр' THEN 100
              WHEN 'Лук' THEN 1 WHEN 'Молоко' THEN 150 WHEN 'Масло сливочное' THEN 30
              WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Фарш' THEN 'г' WHEN 'Сыр' THEN 'г'
              WHEN 'Лук' THEN 'шт' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г'
              WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картофельная запеканка' AND i.name IN ('Картофель', 'Фарш', 'Сыр', 'Лук', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

-- ===========================
-- Скрываем из селектора ингредиенты, добавленные для рецептов (не самые распространённые)
-- ===========================
UPDATE ingredients SET show_in_selector = 0 WHERE name IN (
  'Творог', 'Грибы', 'Бекон', 'Мука', 'Соевый соус', 'Томатная паста',
  'Лимон', 'Имбирь', 'Пармезан', 'Горох', 'Лапша'
);

-- ===========================
-- Скрытые ингредиенты только для AI-распознавания
-- ===========================
INSERT INTO ingredients (name, category, image_url, show_in_selector) VALUES
-- Злаки и мучное
('Хлеб', 'cereals', NULL, 0),
('Батон', 'cereals', NULL, 0),
('Пшено', 'cereals', NULL, 0),
('Манная крупа', 'cereals', NULL, 0),
('Перловка', 'cereals', NULL, 0),
('Кускус', 'cereals', NULL, 0),
('Булгур', 'cereals', NULL, 0),
('Панировочные сухари', 'cereals', NULL, 0),
('Лаваш', 'cereals', NULL, 0),
('Фасоль', 'cereals', NULL, 0),
('Чечевица', 'cereals', NULL, 0),
-- Мясо/рыба
('Индейка', 'meat', NULL, 0),
('Семга', 'meat', NULL, 0),
('Треска', 'meat', NULL, 0),
('Минтай', 'meat', NULL, 0),
('Тунец', 'meat', NULL, 0),
('Колбаса', 'meat', NULL, 0),
('Ветчина', 'meat', NULL, 0),
-- Овощи/грибы
('Шампиньоны', 'vegetables', NULL, 0),
('Вешенки', 'vegetables', NULL, 0),
('Горошек', 'vegetables', NULL, 0),
('Кукуруза', 'vegetables', NULL, 0),
('Стручковая фасоль', 'vegetables', NULL, 0),
('Авокадо', 'vegetables', NULL, 0),
('Листья салата', 'vegetables', NULL, 0),
('Руккола', 'vegetables', NULL, 0),
('Лук-порей', 'vegetables', NULL, 0),
('Базилик', 'vegetables', NULL, 0),
('Кинза', 'vegetables', NULL, 0),
('Помидоры черри', 'vegetables', NULL, 0),
('Спаржа', 'vegetables', NULL, 0),
-- Молочные
('Кефир', 'dairy', NULL, 0),
('Сливки', 'dairy', NULL, 0),
('Йогурт', 'dairy', NULL, 0),
('Фета', 'dairy', NULL, 0),
('Моцарелла', 'dairy', NULL, 0),
('Творожный сыр', 'dairy', NULL, 0),
-- Специи и приправы
('Паприка', 'spices', NULL, 0),
('Куркума', 'spices', NULL, 0),
('Лавровый лист', 'spices', NULL, 0),
('Корица', 'spices', NULL, 0),
('Мускатный орех', 'spices', NULL, 0),
('Орегано', 'spices', NULL, 0),
('Перец чили', 'spices', NULL, 0),
('Горчица', 'spices', NULL, 0),
('Уксус', 'spices', NULL, 0),
-- Прочее
('Мёд', 'other', NULL, 0),
('Сахар', 'other', NULL, 0),
('Майонез', 'other', NULL, 0),
('Кетчуп', 'other', NULL, 0),
('Оливковое масло', 'other', NULL, 0),
('Оливки', 'other', NULL, 0),
('Грецкие орехи', 'other', NULL, 0),
('Арахис', 'other', NULL, 0),
('Изюм', 'other', NULL, 0),
('Курага', 'other', NULL, 0),
('Консервированная фасоль', 'other', NULL, 0),
('Консервированный горошек', 'other', NULL, 0)
ON CONFLICT DO NOTHING;

-- ===========================
-- Блюда "пустого холодильника" — готовятся из минимума продуктов
-- ===========================
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Яичница', 'Простая яичница-глазунья — 5 минут и готово', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 5, 'easy', 1, 1.00, TRUE, FALSE, 'russian', 'breakfast'),
('Омлет', 'Классический омлет из яиц с молоком', 'https://images.unsplash.com/photo-1553481187-be93c21490a9?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 2.00, TRUE, FALSE, 'russian', 'breakfast'),
('Вареные яйца', 'Яйца всмятку или вкрутую — самый простой завтрак', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 1.00, TRUE, FALSE, 'russian', 'breakfast'),
('Яичница с помидорами', 'Яичница с обжаренными помидорами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 2.00, TRUE, FALSE, 'russian', 'breakfast'),
('Яичница с колбасой', 'Яичница с поджаренной колбасой — классика завтрака', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 3.00, FALSE, FALSE, 'russian', 'breakfast'),
('Картофельное пюре', 'Нежное пюре из картофеля с молоком и маслом', 'https://images.unsplash.com/photo-1574484284823-73b5e4b5d5b8?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 2.00, TRUE, FALSE, 'russian', 'lunch'),
('Жареный картофель', 'Хрустящий жареный картофель с луком', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 2.00, TRUE, TRUE, 'russian', 'lunch'),
('Суп картофельный', 'Простой картофельный суп с луком и морковью', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 2.00, TRUE, TRUE, 'russian', 'lunch'),
('Рисовая каша на молоке', 'Нежная молочная каша из риса', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 25, 'easy', 2, 1.50, TRUE, FALSE, 'russian', 'breakfast'),
('Манная каша', 'Классическая манная каша на молоке', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 1.00, TRUE, FALSE, 'russian', 'breakfast'),
('Пшённая каша', 'Пшённая каша на молоке с маслом', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 1.50, TRUE, FALSE, 'russian', 'breakfast'),
('Гречневая каша', 'Рассыпчатая гречка с маслом', 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 1.50, TRUE, FALSE, 'russian', 'lunch'),
('Макароны с маслом', 'Отварные макароны с маслом и солью — выручает всегда', 'https://images.unsplash.com/photo-1618164435735-2cfee3e07c36?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 1.00, TRUE, FALSE, 'russian', 'lunch'),
('Тосты с сыром', 'Хлеб с расплавленным сыром — быстрый перекус', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 5, 'easy', 2, 2.00, TRUE, FALSE, 'other', 'breakfast'),
('Гренки яичные', 'Хлеб, обжаренный в яично-молочном кляре', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 2.00, TRUE, FALSE, 'other', 'breakfast'),
('Бутерброды с колбасой', 'Простые бутерброды — быстрый перекус за 5 минут', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 5, 'easy', 2, 3.00, FALSE, FALSE, 'russian', 'breakfast'),
('Творог со сметаной', 'Свежий творог со сметаной — полезный завтрак без готовки', 'https://images.unsplash.com/photo-1571748982800-fa51086c2a08?w=400&h=520&fit=crop&q=80', 5, 'easy', 2, 3.00, TRUE, FALSE, 'russian', 'breakfast'),
('Суп с вермишелью', 'Лёгкий суп с вермишелью и овощами', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 2.50, TRUE, FALSE, 'russian', 'lunch')
ON CONFLICT DO NOTHING;

-- Связи: блюда пустого холодильника
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

-- Рецепты: блюда пустого холодильника
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

-- Ингредиенты для рецептов новых блюд
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 2 WHEN 'Масло растительное' THEN 10 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Яичница' AND i.name IN ('Яйца', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 3 WHEN 'Молоко' THEN 60 WHEN 'Масло сливочное' THEN 15 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Омлет' AND i.name IN ('Яйца', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 2 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Вареные яйца' AND i.name IN ('Яйца', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 2 WHEN 'Помидоры' THEN 1 WHEN 'Масло растительное' THEN 10 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Помидоры' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Яичница с помидорами' AND i.name IN ('Яйца', 'Помидоры', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 2 WHEN 'Колбаса' THEN 100 WHEN 'Масло растительное' THEN 10 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Колбаса' THEN 'г' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Яичница с колбасой' AND i.name IN ('Яйца', 'Колбаса', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 800 WHEN 'Молоко' THEN 150 WHEN 'Масло сливочное' THEN 50 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картофельное пюре' AND i.name IN ('Картофель', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 800 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 50 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Жареный картофель' AND i.name IN ('Картофель', 'Лук', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 600 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 20 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп картофельный' AND i.name IN ('Картофель', 'Лук', 'Морковь', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 100 WHEN 'Молоко' THEN 500 WHEN 'Масло сливочное' THEN 20 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рисовая каша на молоке' AND i.name IN ('Рис', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Манная крупа' THEN 50 WHEN 'Молоко' THEN 400 WHEN 'Масло сливочное' THEN 15 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Манная крупа' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Манная каша' AND i.name IN ('Манная крупа', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Пшено' THEN 100 WHEN 'Молоко' THEN 500 WHEN 'Масло сливочное' THEN 20 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Пшено' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Пшённая каша' AND i.name IN ('Пшено', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Гречка' THEN 200 WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Гречка' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гречневая каша' AND i.name IN ('Гречка', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 200 WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Макароны с маслом' AND i.name IN ('Макароны', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Хлеб' THEN 4 WHEN 'Сыр' THEN 80 WHEN 'Масло сливочное' THEN 20 END,
  CASE i.name WHEN 'Хлеб' THEN 'ломтя' WHEN 'Сыр' THEN 'г' WHEN 'Масло сливочное' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Тосты с сыром' AND i.name IN ('Хлеб', 'Сыр', 'Масло сливочное')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Хлеб' THEN 4 WHEN 'Яйца' THEN 2 WHEN 'Молоко' THEN 80 WHEN 'Масло сливочное' THEN 20 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Хлеб' THEN 'ломтя' WHEN 'Яйца' THEN 'шт' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гренки яичные' AND i.name IN ('Хлеб', 'Яйца', 'Молоко', 'Масло сливочное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Хлеб' THEN 4 WHEN 'Колбаса' THEN 150 WHEN 'Масло сливочное' THEN 20 END,
  CASE i.name WHEN 'Хлеб' THEN 'ломтя' WHEN 'Колбаса' THEN 'г' WHEN 'Масло сливочное' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Бутерброды с колбасой' AND i.name IN ('Хлеб', 'Колбаса', 'Масло сливочное')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Творог' THEN 200 WHEN 'Сметана' THEN 50 END,
  CASE i.name WHEN 'Творог' THEN 'г' WHEN 'Сметана' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Творог со сметаной' AND i.name IN ('Творог', 'Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 200 WHEN 'Картофель' THEN 2 WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 20 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Картофель' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп с вермишелью' AND i.name IN ('Макароны', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;


-- ============================================================
-- MEDITERRANEAN DISHES
-- ============================================================

-- New ingredient: Нут (chickpeas)
INSERT INTO ingredients (name, category, image_url) VALUES ('Нут', 'vegetables', NULL)
ON CONFLICT DO NOTHING;

-- 1. Греческий салат
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Греческий салат', 'Классический салат с помидорами, огурцами, оливками и сыром фета', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800', 15, 'easy', 2, 300, 1, 0, 'mediterranean', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Греческий салат' AND i.name IN ('Помидоры', 'Огурцы', 'Перец болгарский', 'Сыр', 'Лук', 'Оливки', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[{"step":1,"description":"Помидоры и огурцы нарежьте крупными кубиками. Перец болгарский нарежьте полосками."},{"step":2,"description":"Лук нарежьте полукольцами и замочите в холодной воде на 5 минут."},{"step":3,"description":"Смешайте все овощи в миске. Добавьте оливки."},{"step":4,"description":"Сверху выложите кубики феты, полейте оливковым маслом и посолите по вкусу."}]'
FROM dishes d WHERE d.name = 'Греческий салат'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Помидоры' THEN 3 WHEN 'Огурцы' THEN 2 WHEN 'Перец болгарский' THEN 1
              WHEN 'Сыр' THEN 150 WHEN 'Лук' THEN 0.5 WHEN 'Оливки' THEN 80
              WHEN 'Масло растительное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Помидоры' THEN 'шт' WHEN 'Огурцы' THEN 'шт' WHEN 'Перец болгарский' THEN 'шт'
              WHEN 'Сыр' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Оливки' THEN 'г'
              WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Греческий салат' AND i.name IN ('Помидоры', 'Огурцы', 'Перец болгарский', 'Сыр', 'Лук', 'Оливки', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- 2. Хумус
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Хумус', 'Нежная паста из нута с лимоном и чесноком', 'https://images.unsplash.com/photo-1577805947697-89e18249d767?w=800', 20, 'easy', 4, 200, 1, 1, 'mediterranean', 'snack')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Хумус' AND i.name IN ('Нут', 'Лимон', 'Чеснок', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[{"step":1,"description":"Нут замочите на ночь, затем отварите до мягкости (или используйте консервированный)."},{"step":2,"description":"Слейте воду, оставив немного. Пробейте нут в блендере до гладкости."},{"step":3,"description":"Добавьте сок лимона, чеснок, оливковое масло и соль. Взбейте до кремовой консистенции."},{"step":4,"description":"Подавайте с лавашем или овощами, сбрызнув маслом."}]'
FROM dishes d WHERE d.name = 'Хумус'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Нут' THEN 300 WHEN 'Лимон' THEN 1 WHEN 'Чеснок' THEN 2
              WHEN 'Масло растительное' THEN 40 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Нут' THEN 'г' WHEN 'Лимон' THEN 'шт' WHEN 'Чеснок' THEN 'зубчика'
              WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Хумус' AND i.name IN ('Нут', 'Лимон', 'Чеснок', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- 3. Рататуй
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Рататуй', 'Тушёные овощи в средиземноморском стиле', 'https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?w=800', 50, 'medium', 4, 350, 1, 1, 'mediterranean', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рататуй' AND i.name IN ('Баклажаны', 'Помидоры', 'Перец болгарский', 'Лук', 'Чеснок', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[{"step":1,"description":"Баклажаны нарежьте кубиками, посолите и оставьте на 15 минут, затем промойте."},{"step":2,"description":"Обжарьте лук и чеснок на масле до прозрачности."},{"step":3,"description":"Добавьте перец, баклажаны и помидоры. Перемешайте."},{"step":4,"description":"Тушите на среднем огне 30 минут под крышкой, помешивая. Посолите по вкусу."}]'
FROM dishes d WHERE d.name = 'Рататуй'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Баклажаны' THEN 2 WHEN 'Помидоры' THEN 4 WHEN 'Перец болгарский' THEN 2
              WHEN 'Лук' THEN 1 WHEN 'Чеснок' THEN 3 WHEN 'Масло растительное' THEN 40 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Баклажаны' THEN 'шт' WHEN 'Помидоры' THEN 'шт' WHEN 'Перец болгарский' THEN 'шт'
              WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зубчика' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рататуй' AND i.name IN ('Баклажаны', 'Помидоры', 'Перец болгарский', 'Лук', 'Чеснок', 'Масло растительное', 'Соль')
ON CONFLICT DO NOTHING;

-- 4. Дзадзики (Tzatziki)
INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Дзадзики', 'Греческий соус из йогурта с огурцом и чесноком', 'https://images.unsplash.com/photo-1571091655789-405eb7a3a3a8?w=800', 10, 'easy', 4, 150, 1, 0, 'mediterranean', 'snack')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Дзадзики' AND i.name IN ('Огурцы', 'Сметана', 'Чеснок', 'Лимон', 'Соль', 'Петрушка')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT d.id, '[{"step":1,"description":"Огурец натрите на тёрке, отожмите лишнюю воду."},{"step":2,"description":"Смешайте сметану (или йогурт) с огурцом."},{"step":3,"description":"Добавьте мелко нарезанный чеснок, сок лимона и соль."},{"step":4,"description":"Украсьте зеленью. Подавайте охлаждённым с лавашем или как соус к мясу."}]'
FROM dishes d WHERE d.name = 'Дзадзики'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Огурцы' THEN 2 WHEN 'Сметана' THEN 200 WHEN 'Чеснок' THEN 2
              WHEN 'Лимон' THEN 0.5 WHEN 'Соль' THEN 0.5 WHEN 'Петрушка' THEN 20 END,
  CASE i.name WHEN 'Огурцы' THEN 'шт' WHEN 'Сметана' THEN 'г' WHEN 'Чеснок' THEN 'зубчика'
              WHEN 'Лимон' THEN 'шт' WHEN 'Соль' THEN 'ч.л.' WHEN 'Петрушка' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Дзадзики' AND i.name IN ('Огурцы', 'Сметана', 'Чеснок', 'Лимон', 'Соль', 'Петрушка')
ON CONFLICT DO NOTHING;

-- ════════════════════════════════════════════════════════════════════════
-- Рецепты для блюд без рецептов (найдено DB-аудитом 2026-03-09)
-- ════════════════════════════════════════════════════════════════════════

-- Макароны с овощами
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить макароны до готовности по инструкции."},{"step":2,"description":"Нарезать лук, морковь кубиками, помидоры — дольками."},{"step":3,"description":"Разогреть масло на сковороде, обжарить лук до прозрачности."},{"step":4,"description":"Добавить морковь, тушить 5 минут."},{"step":5,"description":"Добавить помидоры, тушить ещё 5 минут, посолить и поперчить."},{"step":6,"description":"Смешать готовые макароны с овощами и подавать."}]'
FROM dishes WHERE name = 'Макароны с овощами'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 300 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Макароны с овощами' AND i.name IN ('Макароны','Помидоры','Лук','Морковь','Масло растительное')
ON CONFLICT DO NOTHING;

-- Гречка с овощами
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Промыть гречку, залить водой 1:2, варить на медленном огне 20 минут."},{"step":2,"description":"Нарезать лук, морковь кубиками, помидоры — дольками."},{"step":3,"description":"Разогреть масло, обжарить лук до золотистого цвета."},{"step":4,"description":"Добавить морковь, тушить 5 минут, добавить помидоры ещё 5 минут."},{"step":5,"description":"Посолить, поперчить, смешать с готовой гречкой и подавать."}]'
FROM dishes WHERE name = 'Гречка с овощами'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Гречка' THEN 200 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Гречка' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гречка с овощами' AND i.name IN ('Гречка','Помидоры','Лук','Морковь','Масло растительное')
ON CONFLICT DO NOTHING;

-- Рис с овощами
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Промыть рис, залить водой 1:2, варить на медленном огне 20 минут."},{"step":2,"description":"Нарезать лук, морковь кубиками, помидоры — дольками."},{"step":3,"description":"Разогреть масло, обжарить лук до золотистого цвета."},{"step":4,"description":"Добавить морковь, тушить 5 минут, добавить помидоры ещё 5 минут."},{"step":5,"description":"Посолить, поперчить, смешать с готовым рисом и подавать."}]'
FROM dishes WHERE name = 'Рис с овощами'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 200 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рис с овощами' AND i.name IN ('Рис','Помидоры','Лук','Морковь','Масло растительное')
ON CONFLICT DO NOTHING;

-- Картофель с овощами
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать картофель крупными кубиками."},{"step":2,"description":"Нарезать лук, морковь кубиками, помидоры — дольками."},{"step":3,"description":"Смешать всё с растительным маслом, посолить и поперчить."},{"step":4,"description":"Выложить на противень и запекать при 200°C 35-40 минут, помешивая один раз."},{"step":5,"description":"Подавать горячим."}]'
FROM dishes WHERE name = 'Картофель с овощами'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 600 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 40 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картофель с овощами' AND i.name IN ('Картофель','Помидоры','Лук','Морковь','Масло растительное')
ON CONFLICT DO NOTHING;

-- Макароны с сыром
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить макароны до готовности по инструкции на упаковке."},{"step":2,"description":"Слить воду, оставив немного воды от варки."},{"step":3,"description":"Натереть сыр на крупной тёрке."},{"step":4,"description":"Смешать горячие макароны с половиной сыра — он расплавится."},{"step":5,"description":"Выложить в тарелку, посыпать оставшимся сыром и подавать."}]'
FROM dishes WHERE name = 'Макароны с сыром'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 300 WHEN 'Сыр' THEN 100 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Сыр' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Макароны с сыром' AND i.name IN ('Макароны','Сыр')
ON CONFLICT DO NOTHING;

-- Гречка с грибами и луком
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Промыть гречку, залить водой 1:2, варить на медленном огне 20 минут."},{"step":2,"description":"Нарезать лук полукольцами."},{"step":3,"description":"Разогреть масло на сковороде, обжарить лук до золотистого цвета."},{"step":4,"description":"Если есть грибы (шампиньоны, любые) — добавить, обжарить 5-7 минут."},{"step":5,"description":"Смешать готовую гречку с луком (и грибами), посолить, поперчить."},{"step":6,"description":"Подавать горячей."}]'
FROM dishes WHERE name = 'Гречка с грибами и луком'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Гречка' THEN 200 WHEN 'Лук' THEN 2 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Гречка' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гречка с грибами и луком' AND i.name IN ('Гречка','Лук','Масло растительное')
ON CONFLICT DO NOTHING;

-- Рис с курицей и овощами
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Промыть рис, залить водой 1:2, довести до кипения."},{"step":2,"description":"Нарезать курицу кубиками, лук и морковь — мелко."},{"step":3,"description":"Разогреть масло, обжарить лук и морковь до мягкости."},{"step":4,"description":"Добавить курицу, обжарить до золотистого цвета."},{"step":5,"description":"Смешать с рисом, добавить воды если нужно, варить на медленном огне 20 минут."},{"step":6,"description":"Посолить, поперчить. Подавать горячим."}]'
FROM dishes WHERE name = 'Рис с курицей и овощами'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 200 WHEN 'Курица' THEN 400 WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Курица' THEN 'г' WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рис с курицей и овощами' AND i.name IN ('Рис','Курица','Морковь','Лук','Масло растительное')
ON CONFLICT DO NOTHING;

-- Картофель с курицей и овощами
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать картофель крупными кубиками, курицу — средними."},{"step":2,"description":"Нарезать лук и морковь."},{"step":3,"description":"Смешать всё с растительным маслом, посолить и поперчить."},{"step":4,"description":"Выложить на противень и запекать при 200°C 40-45 минут, перемешав один раз в середине."},{"step":5,"description":"Подавать горячим."}]'
FROM dishes WHERE name = 'Картофель с курицей и овощами'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 500 WHEN 'Курица' THEN 400 WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 40 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Курица' THEN 'г' WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картофель с курицей и овощами' AND i.name IN ('Картофель','Курица','Морковь','Лук','Масло растительное')
ON CONFLICT DO NOTHING;

-- ============================================================
-- GEORGIAN DISHES (грузинская кухня)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES
('Хачапури по-аджарски', 'Открытая лепёшка с сыром и яйцом — символ грузинской кухни', 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=400&h=520&fit=crop&q=80', 40, 'medium', 2, 7.00, TRUE, FALSE, 'georgian', 'breakfast'),
('Суп харчо', 'Наваристый острый суп из говядины с рисом и томатами', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 70, 'medium', 4, 12.00, FALSE, FALSE, 'georgian', 'lunch'),
('Сациви с курицей', 'Курица в густом ореховом соусе — традиционное грузинское блюдо', 'https://images.unsplash.com/photo-1598514983099-b501817cc55?w=400&h=520&fit=crop&q=80', 60, 'hard', 4, 14.00, FALSE, FALSE, 'georgian', 'dinner')
ON CONFLICT DO NOTHING;

-- dish_ingredients for Georgian dishes
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Хачапури по-аджарски' AND i.name IN ('Мука','Сыр','Яйца','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп харчо' AND i.name IN ('Говядина','Рис','Помидоры','Лук','Чеснок','Томатная паста','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Сациви с курицей' AND i.name IN ('Курица','Лук','Чеснок','Масло сливочное','Перец черный','Соль')
ON CONFLICT DO NOTHING;

-- recipes for Georgian dishes
INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Приготовить тесто из муки, воды, яйца и щепотки соли — месить 10 минут, дать отдохнуть."},{"step":2,"description":"Натереть сыр (сулугуни или моцарелла) на крупной тёрке."},{"step":3,"description":"Раскатать тесто в форму лодочки, края загнуть бортиком."},{"step":4,"description":"Наполнить сырной массой, запечь при 220°C 15 минут."},{"step":5,"description":"Сделать углубление в центре и вбить яйцо. Запекать ещё 5-7 минут."},{"step":6,"description":"Добавить кусочек масла и подавать горячим."}]'
FROM dishes WHERE name = 'Хачапури по-аджарски'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать говядину кубиками 3×3 см, обжарить на масле до румяной корочки."},{"step":2,"description":"Добавить нарезанный лук, обжаривать ещё 5 минут."},{"step":3,"description":"Добавить томатную пасту и помидоры, тушить 5 минут."},{"step":4,"description":"Залить водой, довести до кипения, варить 40 минут."},{"step":5,"description":"Добавить промытый рис, варить 20 минут."},{"step":6,"description":"Добавить чеснок, зелень, соль, перец. Подавать горячим."}]'
FROM dishes WHERE name = 'Суп харчо'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить курицу целиком до готовности (40-50 минут), сохранить бульон."},{"step":2,"description":"Обжарить лук на сливочном масле до мягкости."},{"step":3,"description":"Добавить к луку чеснок, специи (кориандр, уцхо-сунели или чёрный перец)."},{"step":4,"description":"Смешать с половиной бульона, тушить 10 минут."},{"step":5,"description":"Разобрать курицу на куски, залить соусом."},{"step":6,"description":"Тушить на медленном огне 15 минут. Подавать со свежей зеленью."}]'
FROM dishes WHERE name = 'Сациви с курицей'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Мука' THEN 300 WHEN 'Сыр' THEN 250 WHEN 'Яйца' THEN 2 WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 5 END,
  CASE i.name WHEN 'Мука' THEN 'г' WHEN 'Сыр' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Хачапури по-аджарски' AND i.name IN ('Мука','Сыр','Яйца','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 500 WHEN 'Рис' THEN 100 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Чеснок' THEN 3 WHEN 'Томатная паста' THEN 60 WHEN 'Масло растительное' THEN 40 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Рис' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зуб' WHEN 'Томатная паста' THEN 'г' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп харчо' AND i.name IN ('Говядина','Рис','Помидоры','Лук','Чеснок','Томатная паста','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Курица' THEN 1000 WHEN 'Лук' THEN 2 WHEN 'Чеснок' THEN 4 WHEN 'Масло сливочное' THEN 50 WHEN 'Перец черный' THEN 5 WHEN 'Соль' THEN 10 END,
  CASE i.name WHEN 'Курица' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зуб' WHEN 'Масло сливочное' THEN 'г' WHEN 'Перец черный' THEN 'г' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Сациви с курицей' AND i.name IN ('Курица','Лук','Чеснок','Масло сливочное','Перец черный','Соль')
ON CONFLICT DO NOTHING;

-- ============================================================
-- MEXICAN DISHES (мексиканская кухня)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES
('Кесадилья с курицей и сыром', 'Хрустящая лепёшка с сочной курицей и расплавленным сыром', 'https://images.unsplash.com/photo-1618040996337-56904b7850b9?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 9.00, FALSE, FALSE, 'mexican', 'lunch'),
('Тако с говяжьим фаршем', 'Мексиканские тако с острым мясом, томатами и сыром', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80', 25, 'easy', 2, 10.00, FALSE, FALSE, 'mexican', 'lunch'),
('Мексиканский суп с фасолью', 'Сытный острый суп с фасолью, помидорами и паприкой', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 45, 'easy', 4, 6.00, TRUE, TRUE, 'mexican', 'lunch')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Кесадилья с курицей и сыром' AND i.name IN ('Лаваш','Курица','Сыр','Перец болгарский','Лук','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тако с говяжьим фаршем' AND i.name IN ('Лаваш','Фарш','Помидоры','Лук','Сыр','Перец болгарский')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Мексиканский суп с фасолью' AND i.name IN ('Фасоль','Помидоры','Лук','Чеснок','Паприка','Томатная паста','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать курицу тонкими полосками, обжарить с маслом, солью и перцем 7-10 минут."},{"step":2,"description":"Нарезать лук и болгарский перец, обжарить 5 минут."},{"step":3,"description":"На сковороде разогреть лаваш."},{"step":4,"description":"Выложить на одну половину курицу, овощи и тёртый сыр."},{"step":5,"description":"Сложить лаваш пополам, обжаривать по 2-3 минуты с каждой стороны до золотистой корочки."},{"step":6,"description":"Нарезать треугольниками и подавать."}]'
FROM dishes WHERE name = 'Кесадилья с курицей и сыром'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Обжарить фарш с луком до готовности, добавить паприку и соль."},{"step":2,"description":"Добавить нарезанные помидоры и болгарский перец, тушить 5 минут."},{"step":3,"description":"Прогреть лаваш на сухой сковороде 1-2 минуты."},{"step":4,"description":"Выложить начинку на лаваш, добавить тёртый сыр."},{"step":5,"description":"Завернуть в форму тако и подавать немедленно."}]'
FROM dishes WHERE name = 'Тако с говяжьим фаршем'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замочить фасоль на ночь, отварить до мягкости 1-1.5 часа (или взять консервированную)."},{"step":2,"description":"Обжарить лук с чесноком на масле до золотистости."},{"step":3,"description":"Добавить томатную пасту, паприку, тушить 3 минуты."},{"step":4,"description":"Добавить помидоры, тушить ещё 5 минут."},{"step":5,"description":"Соединить с фасолью и 500 мл воды, варить 20 минут."},{"step":6,"description":"Посолить, поперчить. Подавать со сметаной или авокадо."}]'
FROM dishes WHERE name = 'Мексиканский суп с фасолью'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Лаваш' THEN 2 WHEN 'Курица' THEN 300 WHEN 'Сыр' THEN 150 WHEN 'Перец болгарский' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 20 END,
  CASE i.name WHEN 'Лаваш' THEN 'шт' WHEN 'Курица' THEN 'г' WHEN 'Сыр' THEN 'г' WHEN 'Перец болгарский' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Кесадилья с курицей и сыром' AND i.name IN ('Лаваш','Курица','Сыр','Перец болгарский','Лук','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Лаваш' THEN 2 WHEN 'Фарш' THEN 300 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Сыр' THEN 100 WHEN 'Перец болгарский' THEN 1 END,
  CASE i.name WHEN 'Лаваш' THEN 'шт' WHEN 'Фарш' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Сыр' THEN 'г' WHEN 'Перец болгарский' THEN 'шт' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Тако с говяжьим фаршем' AND i.name IN ('Лаваш','Фарш','Помидоры','Лук','Сыр','Перец болгарский')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Фасоль' THEN 300 WHEN 'Помидоры' THEN 3 WHEN 'Лук' THEN 1 WHEN 'Чеснок' THEN 3 WHEN 'Паприка' THEN 10 WHEN 'Томатная паста' THEN 60 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Фасоль' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зуб' WHEN 'Паприка' THEN 'г' WHEN 'Томатная паста' THEN 'г' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Мексиканский суп с фасолью' AND i.name IN ('Фасоль','Помидоры','Лук','Чеснок','Паприка','Томатная паста','Масло растительное')
ON CONFLICT DO NOTHING;

-- ============================================================
-- FRENCH DISHES (французская кухня)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES
('Луковый суп по-французски', 'Классический суп с карамелизированным луком, хлебом и сыром', 'https://images.unsplash.com/photo-1548943487-a2e4e43b4853?w=400&h=520&fit=crop&q=80', 55, 'medium', 2, 8.00, TRUE, FALSE, 'french', 'lunch'),
('Крок-месье', 'Горячий бутерброд с ветчиной, сыром и соусом бешамель', 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 7.00, FALSE, FALSE, 'french', 'breakfast'),
('Рататуй по-провансальски', 'Тушёные средиземноморские овощи с прованскими травами', 'https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?w=400&h=520&fit=crop&q=80', 60, 'medium', 4, 6.00, TRUE, TRUE, 'french', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Луковый суп по-французски' AND i.name IN ('Лук','Хлеб','Сыр','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Крок-месье' AND i.name IN ('Хлеб','Сыр','Ветчина','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рататуй по-провансальски' AND i.name IN ('Баклажаны','Кабачки','Помидоры','Перец болгарский','Лук','Чеснок','Масло растительное')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать весь лук тонкими полукольцами (около 1 кг)."},{"step":2,"description":"Растопить масло в кастрюле с толстым дном, добавить лук."},{"step":3,"description":"Карамелизировать лук на среднем огне 40 минут, помешивая каждые 5 минут — он должен стать золотисто-коричневым."},{"step":4,"description":"Добавить соль и немного воды, довести до кипения."},{"step":5,"description":"Разлить суп по жаропрочным тарелкам, сверху положить кусок хлеба и щедро посыпать тёртым сыром."},{"step":6,"description":"Запечь под грилем 3-5 минут до расплавления сыра."}]'
FROM dishes WHERE name = 'Луковый суп по-французски'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Намазать два куска хлеба размягчённым сливочным маслом с обеих сторон."},{"step":2,"description":"На один кусок выложить ломтики ветчины."},{"step":3,"description":"Сверху покрыть тёртым сыром (грюйер, эмменталь или обычный)."},{"step":4,"description":"Накрыть вторым куском хлеба."},{"step":5,"description":"Обжаривать на сковороде по 3 минуты с каждой стороны до золотистой корочки."},{"step":6,"description":"Подавать горячим, можно с яичницей-пашот сверху."}]'
FROM dishes WHERE name = 'Крок-месье'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать все овощи кружочками толщиной 3-5 мм."},{"step":2,"description":"Мелко нарезать лук и чеснок, обжарить на масле 5 минут."},{"step":3,"description":"Добавить томатную пасту (или нарезанные помидоры), тушить 5 минут."},{"step":4,"description":"Уложить кружочки баклажана, кабачка, помидора и перца слоями поверх соуса."},{"step":5,"description":"Полить маслом, посолить, добавить прованские травы (орегано, тимьян)."},{"step":6,"description":"Запекать при 180°C 45 минут. Подавать тёплым или комнатной температуры."}]'
FROM dishes WHERE name = 'Рататуй по-провансальски'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Лук' THEN 1000 WHEN 'Хлеб' THEN 4 WHEN 'Сыр' THEN 120 WHEN 'Масло сливочное' THEN 60 WHEN 'Соль' THEN 5 END,
  CASE i.name WHEN 'Лук' THEN 'г' WHEN 'Хлеб' THEN 'ломт' WHEN 'Сыр' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Луковый суп по-французски' AND i.name IN ('Лук','Хлеб','Сыр','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Хлеб' THEN 4 WHEN 'Сыр' THEN 100 WHEN 'Ветчина' THEN 100 WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 3 END,
  CASE i.name WHEN 'Хлеб' THEN 'ломт' WHEN 'Сыр' THEN 'г' WHEN 'Ветчина' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Крок-месье' AND i.name IN ('Хлеб','Сыр','Ветчина','Масло сливочное','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Баклажаны' THEN 2 WHEN 'Кабачки' THEN 2 WHEN 'Помидоры' THEN 3 WHEN 'Перец болгарский' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Чеснок' THEN 3 WHEN 'Масло растительное' THEN 50 END,
  CASE i.name WHEN 'Баклажаны' THEN 'шт' WHEN 'Кабачки' THEN 'шт' WHEN 'Помидоры' THEN 'шт' WHEN 'Перец болгарский' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зуб' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рататуй по-провансальски' AND i.name IN ('Баклажаны','Кабачки','Помидоры','Перец болгарский','Лук','Чеснок','Масло растительное')
ON CONFLICT DO NOTHING;

-- ============================================================
-- EASTERN EUROPEAN DISHES (восточноевропейская кухня)
-- ============================================================

INSERT INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES
('Вареники с картошкой', 'Украинские вареники с нежной картофельной начинкой и луком', 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=400&h=520&fit=crop&q=80', 60, 'medium', 4, 5.00, TRUE, FALSE, 'eastern_european', 'dinner'),
('Паприкаш с курицей', 'Венгерское блюдо из курицы в сметанном соусе с паприкой', 'https://images.unsplash.com/photo-1598514983099-b501817cc55?w=400&h=520&fit=crop&q=80', 45, 'medium', 4, 10.00, FALSE, FALSE, 'eastern_european', 'dinner'),
('Картошка с грибами по-польски', 'Жареный картофель с грибами и луком, заправленный сметаной', 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=520&fit=crop&q=80', 35, 'easy', 3, 5.00, TRUE, FALSE, 'eastern_european', 'dinner')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Вареники с картошкой' AND i.name IN ('Мука','Картофель','Лук','Масло сливочное','Яйца','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паприкаш с курицей' AND i.name IN ('Курица','Лук','Паприка','Сметана','Масло растительное','Перец болгарский')
ON CONFLICT DO NOTHING;

INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Картошка с грибами по-польски' AND i.name IN ('Картофель','Грибы','Лук','Масло растительное','Сметана')
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замесить тесто из муки, яйца, воды и соли — эластичное, не липкое. Дать отдохнуть 20 минут."},{"step":2,"description":"Отварить картофель, сделать пюре."},{"step":3,"description":"Обжарить лук на масле до золотистости, половину добавить в пюре — это начинка."},{"step":4,"description":"Раскатать тесто тонко, нарезать кружочками. Выложить начинку, защипнуть края."},{"step":5,"description":"Варить в подсоленной воде 5-7 минут после всплытия."},{"step":6,"description":"Подавать с оставшимся жареным луком и сметаной."}]'
FROM dishes WHERE name = 'Вареники с картошкой'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать курицу на части, посолить и поперчить."},{"step":2,"description":"Обжарить курицу на масле до золотистой корочки, убрать."},{"step":3,"description":"В том же масле обжарить нарезанный лук и перец болгарский 5 минут."},{"step":4,"description":"Добавить паприку (щедро — 2-3 ст. ложки), жарить 1 минуту."},{"step":5,"description":"Вернуть курицу, добавить 200 мл воды, тушить на медленном огне 30 минут."},{"step":6,"description":"Снять с огня, вмешать сметану. Подавать с лапшой или картофелем."}]'
FROM dishes WHERE name = 'Паприкаш с курицей'
ON CONFLICT DO NOTHING;

INSERT INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать картофель кубиками, грибы — крупно, лук — полукольцами."},{"step":2,"description":"Обжарить картофель на масле до золотистости 15 минут."},{"step":3,"description":"Добавить лук и грибы, жарить ещё 10 минут до мягкости."},{"step":4,"description":"Посолить, поперчить по вкусу."},{"step":5,"description":"Добавить сметану, перемешать и прогреть 2-3 минуты."},{"step":6,"description":"Подавать горячим, можно с зеленью."}]'
FROM dishes WHERE name = 'Картошка с грибами по-польски'
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Мука' THEN 400 WHEN 'Картофель' THEN 500 WHEN 'Лук' THEN 2 WHEN 'Масло сливочное' THEN 50 WHEN 'Яйца' THEN 1 WHEN 'Соль' THEN 10 END,
  CASE i.name WHEN 'Мука' THEN 'г' WHEN 'Картофель' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Масло сливочное' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Вареники с картошкой' AND i.name IN ('Мука','Картофель','Лук','Масло сливочное','Яйца','Соль')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Курица' THEN 800 WHEN 'Лук' THEN 2 WHEN 'Паприка' THEN 30 WHEN 'Сметана' THEN 200 WHEN 'Масло растительное' THEN 40 WHEN 'Перец болгарский' THEN 2 END,
  CASE i.name WHEN 'Курица' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Паприка' THEN 'г' WHEN 'Сметана' THEN 'г' WHEN 'Масло растительное' THEN 'мл' WHEN 'Перец болгарский' THEN 'шт' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Паприкаш с курицей' AND i.name IN ('Курица','Лук','Паприка','Сметана','Масло растительное','Перец болгарский')
ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 600 WHEN 'Грибы' THEN 300 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 50 WHEN 'Сметана' THEN 100 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Грибы' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Сметана' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картошка с грибами по-польски' AND i.name IN ('Картофель','Грибы','Лук','Масло растительное','Сметана')
ON CONFLICT DO NOTHING;


-- dish 63: Вареные яйца (сейчас: глазунья на тосте)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1582169296194-e4d644c48063?w=400&h=520&fit=crop&q=80' WHERE id = 63;

-- dish 64: Яичница с помидорами (сейчас: десерт)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400&h=520&fit=crop&q=80' WHERE id = 64;
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

-- ============================================================
-- Migration 012 (appended)
-- ============================================================
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
-- Migration 013 (appended)
-- ============================================================
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
