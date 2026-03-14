const TUTORIAL_STORAGE_KEY = 'what2eat_tutorial_seen'

export function getTutorialSeen(): boolean {
  if (typeof window === 'undefined') return true
  return localStorage.getItem(TUTORIAL_STORAGE_KEY) === '1'
}

export function setTutorialSeen(): void {
  if (typeof window === 'undefined') return
  localStorage.setItem(TUTORIAL_STORAGE_KEY, '1')
}
