#!/usr/bin/env npx tsx
/**
 * Переводит шаги приготовления рецептов (instructions) с русского на английский
 * через OpenAI gpt-4o-mini и сохраняет в колонку instructions_en в Supabase.
 *
 * Предварительно запусти Migration 018:
 *   ALTER TABLE recipes ADD COLUMN IF NOT EXISTS instructions_en TEXT;
 *
 * Использование:
 *   npx tsx scripts/translate-recipes.ts
 *
 * Опционально — только конкретные recipe IDs:
 *   npx tsx scripts/translate-recipes.ts --ids 1,2,3
 *
 * Стоимость: ~$0.03–0.06 на все 258 рецептов (gpt-4o-mini)
 */

import fs from 'fs'
import path from 'path'

// ── env ─────────────────────────────────────────────────────────────────────
function loadEnv() {
  const envPath = path.join(path.dirname(new URL(import.meta.url).pathname), '..', '.env')
  if (!fs.existsSync(envPath)) return
  for (const line of fs.readFileSync(envPath, 'utf-8').split('\n')) {
    const m = line.match(/^([A-Z_]+)=(.+)$/)
    if (m && !process.env[m[1]]) process.env[m[1]] = m[2].trim()
  }
}
loadEnv()

const SUPABASE_URL = 'https://zfiyhhsknwpilamljhqu.supabase.co'
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY ?? ''
const OPENAI_API_KEY = process.env.VITE_OPENAI_API_KEY ?? process.env.OPENAI_API_KEY ?? ''

if (!SUPABASE_SERVICE_KEY) { console.error('❌ SUPABASE_SERVICE_KEY not set'); process.exit(1) }
if (!OPENAI_API_KEY) { console.error('❌ VITE_OPENAI_API_KEY not set'); process.exit(1) }

// ── Supabase helpers ─────────────────────────────────────────────────────────
async function supabaseGet(path: string) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${path}`, {
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: `Bearer ${SUPABASE_SERVICE_KEY}`,
    },
  })
  if (!res.ok) throw new Error(`GET ${path} → ${res.status} ${await res.text()}`)
  return res.json()
}

async function supabasePatch(table: string, id: number, body: Record<string, unknown>) {
  const res = await fetch(`${SUPABASE_URL}/rest/v1/${table}?id=eq.${id}`, {
    method: 'PATCH',
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: `Bearer ${SUPABASE_SERVICE_KEY}`,
      'Content-Type': 'application/json',
      Prefer: 'return=minimal',
    },
    body: JSON.stringify(body),
  })
  if (!res.ok) throw new Error(`PATCH ${table}#${id} → ${res.status} ${await res.text()}`)
}

// ── OpenAI translation ───────────────────────────────────────────────────────
interface RecipeStep { step: number; description: string }

async function translateSteps(steps: RecipeStep[]): Promise<RecipeStep[]> {
  const prompt = `Translate these Russian cooking recipe steps to English.
Return ONLY a valid JSON array with the same structure (step numbers unchanged).
Do not add markdown, code blocks, or any extra text.

${JSON.stringify(steps)}`

  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      Authorization: `Bearer ${OPENAI_API_KEY}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      model: 'gpt-4o-mini',
      messages: [{ role: 'user', content: prompt }],
      temperature: 0.2,
      max_tokens: 2000,
    }),
  })

  if (!res.ok) {
    const err = await res.text()
    throw new Error(`OpenAI error ${res.status}: ${err}`)
  }

  const data = await res.json() as { choices: { message: { content: string } }[] }
  const content = data.choices[0].message.content.trim()

  // Remove possible markdown code block wrapping
  const cleaned = content.replace(/^```(?:json)?\n?/, '').replace(/\n?```$/, '').trim()
  return JSON.parse(cleaned) as RecipeStep[]
}

// ── sleep ────────────────────────────────────────────────────────────────────
function sleep(ms: number) { return new Promise(r => setTimeout(r, ms)) }

// ── main ─────────────────────────────────────────────────────────────────────
async function main() {
  const idsArg = process.argv.find(a => a.startsWith('--ids='))?.split('=')[1]
  const filterIds: number[] | null = idsArg ? idsArg.split(',').map(Number) : null

  let query = 'recipes?select=id,instructions,instructions_en&order=id'
  if (filterIds) {
    query += `&id=in.(${filterIds.join(',')})`
  } else {
    query += '&instructions_en=is.null'
  }

  console.log('🔍 Fetching recipes without translations…')
  const recipes: { id: number; instructions: string; instructions_en: string | null }[] =
    await supabaseGet(query)

  const todo = recipes.filter(r => !r.instructions_en)
  console.log(`📋 Found ${todo.length} recipes to translate`)
  if (todo.length === 0) { console.log('✅ Nothing to do'); return }

  let ok = 0, failed = 0

  for (let i = 0; i < todo.length; i++) {
    const recipe = todo[i]
    process.stdout.write(`[${i + 1}/${todo.length}] recipe #${recipe.id} … `)

    try {
      let steps: RecipeStep[]
      try {
        steps = JSON.parse(recipe.instructions) as RecipeStep[]
      } catch {
        console.log('⚠️  skip (invalid JSON instructions)')
        failed++
        continue
      }

      if (!steps.length) {
        console.log('⚠️  skip (empty steps)')
        failed++
        continue
      }

      const translated = await translateSteps(steps)
      await supabasePatch('recipes', recipe.id, { instructions_en: JSON.stringify(translated) })

      console.log(`✅ ${steps.length} steps translated`)
      ok++
    } catch (e) {
      console.log(`❌ ${(e as Error).message}`)
      failed++
    }

    // Rate limit: ~3 req/sec to stay within OpenAI free-tier limits
    if (i < todo.length - 1) await sleep(350)
  }

  console.log(`\n🎉 Done: ${ok} translated, ${failed} failed`)
}

main().catch(e => { console.error(e); process.exit(1) })
