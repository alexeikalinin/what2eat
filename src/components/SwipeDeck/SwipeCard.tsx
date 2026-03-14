import { Box, Typography, Chip } from '@mui/material'
import { AccessTime, AttachMoney, ShoppingCart } from '@mui/icons-material'
import { Dish } from '../../types'
import { DIFFICULTY_LABELS, DIFFICULTY_COLORS } from '../../utils/constants'
import { getDishImageUrl } from '../../utils/imageUtils'

interface SwipeCardProps {
  dish: Dish
  swipeDirection: 'left' | 'right' | null
}

export default function SwipeCard({ dish, swipeDirection }: SwipeCardProps) {
  const imageUrl = getDishImageUrl(dish.name, dish.image_url)
  const fallbackUrl = getDishImageUrl(dish.name, null)

  return (
    <Box
      sx={{
        position: 'relative',
        width: '100%',
        height: '100%',
        borderRadius: '24px',
        overflow: 'hidden',
        boxShadow: '0 16px 48px rgba(0,0,0,0.2), 0 4px 16px rgba(0,0,0,0.1)',
        cursor: 'grab',
        bgcolor: '#FFFFFF',
        '&:active': { cursor: 'grabbing' },
      }}
    >
      {/* Full-bleed food photo */}
      <Box
        component="img"
        src={imageUrl}
        alt={dish.name}
        onError={(e: React.SyntheticEvent<HTMLImageElement>) => {
          e.currentTarget.src = fallbackUrl
        }}
        sx={{
          position: 'absolute',
          inset: 0,
          width: '100%',
          height: '100%',
          objectFit: 'cover',
          display: 'block',
        }}
      />

      {/* Bottom gradient overlay */}
      <Box
        sx={{
          position: 'absolute',
          bottom: 0,
          left: 0,
          right: 0,
          height: '68%',
          background: 'linear-gradient(to top, rgba(0,0,0,0.88) 0%, rgba(0,0,0,0.55) 45%, transparent 100%)',
        }}
      />

      {/* Content over image */}
      <Box
        sx={{
          position: 'absolute',
          bottom: 0,
          left: 0,
          right: 0,
          p: '20px 20px 24px',
        }}
      >
        <Typography
          variant="h3"
          sx={{
            color: 'white',
            fontWeight: 800,
            fontSize: { xs: '1.4rem', sm: '1.6rem' },
            mb: 1.5,
            lineHeight: 1.15,
            letterSpacing: '-0.025em',
            textShadow: '0 2px 8px rgba(0,0,0,0.3)',
          }}
        >
          {dish.name}
        </Typography>

        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.75 }}>
          <Chip
            icon={<AccessTime sx={{ color: 'rgba(255,255,255,0.85) !important', fontSize: '13px !important' }} />}
            label={`${dish.cooking_time} мин`}
            size="small"
            sx={{
              bgcolor: 'rgba(255,255,255,0.18)',
              color: 'white',
              backdropFilter: 'blur(8px)',
              border: '1px solid rgba(255,255,255,0.22)',
              fontWeight: 500,
              fontSize: '0.78rem',
            }}
          />
          <Chip
            label={DIFFICULTY_LABELS[dish.difficulty]}
            size="small"
            sx={{
              bgcolor: DIFFICULTY_COLORS[dish.difficulty],
              color: 'white',
              fontWeight: 600,
              fontSize: '0.78rem',
            }}
          />
          {dish.estimated_cost != null && (
            <Chip
              icon={<AttachMoney sx={{ color: '#4ade80 !important', fontSize: '13px !important' }} />}
              label={`$${dish.estimated_cost.toFixed(0)}`}
              size="small"
              sx={{
                bgcolor: 'rgba(34,197,94,0.2)',
                color: '#86efac',
                border: '1px solid rgba(34,197,94,0.3)',
                fontWeight: 600,
                fontSize: '0.78rem',
              }}
            />
          )}
          {dish.is_vegan && (
            <Chip
              label="Веган"
              size="small"
              sx={{
                bgcolor: 'rgba(34,197,94,0.2)',
                color: '#86efac',
                border: '1px solid rgba(34,197,94,0.3)',
                fontSize: '0.78rem',
              }}
            />
          )}
          {!dish.is_vegan && dish.is_vegetarian && (
            <Chip
              label="Вегетар."
              size="small"
              sx={{
                bgcolor: 'rgba(245,158,11,0.2)',
                color: '#fcd34d',
                border: '1px solid rgba(245,158,11,0.3)',
                fontSize: '0.78rem',
              }}
            />
          )}
        </Box>

        {dish.missing_ingredients && dish.missing_ingredients.length > 0 && (
          <Box
            sx={{
              display: 'flex',
              alignItems: 'center',
              gap: 0.75,
              bgcolor: 'rgba(245,158,11,0.15)',
              border: '1px solid rgba(245,158,11,0.3)',
              borderRadius: 2,
              px: 1.5,
              py: 0.75,
              mt: 1.25,
            }}
          >
            <ShoppingCart sx={{ fontSize: 13, color: '#fcd34d' }} />
            <Typography variant="caption" sx={{ color: '#fcd34d', fontWeight: 500 }}>
              Докупить: {dish.missing_ingredients.map(i => i.name).join(', ')}
            </Typography>
          </Box>
        )}
      </Box>

      {/* COOK overlay — swipe right */}
      {swipeDirection === 'right' && (
        <Box
          sx={{
            position: 'absolute',
            top: 32,
            left: 20,
            border: '3.5px solid #22C55E',
            borderRadius: 2,
            px: 2,
            py: 0.75,
            transform: 'rotate(-12deg)',
            boxShadow: '0 0 24px rgba(34,197,94,0.5)',
            background: 'rgba(34,197,94,0.12)',
          }}
        >
          <Typography sx={{ color: '#22C55E', fontWeight: 900, fontSize: 26, letterSpacing: 2, lineHeight: 1 }}>
            COOK ❤️
          </Typography>
        </Box>
      )}

      {/* SKIP overlay — swipe left */}
      {swipeDirection === 'left' && (
        <Box
          sx={{
            position: 'absolute',
            top: 32,
            right: 20,
            border: '3.5px solid #FF4D4D',
            borderRadius: 2,
            px: 2,
            py: 0.75,
            transform: 'rotate(12deg)',
            boxShadow: '0 0 24px rgba(255,77,77,0.5)',
            background: 'rgba(255,77,77,0.12)',
          }}
        >
          <Typography sx={{ color: '#FF4D4D', fontWeight: 900, fontSize: 26, letterSpacing: 2, lineHeight: 1 }}>
            SKIP ✖
          </Typography>
        </Box>
      )}
    </Box>
  )
}
