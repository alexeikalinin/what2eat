import {
  Card,
  CardContent,
  CardMedia,
  Typography,
  Box,
  Chip,
  Button,
  IconButton,
} from '@mui/material'
import { AccessTime, People, AttachMoney, ShoppingCart, FavoriteBorder, Favorite } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useState } from 'react'
import { Dish, Difficulty } from '../../types'
import { DIFFICULTY_LABELS, DIFFICULTY_COLORS } from '../../utils/constants'
import { getDishImageUrl } from '../../utils/imageUtils'

interface DishCardProps {
  dish: Dish
  onSelect: (dishId: number) => void
}

export default function DishCard({ dish, onSelect }: DishCardProps) {
  const [liked, setLiked] = useState(false)

  const getDifficultyColor = (difficulty: Difficulty) => {
    return DIFFICULTY_COLORS[difficulty] || DIFFICULTY_COLORS.easy
  }

  const imageUrl = getDishImageUrl(dish.name, dish.image_url)

  return (
    <motion.div
      whileHover={{ y: -4, transition: { type: 'spring', stiffness: 300, damping: 20 } }}
      whileTap={{ scale: 0.98 }}
      style={{ height: '100%' }}
    >
      <Card
        sx={{
          height: '100%',
          display: 'flex',
          flexDirection: 'column',
          overflow: 'hidden',
          borderRadius: 3,
          border: '1px solid rgba(255,122,24,0.18)',
          boxShadow: '0 4px 20px rgba(255,122,24,0.08), 0 2px 8px rgba(0,0,0,0.04)',
        }}
      >
        {/* Image with heart */}
        <Box sx={{ position: 'relative' }}>
          <CardMedia
            component="img"
            image={imageUrl}
            alt={dish.name}
            sx={{ height: 200, objectFit: 'cover' }}
          />
          {/* Heart icon top-right */}
          <motion.div
            style={{ position: 'absolute', top: 10, right: 10 }}
            animate={liked ? { scale: [1, 1.35, 1] } : {}}
            transition={{ type: 'spring', stiffness: 400, damping: 10 }}
          >
            <IconButton
              size="small"
              onClick={(e) => { e.stopPropagation(); setLiked((v) => !v) }}
              sx={{
                bgcolor: 'rgba(255,255,255,0.92)',
                backdropFilter: 'blur(6px)',
                width: 36,
                height: 36,
                borderRadius: '50%',
                '&:hover': { bgcolor: 'white' },
              }}
            >
              {liked
                ? <Favorite sx={{ fontSize: 18, color: '#FF4D4D' }} />
                : <FavoriteBorder sx={{ fontSize: 18, color: 'rgba(0,0,0,0.4)' }} />
              }
            </IconButton>
          </motion.div>
        </Box>

        <CardContent sx={{ flexGrow: 1, display: 'flex', flexDirection: 'column', p: 2 }}>
          <Typography
            variant="h6"
            component="h3"
            sx={{ fontWeight: 700, lineHeight: 1.3, color: '#1A1A1A', mb: 0.75, fontSize: '1rem' }}
          >
            {dish.name}
          </Typography>
          {dish.description && (
            <Typography
              variant="body2"
              sx={{ color: 'rgba(0,0,0,0.5)', mb: 1.5, flexGrow: 1, lineHeight: 1.5,
                display: '-webkit-box', WebkitLineClamp: 2, WebkitBoxOrient: 'vertical', overflow: 'hidden' }}
            >
              {dish.description}
            </Typography>
          )}

          {/* Meta chips — оформление как в TashaD16, палитра проекта */}
          <Box sx={{ display: 'flex', gap: 0.75, mb: 1.5, flexWrap: 'wrap' }}>
            <Chip
              icon={<AccessTime sx={{ fontSize: '13px !important' }} />}
              label={`${dish.cooking_time} мин`}
              size="small"
              variant="outlined"
              sx={{ bgcolor: 'rgba(255,243,224,0.6)', color: '#E86A08', border: '1px solid rgba(255,122,24,0.28)', fontWeight: 600, fontSize: '0.77rem' }}
            />
            <Chip
              icon={<People sx={{ fontSize: '13px !important' }} />}
              label={`${dish.servings} порц.`}
              size="small"
              variant="outlined"
              sx={{ bgcolor: 'rgba(255,255,255,0.8)', color: 'rgba(0,0,0,0.55)', border: '1px solid rgba(255,122,24,0.18)', fontSize: '0.77rem' }}
            />
            <Chip
              label={DIFFICULTY_LABELS[dish.difficulty]}
              size="small"
              sx={{ bgcolor: getDifficultyColor(dish.difficulty), color: 'white', fontWeight: 700, fontSize: '0.77rem' }}
            />
            {dish.estimated_cost != null && (
              <Chip
                icon={<AttachMoney sx={{ fontSize: '13px !important', color: '#15803d !important' }} />}
                label={`$${dish.estimated_cost.toFixed(0)}`}
                size="small"
                sx={{ bgcolor: 'rgba(34,197,94,0.12)', color: '#15803d', border: '1px solid rgba(34,197,94,0.28)', fontWeight: 600, fontSize: '0.77rem' }}
              />
            )}
            {dish.is_vegan && (
              <Chip label="🌱 Веган" size="small" sx={{ bgcolor: '#F0FDF4', color: '#22C55E', border: 'none', fontSize: '0.77rem' }} />
            )}
            {!dish.is_vegan && dish.is_vegetarian && (
              <Chip label="🥗 Вегетар." size="small" sx={{ bgcolor: '#FFFBEB', color: '#D97706', border: 'none', fontSize: '0.77rem' }} />
            )}
          </Box>

          {dish.missing_ingredients && dish.missing_ingredients.length > 0 && (
            <Box
              sx={{
                display: 'flex',
                alignItems: 'center',
                gap: 0.75,
                mb: 1.5,
                bgcolor: '#FFFBEB',
                border: '1px solid #FDE68A',
                borderRadius: 2,
                px: 1.25,
                py: 0.75,
              }}
            >
              <ShoppingCart sx={{ fontSize: 13, color: '#D97706' }} />
              <Typography variant="caption" sx={{ color: '#D97706', fontWeight: 500 }}>
                Докупить: {dish.missing_ingredients.map(i => i.name).join(', ')}
              </Typography>
            </Box>
          )}

          <Button
            variant="contained"
            fullWidth
            onClick={() => onSelect(dish.id)}
            sx={{
              mt: 'auto',
              py: 1.15,
              fontSize: '0.875rem',
              fontWeight: 700,
              borderRadius: 2,
              boxShadow: '0 4px 14px rgba(255,122,24,0.35)',
              '&:hover': { boxShadow: '0 6px 20px rgba(255,122,24,0.45)' },
            }}
          >
            Посмотреть рецепт
          </Button>
        </CardContent>
      </Card>
    </motion.div>
  )
}
