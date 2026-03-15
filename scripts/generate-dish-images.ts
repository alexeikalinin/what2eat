#!/usr/bin/env npx tsx
/**
 * Генерирует изображения блюд через DALL-E 3 и загружает в Supabase Storage.
 *
 * Использование:
 *   OPENAI_API_KEY=sk-xxx SUPABASE_SERVICE_KEY=eyJ... npx tsx scripts/generate-dish-images.ts
 *
 * Ключи:
 *   OPENAI_API_KEY       — platform.openai.com/api-keys
 *   SUPABASE_SERVICE_KEY — Supabase Dashboard → Settings → API → service_role
 */

import fs from 'fs'
import path from 'path'

// Читаем .env вручную если ключи не переданы через окружение
function loadEnv() {
  const envPath = path.join(path.dirname(new URL(import.meta.url).pathname), '..', '.env')
  if (!fs.existsSync(envPath)) return
  const lines = fs.readFileSync(envPath, 'utf-8').split('\n')
  for (const line of lines) {
    const match = line.match(/^([A-Z_]+)=(.+)$/)
    if (match && !process.env[match[1]]) {
      process.env[match[1]] = match[2].trim()
    }
  }
}
loadEnv()

const SUPABASE_URL = 'https://zfiyhhsknwpilamljhqu.supabase.co'
const BUCKET = 'dish-images'

const OPENAI_KEY = process.env.OPENAI_API_KEY || process.env.VITE_OPENAI_API_KEY
const SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY

if (!OPENAI_KEY) {
  console.error('❌ Нужен OPENAI_API_KEY (или VITE_OPENAI_API_KEY в .env)')
  process.exit(1)
}
if (!SERVICE_KEY) {
  console.error('❌ Нужен SUPABASE_SERVICE_KEY в .env')
  process.exit(1)
}

// Промпты по имени блюда — точные описания для DALL-E 3
const DISH_PROMPTS: Record<string, string> = {
  // Уже сгенерированы (раунд 1)
  'Хачапури по-аджарски': 'Georgian Adjarian khachapuri, boat-shaped bread filled with melted cheese and egg yolk in the center, professional food photography, top view, wooden table, warm lighting',
  'Чкмерули': 'Chkmeruli Georgian chicken in creamy garlic milk sauce, cast iron pan, professional food photography, top-down view, rustic wooden background',
  'Дзадзики': 'Greek tzatziki sauce in white bowl, cucumber slices, fresh dill, drizzle of olive oil, professional food photography, Mediterranean style',
  'Долма': 'Dolma stuffed grape leaves with rice and meat filling, arranged on a plate with yogurt sauce, professional food photography, overhead shot',
  'Бёф Бургиньон': 'French Boeuf Bourguignon beef stew with red wine, mushrooms, pearl onions and carrots in a Dutch oven, professional food photography, warm rustic style',
  'Говяжий гуляш': 'Hungarian beef goulash with paprika sauce, tender beef chunks, served with egg noodles or bread, professional food photography, overhead view',
  'Польский бигос': 'Polish bigos hunter stew with sauerkraut, mixed meats, mushrooms and prunes in a pot, professional food photography, rustic style',
  // Раунд 2 — специфичные блюда с неподходящими категорийными фото
  'Куриный рамен': 'Japanese ramen noodle soup with chicken, soft-boiled egg halves, nori sheet, bamboo shoots, green onions, rich golden broth, dark bowl, professional food photography, overhead',
  'Суп Том Ям': 'Thai Tom Yam Kung soup with shrimp, coconut milk, lemongrass, lime leaves, mushrooms, red chili, clear broth, professional food photography, overhead shot',
  'Луковый суп по-французски': 'French onion soup with caramelized onions, thick layer of melted Gruyere cheese on toasted bread, white ceramic bowl, rustic French bistro style',
  'Суп Буйабес': 'French Bouillabaisse seafood soup with fish, mussels, shrimp, clams, saffron broth, served with rouille sauce and toasted baguette, professional food photography',
  'Мексиканский суп с фасолью': 'Mexican black bean soup with corn, chili peppers, tomatoes, garnished with sour cream, cilantro and tortilla strips, overhead shot',
  'Минестроне': 'Italian Minestrone soup with colorful vegetables, pasta, cannellini beans, tomato broth, sprinkled with parmesan, wooden table, professional food photography',
  'Шакшука': 'Shakshuka with eggs poached in spiced tomato and red pepper sauce, cast iron skillet, fresh herbs, crusty bread on side, overhead food photography',
  'Греческий салат': 'Greek salad with large feta cheese block, kalamata olives, ripe tomatoes, cucumber, red onion rings, drizzled with olive oil, white plate, overhead shot',
  'Салат Цезарь с курицей': 'Caesar salad with grilled chicken slices, crispy romaine lettuce, large croutons, shaved parmesan, creamy Caesar dressing, overhead shot, restaurant style',
  'Салат Оливье': 'Russian Olivier salad with diced potatoes, carrots, pickles, peas, eggs and mayonnaise, classic Soviet New Year salad, white bowl, overhead',
  'Салат из свеклы с чесноком': 'Russian beet salad with grated beetroot, garlic and mayonnaise, deep purple color, garnished with fresh dill, white bowl, overhead shot',
  'Картошка с грибами по-польски': 'Polish potato and mushroom dish, sliced potatoes with fried forest mushrooms, onion, sour cream sauce, rustic pan, food photography',
  'Киш Лорен': 'French Quiche Lorraine with crispy golden crust, creamy bacon and cheese filling, fresh thyme garnish, white plate, professional food photography',
  'Свекольник холодный': 'Cold Russian beet soup Svyokolnik, vibrant pink color with sour cream swirl, cucumber, dill, egg, white bowl, summer food photography',
  'Морковь по-корейски': 'Korean-style spiced marinated carrot salad Morkovcha, bright orange shreds with coriander seeds and sesame, close-up appetizing food photography',
  'Начос с сальсой': 'Nachos with melted cheddar cheese, fresh guacamole, tomato salsa, jalapeno slices, sour cream, served in a large bowl, professional food photography',
  'Фалафель': 'Crispy falafel balls on plate with tahini sauce, fresh pita bread, tomato cucumber salad, lemon wedge, Middle Eastern food photography, overhead',
}

