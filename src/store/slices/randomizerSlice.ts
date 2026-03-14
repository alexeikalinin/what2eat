import { createSlice, PayloadAction } from '@reduxjs/toolkit'
import { RandomizerFocus } from '../../services/dishes'

interface RandomizerState {
  focus: RandomizerFocus
}

const initialState: RandomizerState = {
  focus: {
    cuisine: 'any',
    mealType: 'any',
    cookingTime: 'any',
    difficulty: 'any',
    vegetarianOnly: false,
  },
}

const randomizerSlice = createSlice({
  name: 'randomizer',
  initialState,
  reducers: {
    setFocus: (state, action: PayloadAction<RandomizerFocus>) => {
      state.focus = action.payload
    },
  },
})

export const { setFocus } = randomizerSlice.actions
export default randomizerSlice.reducer
