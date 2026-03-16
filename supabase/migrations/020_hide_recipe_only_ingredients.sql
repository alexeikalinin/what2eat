-- Migration 020: Hide recipe-only imported ingredients from selector
-- Background: import_recipes.py added ~950 recipe-specific ingredients (id >= 180)
-- with default category='other' and show_in_selector=true.
-- These flooded the Supabase 1000-row response limit, hiding vegetables/spices.

UPDATE ingredients
SET show_in_selector = false
WHERE id >= 180
  AND category = 'other';

-- Also hide ingredients from migrations 012+ that have category='other' and high IDs
-- (these were imported as recipe-specific, not user-selectable)
