import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit'
import { Recipe } from '../../types'
import { getAllRecipesForDish } from '../../services/recipes'

interface RecipeState {
  recipes: Recipe[]          // все варианты для текущего блюда
  selectedVariant: number    // индекс выбранного варианта
  loading: boolean
  error: string | null
}

const initialState: RecipeState = {
  recipes: [],
  selectedVariant: 0,
  loading: false,
  error: null,
}

export const fetchRecipe = createAsyncThunk(
  'recipe/fetchByDishId',
  async (dishId: number) => {
    const recipes = await getAllRecipesForDish(dishId)
    if (!recipes.length) throw new Error('Recipe not found')
    return recipes
  }
)

const recipeSlice = createSlice({
  name: 'recipe',
  initialState,
  reducers: {
    clearRecipe: (state) => {
      state.recipes = []
      state.selectedVariant = 0
    },
    setVariant: (state, action: PayloadAction<number>) => {
      state.selectedVariant = action.payload
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(fetchRecipe.pending, (state) => {
        state.loading = true
        state.error = null
        state.selectedVariant = 0
      })
      .addCase(fetchRecipe.fulfilled, (state, action) => {
        state.loading = false
        state.recipes = action.payload
        state.selectedVariant = 0
      })
      .addCase(fetchRecipe.rejected, (state, action) => {
        state.loading = false
        state.error = action.error.message || 'Failed to fetch recipe'
      })
  },
})

export const { clearRecipe, setVariant } = recipeSlice.actions
export default recipeSlice.reducer
