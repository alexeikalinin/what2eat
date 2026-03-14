/**
 * Database initialization stub.
 * The app now uses Supabase as the sole database — sql.js has been removed.
 * initDatabase() resolves immediately; getDatabase() is kept for backwards compatibility
 * but will throw if called (no service should be using it anymore).
 */

export async function initDatabase(): Promise<void> {
  // No-op: Supabase is always ready
}

export function getDatabase(): never {
  throw new Error('getDatabase() is obsolete — use Supabase client directly.')
}

export function closeDatabase(): void {
  // no-op
}
