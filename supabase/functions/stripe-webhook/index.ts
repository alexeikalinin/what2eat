import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import Stripe from 'https://esm.sh/stripe@14'

serve(async (req) => {
  const signature = req.headers.get('stripe-signature')
  const body = await req.text()

  let event: Stripe.Event
  try {
    const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY')!, {
      apiVersion: '2023-10-16',
    })
    event = await stripe.webhooks.constructEventAsync(
      body,
      signature!,
      Deno.env.get('STRIPE_WEBHOOK_SECRET')!
    )
  } catch (err) {
    return new Response(`Webhook Error: ${err}`, { status: 400 })
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
  )

  switch (event.type) {
    case 'checkout.session.completed': {
      const session = event.data.object as Stripe.Checkout.Session
      const userId = session.metadata?.supabase_user_id
      if (!userId) break

      // Find subscription valid_until
      let validUntil: string | null = null
      if (session.subscription) {
        const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY')!, { apiVersion: '2023-10-16' })
        const sub = await stripe.subscriptions.retrieve(session.subscription as string)
        validUntil = new Date(sub.current_period_end * 1000).toISOString()
      }

      await supabase
        .from('user_profiles')
        .update({ plan: 'premium', plan_valid_until: validUntil })
        .eq('id', userId)
      break
    }

    case 'customer.subscription.updated': {
      const sub = event.data.object as Stripe.Subscription
      const customerId = sub.customer as string

      const { data: profile } = await supabase
        .from('user_profiles')
        .select('id')
        .eq('stripe_customer_id', customerId)
        .single()
      if (!profile) break

      const isActive = sub.status === 'active' || sub.status === 'trialing'
      const validUntil = new Date(sub.current_period_end * 1000).toISOString()

      await supabase
        .from('user_profiles')
        .update({
          plan: isActive ? 'premium' : 'free',
          plan_valid_until: isActive ? validUntil : null,
        })
        .eq('id', profile.id)
      break
    }

    case 'customer.subscription.deleted': {
      const sub = event.data.object as Stripe.Subscription
      const customerId = sub.customer as string

      const { data: profile } = await supabase
        .from('user_profiles')
        .select('id')
        .eq('stripe_customer_id', customerId)
        .single()
      if (!profile) break

      await supabase
        .from('user_profiles')
        .update({ plan: 'free', plan_valid_until: null })
        .eq('id', profile.id)
      break
    }
  }

  return new Response(JSON.stringify({ received: true }), {
    headers: { 'Content-Type': 'application/json' },
  })
})
