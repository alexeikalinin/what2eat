-- ============================================================
-- Migration 009: Fix duplicate Unsplash images
-- Each dish gets its own unique photo
-- ============================================================

-- ─── GROUP 1: Супы (все делили photo-1547592166-6d74a4ccbe73) ───
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-Oos6SXFM6zs?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Щи из капусты';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-PyYfyE8s3Fc?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Куриный суп';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-fxJTl_gDh28?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Суп Том Ям';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-k5VGs9qQubc?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Суп Буйабес';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-U9DW1GGTTXw?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Солянка';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-DDlhPxA1xIo?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Мексиканский суп с фасолью';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-8ni7LN6vaQ8?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Рис со свининой';

-- ─── GROUP 2: Яичные (делили photo-1525351484163-7529414344d8) ───
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-fdXnVBurIvU?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Вареные яйца';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-aYa59YITMWo?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Гренки яичные';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-4gmBIFraSuE?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Омлет';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-KjCRLweJsrA?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Яичница с помидорами';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-IQSDSFO9UuI?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Макароны с яичницей';

-- ─── GROUP 3: Каши (делили photo-1517673400267-0251440c45dc) ───
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-Vk044I3w1gI?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Манная каша';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-kdXXgdRulnI?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Пшённая каша';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-s8GfYrV88vo?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Рисовая каша на молоке';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-ZavNEhIrtxg?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Овсяная каша с молоком';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-KXAP_2ASPXI?w=400&h=520&fit=crop&q=80'
  WHERE name IN ('Овсянка с говядиной', 'Овсянка с курицей', 'Овсянка со свининой');

-- ─── GROUP 4: Сосиски (делили фото с бутербродами) ───
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-GU_L_q0d6R0?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Сосиски с гречкой';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-Lzs91p-qI64?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Сосиски с картофелем';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-JeJ5IpCG1mw?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Сосиски с рисом';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-fDLBn8X_IlU?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Макароны с сосисками';

-- ─── GROUP 5: Курица (делили photo-1598514983-99b501817cc5) ───
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-9aajnmX70Eo?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Чкмерули';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-4qJlXK4mYzU?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Картофель с курицей';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-iIhidk0lr9I?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Картофель с курицей и овощами';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-XaDsH-O2QXs?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Тажин с курицей';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-ZjEeMnDiq00?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Картофель с овощами';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-vrWt8ZI-2D8?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Картофель с яичницей';

-- ─── GROUP 6: Картофельные блюда (делили photo-1568600891046) ───
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-hnD-BKPakG4?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Картофель с вареными яйцами';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-5yGd-Uo62Zo?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Картофель с говядиной';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-b94AylTxWqA?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Картофель со свининой';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-8Cerf3zW8hA?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Картофельная запеканка';

-- ─── GROUP 7: Прочие дубли ───

-- Рис-блюда (делили photo-1512058454905)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-OC3lZI9P6kU?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Рис с говядиной';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-Nx3OCfnRit8?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Рис с яичницей';

-- Гречка-блюда
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1OhuSZ2hchk?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Гречка с вареными яйцами';

UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-vG7_DsRlw3Q?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Гречка с овощами';

-- Гуляш и пюре (photo-1574484284823)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-ZSukCSw5VV4?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Чешский гуляш';

-- Творог
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-d2ziNHmnWBU?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Творожная запеканка';

-- Омлет с сыром
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-6rtm6a_aVyE?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Омлет с сыром';

-- Рассольник / Свекольник
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-QPqJeoPNHy4?w=400&h=520&fit=crop&q=80'
  WHERE name = 'Рассольник';
