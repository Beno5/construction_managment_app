# Global UI Scaling Guide

## What Was Implemented

Your entire Rails + Tailwind app now renders at **80% size** using CSS `transform: scale(0.8)`, identical to browser zoom at 75-80%.

### Changes Made

1. **Layout Wrapper** (`app/views/layouts/application.html.erb`)
   - Added `<div id="app-scale-wrapper">` wrapping all visible content
   - Includes navbar, sidebar, main content, modals, flash messages, etc.

2. **CSS Scaling** (`app/assets/stylesheets/application.tailwind.css`)
   - Applied `transform: scale(0.8)` with `transform-origin: top left`
   - Width/height compensation: `125%` (1 / 0.8 = 1.25)
   - Hidden horizontal scrollbar to prevent scale artifacts
   - **Mobile-responsive**: Scaling disabled on screens < 768px wide

### How It Works

- **Desktop**: Everything scales to 80% size
- **Mobile/Tablet**: Scaling automatically disabled (screens < 768px)
- **Scrolling**: Works normally (vertical scroll enabled)
- **Fixed elements**: Flash messages, modals, loading overlays all scale correctly
- **Gantt chart**: Scales proportionally with all other content
- **Turbo Frames**: Work normally within scaled container
- **Stimulus controllers**: No changes needed - work identically

---

## Testing Checklist

After restarting your dev server (`bin/dev`), verify:

- ✅ Entire UI appears ~20% smaller than before
- ✅ Navbar, sidebar, and main content all scaled proportionally
- ✅ Sidebar collapse/expand still works
- ✅ Scrolling works smoothly (no horizontal scrollbar)
- ✅ Modals appear centered and scaled
- ✅ Flash messages/notifications display correctly
- ✅ Gantt chart renders at 80% size and drag/drop works
- ✅ Tables, forms, buttons all scaled uniformly
- ✅ Inline editing still functional
- ✅ Toggle sections expand/collapse normally

---

## Adjusting the Scale

To change the scale percentage, edit `app/assets/stylesheets/application.tailwind.css`:

```css
#app-scale-wrapper {
  transform: scale(0.75); /* 75% size */
  width: 133.33%;         /* 1 / 0.75 = 1.333 */
  height: 133.33%;
}
```

**Common scale values:**
- `0.9` (90%) → width/height: `111.11%`
- `0.8` (80%) → width/height: `125%` ← **Current**
- `0.75` (75%) → width/height: `133.33%`
- `0.7` (70%) → width/height: `142.86%`

**Formula:** `width/height = (1 / scale) × 100%`

After changing, rebuild Tailwind:
```bash
bundle exec rails tailwindcss:build
```

---

## Disabling Scaling

### Option 1: Temporary (Development)
Add this to your browser DevTools console:
```javascript
document.getElementById('app-scale-wrapper').style.transform = 'none';
```

### Option 2: Permanent
Remove or comment out the scaling CSS in `application.tailwind.css`:
```css
#app-scale-wrapper {
  /* transform: scale(0.8); */
  /* width: 125%; */
  /* height: 125%; */
}
```

Then rebuild: `bundle exec rails tailwindcss:build`

---

## Optional Enhancement: Toggle Button

Want to let users switch between normal (100%) and scaled (80%) views? Follow these steps:

### Step 1: Create Stimulus Controller

Create `app/javascript/controllers/scale_controller.js`:

