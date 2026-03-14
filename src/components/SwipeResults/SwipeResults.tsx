import { useMemo, useState } from 'react'
import {
  Box,
  Typography,
  Grid,
  Button,
  Dialog,
  DialogTitle,
  DialogContent,
  MenuItem,
  Select,
  FormControl,
  InputLabel,
  Alert,
  IconButton,
} from '@mui/material'
import { ArrowBack, ShoppingCart, CalendarMonth, Refresh, DeleteOutline } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useAppSelector, useAppDispatch } from '../../hooks/redux'
import { resetSwipe, unlikeDish } from '../../store/slices/swipeSlice'
import { assignDishToDay, DayOfWeek } from '../../store/slices/weeklyPlannerSlice'
import DishCard from '../DishList/DishCard'

const DAY_LABELS: Record<DayOfWeek, string> = {
  mon: 'Понедельник',
  tue: 'Вторник',
  wed: 'Среда',
  thu: 'Четверг',
  fri: 'Пятница',
  sat: 'Суббота',
  sun: 'Воскресенье',
}

interface SwipeResultsProps {
  onDishSelect: (dishId: number) => void
  onBack: () => void
  onRepeat: () => void
  onShoppingList: () => void
}

export default function SwipeResults({ onDishSelect, onBack, onRepeat, onShoppingList }: SwipeResultsProps) {
  const dispatch = useAppDispatch()
  const { likedDishIds } = useAppSelector((state) => state.swipe)
  const { dishes } = useAppSelector((state) => state.dishes)
  const [planDialog, setPlanDialog] = useState<{ open: boolean; dishId: number | null }>({
    open: false,
    dishId: null,
  })
  const [selectedDay, setSelectedDay] = useState<DayOfWeek>('mon')

  const likedDishes = useMemo(
    () => dishes.filter((d) => likedDishIds.includes(d.id)),
    [dishes, likedDishIds]
  )

  const handleRepeat = () => {
    dispatch(resetSwipe())
    onRepeat()
  }

  const openPlanDialog = (dishId: number) => {
    setPlanDialog({ open: true, dishId })
  }

  const handleAddToPlan = () => {
    if (planDialog.dishId != null) {
      dispatch(assignDishToDay({ day: selectedDay, dishId: planDialog.dishId }))
    }
    setPlanDialog({ open: false, dishId: null })
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <Box>
        {/* Header */}
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3, flexWrap: 'wrap', gap: 1 }}>
          <Button
            variant="text"
            onClick={onBack}
            startIcon={<ArrowBack />}
            sx={{ color: 'rgba(0,0,0,0.45)' }}
          >
            Назад
          </Button>
          <Typography variant="h5" sx={{ fontWeight: 700, color: '#1A1A1A' }}>
            Понравилось ❤️
          </Typography>
          <Box sx={{ display: 'flex', gap: 1 }}>
            <Button
              variant="outlined"
              startIcon={<ShoppingCart sx={{ fontSize: 16 }} />}
              onClick={onShoppingList}
              disabled={likedDishes.length === 0}
              size="small"
              sx={{ fontSize: '0.8rem' }}
            >
              Покупки
            </Button>
            <Button
              variant="outlined"
              startIcon={<Refresh sx={{ fontSize: 16 }} />}
              onClick={handleRepeat}
              size="small"
              sx={{ fontSize: '0.8rem' }}
            >
              Ещё раз
            </Button>
          </Box>
        </Box>

        {likedDishes.length === 0 ? (
          <Box sx={{ textAlign: 'center', py: 6 }}>
            <Box sx={{ fontSize: '3rem', mb: 2 }}>😔</Box>
            <Typography variant="h6" sx={{ fontWeight: 600, color: '#1A1A1A', mb: 1 }}>
              Ничего не выбрано
            </Typography>
            <Alert severity="info" sx={{ maxWidth: 400, mx: 'auto' }}>
              Попробуйте свайпать ещё раз!
            </Alert>
          </Box>
        ) : (
          <Grid container spacing={2}>
            {likedDishes.map((dish, i) => (
              <Grid item xs={12} sm={6} key={dish.id}>
                <motion.div
                  initial={{ opacity: 0, y: 16 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: i * 0.07, duration: 0.3 }}
                >
                  <Box sx={{ position: 'relative' }}>
                    <IconButton
                      size="small"
                      onClick={() => dispatch(unlikeDish(dish.id))}
                      sx={{
                        position: 'absolute', top: 8, right: 8, zIndex: 2,
                        bgcolor: 'rgba(255,255,255,0.9)', backdropFilter: 'blur(4px)',
                        width: 32, height: 32,
                        '&:hover': { bgcolor: '#FFECEC', color: '#FF4D4D' },
                      }}
                    >
                      <DeleteOutline sx={{ fontSize: 17, color: 'rgba(0,0,0,0.45)' }} />
                    </IconButton>
                    <DishCard dish={dish} onSelect={onDishSelect} />
                    <Button
                      size="small"
                      startIcon={<CalendarMonth sx={{ fontSize: 15 }} />}
                      onClick={() => openPlanDialog(dish.id)}
                      fullWidth
                      sx={{
                        mt: 1,
                        borderRadius: 3,
                        borderColor: '#E9E9E9',
                        color: 'rgba(0,0,0,0.55)',
                        fontSize: '0.82rem',
                        '&:hover': { borderColor: '#FF7A18', color: '#FF7A18', bgcolor: '#FFF8F0' },
                      }}
                      variant="outlined"
                    >
                      В планировщик
                    </Button>
                  </Box>
                </motion.div>
              </Grid>
            ))}
          </Grid>
        )}

        <Dialog open={planDialog.open} onClose={() => setPlanDialog({ open: false, dishId: null })}>
          <DialogTitle sx={{ fontWeight: 700 }}>Добавить в планировщик</DialogTitle>
          <DialogContent sx={{ minWidth: 280, pt: 2 }}>
            <FormControl fullWidth sx={{ mb: 2.5 }}>
              <InputLabel>День недели</InputLabel>
              <Select
                value={selectedDay}
                label="День недели"
                onChange={(e) => setSelectedDay(e.target.value as DayOfWeek)}
              >
                {(Object.entries(DAY_LABELS) as [DayOfWeek, string][]).map(([key, label]) => (
                  <MenuItem key={key} value={key}>
                    {label}
                  </MenuItem>
                ))}
              </Select>
            </FormControl>
            <Button variant="contained" fullWidth onClick={handleAddToPlan} sx={{ py: 1.25 }}>
              Добавить
            </Button>
          </DialogContent>
        </Dialog>
      </Box>
    </motion.div>
  )
}
