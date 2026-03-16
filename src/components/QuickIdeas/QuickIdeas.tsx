import { useEffect, useState, useRef, useCallback } from 'react'
import { Box, Typography, Chip, ButtonBase, Skeleton, IconButton } from '@mui/material'
import { AccessTime, ChevronLeft, ChevronRight } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { Dish } from '../../types'
import { getQuickDishes, getDishOfDay } from '../../services/dishes'
import { getDishImageUrl, getDishSvgFallback } from '../../utils/imageUtils'
import { useLanguage } from '../../hooks/useLanguage'
import { dishName } from '../../utils/lang'

const CARD_WIDTH = 150
const CARD_GAP = 12
const SCROLL_STEP = (CARD_WIDTH + CARD_GAP) * 3

interface QuickIdeasProps {
  onDishSelect: (dishId: number) => void
  onCuisineSelect?: (cuisine: string) => void
}

function CarouselArrow({
  direction,
  onClick,
  visible,
}: {
  direction: 'left' | 'right'
  onClick: () => void
  visible: boolean
}) {
  return (
    <IconButton
      onClick={onClick}
      size="small"
      sx={{
        width: 28,
        height: 28,
        bgcolor: 'white',
        border: '1px solid #E9E9E9',
        boxShadow: '0 2px 8px rgba(0,0,0,0.10)',
        color: '#1A1A1A',
        opacity: visible ? 1 : 0,
        pointerEvents: visible ? 'auto' : 'none',
        transition: 'opacity 0.2s, background 0.15s',
        '&:hover': { bgcolor: '#FFF3E0', borderColor: '#FF7A18', color: '#FF7A18' },
        '& svg': { fontSize: 18 },
      }}
    >
      {direction === 'left' ? <ChevronLeft /> : <ChevronRight />}
    </IconButton>
  )
}

