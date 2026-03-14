import { createClient } from '@supabase/supabase-js'
const s = createClient(
  'https://zfiyhhsknwpilamljhqu.supabase.co',
  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpmaXloaHNrbndwaWxhbWxqaHF1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzMxMzM2MTYsImV4cCI6MjA4ODcwOTYxNn0.LkWxLOfehJSCV58lvwWcDoDxyKOcjEPF76yjEppsAg8'
)
const { data } = await s.from('ingredients').select('name, category').in('category', ['spices','other']).order('name')
console.log('Spices/Other в БД:')
for (const r of data ?? []) console.log(`  [${r.category}] ${r.name}`)
