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
