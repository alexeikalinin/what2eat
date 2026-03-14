import { createClient } from '@supabase/supabase-js'
import type { User } from '@supabase/supabase-js'

// Патч Headers — в patch-headers.ts (подключается первым в main.tsx)

// Жёстко приводим к строкам — иначе в части окружений (fetch/Headers) передача
// не-строки даёт "Failed to execute 'set' on 'Headers': Invalid value"
const SUPABASE_URL = String(import.meta.env.VITE_SUPABASE_URL ?? '').trim()
const SUPABASE_ANON_KEY = String(import.meta.env.VITE_SUPABASE_ANON_KEY ?? '').trim()

const supabaseUrl = SUPABASE_URL || 'https://placeholder.supabase.co'
const supabaseAnonKey = SUPABASE_ANON_KEY || 'placeholder'

/** Допустимое значение для HTTP-заголовка: строка без управляющих символов (обход "Headers: Invalid value"). */
function safeHeaderValue(v: unknown): string {
  const s = v != null ? String(v) : ''
  return s.replace(/[\x00-\x1F\x7F]/g, '').trim()
}

/** Обход "fetch/Headers: Invalid value": URL и все заголовки — только валидные строки. */
function sanitizedFetch(input: RequestInfo | URL, init?: RequestInit): Promise<Response> {
  const url = typeof input === 'string' ? input : input instanceof URL ? input.href : (input as Request).url
  const safeInput = typeof url === 'string' && url ? url : String(url ?? '')
  if (!init?.headers) return fetch(safeInput, init)
  const headers = new Headers()
  const raw = init.headers
  const setSafe = (key: unknown, value: unknown) => {
    const k = safeHeaderValue(key)
    if (!k) return
    headers.set(k, safeHeaderValue(value))
  }
  if (raw instanceof Headers) {
    raw.forEach((value, key) => setSafe(key, value))
  } else if (Array.isArray(raw)) {
    for (const [key, value] of raw) setSafe(key, value)
  } else {
    for (const key of Object.keys(raw)) setSafe(key, (raw as Record<string, string>)[key])
  }
  return fetch(safeInput, { ...init, headers })
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  global: { fetch: sanitizedFetch },
  auth: {
    flowType: 'pkce',
    detectSessionInUrl: true,
    persistSession: true,
    autoRefreshToken: true,
    storageKey: 'what2eat-auth',
  },
})

/** Возвращает true если Supabase реально подключён */
export function isSupabaseConfigured(): boolean {
  return !!SUPABASE_URL && !!SUPABASE_ANON_KEY
}

export type UserPlan = 'guest' | 'free' | 'premium' | 'loading'

export interface UserProfile {
  id: string
  stripe_customer_id: string | null
  plan: 'free' | 'premium'
  plan_valid_until: string | null
}

export async function getUserProfile(userId: string): Promise<UserProfile | null> {
  if (!isSupabaseConfigured()) return null
  const { data } = await supabase
    .from('user_profiles')
    .select('*')
    .eq('id', userId)
    .maybeSingle()
  return data as UserProfile | null
}

export async function getUsageToday(userId: string): Promise<{ swipes: number; aiPhoto: number }> {
  if (!isSupabaseConfigured()) return { swipes: 0, aiPhoto: 0 }
  const today = new Date().toISOString().slice(0, 10)
  const { data } = await supabase
    .from('usage_counters')
    .select('swipes_count, ai_photo_count')
    .eq('user_id', userId)
    .eq('date', today)
    .maybeSingle()
  if (!data) return { swipes: 0, aiPhoto: 0 }
  return { swipes: data.swipes_count ?? 0, aiPhoto: data.ai_photo_count ?? 0 }
}

export async function incrementUsage(
  userId: string,
  field: 'swipes_count' | 'ai_photo_count'
): Promise<void> {
  if (!isSupabaseConfigured()) return
  const today = new Date().toISOString().slice(0, 10)
  await supabase.rpc('increment_usage', { p_user_id: userId, p_date: today, p_field: field })
}

export type { User }
