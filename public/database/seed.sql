-- Начальные данные для базы данных "ЧтоЕсть"

-- Ингредиенты
INSERT OR IGNORE INTO ingredients (name, category, image_url) VALUES
('Курица', 'meat', '/images/ingredients/chicken.jpg'),
('Говядина', 'meat', '/images/ingredients/beef.jpg'),
('Свинина', 'meat', '/images/ingredients/pork.jpg'),
('Макароны', 'cereals', '/images/ingredients/pasta.jpg'),
('Гречка', 'cereals', '/images/ingredients/buckwheat.jpg'),
('Рис', 'cereals', '/images/ingredients/rice.jpg'),
('Овсянка', 'cereals', '/images/ingredients/oatmeal.jpg'),
('Лук', 'vegetables', '/images/ingredients/onion.jpg'),
('Морковь', 'vegetables', '/images/ingredients/carrot.jpg'),
('Помидоры', 'vegetables', '/images/ingredients/tomatoes.jpg'),
('Картофель', 'vegetables', '/images/ingredients/potato.jpg'),
('Перец болгарский', 'vegetables', '/images/ingredients/bell-pepper.jpg'),
('Чеснок', 'vegetables', '/images/ingredients/garlic.jpg'),
('Огурцы', 'vegetables', '/images/ingredients/cucumber.jpg'),
('Капуста', 'vegetables', '/images/ingredients/cabbage.jpg'),
('Кабачки', 'vegetables', '/images/ingredients/zucchini.jpg'),
('Баклажаны', 'vegetables', '/images/ingredients/eggplant.jpg'),
('Свекла', 'vegetables', '/images/ingredients/beetroot.jpg'),
('Редис', 'vegetables', '/images/ingredients/radish.jpg'),
('Укроп', 'vegetables', '/images/ingredients/dill.jpg'),
('Петрушка', 'vegetables', '/images/ingredients/parsley.jpg'),
('Шпинат', 'vegetables', '/images/ingredients/spinach.jpg'),
('Брокколи', 'vegetables', '/images/ingredients/broccoli.jpg'),
('Цветная капуста', 'vegetables', '/images/ingredients/cauliflower.jpg'),
('Лук зеленый', 'vegetables', '/images/ingredients/green-onion.jpg'),
('Сельдерей', 'vegetables', '/images/ingredients/celery.jpg'),
('Тыква', 'vegetables', '/images/ingredients/pumpkin.jpg'),
('Молоко', 'dairy', '/images/ingredients/milk.jpg'),
('Сыр', 'dairy', '/images/ingredients/cheese.jpg'),
('Сметана', 'dairy', '/images/ingredients/sour-cream.jpg'),
('Яйца', 'dairy', '/images/ingredients/eggs.jpg'),
('Соль', 'spices', '/images/ingredients/salt.jpg'),
('Перец черный', 'spices', '/images/ingredients/black-pepper.jpg'),
('Масло растительное', 'other', '/images/ingredients/vegetable-oil.jpg'),
('Масло сливочное', 'dairy', '/images/ingredients/butter.jpg'),
('Фарш', 'meat', '/images/ingredients/minced-meat.jpg'),
('Сосиски', 'meat', '/images/ingredients/sausages.jpg');

