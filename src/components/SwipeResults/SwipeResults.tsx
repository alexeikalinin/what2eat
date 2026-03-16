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
import { usePlan } from '../../hooks/usePlan'
import { useModalContext } from '../../contexts/ModalContext'
import { useLanguage } from '../../hooks/useLanguage'

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
  const { isPremium } = usePlan()
  const { openPaywall } = useModalContext()
  const { t } = useLanguage()

  const DAY_LABELS: Record<DayOfWeek, string> = {
    mon: t('results_monday'), tue: t('results_tuesday'), wed: t('results_wednesday'),
    thu: t('results_thursday'), fri: t('results_friday'), sat: t('results_saturday'), sun: t('results_sunday'),
  }
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
            {t('back')}
          </Button>
          <Typography variant="h5" sx={{ fontWeight: 700, color: '#1A1A1A' }}>
            {t('results_liked')}
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
              {t('results_shopping')}
            </Button>
            <Button
              variant="outlined"
              startIcon={<Refresh sx={{ fontSize: 16 }} />}
              onClick={handleRepeat}
              size="small"
              sx={{ fontSize: '0.8rem' }}
            >
              {t('results_again')}
            </Button>
          </Box>
        </Box>

        {likedDishes.length === 0 ? (
          <Box sx={{ textAlign: 'center', py: 6 }}>
            <Box sx={{ fontSize: '3rem', mb: 2 }}>😔</Box>
            <Typography variant="h6" sx={{ fontWeight: 600, color: '#1A1A1A', mb: 1 }}>
              {t('results_nothing')}
            </Typography>
            <Alert severity="info" sx={{ maxWidth: 400, mx: 'auto' }}>
              {t('results_try_again')}!
            </Alert>
          </Box>
        ) : (
          <>
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
                        {t('results_add_to_planner')}
                      </Button>
                    </Box>
                  </motion.div>
                </Grid>
              ))}
            </Grid>

            {!isPremium && (
              <motion.div
                initial={{ opacity: 0, y: 12 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: likedDishes.length * 0.07 + 0.1, duration: 0.3 }}
              >
                <Box
                  sx={{
                    mt: 3,
                    p: 2.5,
                    bgcolor: '#FFF3E0',
                    border: '1px solid #FFE0B2',
                    borderRadius: 3,
                  }}
                >
                  <Box sx={{ display: 'flex', alignItems: 'flex-start', gap: 1.5 }}>
                    <CalendarMonth sx={{ color: '#FF7A18', fontSize: 22, mt: 0.25, flexShrink: 0 }} />
                    <Box sx={{ flex: 1 }}>
                      <Typography variant="subtitle2" sx={{ fontWeight: 700, color: '#1A1A1A', mb: 0.5 }}>
                        {t('results_plan_week')}
                      </Typography>
                      <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.6)', mb: 1.5, lineHeight: 1.5 }}>
                        {t('results_add_liked')}
                      </Typography>
                      <Button
                        variant="outlined"
                        size="small"
                        color="warning"
                        onClick={() => openPaywall(t('swipe_results_premium_reason'))}
                        sx={{ borderRadius: 2, fontSize: '0.82rem', fontWeight: 600 }}
                      >
                        {t('results_try_premium')}
                      </Button>
                    </Box>
                  </Box>
                </Box>
              </motion.div>
            )}
          </>
        )}

        <Dialog open={planDialog.open} onClose={() => setPlanDialog({ open: false, dishId: null })}>
          <DialogTitle sx={{ fontWeight: 700 }}>{t('results_add_to_planner')}</DialogTitle>
          <DialogContent sx={{ minWidth: 280, pt: 2 }}>
            <FormControl fullWidth sx={{ mb: 2.5 }}>
              <InputLabel>{t('results_day_of_week')}</InputLabel>
              <Select
                value={selectedDay}
                label={t('results_day_of_week')}
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
              {t('planner_add')}
            </Button>
          </DialogContent>
        </Dialog>
      </Box>
    </motion.div>
  )
}
