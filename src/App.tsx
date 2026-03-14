import { useEffect, useState, useMemo, useCallback } from 'react'
import { Box, Button, CircularProgress, Alert, Accordion, AccordionSummary, AccordionDetails, Typography } from '@mui/material'
import { Casino, ExpandMore, Search } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useAppDispatch, useAppSelector } from './hooks/redux'
import { fetchIngredients } from './store/slices/ingredientsSlice'
import { findDishes, randomizeDishesByFocus } from './store/slices/dishesSlice'
import { fetchRecipe } from './store/slices/recipeSlice'
import { resetSwipe } from './store/slices/swipeSlice'
import { initAuth, setUser, refreshPlan } from './store/slices/userSlice'
import { setFocus } from './store/slices/randomizerSlice'
import { RandomizerFocus } from './services/dishes'
import { initDatabase } from './services/database'
import { supabase } from './services/supabase'
import Layout from './components/Layout'
import IngredientSelector from './components/IngredientSelector'
import IngredientsHero from './components/IngredientsHero'
import TutorialOverlay, { getTutorialSeen } from './components/TutorialOverlay'
import RecipeView from './components/RecipeView'
import SearchFilters from './components/SearchFilters'
import SwipeDeck from './components/SwipeDeck'
import SwipeResults from './components/SwipeResults'
import ShoppingList from './components/ShoppingList'
import WeeklyPlanner from './components/WeeklyPlanner'
import PhotoUpload from './components/PhotoUpload'
import RandomizerFocusScreen from './components/RandomizerFocus'
import QuickIdeas from './components/QuickIdeas'
import AuthModal from './components/AuthModal'
import PaywallModal from './components/PaywallModal'
import { ModalContext } from './contexts/ModalContext'

type View = 'ingredients' | 'photo' | 'dishes' | 'swipe_results' | 'recipe' | 'shopping_list' | 'weekly_planner' | 'randomizer_focus'

