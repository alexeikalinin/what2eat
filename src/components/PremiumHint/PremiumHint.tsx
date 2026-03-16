import { useState } from 'react'
import { Alert, Box, Chip, Typography, Button } from '@mui/material'
import { Lock } from '@mui/icons-material'
import { useModalContext } from '../../contexts/ModalContext'
import { useLanguage } from '../../hooks/useLanguage'

interface PremiumHintProps {
  text: string
  paywallReason: string
  variant?: 'chip' | 'alert' | 'banner'
  dismissKey?: string
}

export default function PremiumHint({ text, paywallReason, variant = 'chip', dismissKey }: PremiumHintProps) {
  const { openPaywall } = useModalContext()
  const { t } = useLanguage()
  const [dismissed, setDismissed] = useState(() => {
    if (!dismissKey) return false
    return localStorage.getItem(`w2e_hint_dismissed_${dismissKey}`) === '1'
  })

  if (dismissed) return null

  const handleDismiss = () => {
    if (dismissKey) localStorage.setItem(`w2e_hint_dismissed_${dismissKey}`, '1')
    setDismissed(true)
  }

  const handleOpen = () => openPaywall(paywallReason)

  if (variant === 'chip') {
    return (
      <Chip
        icon={<Lock sx={{ fontSize: '14px !important' }} />}
        label={text}
        size="small"
        onClick={handleOpen}
        sx={{
          bgcolor: '#FFF3E0',
          border: '1px solid #FFE0B2',
          color: 'rgba(0,0,0,0.6)',
          fontSize: '0.78rem',
          cursor: 'pointer',
          '& .MuiChip-icon': { color: '#FF7A18' },
          '&:hover': { bgcolor: '#FFE0B2' },
        }}
      />
    )
  }

  if (variant === 'alert') {
    return (
      <Alert
        severity="info"
        onClose={dismissKey ? handleDismiss : undefined}
        action={
          <Button
            size="small"
            color="inherit"
            onClick={handleOpen}
            sx={{ fontWeight: 600, fontSize: '0.78rem', whiteSpace: 'nowrap' }}
          >
            {t('hint_learn')} →
          </Button>
        }
        sx={{ mb: 2.5, borderRadius: 3, alignItems: 'center' }}
        icon={false}
      >
        {text}
      </Alert>
    )
  }

  // banner variant
  return (
    <Box
      sx={{
        mt: 2,
        p: 2,
        bgcolor: '#FFF3E0',
        border: '1px solid #FFE0B2',
        borderRadius: 3,
        display: 'flex',
        alignItems: 'flex-start',
        gap: 1.5,
      }}
    >
      <Lock sx={{ color: '#FF7A18', fontSize: 20, mt: 0.25, flexShrink: 0 }} />
      <Box sx={{ flex: 1 }}>
        <Typography variant="body2" sx={{ color: '#1A1A1A', mb: 1.25, lineHeight: 1.5 }}>
          {text}
        </Typography>
        <Button
          variant="outlined"
          size="small"
          color="warning"
          onClick={handleOpen}
          sx={{ borderRadius: 2, fontSize: '0.82rem', fontWeight: 600 }}
        >
          {t('hint_try_premium')}
        </Button>
      </Box>
      {dismissKey && (
        <Typography
          variant="caption"
          onClick={handleDismiss}
          sx={{ color: 'rgba(0,0,0,0.35)', cursor: 'pointer', '&:hover': { color: 'rgba(0,0,0,0.6)' }, flexShrink: 0 }}
        >
          ✕
        </Typography>
      )}
    </Box>
  )
}
