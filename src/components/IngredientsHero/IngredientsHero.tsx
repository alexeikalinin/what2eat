import { useRef } from 'react'
import { Box, Typography, Button } from '@mui/material'
import { CameraAlt, PhotoLibrary } from '@mui/icons-material'
import { motion } from 'framer-motion'
import { useLanguage } from '../../hooks/useLanguage'

interface IngredientsHeroProps {
  onPhotoClick: () => void
  onCameraCapture?: (file: File) => void
  previewImageUrl?: string | null
}

export default function IngredientsHero({ onPhotoClick, onCameraCapture, previewImageUrl }: IngredientsHeroProps) {
  const cameraInputRef = useRef<HTMLInputElement>(null)
  const { t } = useLanguage()

  const handleCameraClick = (e: React.MouseEvent) => {
    e.stopPropagation()
    if (onCameraCapture) {
      cameraInputRef.current?.click()
    } else {
      onPhotoClick()
    }
  }

  const handleCameraFile = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0]
    if (file && onCameraCapture) {
      onCameraCapture(file)
      e.target.value = ''
    }
  }
  return (
    <Box>
      {/* Hero Card */}
      <motion.div
        initial={{ opacity: 0, y: 16 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.45, ease: [0.25, 0.1, 0.25, 1] }}
      >
        <Box
          sx={{
            borderRadius: 5,
            overflow: 'hidden',
            position: 'relative',
            minHeight: 220,
            background: 'linear-gradient(145deg, #1A1A2E 0%, #2D2D44 60%, #FF7A18 140%)',
            boxShadow: '0 10px 40px rgba(0,0,0,0.18)',
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'flex-end',
            p: 3,
            cursor: 'pointer',
          }}
          onClick={onPhotoClick}
        >
          {/* Background pattern */}
          <Box
            sx={{
              position: 'absolute',
              inset: 0,
              background: 'radial-gradient(ellipse at 80% 10%, rgba(255,122,24,0.35) 0%, transparent 60%)',
            }}
          />

          {/* Camera icon pulsing */}
          <Box
            sx={{
              position: 'absolute',
              top: 24,
              right: 24,
            }}
          >
            <motion.div
              animate={{ scale: [1, 1.08, 1], opacity: [0.9, 1, 0.9] }}
              transition={{ duration: 2.5, repeat: Infinity, ease: 'easeInOut' }}
            >
              <Box
                sx={{
                  width: 64,
                  height: 64,
                  borderRadius: '50%',
                  background: 'rgba(255,255,255,0.15)',
                  backdropFilter: 'blur(8px)',
                  border: '2px solid rgba(255,255,255,0.25)',
                  display: 'flex',
                  alignItems: 'center',
                  justifyContent: 'center',
                }}
              >
                <CameraAlt sx={{ color: 'white', fontSize: 32 }} />
              </Box>
            </motion.div>
          </Box>

          {/* Preview image or placeholder */}
          {previewImageUrl && (
            <Box
              sx={{
                position: 'absolute',
                inset: 0,
                '&::after': {
                  content: '""',
                  position: 'absolute',
                  inset: 0,
                  background: 'linear-gradient(to top, rgba(0,0,0,0.7) 0%, rgba(0,0,0,0.2) 50%, transparent 100%)',
                },
              }}
            >
              <Box
                component="img"
                src={previewImageUrl}
                alt={t('hero_preview')}
                sx={{ width: '100%', height: '100%', objectFit: 'cover', display: 'block' }}
              />
            </Box>
          )}

          {/* Text content */}
          <Box sx={{ position: 'relative', zIndex: 1 }}>
            <Typography
              variant="h2"
              sx={{
                color: 'white',
                fontWeight: 800,
                fontSize: { xs: '1.4rem', sm: '1.65rem' },
                letterSpacing: '-0.025em',
                lineHeight: 1.2,
                mb: 0.75,
              }}
            >
              {t('hero_photo_cta')}
            </Typography>
            <Typography
              variant="body2"
              sx={{
                color: 'rgba(255,255,255,0.7)',
                fontSize: '0.875rem',
                mb: 2.5,
              }}
            >
              {t('hero_photo_sub')}
            </Typography>

            <Box sx={{ display: 'flex', gap: 1.5, flexWrap: 'wrap' }}>
              {/* Hidden camera input */}
              <input
                ref={cameraInputRef}
                type="file"
                accept="image/*"
                capture="environment"
                style={{ display: 'none' }}
                onChange={handleCameraFile}
              />
              <Button
                variant="contained"
                startIcon={<CameraAlt sx={{ fontSize: 18 }} />}
                onClick={handleCameraClick}
                sx={{
                  bgcolor: 'white',
                  color: '#FF7A18',
                  fontWeight: 700,
                  fontSize: '0.875rem',
                  borderRadius: 3,
                  px: 2.5,
                  py: 1,
                  background: 'white',
                  boxShadow: '0 2px 12px rgba(0,0,0,0.15)',
                  '&:hover': {
                    background: '#FFF5EE',
                    boxShadow: '0 4px 16px rgba(0,0,0,0.2)',
                  },
                }}
              >
                {t('hero_open_camera')}
              </Button>
              <Button
                variant="text"
                startIcon={<PhotoLibrary sx={{ fontSize: 16 }} />}
                onClick={(e) => { e.stopPropagation(); onPhotoClick() }}
                sx={{
                  color: 'rgba(255,255,255,0.85)',
                  fontWeight: 500,
                  fontSize: '0.875rem',
                  borderRadius: 3,
                  px: 1.5,
                  py: 1,
                  '&:hover': {
                    background: 'rgba(255,255,255,0.12)',
                    color: 'white',
                  },
                }}
              >
                {t('hero_upload_photo')}
              </Button>
            </Box>
          </Box>
        </Box>
      </motion.div>
    </Box>
  )
}
