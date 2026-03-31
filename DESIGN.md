# Design System Strategy: The Kinetic Minimalist

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Digital Stage."** 

In the world of professional dance, performance is defined by explosive movement against a disciplined, darkened void. This design system translates that physical energy into a digital interface. We are moving beyond a "standard" dark mode to create a high-end editorial experience that feels premium and intentional. 

Instead of rigid grids and heavy containers, we utilize **Asymmetric Tension**. By leveraging generous white space (negative space) and placing high-chroma accents against deep, "infinite" blacks, we guide the eye toward action. The UI should never feel like a static utility; it should feel like a spotlight hitting a performer—focused, high-contrast, and elegant.

## 2. Colors: Tonal Depth & The "No-Line" Rule
The palette is rooted in deep obsidian tones, punctuated by high-energy "Solana" electrics.

### The Palette
- **Background & Base:** `surface` (#0e0e0e) and `surface_container_lowest` (#000000). Use these to create an "infinite" depth where the hardware bezel and the software interface merge.
- **Vibrant Accents:** `primary` (#c59aff) and `secondary` (#679cff). These are your spotlights. Use them sparingly for critical CTAs and active states to maintain their "electric" impact.
- **Functional Tones:** `tertiary` (#ff8ba0) for high-energy status tags or "hot" performance metrics.

### The "No-Line" Rule
**Explicit Instruction:** Prohibit the use of 1px solid borders for sectioning content. 
Standard UI relies on lines; high-end UI relies on **Tonal Transitions**. Boundaries must be defined solely through background color shifts. To separate a video preview from a stats list, transition from `surface_container_low` (#131313) to `surface` (#0e0e0e). This creates a sophisticated, "melted" look that feels native to the OLED display.

### The "Glass & Gradient" Rule
To avoid a flat, "templated" feel:
- **Floating Elements:** Use Glassmorphism for navigation bars and floating action buttons. Apply `surface_container_high` with a 70% opacity and a 20px-30px backdrop blur.
- **Signature Textures:** For primary buttons, do not use a flat hex. Apply a subtle linear gradient from `primary` (#c59aff) to `primary_dim` (#9742fd) at a 135-degree angle. This gives the "Solana Purple" a physical, liquid quality.

## 3. Typography: Editorial Hierarchy
We use the system font (San Francisco/Inter) but apply it with editorial intent. The goal is a high-contrast ratio between "Display" and "Body."

- **Display & Headline:** Use `display-lg` (3.5rem) for major milestones or "Proof" screens. Use `headline-lg` (2rem) for screen headers. These should be set with tight letter-spacing (-0.02em) to feel authoritative and "fashion-forward."
- **Title & Subheads:** `title-md` (1.125rem) should be used for card titles. 
- **The Body:** `body-md` (0.875rem) handles the secondary information. 
- **Interaction:** All labels (`label-md`) should be Uppercase with 0.05em tracking to differentiate them from content, mimicking professional stage cues.

## 4. Elevation & Depth: Tonal Layering
In this system, depth is not "up and down"—it is "forward and back."

- **The Layering Principle:** Stack surfaces to create focus. Place a `surface_container_highest` (#262626) card on a `surface` (#0e0e0e) background. The contrast provides the "lift."
- **Ambient Shadows:** Shadows are rarely used. When required for "Floating" elements, use an extra-diffused shadow: `Offset: 0, 20 | Blur: 40 | Color: primary (at 8% opacity)`. This makes the element appear to be glowing rather than casting a heavy shadow.
- **The "Ghost Border" Fallback:** If accessibility requires a container edge, use a "Ghost Border": `outline_variant` (#484848) at 15% opacity. It should be felt, not seen.

## 5. Components

### Buttons
- **Primary:** Gradient fill (`primary` to `primary_dim`), `xl` (1.5rem) corner radius. Use `on_primary_fixed` (#000000) for text to ensure maximum legibility against the vibrant purple.
- **Secondary:** `surface_container_highest` fill with a `primary` "Ghost Border."
- **Tertiary:** No background. Text-only using `primary` color, bold weight.

### Cards & Lists
- **Rule:** Forbid divider lines. 
- **Implementation:** Use `8` (2rem) spacing from the scale to separate list items. For cards, use `surface_container` (#191919) and `xl` (1.5rem) corner radius. Elements inside should feel "nested" rather than "boxed."

### Inputs & Fields
- **Base State:** `surface_container_low` background, no border.
- **Focus State:** A 1px `primary` Ghost Border (20% opacity) and a subtle glow.
- **Error:** Utilize `error` (#ff6e84) only for text; keep the container neutral to avoid "red-alert" visual fatigue.

### Additional App-Specific Components
- **The "Performance Gauge":** A custom progress ring using `secondary` (#679cff) with a `secondary_container` track.
- **SF Symbol Integration:** Use "Ultralight" or "Thin" weights for SF Symbols to match the minimalist editorial aesthetic.

## 6. Do's and Don'ts

### Do
- **Use Intentional Asymmetry:** Align text to the left but place action icons in unexpected, high-reach areas to create a "custom" feel.
- **Embrace the Dark:** Allow 40% of the screen to remain `surface_container_lowest` (#000000).
- **Smooth Corners:** Always use iOS "Continuous" corner smoothing for the `xl` and `lg` radii.

### Don't
- **Don't Use Pure White for Secondary Text:** Always use `on_surface_variant` (#ababab) for timestamps or metadata. Pure white is for headers only.
- **Don't Use Dividers:** If you feel the need for a line, increase the `spacing` scale by one increment instead.
- **Don't Over-Animate:** Movement should be "Snappy and Weighted," like a dancer landing a jump. Use ease-out-expo curves for transitions.