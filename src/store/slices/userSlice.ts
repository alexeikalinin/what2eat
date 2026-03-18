import { createSlice, createAsyncThunk, PayloadAction } from '@reduxjs/toolkit'
import { supabase, isSupabaseConfigured, getUserProfile, getUsageToday, UserPlan } from '../../services/supabase'
import type { User } from '@supabase/supabase-js'

interface UsageToday {
  swipes: number
  aiPhoto: number
}

interface UserState {
  user: User | null
  plan: UserPlan
  usageToday: UsageToday
}

const initialState: UserState = {
  user: null,
  plan: 'loading',
  usageToday: { swipes: 0, aiPhoto: 0 },
}

const GUEST_RESULT = { user: null, plan: 'guest' as UserPlan, usageToday: { swipes: 0, aiPhoto: 0 } }

export const initAuth = createAsyncThunk('user/initAuth', async () => {
  // Если Supabase не настроен — сразу гость, не ждать
  if (!isSupabaseConfigured()) return GUEST_RESULT

  const { data, error } = await supabase.auth.getSession()
  if (error || !data.session) return GUEST_RESULT

  const profile = await getUserProfile(data.session.user.id)
  const plan: UserPlan = profile?.plan === 'premium' ? 'premium' : 'free'
  const usageToday = await getUsageToday(data.session.user.id)
  return { user: data.session.user, plan, usageToday }
})

export const loginWithEmail = createAsyncThunk(
  'user/loginWithEmail',
  async ({ email, password }: { email: string; password: string }, { rejectWithValue }) => {
    const { data, error } = await supabase.auth.signInWithPassword({ email, password })
    if (error) return rejectWithValue(translateAuthError(error.message))
    return data.user
  }
)

export const signUpWithEmail = createAsyncThunk(
  'user/signUpWithEmail',
  async ({ email, password }: { email: string; password: string }, { rejectWithValue }) => {
    const { data, error } = await supabase.auth.signUp({ email, password })
    if (error) return rejectWithValue(translateAuthError(error.message))
    return data.user
  }
)

export const loginWithGoogle = createAsyncThunk(
  'user/loginWithGoogle',
  async (_, { rejectWithValue }) => {
    // redirectTo должен совпадать с одним из Redirect URLs в Supabase Dashboard → Auth → URL Configuration
    const redirectTo = typeof window !== 'undefined' ? window.location.origin : ''
    const { data, error } = await supabase.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo, skipBrowserRedirect: true, queryParams: { prompt: 'select_account' } },
    })
    if (error) return rejectWithValue(translateAuthError(error.message))
    // Явный редирект — не полагаемся на внутренний механизм Supabase
    if (data?.url && typeof window !== 'undefined') {
      window.location.href = data.url
    }
  }
)

export const logout = createAsyncThunk('user/logout', async () => {
  await supabase.auth.signOut()
})

export const refreshPlan = createAsyncThunk('user/refreshPlan', async (userId: string) => {
  const profile = await getUserProfile(userId)
  const plan: UserPlan = profile?.plan === 'premium' ? 'premium' : 'free'
  const usageToday = await getUsageToday(userId)
  return { plan, usageToday }
})

/** Переводит технические ошибки Supabase в понятный русский */
function translateAuthError(msg: string): string {
  if (msg.includes('Invalid login credentials')) return 'Неверный email или пароль'
  if (msg.includes('Email not confirmed')) return 'Подтвердите email перед входом'
  if (msg.includes('User already registered')) return 'Пользователь с таким email уже существует'
  if (msg.includes('Password should be at least')) return 'Пароль должен быть не менее 6 символов'
  if (msg.includes('provider is not enabled') || msg.includes('Unsupported provider'))
    return 'Вход через Google не настроен. Используйте email или обратитесь к администратору.'
  if (msg.includes('rate limit')) return 'Слишком много попыток. Подождите немного.'
  return msg
}

const userSlice = createSlice({
  name: 'user',
  initialState,
  reducers: {
    setUser: (state, action: PayloadAction<User | null>) => {
      state.user = action.payload
      if (!action.payload) {
        state.plan = 'guest'
        state.usageToday = { swipes: 0, aiPhoto: 0 }
      }
    },
    incrementSwipeUsage: (state) => {
      state.usageToday.swipes += 1
    },
    incrementAiPhotoUsage: (state) => {
      state.usageToday.aiPhoto += 1
    },
  },
  extraReducers: (builder) => {
    builder
      .addCase(initAuth.fulfilled, (state, action) => {
        state.user = action.payload.user
        state.plan = action.payload.plan
        state.usageToday = action.payload.usageToday
      })
      .addCase(initAuth.rejected, (state) => {
        state.user = null
        state.plan = 'guest'
      })
      .addCase(loginWithEmail.fulfilled, (state, action) => {
        state.user = action.payload
        state.plan = 'free'
      })
      .addCase(signUpWithEmail.fulfilled, (state, action) => {
        state.user = action.payload
        state.plan = 'free'
      })
      .addCase(logout.fulfilled, (state) => {
        state.user = null
        state.plan = isSupabaseConfigured() ? 'guest' : 'guest'
        state.usageToday = { swipes: 0, aiPhoto: 0 }
      })
      .addCase(refreshPlan.fulfilled, (state, action) => {
        state.plan = action.payload.plan
        state.usageToday = action.payload.usageToday
      })
  },
})

export const { setUser, incrementSwipeUsage, incrementAiPhotoUsage } = userSlice.actions
export default userSlice.reducer
