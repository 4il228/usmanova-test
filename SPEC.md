---

```markdown
# SPEC.md — Detailed Execution Specification for GymTeam Clone

This specification document breaks down the process of refining, cleaning, and stabilizing the downloaded frontend assets (`mainpage.htm`, `june_top5.htm`) into atomic development phases.

---

## Phase 1: Environment Setup & Asset Audit (Phase Code: AUDIT)

### Task 1.1: Local Directory Restructuring
- **Action:** Convert the web-scraped file naming into clean web-standard naming conventions.
- **Steps:**
  1. Rename `mainpage.htm` to `index.html`.
  2. Rename `june_top5.htm` to `top5.html`.
  3. Rename asset directories `mainpage_files` to `assets_main` and `june_top5_files` to `assets_top5`.
  4. Perform a global search-and-replace in `index.html` changing all references from `mainpage_files/` to `assets_main/`.
  5. Perform a global search-and-replace in `top5.html` changing all references from `june_top5_files/` to `assets_top5/`.

### Task 1.2: Relative Path Normalization
- **Action:** Audit all `<link>`, `<script>`, `<img>`, and CSS `background-image` paths.
- **Constraint:** Convert any absolute local paths (`file:///D:/...`) or broken relative links into strict relative pathways `./assets_main/...` or `./assets_top5/...`.
- **Success Criteria:** The page renders completely with all images and styles when served via a local HTTP server (`localhost`).

---

## Phase 2: Telemetry Excision & Code Cleanup (Phase Code: PURGE)

### Task 2.1: Stripping Analytics & Trackers
- **Action:** Locate and completely remove code blocks, tracking pixels, and external scripts that transmit data to third-party tracking services.
- **Constraint:** Do not delete adjacent functional scripts. Remove only the wrapper self-invoking functions or `<script>` tags handling trackers. Leave functional page content intact.

#### 2.1.1: Remove Yandex.Metrika (BOTH files)
- **index.html:** Delete lines 129–141 — the entire block from `<!-- Yandex.Metrika counter -->` through `<!-- /Yandex.Metrika counter -->`, inclusive.
- **top5.html:** Delete lines 130–142 — the identical Yandex.Metrika block.
- **What to remove exactly:**
  ```html
  <!-- Yandex.Metrika counter -->
  <script type="text/javascript">
      (function(m,e,t,r,i,k,a){ ... })(window, document,'script','https://mc.yandex.ru/metrika/tag.js?id=106868527', 'ym');
      ym(106868527, 'init', { ... });
  </script>
  <noscript><div><img src="https://mc.yandex.ru/watch/106868527" ...></div></noscript>
  <!-- /Yandex.Metrika counter -->
  ```
- **Adjacent code to keep:** The `</head>` tag immediately follows on the next line — do not remove it.

#### 2.1.2: Remove Commented-Out Stat Script (BOTH files)
- **index.html:** Delete line 6959: `<!-- <script async src="https://vhencapi13.gcfiles.net/st/stat.js?v=--><!--"></script>-->`
- **top5.html:** Delete line 7860: identical commented-out stat script.
- **Rationale:** This is dead commented-out tracking code, not functional.

#### 2.1.3: Clean Up Large `window.*` Config Block (BOTH files)
- **Location:** Lines 6–73 in both `index.html` and `top5.html` — the massive `<script>` block setting `window.accountUserId`, `window.requestIp`, `window.csrfToken`, etc.
- **Action:** Delete this entire `<script>...</script>` block from both files.
- **Rationale:** This block contains server-side session state, CSRF tokens, file service hosts, and platform config variables (`window.isDisabledFacebook`, `window.proMode`, etc.) that are irrelevant to a static clone. No functional JS in the page depends on these values for rendering.
- **Exception:** Keep the block only if you discover during testing that a functional script reads from it. If so, strip only the sensitive/session values (IPs, tokens, user IDs) and keep rendering-critical keys.

---

### Task 2.2: External Asset Localization — Font Path Repair
- **Action:** Fix all broken font `@font-face` paths so fonts load from local copies or correct relative paths.
- **Context:** The asset directories contain NO subdirectories (`fonts/`, `webfonts/`, `images/`). All CSS files referencing these subdirectories are broken. Font files must be downloaded from their original sources and placed locally.

#### 2.2.1: Download & Localize Gilroy Font (CRITICAL — both files)
- **Source:** The inline `<style id="rawCss5578338">` block in `index.html` (lines 164–183) and `<style id="rawCss9286162">` in `top5.html` (lines 165–184) define 3 `@font-face` rules for `'Gilroy'` font.
- **Current broken URLs:**
  - `url('/fileservice/file/download/h/c5ad85b5bf16600a49d40ad5ed235e33.woff/a/934144/sc/228')` — weight 400
  - `url('/fileservice/file/download/h/6e5d6a1c28b12636f6043ff99fc0ce86.woff/a/934144/sc/205')` — weight 500
  - `url('/fileservice/file/download/h/a0b69f25a8d7f98144131ebbd1a90d1e.woff/a/934144/sc/234')` — weight 600
- **Steps:**
  1. Download each `.woff` file from `https://usmanovafit.gymteam.ru/fileservice/file/download/h/<hash>.woff/a/934144/sc/<code>`.
  2. Save them as `gilroy-400.woff`, `gilroy-500.woff`, `gilroy-600.woff` inside `assets_main/fonts/` and `assets_top5/fonts/`.
  3. In both HTML files, update the `url(...)` paths in the inline `<style>` blocks to: `url('./assets_main/fonts/gilroy-400.woff')` (or `assets_top5/fonts/...` respectively).
- **Fallback:** If the server blocks downloads, find "Gilroy" font files from a public source (e.g., Google Fonts alternative or a CDN mirror) and use those instead. Gilroy is not on Google Fonts — an acceptable fallback is to use the `Exo 2` or `Montserrat` font family as a visual substitute and update the `font-family` declarations accordingly.

