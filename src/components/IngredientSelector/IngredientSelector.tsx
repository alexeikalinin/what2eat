import {
  Box,
  Typography,
  Chip,
  TextField,
  InputAdornment,
  Grid,
  Tabs,
  Tab,
  Button,
} from '@mui/material'
import { Search } from '@mui/icons-material'
import { useState, useMemo } from 'react'
import { motion } from 'framer-motion'
import { useAppSelector, useAppDispatch } from '../../hooks/redux'
import { toggleIngredient, clearSelection } from '../../store/slices/ingredientsSlice'
import { INGREDIENT_CATEGORIES } from '../../utils/constants'
import { IngredientCategory } from '../../types'
import { useLanguage } from '../../hooks/useLanguage'
import { TranslationKeys } from '../../i18n'
import { ingredientName } from '../../utils/lang'

// Категории, несовместимые с вегетарианством/веганством
const NON_VEGETARIAN_CATEGORIES: IngredientCategory[] = ['meat']
const NON_VEGAN_CATEGORIES: IngredientCategory[] = ['meat', 'dairy']

interface IngredientSelectorProps {
  hideTitle?: boolean
}

export default function IngredientSelector({ hideTitle }: IngredientSelectorProps) {
  const dispatch = useAppDispatch()
  const { t, lang } = useLanguage()
  const { ingredients, selectedIngredients } = useAppSelector(
    (state) => state.ingredients
  )
  const { veganOnly, vegetarianOnly } = useAppSelector((state) => state.filters)
  const [searchQuery, setSearchQuery] = useState('')
  const [selectedCategory, setSelectedCategory] = useState<IngredientCategory | 'all'>('all')

  const filteredIngredients = useMemo(() => {
    let filtered = ingredients.filter((ing) => ing.show_in_selector)

    // Скрываем несовместимые с диетой ингредиенты
    if (veganOnly) {
      filtered = filtered.filter((ing) => !NON_VEGAN_CATEGORIES.includes(ing.category))
    } else if (vegetarianOnly) {
      filtered = filtered.filter((ing) => !NON_VEGETARIAN_CATEGORIES.includes(ing.category))
    }

    if (selectedCategory !== 'all') {
      filtered = filtered.filter((ing) => ing.category === selectedCategory)
    }

    if (searchQuery) {
      const q = searchQuery.toLowerCase()
      filtered = filtered.filter((ing) =>
        ing.name.toLowerCase().includes(q) ||
        (ing.name_en && ing.name_en.toLowerCase().includes(q))
      )
    }

    return filtered
  }, [ingredients, selectedCategory, searchQuery, veganOnly, vegetarianOnly])

  const handleToggle = (id: number) => {
    dispatch(toggleIngredient(id))
  }

  const selectedIngredientObjects = useMemo(() => {
    return ingredients.filter((ing) => selectedIngredients.includes(ing.id))
  }, [ingredients, selectedIngredients])

  return (
    <Box>
      {!hideTitle && (
        <Typography
          variant="h4"
          gutterBottom
          sx={{ fontWeight: 700, color: '#1A1A1A', mb: 3, letterSpacing: '-0.02em' }}
        >
          {t('ingredients_title')}
        </Typography>
      )}

      <TextField
        fullWidth
        placeholder={`${t('ingredients_search')}...`}
        value={searchQuery}
        onChange={(e) => setSearchQuery(e.target.value)}
        size="small"
        sx={{ mb: 1.5 }}
        InputProps={{
          startAdornment: (
            <InputAdornment position="start">
              <Search sx={{ color: '#C0C0C0', fontSize: 18 }} />
            </InputAdornment>
          ),
        }}
      />

      <Tabs
        value={selectedCategory}
        onChange={(_, newValue) => setSelectedCategory(newValue)}
        sx={{ mb: 2 }}
        variant="scrollable"
        scrollButtons="auto"
      >
        <Tab label={t('ingredients_all')} value="all" />
        {Object.keys(INGREDIENT_CATEGORIES).map((key) => (
          <Tab key={key} label={t(`ingredients_cat_${key}` as TranslationKeys)} value={key} />
        ))}
      </Tabs>

      {selectedIngredientObjects.length > 0 && (
        <Box sx={{ mb: 2 }}>
          <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 1 }}>
            <Typography
              variant="caption"
              sx={{
                color: 'rgba(0,0,0,0.4)',
                fontWeight: 700,
                textTransform: 'uppercase',
                letterSpacing: '0.08em',
              }}
            >
              {t('ingredients_selected')}: {selectedIngredientObjects.length}
            </Typography>
            <Button
              size="small"
              onClick={() => dispatch(clearSelection())}
              sx={{ fontSize: '0.75rem', color: 'rgba(0,0,0,0.4)', minWidth: 0, p: '2px 6px' }}
            >
              {t('ingredients_reset')}
            </Button>
          </Box>
          <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.75 }}>
            {selectedIngredientObjects.map((ing) => (
              <motion.div
                key={ing.id}
                initial={{ scale: 0.8, opacity: 0 }}
                animate={{ scale: 1, opacity: 1 }}
                exit={{ scale: 0.8, opacity: 0 }}
                transition={{ type: 'spring', stiffness: 400, damping: 20 }}
              >
                <Chip
                  label={ingredientName(ing, lang)}
                  onDelete={() => handleToggle(ing.id)}
                  sx={{
                    background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                    color: 'white',
                    fontWeight: 600,
                    '& .MuiChip-deleteIcon': {
                      color: 'rgba(255,255,255,0.7)',
                      '&:hover': { color: 'white' },
                    },
                  }}
                />
              </motion.div>
            ))}
          </Box>
        </Box>
      )}

      <Grid container spacing={1}>
        {filteredIngredients.map((ingredient) => {
          const isSelected = selectedIngredients.includes(ingredient.id)
          return (
            <Grid item xs={6} sm={4} md={4} key={ingredient.id}>
              <motion.div
                whileTap={{ scale: 0.94 }}
                whileHover={{ y: -2 }}
                transition={{ type: 'spring', stiffness: 500, damping: 25 }}
              >
                <Box
                  onClick={() => handleToggle(ingredient.id)}
                  sx={{
                    p: '10px 14px',
                    cursor: 'pointer',
                    borderRadius: 2.5,
                    border: isSelected ? '1.5px solid #FF7A18' : '1px solid #E9E9E9',
                    bgcolor: isSelected ? '#FFF8F0' : '#FAFAFA',
                    transition: 'all 0.18s ease',
                    userSelect: 'none',
                    '&:hover': {
                      bgcolor: isSelected ? '#FFF3E0' : '#F5F5F5',
                      borderColor: isSelected ? '#FF7A18' : '#C0C0C0',
                    },
                  }}
                >
                  <Typography
                    variant="body2"
                    align="center"
                    sx={{
                      color: isSelected ? '#FF7A18' : '#1A1A1A',
                      fontWeight: isSelected ? 600 : 400,
                      fontSize: '0.85rem',
                    }}
                  >
                    {ingredientName(ingredient, lang)}
                  </Typography>
                </Box>
              </motion.div>
            </Grid>
          )
        })}
      </Grid>

      {(veganOnly || vegetarianOnly) && (
        <Box
          sx={{
            display: 'flex',
            alignItems: 'center',
            gap: 0.75,
            mt: 1.5,
            mb: 0.5,
            px: 1.5,
            py: 0.75,
            bgcolor: '#F0FDF4',
            border: '1px solid #BBF7D0',
            borderRadius: 2,
          }}
        >
          <Typography variant="caption" sx={{ color: '#16A34A', fontWeight: 600 }}>
            🌱 {veganOnly ? t('ingredients_vegan_only') : t('ingredients_vegetarian_only')}
          </Typography>
        </Box>
      )}

      {filteredIngredients.length === 0 && (
        <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.3)', textAlign: 'center', mt: 4, py: 2 }}>
          {t('ingredients_not_found')}
        </Typography>
      )}
    </Box>
  )
}
