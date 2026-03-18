import { useState, useRef, useCallback, useEffect } from 'react'
import {
  Box,
  Typography,
  Button,
  Tabs,
  Tab,
  Chip,
  CircularProgress,
  Alert,
  Menu,
  MenuItem,
  ListItemText,
  TextField,
  Divider,
} from '@mui/material'
import { CameraAlt, RestaurantMenu, ArrowBack, CloudUpload, Check, Edit, Add, Lock } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useAppDispatch, useAppSelector } from '../../hooks/redux'
import { analyzeIngredients, analyzeCalories, clearPhoto, setError } from '../../store/slices/photoSlice'
import { incrementAiPhotoUsage } from '../../store/slices/userSlice'
import { setSelectedIngredients } from '../../store/slices/ingredientsSlice'
import { prepareImageForApi, convertHeicToJpegFile, isHeic } from '../../utils/imageUtils'
import CalorieCard from '../CalorieCard'
import { usePlan } from '../../hooks/usePlan'
import PaywallModal from '../PaywallModal'
import { useModalContext } from '../../contexts/ModalContext'
import PremiumHint from '../PremiumHint'
import { useLanguage } from '../../hooks/useLanguage'
import { ingredientName } from '../../utils/lang'

interface PhotoUploadProps {
  onIngredientsConfirmed: (ingredientIds: number[]) => void
  onBack: () => void
  initialFile?: File | null
}