#### 2.2.2: Fix Roboto Font Paths (BOTH CSS files)
- **Files:** `assets_main/roboto-cyr-swap.css` and `assets_top5/roboto-cyr-swap.css`
- **Current broken pattern:** `src: url(/public/fonts/gfonts/roboto/fonts/<FILENAME>.woff2) format('woff2');`
- **Action:** These are absolute paths to the original server. Replace every `url(/public/fonts/gfonts/roboto/fonts/...)` with a Google Fonts CDN link or download locally.
- **Option A (CDN — preferred for simplicity):**
  1. Delete the entire content of `roboto-cyr-swap.css`.
  2. Add a `<link>` tag in the `<head>` of each HTML file pointing to Google Fonts: `<link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">`
- **Option B (local download):** Download each `.woff2` file, place in `fonts/` subdirectory, and update all `url()` paths to `url('fonts/<FILENAME>.woff2')`.

#### 2.2.3: Fix Open Sans Font Paths (BOTH CSS files)
- **Files:** `assets_main/open-sans-cyr-swap.css` and `assets_top5/open-sans-cyr-swap.css`
- **Current broken pattern:** `src: url(/public/fonts/gfonts/open-sans/fonts/<FILENAME>.woff2) format('woff2');`
- **Action:** Same approach as Roboto — Option A (Google Fonts CDN link) or Option B (local download).
- **CDN link:** `<link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">`