function App() {
  const dispatch = useAppDispatch()
  const [view, setView] = useState<View>('ingredients')
  const [prevView, setPrevView] = useState<View>('swipe_results')
  const [showTutorial, setShowTutorial] = useState(() => !getTutorialSeen())
  const [dbInitialized, setDbInitialized] = useState(false)
  const [dbError, setDbError] = useState<string | null>(null)
  const [authModalOpen, setAuthModalOpen] = useState(false)
  const [paywallReason, setPaywallReason] = useState<string | undefined>()
  const [successPaywallOpen, setSuccessPaywallOpen] = useState(false)

  const modalContext = {
    openAuth: () => setAuthModalOpen(true),
    openPaywall: (reason?: string) => { setPaywallReason(reason); setSuccessPaywallOpen(true) },
  }
  const { selectedIngredients } = useAppSelector((state) => state.ingredients)
  const { dishes } = useAppSelector((state) => state.dishes)
  const filters = useAppSelector((state) => state.filters)
  const { likedDishIds } = useAppSelector((state) => state.swipe)
  const { user, plan } = useAppSelector((state) => state.user)

  // Initialize DB
  useEffect(() => {
    let cancelled = false
    const initializeApp = async () => {
      try {
        await initDatabase()
        if (!cancelled) {
          setDbInitialized(true)
          dispatch(fetchIngredients())
        }
      } catch (error) {
        if (!cancelled) {
          setDbError(`Не удалось инициализировать базу данных: ${error instanceof Error ? error.message : 'Неизвестная ошибка'}`)
        }
      }
    }
    initializeApp()
    return () => { cancelled = true }
  }, [dispatch])

  // Initialize Supabase auth
  useEffect(() => {
    dispatch(initAuth())

    const { data: { subscription } } = supabase.auth.onAuthStateChange((_event, session) => {
      dispatch(setUser(session?.user ?? null))
      if (session?.user) {
        dispatch(refreshPlan(session.user.id))
      }
    })
    return () => subscription.unsubscribe()
  }, [dispatch])

  // Handle Stripe redirect (success/cancel)
  useEffect(() => {
    const params = new URLSearchParams(window.location.search)
    if (params.get('payment') === 'success') {
      window.history.replaceState({}, '', window.location.pathname)
      // Ждём восстановления auth-сессии, затем обновляем план
      const tryRefresh = (attempts = 0) => {
        supabase.auth.getSession().then(({ data }) => {
          if (data.session?.user.id) {
            dispatch(refreshPlan(data.session.user.id))
          } else if (attempts < 5) {
            setTimeout(() => tryRefresh(attempts + 1), 800)
          }
        })
      }
      // Используем setTimeout чтобы дать auth-listener время сработать
      setTimeout(() => {
        if (user) {
          dispatch(refreshPlan(user.id))
        } else {
          tryRefresh()
        }
      }, 1500)
    } else if (params.get('payment') === 'cancel') {
      window.history.replaceState({}, '', window.location.pathname)
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  // Применяем бюджетный фильтр поверх найденных блюд
  const visibleDishes = useMemo(() => {
    if (!filters.budgetEnabled || filters.budgetLimit == null) return dishes
    return dishes.filter(
      (d) => d.estimated_cost == null || d.estimated_cost <= filters.budgetLimit!
    )
  }, [dishes, filters.budgetEnabled, filters.budgetLimit])

  const dispatchFindDishes = (ids: number[]) => {
    dispatch(
      findDishes({
        ingredientIds: ids,
        options: {
          // "Докупить" toggle: расширяем до 5 недостающих; иначе — авто (1 на каждые 3 ингредиента)
          allowMissing: filters.allowMissing ? 5 : undefined,
          vegetarianOnly: filters.vegetarianOnly,
          veganOnly: filters.veganOnly,
        },
      })
    )
  }

  const handleFindDishes = () => {
    if (selectedIngredients.length > 0) {
      dispatch(resetSwipe())
      dispatchFindDishes(selectedIngredients)
      setView('dishes')
    }
  }

  const handleRandomize = () => {
    setView('randomizer_focus')
  }

  const handleCuisineSelect = useCallback((cuisine: string) => {
    const focus: RandomizerFocus = {
      cuisine: cuisine as RandomizerFocus['cuisine'],
      mealType: 'any',
      cookingTime: 'any',
      difficulty: 'any',
      vegetarianOnly: false,
    }
    dispatch(setFocus(focus))
    dispatch(randomizeDishesByFocus(focus))
    setView('dishes')
  }, [dispatch])

  const handleDishSelect = useCallback((dishId: number, from: View = 'swipe_results') => {
    setPrevView(from)
    dispatch(fetchRecipe(dishId))
      .finally(() => setView('recipe'))
  }, [dispatch])

  const handlePhotoIngredientsConfirmed = (ids: number[]) => {
    dispatch(resetSwipe())
    dispatch(
      findDishes({
        ingredientIds: ids,
        options: {
          allowMissing: 3,
          vegetarianOnly: filters.vegetarianOnly,
          veganOnly: filters.veganOnly,
        },
      })
    )
    setView('dishes')
  }

  const handlePlannerClick = () => {
    setView('weekly_planner')
  }

  if (!dbInitialized) {
    return (
      <Layout>
        <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '60vh' }}>
          {dbError ? (
            <Alert severity="error">{dbError}</Alert>
          ) : (
            <Box sx={{ textAlign: 'center' }}>
              <CircularProgress sx={{ color: '#FF7A18', mb: 2 }} />
              <Typography variant="body2" color="text.secondary">Загрузка рецептов…</Typography>
            </Box>
          )}
        </Box>
      </Layout>
    )
  }

  return (
    <ModalContext.Provider value={modalContext}>
    <>
      <Layout
        onLogoClick={() => setView('ingredients')}
        onPlannerClick={handlePlannerClick}
        likedCount={likedDishIds.length}
        onFavoritesClick={() => setView('swipe_results')}
        onLoginClick={() => setAuthModalOpen(true)}
        onUpgradeClick={() => setSuccessPaywallOpen(true)}
      >
        {view === 'ingredients' && showTutorial && (
          <TutorialOverlay onClose={() => setShowTutorial(false)} />
        )}

        {view === 'ingredients' && (
          <motion.div
            initial={{ opacity: 0, y: 8 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.35 }}
          >
            <Box sx={{ pb: 3 }}>
              {/* Hero camera section */}
              <IngredientsHero onPhotoClick={() => setView('photo')} />

              {/* Manual ingredient picker — collapsed by default */}
              <Box sx={{ mt: 3 }}>
                <Accordion
                  defaultExpanded={false}
                  elevation={0}
                  sx={{
                    border: '1px solid #E9E9E9',
                    borderRadius: '16px !important',
                    overflow: 'hidden',
                    bgcolor: '#FFFFFF',
                    '&:before': { display: 'none' },
                  }}
                >
                  <AccordionSummary
                    expandIcon={<ExpandMore sx={{ color: 'rgba(0,0,0,0.4)' }} />}
                    sx={{
                      fontWeight: 600,
                      fontSize: '0.9rem',
                      color: '#1A1A1A',
                      minHeight: 48,
                      '& .MuiAccordionSummary-content': { my: 1.5 },
                    }}
                  >
                    Или выберите ингредиенты вручную
                  </AccordionSummary>
                  <AccordionDetails sx={{ pt: 0, pb: 2, px: 2 }}>
                    <IngredientSelector hideTitle />
                  </AccordionDetails>
                </Accordion>
              </Box>

              {/* Filters */}
              <SearchFilters />

              {/* Action buttons */}
              <Box sx={{ mt: 2.5, display: 'flex', gap: 1.5, flexWrap: 'wrap' }}>
                <motion.div
                  style={{ flex: 1, minWidth: 140 }}
                  whileTap={{ scale: 0.97 }}
                >
                  <Button
                    variant="contained"
                    size="large"
                    fullWidth
                    onClick={handleFindDishes}
                    disabled={selectedIngredients.length === 0}
                    startIcon={<Search />}
                    sx={{ py: 1.5, fontSize: '0.95rem', borderRadius: 3 }}
                  >
                    Найти блюда
                    {selectedIngredients.length > 0 && ` (${selectedIngredients.length})`}
                  </Button>
                </motion.div>
                <motion.div whileTap={{ scale: 0.97 }}>
                  <Button
                    variant="outlined"
                    size="large"
                    onClick={handleRandomize}
                    startIcon={<Casino />}
                    sx={{ py: 1.5, px: 2.5, borderRadius: 3, whiteSpace: 'nowrap' }}
                  >
                    Случайное
                  </Button>
                </motion.div>
              </Box>

              {/* Quick ideas section */}
              {dbInitialized && (
                <Box sx={{ mt: 3 }}>
                  <QuickIdeas
                    onDishSelect={(id) => handleDishSelect(id, 'ingredients')}
                    onCuisineSelect={handleCuisineSelect}
                  />
                </Box>
              )}

              {/* Premium status banner for logged-in free users */}
              {user && plan === 'free' && (
                <Box
                  onClick={() => setSuccessPaywallOpen(true)}
                  sx={{
                    mt: 2,
                    p: 1.5,
                    bgcolor: '#FFF8F0',
                    border: '1px solid #FFE0B2',
                    borderRadius: 3,
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    cursor: 'pointer',
                  }}
                >
                  <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.6)', fontSize: '0.82rem' }}>
                    Вы на Free-плане
                  </Typography>
                  <Typography variant="body2" sx={{ color: '#FF7A18', fontWeight: 600, fontSize: '0.82rem' }}>
                    Обновить до Premium →
                  </Typography>
                </Box>
              )}
            </Box>
          </motion.div>
        )}

        {view === 'randomizer_focus' && (
          <RandomizerFocusScreen
            onStart={() => setView('dishes')}
            onBack={() => setView('ingredients')}
          />
        )}

        {view === 'photo' && (
          <PhotoUpload
            onIngredientsConfirmed={handlePhotoIngredientsConfirmed}
            onBack={() => setView('ingredients')}
          />
        )}

        {view === 'dishes' && (
          <SwipeDeck
            dishes={visibleDishes}
            onDishSelect={(dishId) => handleDishSelect(dishId, 'dishes')}
            onComplete={() => setView('swipe_results')}
            onBack={() => setView('ingredients')}
          />
        )}

        {view === 'swipe_results' && (
          <SwipeResults
            onDishSelect={(dishId) => handleDishSelect(dishId, 'swipe_results')}
            onBack={() => setView('dishes')}
            onRepeat={() => setView('dishes')}
            onShoppingList={() => setView('shopping_list')}
          />
        )}

        {view === 'recipe' && (
          <RecipeView onBack={() => setView(prevView)} />
        )}

        {view === 'shopping_list' && (
          <ShoppingList onBack={() => setView('swipe_results')} />
        )}

        {view === 'weekly_planner' && (
          <WeeklyPlanner
            onDishSelect={handleDishSelect}
            onBack={() => setView('ingredients')}
          />
        )}
      </Layout>

      <AuthModal open={authModalOpen} onClose={() => setAuthModalOpen(false)} />

      <PaywallModal
        open={successPaywallOpen}
        onClose={() => setSuccessPaywallOpen(false)}
        onLoginRequired={() => setAuthModalOpen(true)}
        reason={paywallReason ?? 'Разблокируйте все возможности What2Eat'}
      />
    </>
    </ModalContext.Provider>
  )
}

export default App
