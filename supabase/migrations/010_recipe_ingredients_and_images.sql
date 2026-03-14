-- Migration 010: recipe_ingredients for recipes 1-32 + fix broken image URLs
-- Run in Supabase SQL Editor

-- Part 1: Add recipe_ingredients for recipes 1-32
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 1, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 4, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (1, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 1, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 5, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (2, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 1, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 6, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (3, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 2, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 4, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (4, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (5, 2, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (5, 5, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (5, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (5, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (5, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (6, 1, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (6, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (6, 11, '4', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (6, 13, '2', 'зуб') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (6, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (7, 2, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (7, 4, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (7, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (7, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (7, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (8, 3, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (8, 4, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (8, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (8, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (9, 2, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (9, 6, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (9, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (9, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (9, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (10, 3, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (10, 6, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (10, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (10, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (10, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (11, 3, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (11, 5, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (11, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (11, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (11, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (12, 1, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (12, 7, '150', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (12, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (12, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (13, 2, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (13, 7, '150', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (13, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (13, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (13, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (14, 3, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (14, 7, '150', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (14, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (14, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (15, 2, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (15, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (15, 11, '4', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (15, 13, '2', 'зуб') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (15, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (16, 3, '400', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (16, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (16, 11, '4', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (16, 13, '2', 'зуб') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (16, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (17, 4, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (17, 31, '2', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (17, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (18, 5, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (18, 31, '2', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (18, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (19, 6, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (19, 31, '2', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (19, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (20, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (20, 11, '4', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (20, 31, '2', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (20, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (21, 4, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (21, 31, '2', 'шт') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (22, 5, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (22, 31, '2', 'шт') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (23, 6, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (23, 31, '2', 'шт') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (24, 11, '4', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (24, 31, '2', 'шт') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (25, 7, '150', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (25, 28, '200', 'мл') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (26, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (26, 31, '2', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (26, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (26, 36, '400', 'г') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (27, 4, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (27, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (27, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (27, 37, '4', 'шт') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (28, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (28, 11, '4', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (28, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (28, 37, '4', 'шт') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (29, 5, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (29, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (29, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (29, 37, '4', 'шт') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (30, 6, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (30, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (30, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (30, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (30, 37, '4', 'шт') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (31, 4, '200', 'г') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (31, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (31, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (31, 36, '400', 'г') ON CONFLICT DO NOTHING;

INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (32, 8, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (32, 9, '1', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (32, 11, '4', 'шт') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (32, 34, '2', 'ст.л') ON CONFLICT DO NOTHING;
INSERT INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES (32, 36, '400', 'г') ON CONFLICT DO NOTHING;
-- Part 2: Fix broken image URLs (40 dishes)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1518779578993-ec3579fee39f?w=400&h=520&fit=crop&q=80' WHERE id = 6;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400&h=520&fit=crop&q=80' WHERE id = 9;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1536304993881-ff86d42818e8?w=400&h=520&fit=crop&q=80' WHERE id = 10;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1428515613728-6b4607e44363?w=400&h=520&fit=crop&q=80' WHERE id = 12;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3327?w=400&h=520&fit=crop&q=80' WHERE id = 13;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1620905879383-94a1e5a3170f?w=400&h=520&fit=crop&q=80' WHERE id = 14;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1539136788836-5699e78bfc75?w=400&h=520&fit=crop&q=80' WHERE id = 15;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1506976785307-8732e854ad03?w=400&h=520&fit=crop&q=80' WHERE id = 16;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1551183053-bf91798d09db?w=400&h=520&fit=crop&q=80' WHERE id = 17;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80' WHERE id = 19;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1597690000349-9a14a7f3cf9c?w=400&h=520&fit=crop&q=80' WHERE id = 20;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1505253468034-514d2507d914?w=400&h=520&fit=crop&q=80' WHERE id = 22;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1610832958506-aa56368176cf?w=400&h=520&fit=crop&q=80' WHERE id = 24;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1578020190125-f4f7c18bc9cb?w=400&h=520&fit=crop&q=80' WHERE id = 26;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=520&fit=crop&q=80' WHERE id = 28;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1562967914-608f82629710?w=400&h=520&fit=crop&q=80' WHERE id = 32;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1495214783159-3503fd1b572d?w=400&h=520&fit=crop&q=80' WHERE id = 33;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=400&h=520&fit=crop&q=80' WHERE id = 35;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529543544282-ea669407fca3?w=400&h=520&fit=crop&q=80' WHERE id = 36;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=520&fit=crop&q=80' WHERE id = 37;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1546549032-9571cd6b27df?w=400&h=520&fit=crop&q=80' WHERE id = 38;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1603105037880-880cd4edfb0d?w=400&h=520&fit=crop&q=80' WHERE id = 43;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1571115177098-24ec42ed204d?w=400&h=520&fit=crop&q=80' WHERE id = 44;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534939561126-855b8675edd3?w=400&h=520&fit=crop&q=80' WHERE id = 53;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=400&h=520&fit=crop&q=80' WHERE id = 54;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1548940740-204726a19be3?w=400&h=520&fit=crop&q=80' WHERE id = 56;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1466637574441-749b8f19452f?w=400&h=520&fit=crop&q=80' WHERE id = 60;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1542444592-3d4b4f77a19d?w=400&h=520&fit=crop&q=80' WHERE id = 62;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1525351326368-efbb5cb6814d?w=400&h=520&fit=crop&q=80' WHERE id = 63;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1494597564530-871f2b93ac55?w=400&h=520&fit=crop&q=80' WHERE id = 64;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1564671165093-20688ff1fffa?w=400&h=520&fit=crop&q=80' WHERE id = 69;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&h=520&fit=crop&q=80' WHERE id = 70;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1541658016709-82535e94bc69?w=400&h=520&fit=crop&q=80' WHERE id = 71;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400&h=520&fit=crop&q=80' WHERE id = 75;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1553361371-9b22f78e8b1d?w=400&h=520&fit=crop&q=80' WHERE id = 88;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1598511757337-fe2cafc31ba2?w=400&h=520&fit=crop&q=80' WHERE id = 102;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80' WHERE id = 109;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=400&h=520&fit=crop&q=80' WHERE id = 118;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80' WHERE id = 122;
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1511690743698-d9d85f2fbf38?w=400&h=520&fit=crop&q=80' WHERE id = 126;