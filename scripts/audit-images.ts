#!/usr/bin/env npx tsx
/**
 * Аудит изображений блюд — GPT-4o Vision проверяет каждое фото.
 * Для несоответствий автоматически генерирует правильное фото через DALL-E 3.
 *
 * Использование:
 *   npx tsx scripts/audit-images.ts            # только аудит, отчёт в консоль
 *   npx tsx scripts/audit-images.ts --fix      # аудит + DALL-E для плохих фото
 *   npx tsx scripts/audit-images.ts --dish "Вареные яйца"  # одно блюдо
 *
 * Стоимость:
 *   Аудит:  ~$0.002/блюдо (gpt-4o, detail:low)
 *   Fix:    +$0.04/блюдо (DALL-E 3 standard 1024x1024)
 */

import fs from 'fs'
import path from 'path'

// ── env ─────────────────────────────────────────────────────────────────────
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
const BUCKET = 'dish-images'
const SUPABASE_SERVICE_KEY = process.env.SUPABASE_SERVICE_KEY ?? ''
const OPENAI_KEY = process.env.VITE_OPENAI_API_KEY ?? process.env.OPENAI_API_KEY ?? ''

if (!SUPABASE_SERVICE_KEY) { console.error('❌ SUPABASE_SERVICE_KEY not set'); process.exit(1) }
if (!OPENAI_KEY) { console.error('❌ VITE_OPENAI_API_KEY / OPENAI_API_KEY not set'); process.exit(1) }

// ── colors ──────────────────────────────────────────────────────────────────
const G = (s: string) => `\x1b[32m${s}\x1b[0m`
const R = (s: string) => `\x1b[31m${s}\x1b[0m`
const Y = (s: string) => `\x1b[33m${s}\x1b[0m`
const B = (s: string) => `\x1b[34m${s}\x1b[0m`
const DIM = (s: string) => `\x1b[2m${s}\x1b[0m`
const BOLD = (s: string) => `\x1b[1m${s}\x1b[0m`

// ── args ────────────────────────────────────────────────────────────────────
const args = process.argv.slice(2)
const FIX_MODE = args.includes('--fix')
const DISH_FILTER = (() => {
  const idx = args.indexOf('--dish')
  return idx !== -1 ? args[idx + 1] : null
})()
const DRY_RUN = args.includes('--dry')

// ── Supabase helpers ─────────────────────────────────────────────────────────
async function sbGet(p: string) {
  const r = await fetch(`${SUPABASE_URL}/rest/v1/${p}`, {
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: `Bearer ${SUPABASE_SERVICE_KEY}`,
    },
  })
  if (!r.ok) throw new Error(`Supabase GET ${p}: ${r.status}`)
  return r.json()
}

async function sbPatch(table: string, id: number, body: Record<string, unknown>) {
  const r = await fetch(`${SUPABASE_URL}/rest/v1/${table}?id=eq.${id}`, {
    method: 'PATCH',
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: `Bearer ${SUPABASE_SERVICE_KEY}`,
      'Content-Type': 'application/json',
      Prefer: 'return=minimal',
    },
    body: JSON.stringify(body),
  })
  if (!r.ok) throw new Error(`Supabase PATCH ${table} id=${id}: ${r.status}`)
}

async function sbUpload(fileName: string, imageBuffer: Buffer): Promise<string> {
  const r = await fetch(`${SUPABASE_URL}/storage/v1/object/${BUCKET}/${fileName}`, {
    method: 'POST',
    headers: {
      apikey: SUPABASE_SERVICE_KEY,
      Authorization: `Bearer ${SUPABASE_SERVICE_KEY}`,
      'Content-Type': 'image/png',
      'Cache-Control': '3600',
    },
    body: imageBuffer,
  })
  if (!r.ok) {
    const err = await r.text()
    throw new Error(`Upload failed: ${err}`)
  }
  return `${SUPABASE_URL}/storage/v1/object/public/${BUCKET}/${fileName}`
}

// ── OpenAI helpers ───────────────────────────────────────────────────────────
interface AuditResult {
  match: boolean
  score: number  // 1-10, where 1=completely wrong, 10=perfect match
  seen: string   // what GPT actually sees in the image
}

