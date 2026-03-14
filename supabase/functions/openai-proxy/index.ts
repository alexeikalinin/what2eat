import { serve } from 'https://deno.land/std@0.177.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions'
const DAILY_AI_PHOTO_LIMIT_FREE = 1

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const authHeader = req.headers.get('Authorization')
    if (!authHeader) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    )

    // Verify JWT and get user
    const { data: { user }, error: authError } = await supabase.auth.getUser(
      authHeader.replace('Bearer ', '')
    )
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Invalid token' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Get user plan
    const { data: profile } = await supabase
      .from('user_profiles')
      .select('plan')
      .eq('id', user.id)
      .single()

    const isPremium = profile?.plan === 'premium'

    // Parse request body
    const body = await req.json()
    const action: string = body.action ?? 'generic'

    // Check limits for AI photo actions
    if (action === 'detect_ingredients' || action === 'estimate_calories') {
      if (action === 'estimate_calories' && !isPremium) {
        return new Response(JSON.stringify({ error: 'Premium required for calorie estimation' }), {
          status: 403,
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
      }

      if (!isPremium) {
        const today = new Date().toISOString().slice(0, 10)
        const { data: usage } = await supabase
          .from('usage_counters')
          .select('ai_photo_count')
          .eq('user_id', user.id)
          .eq('date', today)
          .single()

        if ((usage?.ai_photo_count ?? 0) >= DAILY_AI_PHOTO_LIMIT_FREE) {
          return new Response(
            JSON.stringify({ error: `Daily AI photo limit reached (${DAILY_AI_PHOTO_LIMIT_FREE}/day on Free plan)` }),
            { status: 429, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
          )
        }
      }
    }

    // Check AI suggestions limit
    if (action === 'suggest_dishes' && !isPremium) {
      return new Response(JSON.stringify({ error: 'Premium required for AI dish suggestions' }), {
        status: 403,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Proxy to OpenAI (strip our custom 'action' field before forwarding)
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { action: _removedAction, ...openaiBody } = body
    const openaiRes = await fetch(OPENAI_API_URL, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${Deno.env.get('OPENAI_API_KEY')}`,
      },
      body: JSON.stringify(openaiBody),
    })

    if (!openaiRes.ok) {
      const err = await openaiRes.text()
      return new Response(err, {
        status: openaiRes.status,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Increment usage counter for AI photo actions
    if (action === 'detect_ingredients' && !isPremium) {
      const today = new Date().toISOString().slice(0, 10)
      await supabase.rpc('increment_usage', {
        p_user_id: user.id,
        p_date: today,
        p_field: 'ai_photo_count',
      })
    }

    const data = await openaiRes.json()
    return new Response(JSON.stringify(data), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: String(err) }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
