import { useMemo, useState, useEffect } from 'react'
import {
  Box,
  Typography,
  List,
  ListItem,
  Checkbox,
  Divider,
  Button,
  Alert,
  Paper,
} from '@mui/material'
import { ArrowBack, ShoppingCart, Delete } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useAppSelector } from '../../hooks/redux'
import { INGREDIENT_CATEGORIES } from '../../utils/constants'
import { Ingredient } from '../../types'

const STORAGE_KEY = 'what2eat_shopping_checked'

interface ShoppingListProps {
  onBack: () => void
}

export default function ShoppingList({ onBack }: ShoppingListProps) {
  const { likedDishIds } = useAppSelector((state) => state.swipe)
  const { dishes } = useAppSelector((state) => state.dishes)
  const { selectedIngredients } = useAppSelector((state) => state.ingredients)

  const [checked, setChecked] = useState<Set<number>>(() => {
    try {
      const saved = localStorage.getItem(STORAGE_KEY)
      return saved ? new Set(JSON.parse(saved) as number[]) : new Set()
    } catch {
      return new Set()
    }
  })

  const shoppingItems = useMemo(() => {
    const likedDishes = dishes.filter((d) => likedDishIds.includes(d.id))
    const byId = new Map<number, Ingredient>()

    for (const dish of likedDishes) {
      for (const ing of dish.missing_ingredients ?? []) {
        byId.set(ing.id, ing)
      }
      for (const ing of dish.ingredients ?? []) {
        if (!selectedIngredients.includes(ing.id)) {
          byId.set(ing.id, ing)
        }
      }
    }

    return Array.from(byId.values())
  }, [dishes, likedDishIds, selectedIngredients])

  const grouped = useMemo(() => {
    const map = new Map<string, Ingredient[]>()
    for (const ing of shoppingItems) {
      if (!map.has(ing.category)) map.set(ing.category, [])
      map.get(ing.category)!.push(ing)
    }
    return map
  }, [shoppingItems])

  useEffect(() => {
    localStorage.setItem(STORAGE_KEY, JSON.stringify([...checked]))
  }, [checked])

  const toggleCheck = (id: number) => {
    setChecked((prev) => {
      const next = new Set(prev)
      if (next.has(id)) next.delete(id)
      else next.add(id)
      return next
    })
  }

  const clearChecked = () => {
    setChecked(new Set())
    localStorage.removeItem(STORAGE_KEY)
  }

  const boughtCount = [...checked].filter(id => shoppingItems.some(i => i.id === id)).length

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <Box>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 3 }}>
          <Button
            variant="text"
            onClick={onBack}
            startIcon={<ArrowBack />}
            sx={{ color: 'rgba(0,0,0,0.45)' }}
          >
            Назад
          </Button>
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 1 }}>
            <ShoppingCart sx={{ color: '#FF7A18', fontSize: 22 }} />
            <Typography variant="h5" sx={{ fontWeight: 700, color: '#1A1A1A' }}>
              Список покупок
            </Typography>
          </Box>
          <Button
            variant="text"
            size="small"
            startIcon={<Delete sx={{ fontSize: 14 }} />}
            onClick={clearChecked}
            sx={{ color: 'rgba(0,0,0,0.35)', fontSize: '0.8rem' }}
          >
            Сбросить
          </Button>
        </Box>

        {shoppingItems.length === 0 ? (
          <Box sx={{ textAlign: 'center', py: 6 }}>
            <Box sx={{ fontSize: '3rem', mb: 2 }}>🛒</Box>
            <Alert severity="info" sx={{ maxWidth: 400, mx: 'auto' }}>
              Список пуст. Понравьтесь блюда с режимом «Немного докупить».
            </Alert>
          </Box>
        ) : (
          <Box>
            {/* Progress bar */}
            {shoppingItems.length > 0 && (
              <Box
                sx={{
                  mb: 2.5,
                  p: 1.5,
                  bgcolor: '#FFF8F0',
                  border: '1px solid #FFE0B2',
                  borderRadius: 3,
                  display: 'flex',
                  alignItems: 'center',
                  gap: 1.5,
                }}
              >
                <Box
                  sx={{
                    flex: 1,
                    height: 6,
                    bgcolor: '#FFE0B2',
                    borderRadius: 3,
                    overflow: 'hidden',
                  }}
                >
                  <Box
                    sx={{
                      height: '100%',
                      width: `${(boughtCount / shoppingItems.length) * 100}%`,
                      background: 'linear-gradient(90deg, #FF7A18, #FFB347)',
                      borderRadius: 3,
                      transition: 'width 0.4s ease',
                    }}
                  />
                </Box>
                <Typography variant="caption" sx={{ color: '#FF7A18', fontWeight: 700, whiteSpace: 'nowrap' }}>
                  {boughtCount} / {shoppingItems.length}
                </Typography>
              </Box>
            )}

            {Array.from(grouped.entries()).map(([category, items]) => (
              <motion.div
                key={category}
                initial={{ opacity: 0, y: 8 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ duration: 0.25 }}
              >
                <Paper
                  elevation={0}
                  sx={{
                    mb: 2,
                    border: '1px solid #F0F0F0',
                    borderRadius: 3,
                    overflow: 'hidden',
                    bgcolor: '#FFFFFF',
                  }}
                >
                  <Box sx={{ px: 2, py: 1.25, bgcolor: '#FAFAFA', borderBottom: '1px solid #F0F0F0' }}>
                    <Typography variant="caption" sx={{ fontWeight: 700, color: 'rgba(0,0,0,0.45)', textTransform: 'uppercase', letterSpacing: '0.08em', fontSize: '0.72rem' }}>
                      {INGREDIENT_CATEGORIES[category as keyof typeof INGREDIENT_CATEGORIES] ?? category}
                    </Typography>
                  </Box>
                  <List dense disablePadding>
                    {items.map((ing, idx) => {
                      const isChecked = checked.has(ing.id)
                      return (
                        <Box key={ing.id}>
                          <ListItem
                            dense
                            sx={{
                              px: 2,
                              py: 1,
                              cursor: 'pointer',
                              transition: 'opacity 0.2s',
                              opacity: isChecked ? 0.45 : 1,
                              '&:hover': { bgcolor: '#FAFAFA' },
                            }}
                            onClick={() => toggleCheck(ing.id)}
                          >
                            <Checkbox
                              edge="start"
                              checked={isChecked}
                              onChange={() => toggleCheck(ing.id)}
                              size="small"
                              sx={{
                                color: '#E9E9E9',
                                '&.Mui-checked': { color: '#22C55E' },
                                mr: 0.5,
                              }}
                            />
                            <Typography
                              variant="body2"
                              sx={{
                                fontWeight: 500,
                                color: '#1A1A1A',
                                textDecoration: isChecked ? 'line-through' : 'none',
                                fontSize: '0.9rem',
                              }}
                            >
                              {ing.name}
                            </Typography>
                          </ListItem>
                          {idx < items.length - 1 && <Divider />}
                        </Box>
                      )
                    })}
                  </List>
                </Paper>
              </motion.div>
            ))}
          </Box>
        )}
      </Box>
    </motion.div>
  )
}
