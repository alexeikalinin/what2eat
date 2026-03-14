import { supabase } from './supabase'

export type StripePlan = 'monthly' | 'yearly'

function getPriceId(plan: StripePlan): string {
  if (plan === 'yearly') {
    const yearlyId = import.meta.env.VITE_STRIPE_PRICE_ID_YEARLY as string | undefined
    if (yearlyId) return yearlyId
  }
  return import.meta.env.VITE_STRIPE_PRICE_ID as string
}

export async function createCheckoutSession(plan: StripePlan = 'monthly'): Promise<void> {
  const { data: sessionData } = await supabase.auth.getSession()
  const token = sessionData?.session?.access_token
  if (!token) throw new Error('Необходима авторизация')

  const supabaseUrl = import.meta.env.VITE_SUPABASE_URL as string
  if (!supabaseUrl) throw new Error('Supabase не настроен')

  const anonKey = import.meta.env.VITE_SUPABASE_ANON_KEY as string
  const res = await fetch(`${supabaseUrl}/functions/v1/create-checkout`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      Authorization: `Bearer ${token}`,
      apikey: anonKey,
    },
    body: JSON.stringify({ price_id: getPriceId(plan) }),
  })

  if (!res.ok) {
    const err = await res.text()
    throw new Error(`Ошибка создания сессии: ${err}`)
  }

  const { url } = (await res.json()) as { url: string }
  if (url) window.location.href = url
}
