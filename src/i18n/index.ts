import ru from './ru'
import en from './en'

export type Language = 'ru' | 'en'
export type TranslationKeys = keyof typeof ru

const translations: Record<Language, Record<string, string>> = { ru, en }

export function t(lang: Language, key: TranslationKeys): string {
  return translations[lang][key] ?? translations['ru'][key] ?? key
}
