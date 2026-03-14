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
