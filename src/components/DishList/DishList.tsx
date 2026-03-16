import { Box, Typography, Grid, CircularProgress, Alert, Button, Divider } from '@mui/material'
import { ArrowBack, CheckCircle, ShoppingCart } from '@mui/icons-material'
import { useEffect, useRef } from 'react'
import { useAppSelector, useAppDispatch } from '../../hooks/redux'
import { findDishes, clearDishes } from '../../store/slices/dishesSlice'
import { clearSelection } from '../../store/slices/ingredientsSlice'
import DishCard from './DishCard'
import { useLanguage } from '../../hooks/useLanguage'

interface DishListProps {
  onDishSelect: (dishId: number) => void
  onBack: () => void
}

export default function DishList({ onDishSelect, onBack }: DishListProps) {
  const dispatch = useAppDispatch()
  const { dishes, loading, error } = useAppSelector((state) => state.dishes)
  const { selectedIngredients } = useAppSelector((state) => state.ingredients)
  const lastSearchedRef = useRef<string>('')
  const { t } = useLanguage()

  useEffect(() => {
    // Создаем строку из ID для сравнения, чтобы избежать повторных запросов
    const ingredientIdsString = selectedIngredients.map(id => id).sort().join(',')
    
    if (
      selectedIngredients.length > 0 && 
      dishes.length === 0 && 
      !loading && 
      ingredientIdsString !== lastSearchedRef.current
    ) {
      lastSearchedRef.current = ingredientIdsString
      console.log('DishList: Triggering search for ingredients:', selectedIngredients)
      dispatch(findDishes({ ingredientIds: selectedIngredients }))
    }
  }, [dispatch, selectedIngredients, dishes.length, loading])

  const handleBack = () => {
    dispatch(clearDishes())
    dispatch(clearSelection())
    onBack()
  }

  const readyNow = dishes.filter((d) => (d.coverage ?? 0) >= 1.0)
  const needMore = dishes.filter((d) => d.coverage !== undefined && d.coverage < 1.0)
  // If coverage is not set (e.g. no ingredients selected), show all in one list
  const noScoring = dishes.every((d) => d.coverage === undefined)

  return (
    <Box>
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
        <Typography variant="h5">
          {selectedIngredients.length > 0 ? t('dishes_found') : t('dishes_recommended')}: {dishes.length}
        </Typography>
        <Button variant="outlined" onClick={handleBack} startIcon={<ArrowBack />}>
          {t('dishes_back')}
        </Button>
      </Box>

      {loading && (
        <Box sx={{ display: 'flex', justifyContent: 'center', my: 4 }}>
          <CircularProgress />
        </Box>
      )}

      {error && (
        <Alert severity="error" sx={{ mb: 2 }}>
          {error}
        </Alert>
      )}

      {!loading && dishes.length > 0 && noScoring && (
        <Grid container spacing={3}>
          {dishes.map((dish) => (
            <Grid item xs={12} sm={6} md={4} key={dish.id}>
              <DishCard dish={dish} onSelect={onDishSelect} />
            </Grid>
          ))}
        </Grid>
      )}

      {!loading && !noScoring && (
        <Box>
          {/* Секция 1: Можно приготовить сейчас */}
          {readyNow.length > 0 && (
            <Box sx={{ mb: 4 }}>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                <CheckCircle sx={{ color: '#22C55E', fontSize: 20 }} />
                <Typography variant="subtitle1" sx={{ fontWeight: 700, color: '#15803d' }}>
                  {t('dishes_can_cook_now')}
                </Typography>
                <Box sx={{ bgcolor: '#DCFCE7', borderRadius: 10, px: 1, py: 0.1 }}>
                  <Typography variant="caption" sx={{ color: '#15803d', fontWeight: 700 }}>
                    {readyNow.length}
                  </Typography>
                </Box>
              </Box>
              <Grid container spacing={3}>
                {readyNow.map((dish) => (
                  <Grid item xs={12} sm={6} md={4} key={dish.id}>
                    <DishCard dish={dish} onSelect={onDishSelect} />
                  </Grid>
                ))}
              </Grid>
            </Box>
          )}

          {/* Разделитель */}
          {readyNow.length > 0 && needMore.length > 0 && (
            <Divider sx={{ mb: 4 }} />
          )}

          {/* Секция 2: Нужно докупить */}
          {needMore.length > 0 && (
            <Box>
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 2 }}>
                <ShoppingCart sx={{ color: '#D97706', fontSize: 20 }} />
                <Typography variant="subtitle1" sx={{ fontWeight: 700, color: '#92400e' }}>
                  {t('dishes_need_few_more')}
                </Typography>
                <Box sx={{ bgcolor: '#FEF3C7', borderRadius: 10, px: 1, py: 0.1 }}>
                  <Typography variant="caption" sx={{ color: '#92400e', fontWeight: 700 }}>
                    {needMore.length}
                  </Typography>
                </Box>
              </Box>
              <Grid container spacing={3}>
                {needMore.map((dish) => (
                  <Grid item xs={12} sm={6} md={4} key={dish.id}>
                    <DishCard dish={dish} onSelect={onDishSelect} />
                  </Grid>
                ))}
              </Grid>
            </Box>
          )}

          {readyNow.length === 0 && needMore.length === 0 && (
            <Alert severity="info">
              {t('dishes_not_found')}
            </Alert>
          )}
        </Box>
      )}

      {!loading && dishes.length === 0 && !error && (
        <Alert severity="info">
          {t('dishes_not_found')}
        </Alert>
      )}
    </Box>
  )
}

