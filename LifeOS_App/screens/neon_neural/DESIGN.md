# Neon Neural Design System

### 1. Overview & Creative North Star
**Creative North Star: The Cybernetic Architect**
Neon Neural is a high-performance design system built for the intersection of human cognitive flow and digital optimization. It rejects the mundane "SaaS blue" template in favor of a "Cyber-Editorial" aesthetic. The system prioritizes data density without clutter, using deep atmospheric voids and vibrant, self-illuminating accents to guide the eye. It breaks the grid through intentional asymmetry—pairing massive, aggressive headlines with ultra-minimalist status indicators.

### 2. Colors
The palette is rooted in a deep obsidian `#0e0e13` background, providing a high-contrast stage for vibrant violet, cyan, and rose accents.

*   **Primary (Neural Violet):** `#7C5CFF` — Used for core interactive elements and brand identifiers.
*   **Secondary (Data Cyan):** `#00E5FF` — Used for success states, secondary metrics, and flow indicators.
*   **Tertiary (Pulse Rose):** `#FF3D71` — Used for high-alert data, warnings, and system exceptions.
*   **The "No-Line" Rule:** Direct structural borders are strictly prohibited for sectioning. Use background shifts (e.g., `surface` to `surface_container`) or subtle glows to define edges.
*   **Surface Hierarchy:** Layers are defined by "Tonal Depth." The base is `surface`. Floating containers use `glass-panel` properties (40% opacity with 20px blur) to create a sense of verticality.
*   **Signature Textures:** Utilize radial and conic gradients (e.g., `#7C5CFF` to `#7757fa`) for main CTAs to simulate "glowing" energy sources.

### 3. Typography
The system uses a tri-font hierarchy to balance high-fashion editorial style with technical precision.

*   **Display & Headline (Plus Jakarta Sans):** Set in Extra Bold/Black. Used for "Neural Headlines" with tight tracking (-0.05em) and aggressive scale (up to `3.75rem` / `60px`).
*   **Body (Manrope):** Set in Medium/Semi-Bold for high legibility in dense data contexts. Primary size is `1.125rem`.
*   **Label (Space Grotesk):** Mono-spaced feel for technical metadata, timestamps, and status labels. Often used in uppercase with wide tracking (`0.3em`) at small sizes (`10px`).
*   **Typography Scale:**
    *   **Neural Giant:** 3.75rem (Hero)
    *   **System Title:** 2.25rem
    *   **Data Header:** 1.5rem
    *   **Body Lg:** 1.125rem
    *   **Technical Small:** 10px

### 4. Elevation & Depth
Elevation is achieved through light emission rather than physical shadows.

*   **Layering Principle:** Components don't sit *on* the surface; they float in a 3D z-space defined by transparency.
*   **Ambient Shadows:** Use `0 0 15px rgba(124, 92, 255, 0.1)` to create a "Glow Border" effect on hover, suggesting the component is energized.
*   **Glassmorphism:** Navigation and persistent panels must use `backdrop-filter: blur(20px)` and a `1px` border at `white/10` to simulate etched glass.
*   **The Ghost Border:** If a separator is required, use `white/5` (very low opacity) to suggest a boundary without creating a hard visual break.

### 5. Components
*   **Glass Panels:** The standard container. Rounded `xl` (1.5rem) corners, semi-transparent background, and blurred backdrop.
*   **Neural Buttons:** Pill-shaped (`rounded-full`) or sharp-edged squares. Primary buttons feature a "Glow-Drop" shadow of their own hex color.
*   **Circular Progress:** Conic gradients (`#7C5CFF` to `#25252d`) that feel like analog system gauges.
*   **Bento Cards:** Use asymmetric spans (2x1, 1x1, 3x1) to create a rhythmic, non-repetitive layout.
*   **Bottom Navigation:** A floating "Command Deck" using heavy blur (`2xl`) and a concentrated gradient for the "Home" or "Action" center point.

### 6. Do's and Don'ts
*   **Do:** Use high-contrast color shifts to denote importance.
*   **Do:** Mix font families within the same component to separate data from labels.
*   **Do:** Apply `active:scale-95` to all interactive icons for haptic visual feedback.
*   **Don't:** Use solid white (#FFFFFF) for body text; use `on_surface` (#f9f5fd) to prevent ocular strain in dark mode.
*   **Don't:** Use standard material shadows. If it doesn't "glow," it shouldn't have a shadow.
*   **Don't:** Center-align long-form text. Maintain a strict left-aligned or asymmetric right-aligned technical look.