import heic2any from 'heic2any'

/** Максимальная сторона изображения для API (OpenAI принимает, но большие файлы дают 400 при лимитах). */
const MAX_IMAGE_SIDE = 2048
const JPEG_QUALITY = 0.92

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

function pickFoodEmoji(name: string): string {
  const n = name.toLowerCase()
  if (/борщ|щи|суп|бульон|рассольник|солянка|похлёб|уха/.test(n)) return '🍲'
  if (/рис|плов|ризотто/.test(n)) return '🍚'
  if (/паста|спагетти|макарон|лапш|феттучини|тальятелле/.test(n)) return '🍝'
  if (/пицца/.test(n)) return '🍕'
  if (/бургер|котлет|биток/.test(n)) return '🍔'
  if (/курица|куриц|цыплёнок|цыпл/.test(n)) return '🍗'
  if (/яйц|омлет|яичница|глазунья/.test(n)) return '🍳'
  if (/торт|кекс|пирожн|бисквит/.test(n)) return '🎂'
  if (/блин|оладь|панкейк/.test(n)) return '🥞'
  if (/сэндвич|тост|бутерброд/.test(n)) return '🥪'
  if (/салат/.test(n)) return '🥗'
  if (/рыб|форел|сёмг|лосос|треска|судак/.test(n)) return '🐟'
  if (/креветк|морепрод/.test(n)) return '🦐'
  if (/мясо|говядин|свинин|баранин|стейк/.test(n)) return '🥩'
  if (/суши|ролл/.test(n)) return '🍣'
  if (/хлеб|лаваш|лепёшка/.test(n)) return '🍞'
  if (/кофе|капучино|латте/.test(n)) return '☕'
  if (/смузи|сок/.test(n)) return '🥤'
  if (/каша|овсян|гречн|манн/.test(n)) return '🥣'
  if (/картоф|пюре/.test(n)) return '🥔'
  if (/пирог|пирожок/.test(n)) return '🥧'
  return '🍽️'
}

