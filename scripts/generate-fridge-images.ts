/**
 * Генерация 10 тестовых изображений холодильника с продуктами.
 * Использует Playwright для рендеринга HTML и сохранения скриншотов.
 *
 * Запуск: npx tsx scripts/generate-fridge-images.ts
 * Результат: e2e/fixtures/fridge-*.jpg
 */

import { chromium } from '@playwright/test'
import * as fs from 'fs'
import * as path from 'path'
import { fileURLToPath } from 'url'

const __filename = fileURLToPath(import.meta.url)
const __dirname = path.dirname(__filename)

const FIXTURES_DIR = path.join(__dirname, '..', 'e2e', 'fixtures')

const fridges = [
  {
    filename: 'fridge-eggs-butter.jpg',
    title: 'Завтрак',
    emoji: '🥚',
    products: ['Яйца', 'Масло сливочное', 'Молоко', 'Соль'],
    color: '#FFF8E7',
    expectedDishes: ['Яичница', 'Омлет', 'Яйца всмятку'],
  },
  {
    filename: 'fridge-chicken-veggies.jpg',
    title: 'Курица с овощами',
    emoji: '🍗',
    products: ['Курица', 'Лук', 'Морковь', 'Чеснок', 'Масло растительное'],
    color: '#FFF3E0',
    expectedDishes: ['Курица с овощами', 'Куриный суп'],
  },
  {
    filename: 'fridge-beef-potato.jpg',
    title: 'Говядина',
    emoji: '🥩',
    products: ['Говядина', 'Картофель', 'Лук', 'Морковь', 'Томатная паста'],
    color: '#FCE4EC',
    expectedDishes: ['Гуляш', 'Борщ', 'Говядина тушёная'],
  },
  {
    filename: 'fridge-georgian.jpg',
    title: 'Грузинская кухня',
    emoji: '🫓',
    products: ['Мука', 'Сыр', 'Яйца', 'Масло сливочное'],
    color: '#F3E5F5',
    expectedDishes: ['Хачапури по-аджарски'],
  },
  {
    filename: 'fridge-mexican.jpg',
    title: 'Мексиканская кухня',
    emoji: '🌮',
    products: ['Лаваш', 'Курица', 'Сыр', 'Перец болгарский', 'Лук'],
    color: '#E8F5E9',
    expectedDishes: ['Кесадилья с курицей и сыром'],
  },
  {
    filename: 'fridge-french.jpg',
    title: 'Французская кухня',
    emoji: '🥖',
    products: ['Лук', 'Хлеб', 'Сыр', 'Масло сливочное'],
    color: '#E3F2FD',
    expectedDishes: ['Луковый суп по-французски'],
  },
  {
    filename: 'fridge-pasta.jpg',
    title: 'Итальянская паста',
    emoji: '🍝',
    products: ['Макароны', 'Томатная паста', 'Чеснок', 'Масло растительное', 'Пармезан'],
    color: '#FFF9C4',
    expectedDishes: ['Паста Болоньезе', 'Макароны с томатным соусом'],
  },
  {
    filename: 'fridge-asian-rice.jpg',
    title: 'Азиатский рис',
    emoji: '🍱',
    products: ['Рис', 'Яйца', 'Соевый соус', 'Лук', 'Масло растительное'],
    color: '#E0F7FA',
    expectedDishes: ['Жареный рис с яйцом'],
  },
  {
    filename: 'fridge-buckwheat.jpg',
    title: 'Гречка',
    emoji: '🌾',
    products: ['Гречка', 'Яйца', 'Лук', 'Масло растительное'],
    color: '#F1F8E9',
    expectedDishes: ['Гречка с яичницей', 'Гречневая каша'],
  },
  {
    filename: 'fridge-cottage-cheese.jpg',
    title: 'Творог',
    emoji: '🧀',
    products: ['Творог', 'Яйца', 'Молоко', 'Мука', 'Сметана'],
    color: '#FFF3E0',
    expectedDishes: ['Сырники', 'Творожная запеканка'],
  },
]

