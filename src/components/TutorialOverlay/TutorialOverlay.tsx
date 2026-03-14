import { useState } from 'react'
import { Box, Typography, Button } from '@mui/material'
import { CameraAlt, Favorite, CalendarMonth } from '@mui/icons-material'
import { motion, AnimatePresence } from 'framer-motion'
import { setTutorialSeen } from './tutorialStorage'

const steps = [
  {
    icon: CameraAlt,
    title: 'Сфоткай холодильник',
    text: 'Нажми на большую синюю кнопку и сфотографируй продукты — приложение само определит ингредиенты.',
  },
  {
    icon: Favorite,
    title: 'Свайпай рецепты',
    text: 'Листай карточки влево и вправо: нравится — вправо, не подходит — влево. В конце увидишь подборку по вкусу.',
  },
  {
    icon: CalendarMonth,
    title: 'Планируй неделю',
    text: 'Выбери блюда на каждый день в планировщике и собери список покупок одним тапом.',
  },
]

interface TutorialOverlayProps {
  onClose: () => void
}

export default function TutorialOverlay({ onClose }: TutorialOverlayProps) {
  const [step, setStep] = useState(0)
  const [exiting, setExiting] = useState(false)

  const handleClose = () => {
    setExiting(true)
    setTutorialSeen()
    setTimeout(() => {
      onClose()
    }, 300)
  }

  const isLast = step === steps.length - 1
  const StepIcon = steps[step].icon

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: exiting ? 0 : 1 }}
      exit={{ opacity: 0 }}
      transition={{ duration: 0.3 }}
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 1300,
        background: 'rgba(255,255,255,0.92)',
        backdropFilter: 'blur(12px)',
        WebkitBackdropFilter: 'blur(12px)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 32,
      }}
    >
      <Box sx={{ maxWidth: 360, width: '100%', textAlign: 'center' }}>
        <AnimatePresence mode="wait">
          <motion.div
            key={step}
            initial={{ opacity: 0, x: 12 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -12 }}
            transition={{ duration: 0.3 }}
          >
            <Box
              sx={{
                width: 72,
                height: 72,
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                color: '#fff',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                mx: 'auto',
                mb: 2,
              }}
            >
              <StepIcon sx={{ fontSize: 36 }} />
            </Box>
            <Typography variant="h6" sx={{ fontWeight: 700, color: '#1C1C1E', mb: 1 }}>
              {steps[step].title}
            </Typography>
            <Typography variant="body2" sx={{ color: 'rgba(28,28,30,0.7)', mb: 3, lineHeight: 1.5 }}>
              {steps[step].text}
            </Typography>
          </motion.div>
        </AnimatePresence>

        <Box sx={{ display: 'flex', gap: 1, justifyContent: 'center', mb: 2 }}>
          {steps.map((_, i) => (
            <Box
              key={i}
              sx={{
                width: 8,
                height: 8,
                borderRadius: '50%',
                bgcolor: i === step ? '#FF7A18' : '#E9E9E9',
                transition: 'background 0.2s',
              }}
            />
          ))}
        </Box>

        <Box sx={{ display: 'flex', gap: 2, justifyContent: 'center', flexWrap: 'wrap' }}>
          {step > 0 && (
            <Button variant="text" onClick={() => setStep((s) => s - 1)} sx={{ color: '#6C6C70', textTransform: 'none' }}>
              Назад
            </Button>
          )}
          {isLast ? (
            <Button variant="contained" onClick={handleClose} sx={{ background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)', borderRadius: 3, textTransform: 'none', px: 3 }}>
              Понял
            </Button>
          ) : (
            <Button variant="contained" onClick={() => setStep((s) => s + 1)} sx={{ background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)', borderRadius: 3, textTransform: 'none', px: 3 }}>
              Дальше
            </Button>
          )}
        </Box>
      </Box>
    </motion.div>
  )
}
