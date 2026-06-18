# AUDIT.md — Фаза 1: Аудит и инвентаризация

**Дата аудита:** 2026-06-18
**Цель:** Полная инвентаризация всех внешних зависимостей, отсутствующих локальных ассетов и потенциальных проблем.

---

## 1. Структура проекта

```
D:\katyafitness\
├── index.html              (~6297 строк)
├── june_top5.html          (~7528 строк)
├── payment.html            (~4327 строк)
├── assets_main/            (140 файлов)
├── assets_top5/            (82 файла)
├── payment_files/          (149 файлов)
├── AGENTS.md
├── SPEC.md
├── REFACTORING.md
├── package.json
└── node_modules/
```

---

## 2. Внешние зависимости в HTML-файлах

### 2.1 index.html

| Строка | Тип | URL | Критичность | Действие |
|--------|-----|-----|-------------|----------|
| 2 | HTML-комментарий | `https://usmanovafit.gymteam.ru/mainpage#form` | Низкая | Удалить комментарий |
| 34 | Google Fonts CDN | `https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap` | **Высокая** | Заменить на локальные шрифты |
| 35 | Google Fonts CDN | `https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700&display=swap` | **Высокая** | Заменить на локальные шрифты |
| 4904-6253 | Соцсети | `t.me`, `vk.ru`, `max.ru` | Низкая | Оставить (валидные внешние ссылки) |

### 2.2 june_top5.html

| Строка | Тип | URL | Критичность | Действие |
|--------|-----|-----|-------------|----------|
| 2 | HTML-комментарий | `https://usmanovafit.gymteam.ru/june_top5...` | Низкая | Удалить |
| 35 | Google Fonts CDN | `https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap` | **Высокая** | Заменить на локальные |
| 36 | Google Fonts CDN | `https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700&display=swap` | **Высокая** | Заменить на локальные |
| 44 | og:url | `https://usmanovafit.gymteam.ru/june_top5...` | Средняя | Заменить на локальный URL |
| 5015 | Якорь формы | `https://usmanovafit.gymteam.ru/june_top5...#form` | Средняя | Заменить на `#form` |
| 6710 | Контакт | `https://usmanovafit.gymteam.ru/cms/system/contact` | Средняя | Заменить на `#` |
| 6711 | Оферта | `https://usmanovafit.gymteam.ru/oferta_fitnes` | Средняя | Заменить на `#` |
| 6712 | Политика | `https://usmanovafit.gymteam.ru/protection_fitnes` | Средняя | Заменить на `#` |
| 6713 | Персональные данные | `https://usmanovafit.gymteam.ru/personaldata` | Средняя | Заменить на `#` |
| 6747-6748, 7094 | Hidden form helpers | `https://usmanovafit.gymteam.ru/june_top5...` | Средняя | Очистить |
| 5615-5777 | Соцсети | `t.me`, `vk.ru`, `max.ru` | Низкая | Оставить |

### 2.3 payment.html

