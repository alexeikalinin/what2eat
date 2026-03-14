import { useState } from 'react'
import {
  Box, AppBar, Toolbar, Typography, Container, Button,
  IconButton, Badge, Avatar, Tooltip, Menu, MenuItem,
  ListItemIcon, ListItemText, Divider, Chip,
} from '@mui/material'
import {
  CalendarMonth, RestaurantMenu, Lock, Star, Login,
  Logout, Person, AutoAwesome,
} from '@mui/icons-material'
import { ReactNode } from 'react'
import { useAppSelector, useAppDispatch } from '../../hooks/redux'
import { logout } from '../../store/slices/userSlice'

interface LayoutProps {
  children: ReactNode
  onLogoClick?: () => void
  onPlannerClick?: () => void
  likedCount?: number
  onFavoritesClick?: () => void
  onLoginClick?: () => void
  onUpgradeClick?: () => void
}

export default function Layout({
  children, onLogoClick, onPlannerClick, likedCount,
  onFavoritesClick, onLoginClick, onUpgradeClick,
}: LayoutProps) {
  const dispatch = useAppDispatch()
  const { user, plan } = useAppSelector((state) => state.user)
  const [menuAnchor, setMenuAnchor] = useState<null | HTMLElement>(null)

  const isPremium = plan === 'premium'
  const isLoading = plan === 'loading'
  const plannerLocked = !isPremium

  const handleAvatarClick = (e: React.MouseEvent<HTMLElement>) => {
    setMenuAnchor(e.currentTarget)
  }

  const handleMenuClose = () => setMenuAnchor(null)

  const handleLogout = () => {
    handleMenuClose()
    dispatch(logout())
  }

  const handleUpgrade = () => {
    handleMenuClose()
    onUpgradeClick?.()
  }

  return (
    <Box sx={{ display: 'flex', flexDirection: 'column', minHeight: '100vh', bgcolor: '#F7F8FA' }}>
      <AppBar position="sticky" sx={{ mb: 0 }}>
        <Toolbar sx={{ minHeight: 56, px: { xs: 2, sm: 3 } }}>
          {/* Logo */}
          <Box
            onClick={onLogoClick}
            sx={{
              flexGrow: 1,
              display: 'flex',
              alignItems: 'center',
              gap: 1,
              cursor: onLogoClick ? 'pointer' : 'default',
              userSelect: 'none',
              '&:hover': onLogoClick ? { opacity: 0.8 } : {},
            }}
          >
            <Box
              sx={{
                width: 32,
                height: 32,
                borderRadius: '50%',
                background: 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                flexShrink: 0,
                boxShadow: '0 2px 8px rgba(255,122,24,0.35)',
              }}
            >
              <Typography sx={{ color: 'white', fontWeight: 900, fontSize: '0.85rem', lineHeight: 1, letterSpacing: '-0.02em' }}>
                W
              </Typography>
            </Box>
            <Typography
              variant="h6"
              component="span"
              sx={{
                fontWeight: 800,
                fontSize: '1.15rem',
                letterSpacing: '-0.03em',
                background: 'linear-gradient(90deg, #FF7A18 0%, #FFB347 100%)',
                WebkitBackgroundClip: 'text',
                WebkitTextFillColor: 'transparent',
                backgroundClip: 'text',
              }}
            >
              What2Eat
            </Typography>
          </Box>

          {/* Favorites badge */}
          {likedCount != null && likedCount > 0 && onFavoritesClick && (
            <IconButton
              onClick={onFavoritesClick}
              aria-label="Избранные блюда"
              sx={{
                color: 'rgba(0,0,0,0.45)',
                mr: 0.5,
                '&:hover': { color: '#22C55E', background: 'rgba(34,197,94,0.08)' },
              }}
            >
              <Badge
                badgeContent={likedCount}
                sx={{
                  '& .MuiBadge-badge': {
                    background: 'linear-gradient(135deg, #FF7A18, #FFB347)',
                    color: 'white',
                    fontWeight: 700,
                    fontSize: '0.7rem',
                  },
                }}
                max={99}
              >
                <RestaurantMenu fontSize="small" />
              </Badge>
            </IconButton>
          )}

          {/* Planner button */}
          {onPlannerClick && (
            <Tooltip title={plannerLocked ? 'Только Premium' : 'Планировщик'}>
              <Button
                onClick={onPlannerClick}
                size="small"
                startIcon={
                  plannerLocked
                    ? <Lock sx={{ fontSize: 14 }} />
                    : <CalendarMonth sx={{ fontSize: 16 }} />
                }
                sx={{
                  color: plannerLocked ? 'rgba(0,0,0,0.35)' : 'rgba(0,0,0,0.5)',
                  fontWeight: 500,
                  fontSize: '0.85rem',
                  borderRadius: 10,
                  px: 1.5,
                  minWidth: 0,
                  '&:hover': { color: '#FF7A18', background: 'rgba(255,122,24,0.06)' },
                }}
              >
                <Box component="span" sx={{ display: { xs: 'none', sm: 'inline' } }}>
                  Планировщик
                </Box>
              </Button>
            </Tooltip>
          )}

          {/* User area */}
          {!isLoading && (
            user ? (
              <>
                <Tooltip title={isPremium ? 'Premium аккаунт' : 'Free аккаунт — нажмите для настроек'}>
                  <Box
                    onClick={handleAvatarClick}
                    sx={{ ml: 0.5, position: 'relative', cursor: 'pointer' }}
                  >
                    <Avatar
                      sx={{
                        width: 32,
                        height: 32,
                        background: isPremium
                          ? 'linear-gradient(135deg, #FF7A18 0%, #FFB347 100%)'
                          : 'linear-gradient(135deg, #6366F1, #8B5CF6)',
                        fontSize: '0.8rem',
                        fontWeight: 700,
                      }}
                    >
                      {user.email?.[0].toUpperCase() ?? '?'}
                    </Avatar>
                    {isPremium && (
                      <Star
                        sx={{
                          position: 'absolute',
                          bottom: -2,
                          right: -2,
                          fontSize: 12,
                          color: '#FF7A18',
                          bgcolor: 'white',
                          borderRadius: '50%',
                          p: '1px',
                        }}
                      />
                    )}
                  </Box>
                </Tooltip>

                {/* User dropdown menu */}
                <Menu
                  anchorEl={menuAnchor}
                  open={Boolean(menuAnchor)}
                  onClose={handleMenuClose}
                  transformOrigin={{ horizontal: 'right', vertical: 'top' }}
                  anchorOrigin={{ horizontal: 'right', vertical: 'bottom' }}
                  PaperProps={{
                    sx: { borderRadius: 3, mt: 0.5, minWidth: 220, boxShadow: '0 8px 32px rgba(0,0,0,0.12)' },
                  }}
                >
                  {/* Account info */}
                  <Box sx={{ px: 2, py: 1.5 }}>
                    <Box sx={{ display: 'flex', alignItems: 'center', gap: 1, mb: 0.75 }}>
                      <Person sx={{ fontSize: 16, color: 'rgba(0,0,0,0.4)' }} />
                      <Typography variant="body2" sx={{ color: '#1A1A1A', fontWeight: 600, fontSize: '0.85rem' }}>
                        {user.email}
                      </Typography>
                    </Box>
                    <Chip
                      label={isPremium ? '★ Premium' : 'Free'}
                      size="small"
                      sx={{
                        height: 22,
                        fontSize: '0.72rem',
                        fontWeight: 700,
                        background: isPremium
                          ? 'linear-gradient(135deg, #FF7A18, #FFB347)'
                          : '#F0F0F0',
                        color: isPremium ? 'white' : 'rgba(0,0,0,0.55)',
                      }}
                    />
                  </Box>

                  <Divider />

                  {/* Upgrade to premium (only for free) */}
                  {!isPremium && (
                    <MenuItem
                      onClick={handleUpgrade}
                      sx={{ py: 1.25, color: '#FF7A18' }}
                    >
                      <ListItemIcon>
                        <AutoAwesome sx={{ fontSize: 18, color: '#FF7A18' }} />
                      </ListItemIcon>
                      <ListItemText
                        primary="Перейти на Premium"
                        primaryTypographyProps={{ fontWeight: 700, fontSize: '0.875rem', color: '#FF7A18' }}
                      />
                    </MenuItem>
                  )}

                  <Divider />

                  {/* Logout */}
                  <MenuItem onClick={handleLogout} sx={{ py: 1.25 }}>
                    <ListItemIcon>
                      <Logout sx={{ fontSize: 18, color: 'rgba(0,0,0,0.5)' }} />
                    </ListItemIcon>
                    <ListItemText
                      primary="Выйти"
                      primaryTypographyProps={{ fontSize: '0.875rem', color: 'rgba(0,0,0,0.7)' }}
                    />
                  </MenuItem>
                </Menu>
              </>
            ) : (
              <IconButton
                onClick={onLoginClick}
                size="small"
                sx={{
                  ml: 0.5,
                  color: 'rgba(0,0,0,0.4)',
                  '&:hover': { color: '#FF7A18', background: 'rgba(255,122,24,0.06)' },
                }}
                aria-label="Войти"
              >
                <Login fontSize="small" />
              </IconButton>
            )
          )}
        </Toolbar>
      </AppBar>

      <Container maxWidth="sm" sx={{ flex: 1, pb: 5, pt: 2, px: { xs: 2, sm: 2 } }}>
        {children}
      </Container>
    </Box>
  )
}
