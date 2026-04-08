# Design System: Cinematic Immersion

## 1. Overview & Creative North Star: "The Digital Cinematheque"
This design system is built to transcend the "utility app" feel and enter the realm of high-end editorial curation. Our North Star is **The Digital Cinematheque**: an experience that feels like a darkened theater where the interface dissolves, leaving only the narrative. 

To achieve this, we move away from the rigid, boxed-in layouts of traditional streaming platforms. We embrace **intentional asymmetry**, where hero imagery might bleed off-canvas, and **tonal depth**, where elements are separated by light and shadow rather than lines. This is not a library; it is a premiere.

---

## 2. Colors: Tonal Depth & The "No-Line" Rule
The palette is rooted in deep obsidians and cinematic crimsons, designed to prioritize the content's vibrant colors.

### The "No-Line" Rule
**Strict Mandate:** Prohibit the use of 1px solid borders for sectioning or containment. 
Structure must be defined through:
- **Surface Shifts:** Using `surface-container-low` against `background`.
- **Negative Space:** Aggressive use of the spacing scale to create mental boundaries.
- **Tonal Transitions:** Subtle gradients that guide the eye without a hard "stop."

### Surface Hierarchy & Nesting
Treat the UI as physical layers of smoked glass. 
- **Base Layer:** `surface` (#0d0d18) for global backgrounds.
- **Secondary Layer:** `surface-container-low` (#12121e) for large section backgrounds (e.g., a "Trending Now" shelf).
- **Floating Layer:** `surface-container-high` (#1e1e2d) for cards and interactive modules to create a "lifted" feel.

### The "Glass & Gradient" Rule
To avoid a flat, "templated" look:
- **Hero Overlays:** Use a linear gradient transitioning from `surface` (100% opacity) to `surface` (0% opacity) over hero photography to ensure typography remains legible while maintaining immersion.
- **Action Glass:** Use `surface-bright` at 60% opacity with a `20px` backdrop-blur for floating navigation bars or search overlays.

---

## 3. Typography: The Editorial Voice
We use a dual-typeface system to balance cinematic drama with high-performance readability.

*   **Display & Headlines (Epilogue):** An authoritative, wide-set sans-serif. Use `display-lg` for movie titles in hero sections to create a "poster" feel. Headlines should use tight letter-spacing (-2%) to feel "packed" and impactful.
*   **Body & Labels (Manrope):** A modern, geometric sans-serif optimized for legibility. Its high x-height ensures that movie metadata (runtime, year, genre) is readable even at `label-sm` sizes.

**Visual Hierarchy Tip:** Always pair a `headline-lg` (Epilogue) with a `label-md` (Manrope) in all-caps for metadata to create a sophisticated, high-contrast editorial look.

---

## 4. Elevation & Depth: Tonal Layering
Traditional shadows are too heavy for a cinematic dark theme. Instead, we use light.

*   **The Layering Principle:** Depth is achieved by "stacking." A `surface-container-highest` card placed on a `surface-container-low` background creates a natural, soft lift.
*   **Ambient Glow:** For "Primary" featured content, instead of a black shadow, use a soft glow using `primary` at 10% opacity with a `40px` blur. This mimics the light "bleed" from a cinema screen.
*   **The Ghost Border Fallback:** If a boundary is essential (e.g., a search input), use `outline-variant` at 15% opacity. Never use 100% opaque outlines.

---

## 5. Components

### Movie Cards
- **Structure:** No borders. Use `xl` (0.75rem) corner radius.
- **Rating Badge:** Use `tertiary` (#ffe2a5) background with `on_tertiary` text. Position it asymmetrically, overlapping the top-left corner of the poster.
- **Interaction:** On hover, the card should scale (1.05x) and the `surface-tint` should create a subtle inner glow.

### Horizontal Movie Lists
- **Layout:** Use "Partial Reveal" to signal scrollability. The last visible card should be cut off by the screen edge.
- **'See All' Buttons:** Use `label-md` Typography. Replace the standard box button with a "Ghost" style—text-only with a trailing `primary` arrow icon.

### Search Bars
- **Style:** Use `surface-container-highest`. Apply `full` roundedness. 
- **Iconography:** Use a `primary-dim` color for the search icon to give it a "signature" look against the dark surface.

### Buttons
- **Primary:** `primary` background, `on_primary` text. Use `md` (0.375rem) roundedness for a sharper, modern edge.
- **Secondary/Glass:** Use `surface-bright` at 20% opacity with a backdrop-blur. This allows the movie poster behind the button to "tint" the button itself.

---

## 6. Do's and Don'ts

### Do
- **Do** use `surface-container-lowest` (pure black) for the very bottom of long-scroll pages to create a "fade to black" cinematic exit.
- **Do** use `tertiary` (#ffe2a5) sparingly for critical highlights like star ratings or "Premium" badges.
- **Do** maximize the use of `xl` (12px) and `lg` (8px) radii to keep the "sleek" brand promise.

### Don't
- **Don't** use dividers or lines to separate list items. Use 24px–32px of vertical white space instead.
- **Don't** use pure white (#FFFFFF) for body text; use `on_surface_variant` (#aba9b9) to reduce eye strain in dark environments. Save pure white for Headings.
- **Don't** use standard "drop shadows." If an element needs to pop, increase its surface tier (e.g., from `low` to `high`).