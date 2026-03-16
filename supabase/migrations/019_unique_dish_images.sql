-- Migration 019: Fix duplicate and wrong dish images
-- Replaces shared/incorrect Unsplash URLs with dish-specific photos
-- Affected groups: eggs, pasta, chicken, grains, potato, rice, soups

-- ── ЯЙЦА ──────────────────────────────────────────────────────────────────────
-- Previously all shared photo-1482049016688-2d3e1b311543 (avocado toast — WRONG)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80' WHERE name = 'Яичница';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1588166524941-3bf61a9c41db?w=400&h=520&fit=crop&q=80' WHERE name = 'Яичница с помидорами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476224203421-9ac39bcb3df1?w=400&h=520&fit=crop&q=80' WHERE name = 'Яичница с колбасой';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=400&h=520&fit=crop&q=80' WHERE name = 'Яичница с грибами';

-- Шакшука: fix wrong avocado toast photo → correct shakshuka photo
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1590330297626-d7aff25a0431?w=400&h=520&fit=crop&q=80' WHERE name = 'Шакшука';

-- Previously photo-1582169296194-e4d644c48063 (nachos — WRONG)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1474722883778-792e7990302f?w=400&h=520&fit=crop&q=80' WHERE name = 'Вареные яйца';

-- ── ПАСТА / МАКАРОНЫ ──────────────────────────────────────────────────────────
-- Previously all 16 dishes sharing the same generic pasta URL
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1633337474564-1d9478ca4e2e?w=400&h=520&fit=crop&q=80' WHERE name = 'Паста Болоньезе';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1612892483236-52d32a0e0ac1?w=400&h=520&fit=crop&q=80' WHERE name = 'Паста Карбонара';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=400&h=520&fit=crop&q=80' WHERE name = 'Паста Аматричана';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400&h=520&fit=crop&q=80' WHERE name = 'Ньокки с соусом Песто';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=400&h=520&fit=crop&q=80' WHERE name = 'Паста с грибами в сливочном соусе';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1528736235302-52922df5c122?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с сыром';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=520&fit=crop&q=80' WHERE name = 'Лапша удон с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=520&fit=crop&q=80' WHERE name = 'Суп с вермишелью';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=520&fit=crop&q=80' WHERE name = 'Куриная лапша';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с маслом';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны по-флотски';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1474722883778-792e7990302f?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с грибами в сметане';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Фарш с макаронами';

-- ── КУРИЦА ────────────────────────────────────────────────────────────────────
-- Differentiated from generic chicken URL
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=520&fit=crop&q=80' WHERE name = 'Курица терияки';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' WHERE name = 'Курица в сметане';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=520&fit=crop&q=80' WHERE name = 'Карри с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' WHERE name = 'Сациви с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Паприкаш с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' WHERE name = 'Тажин с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=400&h=520&fit=crop&q=80' WHERE name = 'Шашлык из свинины';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=520&fit=crop&q=80' WHERE name = 'Пад Тай с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80' WHERE name = 'Кесадилья с курицей и сыром';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80' WHERE name = 'Буррито с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=520&fit=crop&q=80' WHERE name = 'Говядина по-китайски';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с говядиной';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны со свининой';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80' WHERE name = 'Фахитас с говядиной';

-- ── КАШИ / ГРЕЧКА ─────────────────────────────────────────────────────────────
-- Differentiated porridge types from generic buckwheat URL
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка со свининой';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречневая каша с мясом';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80' WHERE name = 'Овсяная каша с молоком';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=520&fit=crop&q=80' WHERE name = 'Манная каша';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1536304993881-ff86e0c9c5e7?w=400&h=520&fit=crop&q=80' WHERE name = 'Рисовая каша на молоке';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80' WHERE name = 'Овсянка с говядиной';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80' WHERE name = 'Овсянка с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80' WHERE name = 'Овсянка со свининой';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400&h=520&fit=crop&q=80' WHERE name = 'Сосиски с гречкой';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с грибами и луком';

-- ── КАРТОФЕЛЬ ─────────────────────────────────────────────────────────────────
-- Differentiated potato dishes from generic fried potato URL
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1571167366136-f4b1eb35b13e?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофельное пюре';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80' WHERE name = 'Суп картофельный';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с говядиной';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с курицей и овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель со свининой';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1474722883778-792e7990302f?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Фарш с картофелем';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Сосиски с картофелем';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофельная запеканка';

-- ── РИС ───────────────────────────────────────────────────────────────────────
-- Differentiated rice dishes from generic rice URL
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=520&fit=crop&q=80' WHERE name = 'Жареный рис с яйцом';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1474722883778-792e7990302f?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с говядиной';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с курицей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с курицей и овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис со свининой';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' WHERE name = 'Сосиски с рисом';

-- ── СУПЫ ──────────────────────────────────────────────────────────────────────
-- Differentiated soups from generic borscht URL
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80' WHERE name = 'Уха';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80' WHERE name = 'Окрошка на кефире';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80' WHERE name = 'Суп из чечевицы';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80' WHERE name = 'Минестроне';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80' WHERE name = 'Газпачо';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80' WHERE name = 'Суп грибной';
