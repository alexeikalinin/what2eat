import { useRef, useState, useCallback, useEffect } from 'react'
import TinderCard from 'react-tinder-card'
import { motion, AnimatePresence } from 'framer-motion'

const btnContainerVariants = {
  hidden: {},
  visible: { transition: { staggerChildren: 0.09, delayChildren: 0.5 } },
}
const btnItemVariant = {
  hidden: { opacity: 0, y: 24, scale: 0.6 },
  visible: { opacity: 1, y: 0, scale: 1, transition: { type: 'spring' as const, stiffness: 380, damping: 16 } },
}

interface CardAPI {
  swipe(dir?: string): Promise<void>
  restoreCard(): Promise<void>
}
import { Box, Typography, IconButton, Button, CircularProgress } from '@mui/material'
import { Close, Favorite, ArrowBack, Info, Restaurant } from '@mui/icons-material'
import { Dish } from '../../types'
import { useAppDispatch, useAppSelector } from '../../hooks/redux'
import { swipeDish, markSessionComplete, resetSwipe } from '../../store/slices/swipeSlice'
import { incrementSwipeUsage } from '../../store/slices/userSlice'
import { fetchSuggestedDishes } from '../../store/slices/dishesSlice'
import SwipeCard from './SwipeCard'
import { usePlan } from '../../hooks/usePlan'
import PaywallModal from '../PaywallModal'
import { useModalContext } from '../../contexts/ModalContext'

interface SwipeDeckProps {
  dishes: Dish[]
  loading?: boolean
  onDishSelect: (dishId: number) => void
  onComplete: () => void
  onBack: () => void
}