| Строка | Тип | URL | Критичность | Действие |
|--------|-----|-----|-------------|----------|
| 2 | HTML-комментарий | `https://usmanovafit.gymteam.ru/sales/shop/dealPay/...` | Низкая | Удалить |
| 16 | Favicon | `https://fs.getcourse.ru/fileservice/file/download/...png` | **Высокая** | Скачать локально |
| 296 | Яндекс.Метрика | `https://mc.yandex.ru/metrika/tag.js?id=106868527` | **Высокая** | Удалить |
| 300 | Яндекс.Метрика | `https://mc.yandex.ru/watch/106868527` | **Высокая** | Удалить |
| 332 | Ссылка | `https://usmanovafit.gymteam.ru/` | Средняя | Заменить на `./index.html` |
| 750 | CSS bg image | `https://fs.getcourse.ru/...656ba5c6fe217410582063e1c343c314.png` | **Высокая** | Скачать локально |
| 810 | CSS bg image | `https://fs.getcourse.ru/...e1e76605d365b1ccde6a633c185eb5cd.png` | **Высокая** | Скачать локально |
| 816 | CSS bg image | `https://fs.getcourse.ru/...1e22f60a99c0985e65c18df6bfa92cdc.png` | **Высокая** | Скачать локально |
| 821 | CSS bg image | `https://fs.getcourse.ru/...f5d0bab362fd5fbb108ae2bf3eb8a963.png` | **Высокая** | Скачать локально |
| 834 | CSS bg image | `https://fs.getcourse.ru/...144dac04c7d84d33d8d753cecc92a00f.png` | **Высокая** | Скачать локально |
| 839 | CSS bg image | `https://fs.getcourse.ru/...31f19fedd1be892bf9db4a04f51a6038.png` | **Высокая** | Скачать локально |
| 1165 | CSS bg image | `https://fs.getcourse.ru/...f1970cb7a55cf6f483daf09b13369114.svg` | **Высокая** | Скачать локально |
| 2470, 2483 | Юридические ссылки | `https://usmanovafit.gymteam.ru/oferta_fitnes`, `protection_fitnes` | Средняя | Заменить на `#` |
| 2600-2719 | Кнопки оплаты (x6) | `https://usmanovafit.gymteam.ru/sales/shop/dealPay/...#` | Средняя | Заменить на `#` |
| 2756 | CloudPayments SDK | `https://widget.cloudpayments.ru/bundles/cloudpayments/` | Средняя | Удалить/документировать |
| 2787 | Редирект после оплаты | `https://usmanovafit.gymteam.ru/sales/shop/dealPaid/...` | Средняя | Заменить на `#` |
| 3277 | AJAX cooldown | `https://usmanovafit.gymteam.ru/sales/shop/cooldownPeriodApply` | Средняя | Заменить на `/api/cooldown` |
| 3372 | Telegram bot | `https://t.me/UsmanovaSport_bot` | Низкая | Оставить |
| 4292 | Закомментированный трекер | `https://vhencapi13.gcfiles.net/st/stat.js` | **Высокая** | Удалить |

---

## 3. Внешние зависимости в JS-файлах

### 3.1 Критичные (реальные вызовы, не комментарии)

| Файл | Строка | URL | Критичность | Действие |
|------|--------|-----|-------------|----------|
| `payment_files/phone_confirm.js` | 8 | `https://www.google.com/recaptcha/api.js` | **Высокая** | Удалить/замокать |
| `payment_files/clarity.js` | 100 | `https://usmanovafit.gymteam.ru/chtm/s/metric/socket-bundle.*.js` | **Высокая** | Удалить файл |
| `payment_files/clarity.js` | 183 | `https://usmanovafit.gymteam.ru/chtm/s/metric/clarity.gif` | **Высокая** | Удалить файл |
| `payment_files/clarity.js` | 402 | `https://t.me/` (Telegram bot link) | Низкая | Удалить файл |
| `payment_files/clarity.js` | 595 | `https://usmanovafit.gymteam.ru/chtm/s/metric/behaviourBeacon` | **Высокая** | Удалить файл |
| `payment_files/clarity.js` | 614 | `https://usmanovafit.gymteam.ru/chtm/s/metric/behaviour.gif` | **Высокая** | Удалить файл |
| `payment_files/xdget-view-ca11d7935d3a81ff8ae46dff68d943d7.js` | 119 | `https://vk.com` (VK Auth) | Средняя | Удалить |
| `payment_files/xdget-view-ca11d7935d3a81ff8ae46dff68d943d7.js` | 191 | `https://www.youtube.com/embed/` | Средняя | Удалить |
| `payment_files/xdget-view-ca11d7935d3a81ff8ae46dff68d943d7.js` | 298-312 | Соцсети (VK, TG, FB, Twitter, OK, WhatsApp, Viber) | Средняя | Удалить |
| `payment_files/tag.js` | 112-626 | Множество URL Яндекс.Метрики | **Высокая** | Удалить файл |
| `assets_main/superlite-block-abe5dddff141bb1b6762071a4f0ff3e8.js` | 99 | `https://player.vimeo.com/video/`, `https://www.youtube.com/player_api` | Средняя | Удалить/замокать |
| `assets_main/replace.js` | 35 | `https://vh02.gcfiles.net:8083/vod_hls/fileservice/file/download-proxy/h/` | **Высокая** | Удалить/заменить |
| `assets_top5/superlite-block-abe5dddff141bb1b6762071a4f0ff3e8.js` | 99 | Vimeo + YouTube | Средняя | Удалить/замокать |
| `assets_top5/replace.js` | 35 | `https://vh02.gcfiles.net:8083/...` | **Высокая** | Удалить/заменить |