async function auditImage(dishName: string, imageUrl: string): Promise<AuditResult> {
  const prompt = `You are a food image quality checker.
Dish name: "${dishName}"
Look at this image and answer in JSON only:
{"score": <1-10>, "seen": "<one sentence: what food/drink is shown>", "match": <true|false>}
- score 1-3 = completely wrong (e.g. wine glass instead of eggs)
- score 4-6 = somewhat related but not this specific dish
- score 7-10 = correct or very close
No explanation, just JSON.`

  const res = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${OPENAI_KEY}` },
    body: JSON.stringify({
      model: 'gpt-4o',
      max_tokens: 120,
      messages: [{
        role: 'user',
        content: [
          { type: 'image_url', image_url: { url: imageUrl, detail: 'low' } },
          { type: 'text', text: prompt },
        ],
      }],
    }),
  })

  const data = await res.json() as { choices: { message: { content: string } }[] }
  const text = data.choices?.[0]?.message?.content ?? '{}'
  try {
    const m = text.match(/\{[\s\S]*\}/)
    if (m) return JSON.parse(m[0]) as AuditResult
  } catch { /* fall through */ }
  return { match: false, score: 0, seen: 'parse error' }
}

async function generateDallE(dishName: string): Promise<string> {
  const promptRes = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${OPENAI_KEY}` },
    body: JSON.stringify({
      model: 'gpt-4o-mini',
      max_tokens: 120,
      messages: [{
        role: 'user',
        content: `Create a concise DALL-E 3 image prompt for the dish "${dishName}".
Reply with ONLY the prompt (max 100 words): food photography style, top-down or 3/4 angle, natural lighting, appetizing, on a plate or in a bowl.`,
      }],
    }),
  })
  const pData = await promptRes.json() as { choices: { message: { content: string } }[] }
  const prompt = pData.choices?.[0]?.message?.content?.trim() ?? `${dishName}, food photography, top-down, white plate`

  console.log(DIM(`    DALL-E prompt: "${prompt.substring(0, 80)}..."`))

  const imgRes = await fetch('https://api.openai.com/v1/images/generations', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${OPENAI_KEY}` },
    body: JSON.stringify({
      model: 'dall-e-3',
      prompt,
      n: 1,
      size: '1024x1024',
      quality: 'standard',
      response_format: 'url',
    }),
  })
  const imgData = await imgRes.json() as { data: { url: string }[] }
  return imgData.data?.[0]?.url ?? ''
}

async function downloadImage(url: string): Promise<Buffer> {
  const res = await fetch(url)
  if (!res.ok) throw new Error(`Download failed: ${res.status}`)
  return Buffer.from(await res.arrayBuffer())
}

function slugify(name: string): string {
  return name
    .toLowerCase()
    .replace(/[^а-яёa-z0-9]+/gi, '-')
    .replace(/^-+|-+$/g, '')
    .substring(0, 50)
}

const delay = (ms: number) => new Promise(r => setTimeout(r, ms))

// ── Main ─────────────────────────────────────────────────────────────────────
interface Dish {
  id: number
  name: string
  image_url: string | null
}

interface AuditEntry {
  id: number
  name: string
  url: string
  score: number
  seen: string
  match: boolean
  fixed?: boolean
  newUrl?: string
  error?: string
}

async function main() {
  console.log(BOLD('\n🔍 Аудит изображений блюд\n'))
  if (FIX_MODE) console.log(Y('⚡ Fix mode: DALL-E 3 будет использован для плохих фото\n'))
  if (DRY_RUN) console.log(Y('🔒 Dry run: DB не будет обновлена\n'))

  // Fetch all dishes
  let dishes: Dish[] = await sbGet('dishes?select=id,name,image_url&order=name')

  if (DISH_FILTER) {
    dishes = dishes.filter(d => d.name.toLowerCase().includes(DISH_FILTER.toLowerCase()))
    console.log(`Filtered to ${dishes.length} dish(es) matching "${DISH_FILTER}"\n`)
  }

  const results: AuditEntry[] = []
  let checked = 0, skipped = 0, mismatches = 0, fixed = 0

  for (const dish of dishes) {
    const url = dish.image_url

    // Skip dishes without image
    if (!url) {
      console.log(DIM(`  [skip] ${dish.name} — no image_url`))
      skipped++
      continue
    }

    // Skip Supabase Storage (DALL-E generated — trusted as correct)
    if (url.includes('supabase.co/storage')) {
      console.log(DIM(`  [skip] ${dish.name} — Supabase Storage (DALL-E, trusted)`))
      skipped++
      continue
    }

    process.stdout.write(`  Checking [${checked + 1}/${dishes.length}] ${dish.name}… `)

    try {
      const result = await auditImage(dish.name, url)
      checked++

      const icon = result.score >= 7 ? G('✓') : result.score >= 4 ? Y('~') : R('✗')
      const scoreStr = result.score >= 7 ? G(`${result.score}/10`) : result.score >= 4 ? Y(`${result.score}/10`) : R(`${result.score}/10`)
      console.log(`${icon} ${scoreStr} — ${result.seen}`)

      const entry: AuditEntry = { id: dish.id, name: dish.name, url, ...result }

      if (!result.match || result.score < 5) {
        mismatches++
        console.log(R(`    ⚠️  MISMATCH: "${dish.name}" — URL: ${url.substring(0, 70)}…`))

        if (FIX_MODE && !DRY_RUN) {
          try {
            console.log(B(`    🎨 Generating DALL-E 3 image…`))
            const dalleUrl = await generateDallE(dish.name)
            if (!dalleUrl) throw new Error('Empty DALL-E URL')

            const buffer = await downloadImage(dalleUrl)
            const slug = slugify(dish.name)
            const fileName = `${slug}-${Date.now()}.png`
            const publicUrl = await sbUpload(fileName, buffer)

            await sbPatch('dishes', dish.id, { image_url: publicUrl })
            entry.fixed = true
            entry.newUrl = publicUrl
            fixed++
            console.log(G(`    ✅ Fixed! Saved as ${fileName}`))

            await delay(2000) // DALL-E rate limit
          } catch (e) {
            entry.error = String(e)
            console.log(R(`    ❌ Fix failed: ${e}`))
          }
        }
      }

      results.push(entry)

    } catch (e) {
      console.log(R(`error — ${e}`))
      results.push({ id: dish.id, name: dish.name, url: url ?? '', score: -1, seen: 'error', match: false, error: String(e) })
      checked++
    }

    await delay(350) // GPT-4o rate limit
  }

  // ── Report ────────────────────────────────────────────────────────────────
  const bad = results.filter(r => !r.match || r.score < 5)
  const warn = results.filter(r => r.match && r.score >= 5 && r.score < 7)

  console.log('\n' + BOLD('═══════════════════════════════════════════'))
  console.log(BOLD('📊 Результаты аудита'))
  console.log(BOLD('═══════════════════════════════════════════'))
  console.log(`  Проверено: ${checked}`)
  console.log(`  Пропущено: ${skipped} (без image_url)`)
  console.log(G(`  Совпадает (≥7/10): ${results.filter(r => r.score >= 7).length}`))
  console.log(Y(`  Сомнительно (5-6/10): ${warn.length}`))
  console.log(R(`  Не совпадает (<5/10): ${bad.length}`))
  if (FIX_MODE) console.log(G(`  Исправлено DALL-E: ${fixed}`))

  if (bad.length > 0) {
    console.log('\n' + BOLD(R('❌ Несоответствия:')))
    for (const e of bad) {
      const status = e.fixed ? G('[FIXED]') : R('[NEEDS FIX]')
      console.log(`  ${status} ${e.name}`)
      console.log(DIM(`    Видит: "${e.seen}"`))
      console.log(DIM(`    URL:   ${e.url.substring(0, 80)}`))
      if (e.newUrl) console.log(DIM(`    New:   ${e.newUrl.substring(0, 80)}`))
    }
  }

  if (warn.length > 0) {
    console.log('\n' + BOLD(Y('⚠️  Сомнительные (5-6/10):')))
    for (const e of warn) {
      console.log(`  ${e.name} — ${e.seen}`)
    }
  }

  // Save JSON report
  const reportPath = path.join(path.dirname(new URL(import.meta.url).pathname), 'image-audit-report.json')
  fs.writeFileSync(reportPath, JSON.stringify({ timestamp: new Date().toISOString(), summary: { checked, skipped, bad: bad.length, warn: warn.length, fixed }, results }, null, 2))
  console.log(`\n${DIM(`📄 Полный отчёт: scripts/image-audit-report.json`)}`)

  // Generate SQL for unfixed mismatches
  const unfixed = bad.filter(e => !e.fixed)
  if (unfixed.length > 0 && !FIX_MODE) {
    console.log('\n' + BOLD('💡 Для автоисправления запусти:'))
    console.log(B('   npx tsx scripts/audit-images.ts --fix'))
    console.log('\n' + BOLD('Или вручную (сбросить image_url → будет использован DISH_IMAGE_OVERRIDES):'))
    const sql = unfixed.map(e => `UPDATE dishes SET image_url = NULL WHERE id = ${e.id}; -- ${e.name}`).join('\n')
    console.log(Y(sql))
  }

  console.log()
}

main().catch(e => { console.error(R(`\n💥 Fatal: ${e}`)); process.exit(1) })
