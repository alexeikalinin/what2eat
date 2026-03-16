#!/usr/bin/env npx tsx
/**
 * Переводит description блюд на английский через GPT-4o-mini.
 * Обновляет колонку description_en в таблице dishes.
 *
 * Использование:
 *   npx tsx scripts/translate-descriptions.ts
 *   npx tsx scripts/translate-descriptions.ts --limit 10   # только N блюд
 */

import fs from 'fs'
import path from 'path'

function loadEnv() {
  const envPath = path.join(path.dirname(new URL(import.meta.url).pathname), '..', '.env')
  if (!fs.existsSync(envPath)) return
  for (const line of fs.readFileSync(envPath, 'utf-8').split('\n')) {
    const m = line.match(/^([A-Z_][A-Z0-9_]*)=(.+)$/)
    if (m && !process.env[m[1]]) process.env[m[1]] = m[2].trim()
  }
}
loadEnv()

const SUPABASE_URL = 'https://zfiyhhsknwpilamljhqu.supabase.co'
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY ?? ''
const OPENAI_KEY = process.env.VITE_OPENAI_API_KEY ?? process.env.OPENAI_API_KEY ?? ''

if (!SUPABASE_SERVICE_KEY) { console.error('❌ SUPABASE_SERVICE_KEY not set'); process.exit(1) }
if (!OPENAI_KEY) { console.error('❌ OPENAI_API_KEY not set'); process.exit(1) }

const G = (s: string) => `\x1b[32m${s}\x1b[0m`
const R = (s: string) => `\x1b[31m${s}\x1b[0m`
const DIM = (s: string) => `\x1b[2m${s}\x1b[0m`
const BOLD = (s: string) => `\x1b[1m${s}\x1b[0m`

const args = process.argv.slice(2)
const limitIdx = args.indexOf('--limit')
const LIMIT = limitIdx !== -1 ? parseInt(args[limitIdx + 1]) : 9999

async function fetchDishes() {
  const url = `${SUPABASE_URL}/rest/v1/dishes?select=id,name,description&description=not.is.null&description_en=is.null&order=id&limit=${LIMIT}`
  const r = await fetch(url, {
    headers: { apikey: SUPABASE_SERVICE_KEY, Authorization: `Bearer ${SUPABASE_SERVICE_KEY}` },
  })
  if (!r.ok) throw new Error(`Fetch dishes: ${r.status}`)
  return r.json() as Promise<{ id: number; name: string; description: string }[]>
}

async function translateBatch(items: { id: number; name: string; description: string }[]): Promise<Record<number, string>> {
  // Translate up to 20 dishes in one API call
  const listText = items.map((d, i) => `${i + 1}. [${d.id}] "${d.name}": ${d.description}`).join('\n')

  const prompt = `Translate these Russian dish descriptions to English. Keep them concise and appetizing (max 120 chars each).
Return ONLY a JSON object where keys are dish IDs (numbers) and values are English translations.
Example: {"3": "Tasty rice with chicken", "5": "Classic soup with vegetables"}

Dishes to translate:
${listText}`

  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${OPENAI_KEY}` },
    body: JSON.stringify({
      model: 'gpt-4o-mini',
      max_tokens: 2000,
      temperature: 0.3,
      messages: [{ role: 'user', content: prompt }],
    }),
  })

  const data = await res.json() as { choices: { message: { content: string } }[] }
  const text = data.choices?.[0]?.message?.content ?? '{}'
  try {
    const m = text.match(/\{[\s\S]*\}/)
    if (m) {
      const raw = JSON.parse(m[0]) as Record<string, string>
      // Normalize keys to numbers
      const result: Record<number, string> = {}
      for (const [k, v] of Object.entries(raw)) result[parseInt(k)] = v as string
      return result
    }
  } catch { /* fall through */ }
  return {}
}

async function updateDish(id: number, descriptionEn: string) {
  const r = await fetch(`${SUPABASE_URL}/rest/v1/dishes?id=eq.${id}`, {
    method: 'PATCH',
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: `Bearer ${SUPABASE_SERVICE_KEY}`,
      'Content-Type': 'application/json',
      Prefer: 'return=minimal',
    },
    body: JSON.stringify({ description_en: descriptionEn }),
  })
  if (!r.ok) throw new Error(`PATCH dish ${id}: ${r.status}`)
}

const delay = (ms: number) => new Promise(r => setTimeout(r, ms))

async function main() {
  console.log(BOLD('\n🌍 Перевод описаний блюд на английский\n'))

  const dishes = await fetchDishes()
  console.log(`Блюд без description_en: ${dishes.length}\n`)

  if (dishes.length === 0) {
    console.log(G('✅ Все описания уже переведены!'))
    return
  }

  const BATCH = 20
  let translated = 0, errors = 0

  for (let i = 0; i < dishes.length; i += BATCH) {
    const batch = dishes.slice(i, i + BATCH)
    process.stdout.write(`  Batch ${Math.floor(i / BATCH) + 1}/${Math.ceil(dishes.length / BATCH)} (${i + 1}–${Math.min(i + BATCH, dishes.length)})… `)

    try {
      const translations = await translateBatch(batch)
      const found = Object.keys(translations).length
      process.stdout.write(`${G(`✓ ${found} переводов`)}\n`)

      for (const dish of batch) {
        const en = translations[dish.id]
        if (en) {
          try {
            await updateDish(dish.id, en)
            translated++
            console.log(DIM(`    [${dish.id}] ${dish.name} → "${en}"`))
          } catch (e) {
            errors++
            console.log(R(`    [${dish.id}] Update failed: ${e}`))
          }
        } else {
          errors++
          console.log(R(`    [${dish.id}] ${dish.name} — перевод не получен`))
        }
      }
    } catch (e) {
      errors++
      console.log(R(`error — ${e}`))
    }

    if (i + BATCH < dishes.length) await delay(500)
  }

  console.log('\n' + BOLD('═══════════════════════════════'))
  console.log(G(`✅ Переведено: ${translated}`))
  if (errors > 0) console.log(R(`❌ Ошибок: ${errors}`))
  console.log()
}

main().catch(e => { console.error(R(`\n💥 Fatal: ${e}`)); process.exit(1) })