### 3.2 Неактивные (комментарии, лицензии, regex-паттерны)

Большинство внешних URL в JS — это комментарии с лицензиями или URL-паттерны валидаторов. **Не требуют действий.**

Примеры:
- `jquery.countdown.min.js:1` — лицензия `http://keith-wood.name/countdown.html`
- `jquery.inputmask.bundle.js:2431` — regex-паттерн для валидации URL
- `main.js:610` — проверка протокола `href.startsWith('https://')`

---

## 4. Внешние зависимости в CSS-файлах

### 4.1 Критичные

| Файл | Строка | URL | Критичность | Действие |
|------|--------|-----|-------------|----------|
| `assets_main/proxima.css` | 2 | `@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;700&display=swap')` | **Высокая** | Заменить на @font-face |
| `assets_top5/proxima.css` | 2 | `@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;700&display=swap')` | **Высокая** | Заменить на @font-face |

### 4.2 Проблемные пути

| Файл | Проблема | Критичность |
|------|----------|-------------|
| `payment_files/als-granate-vf-new.css` | Ссылается на `../new-fonts/` — директория **не существует** | **Высокая** |
| `payment_files/glyphicons.css` | Ссылается на `fonts/glyphicons-*` — директория `payment_files/fonts/` **не существует** | **Высокая** |
| `payment_files/v4-font-face.css` | Ссылается на `../webfonts/` — директория `payment_files/webfonts/` **не существует** | **Высокая** |
| `payment_files/v5-font-face.css` | Ссылается на `../webfonts/` — **не существует** | **Высокая** |
| `payment_files/old.css` | Ссылается на `../webfonts/v4/` и `../webfonts/v5/` — **не существуют** | **Высокая** |
| `payment_files/fonts(1).css` | Вероятный дубликат `fonts.css` | Средняя |

### 4.3 Безопасные (комментарии/лицензии)

- `all.css`, `v4-font-face.css`, `v5-font-face.css`, `v4-shims.css` в `payment_files/`, `assets_main/`, `assets_top5/` — внешние URL в комментариях лицензий Font Awesome. **Не требуют действий.**
- `bootstrap.min.css` — ссылки в комментариях. **Не требуют действий.**

---

## 5. Проверка локальных ассетов

### 5.1 Шрифты

| Шрифт | Ожидается в | Наличие | Статус |
|-------|-------------|---------|--------|
| Roboto (300,400,500,700) | `assets_main/fonts/`, `assets_top5/fonts/` | **Отсутствуют** | Необходимо скачать |
| Open Sans (300,400,500,600,700) | `assets_main/fonts/`, `assets_top5/fonts/` | **Отсутствуют** | Необходимо скачать |
| Manrope (300,400,700) | `assets_main/fonts/`, `assets_top5/fonts/` | **Отсутствуют** | Необходимо скачать |
| Manrope (300,400,700) TTF | `payment_files/fonts/` | **Директория не существует** | Необходимо скачать + создать |
| Gilroy (400,500,600) | `assets_main/fonts/` | Есть | OK |
| Gilroy (400,500,600) | `assets_top5/fonts/` | Есть | OK |
| Gilroy (400,500,700,800) | `payment_files/` | Есть (корневой) | OK |
| Glyphicons | `assets_main/fonts/`, `assets_top5/fonts/` | Есть | OK |
| Font Awesome 4/5/6 webfonts | `assets_main/webfonts/`, `assets_top5/webfonts/` | Есть | OK |
| Font Awesome v4 (payment) | `payment_files/webfonts/v4/` | **Директория не существует** | Критично |
| Font Awesome v5 (payment) | `payment_files/webfonts/v5/` | **Директория не существует** | Критично |
| Font Awesome 6 (payment) | `payment_files/webfonts/` | **Директория не существует** | Критично |
| ALS Granate VF | `new-fonts/` | **Директория не существует** | Критично |

