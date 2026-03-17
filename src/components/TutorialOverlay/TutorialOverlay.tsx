import { useState } from 'react'
import {
  Box,
  Typography,
  Button,
  TextField,
  Divider,
  CircularProgress,
  Alert,
} from '@mui/material'
import { CameraAlt, Favorite, CalendarMonth, Login, Google } from '@mui/icons-material'
import { motion, AnimatePresence } from 'framer-motion'
import { setTutorialSeen } from './tutorialStorage'
import { useLanguage } from '../../hooks/useLanguage'
import { useAppDispatch } from '../../hooks/redux'
import {
  loginWithEmail,
  signUpWithEmail,
  loginWithGoogle,
  refreshPlan,
} from '../../store/slices/userSlice'
import { isSupabaseConfigured } from '../../services/supabase'

type AuthMode = 'login' | 'signup'

const INFO_ICONS = [CameraAlt, Favorite, CalendarMonth]
const AUTH_STEP = 3

interface TutorialOverlayProps {
  onClose: () => void
}

export default function TutorialOverlay({ onClose }: TutorialOverlayProps) {
  const [step, setStep] = useState(0)
  const [exiting, setExiting] = useState(false)
  const { t } = useLanguage()
  const dispatch = useAppDispatch()

  // Auth state
  const [authMode, setAuthMode] = useState<AuthMode>('login')
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [googleLoading, setGoogleLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [successMsg, setSuccessMsg] = useState<string | null>(null)

  const infoSteps = [
    { icon: INFO_ICONS[0], title: t('tutorial_step1_title'), text: t('tutorial_step1_desc') },
    { icon: INFO_ICONS[1], title: t('tutorial_step2_title'), text: t('tutorial_step2_desc') },
    { icon: INFO_ICONS[2], title: t('tutorial_step3_title'), text: t('tutorial_step3_desc') },
  ]
  const totalSteps = infoSteps.length + 1
  const isAuthStep = step === AUTH_STEP

  const handleClose = () => {
    setExiting(true)
    setTutorialSeen()
    setTimeout(() => onClose(), 300)
  }

  const handleSubmit = async () => {
    if (!email.trim() || !password.trim()) return
    setLoading(true)
    setError(null)
    setSuccessMsg(null)
    const thunk = authMode === 'login' ? loginWithEmail : signUpWithEmail
    const result = await dispatch(thunk({ email, password }))
    setLoading(false)
    if (thunk.rejected.match(result)) {
      setError((result.payload as string) ?? t('auth_error'))
    } else {
      const user = (result as { payload: { id: string } | null }).payload
      if (user?.id) dispatch(refreshPlan(user.id))
      if (authMode === 'signup') {
        setSuccessMsg(t('auth_check_email_confirm'))
      } else {
        handleClose()
      }
    }
  }

  const handleGoogle = async () => {
    setGoogleLoading(true)
    setError(null)
    const result = await dispatch(loginWithGoogle())
    if (loginWithGoogle.rejected.match(result)) {
      setError((result.payload as string) ?? t('auth_google_error'))
      setGoogleLoading(false)
    }
    // On success the browser redirects to Google
  }

  const supabaseReady = isSupabaseConfigured()

  return (
    <motion.div
      initial={{ opacity: 0 }}
      animate={{ opacity: exiting ? 0 : 1 }}
      exit={{ opacity: 0 }}
      transition={{ duration: 0.3 }}
      style={{
        position: 'fixed',
        inset: 0,
        zIndex: 1300,
        background: 'rgba(255,255,255,0.95)',
        backdropFilter: 'blur(12px)',
        WebkitBackdropFilter: 'blur(12px)',
        display: 'flex',
        alignItems: 'center',
        justifyContent: 'center',
        padding: 32,
        overflowY: 'auto',
      }}
    >
      <Box sx={{ maxWidth: 360, width: '100%', textAlign: 'center' }}>
        <AnimatePresence mode="wait">
          <motion.div
            key={step}
            initial={{ opacity: 0, x: 12 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -12 }}
            transition={{ duration: 0.3 }}
          >
            {/* Icon */}
            <Box
              sx={{
                width: 72,
                height: 72,
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                color: '#fff',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                mx: 'auto',
                mb: 2,
              }}
            >
              {isAuthStep
                ? <Login sx={{ fontSize: 36 }} />
                : (() => { const Icon = infoSteps[step].icon; return <Icon sx={{ fontSize: 36 }} /> })()
              }
            </Box>

            {/* Title + description */}
            <Typography variant="h6" sx={{ fontWeight: 700, color: '#1C1C1E', mb: 1 }}>
              {isAuthStep ? t('tutorial_auth_title') : infoSteps[step].title}
            </Typography>
            <Typography variant="body2" sx={{ color: 'rgba(28,28,30,0.7)', mb: 3, lineHeight: 1.5 }}>
              {isAuthStep ? t('tutorial_auth_desc') : infoSteps[step].text}
            </Typography>

            {/* Auth form (only on last step) */}
            {isAuthStep && (
              <Box sx={{ textAlign: 'left' }}>
                <Button
                  variant="outlined"
                  fullWidth
                  startIcon={googleLoading ? <CircularProgress size={16} /> : <Google />}
                  onClick={handleGoogle}
                  disabled={googleLoading || loading || !supabaseReady}
                  sx={{
                    mb: 1.5,
                    borderRadius: 3,
                    borderColor: '#E0E0E0',
                    color: '#1A1A1A',
                    fontWeight: 600,
                    textTransform: 'none',
                    '&:hover': { borderColor: '#FF7A18', bgcolor: '#FFF8F0' },
                  }}
                >
                  {googleLoading ? `${t('auth_redirecting')}…` : t('auth_google')}
                </Button>

                <Divider sx={{ mb: 2 }}>
                  <Typography variant="caption" sx={{ color: 'rgba(0,0,0,0.4)' }}>
                    {t('auth_or_email')}
                  </Typography>
                </Divider>

                <TextField
                  label={t('auth_email')}
                  type="email"
                  fullWidth
                  size="small"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  sx={{ mb: 1.5 }}
                  disabled={loading}
                  onKeyDown={(e) => e.key === 'Enter' && handleSubmit()}
                  autoComplete="email"
                />
                <TextField
                  label={t('auth_password')}
                  type="password"
                  fullWidth
                  size="small"
                  value={password}
                  onChange={(e) => setPassword(e.target.value)}
                  sx={{ mb: 2 }}
                  disabled={loading}
                  onKeyDown={(e) => e.key === 'Enter' && handleSubmit()}
                  autoComplete={authMode === 'login' ? 'current-password' : 'new-password'}
                  helperText={authMode === 'signup' ? t('auth_password_hint') : undefined}
                />

                {error && (
                  <Alert severity="error" sx={{ mb: 1.5, fontSize: '0.82rem' }}>{error}</Alert>
                )}
                {successMsg && (
                  <Alert severity="success" sx={{ mb: 1.5, fontSize: '0.82rem' }}>{successMsg}</Alert>
                )}

                <Button
                  variant="contained"
                  fullWidth
                  onClick={handleSubmit}
                  disabled={loading || !email.trim() || !password.trim() || !supabaseReady}
                  startIcon={loading ? <CircularProgress size={18} sx={{ color: 'white' }} /> : null}
                  sx={{
                    py: 1.4,
                    borderRadius: 3,
                    fontWeight: 700,
                    background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                    mb: 1.5,
                    textTransform: 'none',
                  }}
                >
                  {authMode === 'login' ? t('auth_login') : t('auth_submit_register')}
                </Button>

                <Box sx={{ textAlign: 'center' }}>
                  {authMode === 'login' ? (
                    <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.55)' }}>
                      {t('auth_no_account')}{' '}
                      <Button
                        size="small"
                        onClick={() => { setAuthMode('signup'); setError(null); setSuccessMsg(null) }}
                        sx={{ p: 0, fontWeight: 600, color: '#FF7A18', minWidth: 0, textTransform: 'none', verticalAlign: 'baseline' }}
                      >
                        {t('auth_register')}
                      </Button>
                    </Typography>
                  ) : (
                    <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.55)' }}>
                      {t('auth_have_account')}{' '}
                      <Button
                        size="small"
                        onClick={() => { setAuthMode('login'); setError(null); setSuccessMsg(null) }}
                        sx={{ p: 0, fontWeight: 600, color: '#FF7A18', minWidth: 0, textTransform: 'none', verticalAlign: 'baseline' }}
                      >
                        {t('auth_login')}
                      </Button>
                    </Typography>
                  )}
                </Box>
              </Box>
            )}
          </motion.div>
        </AnimatePresence>

        {/* Step dots */}
        <Box sx={{ display: 'flex', gap: 1, justifyContent: 'center', mt: 3, mb: 2 }}>
          {Array.from({ length: totalSteps }).map((_, i) => (
            <Box
              key={i}
              sx={{
                width: 8,
                height: 8,
                borderRadius: '50%',
                bgcolor: i === step ? '#FF7A18' : '#E9E9E9',
                transition: 'background 0.2s',
              }}
            />
          ))}
        </Box>

        {/* Navigation */}
        <Box sx={{ display: 'flex', gap: 2, justifyContent: 'center', flexWrap: 'wrap' }}>
          {step > 0 && (
            <Button
              variant="text"
              onClick={() => setStep((s) => s - 1)}
              sx={{ color: '#6C6C70', textTransform: 'none' }}
            >
              {t('tutorial_prev')}
            </Button>
          )}
          {!isAuthStep && (
            <Button
              variant="contained"
              onClick={() => setStep((s) => s + 1)}
              sx={{
                background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                borderRadius: 3,
                textTransform: 'none',
                px: 3,
              }}
            >
              {t('tutorial_next')}
            </Button>
          )}
        </Box>
      </Box>
    </motion.div>
  )
}
