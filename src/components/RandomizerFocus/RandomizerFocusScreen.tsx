import { useState } from 'react'
import { Box, Button, FormControlLabel, Paper, Switch, ToggleButton, ToggleButtonGroup, Typography, Tooltip } from '@mui/material'
import { ArrowBack, Casino, Lock } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useAppDispatch, useAppSelector } from '../../hooks/redux'
import { setFocus } from '../../store/slices/randomizerSlice'
import { randomizeDishesByFocus } from '../../store/slices/dishesSlice'
import { resetSwipe } from '../../store/slices/swipeSlice'
import { RandomizerFocus } from '../../services/dishes'
import { usePlan } from '../../hooks/usePlan'
import PaywallModal from '../PaywallModal'
import { useModalContext } from '../../contexts/ModalContext'
import PremiumHint from '../PremiumHint'
import { useLanguage } from '../../hooks/useLanguage'

interface Props {
  onStart: () => void
  onBack: () => void
}

export default function RandomizerFocusScreen({ onStart, onBack }: Props) {
  const dispatch = useAppDispatch()
  const focus = useAppSelector((state) => state.randomizer.focus)
  const { canUseFullRandomizer } = usePlan()
  const { openAuth } = useModalContext()
  const [paywallOpen, setPaywallOpen] = useState(false)

  const isFullRandomizer = canUseFullRandomizer()
  const { t } = useLanguage()

  const update = (patch: Partial<RandomizerFocus>) =>
    dispatch(setFocus({ ...focus, ...patch }))

  const handleStart = () => {
    dispatch(resetSwipe())
    dispatch(randomizeDishesByFocus(focus))
    onStart()
  }

  const toggleProps = { size: 'small' as const, sx: { borderRadius: '10px !important', px: 1.5, py: 0.75, fontSize: '0.85rem' } }

  // Free: только кухня + тип блюда. Premium: все 5 осей
  const freeSections = [
    {
      label: t('randomizer_cuisine'), field: 'cuisine' as const, isPremium: false,
      options: [
        { v: 'any', l: t('randomizer_cuisine_any') }, { v: 'russian', l: t('quick_cuisine_russian') },
        { v: 'italian', l: t('quick_cuisine_italian') }, { v: 'asian', l: t('quick_cuisine_asian') },
        { v: 'eastern_european', l: t('quick_cuisine_eastern_european') },
        { v: 'mediterranean', l: t('quick_cuisine_mediterranean') },
        { v: 'georgian', l: t('quick_cuisine_georgian') },
        { v: 'mexican', l: t('quick_cuisine_mexican') },
        { v: 'french', l: t('quick_cuisine_french') },
      ],
    },
    {
      label: t('randomizer_meal_type'), field: 'mealType' as const, isPremium: false,
      options: [
        { v: 'any', l: t('randomizer_meal_any') }, { v: 'breakfast', l: t('randomizer_meal_breakfast') },
        { v: 'lunch', l: t('randomizer_meal_lunch') }, { v: 'dinner', l: t('randomizer_meal_dinner') }, { v: 'snack', l: t('randomizer_meal_snack') },
      ],
    },
    {
      label: t('randomizer_time'), field: 'cookingTime' as const, isPremium: true,
      options: [
        { v: 'any', l: t('randomizer_time_any') }, { v: 'quick', l: t('randomizer_time_quick') },
        { v: 'medium', l: t('randomizer_time_medium') }, { v: 'slow', l: t('randomizer_time_slow') },
      ],
    },
    {
      label: t('randomizer_difficulty'), field: 'difficulty' as const, isPremium: true,
      options: [
        { v: 'any', l: t('randomizer_diff_any') }, { v: 'easy', l: t('randomizer_diff_easy') },
        { v: 'medium', l: t('randomizer_diff_medium') }, { v: 'hard', l: t('randomizer_diff_hard') },
      ],
    },
  ]

  return (
    <>
      <motion.div
        initial={{ opacity: 0, y: 10 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.3 }}
      >
        <Box sx={{ pb: 4 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', mb: 3, gap: 1 }}>
            <Button startIcon={<ArrowBack />} onClick={onBack} size="small" sx={{ color: 'rgba(0,0,0,0.45)' }}>
              {t('back')}
            </Button>
            <Typography variant="h5" sx={{ flex: 1, textAlign: 'center', fontWeight: 700, color: '#1A1A1A' }}>
              🎲 {t('randomizer_title')}
            </Typography>
          </Box>

          {freeSections.map((section, i) => {
            const locked = section.isPremium && !isFullRandomizer
            return (
              <motion.div
                key={section.field}
                initial={{ opacity: 0, y: 8 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: i * 0.06, duration: 0.25 }}
              >
                <Paper
                  elevation={0}
                  sx={{
                    p: 2,
                    mb: 1.5,
                    border: locked ? '1px solid #FFE0B2' : '1px solid #F0F0F0',
                    borderRadius: 3,
                    bgcolor: locked ? '#FFFAF5' : '#FFFFFF',
                    cursor: locked ? 'pointer' : 'default',
                  }}
                  onClick={locked ? () => setPaywallOpen(true) : undefined}
                >
                  <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75, mb: 1.25 }}>
                    <Typography variant="caption" sx={{ fontWeight: 700, color: locked ? '#FF7A18' : 'rgba(0,0,0,0.4)', textTransform: 'uppercase', letterSpacing: '0.08em', fontSize: '0.72rem' }}>
                      {section.label}
                    </Typography>
                    {locked && <Lock sx={{ fontSize: 13, color: '#FF7A18' }} />}
                    {locked && (
                      <Typography variant="caption" sx={{ color: '#FF7A18', fontSize: '0.68rem', fontWeight: 600 }}>
                        Premium
                      </Typography>
                    )}
                  </Box>
                  <Tooltip title={locked ? t('randomizer_premium_tooltip') : ''} placement="top">
                    <Box sx={{ opacity: locked ? 0.45 : 1, pointerEvents: locked ? 'none' : 'auto' }}>
                      <ToggleButtonGroup
                        value={focus[section.field]}
                        exclusive
                        onChange={(_, v) => v && update({ [section.field]: v })}
                        sx={{ flexWrap: 'wrap', gap: 0.75 }}
                      >
                        {section.options.map((opt) => (
                          <ToggleButton key={opt.v} value={opt.v} {...toggleProps}>
                            {opt.l}
                          </ToggleButton>
                        ))}
                      </ToggleButtonGroup>
                    </Box>
                  </Tooltip>
                </Paper>
              </motion.div>
            )
          })}

          {/* Вегетарианское — Premium */}
          <Paper
            elevation={0}
            sx={{
              p: 2,
              mb: 3,
              border: !isFullRandomizer ? '1px solid #FFE0B2' : '1px solid #F0F0F0',
              borderRadius: 3,
              bgcolor: !isFullRandomizer ? '#FFFAF5' : '#FFFFFF',
              cursor: !isFullRandomizer ? 'pointer' : 'default',
            }}
            onClick={!isFullRandomizer ? () => setPaywallOpen(true) : undefined}
          >
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.75, mb: 0.5 }}>
              {!isFullRandomizer && <Lock sx={{ fontSize: 13, color: '#FF7A18' }} />}
              {!isFullRandomizer && (
                <Typography variant="caption" sx={{ color: '#FF7A18', fontSize: '0.68rem', fontWeight: 600 }}>
                  Premium
                </Typography>
              )}
            </Box>
            <Box sx={{ opacity: !isFullRandomizer ? 0.45 : 1, pointerEvents: !isFullRandomizer ? 'none' : 'auto' }}>
              <FormControlLabel
                control={
                  <Switch
                    checked={focus.vegetarianOnly}
                    onChange={(e) => update({ vegetarianOnly: e.target.checked })}
                    disabled={!isFullRandomizer}
                  />
                }
                label={<Typography variant="body2" sx={{ fontWeight: 500, color: '#1A1A1A' }}>{t('randomizer_vegetarian_only')}</Typography>}
              />
            </Box>
          </Paper>

          <motion.div whileTap={{ scale: 0.97 }}>
            <Button
              variant="contained"
              size="large"
              onClick={handleStart}
              startIcon={<Casino />}
              fullWidth
              sx={{ py: 1.75, fontSize: '1rem', borderRadius: 3 }}
            >
              {t('randomizer_go')}
            </Button>
          </motion.div>

          {!isFullRandomizer && (
            <Box sx={{ mt: 2, display: 'flex', justifyContent: 'center' }}>
              <PremiumHint
                variant="chip"
                text={t('randomizer_hint')}
                paywallReason={t('randomizer_premium_reason')}
              />
            </Box>
          )}
        </Box>
      </motion.div>

      <PaywallModal
        open={paywallOpen}
        onClose={() => setPaywallOpen(false)}
        onLoginRequired={openAuth}
        reason={t('randomizer_premium_reason')}
      />
    </>
  )
}
