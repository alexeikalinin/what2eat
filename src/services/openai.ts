import { supabase } from './supabase'

export interface CalorieEstimate {
  calories: number
  protein: number
  fat: number
  carbs: number
  description: string
}

const DIRECT_API_URL = 'https://api.openai.com/v1/chat/completions'

/** Проверяет залогинен ли пользователь (валидный токен на сервере) */
async function isUserLoggedIn(): Promise<boolean> {
  const { data: { user } } = await supabase.auth.getUser()
  return !!user
}

/**
 * Вызов OpenAI через Supabase Edge Function прокси (для залогиненных пользователей).
 * supabase.functions.invoke() автоматически добавляет правильные Authorization и apikey заголовки.
 */
async function invokeProxy(action: string, openaiBody: Record<string, unknown>): Promise<Record<string, unknown>> {
  const { data, error } = await supabase.functions.invoke('openai-proxy', {
    headers: { 'X-Action': action },
    body: { ...openaiBody, action },
  })
  if (error) throw new Error(`Proxy error: ${error.message}`)
  return data as Record<string, unknown>
}

/**
 * Прямой вызов OpenAI API (для гостей с VITE_OPENAI_API_KEY).
 */
async function callDirect(openaiBody: Record<string, unknown>): Promise<Record<string, unknown>> {
  const key = import.meta.env.VITE_OPENAI_API_KEY as string | undefined
  if (!key) throw new Error('Для AI функций войдите в аккаунт или задайте VITE_OPENAI_API_KEY.')

  const response = await fetch(DIRECT_API_URL, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${key}` },
    body: JSON.stringify(openaiBody),
  })
  if (!response.ok) {
    const err = await response.text()
    throw new Error(`OpenAI API error: ${response.status} — ${err}`)
  }
  return response.json() as Promise<Record<string, unknown>>
}

/** Универсальный вызов: прокси для залогиненных, прямой для гостей */
async function callOpenAI(action: string, openaiBody: Record<string, unknown>): Promise<Record<string, unknown>> {
  if (import.meta.env.VITE_SUPABASE_URL && await isUserLoggedIn()) {
    return invokeProxy(action, openaiBody)
  }
  return callDirect(openaiBody)
}

/**
 * Шаг 1: GPT свободно называет все продукты на фото (без ограничения списком).
 * Шаг 2: клиент матчит результат с БД (см. PhotoUpload).
 * Такой подход даёт значительно лучшее покрытие.
 */
export async function detectIngredientsFromImage(
  base64: string,
  mimeType: string,
  _ingredientNames: string[]
): Promise<string[]> {
  const prompt = `Внимательно осмотри это фото холодильника или продуктов.

Перечисли ВСЕ продукты питания, которые ты видишь — проверяй каждую полку, каждый контейнер, каждый угол изображения. Включай продукты, в которых уверен на 60% и более. Учитывай: овощи, фрукты, молочные продукты, мясо, яйца, зелень, соусы, напитки, готовые блюда.

Верни ТОЛЬКО JSON массив с названиями продуктов на русском языке, в нижнем регистре, без артиклей.
Пример: ["яйца", "сыр", "помидоры", "зелень", "молоко", "огурцы", "сметана"]
Если ничего не видно: []`

  const body = {
    model: 'gpt-4o',
    max_tokens: 400,
    messages: [
      {
        role: 'user',
        content: [
          { type: 'image_url', image_url: { url: `data:${mimeType};base64,${base64}`, detail: 'high' } },
          { type: 'text', text: prompt },
        ],
      },
    ],
  }

  const data = await callOpenAI('detect_ingredients', body)
  const text: string = (data.choices as { message: { content: string } }[])?.[0]?.message?.content ?? '[]'
  try {
    const match = text.match(/\[[\s\S]*\]/)
    return match ? (JSON.parse(match[0]) as string[]) : []
  } catch {
    return []
  }
}

export async function estimateCaloriesFromImage(
  base64: string,
  mimeType: string,
  lang: 'ru' | 'en' = 'ru'
): Promise<CalorieEstimate> {
  const isEn = lang === 'en'
  const prompt = isEn
    ? `Look at the photo of the dish or food and estimate its nutritional value per serving.
Return ONLY a JSON object in this format:
{"calories": <number>, "protein": <g>, "fat": <g>, "carbs": <g>, "description": "<brief description of the dish in English>"}
No explanations, only JSON.`
    : `Посмотри на фото блюда или продукта и оцени его питательную ценность на одну порцию.
Верни ТОЛЬКО JSON объект в формате:
{"calories": <число>, "protein": <г>, "fat": <г>, "carbs": <г>, "description": "<краткое описание блюда на русском>"}
Без пояснений, только JSON.`

  const body = {
    model: 'gpt-4o',
    max_tokens: 200,
    messages: [
      {
        role: 'user',
        content: [
          { type: 'image_url', image_url: { url: `data:${mimeType};base64,${base64}`, detail: 'low' } },
          { type: 'text', text: prompt },
        ],
      },
    ],
  }

  const data = await callOpenAI('estimate_calories', body)
  const text: string = (data.choices as { message: { content: string } }[])?.[0]?.message?.content ?? '{}'
  try {
    const match = text.match(/\{[\s\S]*\}/)
    if (match) return JSON.parse(match[0]) as CalorieEstimate
  } catch {
    // fall through
  }
  return { calories: 0, protein: 0, fat: 0, carbs: 0, description: 'Не удалось определить' }
}

export async function estimateCaloriesFromRecipe(
  dishName: string,
  ingredients: { name: string; quantity: number; unit: string }[],
  lang: 'ru' | 'en' = 'ru'
): Promise<CalorieEstimate> {
  const isEn = lang === 'en'
  const list = ingredients.map((i) => `${i.name} — ${i.quantity} ${i.unit}`).join('\n')
  const prompt = isEn
    ? `Estimate the nutritional value of the dish "${dishName}" per serving.
Ingredients:
${list}

Return ONLY a JSON object in this format:
{"calories": <number>, "protein": <g>, "fat": <g>, "carbs": <g>, "description": "<brief description in English>"}
No explanations, only JSON.`
    : `Оцени питательную ценность блюда «${dishName}» на одну порцию.
Ингредиенты:
${list}

Верни ТОЛЬКО JSON объект в формате:
{"calories": <число>, "protein": <г>, "fat": <г>, "carbs": <г>, "description": "<краткое описание на русском>"}
Без пояснений, только JSON.`

  const body = {
    model: 'gpt-4o-mini',
    max_tokens: 200,
    messages: [{ role: 'user', content: prompt }],
  }

  const data = await callOpenAI('estimate_calories', body)
  const text: string = (data.choices as { message: { content: string } }[])?.[0]?.message?.content ?? '{}'
  try {
    const match = text.match(/\{[\s\S]*\}/)
    if (match) return JSON.parse(match[0]) as CalorieEstimate
  } catch {
    // fall through
  }
  return { calories: 0, protein: 0, fat: 0, carbs: 0, description: 'Не удалось определить' }
}

export async function suggestDishesByIngredients(ingredientNames: string[]): Promise<string[]> {
  if (ingredientNames.length === 0) return []
  const prompt = `Есть продукты: ${ingredientNames.join(', ')}.
Предложи 3–5 простых блюд, которые можно приготовить из этих продуктов (можно не все использовать).
Верни ТОЛЬКО JSON массив строк с названиями блюд на русском, без пояснений.
Пример: ["Яичница с сыром", "Омлет с овощами"]`

  try {
    const body = {
      model: 'gpt-4o-mini',
      max_tokens: 150,
      messages: [{ role: 'user', content: prompt }],
    }
    const data = await callOpenAI('suggest_dishes', body)
    const text: string = (data.choices as { message: { content: string } }[])?.[0]?.message?.content ?? '[]'
    const match = text.match(/\[[\s\S]*?\]/)
    if (!match) return []
    const arr = JSON.parse(match[0]) as unknown
    return Array.isArray(arr) ? arr.filter((x): x is string => typeof x === 'string').slice(0, 5) : []
  } catch {
    return []
  }
}
