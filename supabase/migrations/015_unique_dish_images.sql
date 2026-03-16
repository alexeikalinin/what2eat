-- Migration 015: Unique images per dish type
-- Fixes: 5 largest shared-image groups, broken chicken URL, semantic mismatch
-- Strategy: specific dish names override category rules from migration 013
-- All Unsplash IDs verified from prior migrations in this project

-- ══════════════════════════════════════════════════════════════
-- 1. BROKEN CHICKEN IMAGE (photo-1598103442097 → 404)
--    All ~10 chicken dishes had this broken URL assigned by 013
-- ══════════════════════════════════════════════════════════════
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=520&fit=crop&q=80'
WHERE image_url LIKE '%1598103442097%';

-- ══════════════════════════════════════════════════════════════
-- 2. SOUPS — 11 dishes shared photo-1547592166
--    Борщ, Щи, Солянка, Харчо, Рассольник keep the borscht image
-- ══════════════════════════════════════════════════════════════

-- Газпачо: cold red tomato soup (unique)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%газпачо%';

-- Фо бо, Рамен: Asian noodle soups (unique)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1559628233-100c798642d7?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%фо бо%' OR name ILIKE '%рамен%';

-- Уха: fish soup → fish/salmon image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%уха%';

-- Окрошка: cold vegetable soup → salad/veg image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%окрошк%';

-- Суп грибной: mushroom soup → earthy/cabbage image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%суп грибн%' OR name ILIKE '%грибной суп%';

-- Луковый суп: French onion soup → baked/caramelized (julienne image)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1604152135912-04a022e23696?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%луков%суп%' OR name ILIKE '%суп.*луков%';

-- Минестроне, Гороховый, Чечевичный: green/legume soups → light rice bowl image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%минестроне%' OR name ILIKE '%горохов%суп%' OR name ILIKE '%чечевич%суп%';

-- Мисо-суп: Asian → pilaf/golden image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%мисо%';

-- Крем-суп из тыквы: golden → pilaf/golden image (same as miso, ok for 2)
-- already handled by мисо above if it doesn't match; set explicitly
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%крем-суп%тыкв%' OR name ILIKE '%суп.*тыкв%' OR name ILIKE '%тыкв%суп%';

-- ══════════════════════════════════════════════════════════════
-- 3. PASTA — 18 dishes shared photo-1621996346565
--    Спагетти Болоньезе keeps the canonical pasta image
-- ══════════════════════════════════════════════════════════════

-- Карбонара → baked/creamy julienne image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1604152135912-04a022e23696?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%карбонар%';

-- Лазанья → layered dish (golubcy/cabbage-roll image = layered)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%лазань%';

-- Паста с грибами, Спагетти с грибами → Mediterranean veg (earthier)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=520&fit=crop&q=80'
WHERE (name ILIKE '%паста%' OR name ILIKE '%спагетти%') AND name ILIKE '%гриб%';

-- Феттучин, Альфредо → light/creamy (white rice bowl image)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%феттучин%' OR name ILIKE '%альфредо%';

-- Макароны с курицей → use grilled meat + pasta context (meatball image)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80'
WHERE (name ILIKE '%макарон%' OR name ILIKE '%паста%' OR name ILIKE '%лапш%') AND name ILIKE '%куриц%';

-- Лагман → pilaf/Central Asian image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%лагман%';

-- ══════════════════════════════════════════════════════════════
-- 4. PORRIDGE / GRAIN — 17 dishes shared photo-1574484284002
--    Овсяная каша keeps the canonical porridge image
-- ══════════════════════════════════════════════════════════════

-- Гречка с мясом / грибами / луком → savory, pilaf-like
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%гречк%' AND (name ILIKE '%гриб%' OR name ILIKE '%мяс%' OR name ILIKE '%лук%' OR name ILIKE '%куриц%' OR name ILIKE '%бекон%');

-- Перловая каша → white rice bowl image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%перловк%' OR name ILIKE '%перловая каша%';

-- Пшённая каша → Mediterranean/warm veg image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%пшённ%каш%' OR name ILIKE '%пшенн%каш%';

-- Кукурузная каша / Полента → light colored (rice bowl)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%кукурузн%каш%' OR name ILIKE '%полент%';

-- ══════════════════════════════════════════════════════════════
-- 5. POTATO — 14 dishes shared photo-1518977676601
--    Картофельное пюре keeps the canonical potato image
-- ══════════════════════════════════════════════════════════════

-- Драники → specific potato pancake image (from plan 010)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%драник%';

-- Вареники с картофелем → dumplings image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%вареник%';

-- Запеканка картофельная → julienne/baked with cheese image
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1604152135912-04a022e23696?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%запеканк%' AND name ILIKE '%картоф%';

-- ══════════════════════════════════════════════════════════════
-- 6. SALADS — 9 dishes shared photo-1512621776951
--    Leaves some salads with green salad image (3 salads ok to share)
-- ══════════════════════════════════════════════════════════════

-- Цезарь → specific Caesar image (from plan 010)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1550304943-4f24f54ddde9?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%цезарь%';

-- Греческий салат → Mediterranean vegetables image (from plan 010)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%греческий%';

-- Оливье → blini/pancake texture image (closest to egg+potato salad)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299543923-37dd37887442?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%оливье%';

-- Шуба (Сельдь под шубой) → earthy/beet (golubcy earthy image)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%шуба%' OR name ILIKE '%сельдь под%';

-- Табуле, Фаттуш → grain/herb salad (rice/pilaf image)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%табуле%' OR name ILIKE '%фаттуш%';

-- ══════════════════════════════════════════════════════════════
-- 7. SPECIFIC DISHES: Restore original plan-010 images
--    (overridden by 013's category-level rules)
-- ══════════════════════════════════════════════════════════════

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%медовик%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1508737027454-e6454ef45afd?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%чизкейк%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%панна котта%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534080564583-6be75777b70a?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%паэл%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1561043433-aaf687c4cf04?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%хумус%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%яйца бенедикт%';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1541519227354-08fa5d50c820?w=400&h=520&fit=crop&q=80'
WHERE name ILIKE '%авокадо тост%' OR (name ILIKE '%тост%' AND name ILIKE '%авокадо%');

-- ══════════════════════════════════════════════════════════════
-- 8. SEMANTIC FIX: Гречка с грибами и луком missing Грибы
-- ══════════════════════════════════════════════════════════════
INSERT INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гречка с грибами и луком' AND i.name = 'Грибы'
ON CONFLICT DO NOTHING;
