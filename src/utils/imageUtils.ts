import heic2any from 'heic2any'

/** Максимальная сторона изображения для API (OpenAI принимает, но большие файлы дают 400 при лимитах). */
const MAX_IMAGE_SIDE = 1024
const JPEG_QUALITY = 0.85

function isHeic(file: File): boolean {
  return (
    file.type === 'image/heic' ||
    file.type === 'image/heif' ||
    /\.heic$/i.test(file.name) ||
    /\.heif$/i.test(file.name)
  )
}

/**
 * Конвертирует HEIC/HEIF (фото с iPhone) в JPEG через heic2any.
 */
export async function convertHeicToJpegFile(file: File): Promise<File> {
  const blob = await heic2any({
    blob: file,
    toType: 'image/jpeg',
  })
  const jpegBlob = Array.isArray(blob) ? blob[0] : blob
  if (!jpegBlob || !(jpegBlob instanceof Blob)) {
    throw new Error('Не удалось конвертировать HEIC')
  }
  return new File([jpegBlob], file.name.replace(/\.(heic|heif)$/i, '.jpg'), {
    type: 'image/jpeg',
  })
}

/**
 * Подготавливает фото для отправки в OpenAI: конвертирует HEIC в JPEG, сжимает и уменьшает.
 * iPhone часто отдаёт HEIC — API его не поддерживает; HEIC сначала конвертируется через heic2any.
 */
export async function prepareImageForApi(file: File): Promise<{ base64: string; mimeType: string }> {
  let fileToUse = file
  if (isHeic(file)) {
    fileToUse = await convertHeicToJpegFile(file)
  }
  return new Promise((resolve, reject) => {
    const url = URL.createObjectURL(fileToUse)
    const img = new Image()
    img.crossOrigin = 'anonymous'
    img.onload = () => {
      URL.revokeObjectURL(url)
      const w = img.naturalWidth
      const h = img.naturalHeight
      let dw = w
      let dh = h
      if (w > MAX_IMAGE_SIDE || h > MAX_IMAGE_SIDE) {
        if (w >= h) {
          dw = MAX_IMAGE_SIDE
          dh = Math.round((h * MAX_IMAGE_SIDE) / w)
        } else {
          dh = MAX_IMAGE_SIDE
          dw = Math.round((w * MAX_IMAGE_SIDE) / h)
        }
      }
      const canvas = document.createElement('canvas')
      canvas.width = dw
      canvas.height = dh
      const ctx = canvas.getContext('2d')
      if (!ctx) {
        reject(new Error('Canvas not supported'))
        return
      }
      ctx.drawImage(img, 0, 0, dw, dh)
      const dataUrl = canvas.toDataURL('image/jpeg', JPEG_QUALITY)
      const base64 = dataUrl.split(',')[1]
      if (!base64) {
        reject(new Error('Failed to encode image'))
        return
      }
      resolve({ base64, mimeType: 'image/jpeg' })
    }
    img.onerror = () => {
      URL.revokeObjectURL(url)
      reject(new Error('Не удалось загрузить изображение'))
    }
    img.src = url
  })
}

export { isHeic }

// Генерация цветов для placeholder изображений на основе названия блюда
export function getDishImageUrl(dishName: string, imageUrl: string | null | undefined): string {
  if (imageUrl) {
    return imageUrl
  }
  
  // Генерируем цвет на основе названия блюда
  const colors = [
    '#FF6B6B', '#4ECDC4', '#45B7D1', '#FFA07A', '#98D8C8',
    '#F7DC6F', '#BB8FCE', '#85C1E2', '#F8B739', '#52BE80',
    '#EC7063', '#5DADE2', '#58D68D', '#F4D03F', '#AF7AC5'
  ]
  
  let hash = 0
  for (let i = 0; i < dishName.length; i++) {
    hash = dishName.charCodeAt(i) + ((hash << 5) - hash)
  }
  
  const colorIndex = Math.abs(hash) % colors.length
  const color = colors[colorIndex]
  
  // Создаем SVG placeholder с градиентом
  const svg = `
    <svg width="400" height="300" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="grad" x1="0%" y1="0%" x2="100%" y2="100%">
          <stop offset="0%" style="stop-color:${color};stop-opacity:1" />
          <stop offset="100%" style="stop-color:${adjustBrightness(color, -20)};stop-opacity:1" />
        </linearGradient>
      </defs>
      <rect width="400" height="300" fill="url(#grad)"/>
      <text x="50%" y="50%" font-family="Arial, sans-serif" font-size="24" fill="white" text-anchor="middle" dominant-baseline="middle" font-weight="bold">${dishName}</text>
    </svg>
  `.trim()
  
  return `data:image/svg+xml;base64,${btoa(unescape(encodeURIComponent(svg)))}`
}

function adjustBrightness(hex: string, percent: number): string {
  const num = parseInt(hex.replace('#', ''), 16)
  const r = Math.min(255, Math.max(0, (num >> 16) + percent))
  const g = Math.min(255, Math.max(0, ((num >> 8) & 0x00FF) + percent))
  const b = Math.min(255, Math.max(0, (num & 0x0000FF) + percent))
  return '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)
}

