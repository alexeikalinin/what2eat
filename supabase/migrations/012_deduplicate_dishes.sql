-- Migration 012: удалить дублирующиеся блюда
-- Оставляем блюдо с наименьшим id (первое добавленное), удаляем остальные копии

-- Найти и удалить дубли: оставляем min(id) для каждого названия
-- ON DELETE CASCADE должен удалить связанные dish_ingredients, recipes, recipe_ingredients

DELETE FROM dishes
WHERE id NOT IN (
  SELECT MIN(id)
  FROM dishes
  GROUP BY LOWER(TRIM(name))
);
