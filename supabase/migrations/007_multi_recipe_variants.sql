-- ============================================================
-- Migration 007: Multiple recipe variants per dish
-- - Delete duplicate dishes created by migrations 004 + 006
-- - Drop UNIQUE constraint on recipes.dish_id
-- - Add title + source_url to recipes
-- ============================================================

-- Step 1: Delete duplicate dishes (migration 006 re-added dishes already in 004/005)
-- Keep lowest ID (from 004), delete the duplicates added by 006
DELETE FROM dishes WHERE id IN (
  132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 149
);

-- Step 2: Add recipe variant fields
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS title TEXT NOT NULL DEFAULT 'Классический';
ALTER TABLE recipes ADD COLUMN IF NOT EXISTS source_url TEXT;

-- Step 3: Drop UNIQUE constraint so dish can have multiple recipe variants
ALTER TABLE recipes DROP CONSTRAINT IF EXISTS recipes_dish_id_key;

-- Step 4: Add index for efficient lookup by dish_id (replaces the unique constraint index)
CREATE INDEX IF NOT EXISTS idx_recipes_dish_id ON recipes(dish_id);
