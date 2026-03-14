import { createClient } from '@supabase/supabase-js'
import type { User } from '@supabase/supabase-js'

const SUPABASE_URL = import.meta.env.VITE_SUPABASE_URL ?? ''
const SUPABASE_ANON_KEY = import.meta.env.VITE_SUPABASE_ANON_KEY ?? ''

// DEBUG: убрать после диагностики
console.log('[Supabase] URL first chars:', JSON.stringify(SUPABASE_URL.substring(0, 10)))
console.log('[Supabase] KEY set:', !!SUPABASE_ANON_KEY)

export const supabase = createClient(
  SUPABASE_URL || 'https://placeholder.supabase.co',
  SUPABASE_ANON_KEY || 'placeholder'
)

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
