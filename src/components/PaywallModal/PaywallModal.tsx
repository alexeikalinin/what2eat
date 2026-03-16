import { useState } from 'react'
import {
  Dialog, DialogContent, Box, Typography, Button,
  IconButton, List, ListItem, ListItemIcon, ListItemText,
  Divider, CircularProgress, ToggleButtonGroup, ToggleButton,
} from '@mui/material'
import { Close, Check, Lock, Star } from '@mui/icons-material'
import { createCheckoutSession, StripePlan } from '../../services/stripe'
import { useAppSelector } from '../../hooks/redux'
import { isSupabaseConfigured } from '../../services/supabase'
import { useLanguage } from '../../hooks/useLanguage'

interface PaywallModalProps {
  open: boolean
  onClose: () => void
  onLoginRequired?: () => void
  reason?: string
}

export default function PaywallModal({ open, onClose, onLoginRequired, reason }: PaywallModalProps) {
  const { user } = useAppSelector((state) => state.user)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [billingPlan, setBillingPlan] = useState<StripePlan>('monthly')
  const { t } = useLanguage()

  const FREE_FEATURES = [
    t('paywall_free_ingredients'), t('paywall_free_search'), t('paywall_free_vegetarian_filter'), t('paywall_free_recipes'),
    t('paywall_free_swipe'), t('paywall_free_shopping'), t('paywall_free_ai_photo'), t('paywall_free_randomizer'),
  ]
  const PREMIUM_FEATURES = [
    t('paywall_premium_everything'), t('paywall_premium_swipe_unlimited'), t('paywall_premium_ai_photo_unlimited'),
    t('paywall_premium_calories'), t('paywall_premium_ai_suggestions'), t('paywall_premium_randomizer_full'),
    t('paywall_premium_filters'), t('paywall_premium_weekly'), t('paywall_premium_smart_list'),
  ]

  const stripeReady = isSupabaseConfigured()
  const hasYearlyPrice = !!import.meta.env.VITE_STRIPE_PRICE_ID_YEARLY

  const handleSubscribe = async () => {
    if (!user) {
      onClose()
      onLoginRequired?.()
      return
    }
    if (!stripeReady) {
      setError(t('paywall_stripe_not_configured'))
      return
    }
    setLoading(true)
    setError(null)
    try {
      await createCheckoutSession(billingPlan)
    } catch (err) {
      setError(err instanceof Error ? err.message : t('paywall_error'))
      setLoading(false)
    }
  }

  return (
    <Dialog
      open={open}
      onClose={onClose}
      maxWidth="xs"
      fullWidth
      PaperProps={{ sx: { borderRadius: 4, overflow: 'hidden', m: 2 } }}
    >
      {/* Header */}
      <Box
        sx={{
          background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
          px: 3, pt: 3, pb: 2.5,
          position: 'relative',
        }}
      >
        <IconButton
          onClick={onClose}
          size="small"
          sx={{ position: 'absolute', top: 12, right: 12, color: 'rgba(255,255,255,0.8)' }}
        >
          <Close />
        </IconButton>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 1 }}>
          <Star sx={{ color: 'white', fontSize: 28 }} />
          <Typography variant="h5" sx={{ color: 'white', fontWeight: 800 }}>
            Premium
          </Typography>
        </Box>
        {reason && (
          <Typography variant="body2" sx={{ color: 'rgba(255,255,255,0.9)', mb: 1.5, fontSize: '0.9rem' }}>
            {reason}
          </Typography>
        )}

        {/* Billing toggle */}
        {hasYearlyPrice ? (

          <ToggleButtonGroup
            value={billingPlan}
            exclusive
            onChange={(_, v) => v && setBillingPlan(v)}
            size="small"
            sx={{ bgcolor: 'rgba(255,255,255,0.2)', borderRadius: 2, p: 0.5 }}
          >
            <ToggleButton
              value="monthly"
              sx={{
                color: 'white',
                border: 'none',
                borderRadius: '8px !important',
                px: 2,
                py: 0.5,
                fontSize: '0.8rem',
                fontWeight: 600,
                '&.Mui-selected': { bgcolor: 'white', color: '#FF7A18' },
              }}
            >
              {t('paywall_price_monthly_short')}
            </ToggleButton>
            <ToggleButton
              value="yearly"
              sx={{
                color: 'white',
                border: 'none',
                borderRadius: '8px !important',
                px: 2,
                py: 0.5,
                fontSize: '0.8rem',
                fontWeight: 600,
                '&.Mui-selected': { bgcolor: 'white', color: '#FF7A18' },
              }}
            >
              {t('paywall_price_yearly_short')}
              <Box
                component="span"
                sx={{
                  ml: 0.75,
                  bgcolor: '#22C55E',
                  color: 'white',
                  fontSize: '0.6rem',
                  fontWeight: 800,
                  px: 0.6,
                  py: 0.2,
                  borderRadius: 1,
                }}
              >
                −30%
              </Box>
            </ToggleButton>
          </ToggleButtonGroup>
        ) : (
          <Box>
            <Typography variant="h6" sx={{ color: 'white', fontWeight: 700 }}>
              {t('paywall_price_monthly_short')}
            </Typography>
            <Typography variant="caption" sx={{ color: 'rgba(255,255,255,0.75)' }}>
              {t('paywall_price_yearly_saving')}
            </Typography>
          </Box>
        )}
      </Box>

      <DialogContent sx={{ p: 0 }}>
        {/* Free features */}
        <Box sx={{ px: 3, py: 2 }}>
          <Typography variant="caption" sx={{ fontWeight: 700, color: 'rgba(0,0,0,0.4)', textTransform: 'uppercase', letterSpacing: '0.08em' }}>
            Free
          </Typography>
          <List dense disablePadding sx={{ mt: 0.5 }}>
            {FREE_FEATURES.map((f) => (
              <ListItem key={f} disablePadding disableGutters sx={{ py: 0.2 }}>
                <ListItemIcon sx={{ minWidth: 28 }}>
                  <Check sx={{ fontSize: 15, color: '#22C55E' }} />
                </ListItemIcon>
                <ListItemText
                  primary={f}
                  primaryTypographyProps={{ variant: 'body2', color: 'rgba(0,0,0,0.65)', fontSize: '0.8rem' }}
                />
              </ListItem>
            ))}
          </List>
        </Box>

        <Divider />

        {/* Premium features */}
        <Box sx={{ px: 3, py: 2 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75, mb: 0.5 }}>
            <Star sx={{ fontSize: 14, color: '#FF7A18' }} />
            <Typography variant="caption" sx={{ fontWeight: 700, color: '#FF7A18', textTransform: 'uppercase', letterSpacing: '0.08em' }}>
              Premium
            </Typography>
          </Box>
          <List dense disablePadding sx={{ mt: 0.5 }}>
            {PREMIUM_FEATURES.map((f) => (
              <ListItem key={f} disablePadding disableGutters sx={{ py: 0.2 }}>
                <ListItemIcon sx={{ minWidth: 28 }}>
                  <Star sx={{ fontSize: 13, color: '#FF7A18' }} />
                </ListItemIcon>
                <ListItemText
                  primary={f}
                  primaryTypographyProps={{ variant: 'body2', color: '#1A1A1A', fontSize: '0.8rem', fontWeight: f === t('paywall_premium_everything') ? 400 : 500 }}
                />
              </ListItem>
            ))}
          </List>
        </Box>

        {/* CTA */}
        <Box sx={{ px: 3, pb: 3 }}>
          {error && (
            <Typography variant="body2" sx={{ color: 'error.main', mb: 1.5, fontSize: '0.82rem' }}>
              {error}
            </Typography>
          )}

          <Button
            variant="contained"
            size="large"
            fullWidth
            onClick={handleSubscribe}
            disabled={loading}
            startIcon={loading ? <CircularProgress size={18} sx={{ color: 'white' }} /> : <Star />}
            sx={{
              py: 1.5,
              background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
              borderRadius: 3,
              fontWeight: 700,
              fontSize: '0.95rem',
              boxShadow: '0 4px 15px rgba(255,122,24,0.4)',
              '&:hover': { boxShadow: '0 6px 20px rgba(255,122,24,0.5)' },
            }}
          >
            {loading
              ? t('paywall_stripe_loading')
              : user
                ? billingPlan === 'yearly'
                  ? t('paywall_subscribe_yearly')
                  : t('paywall_subscribe_monthly')
                : t('paywall_login_subscribe')
            }
          </Button>

          {!user && (
            <Typography variant="caption" sx={{ display: 'block', textAlign: 'center', mt: 1, color: 'rgba(0,0,0,0.45)' }}>
              {t('paywall_need_account')}
            </Typography>
          )}

          <Button
            fullWidth
            onClick={onClose}
            size="small"
            startIcon={<Lock sx={{ fontSize: 14 }} />}
            sx={{ mt: 1, color: 'rgba(0,0,0,0.4)', fontSize: '0.8rem' }}
          >
            {t('paywall_continue_free')}
          </Button>
        </Box>
      </DialogContent>
    </Dialog>
  )
}
