import { useState } from 'react'
import {
  Dialog,
  DialogContent,
  Box,
  Typography,
  TextField,
  Button,
  IconButton,
  Divider,
  CircularProgress,
  Alert,
} from '@mui/material'
import { Close, Google } from '@mui/icons-material'
import { useAppDispatch } from '../../hooks/redux'
import { loginWithEmail, signUpWithEmail, loginWithGoogle, refreshPlan } from '../../store/slices/userSlice'
import { isSupabaseConfigured } from '../../services/supabase'
import type { AppDispatch } from '../../store'

type Mode = 'login' | 'signup'

interface AuthModalProps {
  open: boolean
  onClose: () => void
}

async function handleEmailAuth(
  dispatch: AppDispatch,
  mode: Mode,
  email: string,
  password: string
): Promise<string | null> {
  const thunk = mode === 'login' ? loginWithEmail : signUpWithEmail
  const result = await dispatch(thunk({ email, password }))
  if (thunk.rejected.match(result)) {
    return (result.payload as string) ?? result.error?.message ?? 'Ошибка'
  }
  const user = (result as { payload: { id: string } | null }).payload
  if (user?.id) {
    dispatch(refreshPlan(user.id))
  }
  return null
}

export default function AuthModal({ open, onClose }: AuthModalProps) {
  const dispatch = useAppDispatch()
  const [mode, setMode] = useState<Mode>('login')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [googleLoading, setGoogleLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [successMsg, setSuccessMsg] = useState<string | null>(null)

  const supabaseReady = isSupabaseConfigured()

  const handleSubmit = async () => {
    if (!email.trim() || !password.trim()) return
    if (!supabaseReady) {
      setError('Supabase не подключён. Заполните VITE_SUPABASE_URL и VITE_SUPABASE_ANON_KEY.')
      return
    }
    setLoading(true)
    setError(null)
    setSuccessMsg(null)
    const err = await handleEmailAuth(dispatch, mode, email, password)
    setLoading(false)
    if (err) {
      setError(err)
    } else if (mode === 'signup') {
      setSuccessMsg('Проверьте почту — мы отправили письмо с подтверждением')
    } else {
      onClose()
    }
  }

  const handleGoogle = async () => {
    if (!supabaseReady) {
      setError('Supabase не подключён. Заполните VITE_SUPABASE_URL и VITE_SUPABASE_ANON_KEY.')
      return
    }
    setGoogleLoading(true)
    setError(null)
    const result = await dispatch(loginWithGoogle())
    if (loginWithGoogle.rejected.match(result)) {
      setError((result.payload as string) ?? 'Ошибка входа через Google')
      setGoogleLoading(false)
    }
    // Если fulfilled — браузер редиректит на Google, loading останется true (OK)
  }

  const handleClose = () => {
    setEmail('')
    setPassword('')
    setError(null)
    setSuccessMsg(null)
    setGoogleLoading(false)
    onClose()
  }

  const switchMode = (next: Mode) => {
    setMode(next)
    setError(null)
    setSuccessMsg(null)
  }

  return (
    <Dialog
      open={open}
      onClose={handleClose}
      maxWidth="xs"
      fullWidth
      PaperProps={{ sx: { borderRadius: 4, m: 2 } }}
    >
      <Box sx={{ px: 3, pt: 3, pb: 1, display: 'flex', alignItems: 'center', justifyContent: 'space-between' }}>
        <Typography variant="h6" sx={{ fontWeight: 700 }}>
          {mode === 'login' ? 'Войти' : 'Создать аккаунт'}
        </Typography>
        <IconButton onClick={handleClose} size="small" sx={{ color: 'rgba(0,0,0,0.4)' }}>
          <Close />
        </IconButton>
      </Box>

      <DialogContent sx={{ px: 3, pt: 1.5 }}>
        {!supabaseReady && (
          <Alert severity="warning" sx={{ mb: 2, fontSize: '0.82rem' }}>
            Supabase не настроен. Для авторизации заполните .env переменные.
          </Alert>
        )}

        <Button
          variant="outlined"
          fullWidth
          startIcon={googleLoading
            ? <CircularProgress size={16} />
            : <Google />
          }
          onClick={handleGoogle}
          disabled={googleLoading || loading || !supabaseReady}
          sx={{
            mb: 2.5,
            borderRadius: 3,
            borderColor: '#E0E0E0',
            color: '#1A1A1A',
            fontWeight: 600,
            '&:hover': { borderColor: '#FF7A18', bgcolor: '#FFF8F0' },
          }}
        >
          {googleLoading ? 'Перенаправляем…' : 'Войти через Google'}
        </Button>

        <Divider sx={{ mb: 2.5 }}>
          <Typography variant="caption" sx={{ color: 'rgba(0,0,0,0.4)' }}>или по email</Typography>
        </Divider>

        <TextField
          label="Email"
          type="email"
          fullWidth
          size="small"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
          sx={{ mb: 2 }}
          onKeyDown={(e) => e.key === 'Enter' && handleSubmit()}
          autoComplete="email"
          disabled={loading}
        />
        <TextField
          label="Пароль"
          type="password"
          fullWidth
          size="small"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          sx={{ mb: 2 }}
          onKeyDown={(e) => e.key === 'Enter' && handleSubmit()}
          autoComplete={mode === 'login' ? 'current-password' : 'new-password'}
          helperText={mode === 'signup' ? 'Минимум 6 символов' : undefined}
          disabled={loading}
        />

        {error && (
          <Alert severity="error" sx={{ mb: 2, fontSize: '0.82rem' }}>
            {error}
          </Alert>
        )}
        {successMsg && (
          <Alert severity="success" sx={{ mb: 2, fontSize: '0.82rem' }}>
            {successMsg}
          </Alert>
        )}

        <Button
          variant="contained"
          fullWidth
          size="large"
          onClick={handleSubmit}
          disabled={loading || !email.trim() || !password.trim() || !supabaseReady}
          startIcon={loading ? <CircularProgress size={18} sx={{ color: 'white' }} /> : null}
          sx={{
            py: 1.4,
            borderRadius: 3,
            fontWeight: 700,
            background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
            mb: 2,
          }}
        >
          {mode === 'login' ? 'Войти' : 'Зарегистрироваться'}
        </Button>

        <Box sx={{ textAlign: 'center', pb: 1 }}>
          {mode === 'login' ? (
            <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.55)' }}>
              Нет аккаунта?{' '}
              <Button
                size="small"
                onClick={() => switchMode('signup')}
                sx={{ p: 0, fontWeight: 600, color: '#FF7A18', minWidth: 0, textTransform: 'none', verticalAlign: 'baseline' }}
              >
                Создать
              </Button>
            </Typography>
          ) : (
            <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.55)' }}>
              Уже есть аккаунт?{' '}
              <Button
                size="small"
                onClick={() => switchMode('login')}
                sx={{ p: 0, fontWeight: 600, color: '#FF7A18', minWidth: 0, textTransform: 'none', verticalAlign: 'baseline' }}
              >
                Войти
              </Button>
            </Typography>
          )}
        </Box>
      </DialogContent>
    </Dialog>
  )
}
