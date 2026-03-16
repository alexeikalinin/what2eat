import { useState, useCallback } from 'react';
import { Language, t as translate, TranslationKeys } from '../i18n';

const STORAGE_KEY = 'what2eat_lang';

function getInitialLang(): Language {
  try {
    const stored = localStorage.getItem(STORAGE_KEY);
    if (stored === 'en' || stored === 'ru') return stored;
  } catch {}
  return 'en';
}

// Singleton state so all components share the same language
let _lang: Language = getInitialLang();
const _listeners = new Set<() => void>();

function setGlobalLang(lang: Language) {
  _lang = lang;
  try { localStorage.setItem(STORAGE_KEY, lang); } catch {}
  _listeners.forEach(fn => fn());
}

export function useLanguage() {
  const [, rerender] = useState(0);

  const subscribe = useCallback(() => {
    const fn = () => rerender(n => n + 1);
    _listeners.add(fn);
    return () => _listeners.delete(fn);
  }, []);

  // Subscribe on mount
  useState(subscribe);

  const toggleLanguage = useCallback(() => {
    setGlobalLang(_lang === 'ru' ? 'en' : 'ru');
  }, []);

  const t = useCallback((key: TranslationKeys) => translate(_lang, key), []);

  return { lang: _lang, toggleLanguage, t };
}

// Standalone t() for use outside React (services etc.)
export function getLang(): Language { return _lang; }
export { translate as tStatic };
