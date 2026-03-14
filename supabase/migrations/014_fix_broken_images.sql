-- Migration 014: Исправление битых и неправильных изображений
-- 6 фото удалены с Unsplash (404), несколько явных несоответствий

-- ── 404 URLs → NULL (будет использоваться SVG-заглушка с эмодзи) ──
-- photo-1574484284823 (удалено) — Говяжий гуляш
UPDATE dishes SET image_url = NULL
WHERE image_url LIKE '%1574484284823%';

-- photo-1544025162 (удалено) — Долма, Бёф Бургиньон
UPDATE dishes SET image_url = NULL
WHERE image_url LIKE '%1544025162%';

-- photo-1555396273 (удалено) — Польский бигос
UPDATE dishes SET image_url = NULL
WHERE image_url LIKE '%1555396273%';

-- photo-1617196034183 (удалено) — Хачапури по-аджарски
UPDATE dishes SET image_url = NULL
WHERE image_url LIKE '%1617196034183%';

-- photo-1598511757337 (удалено) — Чкмерули
UPDATE dishes SET image_url = NULL
WHERE image_url LIKE '%1598511757337%';

-- photo-1571091655789 (удалено) — Дзадзики (был бургер вместо соуса)
UPDATE dishes SET image_url = NULL
WHERE image_url LIKE '%1571091655789%';

-- ── Явные несоответствия ──

-- photo-1547592180-85f173990554 = азиатское мясо с перцем, использовалось для Минестроне
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80'
WHERE image_url LIKE '%1547592180%';

-- photo-1565958011703 = малиновый торт, использовалось для Киш Лорен
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=520&fit=crop&q=80'
WHERE image_url LIKE '%1565958011703%';

-- photo-1571115177098 = шоколадный торт, использовалось для Творожной запеканки (id=44)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80'
WHERE image_url LIKE '%1571115177098%';

-- photo-1504674900247 = лосось с кускусом, использовалось для Шакшуки и Лобиани
-- Шакшука → яичница (ближе всего)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1482049016688-2d3e1b311543?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%шакшук%' AND image_url LIKE '%1504674900247%';
-- Лобиани → пирог
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%лобиан%';

-- Чешский гуляш — был тако (photo-1565299585323), нужно мясо
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%чешский гуляш%';

-- Начос — был фото яиц (photo-1582169296194)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%начос%';

-- Фалафель → хумус/ближневосточное
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1517191434949-5e90cd67d2b6?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%фалафел%';

-- Аджапсандали (грузинское овощное рагу) → рататуй/овощи
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%аджапсандал%';

-- Чили кон карне → мясо с бобами
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%чили кон%';