export default function PhotoUpload({ onIngredientsConfirmed, onBack, initialFile }: PhotoUploadProps) {
  const dispatch = useAppDispatch()
  const { status, detectedIngredientNames, calorieEstimate, error } = useAppSelector(
    (state) => state.photo
  )
  const { ingredients } = useAppSelector((state) => state.ingredients)
  const { canUseAIPhoto, canUseCalories, trackLocalAiPhoto, isPremium, DAILY_AI_PHOTO_LIMIT } = usePlan()
  const { openAuth } = useModalContext()
  const { t, lang } = useLanguage()
  const [paywallOpen, setPaywallOpen] = useState(false)
  const [paywallReason, setPaywallReason] = useState('')

  const [tab, setTab] = useState(0)
  const [previewUrl, setPreviewUrl] = useState<string | null>(null)
  const [selectedNames, setSelectedNames] = useState<Set<string>>(new Set())
  const [customIngredients, setCustomIngredients] = useState<string[]>([])

  const [addProductAnchor, setAddProductAnchor] = useState<null | HTMLElement>(null)
  const [addSearchQuery, setAddSearchQuery] = useState('')

  const [replaceAnchor, setReplaceAnchor] = useState<null | HTMLElement>(null)
  const [replaceName, setReplaceName] = useState<string | null>(null)
  const [replaceSearchQuery, setReplaceSearchQuery] = useState('')

  const fileInputRef = useRef<HTMLInputElement>(null)

  const handleFile = useCallback(
    async (file: File) => {
      // HEIC/HEIF на iOS Safari имеет type='' — проверяем расширение тоже
      // Android camera apps may also return type='' with a valid image file
      const isHeicFile = /\.(heic|heif)$/i.test(file.name)
      const looksLikeImage = file.type.startsWith('image/') ||
        isHeicFile ||
        file.type === '' || // camera capture on Android often returns empty type
        /\.(jpe?g|png|gif|webp|bmp|tiff?)$/i.test(file.name)
      if (!looksLikeImage) {
        dispatch(setError(t('photo_format_unsupported')))
        return
      }
      dispatch(clearPhoto())
      setSelectedNames(new Set())
      setCustomIngredients([])

      let fileToUse = file
      if (isHeic(file)) {
        try {
          fileToUse = await convertHeicToJpegFile(file)
        } catch {
          dispatch(setError(t('photo_convert_error')))
          return
        }
      }

      const url = URL.createObjectURL(fileToUse)
      setPreviewUrl(url)

      let base64: string
      let mimeType: string
      try {
        const prepared = await prepareImageForApi(fileToUse)
        base64 = prepared.base64
        mimeType = prepared.mimeType
      } catch {
        const supported = ['image/jpeg', 'image/png', 'image/gif', 'image/webp']
        if (!supported.includes(file.type)) {
          dispatch(setError(t('photo_format_hint')))
          return
        }
        const reader = new FileReader()
        const result = await new Promise<string>((res, rej) => {
          reader.onload = () => res((reader.result as string).split(',')[1] ?? '')
          reader.onerror = rej
          reader.readAsDataURL(fileToUse)
        })
        base64 = result
        mimeType = fileToUse.type
      }

      if (tab === 0) {
        if (!canUseAIPhoto()) {
          setPaywallReason(t('photo_ai_paywall_reason'))
          setPaywallOpen(true)
          return
        }
        const result = await dispatch(analyzeIngredients({ base64, mimeType, ingredientNames: [] }))
        if (analyzeIngredients.fulfilled.match(result)) {
          // GPT вернул свободные названия — матчим с БД (fuzzy, case-insensitive)
          const freeNames: string[] = result.payload
          const matched = new Set<string>()
          const custom: string[] = []

          for (const raw of freeNames) {
            const norm = raw.toLowerCase().trim()
            const found = ingredients.find((i) => {
              const iName = i.name.toLowerCase()
              const iNameEn = (i.name_en ?? '').toLowerCase()
              return (
                iName === norm ||
                iNameEn === norm ||
                iName.includes(norm) ||
                norm.includes(iName) ||
                iNameEn.includes(norm) ||
                norm.includes(iNameEn)
              )
            })
            if (found) {
              matched.add(found.name)
            } else {
              custom.push(raw)
            }
          }

          setSelectedNames(matched)
          setCustomIngredients(custom)
          dispatch(incrementAiPhotoUsage())
          trackLocalAiPhoto()
        }
      } else {
        if (!canUseCalories()) {
          setPaywallReason(t('photo_calories_premium_reason'))
          setPaywallOpen(true)
          return
        }
        dispatch(analyzeCalories({ base64, mimeType, lang }))
      }
    },
    [dispatch, ingredients, tab, canUseAIPhoto, canUseCalories, trackLocalAiPhoto, DAILY_AI_PHOTO_LIMIT]
  )

  // Сбрасываем старое состояние фото при каждом открытии компонента (QA 4.9 — нет утечки calorieEstimate)
  useEffect(() => {
    dispatch(clearPhoto())
    if (initialFile) handleFile(initialFile)
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [])

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault()
    const file = e.dataTransfer.files[0]
    if (file) handleFile(file)
  }

  const handleFileInput = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file) handleFile(file)
  }

  const toggleName = (name: string) => {
    setSelectedNames((prev) => {
      const next = new Set(prev)
      if (next.has(name)) next.delete(name)
      else next.add(name)
      return next
    })
  }

  const handleReplace = (oldName: string, newName: string) => {
    setSelectedNames((prev) => {
      const next = new Set(prev)
      next.delete(oldName)
      next.add(newName)
      return next
    })
    setReplaceAnchor(null)
    setReplaceName(null)
    setReplaceSearchQuery('')
  }

  const handleAddProduct = (name: string) => {
    const trimmed = name.trim()
    if (!trimmed) return
    setSelectedNames((prev) => new Set(prev).add(trimmed))
    if (!detectedIngredientNames.includes(trimmed)) {
      setCustomIngredients((prev) => prev.includes(trimmed) ? prev : [...prev, trimmed])
    }
    setAddProductAnchor(null)
    setAddSearchQuery('')
  }

  const handleConfirm = () => {
    const lowerSelected = new Set([...selectedNames].map(s => s.toLowerCase().trim()))
    const ids = ingredients
      .filter((i) => lowerSelected.has(i.name.toLowerCase().trim()))
      .map((i) => i.id)
    if (ids.length === 0) return
    dispatch(setSelectedIngredients(ids))
    onIngredientsConfirmed(ids)
  }

  const handleTabChange = (_: React.SyntheticEvent, newValue: number) => {
    setTab(newValue)
    setPreviewUrl(null)
    dispatch(clearPhoto())
    setSelectedNames(new Set())
    setCustomIngredients([])
  }

  const addFilteredIngredients = ingredients.filter((i) => {
    if (selectedNames.has(i.name)) return false
    if (!addSearchQuery) return true
    return i.name.toLowerCase().startsWith(addSearchQuery.toLowerCase())
  })

  const addQueryIsNew =
    addSearchQuery.trim().length > 0 &&
    !ingredients.some((i) => i.name.toLowerCase() === addSearchQuery.toLowerCase().trim()) &&
    !selectedNames.has(addSearchQuery.trim())

  const replaceFilteredIngredients = ingredients.filter((i) => {
    if (i.name === replaceName) return false
    if (!replaceSearchQuery) return true
    return i.name.toLowerCase().startsWith(replaceSearchQuery.toLowerCase())
  })

  const replaceQueryIsNew =
    replaceSearchQuery.trim().length > 0 &&
    !ingredients.some((i) => i.name.toLowerCase() === replaceSearchQuery.toLowerCase().trim()) &&
    replaceName !== replaceSearchQuery.trim()

  return (
    <motion.div
      initial={{ opacity: 0, y: 8 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.3 }}
    >
      <Box>
        <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2.5 }}>
          <Button
            variant="text"
            onClick={onBack}
            startIcon={<ArrowBack />}
            sx={{ color: 'rgba(0,0,0,0.45)' }}
          >
            {t('back')}
          </Button>
          <Typography variant="h5" sx={{ fontWeight: 700, color: '#1A1A1A' }}>
            📷 {t('photo_title')}
          </Typography>
        </Box>

        <Tabs value={tab} onChange={handleTabChange} sx={{ mb: 3 }}>
          <Tab
            icon={<CameraAlt sx={{ fontSize: 18 }} />}
            iconPosition="start"
            label={
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                {t('photo_detect')}
                {!isPremium && (
                  <Typography variant="caption" sx={{ color: 'rgba(0,0,0,0.38)', fontSize: '0.7rem' }}>
                    {t('photo_daily_limit_caption')}
                  </Typography>
                )}
              </Box>
            }
          />
          <Tab
            icon={isPremium ? <RestaurantMenu sx={{ fontSize: 18 }} /> : <Lock sx={{ fontSize: 16 }} />}
            iconPosition="start"
            label={
              <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                {t('photo_calories')}
                {!isPremium && (
                  <Typography variant="caption" sx={{ color: '#FF7A18', fontSize: '0.7rem', fontWeight: 600 }}>
                    Premium
                  </Typography>
                )}
              </Box>
            }
          />
        </Tabs>

        {/* Upload zone — label wraps input for reliable iOS Safari file selection */}
        <Box
          component="label"
          htmlFor="photo-upload-input"
          onDrop={handleDrop}
          onDragOver={(e) => e.preventDefault()}
          sx={{
            display: 'flex',
            flexDirection: 'column',
            alignItems: 'center',
            justifyContent: 'center',
            gap: 2,
            border: '2px dashed #FFD0A0',
            borderRadius: 4,
            p: 3,
            mb: 3,
            textAlign: 'center',
            cursor: 'pointer',
            bgcolor: previewUrl ? 'transparent' : '#FFFAF5',
            transition: 'all 0.2s ease',
            '&:hover': { bgcolor: '#FFF3E0', borderColor: '#FF7A18' },
            minHeight: previewUrl ? 'auto' : 200,
          }}
        >
          {/* iOS Safari requires label→input pattern; programmatic .click() is unreliable */}
          <input
            id="photo-upload-input"
            ref={fileInputRef}
            type="file"
            accept="image/*,.heic,.heif"
            style={{ display: 'none' }}
            onChange={handleFileInput}
          />
          {previewUrl ? (
            <Box
              component="img"
              src={previewUrl}
              sx={{ maxHeight: 280, maxWidth: '100%', borderRadius: 3, objectFit: 'contain' }}
            />
          ) : (
            <>
              <Box
                sx={{
                  width: 60,
                  height: 60,
                  borderRadius: '50%',
                  bgcolor: '#FFF3E0',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                <CloudUpload sx={{ fontSize: 30, color: '#FF7A18' }} />
              </Box>
              <Box>
                <Typography variant="body1" sx={{ fontWeight: 600, color: '#1A1A1A', mb: 0.5 }}>
                  {t('photo_drop')}
                </Typography>
                <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.45)' }}>
                  {t('photo_or_click')}
                </Typography>
              </Box>
            </>
          )}
        </Box>

        {status === 'analyzing' && (
          <Box sx={{ display: 'flex', alignItems: 'center', gap: 2, mb: 2.5, p: 2, bgcolor: '#FFF8F0', borderRadius: 3 }}>
            <CircularProgress size={22} sx={{ color: '#FF7A18' }} />
            <Typography variant="body2" sx={{ color: '#FF7A18', fontWeight: 600 }}>{t('photo_analyzing')}…</Typography>
          </Box>
        )}

        {status === 'error' && error && (
          <Alert severity="error" sx={{ mb: 2 }}>
            {error}
          </Alert>
        )}

        {tab === 0 && status === 'done' && (
          <Box>
            {selectedNames.size === 0 && customIngredients.length === 0 ? (
              <Alert severity="warning" sx={{ mb: 2 }}>
                {t('photo_not_recognized_try')}
              </Alert>
            ) : (
              <>
                <Typography variant="subtitle1" sx={{ fontWeight: 600, color: '#1A1A1A', mb: 1.5 }}>
                  {t('photo_found_products')} {t('photo_select_hint')}
                </Typography>
                <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 1, mb: 2.5 }}>
                  {[...Array.from(selectedNames), ...customIngredients.filter(n => !selectedNames.has(n))].map((name) => {
                    const isSelected = selectedNames.has(name)
                    const matchedIng = ingredients.find(i => i.name.toLowerCase() === name.toLowerCase())
                    const displayName = matchedIng ? ingredientName(matchedIng, lang) : name
                    return (
                      <motion.div
                        key={name}
                        initial={{ scale: 0.85, opacity: 0 }}
                        animate={{ scale: 1, opacity: 1 }}
                        transition={{ type: 'spring', stiffness: 400, damping: 20 }}
                      >
                        <Chip
                          label={displayName}
                          onClick={() => toggleName(name)}
                          onDelete={(e) => {
                            e.stopPropagation()
                            setReplaceName(name)
                            setReplaceSearchQuery('')
                            setReplaceAnchor((e.currentTarget as HTMLElement).closest('.MuiChip-root') as HTMLElement)
                          }}
                          deleteIcon={<Edit fontSize="small" />}
                          icon={isSelected ? <Check sx={{ fontSize: 14 }} /> : undefined}
                          clickable
                          sx={{
                            bgcolor: isSelected ? '#FF7A18' : '#F5F5F5',
                            color: isSelected ? 'white' : '#1A1A1A',
                            fontWeight: isSelected ? 600 : 400,
                            border: 'none',
                            '& .MuiChip-deleteIcon': {
                              color: isSelected ? 'rgba(255,255,255,0.75)' : 'rgba(0,0,0,0.35)',
                              '&:hover': { color: isSelected ? 'white' : '#1A1A1A' },
                            },
                            '& .MuiChip-icon': { color: isSelected ? 'white' : undefined },
                          }}
                        />
                      </motion.div>
                    )
                  })}
                  <Button
                    size="small"
                    startIcon={<Add sx={{ fontSize: 16 }} />}
                    onClick={(e) => { setAddProductAnchor(e.currentTarget); setAddSearchQuery('') }}
                    sx={{
                      alignSelf: 'center',
                      color: '#FF7A18',
                      fontWeight: 600,
                      fontSize: '0.82rem',
                      '&:hover': { bgcolor: '#FFF3E0' },
                    }}
                  >
                    {t('photo_add_product')}
                  </Button>
                </Box>

                {/* Replace menu */}
                <Menu
                  anchorEl={replaceAnchor}
                  open={Boolean(replaceAnchor) && Boolean(replaceName)}
                  onClose={() => { setReplaceAnchor(null); setReplaceName(null); setReplaceSearchQuery('') }}
                  anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}
                  slotProps={{ paper: { sx: { maxHeight: 360, width: 240, borderRadius: 3 } } }}
                >
                  <Box sx={{ px: 1.5, py: 1 }} onKeyDown={(e) => e.stopPropagation()}>
                    <TextField
                      autoFocus
                      size="small"
                      placeholder={`${t('search')}...`}
                      fullWidth
                      value={replaceSearchQuery}
                      onChange={(e) => setReplaceSearchQuery(e.target.value)}
                    />
                  </Box>
                  <Divider />
                  {replaceQueryIsNew && (
                    <MenuItem onClick={() => replaceName && handleReplace(replaceName, replaceSearchQuery.trim())}>
                      <ListItemText
                        primary={`${t('photo_add_item_prefix')}${replaceSearchQuery.trim()}${t('photo_add_item_suffix')}`}
                        primaryTypographyProps={{ color: '#FF7A18', fontWeight: 600 }}
                      />
                    </MenuItem>
                  )}
                  {replaceFilteredIngredients.map((ing) => (
                    <MenuItem key={ing.id} onClick={() => replaceName && handleReplace(replaceName, ing.name)}>
                      <ListItemText primary={ingredientName(ing, lang)} />
                    </MenuItem>
                  ))}
                  {replaceFilteredIngredients.length === 0 && !replaceQueryIsNew && (
                    <MenuItem disabled>{t('photo_nothing_found')}</MenuItem>
                  )}
                </Menu>

                {/* Add product menu */}
                <Menu
                  anchorEl={addProductAnchor}
                  open={Boolean(addProductAnchor)}
                  onClose={() => { setAddProductAnchor(null); setAddSearchQuery('') }}
                  anchorOrigin={{ vertical: 'bottom', horizontal: 'left' }}
                  slotProps={{ paper: { sx: { maxHeight: 360, width: 240, borderRadius: 3 } } }}
                >
                  <Box sx={{ px: 1.5, py: 1 }} onKeyDown={(e) => e.stopPropagation()}>
                    <TextField
                      autoFocus
                      size="small"
                      placeholder={t('photo_search_placeholder')}
                      fullWidth
                      value={addSearchQuery}
                      onChange={(e) => setAddSearchQuery(e.target.value)}
                      onKeyDown={(e) => {
                        if (e.key === 'Enter' && addSearchQuery.trim()) {
                          e.preventDefault()
                          handleAddProduct(addSearchQuery.trim())
                        }
                      }}
                    />
                  </Box>
                  <Divider />
                  {addQueryIsNew && (
                    <MenuItem onClick={() => handleAddProduct(addSearchQuery.trim())}>
                      <ListItemText
                        primary={`${t('photo_add_item_prefix')}${addSearchQuery.trim()}${t('photo_add_item_suffix')}`}
                        primaryTypographyProps={{ color: '#FF7A18', fontWeight: 600 }}
                      />
                    </MenuItem>
                  )}
                  {addFilteredIngredients.map((ing) => (
                    <MenuItem key={ing.id} onClick={() => handleAddProduct(ing.name)}>
                      <ListItemText primary={ingredientName(ing, lang)} />
                    </MenuItem>
                  ))}
                  {addFilteredIngredients.length === 0 && !addQueryIsNew && (
                    <MenuItem disabled>{t('photo_nothing_found')}</MenuItem>
                  )}
                </Menu>

                <Button
                  variant="contained"
                  size="large"
                  onClick={handleConfirm}
                  disabled={selectedNames.size === 0}
                  fullWidth
                  sx={{ py: 1.5, fontSize: '0.95rem', borderRadius: 3 }}
                >
                  {t('app_find_dishes')} ({selectedNames.size})
                </Button>

                {!isPremium && !canUseAIPhoto() && (
                  <Box sx={{ mt: 2 }}>
                    <PremiumHint
                      variant="banner"
                      text={t('photo_daily_limit_hint')}
                      paywallReason={t('photo_ai_paywall_reason')}
                    />
                  </Box>
                )}
              </>
            )}
          </Box>
        )}

        {tab === 1 && !isPremium && !previewUrl && (
          <Box
            onClick={() => { setPaywallReason(t('photo_calories_premium_reason')); setPaywallOpen(true) }}
            sx={{
              textAlign: 'center',
              py: 4,
              px: 2,
              bgcolor: '#FFF8F0',
              borderRadius: 3,
              border: '1px solid #FFE0B2',
              cursor: 'pointer',
            }}
          >
            <Lock sx={{ color: '#FF7A18', fontSize: 36, mb: 1 }} />
            <Typography variant="subtitle1" sx={{ fontWeight: 700, color: '#1A1A1A', mb: 0.5 }}>
              {t('photo_premium_only')}
            </Typography>
            <Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.55)', mb: 2 }}>
              {t('photo_calories_desc')}
            </Typography>
            <Button variant="contained" size="small" sx={{ background: 'linear-gradient(135deg, #FF7A18, #FFB347)', borderRadius: 2 }}>
              {t('photo_connect_premium')}
            </Button>
          </Box>
        )}

        {tab === 1 && status === 'done' && calorieEstimate && (
          <Box sx={{ maxWidth: 400 }}>
            <CalorieCard estimate={calorieEstimate} />
          </Box>
        )}
      </Box>

      <PaywallModal
        open={paywallOpen}
        onClose={() => setPaywallOpen(false)}
        onLoginRequired={openAuth}
        reason={paywallReason}
      />
    </motion.div>
  )
}