#### 2.2.4: Fix FontAwesome Webfont Paths (BOTH CSS files)
- **Files:** `assets_main/old.css`, `assets_main/v4-font-face.css`, `assets_main/v5-font-face.css`, `assets_main/all.css` (and identical copies in `assets_top5/`)
- **Current broken pattern:** `url("../webfonts/fa-solid-900.woff2")`, `url('../webfonts/v4/fontawesome-webfont.woff2')`, etc.
- **Problem:** The `../webfonts/` path resolves to `D:\katyafitness\webfonts\` which does not exist.
- **Steps:**
  1. Download FontAwesome 5 webfont files (free version) from the official source: `https://use.fontawesome.com/releases/v5.15.4/fontawesome-free-5.15.4-web.zip`
  2. Extract `webfonts/` folder contents (`.woff2`, `.woff`, `.ttf`, `.eot`, `.svg` files).
  3. Place them in `assets_main/webfonts/` and `assets_top5/webfonts/`.
  4. The relative paths `url("../webfonts/...")` will then resolve correctly (CSS is in `assets_main/`, `../webfonts/` goes up one level — WAIT, that's wrong. Since CSS is IN `assets_main/`, `../webfonts/` looks in the project root).
  5. **CORRECTION:** Move the webfonts INTO `assets_main/webfonts/` and change all CSS paths from `url("../webfonts/...")` to `url("webfonts/...")` (same-level relative).
- **Critical files to edit:**
  - `old.css`: lines 5–33 (3 `@font-face` blocks: FontAwesome v4, FontAwesome v5, Viber icon)
  - `v4-font-face.css`: lines 9, 14, 19, 25
  - `v5-font-face.css`: lines 10, 16, 22
  - `all.css`: lines 6382, 7914, 7928, 7937, 7943, 7949, 7953, 7958, 7963, 7969

#### 2.2.5: Fix Proxima / Manrope Font Paths (BOTH CSS files)
- **Files:** `assets_main/proxima.css` and `assets_top5/proxima.css`
- **Current broken pattern:** `src: url('fonts/Manrope-Light.ttf');` (and Regular, Bold)
- **Problem:** No `fonts/` subdirectory exists in `assets_main/`.
- **Steps:**
  1. Download Manrope font from Google Fonts: `https://fonts.google.com/specimen/Manrope`
  2. Save `Manrope-Light.ttf`, `Manrope-Regular.ttf`, `Manrope-Bold.ttf` into `assets_main/fonts/` and `assets_top5/fonts/`.
  3. The existing relative paths `url('fonts/...')` will then resolve correctly.

#### 2.2.6: Fix jQuery UI Image Paths (BOTH CSS files)
- **Files:** `assets_main/jquery-ui.css` and `assets_top5/jquery-ui.css`
- **Current broken pattern:** `url("images/ui-bg_glass_75_e6e6e6_1x400.png")` etc.
- **Problem:** No `images/` subdirectory exists.
- **Steps:**
  1. Download jQuery UI images from the official jQuery UI CDN: `https://code.jquery.com/ui/1.13.2/themes/base/images/`
  2. Download all referenced `ui-*.png` files.
  3. Place them in `assets_main/images/` and `assets_top5/images/`.

---

### Task 2.3: External Asset Localization — Image & Icon Path Repair

#### 2.3.1: Remote `data-src` Lazy-Load Images (BOTH files)
- **index.html line 738:** `data-src="//fs-thb02.getcourse.ru/fileservice/file/thumbnail/h/8d7e3aa384b597937b9504925ead6325.png/s/s1200x/a/934144/sc/68"` — This image is already cached locally as `assets_main/68`. The `src` attribute correctly points to `./assets_main/68`. **No action needed** — the `data-src` is just the lazyload source and the `src` already works.
- **index.html line 1003:** `data-src="//fs-thb01.getcourse.ru/fileservice/file/thumbnail/h/0ab22056b482979979f9203c2db57c87.png/s/s1200x/a/934144/sc/17"` — No local `src` fallback. This image will be broken. **Action:** Download from `https://fs-thb01.getcourse.ru/fileservice/file/thumbnail/h/0ab22056b482979979f9203c2db57c87.png/s/s1200x/a/934144/sc/17`, save as `assets_main/17`, set `src="./assets_main/17"` and remove the `data-src` attribute.
- **top5.html line 1296:** `data-src="//fs-thb03.getcourse.ru/fileservice/file/thumbnail/h/608672c0b775a62295719ffee30edb2f.png/s/s1200x/a/934144/sc/155"` — Same issue. **Action:** Download, save as `assets_top5/155`, set `src="./assets_top5/155"`.

#### 2.3.2: Remote Social Media & Contact Icons in Inline CSS (BOTH files)
- **Problem:** Social media links use inline `style="background-image:url('https://fs.getcourse.ru/fileservice/...')"` for Telegram, VK, Email, MAX icons. These will break offline.
- **Unique remote icon URLs found:**
  - Telegram icon: `https://fs.getcourse.ru/fileservice/file/download/a/656842/sc/91/h/8fec80b0270502eee473a97d551b0561.svg`
  - VK icon: `https://fs.getcourse.ru/fileservice/file/download/a/656842/sc/200/h/c25f8ab693de5b24cfd8c069917051b5.svg`
  - Email icon: `https://fs.getcourse.ru/fileservice/file/download/a/656842/sc/314/h/162edcaeb5a552d600eb62fbc50e622c.svg`
  - MAX icon: `https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/140/h/2e4566e258654949d8dff68c39757fcb.png`
- **Steps:**
  1. Download each icon file.
  2. Save as `telegram.svg`, `vk.svg`, `email.svg`, `max.png` in `assets_main/` and `assets_top5/`.
  3. Replace every inline `background-image:url('https://...')` with `background-image:url('./assets_main/telegram.svg')` (etc.) in both HTML files.
  4. **Important:** These inline styles appear in BOTH mobile and desktop blocks — search for ALL occurrences and replace each.

#### 2.3.3: Remote Decorative/Info Block Background Images (index.html ONLY)
- **index.html lines 1909–1921 and 2112–2121:** Four `gc-square` divs with inline `background-image:url('https://fs.getcourse.ru/...')` — these appear to be info/decorative icons.
- **Action:** Download each, save locally, and update the inline `url()` paths. Alternatively, if these are non-essential decorative elements, they can be removed entirely if the design allows it.

#### 2.3.4: Remote Favicon (BOTH files)
- **index.html line 75** and **top5.html line 75:** `<link rel="shortcut icon" href="https://fs.getcourse.ru/fileservice/file/download/a/934144/sc/240/h/fb783df3c47bb9bdf8432ac158d24131.png">`
- **Action:** Download the favicon, save as `assets_main/favicon.png` and `assets_top5/favicon.png`, update the `<link>` href to `./assets_main/favicon.png`.

---

### Task 2.4: Cleanup of Server-Platform Markup Artifacts
- **Action:** Remove HTML artifacts that are part of the GetCourse platform editor and have no meaning in a static clone.
- **Items to remove from BOTH files:**
  1. All `<div class="add-redesign-subblock" ...><span class="fa fa-plus"></span></div>` elements — these are CMS editor UI buttons. Search for `add-redesign-subblock` and remove all matching `<div>` elements.
  2. All `<style>` blocks that only hide `.add-redesign-subblock` (e.g., `.add-redesign-subblock, div#<id> .add-redesign-subblock { display: none; }`). These are dead CSS once the elements are removed.
  3. All `<div class="common-setting-link box-setting-link" ...>` elements — CMS editor artifacts.
- **Constraint:** Be careful not to remove functional `<style>` blocks that are adjacent. Only remove the ones whose sole content is hiding `.add-redesign-subblock`.

---

### Task 2.5: Verification Steps
After completing all tasks above:
1. **Grep check:** Run `grep -r "yandex\|mc\.yandex\|google-analytics\|googletagmanager\|connect\.facebook\|getcourse\.ru/fileservice" index.html top5.html` — should return ZERO matches (except legitimate `usmanovafit.gymteam.ru` page links which are kept intentionally).
2. **Grep check:** Run `grep -r "data-src=\"//" index.html top5.html` — should return ZERO matches.
3. **Grep check:** Run `grep -r "background-image:url.*https://" index.html top5.html` — should return ZERO matches.
4. **Grep check:** Run `grep -r "add-redesign-subblock" index.html top5.html` — should return ZERO matches.
5. **Console test:** Serve via local HTTP server, open DevTools Console — no 404s for fonts, no mixed-content warnings.

---

## Phase 3: Interactive Logic & Form Refactoring (Phase Code: WIRE)

> **ACTUAL STATE AFTER PHASE 2:** All remote URLs, trackers, and CMS artifacts have been removed. The `window.*` config block (containing `window.csrfToken`, `window.requestTime`, `window.requestSimpleSign`) was deleted in Phase 2. This means `ajaxCall()` in `superlite-block-*.js` will fail to append CSRF/session tokens — which is fine since we're re-routing submissions anyway.

### Architecture Overview

The project has **ONE functional form** located in `top5.html` (NOT in `index.html`). The `index.html` only contains CTA buttons that navigate to `#form` anchors (which don't exist on index.html — they're dead links pointing to top5.html sections).

**Form location:** `top5.html` lines 6734–7012
**Form ID:** `ltForm144649`
**Form action:** `https://usmanovafit.gymteam.ru/pl/lite/block-public/process?id=2235861150`
**Form widget:** `$('#ltForm144649').liteForm()` (initialized at line 7015)

**Modal trigger:** Button `button442459` (line ~5457) calls `ltShowModalBlock("b-5bf88")` which wraps the form block (`data-code="b-5bf88"`) in a Bootstrap modal.

---

### Task 3.1: Map the Form Data Payload

**Action:** Document the exact field names and structure that the form submits. The next agent MUST understand this before making changes.

**Form fields (from `top5.html`):**

| Line | Field Name | Type | Value/Notes |
|------|-----------|------|-------------|
| 6739 | `formParams[setted_offer_id]` | hidden | Set dynamically by JS |
| 6740 | `formParams[willCreatePaidDeal]` | hidden | `"1"` |
| 6741 | `__gc__internal__form__helper` | hidden | Page URL with UTMs |
| 6742 | `__gc__internal__form__helper_ref` | hidden | Referrer URL |
| 6751 | `formParams[need_offer]` | hidden | `"1"` |
| 6756 | `formParams[offer_id][]` | radio | Value `"8463143"`, pre-checked |
| 6821 | `formParams[full_name]` | text | User name |
| 6831 | `formParams[email]` | text | User email |
| 6841 | `formParams[phone]` | text | User phone |
| 6861 | `formParams[dealCustomFields][11928177]` | hidden | `deal_utm_source` |
| 6885 | `formParams[dealCustomFields][11928178]` | hidden | `deal_utm_medium` |
| 6909 | `formParams[dealCustomFields][11928179]` | hidden | `deal_utm_campaign` |
| 6933 | `formParams[dealCustomFields][11928180]` | hidden | `deal_utm_content` |
| 6957 | `formParams[dealCustomFields][11928181]` | hidden | `deal_utm_term` |
| 7010 | `confirmMailingCheckbox` | checkbox | Marketing opt-in |
| 7012 | `formParams[clarity_uid]` | hidden | Clarity session ID (can remove) |

**Additional fields added by JS at submit time (from `superlite-block-*.js` lines 77–80):**
- `fromUrl` — current page URL encoded
- `formParams[breakedOn]` — if form was interrupted
- `formParams[dealId]` — if deal already created
- `gcSession`, `gcVisit`, `gcVisitor`, `gcSessionHash` — from localStorage (will be empty since config was removed)

---

### Task 3.2: Intercept the Form Submission

**Action:** Modify the `liteForm` widget's `sendForm()` method in `superlite-block-abe5dddff141bb1b6762071a4f0ff3e8.js` to re-route submissions.

**File to edit:** `assets_top5/superlite-block-abe5dddff141bb1b6762071a4f0ff3e8.js`
**Target function:** `ajaxCall()` at lines 36–40

**Approach A (RECOMMENDED — cleanest):** Add an interceptor at the TOP of the `ajaxCall()` function (line 36) that checks if the URL matches the form action pattern and redirects it:

```javascript
// === PHASE 3: CUSTOM ENDPOINT CONFIGURATION ===
window.API_CONFIG = {
    SUBMIT_URL: '/api/submit',  // ← CHANGE THIS to your actual endpoint
    ENABLED: true
};

function ajaxCall(a, b, c, d, g) {
    // === PHASE 3: INTERCEPT FORM SUBMISSION ===
    if (window.API_CONFIG.ENABLED && typeof a === 'string' && a.indexOf('/pl/lite/block-public/process') !== -1) {
        // Re-route to custom endpoint
        a = window.API_CONFIG.SUBMIT_URL;
        // Keep the payload structure intact for backend compatibility
    }
    // === END PHASE 3 ===
    
    // ... rest of original ajaxCall() unchanged ...
}
```

**Approach B (alternative — HTML-only):** Change the form's `action` attribute directly in `top5.html`:
- Line 6738: Change `action="https://usmanovafit.gymteam.ru/pl/lite/block-public/process?id=2235861150"` to `action="/api/submit"`
- This is simpler but less flexible — the `ajaxCall()` function adds CSRF/session tokens that your backend may or may not need.

**CRITICAL:** If using Approach A, the `ajaxCall()` function (lines 36–40) also appends `window.csrfToken`, `window.requestTime`, `window.requestSimpleSign`, and localStorage session data to the payload. Since these `window.*` values were deleted in Phase 2, they will be `undefined`. Your backend must handle missing tokens gracefully, OR you must re-add minimal config:

```javascript
// Add this BEFORE the ajaxCall function if your backend requires CSRF
window.csrfToken = '';
window.requestTime = Math.floor(Date.now() / 1000);
window.requestSimpleSign = '';
```

---

### Task 3.3: Handle the Success/Error Response Flow

**Action:** After form submission, the `liteForm` widget's success callback (lines 81–86 of `superlite-block-*.js`) handles three scenarios:

1. **Redirect to payment** (`a.data.redirectUrl`) — Lines 82–84: If the response contains `redirectUrl`, the browser navigates there. For a static clone, you may want to show a "Thank you" message instead.

2. **Show result message** (`a.data.defaultMessage`) — Lines 84–85: Displays a success message in `.resultBlock`.

3. **Show error** (`a.data.error`) — Line 86: Displays error in `.resultBlock`.

**Recommended modification:** Replace the success callback logic to show a static "Thank you" message:

```javascript
// Inside the ajaxCall success callback, replace the redirect logic with:
function(data) {
    if (data.success) {
        // Show thank-you message
        var form = $('#ltForm144649');
        form.find('.form-content').hide();
        form.find('.form-result-block')
            .html('<h3 class="text-center">Спасибо! Ваша заявка принята.</h3>')
            .show();
    } else {
        alert('Ошибка: ' + (data.message || 'Попробуйте ещё раз'));
    }
}
```

---

### Task 3.4: Clean Up Dead External Endpoints in JS

**Action:** The following JS functions make calls to GetCourse server endpoints that will fail. Stub them out or remove them.

**Files to edit:** `assets_top5/superlite-block-abe5dddff141bb1b6762071a4f0ff3e8.js`

| Line(s) | Function | Endpoint | Action |
|---------|----------|----------|--------|
| 43 | `sendError()` | `/pl/gc/log` | Replace body with `console.error(a)` |
| 45 | `getUploadifySecretLink()` | `/fileservice/widget/create-secret-link` | No-op (file upload not needed) |
| 46 | `panelPutTaskAside()` | `/tasks/control/task/setNew` | No-op |
| 47 | `panelFinishTask()` | `/tasks/control/task/setCompleted` | No-op |
| 47 | `panelLoad()` | `/tasks/control/task/getPanel` | No-op |
| 72 | `onTelegramAuth()` | `/pl/user/profile/login-with-telegram` | No-op |
| 72 | `window.checkFormPhone()` | `/pl/user/profile/set-phone` | Always return true |
| 90 | `ltShowModalForm()` | `/pl/lite/block-public/get-block-html` | Keep only the `custom` branch (which calls `ltShowModalBlock`) |

**For `window.checkFormPhone` (line 72), replace with:**
```javascript
window.checkFormPhone = function(a) { return true; };
```

**For `sendError` (line 43), replace with:**
```javascript
function sendError(a) { console.error('[sendError]', a); }
```

---

### Task 3.5: Clean Up notice.js Remote Calls

**File to edit:** `assets_top5/notice.js`

**Action:** The `noticeWidget` makes AJAX calls to `/pl/cms/popup/get` and `/pl/cms/popup/process`. Since these are server-rendered popups that won't exist on a static site:

1. **Option A (recommended):** Empty out the noticeWidget initialization in `top5.html` line 7054 and `index.html` line 6322 by commenting out:
   ```javascript
   // $('#noticeWidget').noticeWidget();
   ```

2. **Option B:** Keep the notification popup HTML that's already inline in `top5.html` (lines 542–667 — the `showNotification("promo")` system) since it's pure client-side JS with no server calls. Just disable the `noticeWidget` AJAX popups.

---

### Task 3.6: Preserve Client-Side Features (DO NOT BREAK)

The following features are pure client-side and MUST continue working after Phase 3:

| Feature | Location | Why it works |
|---------|----------|-------------|
| Countdown timers | `top5.html` lines 774, 1208, 5301 | Uses jQuery Countdown plugin, reads `finishDate` from inline string, no server calls |
| `showNotification("promo")` | `top5.html` lines 542–667 | Pure client-side random name/city generation, no server calls |
| UTM auto-fill | `global-function.js` lines 238–253 | Reads `window.location.search`, fills hidden inputs, no server calls |
| Button scroll-to-form | Multiple buttons | `location.href='#form'` — pure anchor navigation |
| Lazy loading | `superlite-block-*.js` lines 17–31 | lazysizes library, reads `data-bg` attribute, no server calls |
| Animated blocks | `superlite-block-*.js` lines 32–35 | Scroll-based CSS animations, no server calls |
| Modal open/close | `modal.js` | Bootstrap modal factory, no server calls |
| Form position select | `top5.html` lines 6773–6806 | Radio button CSS toggle, no server calls |
| `addGlobalCheckbox()` | `global-function.js` lines 1–191 | Creates checkbox DOM elements, validates before submit, no server calls |
| `fillCustomFields()` | `global-function.js` lines 193–381 | UTM auto-mapping, no server calls |

---

### Task 3.7: Verification Steps

After completing all modifications:

1. **Serve locally:** Run `python -m http.server 8000` from the project directory.
2. **Open `top5.html`** in browser (e.g., `http://localhost:8000/top5.html`).
3. **Test form submission:**
   - Click any "УЗНАТЬ ПОДРОБНЕЕ" or "ЗАБРАТЬ НАБОР" button → modal should open with the form.
   - Fill in name, email, phone.
   - Click "Продолжить" → should POST to your custom endpoint (check Network tab).
   - Should NOT redirect to `usmanovafit.gymteam.ru`.
4. **Test countdown:** Timer should count down to `2026-06-22 00:00` Moscow time.
5. **Test notification popup:** After ~15 seconds, a "someone purchased" notification should appear in bottom-right.
6. **Test scroll anchors:** CTA buttons should smooth-scroll to `#form` section.
7. **Console check:** No `ReferenceError` for `window.csrfToken`, `window.requestTime`, etc. (these are now undefined but `ajaxCall` handles it gracefully since we intercept before they're used).
8. **Grep check:** `grep -r "usmanovafit\.gymteam\.ru/pl/" assets_top5/` should return ZERO matches (all server endpoints stubbed out).

---

## Phase 4: Layout Locking & Responsiveness Validation (Phase Code: LOCK)

> **ACTUAL STATE AFTER PHASE 3:** All server endpoints have been stubbed. Form submissions are intercepted by `window.API_CONFIG.SUBMIT_URL` (`/api/submit`). The `ajaxCall()` interceptor re-routes `/pl/lite/block-public/process` calls. The `noticeWidget` AJAX popups are disabled. Analytics trackers (Clarity, gccounter) are stubbed. The `sendError`, `getUploadifySecretLink`, `panelPutTaskAside`, `panelFinishTask`, `panelLoad`, `onTelegramAuth`, `checkFormPhone`, `ltShowModalForm`, and `initUploadify` functions are stubbed.

---

### Task 4.0: Pre-Flight Cleanup (MUST DO FIRST)

These items were discovered during Phase 3 audit and MUST be cleaned before layout testing.

#### 4.0.1: Remove Gemini Agent Iframes (BOTH files)

**Problem:** Both HTML files contain an embedded Gemini AI chatbot iframe and toggle button at the very end of `<body>`. These are third-party overlays that must be removed.

**top5.html line 7070:** The entire line contains:
```html
<div id="blueimp-gallery" ...>...</div><div id="gemini-agent-root"><iframe src="./assets_top5/4832cce4-0e26-4eb9-8bde-77d81e872843.html" style="position: fixed; ..."></iframe></div><button id="gemini-toggle" style="position: fixed; ...">...</button></body></html>
```

**index.html line 6333:** Identical structure with `./assets_main/66e8de59-....html`.

**Action:**
1. In `top5.html`: Replace the content of line 7070 — remove the `<div id="gemini-agent-root">...</div>` and `<button id="gemini-toggle">...</button>` portions. Keep the `<div id="blueimp-gallery">...</div>` (it's a legitimate image gallery lightbox). Keep `</body></html>` at the end.
2. In `index.html`: Same operation on line 6333.
3. Delete the embedded HTML files: `assets_top5/4832cce4-0e26-4eb9-8bde-77d81e872843.html` and `assets_main/66e8de59-5844-4302-97ac-5742fc9d9c9d.html`.

**Result should look like (end of file):**
```html
<div id="blueimp-gallery" class="blueimp-gallery blueimp-gallery-controls" style="display: none;"><div class="slides next-click"></div><h3 class="title"></h3><a class="prev">‹</a><a class="next next-click">›</a><a class="play-pause"></a><ol class="indicator"></ol></div>
</body></html>
```

#### 4.0.2: Fix Form Action URL in top5.html

**Problem:** The form's `action` attribute still points to the original server:
```html
action="https://usmanovafit.gymteam.ru/pl/lite/block-public/process?id=2235861150"
```

**Why it still works:** The `ajaxCall()` interceptor in `superlite-block-*.js` detects this URL and re-routes it to `window.API_CONFIG.SUBMIT_URL`. However, if JavaScript is disabled or the interceptor loads late, the form would POST directly to the old server.

**Action:** Change the form `action` attribute in `top5.html` line 6738 from:
```
action="https://usmanovafit.gymteam.ru/pl/lite/block-public/process?id=2235861150"
```
to:
```
action="/api/submit"
```

**Note:** The `ajaxCall()` interceptor checks for `/pl/lite/block-public/process` in the URL. After this change, the interceptor will NOT match (the URL is now `/api/submit`). This is fine — the form will POST directly to `/api/submit` without needing the interceptor. The interceptor remains as a fallback for any other code paths that might call the old URL.

#### 4.0.3: Remove Unused Asset Files

**Action:** Delete these files that are no longer referenced or needed:
- `assets_top5/4832cce4-0e26-4eb9-8bde-77d81e872843.html` (Gemini agent)
- `assets_main/66e8de59-5844-4302-97ac-5742fc9d9c9d.html` (Gemini agent)
- `assets_top5/tag.js` (GTM tag replacement — analytics)
- `assets_top5/tag_phono.js` (phone tracking tag — analytics)
- `assets_main/tag.js` (same)
- `assets_main/tag_phono.js` (same)

**Verify before deleting:** Grep for `tag.js` and `tag_phono.js` in both HTML files to confirm they are still loaded as `<script>` tags. If so, remove those `<script>` tags from the HTML files first.

---

### Task 4.1: Layout Freeze Verification

**Action:** Serve the project locally and verify all interactive states match the original behavior.

#### 4.1.1: Start Local Server
```bash
cd D:\katyafitness
python -m http.server 8000
```

#### 4.1.2: Test Modal Windows
1. Open `http://localhost:8000/top5.html`
2. Find and click the "ЗАБРАТЬ НАБОР" CTA button (line 5457 — `button442459`)
3. **Expected:** A Bootstrap modal (`gc-modal`) should appear with the form (`ltForm144649`) inside it
4. **Check:** Modal has a dark backdrop, close button (X) in top-right corner, form fields visible
5. **Close modal:** Click X button, click backdrop, or press ESC — modal should close
6. **Re-open:** Click the CTA button again — modal should re-open cleanly

#### 4.1.3: Test Anchor Scroll to #form
1. On `top5.html`, click any CTA button that has `location.href='#form'`
2. **Expected:** Page smooth-scrolls to the `id="form"` anchor (line 5011)
3. **Check:** The form section is visible after scrolling, no visual offset bugs
4. **Note:** The `bodyScrollTo()` function uses 400px offset. If the sticky menu (if present) covers the form, the offset may need adjustment.

#### 4.1.4: Test Countdown Timers
1. On `top5.html`, verify countdown timers are visible and counting down
2. **Expected:** Timer shows days/hours/minutes/seconds to `2026-06-22 00:00` Moscow time
3. **Check:** Timer does not show "0" or "undefined" values

#### 4.1.5: Test Notification Popup
1. On `top5.html`, wait ~15 seconds after page load
2. **Expected:** A "someone purchased" notification appears in the bottom-right corner
3. **Check:** Notification has a name, city, and product info; closes automatically or via X button

#### 4.1.6: Test Form Submission
1. Open the form modal (click "ЗАБРАТЬ НАБОР")
2. Fill in name, email, phone
3. Click "Продолжить"
4. **Expected:** Form content hides, result block shows "Спасибо! Ваша заявка принята."
5. **Check:** No redirect to `usmanovafit.gymteam.ru`. Check DevTools Network tab — request should go to `/api/submit`

---

### Task 4.2: Media Query & Mobile Breakpoint Guard

**Action:** Validate responsive behavior at standard widths. The project's responsive CSS comes from:
- Inline `<style>` blocks in both HTML files (body background, form input styling)
- `superlite-block-3b3d45c8c82d97c135d0a114931a83b4.css` (Bootstrap grid + component styles)
- `modal.css`, `blocks-modal.css`, `bootstrap-modal.min.css` (modal responsiveness)
- `notice.css` (notice widget mobile)
- `button.css` (button sizing)

#### 4.2.1: Desktop (1440px)
- Open DevTools, set viewport to 1440×900
- Verify all sections render full-width, no horizontal scrollbar
- Verify hero section background image covers full width
- Verify form modal opens at 520px width (per `data-modal-width="520px"`)
- Verify countdown timer is visible and properly sized

#### 4.2.2: Tablet (768px)
- Set viewport to 768×1024
- Verify layout stacks vertically where needed
- Verify form inputs remain usable (not too small)
- Verify modal adjusts: `modal.css` line 9 sets `min-width: 500px → width: 85%`
- Verify no content overflow or horizontal scroll

#### 4.2.3: Mobile (375px)
- Set viewport to 375×667 (iPhone SE)
- Verify form inputs: `@media (max-width: 640px)` applies `font-size: 18px`, `height: 60px`, `text-align: center`
- Verify modal: `modal.css` line 55 sets full-width, close button repositioned
- Verify `blocks-modal.css` line 7: modal dialog 100% width at `max-width: 600px`
- Verify images scale properly, no horizontal overflow
- Verify CTA buttons are tappable (min 44px height)

#### 4.2.4: Fix Broken Responsive Behavior
If any block breaks during scaling:
1. Open the original live site (`https://usmanovafit.gymteam.ru/june_top5`) in a separate browser tab
2. Use DevTools inspector to find the correct CSS rule at that breakpoint
3. Extract the exact `@media` query
4. Append it to the appropriate local CSS file (or inline `<style>` block in the HTML)
5. **DO NOT** modify the layout structure — only add/fix CSS

---

### Task 4.3: Cross-Browser Compatibility Quick Check

**Action:** Verify the site works in these browsers (even if just briefly):
- Chrome/Edge (Chromium)
- Firefox
- Safari (if available)

**Key things to check:**
- Font rendering (Gilroy, Roboto, Open Sans should load from local/Google Fonts CDN)
- Modal backdrop overlay works
- CSS transitions animate smoothly
- Form inputs are focusable and fillable

---

### Task 4.4: Final Grep Verification

After all Phase 4 changes:

1. **No remote usmanovafit.gymteam.ru references in JS/CSS:**
   ```bash
   grep -r "usmanovafit\.gymteam\.ru" assets_top5/*.js assets_top5/*.css assets_main/*.js assets_main/*.css
   ```
   Expected: ZERO matches (HTML comments in `.html` asset files are acceptable)

2. **No remote usmanovafit.gymteam.ru references in HTML:**
   ```bash
   grep "usmanovafit\.gymteam\.ru" index.html top5.html
   ```
   Expected: ZERO matches (the form action should now be `/api/submit`)

3. **No Gemini agent references:**
   ```bash
   grep -r "gemini" index.html top5.html assets_top5/ assets_main/
   ```
   Expected: ZERO matches

4. **No data-src lazy-load remnants:**
   ```bash
   grep -r 'data-src="//' index.html top5.html
   ```
   Expected: ZERO matches

5. **No inline background-image with remote URLs:**
   ```bash
   grep -r "background-image:url.*https://" index.html top5.html
   ```
   Expected: ZERO matches

---

### Task 4.5: Verification Checklist

After completing all Phase 4 tasks, confirm:

- [ ] Gemini agent iframes removed from both HTML files
- [ ] Form action changed to `/api/submit` in top5.html
- [ ] Unused analytics files deleted (tag.js, tag_phono.js)
- [ ] Modal opens/closes correctly on CTA button click
- [ ] ESC key closes modal
- [ ] Anchor scroll to `#form` works without offset bugs
- [ ] Countdown timer displays correctly
- [ ] Notification popup appears after ~15 seconds
- [ ] Form submission shows "Спасибо" message (no redirect)
- [ ] Desktop layout (1440px) renders correctly
- [ ] Tablet layout (768px) renders correctly
- [ ] Mobile layout (375px) renders correctly
- [ ] No console errors related to missing files or undefined variables
- [ ] All grep checks pass (no remote URLs in JS/CSS/HTML)

---

## Phase 5: Final Optimization & Handover (Phase Code: PROD)

> **ACTUAL STATE AFTER PHASE 4:** Gemini agent iframes removed. Form action changed to `/api/submit`. Unused analytics files (`tag.js`, `tag_phono.js`) deleted. All `data-src` lazy-load remnants resolved. All `background-image:url(https://...)` inline references resolved. CMS `add-redesign-subblock` artifacts removed. All `@font-face` paths point to local relative files.

---

### Task 5.1: Download Missing Font & Webfont Files

Several CSS files reference font/webfont files that were never downloaded. These will cause 404 errors in the console.

#### 5.1.1: Glyphicons (BOTH directories)

**Referenced by:** `assets_main/glyphicons.css` and `assets_top5/glyphicons.css`
**Missing files (5 per directory, 10 total):**

Download from the Bootstrap 3 CDN: `https://netdna.bootstrapcdn.com/bootstrap/3.3.7/fonts/`

| Filename | Source URL |
|----------|-----------|
| `glyphicons-halflings-regular.eot` | `https://netdna.bootstrapcdn.com/bootstrap/3.3.7/fonts/glyphicons-halflings-regular.eot` |
| `glyphicons-halflings-regular.woff2` | `https://netdna.bootstrapcdn.com/bootstrap/3.3.7/fonts/glyphicons-halflings-regular.woff2` |
| `glyphicons-halflings-regular.woff` | `https://netdna.bootstrapcdn.com/bootstrap/3.3.7/fonts/glyphicons-halflings-regular.woff` |
| `glyphicons-halflings-regular.ttf` | `https://netdna.bootstrapcdn.com/bootstrap/3.3.7/fonts/glyphicons-halflings-regular.ttf` |
| `glyphicons-halflings-regular.svg` | `https://netdna.bootstrapcdn.com/bootstrap/3.3.7/fonts/glyphicons-halflings-regular.svg` |

**Save to:** `assets_main/fonts/` and `assets_top5/fonts/`

#### 5.1.2: FontAwesome v4 Compatibility & Viber (BOTH directories)

**Referenced by:** `assets_main/old.css` and `assets_top5/old.css` (lines 5–33)
**Missing subdirectories and files:**

The `old.css` references `../webfonts/v4/`, `../webfonts/v5/`, and `../webfonts/fa-viber.*` — but only the flat `webfonts/` directory exists (with FA5 base files). Create subdirectories and download:

**For `webfonts/v4/`** — download from `https://use.fontawesome.com/releases/v5.15.4/fontawesome-free-5.15.4-web.zip` → extract `webfonts/` → copy `v4-compatibility/` contents, OR download FA4 directly:
- Source: `https://netdna.bootstrapcdn.com/font-awesome/4.7.0/fonts/`
- Files needed: `fontawesome-webfont.eot`, `.woff2`, `.woff`, `.ttf`, `.svg`
- Save to: `assets_main/webfonts/v4/` and `assets_top5/webfonts/v4/`

**For `webfonts/v5/`** — copy the existing FA5 base files from `webfonts/` into `webfonts/v5/`:
- `fa-brands-400.{eot,woff2,woff,ttf,svg}`
- `fa-regular-400.{eot,woff2,woff,ttf,svg}`
- `fa-solid-900.{eot,woff2,woff,ttf,svg}`
- Save to: `assets_main/webfonts/v5/` and `assets_top5/webfonts/v5/`

**For `fa-viber.*`** — download Viber icon (FA5 brand):
- Source: `https://use.fontawesome.com/releases/v5.15.4/fontawesome-free-5.15.4-web.zip` → `webfonts/fa-viber.*`
- Files: `fa-viber.eot`, `.woff2`, `.woff`, `.ttf`, `.svg`
- Save to: `assets_main/webfonts/` and `assets_top5/webfonts/`

**For `fa-v4compatibility.*`** — download from same FA5 zip:
- Files: `fa-v4compatibility.woff2`, `.ttf`
- Save to: `assets_main/webfonts/` and `assets_top5/webfonts/`

#### 5.1.3: jQuery UI Theme Images (BOTH directories)

**Referenced by:** `assets_main/jquery-ui.css` and `assets_top5/jquery-ui.css`
**Missing files (12 per directory, 24 total):**

Download all from jQuery UI CDN: `https://code.jquery.com/ui/1.13.2/themes/base/images/`

| # | Filename |
|---|----------|
| 1 | `ui-bg_flat_75_ffffff_40x100.png` |
| 2 | `ui-bg_highlight-soft_75_cccccc_1x100.png` |
| 3 | `ui-bg_glass_55_fbf9ee_1x400.png` |
| 4 | `ui-bg_glass_65_ffffff_1x400.png` |
| 5 | `ui-bg_glass_75_dadada_1x400.png` |
| 6 | `ui-bg_glass_75_e6e6e6_1x400.png` |
| 7 | `ui-bg_glass_95_fef1ec_1x400.png` |
| 8 | `ui-icons_222222_256x240.png` |
| 9 | `ui-icons_2e83ff_256x240.png` |
| 10 | `ui-icons_454545_256x240.png` |
| 11 | `ui-icons_888888_256x240.png` |
| 12 | `ui-icons_cd0a0a_256x240.png` |

**Save to:** `assets_main/images/` and `assets_top5/images/`

**Note:** `ui-bg_flat_0_aaaaaa_40x100.png` already exists in both directories — do not overwrite.

---

### Task 5.2: Clean Up Orphan & Extensionless Files

#### 5.2.1: Identify Mystery Extensionless Files

Three files have no extension and are referenced by the HTML:

| File | Referenced By | Purpose |
|------|--------------|---------|
| `assets_main/68` | `index.html:602` — `<img src="./assets_main/68">` | Thumbnail image |
| `assets_main/17` | `index.html:841` — `<img src="./assets_main/17">` | Thumbnail image |
| `assets_top5/155` | `top5.html:1143` — `<img src="./assets_top5/155">` | Thumbnail image |

**Action:** These are valid image files downloaded without extensions. To clean up:
1. Identify the actual file type by running: `file assets_main/68`, `file assets_main/17`, `file assets_top5/155` (or check first bytes)
2. Rename with correct extension (e.g., `68.png`, `17.png`, `155.png`)
3. Update the `src` attributes in both HTML files accordingly:
   - `index.html:602`: `src="./assets_main/68"` → `src="./assets_main/68.png"` (or correct extension)
   - `index.html:841`: `src="./assets_main/17"` → `src="./assets_main/17.png"` (or correct extension)
   - `top5.html:1143`: `src="./assets_top5/155"` → `src="./assets_top5/155.png"` (or correct extension)

**Alternative (simpler):** If renaming feels risky, leave them as-is. They work fine without extensions. Just verify they are valid images.

#### 5.2.2: Remove Orphan File

- `assets_main/test2.png` — not referenced by any HTML or CSS file. **Delete it.**

---

### Task 5.3: Console Error Zeroing

* **Action:** Run the full project inside a local web server and open the browser DevTools Console.
* **Steps:**
  1. Start server: `python -m http.server 8000` from `D:\katyafitness`
  2. Open `http://localhost:8000/index.html` — check console for 404s and errors
  3. Open `http://localhost:8000/top5.html` — same check
  4. Fix any remaining `404 Not Found` errors (these will likely be the fonts/images from Task 5.1)
  5. Fix any uncaught `ReferenceError` for undefined variables
  6. Mock any missing tracking/analytics files with empty JS stubs if scripts try to load them
* **Expected 404 sources after Phase 4:**
  - `fonts/glyphicons-halflings-regular.*` → fixed by Task 5.1.1
  - `webfonts/v4/fontawesome-webfont.*` → fixed by Task 5.1.2
  - `webfonts/v5/fa-*.*` → fixed by Task 5.1.2
  - `webfonts/fa-viber.*` → fixed by Task 5.1.2
  - `webfonts/fa-v4compatibility.*` → fixed by Task 5.1.2
  - `images/ui-bg_*` and `images/ui-icons_*` → fixed by Task 5.1.3

---

### Task 5.4: Final Verification Checklist

After completing all tasks above, confirm every item:

- [ ] All glyphicons font files present in both `fonts/` directories
- [ ] All FontAwesome v4/v5/viber/v4compatibility webfont files present in both `webfonts/` directories
- [ ] All jQuery UI theme images present in both `images/` directories
- [ ] Extensionless files renamed (or confirmed working as-is)
- [ ] `test2.png` orphan deleted
- [ ] Zero 404 errors in browser console for `index.html`
- [ ] Zero 404 errors in browser console for `top5.html`
- [ ] Zero `ReferenceError` for undefined variables in console
- [ ] Form submission on `top5.html` works (POST to `/api/submit`, shows "Спасибо" message)
- [ ] Modal opens/closes on CTA button click
- [ ] Countdown timer displays correctly
- [ ] Notification popup appears after ~15 seconds
- [ ] No broken images visible on either page
- [ ] `grep -r "gemini" index.html top5.html assets_top5/ assets_main/` returns ZERO matches (except SPEC.md)
- [ ] `grep -r 'data-src="//' index.html top5.html` returns ZERO matches
- [ ] `grep -r "background-image:url.*https://" index.html top5.html` returns ZERO matches
- [ ] `grep -r "add-redesign-subblock" index.html top5.html` returns ZERO matches

---

### Task 5.5: Production Readiness — Final Deliverable

**Deliverable:** A single directory ready for deployment:

```text
D:\katyafitness\
├── index.html           (Main landing page — 6334 lines, fully cleaned)
├── top5.html            (Subpage — 7071 lines, fully cleaned)
├── assets_main/
│   ├── fonts/           (gilroy-400/500/600.woff + glyphicons-halflings-regular.*)
│   ├── webfonts/        (FA5 base + v4/ + v5/ + fa-viber.* + fa-v4compatibility.*)
│   ├── images/          (13 jQuery UI theme images)
│   ├── *.css            (16 stylesheets)
│   ├── *.js             (9 scripts)
│   └── *.png/*.jpg/*.svg (image assets)
└── assets_top5/
    ├── fonts/           (same as above)
    ├── webfonts/        (same as above)
    ├── images/          (13 jQuery UI theme images)
    ├── *.css            (16 stylesheets)
    ├── *.js             (12 scripts — includes countdown, gccounter, localstore)
    └── *.png/*.jpg/*.svg (image assets)
```

**No external CDN dependencies** — all assets are local. All form submissions route to `/api/submit`. No analytics trackers. No Gemini agent. No CMS artifacts.
---