import { useState, useMemo } from 'react'
import {
  Box,
  Typography,
  Grid,
  Paper,
  Button,
  IconButton,
  Dialog,
  DialogTitle,
  DialogContent,
  MenuItem,
  Select,
  FormControl,
  InputLabel,
} from '@mui/material'
import { ArrowBack, Add, Delete, MenuBook, Lock, Star } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useAppSelector, useAppDispatch } from '../../hooks/redux'
import { assignDishToDay, removeDishFromDay, DayOfWeek } from '../../store/slices/weeklyPlannerSlice'
import { usePlan } from '../../hooks/usePlan'
import PaywallModal from '../PaywallModal'
import { useModalContext } from '../../contexts/ModalContext'

const DAY_LABELS: Record<DayOfWeek, string> = {
  mon: 'Пн',
  tue: 'Вт',
  wed: 'Ср',
  thu: 'Чт',
  fri: 'Пт',
  sat: 'Сб',
  sun: 'Вс',
}
const DAYS = Object.keys(DAY_LABELS) as DayOfWeek[]

interface WeeklyPlannerProps {
  onDishSelect: (dishId: number) => void
  onBack: () => void
}

export default function WeeklyPlanner({ onDishSelect, onBack }: WeeklyPlannerProps) {
  const dispatch = useAppDispatch()
  const { plan } = useAppSelector((state) => state.weeklyPlanner)
  const { dishes } = useAppSelector((state) => state.dishes)
  const { likedDishIds } = useAppSelector((state) => state.swipe)
  const { canUseWeeklyPlanner } = usePlan()
  const { openAuth } = useModalContext()

  // All hooks before any conditional returns
  const [paywallOpen, setPaywallOpen] = useState(false)
  const [addDialog, setAddDialog] = useState<{ open: boolean; day: DayOfWeek | null }>({
    open: false,
    day: null,
  })
  const [selectedDishId, setSelectedDishId] = useState<number | ''>('')

  const availableDishes = useMemo(
    () => dishes.filter((d) => likedDishIds.includes(d.id)),
    [dishes, likedDishIds]
  )

  const dishById = useMemo(() => new Map(dishes.map((d) => [d.id, d])), [dishes])

  const openAdd = (day: DayOfWeek) => {
    setSelectedDishId('')
    setAddDialog({ open: true, day })
  }

  const handleAdd = () => {
    if (addDialog.day && selectedDishId !== '') {
      dispatch(assignDishToDay({ day: addDialog.day, dishId: selectedDishId as number }))
    }
    setAddDialog({ open: false, day: null })
  }

  // Premium gate — show paywall screen
  if (!canUseWeeklyPlanner()) {
    return (
      <>
        <motion.div initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ duration: 0.3 }}>
          <Box>
            <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 3 }}>
              <Button variant="text" onClick={onBack} startIcon={<ArrowBack />} sx={{ color: 'rgba(0,0,0,0.45)' }}>
                Назад
              </Button>
              <Typography variant="h5" sx={{ fontWeight: 700, color: '#1A1A1A' }}>
                📅 Планировщик недели
              </Typography>
            </Box>

            <Box
              sx={{
                textAlign: 'center',
                py: 6,
                px: 3,
                bgcolor: '#FFFFFF',
                borderRadius: 4,
                border: '1.5px dashed #FFD0A0',
              }}
            >
              <Box
                sx={{
                  width: 72,
                  height: 72,
                  borderRadius: '50%',
                  background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                  mx: 'auto',
                  mb: 2.5,
                  boxShadow: '0 4px 20px rgba(255,122,24,0.35)',
                }}
              >
                <Lock sx={{ color: 'white', fontSize: 32 }} />
              </Box>
              <Typography variant="h5" sx={{ fontWeight: 700, color: '#1A1A1A', mb: 1 }}>
                Только Premium
              </Typography>
              <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.55)', mb: 3, maxWidth: 280, mx: 'auto' }}>
                Планируйте приёмы пищи на неделю вперёд и получайте умный список покупок
              </Typography>
              <Button
                variant="contained"
                startIcon={<Star />}
                size="large"
                onClick={() => setPaywallOpen(true)}
                sx={{
                  background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                  borderRadius: 3,
                  px: 4,
                  fontWeight: 700,
                  boxShadow: '0 4px 15px rgba(255,122,24,0.4)',
                }}
              >
                Подключить Premium
              </Button>
            </Box>
          </Box>
        </motion.div>

        <PaywallModal
          open={paywallOpen}
          onClose={() => setPaywallOpen(false)}
          onLoginRequired={openAuth}
          reason="Недельный планировщик и умный список покупок — только в Premium."
        />
      </>
    )
  }

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <Box>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 3 }}>
          <Button
            variant="text"
            onClick={onBack}
            startIcon={<ArrowBack />}
            sx={{ color: 'rgba(0,0,0,0.45)' }}
          >
            Назад
          </Button>
          <Typography variant="h5" sx={{ fontWeight: 700, color: '#1A1A1A' }}>
            📅 Планировщик недели
          </Typography>
        </Box>

        <Grid container spacing={1.5}>
          {DAYS.map((day, i) => {
            const dishId = plan[day]
            const dish = dishId != null ? dishById.get(dishId) : undefined

            return (
              <Grid item xs={6} sm={4} md={3} key={day}>
                <motion.div
                  initial={{ opacity: 0, scale: 0.95 }}
                  animate={{ opacity: 1, scale: 1 }}
                  transition={{ delay: i * 0.04, duration: 0.25 }}
                  whileHover={{ y: -2 }}
                >
                  <Paper
                    elevation={dish ? 2 : 0}
                    sx={{
                      p: 1.75,
                      minHeight: 110,
                      display: 'flex',
                      flexDirection: 'column',
                      gap: 0.75,
                      bgcolor: dish ? '#FFFFFF' : '#FAFAFA',
                      border: dish ? '1px solid #F0F0F0' : '1.5px dashed #E9E9E9',
                      borderRadius: 3,
                      transition: 'all 0.2s ease',
                      cursor: dish ? 'default' : 'pointer',
                      '&:hover': dish ? {} : { borderColor: '#FF7A18', bgcolor: '#FFF8F0' },
                    }}
                    onClick={!dish ? () => openAdd(day) : undefined}
                  >
                    <Typography
                      variant="caption"
                      sx={{
                        fontWeight: 700,
                        color: dish ? '#FF7A18' : 'rgba(0,0,0,0.35)',
                        textTransform: 'uppercase',
                        letterSpacing: '0.06em',
                        fontSize: '0.72rem',
                      }}
                    >
                      {DAY_LABELS[day]}
                    </Typography>

                    {dish ? (
                      <>
                        <Typography
                          variant="body2"
                          sx={{ fontWeight: 600, color: '#1A1A1A', flexGrow: 1, lineHeight: 1.35, fontSize: '0.875rem' }}
                        >
                          {dish.name}
                        </Typography>
                        <Box sx={{ display: 'flex', gap: 0.5 }}>
                          <IconButton
                            size="small"
                            onClick={() => onDishSelect(dish.id)}
                            sx={{
                              color: '#6366F1',
                              bgcolor: '#F0F0FF',
                              borderRadius: 1.5,
                              width: 28,
                              height: 28,
                              '&:hover': { bgcolor: '#E0E0FF' },
                            }}
                          >
                            <MenuBook sx={{ fontSize: 14 }} />
                          </IconButton>
                          <IconButton
                            size="small"
                            onClick={() => dispatch(removeDishFromDay(day))}
                            sx={{
                              color: '#FF4D4D',
                              bgcolor: '#FFF1F0',
                              borderRadius: 1.5,
                              width: 28,
                              height: 28,
                              '&:hover': { bgcolor: '#FFE0DE' },
                            }}
                          >
                            <Delete sx={{ fontSize: 14 }} />
                          </IconButton>
                        </Box>
                      </>
                    ) : (
                      <Box sx={{ flexGrow: 1, display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                        <Box
                          sx={{
                            width: 32,
                            height: 32,
                            borderRadius: '50%',
                            bgcolor: '#F5F5F5',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                          }}
                        >
                          <Add sx={{ fontSize: 18, color: 'rgba(0,0,0,0.3)' }} />
                        </Box>
                      </Box>
                    )}
                  </Paper>
                </motion.div>
              </Grid>
            )
          })}
        </Grid>

        <Dialog open={addDialog.open} onClose={() => setAddDialog({ open: false, day: null })}>
          <DialogTitle sx={{ fontWeight: 700 }}>Выбрать блюдо</DialogTitle>
          <DialogContent sx={{ minWidth: 280, pt: 2 }}>
            {availableDishes.length === 0 ? (
              <Typography color="text.secondary" variant="body2" sx={{ mb: 2 }}>
                Сначала выберите понравившиеся блюда через свайп
              </Typography>
            ) : (
              <FormControl fullWidth sx={{ mb: 2.5 }}>
                <InputLabel>Блюдо</InputLabel>
                <Select
                  value={selectedDishId}
                  label="Блюдо"
                  onChange={(e) => setSelectedDishId(e.target.value as number)}
                >
                  {availableDishes.map((d) => (
                    <MenuItem key={d.id} value={d.id}>
                      {d.name}
                    </MenuItem>
                  ))}
                </Select>
              </FormControl>
            )}
            <Button
              variant="contained"
              fullWidth
              onClick={handleAdd}
              disabled={selectedDishId === '' || availableDishes.length === 0}
              sx={{ py: 1.25 }}
            >
              Добавить
            </Button>
          </DialogContent>
        </Dialog>
      </Box>
    </motion.div>
  )
}
