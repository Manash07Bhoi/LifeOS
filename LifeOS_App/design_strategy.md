# Design System Strategy: LifeOS Editorial Framework

## 1. Overview & Creative North Star: "The Digital Architect"
The North Star for this design system is **The Digital Architect**. We are not building a standard utility app; we are crafting a premium, sentient OS interface that feels like it was pulled from a high-end laboratory in 2077.

To break the "template" look, we move away from symmetrical grids. This system utilizes **Intentional Asymmetry**—where large-scale typography might be anchored to the far left, while data visualizations float in the "negative space" on the right. We replace rigid containers with overlapping layers of frosted light, creating an interface that feels three-dimensional and alive.

---

## 2. Colors & Surface Philosophy
The palette is rooted in a deep, nocturnal void (`#0e0e13`), punctuated by hyper-saturated light leaks.

### The "No-Line" Rule
Explicitly prohibit 1px solid borders for sectioning. Boundaries are defined through:
- **Tonal Shifts:** Placing a `surface_container_low` card against a `surface` background.
- **Light Bleed:** Using subtle radial gradients of `primary_dim` to suggest an edge.
- **Glassmorphism:** Using `rgba(255, 255, 255, 0.05)` with a 20px–40px backdrop-blur.

### Surface Hierarchy & Nesting
Treat the UI as a series of stacked, semi-translucent sheets.
- **Level 0 (Base):** `surface` (#0e0e13) – The infinite void.
- **Level 1 (Nesting):** `surface_container` (#19191f) – For secondary content blocks.
- **Level 2 (Active):** `surface_variant` (#25252d) – High-priority interactive regions.

### The "Glass & Gradient" Rule
Standard flat colors lack "soul." Main CTAs and Hero elements must use a **Signature Texture**: A linear gradient from `primary` (#b1a1ff) to `primary_dim` (#7757fa) at a 135-degree angle. This provides a sense of refractive light that flat hex codes cannot achieve.

---

## 3. Typography: The Editorial Voice
We use typography as a structural element, not just for legibility.

- **Display & Headlines (Plus Jakarta Sans):** These are the "anchors." Use `display-lg` with tight tracking (-2%) for a bold, cinematic impact. The brand identity relies on the contrast between these massive, wide headings and the utilitarian data.
- **Body (Manrope):** Chosen for its geometric clarity and high readability in dark mode.
- **Command UI (Space Grotesk):** This monospace-adjacent font is reserved for "System Data"—timestamps, coordinates, and raw status updates. It provides that "Terminal" aesthetic essential to the cyberpunk feel.

---

## 4. Elevation & Depth: Tonal Layering
We do not use shadows to simulate height; we use **luminance**.

- **The Layering Principle:** Place a `surface_container_lowest` (#000000) card on a `surface_container_high` (#1f1f26) section to create a "recessed" or "cut-out" look.
- **Ambient Glows:** Floating elements (like Modals or FABs) use a shadow color derived from `surface_tint` (#b1a1ff) at 8% opacity with a 30px blur. This mimics the glow of a neon sign against a dark wall.
- **The "Ghost Border" Fallback:** If containment is required for accessibility, use the `outline_variant` token at **15% opacity**. This creates a "hairline" edge that only appears when light hits it correctly.

---

## 5. Components

### Buttons & Interaction
- **Primary:** Gradient fill (`primary` to `primary_dim`). `xl` roundedness (1.5rem). No border, but a subtle outer glow on hover/active states.
- **Secondary (Glass):** `rgba(255, 255, 255, 0.05)` background with a 1px "Ghost Border" of `secondary_fixed_dim`.
- **Tertiary:** Pure text using `label-md` in `secondary`.

### Cards & Lists
- **Forbid Dividers:** Use `surface_container_low` background shifts or 32px of vertical whitespace to separate items.
- **Nesting:** Small chips (status indicators) inside cards should use `surface_bright` to pop against the blurred glass background.

### Command Input (Custom Component)
- A specialized text field for LifeOS. It uses `surface_container_lowest` with a `secondary` (#00e3fd) "neon-pulse" cursor. Typography must be `label-md` (Space Grotesk).

### Progress Visualizers
- Replace standard bars with circular "Glow Rings." Use `secondary` for the progress track and `secondary_container` for the background, with a blur effect on the leading edge of the progress line to simulate movement.

---

## 6. Do’s and Don’ts

### Do:
- **Embrace Negative Space:** If a screen feels full, it is wrong. Increase padding-top to 40px+ for headers.
- **Use "Data-Brutalism":** Use `tertiary` (#ff6d8a) sparingly for critical alerts or "System Overload" states.
- **Animate Transitions:** Use "Staggered Entry" animations. Elements shouldn't appear at once; they should slide in from the bottom with a 0.4s ease-out, creating a sense of weight.

### Don’t:
- **Don't use 100% White:** Never use #FFFFFF for text. Use `on_surface` (#f9f5fd) to prevent "retina burn" against the dark background.
- **Don't use Standard Icons:** Avoid rounded, friendly icons. Use sharp, high-stroke-weight linear icons that match the `outline` token.
- **Don't over-saturate:** If every element has a neon glow, nothing is special. Keep 90% of the UI monochromatic (`surface` and `surface_container` tiers) and save the neons for active interactions.

---

## 7. Token Summary Reference
- **Corner Radius:** `xl` (24px/1.5rem) for main cards; `md` (12px/0.75rem) for inner chips.
- **Blur Strength:** 20px–40px for all glassmorphic layers.
- **Text Contrast:** Ensure `on_surface_variant` is used for non-essential info to maintain a clear visual hierarchy.
