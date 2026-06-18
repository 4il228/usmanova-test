# REFACTORING.md — Полный план рефакторинга проекта GymTeam Clone

**Дата анализа:** 2026-06-18
**Исходный сайт:** `https://usmanovafit.gymteam.ru/mainpage#form`

---

## Содержание

1. [Текущее состояние проекта](#текущее-состояние-проекта)
2. [Фаза 1: Аудит и инвентаризация](#фаза-1-аудит-и-инвентаризация)
3. [Фаза 2: Полная локализация статики](#фаза-2-полная-локализация-статики)
4. [Фаза 3: Очистка от телеметрии и трекинга](#фаза-3-очистка-от-телеметрии-и-трекинга)
5. [Фаза 4: Оптимизация HTML-разметки](#фаза-4-оптимизация-html-разметки)
6. [Фаза 5: Стабилизация CSS/JS](#фаза-5-стабилизация-cssjs)
7. [Фаза 6: Переподключение форм к локальному бэкенду](#фаза-6-переподключение-форм-к-локальному-бэкенду)
8. [Фаза 7: Финальная валидация и тестирование](#фаза-7-финальная-валидация-и-тестирование)

---

## Текущее состояние проекта

### Структура файлов

```
D:\katyafitness\
├── index.html                  (Главная страница, ~6297 строк)
├── june_top5.html              (Промо-страница топ-5, ~7528 строк)
├── payment.html                (Страница оплаты, ~4327 строк)
├── assets_main/                (140 файлов — CSS, JS, шрифты, изображения)
├── assets_top5/                (82 файла — CSS, JS, шрифты, изображения)
├── payment_files/              (149 файлов — CSS, JS, шрифты, изображения)
├── AGENTS.md
├── SPEC.md
├── package.json
└── node_modules/
```

### Критические проблемы

| Проблема | Критичность | Файлы |
|----------|-------------|-------|
| Внешние шрифты Google Fonts CDN | Высокая | `index.html`, `june_top5.html`, `proxima.css` (x2) |
| Внешние изображения GetCourse CDN | Высокая | `payment.html` (8 уникальных URL) |
| Трекер Яндекс.Метрика | Высокая | `payment.html` |
| CloudPayments SDK (внешний) | Средняя | `payment.html` |
| reCAPTCHA Google | Средняя | `payment_files/phone_confirm.js` |
| VK/YouTube/Telegram ссылки | Низкая | `payment_files/xdget-view-*.js` |
| Отсутствующие локальные шрифты Manrope | Высокая | `payment_files/fonts/` (пустая директория) |
| Ссылки на оригинальный сайт | Средняя | `payment.html`, `june_top5.html`, `index.html` |

---

## Фаза 1: Аудит и инвентаризация

**Статус:** ✅ Выполнена (этот документ)

### Результаты

- Полный список всех внешних URL — 61 ссылка в HTML, 293 в JS
- Все три HTML-файла проверены на наличие внешних зависимостей
- Определены 3 категории внешних ресурсов: шрифты, изображения, скрипты/трекеры

---

## Фаза 2: Полная локализация статики

**Цель:** Ни одно изображение, ни один шрифт не загружаются по внешним ссылкам. Всё — только из локальных директорий проекта.

### 2.1 Локализация шрифтов Google Fonts

**Проблема:** Шрифты Roboto, Open Sans и Manrope загружаются с `fonts.googleapis.com`.

**Источники внешних ссылок:**

| Файл | Строка | Шрифт | Веса |
|------|--------|-------|------|
| `index.html:34` | `<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700">` | Roboto | 300, 400, 500, 700 |
| `index.html:35` | `<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700">` | Open Sans | 300, 400, 500, 600, 700 |
| `june_top5.html:35` | `<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700">` | Roboto | 300, 400, 500, 700 |
| `june_top5.html:36` | `<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700">` | Open Sans | 300, 400, 500, 600, 700 |
| `assets_main/proxima.css:2` | `@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;700')` | Manrope | 300, 400, 700 |
| `assets_top5/proxima.css:2` | `@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@300;400;700')` | Manrope | 300, 400, 700 |

**Действия:**

1. **Скачатьwoff2-файлы** шрифтов (приоритетный формат для современных браузеров):
   ```
   Скачать с Google Fonts API:
   - Roboto: 300, 400, 500, 700 (woff2 + woff как fallback)
   - Open Sans: 300, 400, 500, 600, 700 (woff2 + woff)
   - Manrope: 300, 400, 700 (woff2 + woff)
   ```

2. **Разместить шрифты локально:**
   ```
   assets_main/fonts/
   ├── roboto-300.woff2
   ├── roboto-300.woff
   ├── roboto-400.woff2
   ├── roboto-400.woff
   ├── roboto-500.woff2
   ├── roboto-500.woff
   ├── roboto-700.woff2
   ├── roboto-700.woff
   ├── open-sans-300.woff2
   ├── open-sans-300.woff
   ├── open-sans-400.woff2
   ├── open-sans-400.woff
   ├── open-sans-500.woff2
   ├── open-sans-500.woff
   ├── open-sans-600.woff2
   ├── open-sans-600.woff
   ├── open-sans-700.woff2
   ├── open-sans-700.woff
   ├── manrope-300.woff2
   ├── manrope-300.woff
   ├── manrope-400.woff2
   ├── manrope-400.woff
   ├── manrope-700.woff2
   └── manrope-700.woff
   ```
   То же самое复制到 `assets_top5/fonts/`.

3. **Создать локальные CSS-файлы `@font-face`:**

   **`assets_main/roboto-cyr-swap.css`** (заменить содержимое):
   ```css
   @font-face {
       font-family: 'Roboto';
       font-weight: 300;
       font-style: normal;
       font-display: swap;
       src: url('fonts/roboto-300.woff2') format('woff2'),
            url('fonts/roboto-300.woff') format('woff');
   }
   @font-face {
       font-family: 'Roboto';
       font-weight: 400;
       font-style: normal;
       font-display: swap;
       src: url('fonts/roboto-400.woff2') format('woff2'),
            url('fonts/roboto-400.woff') format('woff');
   }
   @font-face {
       font-family: 'Roboto';
       font-weight: 500;
       font-style: normal;
       font-display: swap;
       src: url('fonts/roboto-500.woff2') format('woff2'),
            url('fonts/roboto-500.woff') format('woff');
   }
   @font-face {
       font-family: 'Roboto';
       font-weight: 700;
       font-style: normal;
       font-display: swap;
       src: url('fonts/roboto-700.woff2') format('woff2'),
            url('fonts/roboto-700.woff') format('woff');
   }
   ```

   **`assets_main/open-sans-cyr-swap.css`** (заменить содержимое):
   ```css
   @font-face {
       font-family: 'Open Sans';
       font-weight: 300;
       font-style: normal;
       font-display: swap;
       src: url('fonts/open-sans-300.woff2') format('woff2'),
            url('fonts/open-sans-300.woff') format('woff');
   }
   @font-face {
       font-family: 'Open Sans';
       font-weight: 400;
       font-style: normal;
       font-display: swap;
       src: url('fonts/open-sans-400.woff2') format('woff2'),
            url('fonts/open-sans-400.woff') format('woff');
   }
   @font-face {
       font-family: 'Open Sans';
       font-weight: 500;
       font-style: normal;
       font-display: swap;
       src: url('fonts/open-sans-500.woff2') format('woff2'),
            url('fonts/open-sans-500.woff') format('woff');
   }
   @font-face {
       font-family: 'Open Sans';
       font-weight: 600;
       font-style: normal;
       font-display: swap;
       src: url('fonts/open-sans-600.woff2') format('woff2'),
            url('fonts/open-sans-600.woff') format('woff');
   }
   @font-face {
       font-family: 'Open Sans';
       font-weight: 700;
       font-style: normal;
       font-display: swap;
       src: url('fonts/open-sans-700.woff2') format('woff2'),
            url('fonts/open-sans-700.woff') format('woff');
   }
   ```

   **`assets_main/proxima.css`** (заменить содержимое):
   ```css
   @font-face {
       font-family: 'Manrope';
       font-weight: 300;
       font-style: normal;
       font-display: swap;
       src: url('fonts/manrope-300.woff2') format('woff2'),
            url('fonts/manrope-300.woff') format('woff');
   }
   @font-face {
       font-family: 'Manrope';
       font-weight: 400;
       font-style: normal;
       font-display: swap;
       src: url('fonts/manrope-400.woff2') format('woff2'),
            url('fonts/manrope-400.woff') format('woff');
   }
   @font-face {
       font-family: 'Manrope';
       font-weight: 700;
       font-style: normal;
       font-display: swap;
       src: url('fonts/manrope-700.woff2') format('woff2'),
            url('fonts/manrope-700.woff') format('woff');
   }
   ```

   Все те же файлы复制到 `assets_top5/`.

4. **Удалить внешние ссылки из HTML:**
   - `index.html:34` — удалить `<link href="https://fonts.googleapis.com/css2?family=Roboto...">`
   - `index.html:35` — удалить `<link href="https://fonts.googleapis.com/css2?family=Open+Sans...">`
   - `june_top5.html:35` — удалить `<link href="https://fonts.googleapis.com/css2?family=Roboto...">`
   - `june_top5.html:36` — удалить `<link href="https://fonts.googleapis.com/css2?family=Open+Sans...">`

5. **Убедиться, что CSS `roboto-cyr-swap.css`, `open-sans-cyr-swap.css`, `proxima.css` подключены в HTML** (проверить порядок подключения в `<head>`).

### 2.2 Локализация шрифтов Manrope для payment.html

**Проблема:** `payment_files/manrope.css` и `payment_files/proxima.css` ссылаются на `fonts/Manrope-*.ttf`, но директория `payment_files/fonts/` **пуста**.

**Действия:**

1. **Скачать Manrope TTF-файлы:**
   ```
   payment_files/fonts/
   ├── Manrope-Light.ttf      (weight 300)
   ├── Manrope-Regular.ttf    (weight 400)
   └── Manrope-Bold.ttf       (weight 700)
   ```

2. **Дополнительно добавить woff2-формат** для производительности:
   ```
   payment_files/fonts/
   ├── Manrope-Light.woff2
   ├── Manrope-Regular.woff2
   └── Manrope-Bold.woff2
   ```

3. **Обновить `payment_files/proxima.css`:**
   ```css
   @font-face {
       font-family: 'proxima-nova';
       font-weight: 300;
       font-style: normal;
       font-display: swap;
       src: url('fonts/Manrope-Light.woff2') format('woff2'),
            url('fonts/Manrope-Light.ttf') format('truetype');
   }
   @font-face {
       font-family: 'proxima-nova';
       font-weight: 400;
       font-style: normal;
       font-display: swap;
       src: url('fonts/Manrope-Regular.woff2') format('woff2'),
            url('fonts/Manrope-Regular.ttf') format('truetype');
   }
   @font-face {
       font-family: 'proxima-nova';
       font-weight: 700;
       font-style: normal;
       font-display: swap;
       src: url('fonts/Manrope-Bold.woff2') format('woff2'),
            url('fonts/Manrope-Bold.ttf') format('truetype');
   }
   ```

### 2.3 Локализация изображений GetCourse CDN (payment.html)

**Проблема:** 8 уникальных изображений загружаются с `fs.getcourse.ru`.

**Полный список внешних URL изображений:**

| # | Файл:Строка | URL | Назначение |
|---|-------------|-----|------------|
| 1 | `payment.html:16` | `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/240/h/fb783df3c47bb9bdf8432ac158d24131.png` | Favicon |
| 2 | `payment.html:750` | `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/498/h/656ba5c6fe217410582063e1c343c314.png` | Иконка банковского перевода (CSS bg) |
| 3 | `payment.html:810` | `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/286/h/e1e76605d365b1ccde6a633c185eb5cd.png` | Кнопка СБП (CSS bg) |
| 4 | `payment.html:816` | `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/300/h/1e22f60a99c0985e65c18df6bfa92cdc.png` | Кнопка CloudPayments (CSS bg) |
| 5 | `payment.html:821` | `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/422/h/f5d0bab362fd5fbb108ae2bf3eb8a963.png` | Кнопка PayAnyWay (CSS bg) |
| 6 | `payment.html:834` | `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/280/h/144dac04c7d84d33d8d753cecc92a00f.png` | Кнопка Тинькофф (CSS bg) |
| 7 | `payment.html:839` | `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/288/h/31f19fedd1be892bf9db4a04f51a6038.png` | Кнопка Другое (CSS bg) |
| 8 | `payment.html:1165` | `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/148/h/f1970cb7a55cf6f483daf09b13369114.svg` | Иконка чекбокса (CSS bg) |

**Действия:**

1. **Скачать все 8 файлов** (выполнить через браузер или curl):
   ```bash
   mkdir -p payment_files/images/getcourse
   curl -o payment_files/images/getcourse/favicon.png "https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/240/h/fb783df3c47bb9bdf8432ac158d24131.png"
   curl -o payment_files/images/getcourse/bank-transfer.png "https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/498/h/656ba5c6fe217410582063e1c343c314.png"
   curl -o payment_files/images/getcourse/sbp-btn.png "https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/286/h/e1e76605d365b1ccde6a633c185eb5cd.png"
   curl -o payment_files/images/getcourse/cloud-btn.png "https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/300/h/1e22f60a99c0985e65c18df6bfa92cdc.png"
   curl -o payment_files/images/getcourse/payanyway-btn.png "https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/422/h/f5d0bab362fd5fbb108ae2bf3eb8a963.png"
   curl -o payment_files/images/getcourse/tinkoff-btn.png "https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/280/h/144dac04c7d84d33d8d753cecc92a00f.png"
   curl -o payment_files/images/getcourse/other-btn.png "https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/288/h/31f19fedd1be892bf9db4a04f51a6038.png"
   curl -o payment_files/images/getcourse/checkbox.svg "https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/148/h/f1970cb7a55cf6f483daf09b13369114.svg"
   ```

2. **Заменить URL в `payment.html`:**

   | Строка | Было | Стало |
   |--------|------|-------|
   | 16 | `href="https://fs.getcourse.ru/...fb783df3c47bb9bdf8432ac158d24131.png"` | `href="./payment_files/images/getcourse/favicon.png"` |
   | 750 | `url(https://fs.getcourse.ru/...656ba5c6fe217410582063e1c343c314.png)` | `url(./payment_files/images/getcourse/bank-transfer.png)` |
   | 810 | `url(https://fs.getcourse.ru/...e1e76605d365b1ccde6a633c185eb5cd.png)` | `url(./payment_files/images/getcourse/sbp-btn.png)` |
   | 816 | `url(https://fs.getcourse.ru/...1e22f60a99c0985e65c18df6bfa92cdc.png)` | `url(./payment_files/images/getcourse/cloud-btn.png)` |
   | 821 | `url(https://fs.getcourse.ru/...f5d0bab362fd5fbb108ae2bf3eb8a963.png)` | `url(./payment_files/images/getcourse/payanyway-btn.png)` |
   | 834 | `url(https://fs.getcourse.ru/...144dac04c7d84d33d8d753cecc92a00f.png)` | `url(./payment_files/images/getcourse/tinkoff-btn.png)` |
   | 839 | `url(https://fs.getcourse.ru/...31f19fedd1be892bf9db4a04f51a6038.png)` | `url(./payment_files/images/getcourse/other-btn.png)` |
   | 1165 | `url("https://fs.getcourse.ru/...f1970cb7a55cf6f483daf09b13369114.svg")` | `url("./payment_files/images/getcourse/checkbox.svg")` |

### 2.4 Локализация логотипа payment.html

**Проблема:** Файл `payment_files/63` — это логотип (3537 байт), но не имеет расширения.

**Действия:**
1. Определить MIME-тип файла (предположительно PNG по размеру)
2. Переименовать в `payment_files/images/logo.png`
3. Обновить `payment.html:333`:
   ```html
   <!-- Было -->
   <img src="./payment_files/63" alt="" title="">
   <!-- Стало -->
   <img src="./payment_files/images/logo.png" alt="" title="">
   ```

---

## Фаза 3: Очистка от телеметрии и трекинга

**Цель:** Удалить все сторонние трекеры, аналитику и виджеты, не относящиеся к функционалу.

### 3.1 Яндекс.Метрика

**Расположение:** `payment.html:290-301`

**Удалить полностью:**
```html
<!-- Начало блока — строка 290 -->
<script type="text/javascript">
    (function(m,e,t,r,i,k,a){
        m[i]=m[i]||function(){(m[i].a=m[i].a||[]).push(arguments)};
        m[i].l=1*new Date();
        for (var j = 0; j < document.scripts.length; j++) {if (document.scripts[j].src === r) { return; }}
        k=e.createElement(t),a=e.getElementsByTagName(t)[0],k.async=1,k.src=r,a.parentNode.insertBefore(k,a)
    })(window, document,'script','https://mc.yandex.ru/metrika/tag.js?id=106868527', 'ym');

    ym(106868527, 'init', {ssr:true, webvisor:true, clickmap:true, ecommerce:"dataLayer", ...});
</script>
<noscript><div><img src="https://mc.yandex.ru/watch/106868527" style="position:absolute; left:-9999px;" alt="" /></div></noscript>
<!-- /Yandex.Metrika counter -->
<!-- Конец блока — строка 301 -->
```

### 3.2 Закомментированный трекер stat.js

**Расположение:** `payment.html:4292`

**Удалить:**
```html
<!-- Было -->
<script src="./payment_files/talks_widget.js"></script><!-- <script async src="https://vhencapi13.gcfiles.net/st/stat.js?v= --><!-- "></script> -->
<!-- Стало -->
<script src="./payment_files/talks_widget.js"></script>
```

### 3.3 CloudPayments виджет (внешний скрипт)

**Расположение:** `payment.html:2756`

**Проблема:** Загружает внешний скрипт `https://widget.cloudpayments.ru/bundles/cloudpayments/`.

**Действия:**
- Определить: является ли это критичным для функционала оплаты
- Если да — документировать зависимость, оставить с пометкой
- Если нет — удалить весь блок `<script>` связанный с CloudPayments (строки 2754-2795)

### 3.4 reCAPTCHA Google

**Расположение:** `payment_files/phone_confirm.js:8`

**Проблема:** Динамически загружает `https://www.google.com/recaptcha/api.js`.

**Действия:**
- Определить: используется ли проверка телефона на странице оплаты
- Если нет — удалить/закомментировать вызов
- Если да — оставить с пометкой зависимости

### 3.5 VK Auth / YouTube Embed / Social Share

**Расположение:** `payment_files/xdget-view-ca11d7935d3a81ff8ae46dff68d943d7.js`

| Строка | Что | Действие |
|--------|-----|----------|
| 119 | VK Auth (`window.open('https://vk.com')`) | Удалить, если VK-авторизация не нужна |
| 191 | YouTube embed (`https://youtube.com/embed/`) | Удалить, если видео не используются |
| 298-312 | Social share (VK, Telegram, FB, Twitter, OK, WhatsApp, Viber, Email) | Удалить, если шаринг не нужен |

### 3.6 Clarity.js — поведенческая аналитика GetCourse

**Расположение:** `payment_files/clarity.js`

**Проблема:** Содержит множество внешних URL:
- `https://usmanovafit.gymteam.ru/chtm/s/metric/socket-bundle.*.js` (строка 100)
- `https://usmanovafit.gymteam.ru/chtm/s/metric/clarity.gif` (строка 183)
- `https://usmanovafit.gymteam.ru/chtm/s/metric/behaviourBeacon` (строка 595)
- `https://usmanovafit.gymteam.ru/chtm/s/metric/behaviour.gif` (строка 614)
- `https://t.me/` — ссылка на Telegram бот (строка 402)

**Действия:**
- Удалить файл `payment_files/clarity.js` если поведенческая аналитика не нужна
- Или оставить с пометкой, что требует отдельного бэкенда

### 3.7 tag.js — Яндекс.Метрика (массивный файл)

**Расположение:** `payment_files/tag.js`

**Проблема:** Содержит数百外部 URL Яндекс.Метрики, включая:
- `https://mc.yandex.ru/metrika/informer.js` (строка 517)
- `https://mc.yandex.md/cc` (строка 515)
- `https://eu.asas.yango.com/mapuid` (строка 522)
- `https://adstat.yandex.ru/track` (строка 614)
- `https://spadsync.com/partner` (строка 617)

**Действия:**
- Удалить `payment_files/tag.js`
- Удалить `payment_files/tag_phono.js`
- Удалить соответствующие `<script>` теги из `payment.html:3-5`

---

## Фаза 4: Оптимизация HTML-разметки

**Цель:** Убрать мертвый код, исправить некорректные ссылки, оптимизировать структуру.

### 4.1 Замена ссылок на оригинальный сайт

**Список всех ссылок на `usmanovafit.gymteam.ru`:**

| Файл | Строки | URL | Тип | Действие |
|------|--------|-----|-----|----------|
| `payment.html:2` | Комментарий `saved from url` | `https://usmanovafit.gymteam.ru/sales/shop/dealPay/...` | HTML comment | Удалить комментарий |
| `payment.html:332` | Logo link | `https://usmanovafit.gymteam.ru/` | Навигация | Заменить на `./index.html` |
| `payment.html:2470,2483` | Оферта/Конфиденциальность | `https://usmanovafit.gymteam.ru/oferta_fitnes`, `protection_fitnes` | Юридические | Заменить на `#` или локальные страницы |
| `payment.html:2600-2719` | Кнопки оплаты (x6) | `https://usmanovafit.gymteam.ru/sales/shop/dealPay/...#` | Платежные | Заменить на `#` |
| `payment.html:2787` | Редирект после оплаты | `https://usmanovafit.gymteam.ru/sales/shop/dealPaid/...` | Редирект | Заменить на `./payment_success.html` или `#` |
| `payment.html:3277` | AJAX cooldown | `https://usmanovafit.gymteam.ru/sales/shop/cooldownPeriodApply` | API | Заменить на `/api/cooldown` |
| `payment.html:3372` | Telegram bot | `https://t.me/UsmanovaSport_bot` | Ссылка | Оставить (внешняя, но валидная) |
| `june_top5.html:2` | Комментарий `saved from url` | `https://usmanovafit.gymteam.ru/june_top5...` | HTML comment | Удалить |
| `june_top5.html:44` | og:url | `https://usmanovafit.gymteam.ru/june_top5...` | Meta | Заменить на локальный URL |
| `june_top5.html:5015` | Form anchor href | `https://usmanovafit.gymteam.ru/june_top5...#form` | Якорь | Заменить на `#form` |
| `june_top5.html:5615-5777` | Соцсети (Telegram, VK, Max) | Внешние | Навигация | Оставить (внешние, валидные) |
| `june_top5.html:6710-6713` | Ссылки в футере | `usmanovafit.gymteam.ru/cms/...`, `oferta_fitnes`, `protection_fitnes`, `personaldata` | Юридические | Заменить на `#` или локальные |
| `june_top5.html:6747-6748` | Hidden form helpers | `https://usmanovafit.gymteam.ru/june_top5...`, `mainpage` | Форма | Очистить/заменить |
| `index.html:2` | Комментарий `saved from url` | `https://usmanovafit.gymteam.ru/mainpage#form` | HTML comment | Удалить |
| `index.html:4904-5066` | Соцсети (Telegram, VK, Max) | Внешние | Навигация | Оставить |
| `index.html:6031,6245-6253` | Контакты в футере | VK, Telegram, Max | Навигация | Оставить |

### 4.2 Удаление Facebook Pixel ID

**Расположение:** `index.html:44`, `june_top5.html:45`

```html
<meta property="fb:app_id" content="1437814016454992">
```

**Действие:** Удалить из обоих файлов.

### 4.3 Очистка hidden form полей (GetCourse)

**Расположение:** `june_top5.html:6747-6748`, `june_top5.html:7094`

```html
<input type="hidden" name="__gc__internal__form__helper" value="https://usmanovafit.gymteam.ru/june_top5?utm_source=...">
<input type="hidden" name="__gc__internal__form__helper_ref" value="https://usmanovafit.gymteam.ru/mainpage">
```

**Действие:** Очистить значения или удалить hidden-поля, если формы не используют GetCourse API.

### 4.4 Удаление meta google-play-app

**Расположение:** `payment.html:13`

```html
<meta name="google-play-app" content="app-id=com.chatium.app">
```

**Действие:** Удалить (ссылка на Chatium — стороннее приложение).

### 4.5 Удаление iframe Gemini Agent

**Расположение:** `payment.html:4298`

**Проблема:** Содержит iframe на `payment_files/51b9d8b6-ae0d-4086-8124-2b018f94ed9f.html` (chatbot).

**Действие:** Удалить entire `<div id="gemini-agent-root">` блок, если чатбот не нужен.

---

## Фаза 5: Стабилизация CSS/JS

**Цель:** Убедиться, что все CSS- и JS-файлы работают автономно, без внешних зависимостей.

### 5.1 CSS-файлы, требующие проверки

| Файл | Проблема | Действие |
|------|----------|----------|
| `payment_files/als-granate-vf-new.css` | Ссылается на `../new-fonts/` — директория не существует | Удалить или скачать шрифты |
| `payment_files/glyphicons.css` | Ссылается на `fonts/glyphicons-*` — директория пуста | Скачать Glyphicons шрифты |
| `payment_files/all.css` | Ссылается на `../webfonts/` — путь не резолвится | Проверить и исправить пути |
| `payment_files/old.css` | Ссылается на `../webfonts/v4/` и `../webfonts/v5/` — не существуют | Проверить и исправить пути |
| `payment_files/v4-font-face.css` | Ссылается на `../webfonts/` — не существует | Проверить и исправить пути |
| `payment_files/v5-font-face.css` | Ссылается на `../webfonts/` — не существует | Проверить и исправить пути |
| `payment_files/fonts(1).css` | Дубликат fonts.css? | Проверить и удалить дубликат |

### 5.2 JS-файлы с внешними ссылками (не комментарии)

| Файл | Строка | Проблема | Действие |
|------|--------|----------|----------|
| `payment_files/phone_confirm.js:8` | `https://www.google.com/recaptcha/api.js` | reCAPTCHA | Удалить/замокать |
| `payment_files/xdget-view-*.js:119` | `https://vk.com` | VK Auth | Удалить |
| `payment_files/xdget-view-*.js:191` | `https://youtube.com/embed/` | YouTube | Удалить |
| `payment_files/xdget-view-*.js:298-312` | Соцсети (VK, TG, FB, Twitter, OK, WhatsApp, Viber) | Share | Удалить |
| `payment_files/clarity.js:100` | `https://usmanovafit.gymteam.ru/chtm/s/metric/...` | Аналитика | Удалить файл |
| `payment_files/tag.js` (массивный) | Множество URL Яндекс.Метрики | Трекер | Удалить файл |
| `payment_files/socket.io.slim.js` | Внутренняя логика WebSocket | Библиотека | Оставить |
| `payment_files/react.min.js` | React 0.13 (устаревший!) | Библиотека | Оставить, пометить устаревшим |

### 5.3 Дублирование CSS/JS между assets_main и assets_top5

**Проблема:** Директории `assets_main/` и `assets_top5/` содержат практически идентичные наборы файлов (CSS, JS, шрифты, webfonts).

**Рекомендация:**
- Создать общую директорию `shared/` для общих ресурсов
- Или оставить как есть, если страницы должны быть полностью автономными
- **Минимальное действие:** Удалить явные дубликаты (если файлы идентичны по содержимому)

---

## Фаза 6: Переподключение форм к локальному бэкенду

**Цель:** Все формы отправляют данные на локальный эндпоинт вместо внешнего API GetCourse.

### 6.1 Текущие обработчики форм

| Страница | Форма | Текущий обработчик | Тип |
|----------|-------|-------------------|-----|
| `index.html` | Форма заказа | JS: `orderForm` (строка ~1472) | JavaScript |
| `index.html` | Форма подписки | JS: `subscriptionForm` (строка ~1824) | JavaScript |
| `june_top5.html` | Форма заказа | JS: `orderForm` (строка ~1307) | JavaScript |
| `june_top5.html` | Quiz/многошаговая | JS state machine (строки 850-1250) | JavaScript |
| `payment.html` | Форма оплаты | JS: `xdget_orderForm` (строка ~862) | JavaScript |

### 6.2 Действия

1. **Определить конечный бэкенд** (API URL)
2. **Найти все `$.ajax`, `fetch`, `XMLHttpRequest` вызовы** в JS-файлах:
   - `payment.html:2770-2774` — AJAX на `/pl/sales/prepayment/cloud-payment-prepayment`
   - `payment.html:3277` — AJAX на `https://usmanovafit.gymteam.ru/sales/shop/cooldownPeriodApply`
   - JS-файлы в `assets_main/` и `assets_top5/` — содержат обработчики форм
3. **Заменить URL эндпоинтов** на конфигурируемые:
   ```javascript
   // Было
   $.ajax({ url: 'https://usmanovafit.gymteam.ru/sales/shop/...', ... })
   // Стало
   const API_BASE = window.API_BASE || '/api';
   $.ajax({ url: `${API_BASE}/sales/shop/...`, ... })
   ```
4. **Создать `config.js`** с базовым URL:
   ```javascript
   window.API_BASE = 'http://localhost:3000/api';
   ```

---

## Фаза 7: Финальная валидация и тестирование

**Цель:** Убедиться, что проект полностью работает автономно.

### 7.1 Чеклист валидации

#### Шрифты
- [ ] Roboto загружается локально (300, 400, 500, 700)
- [ ] Open Sans загружается локально (300, 400, 500, 600, 700)
- [ ] Manrope загружается локально (300, 400, 700)
- [ ] Glyphicons загружается локально
- [ ] Font Awesome 4/5 загружается локально
- [ ] Gilroy загружается локально (для payment)
- [ ] proxima-nova (Manrope alias) загружается в payment.html

#### Изображения
- [ ] Все 8 изображений GetCourse CDN заменены на локальные
- [ ] Favicon payment.html работает локально
- [ ] Логотип payment.html работает локально (файл `63` -> `images/logo.png`)
- [ ] Все изображения в `assets_main/images/` доступны
- [ ] Все изображения в `assets_top5/images/` доступны

#### Трекеры и аналитика
- [ ] Яндекс.Метрика удалена из payment.html
- [ ] tag.js / tag_phono.js удалены
- [ ] clarity.js удалён
- [ ] stat.js (закомментированный) удалён
- [ ] Facebook Pixel ID удалён
- [ ] reCAPTCHA удалена/замокана

#### Ссылки
- [ ] Нет ссылок на `fonts.googleapis.com`
- [ ] Нет ссылок на `fs.getcourse.ru`
- [ ] Нет ссылок на `mc.yandex.ru`
- [ ] Нет ссылок на `widget.cloudpayments.ru` (или документировано)
- [ ] Все внутренние ссылки ведут на локальные файлы
- [ ] Соцсети (Telegram, VK, Max) — оставлены как внешние (валидные)

#### Формы
- [ ] Формы отправляют данные на локальный API
- [ ] Валидация работает автономно
- [ ] Нет обращений к внешним API при отправке

### 7.2 Тестирование в браузере

1. Открыть `index.html` через `serve .` (локальный сервер)
2. Проверить Console на ошибки 404 (все ресурсы загружены)
3. Проверить вкладку Network: **0 внешних запросов** (кроме соцсетей)
4. Проверить шрифты — текст отображается корректно
5. Проверить адаптивность (мобильная версия)
6. Повторить для `june_top5.html` и `payment.html`

### 7.3 Финальная проверка

```bash
# Запуск локального сервера
npm start

# Проверка всех внешних ссылок в проекте (должно быть 0 критичных)
grep -rn "https://" *.html payment_files/*.js payment_files/*.css assets_*/*.css assets_*/*.js | grep -v "node_modules" | grep -v "//.*http" | grep -v "t.me" | grep -v "vk.ru" | grep -v "vk.com" | grep -v "max.ru" | grep -v "facebook.com" | grep -v "twitter.com" | grep -v "telegram.me" | grep -v "ok.ru" | grep -v "whatsapp.com" | grep -v "viber://"
```

---

## Сводная таблица всех внешних URL

| Категория | URL | Файл | Статус после рефакторинга |
|-----------|-----|------|--------------------------|
| Google Fonts | `fonts.googleapis.com` | index.html, june_top5.html, proxima.css (x2) | 🔴 УДАЛИТЬ |
| GetCourse CDN | `fs.getcourse.ru` | payment.html (8 URL) | 🔴 УДАЛИТЬ, заменить на локальные |
| Яндекс.Метрика | `mc.yandex.ru` | payment.html, tag.js | 🔴 УДАЛИТЬ |
| CloudPayments | `widget.cloudpayments.ru` | payment.html | 🟡 Документировать или удалить |
| reCAPTCHA | `google.com/recaptcha` | phone_confirm.js | 🟡 Документировать или удалить |
| VK Auth | `vk.com` | xdget-view-*.js | 🟡 Удалить если не нужна |
| YouTube | `youtube.com/embed/` | xdget-view-*.js | 🟡 Удалить если не нужен |
| Social Share | `vk.com/share`, `telegram.me`, `facebook.com`, `twitter.com`, `ok.ru`, `whatsapp.com`, `viber://` | xdget-view-*.js | 🟡 Удалить если не нужен |
| GetCourse Analytics | `usmanovafit.gymteam.ru/chtm/` | clarity.js | 🔴 УДАЛИТЬ |
| Telegram Bot | `t.me/UsmanovaSport_bot` | index.html, june_top5.html, payment.html | 🟢 ОСТАВИТЬ |
| VK Group | `vk.ru/usmanovateam` | index.html, june_top5.html | 🟢 ОСТАВИТЬ |
| Max.ru Bot | `max.ru/id7734434533_1_bot` | index.html, june_top5.html | 🟢 ОСТАВИТЬ |

---

## Приоритет выполнения

| Приоритет | Фаза | Время (оценка) | Сложность |
|-----------|------|----------------|-----------|
| 🔴 P0 | Фаза 2.1: Локализация шрифтов Google | 2-3 часа | Средняя |
| 🔴 P0 | Фаза 2.3: Локализация изображений GetCourse | 1 час | Низкая |
| 🔴 P0 | Фаза 2.2: Шрифты Manrope для payment | 30 мин | Низкая |
| 🔴 P1 | Фаза 3.1-3.2: Удаление Яндекс.Метрики | 15 мин | Низкая |
| 🔴 P1 | Фаза 3.5-3.7: Удаление tag.js, clarity.js | 30 мин | Низкая |
| 🟡 P2 | Фаза 4: Оптимизация HTML-разметки | 2-3 часа | Средняя |
| 🟡 P2 | Фаза 5: Стабилизация CSS/JS | 3-4 часа | Высокая |
| 🟢 P3 | Фаза 6: Переподключение форм | 4-6 часов | Высокая |
| 🟢 P3 | Фаза 7: Тестирование | 2-3 часа | Средняя |

**Общая оценка:** 15-22 часов