```javascript
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["wrapper"]

  connect() {
    // Check localStorage for user preference
    const userId = this.element.dataset.userId
    const savedState = localStorage.getItem(`scale_enabled_${userId}`)

    if (savedState === 'false') {
      this.disable()
    }
  }

  toggle() {
    const wrapper = document.getElementById('app-scale-wrapper')
    const isScaled = wrapper.classList.contains('scale-disabled')

    if (isScaled) {
      this.enable()
    } else {
      this.disable()
    }
  }

  enable() {
    const wrapper = document.getElementById('app-scale-wrapper')
    wrapper.classList.remove('scale-disabled')

    const userId = this.element.dataset.userId
    if (userId) {
      localStorage.setItem(`scale_enabled_${userId}`, 'true')
    }
  }

  disable() {
    const wrapper = document.getElementById('app-scale-wrapper')
    wrapper.classList.add('scale-disabled')

    const userId = this.element.dataset.userId
    if (userId) {
      localStorage.setItem(`scale_enabled_${userId}`, 'false')
    }
  }
}
```

### Step 2: Register Controller

Edit `app/javascript/controllers/index.js`:

```javascript
import ScaleController from "./scale_controller"
application.register("scale", ScaleController)
```

### Step 3: Add CSS Class for Disabled State

Add to `app/assets/stylesheets/application.tailwind.css`:

```css
/* Disable scaling when toggled off */
#app-scale-wrapper.scale-disabled {
  transform: none !important;
  width: 100% !important;
  height: 100% !important;
}
```

### Step 4: Add Toggle Button to Navbar

Edit `app/views/partials/_navbar.html.erb` and add this button (near sidebar toggle):

```erb
<% if user_signed_in? %>
  <!-- Scale Toggle Button -->
  <div data-controller="scale" data-user-id="<%= current_user.id %>">
    <button type="button"
            data-action="click->scale#toggle"
            class="p-2 text-gray-500 rounded-lg hover:text-gray-900 hover:bg-gray-100 dark:text-gray-400 dark:hover:text-white dark:hover:bg-gray-700"
            title="Toggle UI Scale (80% / 100%)">
      <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 8V4m0 0h4M4 4l5 5m11-1V4m0 0h-4m4 0l-5 5M4 16v4m0 0h4m-4 0l5-5m11 5l-5-5m5 5v-4m0 4h-4"/>
      </svg>
    </button>
  </div>
<% end %>
```

### Step 5: Rebuild Assets

```bash
yarn build
bundle exec rails tailwindcss:build
```

Now users can click the toggle button to switch between 80% and 100% UI size!

---

## Troubleshooting

### Issue: Horizontal scrollbar appears
**Solution:** Ensure `body` has `overflow-x: hidden` in CSS (already applied)

### Issue: Fixed modals not centered
**Solution:** Modals are inside `#app-scale-wrapper`, so they scale correctly. If issues persist, check modal positioning CSS.

### Issue: Gantt chart cut off
**Solution:** The Gantt container scales with everything else. If cut off, check parent container widths - they should be percentage-based, not fixed pixels.

### Issue: Text too small to read
**Solution:** Increase scale to `0.85` or `0.9` instead of `0.8`

### Issue: Mobile view broken
**Solution:** The media query should disable scaling on mobile. Check that it's not commented out:
```css
@media (max-width: 768px) {
  #app-scale-wrapper {
    transform: none;
    width: 100%;
    height: 100%;
  }
}
```

---

## Production Deployment

The scaling is pure CSS - no configuration needed for production. Just deploy as normal:

```bash
git add .
git commit -m "Add global 80% UI scaling with CSS transform"
git push heroku master
```

Heroku will automatically:
1. Build JavaScript with ESBuild
2. Compile Tailwind CSS (includes scaling rules)
3. Precompile assets

---

## Reverting Changes

If you need to remove scaling completely:

1. **Remove wrapper** from `app/views/layouts/application.html.erb`:
   - Delete `<div id="app-scale-wrapper">` (line 95)
   - Delete `</div>` closing tag (line 138)

2. **Remove CSS** from `app/assets/stylesheets/application.tailwind.css`:
   - Delete lines 283-304 (the scaling CSS block)

3. **Rebuild:**
   ```bash
   bundle exec rails tailwindcss:build
   ```

4. **Optional:** Delete this guide file:
   ```bash
   rm GLOBAL_SCALE_GUIDE.md
   ```
