/**
 * Патч выполняется первым при загрузке приложения (импорт из main.tsx).
 * Supabase auth (_exchangeCodeForSession) вызывает Headers.prototype.set()
 * с undefined/невалидным значением → "Failed to execute 'set' on 'Headers': Invalid value".
 * Приводим имя и значение к безопасным строкам до вызова нативного set.
 */
if (typeof Headers !== 'undefined' && Headers.prototype.set) {
  const nativeSet = Headers.prototype.set
  Headers.prototype.set = function (name: string, value: string | string[]) {
    const n = String(name ?? '').trim()
    if (!n) return
    const safe =
      value != null ? (Array.isArray(value) ? value.join(', ') : String(value)) : ''
    nativeSet.call(this, n, safe.replace(/[\x00-\x1F\x7F]/g, ''))
  }
}