interface Dish {
  id: number
  name: string
  image_url: string | null
}

async function ensureBucketExists() {
  // Проверяем через LIST всех bucket-ов (надёжнее чем GET одного)
  const res = await fetch(`${SUPABASE_URL}/storage/v1/bucket`, {
    headers: { Authorization: `Bearer ${SERVICE_KEY}`, apikey: SERVICE_KEY! },
  })
  const buckets = await res.json() as { name: string }[]
  const exists = Array.isArray(buckets) && buckets.some(b => b.name === BUCKET)

  if (!exists) {
    console.log(`📦 Создаю bucket "${BUCKET}"...`)
    const create = await fetch(`${SUPABASE_URL}/storage/v1/bucket`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${SERVICE_KEY}`,
        apikey: SERVICE_KEY!,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ id: BUCKET, name: BUCKET, public: true }),
    })
    if (!create.ok) {
      const err = await create.json()
      throw new Error(`Не удалось создать bucket: ${JSON.stringify(err)}`)
    }
    console.log(`✅ Bucket "${BUCKET}" создан`)
  } else {
    console.log(`✅ Bucket "${BUCKET}" уже существует`)
  }
}

async function generateImage(dishName: string): Promise<Buffer> {
  const prompt = DISH_PROMPTS[dishName] ??
    `${dishName}, professional food photography, top view, white background, appetizing, high quality`

  console.log(`  🎨 Генерирую: "${prompt.slice(0, 60)}..."`)

  const res = await fetch('https://api.openai.com/v1/images/generations', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${OPENAI_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'dall-e-3',
      prompt,
      n: 1,
      size: '1024x1024',
      quality: 'standard',
      response_format: 'url',
    }),
  })

  if (!res.ok) {
    const err = await res.text()
    throw new Error(`DALL-E error: ${res.status} — ${err}`)
  }

  const data = await res.json() as { data: { url: string }[] }
  const imageUrl = data.data[0]?.url
  if (!imageUrl) throw new Error('DALL-E вернул пустой ответ')

  // Скачиваем изображение
  const imgRes = await fetch(imageUrl)
  if (!imgRes.ok) throw new Error('Не удалось скачать сгенерированное изображение')
  const arrayBuffer = await imgRes.arrayBuffer()
  return Buffer.from(arrayBuffer)
}

async function uploadToStorage(dishId: number, imageBuffer: Buffer): Promise<string> {
  const fileName = `dish-${dishId}.png`

  const res = await fetch(`${SUPABASE_URL}/storage/v1/object/${BUCKET}/${fileName}`, {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${SERVICE_KEY}`,
      apikey: SERVICE_KEY!,
      'Content-Type': 'image/png',
      'x-upsert': 'true',
    },
    body: imageBuffer,
  })

  if (!res.ok) {
    const err = await res.json()
    throw new Error(`Upload error: ${JSON.stringify(err)}`)
  }

  return `${SUPABASE_URL}/storage/v1/object/public/${BUCKET}/${fileName}`
}

