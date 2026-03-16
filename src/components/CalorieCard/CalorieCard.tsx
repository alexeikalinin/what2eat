import { Box, Typography, Paper, LinearProgress } from '@mui/material'
import { CalorieEstimate } from '../../services/openai'
import { useLanguage } from '../../hooks/useLanguage'

interface CalorieCardProps {
  estimate: CalorieEstimate
}

interface MacroRow {
  label: string
  value: number
  unit: string
  color: string
  max: number
}

export default function CalorieCard({ estimate }: CalorieCardProps) {
  const { t } = useLanguage()
  const macros: MacroRow[] = [
    { label: t('protein'), value: estimate.protein, unit: 'г', color: '#6366F1', max: 60 },
    { label: t('fat'), value: estimate.fat, unit: 'г', color: '#FF7A18', max: 80 },
    { label: t('carbs'), value: estimate.carbs, unit: 'г', color: '#22C55E', max: 120 },
  ]

  return (
    <Paper sx={{ p: 3 }}>
      {estimate.description && (
        <Typography variant="subtitle1" gutterBottom>
          {estimate.description}
        </Typography>
      )}

      <Box
        sx={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
          width: 100,
          height: 100,
          borderRadius: '50%',
          border: '6px solid',
          borderColor: 'primary.main',
          mx: 'auto',
          mb: 3,
        }}
      >
        <Box sx={{ textAlign: 'center' }}>
          <Typography variant="h5" fontWeight={700} color="primary">
            {estimate.calories}
          </Typography>
          <Typography variant="caption" color="text.secondary">
            {t('kcal')}
          </Typography>
        </Box>
      </Box>

      <Box sx={{ display: 'flex', flexDirection: 'column', gap: 1.5 }}>
        {macros.map((m) => (
          <Box key={m.label}>
            <Box sx={{ display: 'flex', justifyContent: 'space-between', mb: 0.5 }}>
              <Typography variant="body2">{m.label}</Typography>
              <Typography variant="body2" fontWeight={600}>
                {m.value} {m.unit}
              </Typography>
            </Box>
            <LinearProgress
              variant="determinate"
              value={Math.min((m.value / m.max) * 100, 100)}
              sx={{
                height: 8,
                borderRadius: 4,
                bgcolor: 'grey.200',
                '& .MuiLinearProgress-bar': { bgcolor: m.color, borderRadius: 4 },
              }}
            />
          </Box>
        ))}
      </Box>
    </Paper>
  )
}