-- Блюда
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan) VALUES
('Макароны с курицей', 'Сытное и простое блюдо из макарон и курицы', 'https://images.unsplash.com/photo-1563379906659-ee70c0c47ba6?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 8.00, 0, 0),
('Гречка с курицей', 'Классическое блюдо русской кухни', 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80', 40, 'easy', 4, 8.00, 0, 0),
('Рис с курицей', 'Вкусное блюдо из риса и курицы', 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 8.00, 0, 0),
('Макароны по-флотски', 'Макароны с говяжьим фаршем', 'https://images.unsplash.com/photo-1555396273-122e7a6ce434?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 9.00, 0, 0),
('Гречневая каша с мясом', 'Сытная гречка с говядиной', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80', 50, 'medium', 4, 10.00, 0, 0),
('Картофель с курицей', 'Запеченный картофель с курицей', 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80', 45, 'easy', 4, 9.00, 0, 0),
('Макароны с говядиной', 'Макароны с тушеной говядиной', 'https://images.unsplash.com/photo-1551218372-a8789b81b253?w=400&h=520&fit=crop&q=80', 45, 'medium', 4, 11.00, 0, 0),
('Макароны со свининой', 'Макароны с обжаренной свининой', 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 10.00, 0, 0),
('Рис с говядиной', 'Рис с тушеной говядиной', 'https://images.unsplash.com/photo-1544025162-d76538415e0f?w=400&h=520&fit=crop&q=80', 50, 'medium', 4, 11.00, 0, 0),
('Рис со свининой', 'Рис с обжаренной свининой', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 40, 'easy', 4, 10.00, 0, 0),
('Гречка со свининой', 'Гречка с обжаренной свининой', 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80', 45, 'easy', 4, 10.00, 0, 0),
('Овсянка с курицей', 'Овсяная каша с курицей', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 7.00, 0, 0),
('Овсянка с говядиной', 'Овсяная каша с говядиной', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 40, 'medium', 4, 9.00, 0, 0),
('Овсянка со свининой', 'Овсяная каша со свининой', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 8.00, 0, 0),
('Картофель с говядиной', 'Запеченный картофель с говядиной', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 55, 'medium', 4, 12.00, 0, 0),
('Картофель со свининой', 'Запеченный картофель со свининой', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 50, 'easy', 4, 10.00, 0, 0),
('Макароны с яичницей', 'Макароны с жареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 20, 'easy', 4, 4.00, 1, 0),
('Гречка с яичницей', 'Гречка с жареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 4.00, 1, 0),
('Рис с яичницей', 'Рис с жареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 4.00, 1, 0),
('Картофель с яичницей', 'Картофель с жареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 4.00, 1, 0),
('Макароны с вареными яйцами', 'Макароны с вареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 20, 'easy', 4, 3.00, 1, 0),
('Гречка с вареными яйцами', 'Гречка с вареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 3.00, 1, 0),
('Рис с вареными яйцами', 'Рис с вареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 3.00, 1, 0),
('Картофель с вареными яйцами', 'Картофель с вареными яйцами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 4.00, 1, 0),
('Макароны с овощами', 'Макароны с помидорами, луком и морковью', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 5.00, 1, 1),
('Гречка с овощами', 'Гречка с морковью, луком и помидорами', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 4.00, 1, 1),
('Рис с овощами', 'Рис с морковью, луком и помидорами', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 4.00, 1, 1),
('Картофель с овощами', 'Запеченный картофель с овощами', 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80', 40, 'easy', 4, 4.00, 1, 1),
('Макароны с сыром', 'Макароны с тертым сыром', 'https://images.unsplash.com/photo-1618164435735-2cfee3e07c36?w=400&h=520&fit=crop&q=80', 20, 'easy', 4, 5.00, 1, 0),
('Гречка с грибами и луком', 'Гречка с обжаренными грибами и луком', 'https://images.unsplash.com/photo-1506807803488-8eafc15316c9?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 4.00, 1, 1),
('Рис с курицей и овощами', 'Рис с курицей, морковью и луком', 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&h=520&fit=crop&q=80', 40, 'easy', 4, 9.00, 0, 0),
('Картофель с курицей и овощами', 'Запеченный картофель с курицей и овощами', 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80', 50, 'medium', 4, 10.00, 0, 0),
('Овсяная каша с молоком', 'Классическая овсяная каша на молоке', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 2.00, 1, 0),
('Котлеты из фарша', 'Классические котлеты из мясного фарша', 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 9.00, 0, 0),
('Макароны с сосисками', 'Простое и сытное блюдо из макарон и сосисок', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 20, 'easy', 4, 6.00, 0, 0),
('Сосиски с картофелем', 'Жареные сосиски с картофелем', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 7.00, 0, 0),
('Сосиски с гречкой', 'Гречка с жареными сосисками', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 7.00, 0, 0),
('Сосиски с рисом', 'Рис с жареными сосисками', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 7.00, 0, 0),
('Фарш с макаронами', 'Макароны с мясным фаршем и луком', 'https://images.unsplash.com/photo-1555396273-122e7a6ce434?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 8.00, 0, 0),
('Фарш с картофелем', 'Жареный фарш с картофелем', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 8.00, 0, 0);

-- Связи блюд и ингредиентов
-- Макароны с курицей (id=1)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(1, 1), -- Курица
(1, 4), -- Макароны
(1, 8), -- Лук
(1, 34); -- Масло растительное

-- Гречка с курицей (id=2)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(2, 1), -- Курица
(2, 5), -- Гречка
(2, 8), -- Лук
(2, 9), -- Морковь
(2, 34); -- Масло растительное

-- Рис с курицей (id=3)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(3, 1), -- Курица
(3, 6), -- Рис
(3, 8), -- Лук
(3, 9), -- Морковь
(3, 34); -- Масло растительное

-- Макароны по-флотски (id=4)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(4, 2), -- Говядина
(4, 4), -- Макароны
(4, 8), -- Лук
(4, 34); -- Масло растительное

-- Гречневая каша с мясом (id=5)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(5, 2), -- Говядина
(5, 5), -- Гречка
(5, 8), -- Лук
(5, 9), -- Морковь
(5, 34); -- Масло растительное

-- Картофель с курицей (id=6)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(6, 1), -- Курица
(6, 11), -- Картофель
(6, 8), -- Лук
(6, 13), -- Чеснок
(6, 34); -- Масло растительное

-- Макароны с говядиной (id=7)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(7, 2), -- Говядина
(7, 4), -- Макароны
(7, 8), -- Лук
(7, 9), -- Морковь
(7, 34); -- Масло растительное

-- Макароны со свининой (id=8)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(8, 3), -- Свинина
(8, 4), -- Макароны
(8, 8), -- Лук
(8, 34); -- Масло растительное

-- Рис с говядиной (id=9)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(9, 2), -- Говядина
(9, 6), -- Рис
(9, 8), -- Лук
(9, 9), -- Морковь
(9, 34); -- Масло растительное

-- Рис со свининой (id=10)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(10, 3), -- Свинина
(10, 6), -- Рис
(10, 8), -- Лук
(10, 9), -- Морковь
(10, 34); -- Масло растительное

-- Гречка со свининой (id=11)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(11, 3), -- Свинина
(11, 5), -- Гречка
(11, 8), -- Лук
(11, 9), -- Морковь
(11, 34); -- Масло растительное

-- Овсянка с курицей (id=12)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(12, 1), -- Курица
(12, 7), -- Овсянка
(12, 8), -- Лук
(12, 34); -- Масло растительное

-- Овсянка с говядиной (id=13)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(13, 2), -- Говядина
(13, 7), -- Овсянка
(13, 8), -- Лук
(13, 9), -- Морковь
(13, 34); -- Масло растительное

-- Овсянка со свининой (id=14)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(14, 3), -- Свинина
(14, 7), -- Овсянка
(14, 8), -- Лук
(14, 34); -- Масло растительное

-- Картофель с говядиной (id=15)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(15, 2), -- Говядина
(15, 11), -- Картофель
(15, 8), -- Лук
(15, 13), -- Чеснок
(15, 34); -- Масло растительное

-- Картофель со свининой (id=16)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(16, 3), -- Свинина
(16, 11), -- Картофель
(16, 8), -- Лук
(16, 13), -- Чеснок
(16, 34); -- Масло растительное

-- Макароны с яичницей (id=17)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(17, 31), -- Яйца
(17, 4), -- Макароны
(17, 34); -- Масло растительное

-- Гречка с яичницей (id=18)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(18, 31), -- Яйца
(18, 5), -- Гречка
(18, 34); -- Масло растительное

-- Рис с яичницей (id=19)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(19, 31), -- Яйца
(19, 6), -- Рис
(19, 34); -- Масло растительное

-- Картофель с яичницей (id=20)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(20, 31), -- Яйца
(20, 11), -- Картофель
(20, 8), -- Лук
(20, 34); -- Масло растительное

-- Макароны с вареными яйцами (id=21)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(21, 31), -- Яйца
(21, 4); -- Макароны

-- Гречка с вареными яйцами (id=22)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(22, 31), -- Яйца
(22, 5); -- Гречка

-- Рис с вареными яйцами (id=23)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(23, 31), -- Яйца
(23, 6); -- Рис

-- Картофель с вареными яйцами (id=24)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(24, 31), -- Яйца
(24, 11); -- Картофель

-- Макароны с овощами (id=25)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(25, 4), -- Макароны
(25, 10), -- Помидоры
(25, 8), -- Лук
(25, 9), -- Морковь
(25, 34); -- Масло растительное

-- Гречка с овощами (id=26)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(26, 5), -- Гречка
(26, 9), -- Морковь
(26, 8), -- Лук
(26, 10), -- Помидоры
(26, 34); -- Масло растительное

-- Рис с овощами (id=27)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(27, 6), -- Рис
(27, 9), -- Морковь
(27, 8), -- Лук
(27, 10), -- Помидоры
(27, 34); -- Масло растительное

-- Картофель с овощами (id=28)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(28, 11), -- Картофель
(28, 9), -- Морковь
(28, 8), -- Лук
(28, 10), -- Помидоры
(28, 34); -- Масло растительное

-- Макароны с сыром (id=29)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(29, 4), -- Макароны
(29, 29); -- Сыр

-- Гречка с грибами и луком (id=30)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(30, 5), -- Гречка
(30, 8), -- Лук
(30, 34); -- Масло растительное

-- Рис с курицей и овощами (id=31)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(31, 6), -- Рис
(31, 1), -- Курица
(31, 9), -- Морковь
(31, 8), -- Лук
(31, 34); -- Масло растительное

-- Картофель с курицей и овощами (id=32)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(32, 11), -- Картофель
(32, 1), -- Курица
(32, 9), -- Морковь
(32, 8), -- Лук
(32, 34); -- Масло растительное

-- Овсяная каша с молоком (id=33)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(33, 7), -- Овсянка
(33, 28); -- Молоко

-- Котлеты из фарша (id=34)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(34, 36), -- Фарш
(34, 8), -- Лук
(34, 31), -- Яйца
(34, 34); -- Масло растительное

-- Макароны с сосисками (id=35)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(35, 4), -- Макароны
(35, 37), -- Сосиски
(35, 8), -- Лук
(35, 34); -- Масло растительное

-- Сосиски с картофелем (id=36)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(36, 37), -- Сосиски
(36, 11), -- Картофель
(36, 8), -- Лук
(36, 34); -- Масло растительное

-- Сосиски с гречкой (id=37)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(37, 37), -- Сосиски
(37, 5), -- Гречка
(37, 8), -- Лук
(37, 34); -- Масло растительное

-- Сосиски с рисом (id=38)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(38, 37), -- Сосиски
(38, 6), -- Рис
(38, 8), -- Лук
(38, 9), -- Морковь
(38, 34); -- Масло растительное

-- Фарш с макаронами (id=39)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(39, 36), -- Фарш
(39, 4), -- Макароны
(39, 8), -- Лук
(39, 34); -- Масло растительное

-- Фарш с картофелем (id=40)
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id) VALUES
(40, 36), -- Фарш
(40, 11), -- Картофель
(40, 8), -- Лук
(40, 9), -- Морковь
(40, 34); -- Масло растительное

-- Рецепты
INSERT OR IGNORE INTO recipes (dish_id, instructions) VALUES
(1, '[
  {"step": 1, "description": "Нарезать курицу кубиками среднего размера"},
  {"step": 2, "description": "Нарезать лук полукольцами"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить лук до прозрачности, затем добавить курицу"},
  {"step": 5, "description": "Обжарить курицу до золотистого цвета, посолить и поперчить"},
  {"step": 6, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 7, "description": "Смешать готовые макароны с курицей и подавать горячим"}
]'),

(2, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать курицу кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить лук и морковь на сковороде"},
  {"step": 4, "description": "Добавить курицу и обжарить до готовности"},
  {"step": 5, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовую гречку с курицей и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(3, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать курицу кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить лук и морковь на сковороде"},
  {"step": 4, "description": "Добавить курицу и обжарить до готовности"},
  {"step": 5, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовый рис с курицей и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(4, '[
  {"step": 1, "description": "Нарезать лук мелко"},
  {"step": 2, "description": "Обжарить лук на сковороде до золотистого цвета"},
  {"step": 3, "description": "Добавить мясной фарш и обжарить до готовности"},
  {"step": 4, "description": "Посолить и поперчить по вкусу"},
  {"step": 5, "description": "Отварить макароны согласно инструкции"},
  {"step": 6, "description": "Смешать макароны с фаршем и подавать"}
]'),

(5, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать говядину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить мясо до образования корочки"},
  {"step": 4, "description": "Добавить лук и морковь, тушить 10 минут"},
  {"step": 5, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовую гречку с мясом и овощами"},
  {"step": 7, "description": "Тушить еще 5 минут и подавать"}
]'),

(6, '[
  {"step": 1, "description": "Нарезать картофель крупными кубиками"},
  {"step": 2, "description": "Нарезать курицу кубиками, лук и чеснок"},
  {"step": 3, "description": "Смешать все ингредиенты с растительным маслом"},
  {"step": 4, "description": "Посолить, поперчить, добавить специи"},
  {"step": 5, "description": "Выложить на противень и запекать при 200°C 35-40 минут"},
  {"step": 6, "description": "Подавать горячим"}
]'),

(7, '[
  {"step": 1, "description": "Нарезать говядину кубиками среднего размера"},
  {"step": 2, "description": "Нарезать лук и морковь"},
  {"step": 3, "description": "Обжарить говядину до образования корочки"},
  {"step": 4, "description": "Добавить лук и морковь, тушить 15 минут"},
  {"step": 5, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 6, "description": "Смешать готовые макароны с мясом и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(8, '[
  {"step": 1, "description": "Нарезать свинину кубиками среднего размера"},
  {"step": 2, "description": "Нарезать лук полукольцами"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить лук до прозрачности, затем добавить свинину"},
  {"step": 5, "description": "Обжарить свинину до готовности, посолить и поперчить"},
  {"step": 6, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 7, "description": "Смешать готовые макароны со свининой и подавать горячим"}
]'),

(9, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать говядину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить говядину до образования корочки"},
  {"step": 4, "description": "Добавить лук и морковь, тушить 10 минут"},
  {"step": 5, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовый рис с мясом и овощами"},
  {"step": 7, "description": "Тушить еще 5 минут и подавать"}
]'),

(10, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать свинину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить лук и морковь на сковороде"},
  {"step": 4, "description": "Добавить свинину и обжарить до готовности"},
  {"step": 5, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовый рис со свининой и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(11, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Нарезать свинину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить лук и морковь на сковороде"},
  {"step": 4, "description": "Добавить свинину и обжарить до готовности"},
  {"step": 5, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 6, "description": "Смешать готовую гречку со свининой и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(12, '[
  {"step": 1, "description": "Залить овсянку водой или молоком в соотношении 1:2"},
  {"step": 2, "description": "Нарезать курицу кубиками, лук"},
  {"step": 3, "description": "Обжарить лук на сковороде"},
  {"step": 4, "description": "Добавить курицу и обжарить до готовности"},
  {"step": 5, "description": "Варить овсянку на медленном огне 10-15 минут"},
  {"step": 6, "description": "Смешать готовую овсянку с курицей и луком"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(13, '[
  {"step": 1, "description": "Залить овсянку водой или молоком в соотношении 1:2"},
  {"step": 2, "description": "Нарезать говядину кубиками, лук и морковь"},
  {"step": 3, "description": "Обжарить мясо до образования корочки"},
  {"step": 4, "description": "Добавить лук и морковь, тушить 10 минут"},
  {"step": 5, "description": "Варить овсянку на медленном огне 10-15 минут"},
  {"step": 6, "description": "Смешать готовую овсянку с мясом и овощами"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(14, '[
  {"step": 1, "description": "Залить овсянку водой или молоком в соотношении 1:2"},
  {"step": 2, "description": "Нарезать свинину кубиками, лук"},
  {"step": 3, "description": "Обжарить лук на сковороде"},
  {"step": 4, "description": "Добавить свинину и обжарить до готовности"},
  {"step": 5, "description": "Варить овсянку на медленном огне 10-15 минут"},
  {"step": 6, "description": "Смешать готовую овсянку со свининой и луком"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(15, '[
  {"step": 1, "description": "Нарезать картофель крупными кубиками"},
  {"step": 2, "description": "Нарезать говядину кубиками, лук и чеснок"},
  {"step": 3, "description": "Обжарить говядину до образования корочки"},
  {"step": 4, "description": "Смешать картофель, мясо, лук и чеснок с растительным маслом"},
  {"step": 5, "description": "Посолить, поперчить, добавить специи"},
  {"step": 6, "description": "Выложить на противень и запекать при 200°C 45-50 минут"},
  {"step": 7, "description": "Подавать горячим"}
]'),

(16, '[
  {"step": 1, "description": "Нарезать картофель крупными кубиками"},
  {"step": 2, "description": "Нарезать свинину кубиками, лук и чеснок"},
  {"step": 3, "description": "Смешать все ингредиенты с растительным маслом"},
  {"step": 4, "description": "Посолить, поперчить, добавить специи"},
  {"step": 5, "description": "Выложить на противень и запекать при 200°C 40-45 минут"},
  {"step": 6, "description": "Подавать горячим"}
]'),

(17, '[
  {"step": 1, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 2, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 3, "description": "Разбить яйца в миску, посолить и взбить вилкой"},
  {"step": 4, "description": "Вылить яйца на сковороду и жарить, помешивая, до готовности"},
  {"step": 5, "description": "Смешать готовые макароны с яичницей"},
  {"step": 6, "description": "Подавать горячим"}
]'),

(18, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Разбить яйца в миску, посолить и взбить вилкой"},
  {"step": 5, "description": "Вылить яйца на сковороду и жарить, помешивая, до готовности"},
  {"step": 6, "description": "Смешать готовую гречку с яичницей и подавать"}
]'),

(19, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Разбить яйца в миску, посолить и взбить вилкой"},
  {"step": 5, "description": "Вылить яйца на сковороду и жарить, помешивая, до готовности"},
  {"step": 6, "description": "Смешать готовый рис с яичницей и подавать"}
]'),

(20, '[
  {"step": 1, "description": "Отварить картофель в мундире или очищенный до готовности"},
  {"step": 2, "description": "Нарезать картофель кубиками, лук"},
  {"step": 3, "description": "Обжарить картофель с луком на сковороде"},
  {"step": 4, "description": "Разбить яйца в миску, посолить и взбить вилкой"},
  {"step": 5, "description": "Вылить яйца на картофель и жарить, помешивая, до готовности"},
  {"step": 6, "description": "Подавать горячим"}
]'),

(21, '[
  {"step": 1, "description": "Отварить яйца вкрутую (7-8 минут после закипания)"},
  {"step": 2, "description": "Охладить яйца в холодной воде и очистить"},
  {"step": 3, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 4, "description": "Нарезать яйца кубиками или дольками"},
  {"step": 5, "description": "Смешать макароны с яйцами"},
  {"step": 6, "description": "Подавать, можно добавить масло или сметану"}
]'),

(22, '[
  {"step": 1, "description": "Отварить яйца вкрутую (7-8 минут после закипания)"},
  {"step": 2, "description": "Охладить яйца в холодной воде и очистить"},
  {"step": 3, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 4, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 5, "description": "Нарезать яйца кубиками или дольками"},
  {"step": 6, "description": "Смешать готовую гречку с яйцами и подавать"}
]'),

(23, '[
  {"step": 1, "description": "Отварить яйца вкрутую (7-8 минут после закипания)"},
  {"step": 2, "description": "Охладить яйца в холодной воде и очистить"},
  {"step": 3, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 4, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 5, "description": "Нарезать яйца кубиками или дольками"},
  {"step": 6, "description": "Смешать готовый рис с яйцами и подавать"}
]'),

(24, '[
  {"step": 1, "description": "Отварить яйца вкрутую (7-8 минут после закипания)"},
  {"step": 2, "description": "Охладить яйца в холодной воде и очистить"},
  {"step": 3, "description": "Отварить картофель до готовности"},
  {"step": 4, "description": "Нарезать картофель кубиками"},
  {"step": 5, "description": "Нарезать яйца кубиками или дольками"},
  {"step": 6, "description": "Смешать картофель с яйцами, можно добавить масло или сметану"},
  {"step": 7, "description": "Подавать"}
]'),

(33, '[
  {"step": 1, "description": "Влить молоко в кастрюлю и довести до кипения"},
  {"step": 2, "description": "Добавить овсянку в кипящее молоко"},
  {"step": 3, "description": "Варить на медленном огне, помешивая, 10-15 минут"},
  {"step": 4, "description": "Добавить соль по вкусу"},
  {"step": 5, "description": "Подавать горячей, можно добавить масло"}
]'),

(34, '[
  {"step": 1, "description": "Нарезать лук мелко"},
  {"step": 2, "description": "Смешать фарш с луком, яйцом, солью и перцем"},
  {"step": 3, "description": "Хорошо вымесить фарш до однородной массы"},
  {"step": 4, "description": "Сформировать котлеты округлой формы"},
  {"step": 5, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 6, "description": "Обжарить котлеты с обеих сторон до золотистой корочки"},
  {"step": 7, "description": "Уменьшить огонь и довести до готовности под крышкой 10-15 минут"},
  {"step": 8, "description": "Подавать горячими"}
]'),

(35, '[
  {"step": 1, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 2, "description": "Нарезать сосиски кружочками, лук полукольцами"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить лук до прозрачности"},
  {"step": 5, "description": "Добавить сосиски и обжарить до золотистого цвета"},
  {"step": 6, "description": "Посолить и поперчить по вкусу"},
  {"step": 7, "description": "Смешать готовые макароны с сосисками и луком"},
  {"step": 8, "description": "Подавать горячим"}
]'),

(36, '[
  {"step": 1, "description": "Очистить и нарезать картофель кубиками"},
  {"step": 2, "description": "Нарезать сосиски кружочками, лук полукольцами"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить картофель до золотистого цвета"},
  {"step": 5, "description": "Добавить лук и обжарить еще 5 минут"},
  {"step": 6, "description": "Добавить сосиски и обжарить все вместе 5-7 минут"},
  {"step": 7, "description": "Посолить и поперчить по вкусу"},
  {"step": 8, "description": "Подавать горячим"}
]'),

(37, '[
  {"step": 1, "description": "Промыть гречку и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Варить гречку на медленном огне 20 минут"},
  {"step": 3, "description": "Нарезать сосиски кружочками, лук полукольцами"},
  {"step": 4, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 5, "description": "Обжарить лук до прозрачности"},
  {"step": 6, "description": "Добавить сосиски и обжарить до золотистого цвета"},
  {"step": 7, "description": "Смешать готовую гречку с сосисками и луком"},
  {"step": 8, "description": "Посолить и поперчить по вкусу"},
  {"step": 9, "description": "Подавать горячим"}
]'),

(38, '[
  {"step": 1, "description": "Промыть рис и залить водой в соотношении 1:2"},
  {"step": 2, "description": "Варить рис на медленном огне 20 минут"},
  {"step": 3, "description": "Нарезать сосиски кружочками, лук и морковь"},
  {"step": 4, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 5, "description": "Обжарить лук и морковь до мягкости"},
  {"step": 6, "description": "Добавить сосиски и обжарить до золотистого цвета"},
  {"step": 7, "description": "Смешать готовый рис с сосисками и овощами"},
  {"step": 8, "description": "Посолить и поперчить по вкусу"},
  {"step": 9, "description": "Подавать горячим"}
]'),

(39, '[
  {"step": 1, "description": "Нарезать лук мелко"},
  {"step": 2, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 3, "description": "Обжарить лук до золотистого цвета"},
  {"step": 4, "description": "Добавить фарш и обжарить, разминая вилкой, до готовности"},
  {"step": 5, "description": "Посолить и поперчить по вкусу"},
  {"step": 6, "description": "Отварить макароны согласно инструкции на упаковке"},
  {"step": 7, "description": "Смешать готовые макароны с фаршем"},
  {"step": 8, "description": "Подавать горячим"}
]'),

(40, '[
  {"step": 1, "description": "Очистить и нарезать картофель кубиками"},
  {"step": 2, "description": "Нарезать лук и морковь"},
  {"step": 3, "description": "Разогреть сковороду с растительным маслом"},
  {"step": 4, "description": "Обжарить лук и морковь до мягкости"},
  {"step": 5, "description": "Добавить фарш и обжарить, разминая вилкой, до готовности"},
  {"step": 6, "description": "Добавить картофель и обжарить все вместе 10-15 минут"},
  {"step": 7, "description": "Налить немного воды, накрыть крышкой и тушить до готовности картофеля"},
  {"step": 8, "description": "Посолить и поперчить по вкусу"},
  {"step": 9, "description": "Подавать горячим"}
]');

-- Ингредиенты для рецептов (с количеством)
-- Макароны с курицей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(1, 1, 500, 'г'),  -- Курица
(1, 4, 300, 'г'),  -- Макароны
(1, 8, 1, 'шт'),   -- Лук
(1, 19, 30, 'мл'), -- Масло растительное
(1, 17, 1, 'ч.л.'), -- Соль
(1, 18, 0.5, 'ч.л.'); -- Перец

-- Гречка с курицей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(2, 1, 500, 'г'),  -- Курица
(2, 5, 200, 'г'),  -- Гречка
(2, 8, 1, 'шт'),   -- Лук
(2, 9, 1, 'шт'),   -- Морковь
(2, 19, 30, 'мл'), -- Масло растительное
(2, 17, 1, 'ч.л.'), -- Соль
(2, 18, 0.5, 'ч.л.'); -- Перец

-- Рис с курицей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(3, 1, 500, 'г'),  -- Курица
(3, 6, 200, 'г'),  -- Рис
(3, 8, 1, 'шт'),   -- Лук
(3, 9, 1, 'шт'),   -- Морковь
(3, 19, 30, 'мл'), -- Масло растительное
(3, 17, 1, 'ч.л.'), -- Соль
(3, 18, 0.5, 'ч.л.'); -- Перец

-- Макароны по-флотски
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(4, 2, 400, 'г'),  -- Говядина (фарш)
(4, 4, 300, 'г'),  -- Макароны
(4, 8, 1, 'шт'),   -- Лук
(4, 19, 30, 'мл'), -- Масло растительное
(4, 17, 1, 'ч.л.'), -- Соль
(4, 18, 0.5, 'ч.л.'); -- Перец

-- Гречневая каша с мясом
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(5, 2, 500, 'г'),  -- Говядина
(5, 5, 200, 'г'),  -- Гречка
(5, 8, 1, 'шт'),   -- Лук
(5, 9, 1, 'шт'),   -- Морковь
(5, 19, 30, 'мл'), -- Масло растительное
(5, 17, 1, 'ч.л.'), -- Соль
(5, 18, 0.5, 'ч.л.'); -- Перец

-- Картофель с курицей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(6, 1, 500, 'г'),  -- Курица
(6, 11, 800, 'г'), -- Картофель
(6, 8, 1, 'шт'),   -- Лук
(6, 13, 3, 'зуб'), -- Чеснок
(6, 19, 40, 'мл'), -- Масло растительное
(6, 17, 1, 'ч.л.'), -- Соль
(6, 18, 0.5, 'ч.л.'); -- Перец

-- Макароны с говядиной
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(7, 2, 500, 'г'),  -- Говядина
(7, 4, 300, 'г'),  -- Макароны
(7, 8, 1, 'шт'),   -- Лук
(7, 9, 1, 'шт'),   -- Морковь
(7, 19, 30, 'мл'), -- Масло растительное
(7, 17, 1, 'ч.л.'), -- Соль
(7, 18, 0.5, 'ч.л.'); -- Перец

-- Макароны со свининой
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(8, 3, 500, 'г'),  -- Свинина
(8, 4, 300, 'г'),  -- Макароны
(8, 8, 1, 'шт'),   -- Лук
(8, 19, 30, 'мл'), -- Масло растительное
(8, 17, 1, 'ч.л.'), -- Соль
(8, 18, 0.5, 'ч.л.'); -- Перец

-- Рис с говядиной
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(9, 2, 500, 'г'),  -- Говядина
(9, 6, 200, 'г'),  -- Рис
(9, 8, 1, 'шт'),   -- Лук
(9, 9, 1, 'шт'),   -- Морковь
(9, 19, 30, 'мл'), -- Масло растительное
(9, 17, 1, 'ч.л.'), -- Соль
(9, 18, 0.5, 'ч.л.'); -- Перец

-- Рис со свининой
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(10, 3, 500, 'г'),  -- Свинина
(10, 6, 200, 'г'),  -- Рис
(10, 8, 1, 'шт'),   -- Лук
(10, 9, 1, 'шт'),   -- Морковь
(10, 19, 30, 'мл'), -- Масло растительное
(10, 17, 1, 'ч.л.'), -- Соль
(10, 18, 0.5, 'ч.л.'); -- Перец

-- Гречка со свининой
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(11, 3, 500, 'г'),  -- Свинина
(11, 5, 200, 'г'),  -- Гречка
(11, 8, 1, 'шт'),   -- Лук
(11, 9, 1, 'шт'),   -- Морковь
(11, 19, 30, 'мл'), -- Масло растительное
(11, 17, 1, 'ч.л.'), -- Соль
(11, 18, 0.5, 'ч.л.'); -- Перец

-- Овсянка с курицей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(12, 1, 500, 'г'),  -- Курица
(12, 7, 200, 'г'),  -- Овсянка
(12, 8, 1, 'шт'),   -- Лук
(12, 19, 30, 'мл'), -- Масло растительное
(12, 17, 1, 'ч.л.'), -- Соль
(12, 18, 0.5, 'ч.л.'); -- Перец

-- Овсянка с говядиной
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(13, 2, 500, 'г'),  -- Говядина
(13, 7, 200, 'г'),  -- Овсянка
(13, 8, 1, 'шт'),   -- Лук
(13, 9, 1, 'шт'),   -- Морковь
(13, 19, 30, 'мл'), -- Масло растительное
(13, 17, 1, 'ч.л.'), -- Соль
(13, 18, 0.5, 'ч.л.'); -- Перец

-- Овсянка со свининой
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(14, 3, 500, 'г'),  -- Свинина
(14, 7, 200, 'г'),  -- Овсянка
(14, 8, 1, 'шт'),   -- Лук
(14, 19, 30, 'мл'), -- Масло растительное
(14, 17, 1, 'ч.л.'), -- Соль
(14, 18, 0.5, 'ч.л.'); -- Перец

-- Картофель с говядиной
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(15, 2, 500, 'г'),  -- Говядина
(15, 11, 800, 'г'), -- Картофель
(15, 8, 1, 'шт'),   -- Лук
(15, 13, 3, 'зуб'), -- Чеснок
(15, 19, 40, 'мл'), -- Масло растительное
(15, 17, 1, 'ч.л.'), -- Соль
(15, 18, 0.5, 'ч.л.'); -- Перец

-- Картофель со свининой
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(16, 3, 500, 'г'),  -- Свинина
(16, 11, 800, 'г'), -- Картофель
(16, 8, 1, 'шт'),   -- Лук
(16, 13, 3, 'зуб'), -- Чеснок
(16, 19, 40, 'мл'), -- Масло растительное
(16, 17, 1, 'ч.л.'), -- Соль
(16, 18, 0.5, 'ч.л.'); -- Перец

-- Макароны с яичницей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(17, 21, 4, 'шт'),  -- Яйца
(17, 4, 300, 'г'),  -- Макароны
(17, 19, 30, 'мл'), -- Масло растительное
(17, 17, 1, 'ч.л.'), -- Соль
(17, 18, 0.5, 'ч.л.'); -- Перец

-- Гречка с яичницей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(18, 21, 4, 'шт'),  -- Яйца
(18, 5, 200, 'г'),  -- Гречка
(18, 19, 30, 'мл'), -- Масло растительное
(18, 17, 1, 'ч.л.'), -- Соль
(18, 18, 0.5, 'ч.л.'); -- Перец

-- Рис с яичницей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(19, 21, 4, 'шт'),  -- Яйца
(19, 6, 200, 'г'),  -- Рис
(19, 19, 30, 'мл'), -- Масло растительное
(19, 17, 1, 'ч.л.'), -- Соль
(19, 18, 0.5, 'ч.л.'); -- Перец

-- Картофель с яичницей
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(20, 21, 4, 'шт'),  -- Яйца
(20, 11, 600, 'г'), -- Картофель
(20, 8, 1, 'шт'),   -- Лук
(20, 19, 30, 'мл'), -- Масло растительное
(20, 17, 1, 'ч.л.'), -- Соль
(20, 18, 0.5, 'ч.л.'); -- Перец

-- Макароны с вареными яйцами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(21, 21, 4, 'шт'),  -- Яйца
(21, 4, 300, 'г'),  -- Макароны
(21, 17, 1, 'ч.л.'), -- Соль
(21, 20, 30, 'г'); -- Масло сливочное (опционально)

-- Гречка с вареными яйцами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(22, 21, 4, 'шт'),  -- Яйца
(22, 5, 200, 'г'),  -- Гречка
(22, 17, 1, 'ч.л.'), -- Соль
(22, 20, 30, 'г'); -- Масло сливочное (опционально)

-- Рис с вареными яйцами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(23, 21, 4, 'шт'),  -- Яйца
(23, 6, 200, 'г'),  -- Рис
(23, 17, 1, 'ч.л.'), -- Соль
(23, 20, 30, 'г'); -- Масло сливочное (опционально)

-- Картофель с вареными яйцами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(24, 21, 4, 'шт'),  -- Яйца
(24, 11, 600, 'г'), -- Картофель
(24, 17, 1, 'ч.л.'), -- Соль
(24, 20, 30, 'г'); -- Масло сливочное (опционально)

-- Макароны с овощами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(25, 4, 300, 'г'),  -- Макароны
(25, 10, 2, 'шт'),  -- Помидоры
(25, 8, 1, 'шт'),   -- Лук
(25, 9, 1, 'шт'),   -- Морковь
(25, 19, 30, 'мл'), -- Масло растительное
(25, 17, 1, 'ч.л.'), -- Соль
(25, 18, 0.5, 'ч.л.'); -- Перец

-- Гречка с овощами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(26, 5, 200, 'г'),  -- Гречка
(26, 9, 1, 'шт'),   -- Морковь
(26, 8, 1, 'шт'),   -- Лук
(26, 10, 2, 'шт'),  -- Помидоры
(26, 19, 30, 'мл'), -- Масло растительное
(26, 17, 1, 'ч.л.'), -- Соль
(26, 18, 0.5, 'ч.л.'); -- Перец

-- Рис с овощами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(27, 6, 200, 'г'),  -- Рис
(27, 9, 1, 'шт'),   -- Морковь
(27, 8, 1, 'шт'),   -- Лук
(27, 10, 2, 'шт'),  -- Помидоры
(27, 19, 30, 'мл'), -- Масло растительное
(27, 17, 1, 'ч.л.'), -- Соль
(27, 18, 0.5, 'ч.л.'); -- Перец

-- Картофель с овощами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(28, 11, 800, 'г'), -- Картофель
(28, 9, 1, 'шт'),   -- Морковь
(28, 8, 1, 'шт'),   -- Лук
(28, 10, 2, 'шт'),  -- Помидоры
(28, 19, 40, 'мл'), -- Масло растительное
(28, 17, 1, 'ч.л.'), -- Соль
(28, 18, 0.5, 'ч.л.'); -- Перец

-- Макароны с сыром
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(29, 4, 300, 'г'),  -- Макароны
(29, 15, 150, 'г'), -- Сыр
(29, 17, 1, 'ч.л.'); -- Соль

-- Гречка с грибами и луком
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(30, 5, 200, 'г'),  -- Гречка
(30, 8, 2, 'шт'),   -- Лук
(30, 19, 30, 'мл'), -- Масло растительное
(30, 17, 1, 'ч.л.'), -- Соль
(30, 18, 0.5, 'ч.л.'); -- Перец

-- Рис с курицей и овощами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(31, 6, 200, 'г'),  -- Рис
(31, 1, 500, 'г'),  -- Курица
(31, 9, 1, 'шт'),   -- Морковь
(31, 8, 1, 'шт'),   -- Лук
(31, 19, 30, 'мл'), -- Масло растительное
(31, 17, 1, 'ч.л.'), -- Соль
(31, 18, 0.5, 'ч.л.'); -- Перец

-- Картофель с курицей и овощами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(32, 11, 800, 'г'), -- Картофель
(32, 1, 500, 'г'),  -- Курица
(32, 9, 1, 'шт'),   -- Морковь
(32, 8, 1, 'шт'),   -- Лук
(32, 19, 40, 'мл'), -- Масло растительное
(32, 17, 1, 'ч.л.'), -- Соль
(32, 18, 0.5, 'ч.л.'); -- Перец

-- Овсяная каша с молоком
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(33, 7, 100, 'г'),  -- Овсянка
(33, 32, 400, 'мл'), -- Молоко
(33, 17, 0.5, 'ч.л.'); -- Соль

-- Котлеты из фарша
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(34, 40, 500, 'г'),  -- Фарш
(34, 8, 1, 'шт'),   -- Лук
(34, 21, 1, 'шт'),  -- Яйца
(34, 19, 40, 'мл'), -- Масло растительное
(34, 17, 1, 'ч.л.'), -- Соль
(34, 18, 0.5, 'ч.л.'); -- Перец

-- Макароны с сосисками
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(35, 4, 300, 'г'),  -- Макароны
(35, 41, 6, 'шт'),  -- Сосиски
(35, 8, 1, 'шт'),   -- Лук
(35, 19, 30, 'мл'), -- Масло растительное
(35, 17, 1, 'ч.л.'), -- Соль
(35, 18, 0.5, 'ч.л.'); -- Перец

-- Сосиски с картофелем
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(36, 41, 6, 'шт'),  -- Сосиски
(36, 11, 800, 'г'), -- Картофель
(36, 8, 1, 'шт'),   -- Лук
(36, 19, 40, 'мл'), -- Масло растительное
(36, 17, 1, 'ч.л.'), -- Соль
(36, 18, 0.5, 'ч.л.'); -- Перец

-- Сосиски с гречкой
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(37, 41, 6, 'шт'),  -- Сосиски
(37, 5, 200, 'г'),  -- Гречка
(37, 8, 1, 'шт'),   -- Лук
(37, 19, 30, 'мл'), -- Масло растительное
(37, 17, 1, 'ч.л.'), -- Соль
(37, 18, 0.5, 'ч.л.'); -- Перец

-- Сосиски с рисом
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(38, 41, 6, 'шт'),  -- Сосиски
(38, 6, 200, 'г'),  -- Рис
(38, 8, 1, 'шт'),   -- Лук
(38, 9, 1, 'шт'),   -- Морковь
(38, 19, 30, 'мл'), -- Масло растительное
(38, 17, 1, 'ч.л.'), -- Соль
(38, 18, 0.5, 'ч.л.'); -- Перец

-- Фарш с макаронами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(39, 40, 400, 'г'),  -- Фарш
(39, 4, 300, 'г'),  -- Макароны
(39, 8, 1, 'шт'),   -- Лук
(39, 19, 30, 'мл'), -- Масло растительное
(39, 17, 1, 'ч.л.'), -- Соль
(39, 18, 0.5, 'ч.л.'); -- Перец

-- Фарш с картофелем
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit) VALUES
(40, 40, 400, 'г'),  -- Фарш
(40, 11, 800, 'г'), -- Картофель
(40, 8, 1, 'шт'),   -- Лук
(40, 9, 1, 'шт'),   -- Морковь
(40, 19, 40, 'мл'), -- Масло растительное
(40, 17, 1, 'ч.л.'), -- Соль
(40, 18, 0.5, 'ч.л.'); -- Перец

-- ======================================================================
-- РАСШИРЕНИЕ БАЗЫ ДАННЫХ: новые ингредиенты, блюда и рецепты
-- ======================================================================

-- Исправление изображений: яичные блюда (разные фото для каждого блюда)
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1563379906659-ee70c0c47ba6?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1606756790138-261d2b21cd75?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с яичницей';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1551218372-a8789b81b253?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1544025162-d76538415e0f?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с вареными яйцами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с вареными яйцами';
-- Исправление изображений: овощные блюда
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400&h=520&fit=crop&q=80' WHERE name = 'Макароны с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80' WHERE name = 'Гречка с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1512058454905-6b841e7ad132?w=400&h=520&fit=crop&q=80' WHERE name = 'Рис с овощами';
UPDATE dishes SET image_url = 'https://images.unsplash.com/photo-1598514983-99b501817cc5?w=400&h=520&fit=crop&q=80' WHERE name = 'Картофель с овощами';

-- Установка meal_type для завтраков среди существующих блюд
UPDATE dishes SET meal_type = 'breakfast' WHERE name IN (
  'Макароны с яичницей', 'Гречка с яичницей', 'Рис с яичницей', 'Картофель с яичницей',
  'Макароны с вареными яйцами', 'Гречка с вареными яйцами', 'Рис с вареными яйцами',
  'Картофель с вареными яйцами', 'Овсяная каша с молоком');
-- Установка meal_type для обедов
UPDATE dishes SET meal_type = 'lunch' WHERE name IN ('Гречка с грибами и луком');

-- Новые ингредиенты
INSERT OR IGNORE INTO ingredients (name, category, image_url) VALUES
('Творог', 'dairy', '/images/ingredients/cottage-cheese.jpg'),
('Грибы', 'vegetables', '/images/ingredients/mushrooms.jpg'),
('Бекон', 'meat', '/images/ingredients/bacon.jpg'),
('Мука', 'cereals', '/images/ingredients/flour.jpg'),
('Соевый соус', 'spices', '/images/ingredients/soy-sauce.jpg'),
('Томатная паста', 'other', '/images/ingredients/tomato-paste.jpg'),
('Лимон', 'vegetables', '/images/ingredients/lemon.jpg'),
('Имбирь', 'spices', '/images/ingredients/ginger.jpg'),
('Пармезан', 'dairy', '/images/ingredients/parmesan.jpg'),
('Горох', 'cereals', '/images/ingredients/peas.jpg'),
('Лапша', 'cereals', '/images/ingredients/noodles.jpg');

-- ===========================
-- Новые блюда: завтраки
-- ===========================
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Блины', 'Тонкие русские блины на молоке — классика завтрака', 'https://images.unsplash.com/photo-1519620831337-5e58b8e06bdb?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 3.00, 1, 0, 'russian', 'breakfast'),
('Сырники', 'Творожные сырники с румяной корочкой и сметаной', 'https://images.unsplash.com/photo-1568051243858-533a607809a5?w=400&h=520&fit=crop&q=80', 30, 'easy', 2, 4.00, 1, 0, 'russian', 'breakfast'),
('Омлет с сыром', 'Пышный омлет с тертым сыром и зеленью', 'https://images.unsplash.com/photo-1553481187-be93c21490a9?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 3.00, 1, 0, 'russian', 'breakfast'),
('Творожная запеканка', 'Нежная запеканка из творога, запеченная в духовке', 'https://images.unsplash.com/photo-1571748982800-fa51086c2a08?w=400&h=520&fit=crop&q=80', 50, 'easy', 4, 4.00, 1, 0, 'russian', 'breakfast');

-- ===========================
-- Новые блюда: итальянская кухня
-- ===========================
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Паста Карбонара', 'Классическая итальянская паста с беконом, яйцом и пармезаном', 'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=400&h=520&fit=crop&q=80', 25, 'medium', 2, 12.00, 0, 0, 'italian', 'dinner'),
('Ризотто с грибами', 'Кремовое ризотто с шампиньонами и пармезаном', 'https://images.unsplash.com/photo-1476718406336-bb5a9690ee2a?w=400&h=520&fit=crop&q=80', 40, 'medium', 2, 11.00, 1, 0, 'italian', 'dinner'),
('Паста Болоньезе', 'Паста с густым мясным соусом болоньезе', 'https://images.unsplash.com/photo-1551183053-bf91798d047e?w=400&h=520&fit=crop&q=80', 55, 'medium', 4, 13.00, 0, 0, 'italian', 'dinner'),
('Лазанья', 'Слоёная лазанья с мясным фаршем и соусом бешамель', 'https://images.unsplash.com/photo-1574894709920-11b28be1e68e?w=400&h=520&fit=crop&q=80', 80, 'hard', 6, 15.00, 0, 0, 'italian', 'dinner');

-- ===========================
-- Новые блюда: азиатская кухня
-- ===========================
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Жареный рис с яйцом', 'Китайский жареный рис с яйцом и овощами', 'https://images.unsplash.com/photo-1603133872657-e48a571a0b69?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 5.00, 1, 0, 'asian', 'lunch'),
('Курица терияки', 'Сочная курица в соусе терияки с рисом', 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=520&fit=crop&q=80', 30, 'easy', 2, 10.00, 0, 0, 'asian', 'dinner'),
('Лапша удон с овощами', 'Густая удон-лапша с овощами в соевом соусе', 'https://images.unsplash.com/photo-1569050467447-ce54b3bbc37d?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 8.00, 1, 1, 'asian', 'lunch');

-- ===========================
-- Новые блюда: русские супы
-- ===========================
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Борщ', 'Наваристый борщ со свёклой, капустой и говядиной', 'https://images.unsplash.com/photo-1547592166-23ac786af7ea?w=400&h=520&fit=crop&q=80', 90, 'medium', 6, 10.00, 0, 0, 'russian', 'lunch'),
('Щи из капусты', 'Классические щи из свежей капусты с говядиной', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 75, 'easy', 6, 9.00, 0, 0, 'russian', 'lunch'),
('Солянка', 'Густая кисло-соленая солянка с мясом и огурцами', 'https://images.unsplash.com/photo-1547592180-85f173990888?w=400&h=520&fit=crop&q=80', 60, 'medium', 4, 12.00, 0, 0, 'russian', 'lunch'),
('Гороховый суп', 'Наваристый суп из гороха с беконом', 'https://images.unsplash.com/photo-1547592166-aa6e0bd2e3a0?w=400&h=520&fit=crop&q=80', 90, 'easy', 6, 8.00, 0, 0, 'russian', 'lunch'),
('Куриный суп', 'Лёгкий куриный суп с овощами и вермишелью', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 50, 'easy', 4, 8.00, 0, 0, 'russian', 'lunch');

-- ===========================
-- Новые блюда: русские основные блюда
-- ===========================
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Пельмени домашние', 'Домашние пельмени с мясным фаршем в сметане', 'https://images.unsplash.com/photo-1585032226651-759b792d2727?w=400&h=520&fit=crop&q=80', 120, 'hard', 6, 10.00, 0, 0, 'russian', 'dinner'),
('Говяжий гуляш', 'Тушеная говядина в томатном соусе с картофелем', 'https://images.unsplash.com/photo-1574484284823-73b5e4b5d5b8?w=400&h=520&fit=crop&q=80', 90, 'medium', 4, 14.00, 0, 0, 'russian', 'dinner'),
('Тефтели в соусе', 'Нежные тефтели из фарша в томатном соусе', 'https://images.unsplash.com/photo-1557116571-5780e2d41e34?w=400&h=520&fit=crop&q=80', 50, 'medium', 4, 10.00, 0, 0, 'russian', 'dinner'),
('Картофельная запеканка', 'Запеканка из картофеля с фаршем и сыром', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 65, 'easy', 4, 9.00, 0, 0, 'russian', 'dinner');

-- ===========================
-- Связи: новые блюда и ингредиенты
-- ===========================
-- Блины
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Блины' AND i.name IN ('Мука', 'Молоко', 'Яйца', 'Масло сливочное', 'Соль');

-- Сырники
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Сырники' AND i.name IN ('Творог', 'Яйца', 'Мука', 'Масло растительное', 'Соль');

-- Омлет с сыром
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Омлет с сыром' AND i.name IN ('Яйца', 'Молоко', 'Сыр', 'Масло сливочное', 'Соль');

-- Творожная запеканка
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Творожная запеканка' AND i.name IN ('Творог', 'Яйца', 'Мука', 'Молоко', 'Масло сливочное', 'Соль');

-- Паста Карбонара
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паста Карбонара' AND i.name IN ('Макароны', 'Бекон', 'Яйца', 'Пармезан', 'Соль', 'Перец черный');

-- Ризотто с грибами
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Ризотто с грибами' AND i.name IN ('Рис', 'Грибы', 'Лук', 'Пармезан', 'Масло сливочное', 'Масло растительное', 'Соль');

-- Паста Болоньезе
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паста Болоньезе' AND i.name IN ('Макароны', 'Фарш', 'Помидоры', 'Томатная паста', 'Лук', 'Морковь', 'Сельдерей', 'Масло растительное', 'Соль');

-- Лазанья
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Лазанья' AND i.name IN ('Мука', 'Фарш', 'Помидоры', 'Томатная паста', 'Молоко', 'Масло сливочное', 'Сыр', 'Лук', 'Соль');

-- Жареный рис с яйцом
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Жареный рис с яйцом' AND i.name IN ('Рис', 'Яйца', 'Лук зеленый', 'Соевый соус', 'Масло растительное', 'Морковь', 'Соль');

-- Курица терияки
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Курица терияки' AND i.name IN ('Курица', 'Соевый соус', 'Рис', 'Имбирь', 'Чеснок', 'Масло растительное');

-- Лапша удон с овощами
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Лапша удон с овощами' AND i.name IN ('Лапша', 'Морковь', 'Перец болгарский', 'Лук', 'Соевый соус', 'Масло растительное');

-- Борщ
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Борщ' AND i.name IN ('Говядина', 'Свекла', 'Капуста', 'Картофель', 'Морковь', 'Лук', 'Томатная паста', 'Масло растительное', 'Сметана', 'Соль');

-- Щи из капусты
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Щи из капусты' AND i.name IN ('Говядина', 'Капуста', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Сметана', 'Соль');

-- Солянка
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Солянка' AND i.name IN ('Говядина', 'Сосиски', 'Лук', 'Огурцы', 'Томатная паста', 'Лимон', 'Масло растительное', 'Соль');

-- Гороховый суп
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гороховый суп' AND i.name IN ('Горох', 'Бекон', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Соль');

-- Куриный суп
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Куриный суп' AND i.name IN ('Курица', 'Лапша', 'Картофель', 'Морковь', 'Лук', 'Соль', 'Перец черный');

-- Пельмени домашние
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Пельмени домашние' AND i.name IN ('Фарш', 'Мука', 'Яйца', 'Лук', 'Соль', 'Перец черный', 'Масло сливочное', 'Сметана');

-- Говяжий гуляш
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Говяжий гуляш' AND i.name IN ('Говядина', 'Томатная паста', 'Лук', 'Морковь', 'Картофель', 'Масло растительное', 'Соль', 'Перец черный');

-- Тефтели в соусе
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тефтели в соусе' AND i.name IN ('Фарш', 'Рис', 'Лук', 'Яйца', 'Томатная паста', 'Масло растительное', 'Соль', 'Перец черный');

-- Картофельная запеканка
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Картофельная запеканка' AND i.name IN ('Картофель', 'Фарш', 'Сыр', 'Лук', 'Молоко', 'Масло сливочное', 'Соль');

-- ===========================
-- Рецепты: новые блюда
-- ===========================
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Смешать муку, молоко, яйца и щепотку соли в жидкое тесто"},
  {"step": 2, "description": "Добавить растопленное сливочное масло, перемешать"},
  {"step": 3, "description": "Дать тесту постоять 15 минут"},
  {"step": 4, "description": "Раскалить сковороду и смазать маслом"},
  {"step": 5, "description": "Налить тонкий слой теста, обжарить 1-2 минуты с каждой стороны"},
  {"step": 6, "description": "Подавать с вареньем, сметаной или медом"}
]' FROM dishes d WHERE d.name = 'Блины';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отжать творог через марлю, чтобы убрать лишнюю влагу"},
  {"step": 2, "description": "Смешать творог с яйцом, мукой и солью до однородной массы"},
  {"step": 3, "description": "Слепить небольшие круглые лепёшки, обвалять в муке"},
  {"step": 4, "description": "Обжарить на растительном масле до золотистой корочки с обеих сторон"},
  {"step": 5, "description": "Подавать со сметаной или вареньем"}
]' FROM dishes d WHERE d.name = 'Сырники';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Взбить яйца с молоком и солью венчиком"},
  {"step": 2, "description": "Натереть сыр на терке"},
  {"step": 3, "description": "Растопить сливочное масло на сковороде на среднем огне"},
  {"step": 4, "description": "Вылить яичную смесь, накрыть крышкой"},
  {"step": 5, "description": "Через 3 минуты посыпать сыром, готовить ещё 2 минуты"},
  {"step": 6, "description": "Сложить омлет пополам и подавать горячим"}
]' FROM dishes d WHERE d.name = 'Омлет с сыром';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Смешать творог с яйцами, мукой, молоком и щепоткой соли"},
  {"step": 2, "description": "Смазать форму для запекания сливочным маслом"},
  {"step": 3, "description": "Выложить творожную смесь ровным слоем"},
  {"step": 4, "description": "Запекать при 180°C в течение 35-40 минут до золотистой корочки"},
  {"step": 5, "description": "Дать остыть 10 минут, нарезать порциями и подавать со сметаной"}
]' FROM dishes d WHERE d.name = 'Творожная запеканка';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать бекон полосками и обжарить на сухой сковороде"},
  {"step": 2, "description": "Отварить макароны аль денте, сохранить стакан воды от варки"},
  {"step": 3, "description": "Взбить яйца с тертым пармезаном и черным перцем"},
  {"step": 4, "description": "Снять сковороду с огня, добавить горячие макароны к бекону"},
  {"step": 5, "description": "Быстро влить яичную смесь, перемешивая — яйца должны загустеть, но не свернуться"},
  {"step": 6, "description": "При необходимости добавить немного воды от варки, подавать немедленно"}
]' FROM dishes d WHERE d.name = 'Паста Карбонара';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Обжарить лук в смеси масел до прозрачности"},
  {"step": 2, "description": "Добавить нарезанные грибы, жарить 5-7 минут"},
  {"step": 3, "description": "Добавить рис и обжарить 2 минуты, помешивая"},
  {"step": 4, "description": "Влить горячий бульон по одному половнику, постоянно помешивая"},
  {"step": 5, "description": "Повторять добавление бульона по мере впитывания (около 20 минут)"},
  {"step": 6, "description": "Снять с огня, добавить сливочное масло и тертый пармезан, перемешать"}
]' FROM dishes d WHERE d.name = 'Ризотто с грибами';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Обжарить фарш на растительном масле, разбивая комки"},
  {"step": 2, "description": "Добавить мелко нарезанные лук, морковь и сельдерей, тушить 10 минут"},
  {"step": 3, "description": "Добавить помидоры и томатную пасту, перемешать"},
  {"step": 4, "description": "Тушить соус на медленном огне 30-40 минут, помешивая"},
  {"step": 5, "description": "Отварить макароны аль денте"},
  {"step": 6, "description": "Смешать пасту с соусом, подавать с тертым сыром"}
]' FROM dishes d WHERE d.name = 'Паста Болоньезе';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Приготовить тесто для листов лазаньи из муки, яиц и соли, раскатать тонко"},
  {"step": 2, "description": "Обжарить фарш с луком, добавить томатную пасту и помидоры, тушить 20 минут"},
  {"step": 3, "description": "Приготовить соус бешамель: обжарить муку в масле, влить молоко, варить до густоты"},
  {"step": 4, "description": "Смазать форму, выложить слой теста, слой мясного соуса, слой бешамель"},
  {"step": 5, "description": "Повторить слои 3-4 раза, сверху посыпать тертым сыром"},
  {"step": 6, "description": "Запекать при 180°C 35-40 минут до золотистой корочки"}
]' FROM dishes d WHERE d.name = 'Лазанья';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отварить рис заранее и остудить (желательно вчерашний)"},
  {"step": 2, "description": "Разогреть масло на большой сковороде на сильном огне"},
  {"step": 3, "description": "Обжарить нарезанную морковь и зеленый лук 2 минуты"},
  {"step": 4, "description": "Добавить рис, жарить помешивая 3-4 минуты"},
  {"step": 5, "description": "Сдвинуть рис в сторону, разбить яйца и быстро перемешать"},
  {"step": 6, "description": "Добавить соевый соус, перемешать все вместе и подавать"}
]' FROM dishes d WHERE d.name = 'Жареный рис с яйцом';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать курицу крупными кусочками"},
  {"step": 2, "description": "Смешать соевый соус, тертый имбирь и чеснок для маринада"},
  {"step": 3, "description": "Замариновать курицу на 20 минут"},
  {"step": 4, "description": "Обжарить курицу на масле до золотистого цвета с каждой стороны"},
  {"step": 5, "description": "Влить оставшийся маринад, тушить 5-7 минут до загустения соуса"},
  {"step": 6, "description": "Подавать с отварным рисом, полив соусом терияки"}
]' FROM dishes d WHERE d.name = 'Курица терияки';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать морковь соломкой, болгарский перец полосками, лук полукольцами"},
  {"step": 2, "description": "Обжарить овощи на масле 3-4 минуты на сильном огне"},
  {"step": 3, "description": "Отварить лапшу по инструкции на упаковке"},
  {"step": 4, "description": "Добавить лапшу к овощам на сковороде"},
  {"step": 5, "description": "Влить соевый соус, перемешать и прогреть 2 минуты"},
  {"step": 6, "description": "Подавать горячей, по желанию добавить кунжут"}
]' FROM dishes d WHERE d.name = 'Лапша удон с овощами';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отварить говядину целым куском 1.5 часа, снимая пену"},
  {"step": 2, "description": "Натереть свеклу на крупной терке, обжарить с томатной пастой 10 минут"},
  {"step": 3, "description": "В бульон добавить нарезанный картофель, варить 15 минут"},
  {"step": 4, "description": "Добавить нашинкованную капусту, пассерованные лук и морковь"},
  {"step": 5, "description": "Добавить свеклу с томатом, варить еще 10 минут"},
  {"step": 6, "description": "Посолить, дать настояться 20 минут, подавать со сметаной"}
]' FROM dishes d WHERE d.name = 'Борщ';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Сварить говядину в 2.5 л воды, снять пену, варить 1 час"},
  {"step": 2, "description": "Обжарить лук и морковь до золотистого цвета"},
  {"step": 3, "description": "В бульон добавить нарезанный картофель, варить 10 минут"},
  {"step": 4, "description": "Добавить нашинкованную капусту и пассерованные овощи"},
  {"step": 5, "description": "Варить до мягкости капусты, посолить по вкусу"},
  {"step": 6, "description": "Подавать горячими со сметаной и черным хлебом"}
]' FROM dishes d WHERE d.name = 'Щи из капусты';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать говядину кубиками, сосиски кружочками"},
  {"step": 2, "description": "Обжарить говядину, добавить лук и жарить до золотистого"},
  {"step": 3, "description": "Добавить нарезанные соленые огурцы и томатную пасту"},
  {"step": 4, "description": "Залить горячим бульоном или водой, тушить 30 минут"},
  {"step": 5, "description": "Добавить сосиски, варить еще 10 минут"},
  {"step": 6, "description": "Подавать с долькой лимона и сметаной"}
]' FROM dishes d WHERE d.name = 'Солянка';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Замочить горох на ночь или на 4 часа"},
  {"step": 2, "description": "Нарезать бекон кубиками, обжарить до хруста"},
  {"step": 3, "description": "Обжарить лук и морковь до золотистого"},
  {"step": 4, "description": "В кастрюле отварить горох 40-50 минут до мягкости"},
  {"step": 5, "description": "Добавить картофель, бекон и пассерованные овощи, варить 15 минут"},
  {"step": 6, "description": "Посолить, можно пюрировать часть супа для густоты"}
]' FROM dishes d WHERE d.name = 'Гороховый суп';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Залить курицу холодной водой, довести до кипения, снять пену"},
  {"step": 2, "description": "Варить на медленном огне 30 минут"},
  {"step": 3, "description": "Добавить нарезанные картофель и морковь"},
  {"step": 4, "description": "Добавить целую луковицу, варить еще 15 минут"},
  {"step": 5, "description": "Добавить лапшу, варить до готовности 5-7 минут"},
  {"step": 6, "description": "Посолить, поперчить, убрать луковицу, подавать горячим"}
]' FROM dishes d WHERE d.name = 'Куриный суп';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Приготовить тесто: смешать муку, яйцо, воду и соль, вымесить"},
  {"step": 2, "description": "Для начинки: смешать фарш с мелко нарезанным луком, посолить и поперчить"},
  {"step": 3, "description": "Раскатать тесто тонко, вырезать кружки стаканом"},
  {"step": 4, "description": "Положить начинку на каждый кружок, слепить пельмени"},
  {"step": 5, "description": "Отварить пельмени в подсоленной воде 5-7 минут после всплытия"},
  {"step": 6, "description": "Подавать со сметаной, маслом или уксусом"}
]' FROM dishes d WHERE d.name = 'Пельмени домашние';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать говядину кубиками 3x3 см"},
  {"step": 2, "description": "Обжарить мясо на сильном огне до румяной корочки"},
  {"step": 3, "description": "Добавить нарезанный лук и морковь, обжаривать 5 минут"},
  {"step": 4, "description": "Добавить томатную пасту и горячую воду, тушить 40 минут"},
  {"step": 5, "description": "Добавить картофель, тушить ещё 20 минут до мягкости"},
  {"step": 6, "description": "Посолить, поперчить, подавать с хлебом"}
]' FROM dishes d WHERE d.name = 'Говяжий гуляш';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Смешать фарш с вареным рисом, яйцом, мелко нарезанным луком, посолить"},
  {"step": 2, "description": "Слепить небольшие шарики-тефтели"},
  {"step": 3, "description": "Обжарить тефтели на масле со всех сторон"},
  {"step": 4, "description": "Приготовить соус: томатная паста с водой, посолить"},
  {"step": 5, "description": "Залить тефтели соусом, тушить под крышкой 20 минут"},
  {"step": 6, "description": "Подавать с гречкой, рисом или картофелем"}
]' FROM dishes d WHERE d.name = 'Тефтели в соусе';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отварить картофель до полуготовности, нарезать кружками"},
  {"step": 2, "description": "Обжарить фарш с луком, посолить и поперчить"},
  {"step": 3, "description": "В форму выложить слой картофеля, затем слой фарша"},
  {"step": 4, "description": "Залить смесью молока и яйца"},
  {"step": 5, "description": "Посыпать тертым сыром"},
  {"step": 6, "description": "Запекать при 180°C 35-40 минут до золотистой корочки"}
]' FROM dishes d WHERE d.name = 'Картофельная запеканка';

-- ===========================
-- Ингредиенты рецептов: новые блюда
-- ===========================
-- Блины
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Мука' THEN 300 WHEN 'Молоко' THEN 500 WHEN 'Яйца' THEN 2
              WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Мука' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Яйца' THEN 'шт'
              WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Блины' AND i.name IN ('Мука', 'Молоко', 'Яйца', 'Масло сливочное', 'Соль');

-- Сырники
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Творог' THEN 500 WHEN 'Яйца' THEN 1 WHEN 'Мука' THEN 60
              WHEN 'Масло растительное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Творог' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Мука' THEN 'г'
              WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Сырники' AND i.name IN ('Творог', 'Яйца', 'Мука', 'Масло растительное', 'Соль');

-- Омлет с сыром
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 3 WHEN 'Молоко' THEN 60 WHEN 'Сыр' THEN 50
              WHEN 'Масло сливочное' THEN 15 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Молоко' THEN 'мл' WHEN 'Сыр' THEN 'г'
              WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Омлет с сыром' AND i.name IN ('Яйца', 'Молоко', 'Сыр', 'Масло сливочное', 'Соль');

-- Творожная запеканка
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Творог' THEN 600 WHEN 'Яйца' THEN 2 WHEN 'Мука' THEN 50
              WHEN 'Молоко' THEN 100 WHEN 'Масло сливочное' THEN 20 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Творог' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Мука' THEN 'г'
              WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Творожная запеканка' AND i.name IN ('Творог', 'Яйца', 'Мука', 'Молоко', 'Масло сливочное', 'Соль');

-- Паста Карбонара
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 200 WHEN 'Бекон' THEN 150 WHEN 'Яйца' THEN 2
              WHEN 'Пармезан' THEN 50 WHEN 'Соль' THEN 0.5 WHEN 'Перец черный' THEN 0.5 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Бекон' THEN 'г' WHEN 'Яйца' THEN 'шт'
              WHEN 'Пармезан' THEN 'г' WHEN 'Соль' THEN 'ч.л.' WHEN 'Перец черный' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Паста Карбонара' AND i.name IN ('Макароны', 'Бекон', 'Яйца', 'Пармезан', 'Соль', 'Перец черный');

-- Ризотто с грибами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 200 WHEN 'Грибы' THEN 300 WHEN 'Лук' THEN 1
              WHEN 'Пармезан' THEN 50 WHEN 'Масло сливочное' THEN 40 WHEN 'Масло растительное' THEN 30
              WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Грибы' THEN 'г' WHEN 'Лук' THEN 'шт'
              WHEN 'Пармезан' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Ризотто с грибами' AND i.name IN ('Рис', 'Грибы', 'Лук', 'Пармезан', 'Масло сливочное', 'Масло растительное', 'Соль');

-- Паста Болоньезе
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 400 WHEN 'Фарш' THEN 500 WHEN 'Помидоры' THEN 400
              WHEN 'Томатная паста' THEN 50 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1
              WHEN 'Сельдерей' THEN 2 WHEN 'Масло растительное' THEN 30 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Фарш' THEN 'г' WHEN 'Помидоры' THEN 'г'
              WHEN 'Томатная паста' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт'
              WHEN 'Сельдерей' THEN 'стебля' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Паста Болоньезе' AND i.name IN ('Макароны', 'Фарш', 'Помидоры', 'Томатная паста', 'Лук', 'Морковь', 'Сельдерей', 'Масло растительное', 'Соль');

-- Лазанья
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Мука' THEN 300 WHEN 'Фарш' THEN 600 WHEN 'Помидоры' THEN 400
              WHEN 'Томатная паста' THEN 70 WHEN 'Молоко' THEN 500 WHEN 'Масло сливочное' THEN 50
              WHEN 'Сыр' THEN 150 WHEN 'Лук' THEN 1 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Мука' THEN 'г' WHEN 'Фарш' THEN 'г' WHEN 'Помидоры' THEN 'г'
              WHEN 'Томатная паста' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г'
              WHEN 'Сыр' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Лазанья' AND i.name IN ('Мука', 'Фарш', 'Помидоры', 'Томатная паста', 'Молоко', 'Масло сливочное', 'Сыр', 'Лук', 'Соль');

-- Жареный рис с яйцом
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 200 WHEN 'Яйца' THEN 2 WHEN 'Лук зеленый' THEN 30
              WHEN 'Соевый соус' THEN 30 WHEN 'Масло растительное' THEN 30 WHEN 'Морковь' THEN 1
              WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Лук зеленый' THEN 'г'
              WHEN 'Соевый соус' THEN 'мл' WHEN 'Масло растительное' THEN 'мл' WHEN 'Морковь' THEN 'шт'
              WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Жареный рис с яйцом' AND i.name IN ('Рис', 'Яйца', 'Лук зеленый', 'Соевый соус', 'Масло растительное', 'Морковь', 'Соль');

-- Курица терияки
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Курица' THEN 500 WHEN 'Соевый соус' THEN 60 WHEN 'Рис' THEN 200
              WHEN 'Имбирь' THEN 10 WHEN 'Чеснок' THEN 2 WHEN 'Масло растительное' THEN 20 END,
  CASE i.name WHEN 'Курица' THEN 'г' WHEN 'Соевый соус' THEN 'мл' WHEN 'Рис' THEN 'г'
              WHEN 'Имбирь' THEN 'г' WHEN 'Чеснок' THEN 'зубчика' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Курица терияки' AND i.name IN ('Курица', 'Соевый соус', 'Рис', 'Имбирь', 'Чеснок', 'Масло растительное');

-- Лапша удон с овощами
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Лапша' THEN 200 WHEN 'Морковь' THEN 1 WHEN 'Перец болгарский' THEN 1
              WHEN 'Лук' THEN 1 WHEN 'Соевый соус' THEN 40 WHEN 'Масло растительное' THEN 20 END,
  CASE i.name WHEN 'Лапша' THEN 'г' WHEN 'Морковь' THEN 'шт' WHEN 'Перец болгарский' THEN 'шт'
              WHEN 'Лук' THEN 'шт' WHEN 'Соевый соус' THEN 'мл' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Лапша удон с овощами' AND i.name IN ('Лапша', 'Морковь', 'Перец болгарский', 'Лук', 'Соевый соус', 'Масло растительное');

-- Борщ
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 500 WHEN 'Свекла' THEN 2 WHEN 'Капуста' THEN 300
              WHEN 'Картофель' THEN 3 WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1
              WHEN 'Томатная паста' THEN 50 WHEN 'Масло растительное' THEN 30
              WHEN 'Сметана' THEN 100 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Свекла' THEN 'шт' WHEN 'Капуста' THEN 'г'
              WHEN 'Картофель' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт'
              WHEN 'Томатная паста' THEN 'г' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Сметана' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Борщ' AND i.name IN ('Говядина', 'Свекла', 'Капуста', 'Картофель', 'Морковь', 'Лук', 'Томатная паста', 'Масло растительное', 'Сметана', 'Соль');

-- Щи из капусты
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 400 WHEN 'Капуста' THEN 400 WHEN 'Картофель' THEN 3
              WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 30
              WHEN 'Сметана' THEN 80 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Капуста' THEN 'г' WHEN 'Картофель' THEN 'шт'
              WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Сметана' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Щи из капусты' AND i.name IN ('Говядина', 'Капуста', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Сметана', 'Соль');

-- Солянка
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 300 WHEN 'Сосиски' THEN 3 WHEN 'Лук' THEN 2
              WHEN 'Огурцы' THEN 3 WHEN 'Томатная паста' THEN 60 WHEN 'Лимон' THEN 0.5
              WHEN 'Масло растительное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Сосиски' THEN 'шт' WHEN 'Лук' THEN 'шт'
              WHEN 'Огурцы' THEN 'шт' WHEN 'Томатная паста' THEN 'г' WHEN 'Лимон' THEN 'шт'
              WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Солянка' AND i.name IN ('Говядина', 'Сосиски', 'Лук', 'Огурцы', 'Томатная паста', 'Лимон', 'Масло растительное', 'Соль');

-- Гороховый суп
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Горох' THEN 300 WHEN 'Бекон' THEN 200 WHEN 'Картофель' THEN 3
              WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 30
              WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Горох' THEN 'г' WHEN 'Бекон' THEN 'г' WHEN 'Картофель' THEN 'шт'
              WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гороховый суп' AND i.name IN ('Горох', 'Бекон', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Соль');

-- Куриный суп
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Курица' THEN 500 WHEN 'Лапша' THEN 100 WHEN 'Картофель' THEN 3
              WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Соль' THEN 1
              WHEN 'Перец черный' THEN 0.5 END,
  CASE i.name WHEN 'Курица' THEN 'г' WHEN 'Лапша' THEN 'г' WHEN 'Картофель' THEN 'шт'
              WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Соль' THEN 'ч.л.'
              WHEN 'Перец черный' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Куриный суп' AND i.name IN ('Курица', 'Лапша', 'Картофель', 'Морковь', 'Лук', 'Соль', 'Перец черный');

-- Пельмени домашние
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Фарш' THEN 500 WHEN 'Мука' THEN 400 WHEN 'Яйца' THEN 1
              WHEN 'Лук' THEN 1 WHEN 'Соль' THEN 1 WHEN 'Перец черный' THEN 0.5
              WHEN 'Масло сливочное' THEN 30 WHEN 'Сметана' THEN 100 END,
  CASE i.name WHEN 'Фарш' THEN 'г' WHEN 'Мука' THEN 'г' WHEN 'Яйца' THEN 'шт'
              WHEN 'Лук' THEN 'шт' WHEN 'Соль' THEN 'ч.л.' WHEN 'Перец черный' THEN 'ч.л.'
              WHEN 'Масло сливочное' THEN 'г' WHEN 'Сметана' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Пельмени домашние' AND i.name IN ('Фарш', 'Мука', 'Яйца', 'Лук', 'Соль', 'Перец черный', 'Масло сливочное', 'Сметана');

-- Говяжий гуляш
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 600 WHEN 'Томатная паста' THEN 60 WHEN 'Лук' THEN 2
              WHEN 'Морковь' THEN 1 WHEN 'Картофель' THEN 4 WHEN 'Масло растительное' THEN 40
              WHEN 'Соль' THEN 1 WHEN 'Перец черный' THEN 0.5 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Томатная паста' THEN 'г' WHEN 'Лук' THEN 'шт'
              WHEN 'Морковь' THEN 'шт' WHEN 'Картофель' THEN 'шт' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Соль' THEN 'ч.л.' WHEN 'Перец черный' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Говяжий гуляш' AND i.name IN ('Говядина', 'Томатная паста', 'Лук', 'Морковь', 'Картофель', 'Масло растительное', 'Соль', 'Перец черный');

-- Тефтели в соусе
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Фарш' THEN 500 WHEN 'Рис' THEN 80 WHEN 'Лук' THEN 1
              WHEN 'Яйца' THEN 1 WHEN 'Томатная паста' THEN 60 WHEN 'Масло растительное' THEN 30
              WHEN 'Соль' THEN 1 WHEN 'Перец черный' THEN 0.5 END,
  CASE i.name WHEN 'Фарш' THEN 'г' WHEN 'Рис' THEN 'г' WHEN 'Лук' THEN 'шт'
              WHEN 'Яйца' THEN 'шт' WHEN 'Томатная паста' THEN 'г' WHEN 'Масло растительное' THEN 'мл'
              WHEN 'Соль' THEN 'ч.л.' WHEN 'Перец черный' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Тефтели в соусе' AND i.name IN ('Фарш', 'Рис', 'Лук', 'Яйца', 'Томатная паста', 'Масло растительное', 'Соль', 'Перец черный');

-- Картофельная запеканка
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 800 WHEN 'Фарш' THEN 400 WHEN 'Сыр' THEN 100
              WHEN 'Лук' THEN 1 WHEN 'Молоко' THEN 150 WHEN 'Масло сливочное' THEN 30
              WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Фарш' THEN 'г' WHEN 'Сыр' THEN 'г'
              WHEN 'Лук' THEN 'шт' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г'
              WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картофельная запеканка' AND i.name IN ('Картофель', 'Фарш', 'Сыр', 'Лук', 'Молоко', 'Масло сливочное', 'Соль');

-- ===========================
-- Скрываем из селектора ингредиенты, добавленные для рецептов (не самые распространённые)
-- ===========================
UPDATE ingredients SET show_in_selector = 0 WHERE name IN (
  'Творог', 'Грибы', 'Бекон', 'Мука', 'Соевый соус', 'Томатная паста',
  'Лимон', 'Имбирь', 'Пармезан', 'Горох', 'Лапша'
);

-- ===========================
-- Скрытые ингредиенты только для AI-распознавания
-- ===========================
INSERT OR IGNORE INTO ingredients (name, category, image_url, show_in_selector) VALUES
-- Злаки и мучное
('Хлеб', 'cereals', NULL, 0),
('Батон', 'cereals', NULL, 0),
('Пшено', 'cereals', NULL, 0),
('Манная крупа', 'cereals', NULL, 0),
('Перловка', 'cereals', NULL, 0),
('Кускус', 'cereals', NULL, 0),
('Булгур', 'cereals', NULL, 0),
('Панировочные сухари', 'cereals', NULL, 0),
('Лаваш', 'cereals', NULL, 0),
('Фасоль', 'cereals', NULL, 0),
('Чечевица', 'cereals', NULL, 0),
-- Мясо/рыба
('Индейка', 'meat', NULL, 0),
('Семга', 'meat', NULL, 0),
('Треска', 'meat', NULL, 0),
('Минтай', 'meat', NULL, 0),
('Тунец', 'meat', NULL, 0),
('Колбаса', 'meat', NULL, 0),
('Ветчина', 'meat', NULL, 0),
-- Овощи/грибы
('Шампиньоны', 'vegetables', NULL, 0),
('Вешенки', 'vegetables', NULL, 0),
('Горошек', 'vegetables', NULL, 0),
('Кукуруза', 'vegetables', NULL, 0),
('Стручковая фасоль', 'vegetables', NULL, 0),
('Авокадо', 'vegetables', NULL, 0),
('Листья салата', 'vegetables', NULL, 0),
('Руккола', 'vegetables', NULL, 0),
('Лук-порей', 'vegetables', NULL, 0),
('Базилик', 'vegetables', NULL, 0),
('Кинза', 'vegetables', NULL, 0),
('Помидоры черри', 'vegetables', NULL, 0),
('Спаржа', 'vegetables', NULL, 0),
-- Молочные
('Кефир', 'dairy', NULL, 0),
('Сливки', 'dairy', NULL, 0),
('Йогурт', 'dairy', NULL, 0),
('Фета', 'dairy', NULL, 0),
('Моцарелла', 'dairy', NULL, 0),
('Творожный сыр', 'dairy', NULL, 0),
-- Специи и приправы
('Паприка', 'spices', NULL, 0),
('Куркума', 'spices', NULL, 0),
('Лавровый лист', 'spices', NULL, 0),
('Корица', 'spices', NULL, 0),
('Мускатный орех', 'spices', NULL, 0),
('Орегано', 'spices', NULL, 0),
('Перец чили', 'spices', NULL, 0),
('Горчица', 'spices', NULL, 0),
('Уксус', 'spices', NULL, 0),
-- Прочее
('Мёд', 'other', NULL, 0),
('Сахар', 'other', NULL, 0),
('Майонез', 'other', NULL, 0),
('Кетчуп', 'other', NULL, 0),
('Оливковое масло', 'other', NULL, 0),
('Оливки', 'other', NULL, 0),
('Грецкие орехи', 'other', NULL, 0),
('Арахис', 'other', NULL, 0),
('Изюм', 'other', NULL, 0),
('Курага', 'other', NULL, 0),
('Консервированная фасоль', 'other', NULL, 0),
('Консервированный горошек', 'other', NULL, 0);

-- ===========================
-- Блюда "пустого холодильника" — готовятся из минимума продуктов
-- ===========================
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type) VALUES
('Яичница', 'Простая яичница-глазунья — 5 минут и готово', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 5, 'easy', 1, 1.00, 1, 0, 'russian', 'breakfast'),
('Омлет', 'Классический омлет из яиц с молоком', 'https://images.unsplash.com/photo-1553481187-be93c21490a9?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 2.00, 1, 0, 'russian', 'breakfast'),
('Вареные яйца', 'Яйца всмятку или вкрутую — самый простой завтрак', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 1.00, 1, 0, 'russian', 'breakfast'),
('Яичница с помидорами', 'Яичница с обжаренными помидорами', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 2.00, 1, 0, 'russian', 'breakfast'),
('Яичница с колбасой', 'Яичница с поджаренной колбасой — классика завтрака', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 3.00, 0, 0, 'russian', 'breakfast'),
('Картофельное пюре', 'Нежное пюре из картофеля с молоком и маслом', 'https://images.unsplash.com/photo-1574484284823-73b5e4b5d5b8?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 2.00, 1, 0, 'russian', 'lunch'),
('Жареный картофель', 'Хрустящий жареный картофель с луком', 'https://images.unsplash.com/photo-1568600891046-c31b656a8a40?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 2.00, 1, 1, 'russian', 'lunch'),
('Суп картофельный', 'Простой картофельный суп с луком и морковью', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 35, 'easy', 4, 2.00, 1, 1, 'russian', 'lunch'),
('Рисовая каша на молоке', 'Нежная молочная каша из риса', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 25, 'easy', 2, 1.50, 1, 0, 'russian', 'breakfast'),
('Манная каша', 'Классическая манная каша на молоке', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 10, 'easy', 2, 1.00, 1, 0, 'russian', 'breakfast'),
('Пшённая каша', 'Пшённая каша на молоке с маслом', 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80', 25, 'easy', 4, 1.50, 1, 0, 'russian', 'breakfast'),
('Гречневая каша', 'Рассыпчатая гречка с маслом', 'https://images.unsplash.com/photo-1609950547341-b88d1b98e30f?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 1.50, 1, 0, 'russian', 'lunch'),
('Макароны с маслом', 'Отварные макароны с маслом и солью — выручает всегда', 'https://images.unsplash.com/photo-1618164435735-2cfee3e07c36?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 1.00, 1, 0, 'russian', 'lunch'),
('Тосты с сыром', 'Хлеб с расплавленным сыром — быстрый перекус', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 5, 'easy', 2, 2.00, 1, 0, 'other', 'breakfast'),
('Гренки яичные', 'Хлеб, обжаренный в яично-молочном кляре', 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80', 15, 'easy', 2, 2.00, 1, 0, 'other', 'breakfast'),
('Бутерброды с колбасой', 'Простые бутерброды — быстрый перекус за 5 минут', 'https://images.unsplash.com/photo-1565299507177-b0ac66763828?w=400&h=520&fit=crop&q=80', 5, 'easy', 2, 3.00, 0, 0, 'russian', 'breakfast'),
('Творог со сметаной', 'Свежий творог со сметаной — полезный завтрак без готовки', 'https://images.unsplash.com/photo-1571748982800-fa51086c2a08?w=400&h=520&fit=crop&q=80', 5, 'easy', 2, 3.00, 1, 0, 'russian', 'breakfast'),
('Суп с вермишелью', 'Лёгкий суп с вермишелью и овощами', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 30, 'easy', 4, 2.50, 1, 0, 'russian', 'lunch');

-- Связи: блюда пустого холодильника
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Яичница' AND i.name IN ('Яйца', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Омлет' AND i.name IN ('Яйца', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Вареные яйца' AND i.name IN ('Яйца', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Яичница с помидорами' AND i.name IN ('Яйца', 'Помидоры', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Яичница с колбасой' AND i.name IN ('Яйца', 'Колбаса', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Картофельное пюре' AND i.name IN ('Картофель', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Жареный картофель' AND i.name IN ('Картофель', 'Лук', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп картофельный' AND i.name IN ('Картофель', 'Лук', 'Морковь', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рисовая каша на молоке' AND i.name IN ('Рис', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Манная каша' AND i.name IN ('Манная крупа', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Пшённая каша' AND i.name IN ('Пшено', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гречневая каша' AND i.name IN ('Гречка', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Макароны с маслом' AND i.name IN ('Макароны', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тосты с сыром' AND i.name IN ('Хлеб', 'Сыр', 'Масло сливочное');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Гренки яичные' AND i.name IN ('Хлеб', 'Яйца', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Бутерброды с колбасой' AND i.name IN ('Хлеб', 'Колбаса', 'Масло сливочное');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Творог со сметаной' AND i.name IN ('Творог', 'Сметана');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп с вермишелью' AND i.name IN ('Макароны', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Соль');

-- Рецепты: блюда пустого холодильника
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Разогреть сковороду с растительным маслом на среднем огне"},
  {"step": 2, "description": "Аккуратно разбить яйца на сковороду, не перемешивая"},
  {"step": 3, "description": "Посолить по вкусу"},
  {"step": 4, "description": "Жарить 2-3 минуты до застывания белка, желток оставить жидким"},
  {"step": 5, "description": "Подавать горячей прямо со сковороды"}
]' FROM dishes d WHERE d.name = 'Яичница';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Взбить яйца с молоком и щепоткой соли"},
  {"step": 2, "description": "Растопить сливочное масло в сковороде на среднем огне"},
  {"step": 3, "description": "Вылить яичную смесь, накрыть крышкой"},
  {"step": 4, "description": "Готовить 3-4 минуты, не мешая, до застывания"},
  {"step": 5, "description": "Сложить пополам лопаткой и подавать"}
]' FROM dishes d WHERE d.name = 'Омлет';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Залить яйца холодной водой в кастрюле"},
  {"step": 2, "description": "Довести до кипения, варить 4 мин (всмятку) или 8 мин (вкрутую)"},
  {"step": 3, "description": "Переложить в холодную воду на 2 минуты — так легче чистить"},
  {"step": 4, "description": "Очистить и подавать с солью"}
]' FROM dishes d WHERE d.name = 'Вареные яйца';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать помидоры кружочками или дольками"},
  {"step": 2, "description": "Обжарить помидоры на масле 1-2 минуты"},
  {"step": 3, "description": "Разбить яйца поверх помидоров, посолить"},
  {"step": 4, "description": "Накрыть крышкой и готовить 2-3 минуты до готовности белка"},
  {"step": 5, "description": "Подавать горячей с зеленью по желанию"}
]' FROM dishes d WHERE d.name = 'Яичница с помидорами';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать колбасу кружочками или соломкой"},
  {"step": 2, "description": "Обжарить колбасу на масле 2-3 минуты до румяности"},
  {"step": 3, "description": "Разбить яйца поверх колбасы, посолить"},
  {"step": 4, "description": "Жарить 2-3 минуты до готовности белка"},
  {"step": 5, "description": "Подавать горячей"}
]' FROM dishes d WHERE d.name = 'Яичница с колбасой';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Очистить и нарезать картофель кубиками"},
  {"step": 2, "description": "Отварить в подсоленной воде до мягкости (15-20 мин)"},
  {"step": 3, "description": "Слить воду, добавить сливочное масло"},
  {"step": 4, "description": "Разогреть молоко и влить к картофелю"},
  {"step": 5, "description": "Тщательно размять толкушкой до однородной массы"},
  {"step": 6, "description": "Посолить по вкусу, подавать горячим"}
]' FROM dishes d WHERE d.name = 'Картофельное пюре';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Очистить и нарезать картофель ломтиками или брусочками"},
  {"step": 2, "description": "Нарезать лук полукольцами"},
  {"step": 3, "description": "Разогреть масло в сковороде на среднем огне"},
  {"step": 4, "description": "Выложить картофель и жарить 10 минут без перемешивания"},
  {"step": 5, "description": "Перевернуть, добавить лук, жарить ещё 10-15 минут"},
  {"step": 6, "description": "Посолить, подавать горячим"}
]' FROM dishes d WHERE d.name = 'Жареный картофель';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать картофель кубиками, лук и морковь"},
  {"step": 2, "description": "Обжарить лук и морковь в кастрюле на масле 5 минут"},
  {"step": 3, "description": "Залить 1.5 л воды, довести до кипения"},
  {"step": 4, "description": "Добавить картофель, варить 15-20 минут до мягкости"},
  {"step": 5, "description": "Посолить, поперчить по вкусу"},
  {"step": 6, "description": "Подавать горячим, по желанию добавить сметану"}
]' FROM dishes d WHERE d.name = 'Суп картофельный';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Промыть рис несколько раз"},
  {"step": 2, "description": "Довести молоко до кипения в кастрюле с толстым дном"},
  {"step": 3, "description": "Всыпать рис, убавить огонь"},
  {"step": 4, "description": "Варить, помешивая, 20-25 минут до мягкости"},
  {"step": 5, "description": "Добавить масло и соль по вкусу, подавать горячей"}
]' FROM dishes d WHERE d.name = 'Рисовая каша на молоке';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Довести молоко до кипения"},
  {"step": 2, "description": "Тонкой струйкой всыпать манную крупу, непрерывно мешая"},
  {"step": 3, "description": "Убавить огонь и варить 5-7 минут, постоянно помешивая"},
  {"step": 4, "description": "Добавить масло и щепотку соли"},
  {"step": 5, "description": "Подавать горячей, можно добавить варенье или мёд"}
]' FROM dishes d WHERE d.name = 'Манная каша';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Промыть пшено, залить молоком"},
  {"step": 2, "description": "Довести до кипения на среднем огне"},
  {"step": 3, "description": "Убавить огонь, варить 20 минут, помешивая"},
  {"step": 4, "description": "Добавить масло и соль, снять с огня"},
  {"step": 5, "description": "Накрыть крышкой и дать настояться 5 минут"}
]' FROM dishes d WHERE d.name = 'Пшённая каша';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Промыть гречку, залить кипятком 1:2"},
  {"step": 2, "description": "Поставить на средний огонь, довести до кипения"},
  {"step": 3, "description": "Убавить огонь, варить под крышкой 15-20 минут"},
  {"step": 4, "description": "Дождаться, пока вода полностью впитается"},
  {"step": 5, "description": "Добавить сливочное масло и соль, подавать"}
]' FROM dishes d WHERE d.name = 'Гречневая каша';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Отварить макароны в подсоленной воде по инструкции"},
  {"step": 2, "description": "Слить воду, оставив пару ложек"},
  {"step": 3, "description": "Добавить сливочное масло в горячие макароны"},
  {"step": 4, "description": "Перемешать до полного таяния масла"},
  {"step": 5, "description": "Посолить по вкусу, подавать горячими"}
]' FROM dishes d WHERE d.name = 'Макароны с маслом';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать хлеб ломтиками"},
  {"step": 2, "description": "Положить ломтик сыра на каждый кусок"},
  {"step": 3, "description": "Обжарить на сковороде с маслом до расплавления сыра"},
  {"step": 4, "description": "Или поставить в микроволновку на 30 секунд"},
  {"step": 5, "description": "Подавать горячими"}
]' FROM dishes d WHERE d.name = 'Тосты с сыром';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Взбить яйца с молоком и щепоткой соли"},
  {"step": 2, "description": "Обмакнуть ломтики хлеба в яичную смесь с двух сторон"},
  {"step": 3, "description": "Растопить масло на сковороде"},
  {"step": 4, "description": "Обжарить гренки по 2-3 минуты с каждой стороны до золотистого цвета"},
  {"step": 5, "description": "Подавать горячими, по желанию посыпать сахаром"}
]' FROM dishes d WHERE d.name = 'Гренки яичные';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать хлеб ломтиками"},
  {"step": 2, "description": "Намазать сливочное масло на каждый ломоть"},
  {"step": 3, "description": "Нарезать колбасу тонкими кружочками"},
  {"step": 4, "description": "Разложить колбасу на хлеб"},
  {"step": 5, "description": "Подавать с чаем или кофе"}
]' FROM dishes d WHERE d.name = 'Бутерброды с колбасой';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Выложить творог в миску или на тарелку"},
  {"step": 2, "description": "Добавить сметану по вкусу"},
  {"step": 3, "description": "По желанию добавить щепотку соли или ложку мёда"},
  {"step": 4, "description": "Подавать сразу — готово!"}
]' FROM dishes d WHERE d.name = 'Творог со сметаной';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[
  {"step": 1, "description": "Нарезать морковь и лук"},
  {"step": 2, "description": "Обжарить лук и морковь на масле 5 минут"},
  {"step": 3, "description": "Нарезать картофель кубиками, добавить в кастрюлю"},
  {"step": 4, "description": "Залить 1.5 л кипятка, варить 10 минут"},
  {"step": 5, "description": "Добавить вермишель, варить 5-7 минут до готовности"},
  {"step": 6, "description": "Посолить, подавать горячим"}
]' FROM dishes d WHERE d.name = 'Суп с вермишелью';

-- Ингредиенты для рецептов новых блюд
INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 2 WHEN 'Масло растительное' THEN 10 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Яичница' AND i.name IN ('Яйца', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 3 WHEN 'Молоко' THEN 60 WHEN 'Масло сливочное' THEN 15 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Омлет' AND i.name IN ('Яйца', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 2 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Вареные яйца' AND i.name IN ('Яйца', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 2 WHEN 'Помидоры' THEN 1 WHEN 'Масло растительное' THEN 10 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Помидоры' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Яичница с помидорами' AND i.name IN ('Яйца', 'Помидоры', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Яйца' THEN 2 WHEN 'Колбаса' THEN 100 WHEN 'Масло растительное' THEN 10 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Яйца' THEN 'шт' WHEN 'Колбаса' THEN 'г' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Яичница с колбасой' AND i.name IN ('Яйца', 'Колбаса', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 800 WHEN 'Молоко' THEN 150 WHEN 'Масло сливочное' THEN 50 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картофельное пюре' AND i.name IN ('Картофель', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 800 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 50 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Жареный картофель' AND i.name IN ('Картофель', 'Лук', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 600 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 20 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп картофельный' AND i.name IN ('Картофель', 'Лук', 'Морковь', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 100 WHEN 'Молоко' THEN 500 WHEN 'Масло сливочное' THEN 20 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рисовая каша на молоке' AND i.name IN ('Рис', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Манная крупа' THEN 50 WHEN 'Молоко' THEN 400 WHEN 'Масло сливочное' THEN 15 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Манная крупа' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Манная каша' AND i.name IN ('Манная крупа', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Пшено' THEN 100 WHEN 'Молоко' THEN 500 WHEN 'Масло сливочное' THEN 20 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Пшено' THEN 'г' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Пшённая каша' AND i.name IN ('Пшено', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Гречка' THEN 200 WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Гречка' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гречневая каша' AND i.name IN ('Гречка', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 200 WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Макароны с маслом' AND i.name IN ('Макароны', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Хлеб' THEN 4 WHEN 'Сыр' THEN 80 WHEN 'Масло сливочное' THEN 20 END,
  CASE i.name WHEN 'Хлеб' THEN 'ломтя' WHEN 'Сыр' THEN 'г' WHEN 'Масло сливочное' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Тосты с сыром' AND i.name IN ('Хлеб', 'Сыр', 'Масло сливочное');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Хлеб' THEN 4 WHEN 'Яйца' THEN 2 WHEN 'Молоко' THEN 80 WHEN 'Масло сливочное' THEN 20 WHEN 'Соль' THEN 0.25 END,
  CASE i.name WHEN 'Хлеб' THEN 'ломтя' WHEN 'Яйца' THEN 'шт' WHEN 'Молоко' THEN 'мл' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гренки яичные' AND i.name IN ('Хлеб', 'Яйца', 'Молоко', 'Масло сливочное', 'Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Хлеб' THEN 4 WHEN 'Колбаса' THEN 150 WHEN 'Масло сливочное' THEN 20 END,
  CASE i.name WHEN 'Хлеб' THEN 'ломтя' WHEN 'Колбаса' THEN 'г' WHEN 'Масло сливочное' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Бутерброды с колбасой' AND i.name IN ('Хлеб', 'Колбаса', 'Масло сливочное');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Творог' THEN 200 WHEN 'Сметана' THEN 50 END,
  CASE i.name WHEN 'Творог' THEN 'г' WHEN 'Сметана' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Творог со сметаной' AND i.name IN ('Творог', 'Сметана');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 200 WHEN 'Картофель' THEN 2 WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 20 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Картофель' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп с вермишелью' AND i.name IN ('Макароны', 'Картофель', 'Морковь', 'Лук', 'Масло растительное', 'Соль');


-- ============================================================
-- MEDITERRANEAN DISHES
-- ============================================================

-- New ingredient: Нут (chickpeas)
INSERT OR IGNORE INTO ingredients (name, category, image_url) VALUES ('Нут', 'vegetables', NULL);

-- 1. Греческий салат
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Греческий салат', 'Классический салат с помидорами, огурцами, оливками и сыром фета', 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800', 15, 'easy', 2, 300, 1, 0, 'mediterranean', 'lunch');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Греческий салат' AND i.name IN ('Помидоры', 'Огурцы', 'Перец болгарский', 'Сыр', 'Лук', 'Оливки', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[{"step":1,"description":"Помидоры и огурцы нарежьте крупными кубиками. Перец болгарский нарежьте полосками."},{"step":2,"description":"Лук нарежьте полукольцами и замочите в холодной воде на 5 минут."},{"step":3,"description":"Смешайте все овощи в миске. Добавьте оливки."},{"step":4,"description":"Сверху выложите кубики феты, полейте оливковым маслом и посолите по вкусу."}]'
FROM dishes d WHERE d.name = 'Греческий салат';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Помидоры' THEN 3 WHEN 'Огурцы' THEN 2 WHEN 'Перец болгарский' THEN 1
              WHEN 'Сыр' THEN 150 WHEN 'Лук' THEN 0.5 WHEN 'Оливки' THEN 80
              WHEN 'Масло растительное' THEN 30 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Помидоры' THEN 'шт' WHEN 'Огурцы' THEN 'шт' WHEN 'Перец болгарский' THEN 'шт'
              WHEN 'Сыр' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Оливки' THEN 'г'
              WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Греческий салат' AND i.name IN ('Помидоры', 'Огурцы', 'Перец болгарский', 'Сыр', 'Лук', 'Оливки', 'Масло растительное', 'Соль');

-- 2. Хумус
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Хумус', 'Нежная паста из нута с лимоном и чесноком', 'https://images.unsplash.com/photo-1577805947697-89e18249d767?w=800', 20, 'easy', 4, 200, 1, 1, 'mediterranean', 'snack');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Хумус' AND i.name IN ('Нут', 'Лимон', 'Чеснок', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[{"step":1,"description":"Нут замочите на ночь, затем отварите до мягкости (или используйте консервированный)."},{"step":2,"description":"Слейте воду, оставив немного. Пробейте нут в блендере до гладкости."},{"step":3,"description":"Добавьте сок лимона, чеснок, оливковое масло и соль. Взбейте до кремовой консистенции."},{"step":4,"description":"Подавайте с лавашем или овощами, сбрызнув маслом."}]'
FROM dishes d WHERE d.name = 'Хумус';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Нут' THEN 300 WHEN 'Лимон' THEN 1 WHEN 'Чеснок' THEN 2
              WHEN 'Масло растительное' THEN 40 WHEN 'Соль' THEN 0.5 END,
  CASE i.name WHEN 'Нут' THEN 'г' WHEN 'Лимон' THEN 'шт' WHEN 'Чеснок' THEN 'зубчика'
              WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Хумус' AND i.name IN ('Нут', 'Лимон', 'Чеснок', 'Масло растительное', 'Соль');

-- 3. Рататуй
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Рататуй', 'Тушёные овощи в средиземноморском стиле', 'https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?w=800', 50, 'medium', 4, 350, 1, 1, 'mediterranean', 'dinner');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рататуй' AND i.name IN ('Баклажаны', 'Помидоры', 'Перец болгарский', 'Лук', 'Чеснок', 'Масло растительное', 'Соль');

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[{"step":1,"description":"Баклажаны нарежьте кубиками, посолите и оставьте на 15 минут, затем промойте."},{"step":2,"description":"Обжарьте лук и чеснок на масле до прозрачности."},{"step":3,"description":"Добавьте перец, баклажаны и помидоры. Перемешайте."},{"step":4,"description":"Тушите на среднем огне 30 минут под крышкой, помешивая. Посолите по вкусу."}]'
FROM dishes d WHERE d.name = 'Рататуй';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Баклажаны' THEN 2 WHEN 'Помидоры' THEN 4 WHEN 'Перец болгарский' THEN 2
              WHEN 'Лук' THEN 1 WHEN 'Чеснок' THEN 3 WHEN 'Масло растительное' THEN 40 WHEN 'Соль' THEN 1 END,
  CASE i.name WHEN 'Баклажаны' THEN 'шт' WHEN 'Помидоры' THEN 'шт' WHEN 'Перец болгарский' THEN 'шт'
              WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зубчика' WHEN 'Масло растительное' THEN 'мл' WHEN 'Соль' THEN 'ч.л.' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рататуй' AND i.name IN ('Баклажаны', 'Помидоры', 'Перец болгарский', 'Лук', 'Чеснок', 'Масло растительное', 'Соль');

-- 4. Дзадзики (Tzatziki)
INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES ('Дзадзики', 'Греческий соус из йогурта с огурцом и чесноком', 'https://images.unsplash.com/photo-1571091655789-405eb7a3a3a8?w=800', 10, 'easy', 4, 150, 1, 0, 'mediterranean', 'snack');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Дзадзики' AND i.name IN ('Огурцы', 'Сметана', 'Чеснок', 'Лимон', 'Соль', 'Петрушка');

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT d.id, '[{"step":1,"description":"Огурец натрите на тёрке, отожмите лишнюю воду."},{"step":2,"description":"Смешайте сметану (или йогурт) с огурцом."},{"step":3,"description":"Добавьте мелко нарезанный чеснок, сок лимона и соль."},{"step":4,"description":"Украсьте зеленью. Подавайте охлаждённым с лавашем или как соус к мясу."}]'
FROM dishes d WHERE d.name = 'Дзадзики';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Огурцы' THEN 2 WHEN 'Сметана' THEN 200 WHEN 'Чеснок' THEN 2
              WHEN 'Лимон' THEN 0.5 WHEN 'Соль' THEN 0.5 WHEN 'Петрушка' THEN 20 END,
  CASE i.name WHEN 'Огурцы' THEN 'шт' WHEN 'Сметана' THEN 'г' WHEN 'Чеснок' THEN 'зубчика'
              WHEN 'Лимон' THEN 'шт' WHEN 'Соль' THEN 'ч.л.' WHEN 'Петрушка' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Дзадзики' AND i.name IN ('Огурцы', 'Сметана', 'Чеснок', 'Лимон', 'Соль', 'Петрушка');

-- ════════════════════════════════════════════════════════════════════════
-- Рецепты для блюд без рецептов (найдено DB-аудитом 2026-03-09)
-- ════════════════════════════════════════════════════════════════════════

-- Макароны с овощами
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить макароны до готовности по инструкции."},{"step":2,"description":"Нарезать лук, морковь кубиками, помидоры — дольками."},{"step":3,"description":"Разогреть масло на сковороде, обжарить лук до прозрачности."},{"step":4,"description":"Добавить морковь, тушить 5 минут."},{"step":5,"description":"Добавить помидоры, тушить ещё 5 минут, посолить и поперчить."},{"step":6,"description":"Смешать готовые макароны с овощами и подавать."}]'
FROM dishes WHERE name = 'Макароны с овощами';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 300 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Макароны с овощами' AND i.name IN ('Макароны','Помидоры','Лук','Морковь','Масло растительное');

-- Гречка с овощами
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Промыть гречку, залить водой 1:2, варить на медленном огне 20 минут."},{"step":2,"description":"Нарезать лук, морковь кубиками, помидоры — дольками."},{"step":3,"description":"Разогреть масло, обжарить лук до золотистого цвета."},{"step":4,"description":"Добавить морковь, тушить 5 минут, добавить помидоры ещё 5 минут."},{"step":5,"description":"Посолить, поперчить, смешать с готовой гречкой и подавать."}]'
FROM dishes WHERE name = 'Гречка с овощами';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Гречка' THEN 200 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Гречка' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гречка с овощами' AND i.name IN ('Гречка','Помидоры','Лук','Морковь','Масло растительное');

-- Рис с овощами
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Промыть рис, залить водой 1:2, варить на медленном огне 20 минут."},{"step":2,"description":"Нарезать лук, морковь кубиками, помидоры — дольками."},{"step":3,"description":"Разогреть масло, обжарить лук до золотистого цвета."},{"step":4,"description":"Добавить морковь, тушить 5 минут, добавить помидоры ещё 5 минут."},{"step":5,"description":"Посолить, поперчить, смешать с готовым рисом и подавать."}]'
FROM dishes WHERE name = 'Рис с овощами';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 200 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рис с овощами' AND i.name IN ('Рис','Помидоры','Лук','Морковь','Масло растительное');

-- Картофель с овощами
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать картофель крупными кубиками."},{"step":2,"description":"Нарезать лук, морковь кубиками, помидоры — дольками."},{"step":3,"description":"Смешать всё с растительным маслом, посолить и поперчить."},{"step":4,"description":"Выложить на противень и запекать при 200°C 35-40 минут, помешивая один раз."},{"step":5,"description":"Подавать горячим."}]'
FROM dishes WHERE name = 'Картофель с овощами';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 600 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Морковь' THEN 1 WHEN 'Масло растительное' THEN 40 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Морковь' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картофель с овощами' AND i.name IN ('Картофель','Помидоры','Лук','Морковь','Масло растительное');

-- Макароны с сыром
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить макароны до готовности по инструкции на упаковке."},{"step":2,"description":"Слить воду, оставив немного воды от варки."},{"step":3,"description":"Натереть сыр на крупной тёрке."},{"step":4,"description":"Смешать горячие макароны с половиной сыра — он расплавится."},{"step":5,"description":"Выложить в тарелку, посыпать оставшимся сыром и подавать."}]'
FROM dishes WHERE name = 'Макароны с сыром';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Макароны' THEN 300 WHEN 'Сыр' THEN 100 END,
  CASE i.name WHEN 'Макароны' THEN 'г' WHEN 'Сыр' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Макароны с сыром' AND i.name IN ('Макароны','Сыр');

-- Гречка с грибами и луком
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Промыть гречку, залить водой 1:2, варить на медленном огне 20 минут."},{"step":2,"description":"Нарезать лук полукольцами."},{"step":3,"description":"Разогреть масло на сковороде, обжарить лук до золотистого цвета."},{"step":4,"description":"Если есть грибы (шампиньоны, любые) — добавить, обжарить 5-7 минут."},{"step":5,"description":"Смешать готовую гречку с луком (и грибами), посолить, поперчить."},{"step":6,"description":"Подавать горячей."}]'
FROM dishes WHERE name = 'Гречка с грибами и луком';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Гречка' THEN 200 WHEN 'Лук' THEN 2 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Гречка' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Гречка с грибами и луком' AND i.name IN ('Гречка','Лук','Масло растительное');

-- Рис с курицей и овощами
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Промыть рис, залить водой 1:2, довести до кипения."},{"step":2,"description":"Нарезать курицу кубиками, лук и морковь — мелко."},{"step":3,"description":"Разогреть масло, обжарить лук и морковь до мягкости."},{"step":4,"description":"Добавить курицу, обжарить до золотистого цвета."},{"step":5,"description":"Смешать с рисом, добавить воды если нужно, варить на медленном огне 20 минут."},{"step":6,"description":"Посолить, поперчить. Подавать горячим."}]'
FROM dishes WHERE name = 'Рис с курицей и овощами';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Рис' THEN 200 WHEN 'Курица' THEN 400 WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Рис' THEN 'г' WHEN 'Курица' THEN 'г' WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рис с курицей и овощами' AND i.name IN ('Рис','Курица','Морковь','Лук','Масло растительное');

-- Картофель с курицей и овощами
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать картофель крупными кубиками, курицу — средними."},{"step":2,"description":"Нарезать лук и морковь."},{"step":3,"description":"Смешать всё с растительным маслом, посолить и поперчить."},{"step":4,"description":"Выложить на противень и запекать при 200°C 40-45 минут, перемешав один раз в середине."},{"step":5,"description":"Подавать горячим."}]'
FROM dishes WHERE name = 'Картофель с курицей и овощами';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 500 WHEN 'Курица' THEN 400 WHEN 'Морковь' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 40 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Курица' THEN 'г' WHEN 'Морковь' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картофель с курицей и овощами' AND i.name IN ('Картофель','Курица','Морковь','Лук','Масло растительное');

-- ============================================================
-- GEORGIAN DISHES (грузинская кухня)
-- ============================================================

INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES
('Хачапури по-аджарски', 'Открытая лепёшка с сыром и яйцом — символ грузинской кухни', 'https://images.unsplash.com/photo-1617196034183-421b4040ed20?w=400&h=520&fit=crop&q=80', 40, 'medium', 2, 7.00, 1, 0, 'georgian', 'breakfast'),
('Суп харчо', 'Наваристый острый суп из говядины с рисом и томатами', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 70, 'medium', 4, 12.00, 0, 0, 'georgian', 'lunch'),
('Сациви с курицей', 'Курица в густом ореховом соусе — традиционное грузинское блюдо', 'https://images.unsplash.com/photo-1598514983099-b501817cc55?w=400&h=520&fit=crop&q=80', 60, 'hard', 4, 14.00, 0, 0, 'georgian', 'dinner');

-- dish_ingredients for Georgian dishes
INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Хачапури по-аджарски' AND i.name IN ('Мука','Сыр','Яйца','Масло сливочное','Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Суп харчо' AND i.name IN ('Говядина','Рис','Помидоры','Лук','Чеснок','Томатная паста','Масло растительное');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Сациви с курицей' AND i.name IN ('Курица','Лук','Чеснок','Масло сливочное','Перец черный','Соль');

-- recipes for Georgian dishes
INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Приготовить тесто из муки, воды, яйца и щепотки соли — месить 10 минут, дать отдохнуть."},{"step":2,"description":"Натереть сыр (сулугуни или моцарелла) на крупной тёрке."},{"step":3,"description":"Раскатать тесто в форму лодочки, края загнуть бортиком."},{"step":4,"description":"Наполнить сырной массой, запечь при 220°C 15 минут."},{"step":5,"description":"Сделать углубление в центре и вбить яйцо. Запекать ещё 5-7 минут."},{"step":6,"description":"Добавить кусочек масла и подавать горячим."}]'
FROM dishes WHERE name = 'Хачапури по-аджарски';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать говядину кубиками 3×3 см, обжарить на масле до румяной корочки."},{"step":2,"description":"Добавить нарезанный лук, обжаривать ещё 5 минут."},{"step":3,"description":"Добавить томатную пасту и помидоры, тушить 5 минут."},{"step":4,"description":"Залить водой, довести до кипения, варить 40 минут."},{"step":5,"description":"Добавить промытый рис, варить 20 минут."},{"step":6,"description":"Добавить чеснок, зелень, соль, перец. Подавать горячим."}]'
FROM dishes WHERE name = 'Суп харчо';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Отварить курицу целиком до готовности (40-50 минут), сохранить бульон."},{"step":2,"description":"Обжарить лук на сливочном масле до мягкости."},{"step":3,"description":"Добавить к луку чеснок, специи (кориандр, уцхо-сунели или чёрный перец)."},{"step":4,"description":"Смешать с половиной бульона, тушить 10 минут."},{"step":5,"description":"Разобрать курицу на куски, залить соусом."},{"step":6,"description":"Тушить на медленном огне 15 минут. Подавать со свежей зеленью."}]'
FROM dishes WHERE name = 'Сациви с курицей';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Мука' THEN 300 WHEN 'Сыр' THEN 250 WHEN 'Яйца' THEN 2 WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 5 END,
  CASE i.name WHEN 'Мука' THEN 'г' WHEN 'Сыр' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Хачапури по-аджарски' AND i.name IN ('Мука','Сыр','Яйца','Масло сливочное','Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Говядина' THEN 500 WHEN 'Рис' THEN 100 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Чеснок' THEN 3 WHEN 'Томатная паста' THEN 60 WHEN 'Масло растительное' THEN 40 END,
  CASE i.name WHEN 'Говядина' THEN 'г' WHEN 'Рис' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зуб' WHEN 'Томатная паста' THEN 'г' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Суп харчо' AND i.name IN ('Говядина','Рис','Помидоры','Лук','Чеснок','Томатная паста','Масло растительное');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Курица' THEN 1000 WHEN 'Лук' THEN 2 WHEN 'Чеснок' THEN 4 WHEN 'Масло сливочное' THEN 50 WHEN 'Перец черный' THEN 5 WHEN 'Соль' THEN 10 END,
  CASE i.name WHEN 'Курица' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зуб' WHEN 'Масло сливочное' THEN 'г' WHEN 'Перец черный' THEN 'г' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Сациви с курицей' AND i.name IN ('Курица','Лук','Чеснок','Масло сливочное','Перец черный','Соль');

-- ============================================================
-- MEXICAN DISHES (мексиканская кухня)
-- ============================================================

INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES
('Кесадилья с курицей и сыром', 'Хрустящая лепёшка с сочной курицей и расплавленным сыром', 'https://images.unsplash.com/photo-1618040996337-56904b7850b9?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 9.00, 0, 0, 'mexican', 'lunch'),
('Тако с говяжьим фаршем', 'Мексиканские тако с острым мясом, томатами и сыром', 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80', 25, 'easy', 2, 10.00, 0, 0, 'mexican', 'lunch'),
('Мексиканский суп с фасолью', 'Сытный острый суп с фасолью, помидорами и паприкой', 'https://images.unsplash.com/photo-1547592166-6d74a4ccbe73?w=400&h=520&fit=crop&q=80', 45, 'easy', 4, 6.00, 1, 1, 'mexican', 'lunch');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Кесадилья с курицей и сыром' AND i.name IN ('Лаваш','Курица','Сыр','Перец болгарский','Лук','Масло растительное');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Тако с говяжьим фаршем' AND i.name IN ('Лаваш','Фарш','Помидоры','Лук','Сыр','Перец болгарский');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Мексиканский суп с фасолью' AND i.name IN ('Фасоль','Помидоры','Лук','Чеснок','Паприка','Томатная паста','Масло растительное');

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать курицу тонкими полосками, обжарить с маслом, солью и перцем 7-10 минут."},{"step":2,"description":"Нарезать лук и болгарский перец, обжарить 5 минут."},{"step":3,"description":"На сковороде разогреть лаваш."},{"step":4,"description":"Выложить на одну половину курицу, овощи и тёртый сыр."},{"step":5,"description":"Сложить лаваш пополам, обжаривать по 2-3 минуты с каждой стороны до золотистой корочки."},{"step":6,"description":"Нарезать треугольниками и подавать."}]'
FROM dishes WHERE name = 'Кесадилья с курицей и сыром';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Обжарить фарш с луком до готовности, добавить паприку и соль."},{"step":2,"description":"Добавить нарезанные помидоры и болгарский перец, тушить 5 минут."},{"step":3,"description":"Прогреть лаваш на сухой сковороде 1-2 минуты."},{"step":4,"description":"Выложить начинку на лаваш, добавить тёртый сыр."},{"step":5,"description":"Завернуть в форму тако и подавать немедленно."}]'
FROM dishes WHERE name = 'Тако с говяжьим фаршем';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замочить фасоль на ночь, отварить до мягкости 1-1.5 часа (или взять консервированную)."},{"step":2,"description":"Обжарить лук с чесноком на масле до золотистости."},{"step":3,"description":"Добавить томатную пасту, паприку, тушить 3 минуты."},{"step":4,"description":"Добавить помидоры, тушить ещё 5 минут."},{"step":5,"description":"Соединить с фасолью и 500 мл воды, варить 20 минут."},{"step":6,"description":"Посолить, поперчить. Подавать со сметаной или авокадо."}]'
FROM dishes WHERE name = 'Мексиканский суп с фасолью';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Лаваш' THEN 2 WHEN 'Курица' THEN 300 WHEN 'Сыр' THEN 150 WHEN 'Перец болгарский' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 20 END,
  CASE i.name WHEN 'Лаваш' THEN 'шт' WHEN 'Курица' THEN 'г' WHEN 'Сыр' THEN 'г' WHEN 'Перец болгарский' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Кесадилья с курицей и сыром' AND i.name IN ('Лаваш','Курица','Сыр','Перец болгарский','Лук','Масло растительное');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Лаваш' THEN 2 WHEN 'Фарш' THEN 300 WHEN 'Помидоры' THEN 2 WHEN 'Лук' THEN 1 WHEN 'Сыр' THEN 100 WHEN 'Перец болгарский' THEN 1 END,
  CASE i.name WHEN 'Лаваш' THEN 'шт' WHEN 'Фарш' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Сыр' THEN 'г' WHEN 'Перец болгарский' THEN 'шт' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Тако с говяжьим фаршем' AND i.name IN ('Лаваш','Фарш','Помидоры','Лук','Сыр','Перец болгарский');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Фасоль' THEN 300 WHEN 'Помидоры' THEN 3 WHEN 'Лук' THEN 1 WHEN 'Чеснок' THEN 3 WHEN 'Паприка' THEN 10 WHEN 'Томатная паста' THEN 60 WHEN 'Масло растительное' THEN 30 END,
  CASE i.name WHEN 'Фасоль' THEN 'г' WHEN 'Помидоры' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зуб' WHEN 'Паприка' THEN 'г' WHEN 'Томатная паста' THEN 'г' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Мексиканский суп с фасолью' AND i.name IN ('Фасоль','Помидоры','Лук','Чеснок','Паприка','Томатная паста','Масло растительное');

-- ============================================================
-- FRENCH DISHES (французская кухня)
-- ============================================================

INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES
('Луковый суп по-французски', 'Классический суп с карамелизированным луком, хлебом и сыром', 'https://images.unsplash.com/photo-1548943487-a2e4e43b4853?w=400&h=520&fit=crop&q=80', 55, 'medium', 2, 8.00, 1, 0, 'french', 'lunch'),
('Крок-месье', 'Горячий бутерброд с ветчиной, сыром и соусом бешамель', 'https://images.unsplash.com/photo-1528735602780-2552fd46c7af?w=400&h=520&fit=crop&q=80', 20, 'easy', 2, 7.00, 0, 0, 'french', 'breakfast'),
('Рататуй по-провансальски', 'Тушёные средиземноморские овощи с прованскими травами', 'https://images.unsplash.com/photo-1572453800999-e8d2d1589b7c?w=400&h=520&fit=crop&q=80', 60, 'medium', 4, 6.00, 1, 1, 'french', 'dinner');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Луковый суп по-французски' AND i.name IN ('Лук','Хлеб','Сыр','Масло сливочное','Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Крок-месье' AND i.name IN ('Хлеб','Сыр','Ветчина','Масло сливочное','Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Рататуй по-провансальски' AND i.name IN ('Баклажаны','Кабачки','Помидоры','Перец болгарский','Лук','Чеснок','Масло растительное');

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать весь лук тонкими полукольцами (около 1 кг)."},{"step":2,"description":"Растопить масло в кастрюле с толстым дном, добавить лук."},{"step":3,"description":"Карамелизировать лук на среднем огне 40 минут, помешивая каждые 5 минут — он должен стать золотисто-коричневым."},{"step":4,"description":"Добавить соль и немного воды, довести до кипения."},{"step":5,"description":"Разлить суп по жаропрочным тарелкам, сверху положить кусок хлеба и щедро посыпать тёртым сыром."},{"step":6,"description":"Запечь под грилем 3-5 минут до расплавления сыра."}]'
FROM dishes WHERE name = 'Луковый суп по-французски';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Намазать два куска хлеба размягчённым сливочным маслом с обеих сторон."},{"step":2,"description":"На один кусок выложить ломтики ветчины."},{"step":3,"description":"Сверху покрыть тёртым сыром (грюйер, эмменталь или обычный)."},{"step":4,"description":"Накрыть вторым куском хлеба."},{"step":5,"description":"Обжаривать на сковороде по 3 минуты с каждой стороны до золотистой корочки."},{"step":6,"description":"Подавать горячим, можно с яичницей-пашот сверху."}]'
FROM dishes WHERE name = 'Крок-месье';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать все овощи кружочками толщиной 3-5 мм."},{"step":2,"description":"Мелко нарезать лук и чеснок, обжарить на масле 5 минут."},{"step":3,"description":"Добавить томатную пасту (или нарезанные помидоры), тушить 5 минут."},{"step":4,"description":"Уложить кружочки баклажана, кабачка, помидора и перца слоями поверх соуса."},{"step":5,"description":"Полить маслом, посолить, добавить прованские травы (орегано, тимьян)."},{"step":6,"description":"Запекать при 180°C 45 минут. Подавать тёплым или комнатной температуры."}]'
FROM dishes WHERE name = 'Рататуй по-провансальски';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Лук' THEN 1000 WHEN 'Хлеб' THEN 4 WHEN 'Сыр' THEN 120 WHEN 'Масло сливочное' THEN 60 WHEN 'Соль' THEN 5 END,
  CASE i.name WHEN 'Лук' THEN 'г' WHEN 'Хлеб' THEN 'ломт' WHEN 'Сыр' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Луковый суп по-французски' AND i.name IN ('Лук','Хлеб','Сыр','Масло сливочное','Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Хлеб' THEN 4 WHEN 'Сыр' THEN 100 WHEN 'Ветчина' THEN 100 WHEN 'Масло сливочное' THEN 30 WHEN 'Соль' THEN 3 END,
  CASE i.name WHEN 'Хлеб' THEN 'ломт' WHEN 'Сыр' THEN 'г' WHEN 'Ветчина' THEN 'г' WHEN 'Масло сливочное' THEN 'г' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Крок-месье' AND i.name IN ('Хлеб','Сыр','Ветчина','Масло сливочное','Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Баклажаны' THEN 2 WHEN 'Кабачки' THEN 2 WHEN 'Помидоры' THEN 3 WHEN 'Перец болгарский' THEN 1 WHEN 'Лук' THEN 1 WHEN 'Чеснок' THEN 3 WHEN 'Масло растительное' THEN 50 END,
  CASE i.name WHEN 'Баклажаны' THEN 'шт' WHEN 'Кабачки' THEN 'шт' WHEN 'Помидоры' THEN 'шт' WHEN 'Перец болгарский' THEN 'шт' WHEN 'Лук' THEN 'шт' WHEN 'Чеснок' THEN 'зуб' WHEN 'Масло растительное' THEN 'мл' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Рататуй по-провансальски' AND i.name IN ('Баклажаны','Кабачки','Помидоры','Перец болгарский','Лук','Чеснок','Масло растительное');

-- ============================================================
-- EASTERN EUROPEAN DISHES (восточноевропейская кухня)
-- ============================================================

INSERT OR IGNORE INTO dishes (name, description, image_url, cooking_time, difficulty, servings, estimated_cost, is_vegetarian, is_vegan, cuisine_type, meal_type)
VALUES
('Вареники с картошкой', 'Украинские вареники с нежной картофельной начинкой и луком', 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=400&h=520&fit=crop&q=80', 60, 'medium', 4, 5.00, 1, 0, 'eastern_european', 'dinner'),
('Паприкаш с курицей', 'Венгерское блюдо из курицы в сметанном соусе с паприкой', 'https://images.unsplash.com/photo-1598514983099-b501817cc55?w=400&h=520&fit=crop&q=80', 45, 'medium', 4, 10.00, 0, 0, 'eastern_european', 'dinner'),
('Картошка с грибами по-польски', 'Жареный картофель с грибами и луком, заправленный сметаной', 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=520&fit=crop&q=80', 35, 'easy', 3, 5.00, 1, 0, 'eastern_european', 'dinner');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Вареники с картошкой' AND i.name IN ('Мука','Картофель','Лук','Масло сливочное','Яйца','Соль');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Паприкаш с курицей' AND i.name IN ('Курица','Лук','Паприка','Сметана','Масло растительное','Перец болгарский');

INSERT OR IGNORE INTO dish_ingredients (dish_id, ingredient_id)
SELECT d.id, i.id FROM dishes d, ingredients i
WHERE d.name = 'Картошка с грибами по-польски' AND i.name IN ('Картофель','Грибы','Лук','Масло растительное','Сметана');

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Замесить тесто из муки, яйца, воды и соли — эластичное, не липкое. Дать отдохнуть 20 минут."},{"step":2,"description":"Отварить картофель, сделать пюре."},{"step":3,"description":"Обжарить лук на масле до золотистости, половину добавить в пюре — это начинка."},{"step":4,"description":"Раскатать тесто тонко, нарезать кружочками. Выложить начинку, защипнуть края."},{"step":5,"description":"Варить в подсоленной воде 5-7 минут после всплытия."},{"step":6,"description":"Подавать с оставшимся жареным луком и сметаной."}]'
FROM dishes WHERE name = 'Вареники с картошкой';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать курицу на части, посолить и поперчить."},{"step":2,"description":"Обжарить курицу на масле до золотистой корочки, убрать."},{"step":3,"description":"В том же масле обжарить нарезанный лук и перец болгарский 5 минут."},{"step":4,"description":"Добавить паприку (щедро — 2-3 ст. ложки), жарить 1 минуту."},{"step":5,"description":"Вернуть курицу, добавить 200 мл воды, тушить на медленном огне 30 минут."},{"step":6,"description":"Снять с огня, вмешать сметану. Подавать с лапшой или картофелем."}]'
FROM dishes WHERE name = 'Паприкаш с курицей';

INSERT OR IGNORE INTO recipes (dish_id, instructions)
SELECT id, '[{"step":1,"description":"Нарезать картофель кубиками, грибы — крупно, лук — полукольцами."},{"step":2,"description":"Обжарить картофель на масле до золотистости 15 минут."},{"step":3,"description":"Добавить лук и грибы, жарить ещё 10 минут до мягкости."},{"step":4,"description":"Посолить, поперчить по вкусу."},{"step":5,"description":"Добавить сметану, перемешать и прогреть 2-3 минуты."},{"step":6,"description":"Подавать горячим, можно с зеленью."}]'
FROM dishes WHERE name = 'Картошка с грибами по-польски';

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Мука' THEN 400 WHEN 'Картофель' THEN 500 WHEN 'Лук' THEN 2 WHEN 'Масло сливочное' THEN 50 WHEN 'Яйца' THEN 1 WHEN 'Соль' THEN 10 END,
  CASE i.name WHEN 'Мука' THEN 'г' WHEN 'Картофель' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Масло сливочное' THEN 'г' WHEN 'Яйца' THEN 'шт' WHEN 'Соль' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Вареники с картошкой' AND i.name IN ('Мука','Картофель','Лук','Масло сливочное','Яйца','Соль');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Курица' THEN 800 WHEN 'Лук' THEN 2 WHEN 'Паприка' THEN 30 WHEN 'Сметана' THEN 200 WHEN 'Масло растительное' THEN 40 WHEN 'Перец болгарский' THEN 2 END,
  CASE i.name WHEN 'Курица' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Паприка' THEN 'г' WHEN 'Сметана' THEN 'г' WHEN 'Масло растительное' THEN 'мл' WHEN 'Перец болгарский' THEN 'шт' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Паприкаш с курицей' AND i.name IN ('Курица','Лук','Паприка','Сметана','Масло растительное','Перец болгарский');

INSERT OR IGNORE INTO recipe_ingredients (recipe_id, ingredient_id, quantity, unit)
SELECT r.id, i.id,
  CASE i.name WHEN 'Картофель' THEN 600 WHEN 'Грибы' THEN 300 WHEN 'Лук' THEN 1 WHEN 'Масло растительное' THEN 50 WHEN 'Сметана' THEN 100 END,
  CASE i.name WHEN 'Картофель' THEN 'г' WHEN 'Грибы' THEN 'г' WHEN 'Лук' THEN 'шт' WHEN 'Масло растительное' THEN 'мл' WHEN 'Сметана' THEN 'г' END
FROM recipes r JOIN dishes d ON r.dish_id = d.id, ingredients i
WHERE d.name = 'Картошка с грибами по-польски' AND i.name IN ('Картофель','Грибы','Лук','Масло растительное','Сметана');