async function updateDishImageUrl(dishId: number, imageUrl: string) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/dishes?id=eq.${dishId}`, {
    method: 'PATCH',
    headers: {
      Authorization: `Bearer ${SERVICE_KEY}`,
      apikey: SERVICE_KEY!,
      'Content-Type': 'application/json',
      Prefer: 'return=minimal',
    },
    body: JSON.stringify({ image_url: imageUrl }),
  })

  if (!res.ok) {
    const err = await res.text()
    throw new Error(`DB update error: ${err}`)
  }
}

async function getDishesForGeneration(): Promise<Dish[]> {
  // Все блюда из DISH_PROMPTS — нужно сгенерировать/перегенерировать
  const targetNames = Object.keys(DISH_PROMPTS)

  // Получаем все блюда по именам из промптов + блюда с NULL image_url
  const encoded = targetNames.map(n => encodeURIComponent(`"${n}"`)).join(',')
  const url = `${SUPABASE_URL}/rest/v1/dishes?select=id,name,image_url&or=(image_url.is.null,name.in.(${encoded}))&order=name`

  const res = await fetch(url, {
    headers: {
      Authorization: `Bearer ${SERVICE_KEY}`,
      apikey: SERVICE_KEY!,
    },
  })
  if (!res.ok) throw new Error('Не удалось получить блюда')
  const all = await res.json() as Dish[]

  // Пропускаем блюда, которые уже имеют изображение из Supabase Storage
  return all.filter(d =>
    d.image_url === null || !d.image_url.includes('/storage/v1/object/public/dish-images/')
  )
}

async function main() {
  console.log('🚀 Генерация изображений блюд через DALL-E 3\n')

  await ensureBucketExists()
  console.log()

  const dishes = await getDishesForGeneration()
  if (dishes.length === 0) {
    console.log('✅ Все целевые блюда уже имеют изображения из Supabase Storage!')
    return
  }

  console.log(`📋 Блюд для генерации: ${dishes.length}`)
  for (const d of dishes) console.log(`   • ${d.name} (id=${d.id}) — ${d.image_url ? 'неверное фото' : 'нет фото'}`)
  console.log()

  let success = 0
  let failed = 0

  for (const dish of dishes) {
    console.log(`\n🍽️  ${dish.name} (id=${dish.id})`)
    try {
      const imageBuffer = await generateImage(dish.name)
      console.log(`  ⬆️  Загружаю в Supabase Storage...`)
      const publicUrl = await uploadToStorage(dish.id, imageBuffer)
      await updateDishImageUrl(dish.id, publicUrl)
      console.log(`  ✅ Готово: ${publicUrl}`)
      success++
      // Пауза чтобы не превысить rate limit OpenAI
      await new Promise(r => setTimeout(r, 2000))
    } catch (e) {
      console.error(`  ❌ Ошибка: ${(e as Error).message}`)
      failed++
    }
  }

  console.log(`\n${'─'.repeat(50)}`)
  console.log(`✅ Успешно: ${success}  ❌ Ошибок: ${failed}`)
}

main().catch((e: unknown) => {
  console.error('Fatal:', e)
  process.exit(1)
})
