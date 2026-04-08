# Design System Specification: The Cinematic Canvas

## 1. Overview & Creative North Star: "The Digital Curator"
This design system is built to transform a standard database into a premiere cinematic experience. Our Creative North Star is **The Digital Curator**. We are not building a utility; we are building a theater. 

To break the "template" look common in streaming apps, this system rejects rigid, boxed-in grids in favor of **intentional asymmetry** and **tonal depth**. We treat the screen as a dark stage where light and content take center stage. By using high-contrast typography scales and overlapping "glass" layers, we create a sense of physical space and premium editorial authority.

---

## 2. Colors & Surface Philosophy
The palette is rooted in the depth of a darkened cinema, using `background (#060e20)` as our "void." 

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders to define sections. Boundaries must be defined solely through:
1.  **Tonal Shifts:** Placing a `surface-container-low (#091328)` card against a `surface (#060e20)` background.
2.  **Luminance Hierarchy:** Using `surface-bright (#1f2b49)` to draw the eye to interactive zones.

### Surface Hierarchy & Nesting
Treat the UI as stacked sheets of frosted glass. 
*   **Base:** `surface-dim (#060e20)`
*   **Level 1 (Content Rails):** `surface-container-low (#091328)`
*   **Level 2 (Cards/Modals):** `surface-container-highest (#192540)`

### The "Glass & Gradient" Rule
To achieve a signature "Electric Indigo" feel, primary CTAs should not be flat. Use a linear gradient from `primary (#a5a5ff)` to `primary-container (#9695ff)` at a 135-degree angle. For floating overlays (like navigation bars or movie detail descriptors), apply `surface-variant (#192540)` at 60% opacity with a `20px` backdrop-blur.

---

## 3. Typography: Editorial Impact
We pair the structural precision of **Inter** with the expressive, wide stance of **Manrope** to create a high-end editorial feel.

*   **Display (Manrope):** Used for movie titles and "hero" moments. `display-lg (3.5rem)` uses tight letter-spacing (-0.02em) to feel like a movie poster.
*   **Headline (Manrope):** Used for category headers. `headline-md (1.75rem)` should be Bold (700) to command attention against dark backgrounds.
*   **Title & Body (Inter):** For metadata (cast, synopsis). `title-md (1.125rem)` handles the heavy lifting, while `body-md (0.875rem)` in `on-surface-variant (#a3aac4)` provides readable, low-fatigue descriptions.
*   **Label (Inter):** `label-sm (0.6875rem)` in All Caps with +0.05em tracking for technical data (e.g., 4K, HDR, 128 min).

---

## 4. Elevation & Depth: Tonal Layering
Traditional drop shadows are too "software-like" for a cinematic experience. We use **Ambient Shadows** and **Luminance**.

*   **The Layering Principle:** Depth is achieved by stacking. A `surface-container-lowest (#000000)` player control bar sits atop a `surface (#060e20)` background, creating a natural "recessed" look.
*   **Ambient Shadows:** For floating "Gold" elements (Secondary actions), use a shadow color of `#ffd709` at 8% opacity with a `32px` blur and `12px` Y-offset.
*   **The "Ghost Border" Fallback:** If a boundary is required for accessibility, use `outline-variant (#40485d)` at 15% opacity. Never use 100% opaque lines.
*   **Visual Soul:** High-quality movie posters should feature a soft `xl (1.5rem)` corner radius and a subtle inner glow (1px white inner stroke at 10% opacity) to mimic light catching the edge of a physical film cell.

---

## 5. Components

### Buttons
*   **Primary (Indigo):** Gradient of `primary` to `primary-container`. `full` roundedness. Large horizontal padding (24px).
*   **Secondary (Cinematic Gold):** `secondary (#ffd709)` background with `on-secondary (#5b4b00)` text. Use for "Buy/Rent" or high-conversion actions.
*   **Tertiary (Glass):** Semi-transparent `surface-variant` with a 20px backdrop blur. Used for "Add to Watchlist" over imagery.

### Cards & Lists
*   **Rule:** Forbid divider lines.
*   **Implementation:** Use a `1.5rem (xl)` corner radius. Space items using the `24px` spacing token. To separate list items, shift the background of alternating rows from `surface` to `surface-container-low`.

### Cinematic Chips
*   **Style:** `surface-container-high` background. No border. Used for genres (e.g., "Sci-Fi"). When selected, the chip transforms into the `secondary_dim (#efc900)` gold.

### Input Fields
*   **Search:** Use `surface-container-highest` with a `md (0.75rem)` radius. The placeholder text should use `on-surface-variant`. On focus, the container should glow with a subtle `primary` outer halo (4px blur).

---

## 6. Do's and Don'ts

### Do:
*   **Do** allow movie posters to "break" the grid slightly, overlapping into the header area to create depth.
*   **Do** use `secondary_fixed_dim (#efc900)` for star ratings to ensure they "pop" against the charcoal backgrounds.
*   **Do** use extreme vertical whitespace (48px+) between major sections to let the high-quality imagery breathe.

### Don't:
*   **Don't** use pure white (#FFFFFF) for body text. Use `on-background (#dee5ff)` to reduce eye strain in dark environments.
*   **Don't** use standard "Material Design" ripples for touch feedback. Use a subtle "scale-down" (0.98) transform and a brightness increase.
*   **Don't** ever use a 1px solid divider. If you need to separate content, use a `16px` gap or a tonal background shift.