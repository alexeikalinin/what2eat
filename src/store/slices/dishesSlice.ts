import { createSlice, createAsyncThunk } from '@reduxjs/toolkit'
import { Dish } from '../../types'
import * as dishesService from '../../services/dishes'
import { FindDishesOptions, RandomizerFocus } from '../../services/dishes'
import { suggestDishesByIngredients } from '../../services/openai'

interface DishesState {
  dishes: Dish[]
  suggestedDishNames: string[]
  loading: boolean
  searchComplete: boolean   // true after fulfilled/rejected — prevents "nothing found" flash during load
  error: string | null
}

const initialState: DishesState = {
  dishes: [],
  suggestedDishNames: [],
  loading: false,
  searchComplete: false,
  error: null,
}

export const findDishes = createAsyncThunk(
  'dishes/findByIngredients',
  async ({ ingredientIds, options }: { ingredientIds: number[]; options?: FindDishesOptions }) => {
    return await dishesService.findDishesByIngredients(ingredientIds, options)
  }
)

export const randomizeDishesByFocus = createAsyncThunk(
  'dishes/randomizeByFocus',
  async (focus: RandomizerFocus) => {
    return await dishesService.getDishesByFocus(focus)
  }
)

export const fetchSuggestedDishes = createAsyncThunk(
  'dishes/suggestByAi',
  async (ingredientNames: string[]) => {
    return await suggestDishesByIngredients(ingredientNames)
  }
)

const dishesSlice = createSlice({
  name: 'dishes',
  initialState,
  reducers: {
    clearDishes: (state) => {
      state.dishes = []
      state.suggestedDishNames = []
      state.searchComplete = false
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(findDishes.pending, (state) => {
        state.loading = true
        state.searchComplete = false
        state.error = null
        state.suggestedDishNames = []
      })
      .addCase(findDishes.fulfilled, (state, action) => {
        state.loading = false
        state.searchComplete = true
        state.dishes = action.payload
      })
      .addCase(findDishes.rejected, (state, action) => {
        state.loading = false
        state.searchComplete = true
        state.error = action.error.message || 'Failed to find dishes'
      })
      .addCase(randomizeDishesByFocus.pending, (state) => {
        state.loading = true
        state.searchComplete = false
        state.error = null
      })
      .addCase(randomizeDishesByFocus.fulfilled, (state, action) => {
        state.loading = false
        state.searchComplete = true
        state.dishes = action.payload
      })
      .addCase(randomizeDishesByFocus.rejected, (state, action) => {
        state.loading = false
        state.searchComplete = true
        state.error = action.error.message || 'Failed to randomize dishes'
      })
      .addCase(fetchSuggestedDishes.fulfilled, (state, action) => {
        state.suggestedDishNames = action.payload
      })
      .addCase(fetchSuggestedDishes.rejected, (state) => {
        state.suggestedDishNames = []
      })
  },
})

export const { clearDishes } = dishesSlice.actions
export default dishesSlice.reducer
