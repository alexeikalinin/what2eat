import { useState } from 'react'
import {
  Box,
  Typography,
  Paper,
  Chip,
  Button,
  CircularProgress,
  Alert,
  Grid,
  List,
  ListItem,
} from '@mui/material'
import { ArrowBack, AccessTime, People, OpenInNew, Calculate } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useAppSelector, useAppDispatch } from '../../hooks/redux'
import { clearRecipe, setVariant } from '../../store/slices/recipeSlice'
import { analyzeCaloriesFromRecipe, clearPhoto } from '../../store/slices/photoSlice'
import { DIFFICULTY_COLORS } from '../../utils/constants'
import { Difficulty } from '../../types'
import { getDishImageUrl } from '../../utils/imageUtils'
import CalorieCard from '../CalorieCard'
import { usePlan } from '../../hooks/usePlan'
import { useModalContext } from '../../contexts/ModalContext'
import { useLanguage } from '../../hooks/useLanguage'
import { recipeInstructions, recipeTitle, difficultyLabel } from '../../utils/lang'

interface RecipeViewProps {
  onBack: () => void
}

export default function RecipeView({ onBack }: RecipeViewProps) {
  const dispatch = useAppDispatch()
  const { recipes, selectedVariant, loading, error } = useAppSelector((state) => state.recipe)
  const currentRecipe = recipes[selectedVariant] ?? null
  const calorieEstimate = useAppSelector((s) => s.photo.calorieEstimate)
  const photoStatus = useAppSelector((s) => s.photo.status)

  const { isPremium } = usePlan()
  const { openPaywall } = useModalContext()
  const { lang, t } = useLanguage()
  const [calorieRequested, setCalorieRequested] = useState(false)

  const handleBack = () => {
    dispatch(clearRecipe())
    dispatch(clearPhoto())
    onBack()
  }

  const handleCalorieClick = () => {
    if (!isPremium) { openPaywall('calories'); return }
    if (calorieRequested) return
    setCalorieRequested(true)
    const ingredients = currentRecipe?.ingredients.map(i => ({
      name: i.ingredient_name,
      quantity: i.quantity,
      unit: i.unit,
    })) ?? []
    dispatch(analyzeCaloriesFromRecipe({ dishName: currentRecipe?.dish_name ?? '', ingredients, lang }))
  }

  const getDifficultyColor = (difficulty: Difficulty) => {
    return DIFFICULTY_COLORS[difficulty] || DIFFICULTY_COLORS.easy
  }

  if (loading) {
    return (
      <Box sx={{ display: 'flex', flexDirection: 'column', justifyContent: 'center', alignItems: 'center', my: 8, gap: 2 }}>
        <CircularProgress sx={{ color: '#FF7A18' }} />
        <Typography variant="body2" color="text.secondary">{t('recipe_loading')}…</Typography>
      </Box>
    )
  }

  if (error) {
    return (
      <Box>
        <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>
        <Button variant="outlined" onClick={handleBack} startIcon={<ArrowBack />}>{t('back')}</Button>
      </Box>
    )
  }

  if (!currentRecipe) {
    return (
      <Box>
        <Alert severity="info">{t('recipe_not_found')}</Alert>
        <Button variant="outlined" onClick={handleBack} startIcon={<ArrowBack />} sx={{ mt: 2 }}>{t('back')}</Button>
      </Box>
    )
  }

  const imageUrl = getDishImageUrl(currentRecipe.dish_name, currentRecipe.image_url)

  return (
    <motion.div
      initial={{ opacity: 0, y: 12 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.35 }}
    >
      <Box sx={{ pb: 4 }}>
        {/* Full-width hero image */}
        <Box
          sx={{
            position: 'relative',
            height: { xs: 260, sm: 320 },
            borderRadius: 4,
            overflow: 'hidden',
            mb: 3,
            mx: -2,
          }}
        >
          <Box
            component="img"
            src={imageUrl}
            alt={currentRecipe.dish_name}
            sx={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
          />
          <Box
            sx={{
              position: 'absolute',
              inset: 0,
              background: 'linear-gradient(to top, rgba(0,0,0,0.75) 0%, rgba(0,0,0,0.2) 50%, transparent 100%)',
            }}
          />
          <Button
            variant="text"
            onClick={handleBack}
            startIcon={<ArrowBack sx={{ fontSize: 18 }} />}
            size="small"
            sx={{
              position: 'absolute',
              top: 12,
              left: 12,
              color: 'white',
              bgcolor: 'rgba(0,0,0,0.3)',
              backdropFilter: 'blur(8px)',
              borderRadius: 10,
              px: 1.5,
              py: 0.75,
              fontWeight: 600,
              '&:hover': { bgcolor: 'rgba(0,0,0,0.45)' },
            }}
          >
            {t('back')}
          </Button>
          <Box sx={{ position: 'absolute', bottom: 0, left: 0, right: 0, p: '16px 20px 20px' }}>
            <Typography
              variant="h2"
              sx={{
                color: 'white',
                fontWeight: 800,
                fontSize: { xs: '1.5rem', sm: '1.8rem' },
                letterSpacing: '-0.025em',
                lineHeight: 1.15,
                textShadow: '0 2px 8px rgba(0,0,0,0.3)',
              }}
            >
              {lang === 'en' && currentRecipe.dish_name_en
              ? currentRecipe.dish_name_en
              : currentRecipe.dish_name}
            </Typography>
          </Box>
        </Box>

        {/* Recipe variant selector (shown only when multiple variants exist) */}
        {recipes.length > 1 && (
          <Box sx={{ mb: 2.5 }}>
            <Typography variant="caption" sx={{ color: 'rgba(0,0,0,0.45)', fontWeight: 600, textTransform: 'uppercase', letterSpacing: '0.06em', mb: 1, display: 'block' }}>
              {t('recipe_variant')}
            </Typography>
            <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap' }}>
              {recipes.map((r, i) => (
                <Chip
                  key={r.id}
                  label={recipeTitle(r.title, r.title_en, lang)}
                  onClick={() => dispatch(setVariant(i))}
                  variant={selectedVariant === i ? 'filled' : 'outlined'}
                  sx={{
                    fontWeight: 600,
                    fontSize: '0.82rem',
                    cursor: 'pointer',
                    ...(selectedVariant === i
                      ? { bgcolor: '#FF7A18', color: 'white', borderColor: '#FF7A18' }
                      : { color: 'rgba(0,0,0,0.6)', borderColor: '#E0E0E0' }),
                  }}
                />
              ))}
            </Box>
          </Box>
        )}

        {/* Две колонки как в TashaD16: ингредиенты (30%) + шаги (70%), палитра в стиле проекта */}
        <Grid container spacing={2.5}>
          {/* Левый блок: ингредиенты */}
          <Grid item xs={12} md={4}>
            <Paper
              elevation={0}
              sx={{
                p: 2.5,
                borderRadius: 3,
                bgcolor: 'rgba(255,243,224,0.97)',
                backdropFilter: 'blur(20px)',
                border: '1.5px solid rgba(255,122,24,0.28)',
                boxShadow: '0 4px 24px rgba(255,122,24,0.12)',
              }}
            >
              <Box sx={{ display: 'flex', gap: 1, flexWrap: 'wrap', alignItems: 'center', mb: 2 }}>
                <Chip
                  icon={<AccessTime sx={{ fontSize: '15px !important' }} />}
                  label={`${currentRecipe.cooking_time} ${t('min')}`}
                  size="small"
                  sx={{ bgcolor: 'rgba(255,122,24,0.15)', color: '#E86A08', border: '1px solid rgba(255,122,24,0.30)', fontWeight: 600 }}
                />
                <Chip
                  icon={<People sx={{ fontSize: '15px !important' }} />}
                  label={`${currentRecipe.servings} ${t('portions')}`}
                  size="small"
                  sx={{ bgcolor: 'rgba(255,122,24,0.15)', color: '#E86A08', border: '1px solid rgba(255,122,24,0.30)', fontWeight: 600 }}
                />
                <Chip
                  label={difficultyLabel(currentRecipe.difficulty, t)}
                  size="small"
                  sx={{ bgcolor: getDifficultyColor(currentRecipe.difficulty), color: 'white', fontWeight: 700 }}
                />
                {currentRecipe.source_url && (
                  <Chip
                    icon={<OpenInNew sx={{ fontSize: '14px !important' }} />}
                    label={t('recipe_source')}
                    component="a"
                    href={currentRecipe.source_url}
                    target="_blank"
                    rel="noopener noreferrer"
                    clickable
                    size="small"
                    sx={{ color: 'rgba(0,0,0,0.55)', border: '1px solid rgba(255,122,24,0.25)', fontWeight: 500, fontSize: '0.78rem' }}
                  />
                )}
              </Box>
              <Typography variant="subtitle1" sx={{ fontWeight: 700, mb: 1.5, color: '#1A1A1A' }}>
                🧂 {t('recipe_ingredients')}
              </Typography>
              <List dense disablePadding>
                {currentRecipe.ingredients.map((ing, index) => (
                  <ListItem
                    key={index}
                    disablePadding
                    sx={{
                      py: 0.75,
                      borderBottom: index < currentRecipe.ingredients.length - 1 ? '1px solid rgba(255,122,24,0.12)' : 'none',
                      display: 'flex',
                      justifyContent: 'space-between',
                      alignItems: 'center',
                    }}
                  >
                    <Typography variant="body2" sx={{ fontWeight: 500, color: '#1A1A1A' }}>
                      {lang === 'en' && ing.ingredient_name_en ? ing.ingredient_name_en : ing.ingredient_name}
                    </Typography>
                    <Typography variant="caption" sx={{ color: 'rgba(0,0,0,0.5)', fontWeight: 500 }}>
                      {ing.quantity} {ing.unit}
                    </Typography>
                  </ListItem>
                ))}
              </List>

              {/* Calorie estimation inline */}
              {calorieRequested && photoStatus === 'analyzing' && (
                <Box sx={{ mt: 2, display: 'flex', alignItems: 'center', gap: 1 }}>
                  <CircularProgress size={16} sx={{ color: '#FF7A18' }} />
                  <Typography variant="caption" sx={{ color: '#FF7A18' }}>{t('recipe_calc_calories_auto')}</Typography>
                </Box>
              )}
              {calorieRequested && calorieEstimate && (
                <Box sx={{ mt: 2 }}>
                  <Typography variant="caption" sx={{ color: 'rgba(0,0,0,0.45)', mb: 0.5, display: 'block' }}>
                    {t('recipe_calories_auto_hint')}
                  </Typography>
                  <CalorieCard estimate={calorieEstimate} />
                </Box>
              )}
              {!calorieRequested && (
                <Button
                  onClick={handleCalorieClick}
                  startIcon={<Calculate sx={{ fontSize: 16 }} />}
                  size="small"
                  fullWidth
                  sx={{
                    mt: 2,
                    borderRadius: 2,
                    fontWeight: 600,
                    fontSize: '0.82rem',
                    color: isPremium ? '#FF7A18' : 'rgba(0,0,0,0.4)',
                    border: `1px solid ${isPremium ? 'rgba(255,122,24,0.4)' : 'rgba(0,0,0,0.15)'}`,
                    bgcolor: isPremium ? 'rgba(255,122,24,0.06)' : 'transparent',
                    '&:hover': { bgcolor: isPremium ? 'rgba(255,122,24,0.12)' : 'rgba(0,0,0,0.04)' },
                  }}
                >
                  {isPremium ? t('recipe_calc_calories') : t('recipe_calc_calories_premium')}
                </Button>
              )}
            </Paper>
          </Grid>

          {/* Правый блок: приготовление */}
          <Grid item xs={12} md={8}>
            <Paper
              elevation={0}
              sx={{
                p: 2.5,
                borderRadius: 3,
                bgcolor: 'rgba(255,248,240,0.97)',
                backdropFilter: 'blur(20px)',
                border: '1.5px solid rgba(255,122,24,0.20)',
                boxShadow: '0 4px 24px rgba(255,122,24,0.08)',
              }}
            >
              <Typography variant="subtitle1" sx={{ fontWeight: 700, mb: 2, color: '#1A1A1A' }}>
                👨‍🍳 {t('recipe_steps')}
              </Typography>
              <Box sx={{ display: 'flex', flexDirection: 'column', gap: 0 }}>
                {recipeInstructions(
                    JSON.stringify(currentRecipe.instructions),
                    currentRecipe.instructions_en,
                    lang
                  ).map((step, index) => (
                  <motion.div
                    key={`${selectedVariant}-${index}`}
                    initial={{ opacity: 0, x: -12 }}
                    animate={{ opacity: 1, x: 0 }}
                    transition={{ delay: index * 0.05, duration: 0.28 }}
                  >
                    <Box
                      sx={{
                        display: 'flex',
                        gap: 2,
                        alignItems: 'flex-start',
                        pb: index < currentRecipe.instructions.length - 1 ? 2 : 0,
                        mb: index < currentRecipe.instructions.length - 1 ? 2 : 0,
                        borderBottom: 'none',
                      }}
                    >
                      <Box
                        sx={{
                          minWidth: 32,
                          height: 32,
                          borderRadius: '50%',
                          background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                          display: 'flex',
                          alignItems: 'center',
                          justifyContent: 'center',
                          flexShrink: 0,
                          boxShadow: '0 2px 10px rgba(255,122,24,0.35)',
                        }}
                      >
                        <Typography sx={{ color: 'white', fontWeight: 800, fontSize: '0.8rem' }}>
                          {step.step}
                        </Typography>
                      </Box>
                      <Typography
                        variant="body2"
                        sx={{ color: '#3A3A3A', lineHeight: 1.65, pt: 0.5, fontSize: '0.9rem' }}
                      >
                        {step.description}
                      </Typography>
                    </Box>
                  </motion.div>
                ))}
              </Box>
            </Paper>
          </Grid>
        </Grid>
      </Box>

    </motion.div>
  )
}