export default function QuickIdeas({ onDishSelect, onCuisineSelect }: QuickIdeasProps) {
  const { t, lang } = useLanguage()
  const [dishOfDay, setDishOfDay] = useState<Dish | null>(null)
  const [quickDishes, setQuickDishes] = useState<Dish[]>([])
  const [loading, setLoading] = useState(true)
  const [canScrollLeft, setCanScrollLeft] = useState(false)
  const [canScrollRight, setCanScrollRight] = useState(false)
  const scrollRef = useRef<HTMLDivElement>(null)

  const CUISINE_TILES = [
    { key: 'russian',          label: t('quick_cuisine_russian'),          emoji: '🥘', from: '#FF6B6B', to: '#EE4545' },
    { key: 'italian',          label: t('quick_cuisine_italian'),          emoji: '🍝', from: '#FF9A3C', to: '#E07B00' },
    { key: 'asian',            label: t('quick_cuisine_asian'),            emoji: '🍜', from: '#4ECDC4', to: '#2BAF9E' },
    { key: 'eastern_european', label: t('quick_cuisine_eastern_european'), emoji: '🫕', from: '#A78BFA', to: '#7C3AED' },
    { key: 'mediterranean',    label: t('quick_cuisine_mediterranean'),    emoji: '🫒', from: '#6EE7B7', to: '#10B981' },
    { key: 'any',              label: t('quick_cuisine_all'),              emoji: '🌍', from: '#94A3B8', to: '#64748B' },
  ]

  useEffect(() => {
    let cancelled = false
    Promise.all([getDishOfDay(), getQuickDishes(50)]).then(([dod, quick]) => {
      if (!cancelled) {
        setDishOfDay(dod)
        setQuickDishes(quick)
        setLoading(false)
      }
    })
    return () => { cancelled = true }
  }, [])

  const updateScrollState = useCallback(() => {
    const el = scrollRef.current
    if (!el) return
    setCanScrollLeft(el.scrollLeft > 4)
    setCanScrollRight(el.scrollLeft < el.scrollWidth - el.clientWidth - 4)
  }, [])

  useEffect(() => {
    const el = scrollRef.current
    if (!el) return
    updateScrollState()
    el.addEventListener('scroll', updateScrollState, { passive: true })
    const ro = new ResizeObserver(updateScrollState)
    ro.observe(el)
    return () => {
      el.removeEventListener('scroll', updateScrollState)
      ro.disconnect()
    }
  }, [quickDishes, updateScrollState])

  const scrollLeft = () => {
    scrollRef.current?.scrollBy({ left: -SCROLL_STEP, behavior: 'smooth' })
  }
  const scrollRight = () => {
    scrollRef.current?.scrollBy({ left: SCROLL_STEP, behavior: 'smooth' })
  }

  if (loading) {
    return (
      <Box>
        <Skeleton variant="text" width={160} height={28} sx={{ mb: 1.5 }} />
        <Skeleton variant="rounded" height={130} sx={{ borderRadius: 3, mb: 2 }} />
        <Skeleton variant="text" width={140} height={22} sx={{ mb: 1 }} />
        <Box sx={{ display: 'flex', gap: 1.5 }}>
          {[...Array(4)].map((_, i) => (
            <Skeleton key={i} variant="rounded" width={CARD_WIDTH} height={120} sx={{ borderRadius: 2, flexShrink: 0 }} />
          ))}
        </Box>
      </Box>
    )
  }

  if (!dishOfDay && quickDishes.length === 0) return null

  return (
    <motion.div
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.4 }}
    >
      <Typography variant="h6" sx={{ fontWeight: 700, color: '#1A1A1A', mb: 1.5, fontSize: '1rem' }}>
        {t('quick_ideas_title')}
      </Typography>

      {/* Блюдо дня */}
      {dishOfDay && (
        <ButtonBase
          onClick={() => onDishSelect(dishOfDay.id)}
          sx={{ width: '100%', borderRadius: 3, mb: 2, display: 'block', textAlign: 'left' }}
        >
          <Box
            sx={{
              borderRadius: 3,
              overflow: 'hidden',
              border: '1px solid #E9E9E9',
              bgcolor: '#fff',
              boxShadow: '0 2px 8px rgba(0,0,0,0.06)',
            }}
          >
            <Box
              component="img"
              src={getDishImageUrl(dishOfDay.name, dishOfDay.image_url)}
              alt={dishOfDay.name}
              sx={{ width: '100%', height: 130, objectFit: 'cover', display: 'block' }}
              onError={(e) => {
                e.currentTarget.onerror = null
                e.currentTarget.src = getDishSvgFallback(dishOfDay.name)
              }}
            />
            <Box sx={{ px: 1.5, py: 1.25, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
              <Box>
                <Typography variant="body2" sx={{ color: '#FF7A18', fontWeight: 600, fontSize: '0.72rem', mb: 0.25 }}>
                  {t('quick_dish_of_day')}
                </Typography>
                <Typography variant="body1" sx={{ fontWeight: 700, color: '#1A1A1A', fontSize: '0.95rem', lineHeight: 1.2 }}>
                  {dishName(dishOfDay, lang)}
                </Typography>
              </Box>
              <Chip
                icon={<AccessTime sx={{ fontSize: '12px !important' }} />}
                label={`${dishOfDay.cooking_time} ${t('min')}`}
                size="small"
                sx={{ fontSize: '0.72rem', height: 24, bgcolor: '#FFF3E0', color: '#E65100', border: 'none' }}
              />
            </Box>
          </Box>
        </ButtonBase>
      )}

      {/* Карусель "Быстро приготовить" */}
      {quickDishes.length > 0 && (
        <>
          {/* Заголовок + стрелки */}
          <Box sx={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', mb: 1 }}>
            <Typography variant="body2" sx={{ fontWeight: 600, color: 'rgba(0,0,0,0.55)', fontSize: '0.82rem' }}>
              {t('quick_fast')}
            </Typography>
            <Box sx={{ display: 'flex', gap: 0.5 }}>
              <CarouselArrow direction="left" onClick={scrollLeft} visible={canScrollLeft} />
              <CarouselArrow direction="right" onClick={scrollRight} visible={canScrollRight} />
            </Box>
          </Box>

          {/* Полоса прокрутки */}
          <Box
            ref={scrollRef}
            sx={{
              display: 'flex',
              gap: `${CARD_GAP}px`,
              overflowX: 'auto',
              pb: 0.5,
              mx: -0.5,
              px: 0.5,
              scrollSnapType: 'x mandatory',
              '&::-webkit-scrollbar': { display: 'none' },
              scrollbarWidth: 'none',
            }}
          >
            {quickDishes.map((dish) => (
              <ButtonBase
                key={dish.id}
                onClick={() => onDishSelect(dish.id)}
                sx={{
                  width: CARD_WIDTH,
                  flexShrink: 0,
                  scrollSnapAlign: 'start',
                  borderRadius: 2,
                  overflow: 'hidden',
                  border: '1px solid #E9E9E9',
                  bgcolor: '#fff',
                  boxShadow: '0 1px 4px rgba(0,0,0,0.05)',
                  display: 'block',
                  textAlign: 'left',
                  transition: 'box-shadow 0.15s',
                  '&:hover': { boxShadow: '0 3px 12px rgba(0,0,0,0.10)' },
                }}
              >
                <Box
                  component="img"
                  src={getDishImageUrl(dish.name, dish.image_url)}
                  alt={dishName(dish, lang)}
                  sx={{ width: '100%', height: 90, objectFit: 'cover', display: 'block' }}
                  onError={(e) => {
                    e.currentTarget.onerror = null
                    e.currentTarget.src = getDishSvgFallback(dish.name)
                  }}
                />
                <Box sx={{ p: 0.75 }}>
                  <Typography
                    variant="caption"
                    sx={{
                      fontWeight: 600,
                      color: '#1A1A1A',
                      fontSize: '0.75rem',
                      lineHeight: 1.3,
                      display: '-webkit-box',
                      WebkitLineClamp: 2,
                      WebkitBoxOrient: 'vertical',
                      overflow: 'hidden',
                    }}
                  >
                    {dishName(dish, lang)}
                  </Typography>
                  <Typography variant="caption" sx={{ color: 'rgba(0,0,0,0.35)', fontSize: '0.68rem' }}>
                    {dish.cooking_time} {t('min')}
                  </Typography>
                </Box>
              </ButtonBase>
            ))}
          </Box>

          <Typography variant="caption" sx={{ color: 'rgba(0,0,0,0.28)', fontSize: '0.7rem', display: 'block', mt: 0.75, mb: 2 }}>
            {quickDishes.length} {t('quick_dishes_swipe')} →
          </Typography>
        </>
      )}

      {/* Секция "По кухням" */}
      {onCuisineSelect && (
        <>
          <Typography variant="body2" sx={{ fontWeight: 600, color: 'rgba(0,0,0,0.55)', fontSize: '0.82rem', mb: 1 }}>
            {t('quick_by_cuisine')}
          </Typography>
          <Box
            sx={{
              display: 'grid',
              gridTemplateColumns: 'repeat(3, 1fr)',
              gap: 1.5,
            }}
          >
            {CUISINE_TILES.map((tile) => (
              <ButtonBase
                key={tile.key}
                onClick={() => onCuisineSelect(tile.key)}
                sx={{
                  height: 64,
                  borderRadius: 2,
                  overflow: 'hidden',
                  background: `linear-gradient(135deg, ${tile.from} 0%, ${tile.to} 100%)`,
                  display: 'flex',
                  flexDirection: 'column',
                  alignItems: 'center',
                  justifyContent: 'center',
                  gap: 0.5,
                  boxShadow: '0 2px 8px rgba(0,0,0,0.1)',
                  transition: 'transform 0.15s, box-shadow 0.15s',
                  '&:hover': { transform: 'translateY(-1px)', boxShadow: '0 4px 14px rgba(0,0,0,0.16)' },
                }}
              >
                <Typography sx={{ fontSize: 22, lineHeight: 1 }}>{tile.emoji}</Typography>
                <Typography sx={{ fontSize: '0.67rem', fontWeight: 600, color: 'white', lineHeight: 1.2, textAlign: 'center', px: 0.5 }}>
                  {tile.label}
                </Typography>
              </ButtonBase>
            ))}
          </Box>
        </>
      )}
    </motion.div>
  )
}