### 5.2 CSS-файлы шрифтов

| Файл | Состояние |
|------|-----------|
| `assets_main/roboto-cyr-swap.css` | **Пустой** (1 строка-комментарий) — нужен @font-face |
| `assets_main/open-sans-cyr-swap.css` | **Пустой** (1 строка-комментарий) — нужен @font-face |
| `assets_main/proxima.css` | Только `@import` Google Fonts — нужен @font-face |
| `assets_top5/roboto-cyr-swap.css` | Предположительно пустой (аналогично) |
| `assets_top5/open-sans-cyr-swap.css` | Предположительно пустой (аналогично) |
| `assets_top5/proxima.css` | Только `@import` Google Fonts |
| `payment_files/manrope.css` | @font-face на `fonts/Manrope-*.ttf` — **файлы отсутствуют** |
| `payment_files/proxima.css` | @font-face на `fonts/Manrope-*.ttf` — **файлы отсутствуют** |

### 5.3 Изображения

| Ресурс | Ожидается в | Наличие | Статус |
|--------|-------------|---------|--------|
| 8 изображений GetCourse CDN | `payment_files/images/getcourse/` | **Отсутствуют** | Необходимо скачать |
| Логотип (файл `63`) | `payment_files/63` | Есть (3537 байт, без расширения) | Нужно переименовать |

---

## 6. Трекеры и аналитика

| Трекер | Файл | Критичность | Действие |
|--------|------|-------------|----------|
| Яндекс.Метрика (инлайн) | `payment.html:290-301` | **Высокая** | Удалить |
| Яндекс.Метрика (tag.js) | `payment_files/tag.js` | **Высокая** | Удалить файл |
| Яндекс.Метрика (tag_phono.js) | `payment_files/tag_phono.js` | **Высокая** | Удалить файл |
| Clarity.js (поведенческая аналитика) | `payment_files/clarity.js` | **Высокая** | Удалить файл |
| stat.js (закомментированный) | `payment.html:4292` | Средняя | Удалить комментарий |
| Facebook Pixel ID | `index.html:44`, `june_top5.html:45` | Средняя | Удалить meta-тег |
| reCAPTCHA Google | `payment_files/phone_confirm.js:8` | Средняя | Удалить/замокать |
| CloudPayments SDK | `payment.html:2756` | Средняя | Удалить/документировать |
| Gemini Agent iframe | `payment.html:4298` | Низкая | Удалить если не нужен |

---

## 7. Сводная статистика

| Категория | Количество | Критичных |
|-----------|------------|-----------|
| Внешние URL в HTML | 60 | 14 |
| Внешние URL в JS (активные) | 14 | 6 |
| Внешние URL в CSS (активные) | 2 | 2 |
| Отсутствующие локальные ассеты | 6 групп | 6 |
| Трекеры/аналитика | 9 | 5 |
| **Итого критичных проблем** | | **33** |

---

## 8. Приоритеты для Фазы 2

### P0 — Немедленно
1. Скачать шрифты Roboto, Open Sans, Manrope локально
2. Создать директорию `payment_files/fonts/` и скачать Manrope TTF
3. Создать директорию `payment_files/webfonts/` и скопировать Font Awesome
4. Скачать 8 изображений GetCourse CDN в `payment_files/images/getcourse/`
5. Заполнить CSS @font-face файлы (roboto-cyr-swap.css, open-sans-cyr-swap.css, proxima.css)

### P1 — Скоро
1. Удалить Яндекс.Метрику (инлайн + tag.js + tag_phono.js)
2. Удалить clarity.js
3. Удалить Google Fonts CDN ссылки из HTML
4. Удалить Facebook Pixel ID

### P2 — Позже
1. Заменить ссылки на оригинальный сайт
2. Удалить/замокать CloudPayments, reCAPTCHA
3. Очистить hidden form helpers
4. Обеспечить fonts(1).css дубликат
