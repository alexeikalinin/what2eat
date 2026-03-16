import { useState } from 'react'
import {
  Box,
  FormControlLabel,
  Switch,
  TextField,
  InputAdornment,
  Typography,
  Collapse,
  Tooltip,
} from '@mui/material'
import { Lock } from '@mui/icons-material'
import { useAppDispatch, useAppSelector } from '../../hooks/redux'
import {
  toggleVegetarian,
  toggleVegan,
  toggleAllowMissing,
  toggleBudget,
  setBudgetLimit,
} from '../../store/slices/filtersSlice'
import { usePlan } from '../../hooks/usePlan'
import PaywallModal from '../PaywallModal'
import { useModalContext } from '../../contexts/ModalContext'
import { useLanguage } from '../../hooks/useLanguage'

export default function SearchFilters() {
  const dispatch = useAppDispatch()
  const { vegetarianOnly, veganOnly, allowMissing, budgetEnabled, budgetLimit } = useAppSelector(
    (state) => state.filters
  )
  const { canUseAdvancedFilters } = usePlan()
  const { openAuth } = useModalContext()
  const { t } = useLanguage()
  const [paywallOpen, setPaywallOpen] = useState(false)

  const isAdvanced = canUseAdvancedFilters()

  function lockedClick() {
    if (!isAdvanced) setPaywallOpen(true)
  }

  return (
    <>
      <Box sx={{ mt: 2 }}>
        <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0, rowGap: 0 }}>
          {/* Вегетарианское — FREE */}
          <FormControlLabel
            control={
              <Switch
                checked={vegetarianOnly}
                onChange={() => dispatch(toggleVegetarian())}
                size="small"
              />
            }
            label={<Typography variant="body2" sx={{ color: 'rgba(0,0,0,0.65)', fontSize: '0.875rem' }}>{t('filters_vegetarian')}</Typography>}
            sx={{ mr: 2, '& .MuiFormControlLabel-label': { ml: 0.5 } }}
          />

          {/* Только веганское — PREMIUM */}
          <Tooltip title={!isAdvanced ? t('filters_premium_only') : ''} placement="top">
            <FormControlLabel
              control={
                <Switch
                  checked={veganOnly}
                  onChange={() => isAdvanced ? dispatch(toggleVegan()) : lockedClick()}
                  size="small"
                  disabled={!isAdvanced}
                />
              }
              label={
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                  <Typography variant="body2" sx={{ color: isAdvanced ? 'rgba(0,0,0,0.65)' : 'rgba(0,0,0,0.38)', fontSize: '0.875rem' }}>
                    {t('filters_vegan')}
                  </Typography>
                  {!isAdvanced && <Lock sx={{ fontSize: 13, color: 'rgba(0,0,0,0.3)' }} />}
                </Box>
              }
              onClick={!isAdvanced ? lockedClick : undefined}
              sx={{ mr: 2, '& .MuiFormControlLabel-label': { ml: 0.5 }, cursor: !isAdvanced ? 'pointer' : 'default' }}
            />
          </Tooltip>

          {/* Немного докупить — PREMIUM */}
          <Tooltip title={!isAdvanced ? t('filters_premium_only') : ''} placement="top">
            <FormControlLabel
              control={
                <Switch
                  checked={allowMissing}
                  onChange={() => isAdvanced ? dispatch(toggleAllowMissing()) : lockedClick()}
                  size="small"
                  disabled={!isAdvanced}
                />
              }
              label={
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                  <Typography variant="body2" sx={{ color: isAdvanced ? 'rgba(0,0,0,0.65)' : 'rgba(0,0,0,0.38)', fontSize: '0.875rem' }}>
                    {t('filters_buy_few')}
                  </Typography>
                  {!isAdvanced && <Lock sx={{ fontSize: 13, color: 'rgba(0,0,0,0.3)' }} />}
                </Box>
              }
              onClick={!isAdvanced ? lockedClick : undefined}
              sx={{ mr: 2, '& .MuiFormControlLabel-label': { ml: 0.5 }, cursor: !isAdvanced ? 'pointer' : 'default' }}
            />
          </Tooltip>

          {/* Бюджет — PREMIUM */}
          <Tooltip title={!isAdvanced ? t('filters_premium_only') : ''} placement="top">
            <FormControlLabel
              control={
                <Switch
                  checked={budgetEnabled}
                  onChange={() => isAdvanced ? dispatch(toggleBudget()) : lockedClick()}
                  size="small"
                  disabled={!isAdvanced}
                />
              }
              label={
                <Box sx={{ display: 'flex', alignItems: 'center', gap: 0.5 }}>
                  <Typography variant="body2" sx={{ color: isAdvanced ? 'rgba(0,0,0,0.65)' : 'rgba(0,0,0,0.38)', fontSize: '0.875rem' }}>
                    {t('filters_budget')}
                  </Typography>
                  {!isAdvanced && <Lock sx={{ fontSize: 13, color: 'rgba(0,0,0,0.3)' }} />}
                </Box>
              }
              onClick={!isAdvanced ? lockedClick : undefined}
              sx={{ '& .MuiFormControlLabel-label': { ml: 0.5 }, cursor: !isAdvanced ? 'pointer' : 'default' }}
            />
          </Tooltip>
        </Box>
        <Collapse in={budgetEnabled && isAdvanced}>
          <Box sx={{ mt: 1, maxWidth: 140 }}>
            <TextField
              size="small"
              type="number"
              label={t('filters_max')}
              value={budgetLimit ?? ''}
              onChange={(e) => dispatch(setBudgetLimit(e.target.value ? Number(e.target.value) : null))}
              InputProps={{
                startAdornment: <InputAdornment position="start">$</InputAdornment>,
              }}
              inputProps={{ min: 1, step: 1 }}
            />
          </Box>
        </Collapse>
      </Box>

      <PaywallModal
        open={paywallOpen}
        onClose={() => setPaywallOpen(false)}
        onLoginRequired={openAuth}
        reason={t('filters_premium_reason')}
      />
    </>
  )
}