export default function SwipeDeck({ dishes, loading = false, onDishSelect, onComplete, onBack }: SwipeDeckProps) {
  const dispatch = useAppDispatch()
  const { currentIndex } = useAppSelector((state) => state.swipe)
  const { suggestedDishNames, searchComplete } = useAppSelector((state) => state.dishes)
  const { ingredients, selectedIngredients } = useAppSelector((state) => state.ingredients)
  const [swipeDirection, setSwipeDirection] = useState<Record<number, 'left' | 'right'>>({})
  const [paywallOpen, setPaywallOpen] = useState(false)

  const { canSwipe, swipesRemaining, trackLocalSwipe, isPremium, DAILY_SWIPE_LIMIT } = usePlan()
  const { openAuth } = useModalContext()

  const selectedNamesKey = ingredients
    .filter((i) => selectedIngredients.includes(i.id))
    .map((i) => i.name)
    .join(',')

  useEffect(() => {
    const selectedNames = selectedNamesKey.split(',').filter(Boolean)
    if (dishes.length === 0 && selectedNames.length > 0 && suggestedDishNames.length === 0) {
      dispatch(fetchSuggestedDishes(selectedNames))
    }
  }, [dishes.length, selectedNamesKey, dispatch, suggestedDishNames.length])

  const cardRefsStore = useRef<(CardAPI | null)[]>([])
  while (cardRefsStore.current.length < dishes.length) cardRefsStore.current.push(null)

  const getCardRef = (index: number) => (el: CardAPI | null) => {
    cardRefsStore.current[index] = el
  }

  const remaining = dishes.length - currentIndex

  const handleSwipe = useCallback(
    (direction: string, dishId: number) => {
      const dir = direction === 'right' ? 'right' : 'left'
      dispatch(swipeDish({ dishId, direction: dir }))
      dispatch(incrementSwipeUsage())
      trackLocalSwipe()
      setSwipeDirection(prev => ({ ...prev, [dishId]: dir }))
    },
    [dispatch, trackLocalSwipe]
  )

  const swipe = (dir: 'left' | 'right') => {
    if (!canSwipe()) {
      setPaywallOpen(true)
      return
    }
    const dishId = dishes[currentIndex]?.id
    if (dishId) setSwipeDirection(prev => ({ ...prev, [dishId]: dir }))
    const card = cardRefsStore.current[currentIndex]
    if (card) card.swipe(dir)
  }

  const handleInfoClick = () => {
    if (currentIndex < dishes.length) {
      onDishSelect(dishes[currentIndex].id)
    }
  }

  const handleReset = () => {
    dispatch(resetSwipe())
  }

  // Show spinner while loading OR before first search completes (prevents "nothing found" flash)
  if (loading || !searchComplete) {
    return (
      <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', py: 10, gap: 2 }}>
        <CircularProgress sx={{ color: '#FF7A18' }} />
        <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.45)' }}>Ищем подходящие блюда…</Typography>
      </Box>
    )
  }

  if (dishes.length === 0) {
    return (
      <Box sx={{ textAlign: 'center', py: 8, px: 2 }}>
        <Box
          sx={{
            width: 72,
            height: 72,
            borderRadius: '50%',
            bgcolor: '#FFF3E0',
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            mx: 'auto',
            mb: 2,
          }}
        >
          <Restaurant sx={{ color: '#FF7A18', fontSize: 36 }} />
        </Box>
        <Typography variant="h5" sx={{ color: '#1A1A1A', fontWeight: 700, mb: 1 }}>
          Ничего не нашлось
        </Typography>
        <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.5)', mb: 3 }}>
          Попробуйте выбрать другие ингредиенты
        </Typography>
        {suggestedDishNames.length > 0 && (
          <Box
            sx={{
              mb: 3,
              textAlign: 'left',
              maxWidth: 360,
              mx: 'auto',
              bgcolor: '#FFF8F0',
              border: '1px solid #FFE0B2',
              borderRadius: 3,
              p: 2,
            }}
          >
            <Typography variant="subtitle2" sx={{ color: '#FF7A18', mb: 1, fontWeight: 600 }}>
              ИИ предлагает приготовить:
            </Typography>
            <Box component="ul" sx={{ m: 0, pl: 2.5, color: '#1A1A1A', lineHeight: 2 }}>
              {suggestedDishNames.map((name) => (
                <li key={name}><Typography variant="body2">{name}</Typography></li>
              ))}
            </Box>
          </Box>
        )}
        <Button variant="contained" onClick={onBack} startIcon={<ArrowBack />}>
          Изменить ингредиенты
        </Button>
      </Box>
    )
  }

  return (
    <>
      <Box sx={{ display: 'flex', flexDirection: 'column', alignItems: 'center' }}>
        {/* Header */}
        <Box sx={{ width: '100%', display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
          <Button
            variant="text"
            onClick={onBack}
            startIcon={<ArrowBack />}
            size="small"
            sx={{ color: 'rgba(0,0,0,0.45)', fontWeight: 500 }}
          >
            Назад
          </Button>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            {!isPremium && (
              <Box
                onClick={() => setPaywallOpen(true)}
                sx={{
                  bgcolor: canSwipe() ? '#FFF3E0' : '#FFF1F0',
                  borderRadius: 10,
                  px: 1.5,
                  py: 0.5,
                  cursor: 'pointer',
                }}
              >
                <Typography
                  variant="caption"
                  sx={{
                    color: canSwipe() ? 'rgba(0,0,0,0.45)' : '#FF4D4D',
                    fontWeight: 600,
                    fontSize: '0.75rem',
                  }}
                >
                  {canSwipe() ? `Свайпов: ${swipesRemaining()}/${DAILY_SWIPE_LIMIT}` : 'Лимит исчерпан'}
                </Typography>
              </Box>
            )}
            <Box
              sx={{
                bgcolor: remaining > 0 ? 'rgba(255,122,24,0.08)' : 'rgba(34,197,94,0.12)',
                borderRadius: 10,
                px: 1.5,
                py: 0.5,
                border: `1px solid ${remaining > 0 ? 'rgba(255,122,24,0.2)' : 'rgba(34,197,94,0.25)'}`,
              }}
            >
              <Typography
                variant="caption"
                sx={{
                  color: remaining > 0 ? 'text.secondary' : '#22C55E',
                  fontWeight: 600,
                  fontSize: '0.8rem',
                  letterSpacing: '0.05em',
                  textTransform: 'uppercase',
                }}
              >
                {remaining > 0 ? `Осталось: ${remaining}` : 'Всё просмотрено'}
              </Typography>
            </Box>
          </Box>
          <Button
            variant="text"
            onClick={handleReset}
            size="small"
            sx={{ color: 'rgba(0,0,0,0.35)', fontSize: '0.8rem' }}
          >
            Сначала
          </Button>
        </Box>

        {/* Card stack с подсветкой как в TashaD16 */}
        <Box
          sx={{
            position: 'relative',
            width: '100%',
            maxWidth: 420,
            height: 520,
            mb: 3.5,
            '&::before': {
              content: '""',
              position: 'absolute',
              inset: -24,
              borderRadius: 36,
              background: 'radial-gradient(ellipse 85% 65% at 50% 50%, rgba(34,197,94,0.08) 0%, transparent 65%)',
              pointerEvents: 'none',
            },
            '&::after': {
              content: '""',
              position: 'absolute',
              inset: -12,
              borderRadius: 28,
              background: 'radial-gradient(ellipse 70% 55% at 50% 50%, rgba(34,197,94,0.04) 0%, transparent 70%)',
              pointerEvents: 'none',
              animation: 'swipeGlowPulse 4s ease-in-out infinite',
            },
            '@keyframes swipeGlowPulse': {
              '0%, 100%': { opacity: 1 },
              '50%': { opacity: 0.6 },
            },
          }}
        >
          {remaining === 0 ? (
            <Box
              sx={{
                width: '100%',
                height: '100%',
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                justifyContent: 'center',
                bgcolor: '#FFFFFF',
                borderRadius: '24px',
                boxShadow: '0 10px 30px rgba(0,0,0,0.08)',
                gap: 2,
              }}
            >
              <Box sx={{ fontSize: '3rem' }}>🎉</Box>
              <Typography variant="h5" sx={{ fontWeight: 700, color: '#1A1A1A', textAlign: 'center' }}>
                Вы просмотрели все блюда!
              </Typography>
              <Button variant="contained" onClick={onComplete} size="large" sx={{ px: 4 }}>
                Посмотреть результаты
              </Button>
            </Box>
          ) : (
            <AnimatePresence initial={false}>
              {dishes.map((dish, index) => {
                if (index < currentIndex) return null
                const offset = index - currentIndex
                return (
                  <motion.div
                    key={dish.id}
                    initial={{ opacity: 0, scale: 0.92 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ type: 'spring', stiffness: 320, damping: 24 }}
                    style={{
                      position: 'absolute',
                      width: '100%',
                      height: '100%',
                      zIndex: dishes.length - index,
                      transform: offset === 0 ? 'none' : `translateY(${offset * 8}px) scale(${1 - offset * 0.04})`,
                      transition: 'transform 0.3s ease',
                      pointerEvents: offset === 0 ? 'auto' : 'none',
                      transformOrigin: 'bottom center',
                    }}
                    data-testid="swipe-card"
                  >
                    <TinderCard
                    ref={getCardRef(index)}
                    onSwipe={(dir) => handleSwipe(dir, dish.id)}
                    onCardLeftScreen={() => {
                      if (index === dishes.length - 1) {
                        dispatch(markSessionComplete())
                        onComplete()
                      }
                    }}
                    preventSwipe={['up', 'down']}
                    swipeRequirementType="position"
                    swipeThreshold={80}
                  >
                    <Box sx={{ width: '100%', height: 520 }}>
                      <SwipeCard
                        dish={dish}
                        swipeDirection={swipeDirection[dish.id] ?? null}
                      />
                    </Box>
                  </TinderCard>
                </motion.div>
              )
            })}
            </AnimatePresence>
          )}
        </Box>

        {/* Кнопки с анимацией появления (stagger + spring) как в TashaD16 */}
        {remaining > 0 && (
          <motion.div
            variants={btnContainerVariants}
            initial="hidden"
            animate="visible"
            style={{ display: 'flex', gap: 24, alignItems: 'center', marginBottom: 16, position: 'relative', zIndex: 1000 }}
          >
            {/* Reject */}
            <motion.div variants={btnItemVariant} whileHover={{ scale: 1.08 }} whileTap={{ scale: 0.92 }}>
              <IconButton
                onClick={() => swipe('left')}
                sx={{
                  width: 68,
                  height: 68,
                  borderRadius: '50%',
                  background: 'rgba(255,77,77,0.28)',
                  border: '2px solid rgba(255,77,77,0.75)',
                  color: '#FF4D4D',
                  boxShadow: '0 4px 16px rgba(255,77,77,0.35), 0 0 40px rgba(255,77,77,0.22)',
                  transition: 'box-shadow 0.25s ease, background 0.25s ease',
                  '&:hover': {
                    background: 'rgba(255,77,77,0.40)',
                    boxShadow: '0 4px 20px rgba(255,77,77,0.50), 0 0 60px rgba(255,77,77,0.30)',
                  },
                }}
              >
                <Close sx={{ fontSize: 28 }} />
              </IconButton>
            </motion.div>

            {/* Info */}
            <motion.div variants={btnItemVariant} whileHover={{ scale: 1.08 }} whileTap={{ scale: 0.92 }}>
              <IconButton
                onClick={handleInfoClick}
                sx={{
                  width: 48,
                  height: 48,
                  borderRadius: '50%',
                  bgcolor: 'rgba(255,255,255,0.9)',
                  border: '2px solid rgba(99,102,241,0.4)',
                  color: '#6366F1',
                  boxShadow: '0 4px 16px rgba(99,102,241,0.2), 0 0 24px rgba(99,102,241,0.12)',
                  transition: 'box-shadow 0.25s ease',
                  '&:hover': {
                    boxShadow: '0 4px 20px rgba(99,102,241,0.35), 0 0 36px rgba(99,102,241,0.18)',
                  },
                }}
              >
                <Info sx={{ fontSize: 22 }} />
              </IconButton>
            </motion.div>

            {/* Like */}
            <motion.div variants={btnItemVariant} whileHover={{ scale: 1.08 }} whileTap={{ scale: 0.92 }}>
              <IconButton
                onClick={() => swipe('right')}
                sx={{
                  width: 68,
                  height: 68,
                  borderRadius: '50%',
                  background: 'rgba(34,197,94,0.28)',
                  border: '2px solid rgba(34,197,94,0.75)',
                  color: '#22C55E',
                  boxShadow: '0 4px 16px rgba(34,197,94,0.35), 0 0 40px rgba(34,197,94,0.22)',
                  transition: 'box-shadow 0.25s ease, background 0.25s ease',
                  '&:hover': {
                    background: 'rgba(34,197,94,0.40)',
                    boxShadow: '0 4px 20px rgba(34,197,94,0.50), 0 0 60px rgba(34,197,94,0.30)',
                  },
                }}
              >
                <Favorite sx={{ fontSize: 28 }} />
              </IconButton>
            </motion.div>
          </motion.div>
        )}
      </Box>

      <PaywallModal
        open={paywallOpen}
        onClose={() => setPaywallOpen(false)}
        onLoginRequired={openAuth}
        reason="Свайп-колода: 10 карточек в день бесплатно. Premium — без ограничений."
      />
    </>
  )
}