function generateFridgeHTML(fridge: (typeof fridges)[0]): string {
  const productsHTML = fridge.products
    .map(
      (p, i) => `
      <div class="product" style="animation-delay: ${i * 0.1}s">
        <div class="product-icon">${getProductEmoji(p)}</div>
        <div class="product-name">${p}</div>
      </div>
    `
    )
    .join('')

  return `<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    width: 400px; height: 520px;
    font-family: 'Segoe UI', Arial, sans-serif;
    background: linear-gradient(135deg, ${fridge.color} 0%, #ffffff 100%);
    overflow: hidden;
  }
  .fridge {
    width: 400px; height: 520px;
    background: linear-gradient(180deg, #e8e8e8 0%, #d0d0d0 100%);
    border-radius: 20px;
    padding: 16px;
    display: flex;
    flex-direction: column;
    box-shadow: 0 8px 32px rgba(0,0,0,0.15);
  }
  .fridge-top {
    background: linear-gradient(135deg, #b0c4de 0%, #87a9c7 100%);
    border-radius: 12px 12px 4px 4px;
    padding: 12px;
    margin-bottom: 8px;
    text-align: center;
    border: 2px solid #8099b0;
  }
  .fridge-bottom {
    background: linear-gradient(135deg, #c8dae8 0%, #a8c4d8 100%);
    border-radius: 4px 4px 12px 12px;
    flex: 1;
    padding: 12px;
    border: 2px solid #8099b0;
    display: flex;
    flex-direction: column;
  }
  .shelf {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 8px;
    margin-bottom: 8px;
  }
  .product {
    background: white;
    border-radius: 8px;
    padding: 8px 4px;
    text-align: center;
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 4px;
  }
  .product-icon { font-size: 22px; line-height: 1; }
  .product-name {
    font-size: 9px;
    font-weight: 600;
    color: #333;
    line-height: 1.2;
    text-align: center;
  }
  .fridge-title {
    font-size: 11px;
    font-weight: 700;
    color: #1a3a5c;
    text-transform: uppercase;
    letter-spacing: 1px;
    margin-bottom: 4px;
  }
  .fridge-emoji {
    font-size: 20px;
    display: block;
    margin-bottom: 2px;
  }
  .shelf-label {
    font-size: 8px;
    color: #666;
    text-align: right;
    margin-bottom: 2px;
    font-weight: 600;
    letter-spacing: 0.5px;
    text-transform: uppercase;
  }
  .handle {
    width: 30px; height: 80px;
    background: linear-gradient(90deg, #aaa, #ccc, #aaa);
    border-radius: 6px;
    position: absolute;
    right: 20px;
    top: 50%;
    transform: translateY(-50%);
    box-shadow: 2px 0 6px rgba(0,0,0,0.2);
  }
  .outer {
    position: relative;
    width: 400px; height: 520px;
    background: linear-gradient(135deg, #d8d8d8 0%, #c0c0c0 100%);
    border-radius: 24px;
    padding: 16px 40px 16px 16px;
    box-shadow: inset 0 0 20px rgba(0,0,0,0.1), 0 10px 40px rgba(0,0,0,0.2);
  }
</style>
</head>
<body>
<div class="outer">
  <div class="handle"></div>
  <div class="fridge">
    <div class="fridge-top">
      <span class="fridge-emoji">${fridge.emoji}</span>
      <div class="fridge-title">${fridge.title}</div>
    </div>
    <div class="fridge-bottom">
      <div class="shelf-label">Полка 1</div>
      <div class="shelf">
        ${productsHTML.split('</div>\n      ').slice(0, 3).join('</div>\n      ')}
      </div>
      ${fridge.products.length > 3 ? `
      <div class="shelf-label">Полка 2</div>
      <div class="shelf">
        ${productsHTML.split('</div>\n      ').slice(3).join('</div>\n      ')}
      </div>
      ` : ''}
    </div>
  </div>
</div>
</body>
</html>`
}

function getProductEmoji(name: string): string {
  const map: Record<string, string> = {
    'Яйца': '🥚', 'Масло сливочное': '🧈', 'Молоко': '🥛', 'Соль': '🧂',
    'Курица': '🍗', 'Лук': '🧅', 'Морковь': '🥕', 'Чеснок': '🧄',
    'Масло растительное': '🫙', 'Говядина': '🥩', 'Картофель': '🥔',
    'Помидоры': '🍅', 'Томатная паста': '🥫', 'Мука': '🌾', 'Сыр': '🧀',
    'Лаваш': '🫓', 'Перец болгарский': '🫑', 'Макароны': '🍝',
    'Пармезан': '🧀', 'Рис': '🍚', 'Соевый соус': '🫙', 'Гречка': '🌾',
    'Творог': '🫙', 'Сметана': '🥛', 'Хлеб': '🍞',
    'Фасоль': '🫘', 'Фарш': '🥩', 'Паприка': '🌶️',
    'Чечевица': '🫘', 'Шпинат': '🥬', 'Авокадо': '🥑',
    'Кинза': '🌿', 'Петрушка': '🌿', 'Грибы': '🍄',
    'Кабачки': '🥒', 'Баклажаны': '🍆',
  }
  return map[name] || '🥫'
}

async function main() {
  if (!fs.existsSync(FIXTURES_DIR)) {
    fs.mkdirSync(FIXTURES_DIR, { recursive: true })
  }

  const browser = await chromium.launch()
  const page = await browser.newPage()
  await page.setViewportSize({ width: 400, height: 520 })

  console.log(`Генерация ${fridges.length} изображений холодильников...`)

  for (const fridge of fridges) {
    const html = generateFridgeHTML(fridge)
    await page.setContent(html, { waitUntil: 'networkidle' })
    await page.waitForTimeout(300)

    const outputPath = path.join(FIXTURES_DIR, fridge.filename)
    await page.screenshot({
      path: outputPath,
      type: 'jpeg',
      quality: 90,
      clip: { x: 0, y: 0, width: 400, height: 520 },
    })
    console.log(`  ✓ ${fridge.filename} — ${fridge.products.join(', ')}`)
  }

  await browser.close()

  // Сохраняем метаданные для тестов
  const metaPath = path.join(FIXTURES_DIR, 'fridge-metadata.json')
  fs.writeFileSync(
    metaPath,
    JSON.stringify(
      fridges.map(({ filename, products, expectedDishes, title }) => ({
        filename, products, expectedDishes, title,
      })),
      null,
      2
    )
  )
  console.log(`\n✅ Готово! ${fridges.length} изображений в e2e/fixtures/`)
  console.log(`📋 Метаданные: ${metaPath}`)
}

main().catch((e) => { console.error(e); process.exit(1) })
