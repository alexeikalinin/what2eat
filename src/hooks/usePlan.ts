import { useAppSelector } from './redux'

const DAILY_SWIPE_LIMIT = 10
const DAILY_AI_PHOTO_LIMIT = 1

function getTodayKey(prefix: string): string {
  const today = new Date().toISOString().slice(0, 10)
  return `${prefix}_${today}`
}

function getLocalCount(key: string): number {
  return parseInt(localStorage.getItem(key) ?? '0', 10)
}

function incrementLocal(key: string): void {
  const cur = getLocalCount(key)
  localStorage.setItem(key, String(cur + 1))
}

export function usePlan() {
  const { plan, usageToday, user } = useAppSelector((state) => state.user)

  const isPremium = plan === 'premium'
  const isLoggedIn = !!user

  function getSwipesUsed(): number {
    if (isLoggedIn) return usageToday.swipes
    return getLocalCount(getTodayKey('w2e_swipes'))
  }

  function getAiPhotoUsed(): number {
    if (isLoggedIn) return usageToday.aiPhoto
    return getLocalCount(getTodayKey('w2e_aiphoto'))
  }

  function canSwipe(): boolean {
    if (isPremium) return true
    return getSwipesUsed() < DAILY_SWIPE_LIMIT
  }

  function swipesRemaining(): number {
    if (isPremium) return Infinity
    return Math.max(0, DAILY_SWIPE_LIMIT - getSwipesUsed())
  }

  function canUseAIPhoto(): boolean {
    if (isPremium) return true
    return getAiPhotoUsed() < DAILY_AI_PHOTO_LIMIT
  }

  function canUseCalories(): boolean {
    return isPremium
  }

  function canUseWeeklyPlanner(): boolean {
    return isPremium
  }

  function canUseAdvancedFilters(): boolean {
    return isPremium
  }

  function canUseAISuggestions(): boolean {
    return isPremium
  }

  function canUseFullRandomizer(): boolean {
    return isPremium
  }

  function trackLocalSwipe(): void {
    if (!isLoggedIn) {
      incrementLocal(getTodayKey('w2e_swipes'))
    }
  }

  function trackLocalAiPhoto(): void {
    if (!isLoggedIn) {
      incrementLocal(getTodayKey('w2e_aiphoto'))
    }
  }

  return {
    plan,
    isPremium,
    isLoggedIn,
    canSwipe,
    swipesRemaining,
    canUseAIPhoto,
    canUseCalories,
    canUseWeeklyPlanner,
    canUseAdvancedFilters,
    canUseAISuggestions,
    canUseFullRandomizer,
    trackLocalSwipe,
    trackLocalAiPhoto,
    DAILY_SWIPE_LIMIT,
    DAILY_AI_PHOTO_LIMIT,
  }
}