// Curated Unsplash photos by dish name keywords — OVERRIDES DB values to prevent mismatches
// IMPORTANT: Order matters — specific dish patterns must come BEFORE generic ingredient patterns
const DISH_IMAGE_OVERRIDES: { pattern: RegExp; url: string }[] = [

  // ── СПЕЦИФИЧНЫЕ БЛЮДА (должны стоять ДО общих паттернов по ингредиентам) ──

  // Яйца Бенедикт / пашот (до общего яиц)
  { pattern: /бенедикт|пашот/i, url: 'https://images.unsplash.com/photo-1608039829572-78524f79c4c7?w=400&h=520&fit=crop&q=80' },
  // Шакшука (яйца в томате — до общего яиц)
  { pattern: /шакшук/i, url: 'https://images.unsplash.com/photo-1590330297626-d7aff25a0431?w=400&h=520&fit=crop&q=80' },
  // Омлет (до общего яиц)
  { pattern: /омлет/i, url: 'https://images.unsplash.com/photo-1510693206972-df098062cb71?w=400&h=520&fit=crop&q=80' },
  // Вареные яйца (до общего яичница)
  { pattern: /вареные? яйц|яйц.{0,8}вар/i, url: 'https://images.unsplash.com/photo-1612893770003-5d67c9e39a2a?w=400&h=520&fit=crop&q=80' },
  // Яичница с помидорами — шакшука (яйца в томатном соусе)
  { pattern: /яичниц.{0,15}помидор|яичниц.{0,15}томат/i, url: 'https://images.unsplash.com/photo-1590330297626-d7aff25a0431?w=400&h=520&fit=crop&q=80' },
  // Яичница с колбасой / беконом — английский завтрак
  { pattern: /яичниц.{0,15}колбас|яичниц.{0,15}бекон/i, url: 'https://images.unsplash.com/photo-1533089860892-a7c6f0a88666?w=400&h=520&fit=crop&q=80' },
  // Яичница с грибами
  { pattern: /яичниц.{0,15}гриб/i, url: 'https://images.unsplash.com/photo-1607532941433-304659e8198a?w=400&h=520&fit=crop&q=80' },
  // Яичница / глазунья (общая)
  { pattern: /яичниц|глазунь/i, url: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80' },

  // Паэлья (до риса)
  { pattern: /паэл/i, url: 'https://images.unsplash.com/photo-1534080564583-6be75777b70a?w=400&h=520&fit=crop&q=80' },
  // Ризотто (до риса)
  { pattern: /ризотто/i, url: 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80' },
  // Жареный рис с яйцом (до общего риса)
  { pattern: /жарен.{0,8}рис/i, url: 'https://images.unsplash.com/photo-1603133872878-684f208fb84b?w=400&h=520&fit=crop&q=80' },

  // Лагман (до макарон/лапши)
  { pattern: /лагман/i, url: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=520&fit=crop&q=80' },
  // Пад Тай (до курицы! содержит "курицей" в названии)
  { pattern: /пад.?тай/i, url: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=520&fit=crop&q=80' },
  // Удон (лапша удон — до общей лапши)
  { pattern: /удон/i, url: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=520&fit=crop&q=80' },
  // Буррито (до курицы; исправлена опечатка буррит vs бурит)
  { pattern: /буррит/i, url: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80' },
  // Кесадилья (до курицы)
  { pattern: /кесадиль/i, url: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80' },
  // Карри (до курицы)
  { pattern: /карри/i, url: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=400&h=520&fit=crop&q=80' },
  // Тажин (до курицы)
  { pattern: /тажин|таджин/i, url: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' },
  // Сациви, Паприкаш (Чкмерули — есть DALL-E в Supabase Storage, убран из override)
  { pattern: /сациви|паприкаш/i, url: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' },
  // Курица терияки (до общей курицы)
  { pattern: /терияки/i, url: 'https://images.unsplash.com/photo-1547592180-85f173990554?w=400&h=520&fit=crop&q=80' },

  // Семга / лосось (до общей рыбы)
  { pattern: /сёмг|семг|лосос/i, url: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80' },

  // Уха (до общего супа)
  { pattern: /уха/i, url: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80' },

  // Творожная запеканка (до общей запеканки → картошка)
  { pattern: /творог.{0,8}запеканк|запеканк.{0,8}творог/i, url: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80' },

  // Гречка с грибами (до общей гречки)
  { pattern: /гречк.{0,8}гриб|гриб.{0,8}гречк/i, url: 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80' },

  // Тушёная капуста (до общей капусты в голубцах)
  { pattern: /капуст.{0,15}туш|туш.{0,15}капуст/i, url: 'https://images.unsplash.com/photo-1540420773420-3366772f4999?w=400&h=520&fit=crop&q=80' },

  // Морковь по-корейски (до общей моркови)
  { pattern: /морков.{0,15}корейск|корейск.{0,15}морков/i, url: 'https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?w=400&h=520&fit=crop&q=80' },

  // Гуляш (до общей говядины/свинины)
  { pattern: /гуляш/i, url: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' },

  // Чили кон карне (до общего чили)
  { pattern: /чили.{0,5}кон.{0,5}карн/i, url: 'https://images.unsplash.com/photo-1589187155587-a6e1a1af65f6?w=400&h=520&fit=crop&q=80' },

  // Картофельное пюре (до общего картофеля)
  { pattern: /картофельное? пюре|пюре.{0,15}картоф/i, url: 'https://images.unsplash.com/photo-1571167366136-f4b1eb35b13e?w=400&h=520&fit=crop&q=80' },
  // Картофельная запеканка (до общего картофеля)
  { pattern: /картофель.{0,10}запеканк|картофельная? запеканк/i, url: 'https://images.unsplash.com/photo-1585032226651-759b368d7246?w=400&h=520&fit=crop&q=80' },

  // Паста Болоньезе (до общей пасты)
  { pattern: /болонь/i, url: 'https://images.unsplash.com/photo-1633337474564-1d9478ca4e2e?w=400&h=520&fit=crop&q=80' },
  // Паста Карбонара (до общей пасты)
  { pattern: /карбонар/i, url: 'https://images.unsplash.com/photo-1612892483236-52d32a0e0ac1?w=400&h=520&fit=crop&q=80' },
  // Ньокки (до общей пасты)
  { pattern: /ньокк/i, url: 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=400&h=520&fit=crop&q=80' },
  // Макароны с сыром (до общей пасты)
  { pattern: /макарон.{0,10}сыр|mac.{0,5}cheese/i, url: 'https://images.unsplash.com/photo-1528736235302-52922df5c122?w=400&h=520&fit=crop&q=80' },
  // Паста с грибами / сливочная (до общей пасты)
  { pattern: /паста.{0,15}гриб|паста.{0,15}сливоч/i, url: 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=400&h=520&fit=crop&q=80' },
  // Макароны с грибами (до общих макарон)
  { pattern: /макарон.{0,15}гриб/i, url: 'https://images.unsplash.com/photo-1555949258-eb67b1ef0ceb?w=400&h=520&fit=crop&q=80' },

  // Окрошка (до общего супа)
  { pattern: /окрошк/i, url: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80' },
  // Суп из чечевицы / минестроне (до общего супа)
  { pattern: /чечевиц|минестрон/i, url: 'https://images.unsplash.com/photo-1476124369491-e7addf5db371?w=400&h=520&fit=crop&q=80' },
  // Суп грибной (до общего супа)
  { pattern: /суп.{0,10}гриб|гриб.{0,10}суп/i, url: 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80' },

  // Овсяная каша (до общей каши и гречки)
  { pattern: /овсян|овсяная? каш/i, url: 'https://images.unsplash.com/photo-1517673400267-0251440c45dc?w=400&h=520&fit=crop&q=80' },
  // Манная каша (до общей каши)
  { pattern: /манн/i, url: 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400&h=520&fit=crop&q=80' },
  // Рисовая каша (до общего риса)
  { pattern: /рисовая? каш/i, url: 'https://images.unsplash.com/photo-1536304993881-ff86e0c9c5e7?w=400&h=520&fit=crop&q=80' },
  // Пшённая каша
  { pattern: /пшённ|пшенн/i, url: 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=400&h=520&fit=crop&q=80' },

  // ── КАТЕГОРИИ БЛЮД ──

  // Супы
  { pattern: /борщ/i, url: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80' },
  { pattern: /щи|рассольник|солянка|харчо/i, url: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80' },
  { pattern: /газпачо/i, url: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80' },
  { pattern: /фо.?бо/i, url: 'https://images.unsplash.com/photo-1559628233-100c798642d7?w=400&h=520&fit=crop&q=80' },
  { pattern: /суп|бульон|похлёб/i, url: 'https://images.unsplash.com/photo-1547592166-23ac45744acd?w=400&h=520&fit=crop&q=80' },

  // Паста / макароны (дифференцированные, общий — последний)
  { pattern: /паста|спагетти|феттучин|тальятелл/i, url: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=520&fit=crop&q=80' },
  { pattern: /макарон|лапш/i, url: 'https://images.unsplash.com/photo-1621996346565-e3dbc646d9a9?w=400&h=520&fit=crop&q=80' },

  // Пицца
  { pattern: /пицц/i, url: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=520&fit=crop&q=80' },

  // Курица
  { pattern: /курица|куриц|цыплёнок|цыпл/i, url: 'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=520&fit=crop&q=80' },

  // Мясо / стейк
  { pattern: /стейк/i, url: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=520&fit=crop&q=80' },
  { pattern: /шашлык|гриль|барбекю/i, url: 'https://images.unsplash.com/photo-1529692236671-f1f6cf9683ba?w=400&h=520&fit=crop&q=80' },
  { pattern: /говядин|говяжий|свинин|свиной|баранин/i, url: 'https://images.unsplash.com/photo-1546833999-b9f581a1996d?w=400&h=520&fit=crop&q=80' },
  { pattern: /бефстроганов/i, url: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' },
  { pattern: /котлет|биток|фрикадел/i, url: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' },
  { pattern: /тефтел/i, url: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' },
  { pattern: /бигос/i, url: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' },
  { pattern: /бургинь|буршиньон/i, url: 'https://images.unsplash.com/photo-1529042410759-befb1204b468?w=400&h=520&fit=crop&q=80' },

  // Рис / плов
  { pattern: /плов/i, url: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80' },
  { pattern: /рис(?! рецепт)/i, url: 'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400&h=520&fit=crop&q=80' },

  // Картофель
  { pattern: /картоф|пюре/i, url: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=520&fit=crop&q=80' },

  // Рыба
  { pattern: /форел|треска|судак|минтай/i, url: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80' },
  { pattern: /рыб/i, url: 'https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?w=400&h=520&fit=crop&q=80' },

  // Суши / роллы
  { pattern: /суши|ролл/i, url: 'https://images.unsplash.com/photo-1553621042-f6e147245754?w=400&h=520&fit=crop&q=80' },

  // Блины / оладьи / драники
  { pattern: /блин|оладь|панкейк|драник/i, url: 'https://images.unsplash.com/photo-1565299543923-37dd37887442?w=400&h=520&fit=crop&q=80' },

  // Каши / гречка (общие — после специфичных выше)
  { pattern: /гречк|каша/i, url: 'https://images.unsplash.com/photo-1574484284002-952d92456975?w=400&h=520&fit=crop&q=80' },

  // Яйца (общий паттерн — после всех специфичных выше)
  { pattern: /яйц/i, url: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80' },

  // Салаты
  { pattern: /салат/i, url: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80' },

  // Пироги / выпечка
  { pattern: /хачапур/i, url: 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=520&fit=crop&q=80' },
  { pattern: /лобиан/i, url: 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=520&fit=crop&q=80' },
  { pattern: /пирог|пирожок|пирожки/i, url: 'https://images.unsplash.com/photo-1586444248902-2f64eddc13df?w=400&h=520&fit=crop&q=80' },
  { pattern: /медовик|торт|кекс|пирожн|бисквит/i, url: 'https://images.unsplash.com/photo-1551024506-0bccd828d307?w=400&h=520&fit=crop&q=80' },
  { pattern: /тирамису/i, url: 'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=400&h=520&fit=crop&q=80' },
  { pattern: /чизкейк/i, url: 'https://images.unsplash.com/photo-1533134242443-d4fd215305ad?w=400&h=520&fit=crop&q=80' },
  { pattern: /панна|котта/i, url: 'https://images.unsplash.com/photo-1488477181946-6428a0291777?w=400&h=520&fit=crop&q=80' },

  // Запеканка (общая — картофельная/мясная; творожная обработана выше)
  { pattern: /запеканк/i, url: 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=400&h=520&fit=crop&q=80' },

  // Хлеб / сэндвичи / тосты
  { pattern: /сэндвич|бутерброд/i, url: 'https://images.unsplash.com/photo-1481070414801-51fd732d7184?w=400&h=520&fit=crop&q=80' },
  { pattern: /тост|гренк|крок-месье|крок месье/i, url: 'https://images.unsplash.com/photo-1481070414801-51fd732d7184?w=400&h=520&fit=crop&q=80' },

  // Бургер
  { pattern: /бургер/i, url: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400&h=520&fit=crop&q=80' },

  // Авокадо тост (до общего авокадо)
  { pattern: /авокадо.{0,10}тост|тост.{0,10}авокадо/i, url: 'https://images.unsplash.com/photo-1525351484163-7529414344d8?w=400&h=520&fit=crop&q=80' },
  // Авокадо
  { pattern: /авокадо/i, url: 'https://images.unsplash.com/photo-1543362906-acfc16c67564?w=400&h=520&fit=crop&q=80' },

  // Творог / сырники
  { pattern: /сырник|творог/i, url: 'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=400&h=520&fit=crop&q=80' },

  // Пельмени / вареники / манты
  { pattern: /пельмен|вареник|манты|хинкал/i, url: 'https://images.unsplash.com/photo-1563379926898-05f4575a45d8?w=400&h=520&fit=crop&q=80' },

  // Голубцы / долма
  { pattern: /голубц|долма|фаршир.{0,10}капуст/i, url: 'https://images.unsplash.com/photo-1534939561126-855b8675edd7?w=400&h=520&fit=crop&q=80' },

  // Жульен
  { pattern: /жульен/i, url: 'https://images.unsplash.com/photo-1604152135912-04a022e23696?w=400&h=520&fit=crop&q=80' },

  // Хумус / фалафель (ближневосточное)
  { pattern: /хумус|фалафел/i, url: 'https://images.unsplash.com/photo-1517191434949-5e90cd67d2b6?w=400&h=520&fit=crop&q=80' },

  // Тако / мексиканское
  { pattern: /тако|бурит[^о]|энчилад|начос/i, url: 'https://images.unsplash.com/photo-1565299585323-38d6b0865b47?w=400&h=520&fit=crop&q=80' },

  // Рагу / рататуй / овощные
  { pattern: /рагу|рататуй|аджапсандал/i, url: 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=400&h=520&fit=crop&q=80' },

  // Дзадзики
  { pattern: /дзадзики/i, url: 'https://images.unsplash.com/photo-1517191434949-5e90cd67d2b6?w=400&h=520&fit=crop&q=80' },
]

/** SVG-заглушка с эмодзи и градиентом — без override-логики. Используется в onError. */
export function getDishSvgFallback(dishName: string): string {
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
  const darkColor = adjustBrightness(color, -30)
  const emoji = pickFoodEmoji(dishName)

  const svg = `<svg width="400" height="520" xmlns="http://www.w3.org/2000/svg">
      <defs>
        <linearGradient id="grad" x1="0%" y1="0%" x2="60%" y2="100%">
          <stop offset="0%" style="stop-color:${color};stop-opacity:1" />
          <stop offset="100%" style="stop-color:${darkColor};stop-opacity:1" />
        </linearGradient>
      </defs>
      <rect width="400" height="520" fill="url(#grad)"/>
      <text x="50%" y="44%" font-family="Apple Color Emoji, Segoe UI Emoji, sans-serif" font-size="72" text-anchor="middle" dominant-baseline="middle">${emoji}</text>
      <text x="50%" y="66%" font-family="Arial, sans-serif" font-size="22" fill="white" text-anchor="middle" dominant-baseline="middle" font-weight="600" opacity="0.92">${dishName}</text>
    </svg>`

  return `data:image/svg+xml;base64,${btoa(unescape(encodeURIComponent(svg)))}`
}

// Генерация цветов для placeholder изображений на основе названия блюда
export function getDishImageUrl(dishName: string, imageUrl: string | null | undefined): string {
  // Supabase Storage (кастомные DALL-E) — всегда приоритет над overrides
  if (imageUrl && imageUrl.includes('supabase')) {
    return imageUrl
  }

  // Keyword override точнее общих Unsplash URL из DB
  for (const { pattern, url } of DISH_IMAGE_OVERRIDES) {
    if (pattern.test(dishName)) return url
  }

  if (imageUrl) {
    return imageUrl
  }

  return getDishSvgFallback(dishName)
}

function adjustBrightness(hex: string, percent: number): string {
  const num = parseInt(hex.replace('#', ''), 16)
  const r = Math.min(255, Math.max(0, (num >> 16) + percent))
  const g = Math.min(255, Math.max(0, ((num >> 8) & 0x00FF) + percent))
  const b = Math.min(255, Math.max(0, (num & 0x0000FF) + percent))
  return '#' + ((1 << 24) + (r << 16) + (g << 8) + b).toString(16).slice(1)
}

