#!/usr/bin/env npx ts-node --esm
/**
 * Запускает миграции 012 и 013 через Supabase Management API
 * Использование:
 *   SUPABASE_ACCESS_TOKEN=sbp_xxxx npx tsx scripts/run-migrations.ts
 *
 * PAT можно получить: https://supabase.com/dashboard/account/tokens
 */

import fs from 'fs'
import path from 'path'

const PROJECT_REF = 'zfiyhhsknwpilamljhqu'
const PAT = process.env.SUPABASE_ACCESS_TOKEN

if (!PAT) {
  console.error('❌ Нужен SUPABASE_ACCESS_TOKEN')
  console.error('   Получи на https://supabase.com/dashboard/account/tokens')
  console.error('   Затем запусти: SUPABASE_ACCESS_TOKEN=sbp_xxx npx tsx scripts/run-migrations.ts')
  process.exit(1)
}

const migrations = [
  '012_expand_recipes.sql',
  '013_fix_all_dish_images.sql',
]

async function runQuery(sql: string, label: string) {
  const res = await fetch(`https://api.supabase.com/v1/projects/${PROJECT_REF}/database/query`, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${PAT}`,
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ query: sql }),
  })
  const data = await res.json() as { message?: string; error?: string }
  if (!res.ok) {
    console.error(`❌ ${label}: ${data.message || data.error || JSON.stringify(data)}`)
    return false
  }
  console.log(`✅ ${label}`)
  return true
}

async function main() {
  console.log(`🚀 Запуск миграций для проекта ${PROJECT_REF}...\n`)

  for (const file of migrations) {
    const filePath = path.join(import.meta.dirname ?? process.cwd(), '../supabase/migrations', file)
    if (!fs.existsSync(filePath)) {
      console.error(`❌ Файл не найден: ${filePath}`)
      continue
    }

    const sql = fs.readFileSync(filePath, 'utf-8')
    const ok = await runQuery(sql, file)
    if (!ok) {
      console.error('\n❌ Миграция прервана. Исправь ошибку и запусти снова.')
      process.exit(1)
    }
  }

  console.log('\n✅ Все миграции применены успешно!')
  console.log('   Сайт обновится автоматически через 30 секунд.')
}

main().catch((e: unknown) => {
  console.error('Fatal:', e)
  process.exit(1)
})
