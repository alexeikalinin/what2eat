# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
npm run dev       # Start dev server (Vite)
npm run build     # Type-check + build for production (tsc && vite build)
npm run preview   # Preview production build
npm run lint      # ESLint with zero warnings allowed
npm run format    # Prettier format src/**/*.{ts,tsx,json,css}
```

No test runner is configured yet.

## Architecture

**What2Eat** ("ЧтоЕсть") is a meal planning React SPA for a couple. The UI is in Russian. It runs entirely in the browser — SQLite via WASM, with an optional OpenAI API for photo features (requires `VITE_OPENAI_API_KEY` env var).

### Data layer: sql.js (SQLite via WebAssembly)

- `src/services/database.ts` — initializes the SQLite DB using sql.js; exposes `getDatabase()` used by all other services
- The DB is loaded from `database/schema.sql` at startup; seed data populates ingredients, dishes, and recipes
- All queries use parameterized statements (`db.prepare(...).bind([...])`) to avoid SQL injection
- `recipe.instructions` is stored as a JSON string and parsed at read time

### DB schema (5 tables)

- `ingredients` — id, name, category (`meat|cereals|vegetables|dairy|spices|other`), image_url
- `dishes` — id, name, description, image_url, cooking_time (minutes), difficulty (`easy|medium|hard`), servings
- `dish_ingredients` — many-to-many join between dishes and ingredients (used for search)
- `recipes` — one-to-one with dishes; `instructions` is a JSON array of `RecipeStep`
- `recipe_ingredients` — per-recipe ingredient quantities (ingredient_id, quantity, unit)

### Service layer (`src/services/`)

- `ingredients.ts` — `getAllIngredients`, `getIngredientsByCategory`, `searchIngredients`
- `recipes.ts` — `getRecipeByDishId` (joins recipes + dishes + recipe_ingredients in one query)
- `dishes.ts` — dish search by ingredient IDs (ranks by match count, returns up to 5 results)
- `openai.ts` — optional GPT-4o calls: `detectIngredientsFromImage`, `estimateCaloriesFromImage`, `suggestDishesByIngredients` (fallback when DB returns no results)

### State management: Redux Toolkit (`src/store/`)

Six slices — async ones follow `{ data, loading, error }` with `createAsyncThunk`:

| Slice | Key state |
|-------|-----------|
| `ingredients` | `ingredients[]`, `selectedIngredients: number[]`, loading, error |
| `dishes` | `dishes[]`, `aiSuggestions: string[]`, loading, error |
| `recipe` | `currentRecipe: Recipe \| null`, loading, error |
| `filters` | search/filter criteria for dish search |
| `swipe` | `likedDishIds[]`, `dislikedDishIds[]`, `currentIndex`, `sessionComplete` |
| `weeklyPlanner` | `plan: Record<DayOfWeek, dishId \| null>` — persisted to `localStorage` |
| `photo` | photo upload / AI analysis state |

Use typed hooks from `src/hooks/redux.ts` (`useAppSelector`, `useAppDispatch`) instead of raw `useSelector`/`useDispatch`.

### UI: Material UI v5

- Theme defined in `src/main.tsx` (primary `#1976d2`, secondary `#dc004e`)
- Components in `src/components/` each have an `index.ts` re-export
- `IngredientSelector` — reads from Redux, dispatches `toggleIngredient(id)`
- `DishList` / `DishCard` — triggers dish search when selected ingredients change; shows AI suggestions when DB returns nothing
- `RecipeView` — fetches full recipe (steps + per-recipe quantities) when a dish is selected
- `SearchFilters` — filter controls (difficulty, cooking time, category)
- `SwipeDeck` / `SwipeCard` — Tinder-style swipe UI over dishes; dispatches `swipeDish`
- `SwipeResults` — shows liked dishes after swipe session ends
- `WeeklyPlanner` — drag/assign dishes to days Mon–Sun; plan persisted via `weeklyPlannerSlice`
- `ShoppingList` — aggregates ingredients from weekly plan
- `CalorieCard` — displays calorie estimate from OpenAI photo analysis
- `PhotoUpload` — handles camera/file upload, HEIC→JPEG conversion, calls OpenAI to detect ingredients or estimate calories

### Key data flow

1. App init → `fetchIngredients` thunk → `ingredientsService.getAllIngredients()` → SQLite → Redux
2. User selects ingredients → `toggleIngredient(id)` dispatched → `selectedIngredients[]` updated
3. "Find dishes" → `dishesService.findDishesByIngredients(selectedIngredients)` → SQL COUNT match → top 5 results
4. User picks dish → `getRecipeByDishId(dishId)` → full Recipe object → `RecipeView`

### TypeScript types (`src/types/`)

- `Ingredient` — with `IngredientCategory` union type
- `Dish` — with `difficulty` union
- `Recipe` — contains `RecipeStep[]` (parsed from JSON) and `RecipeIngredient[]`
- All exported from `src/types/index.ts`

### Handoff (Claude Code ↔ Cursor)

When switching environments (e.g. limits exhausted), use **`docs/PROGRESS.md`** to sync context. Rule `.cursor/rules/handoff-sync.mdc` instructs Cursor to update this file when the user says they’re switching or asks to “record where we left off”, and to read it when the user asks “where did we stop?”. Keep PROGRESS.md in git so both sides see it.
