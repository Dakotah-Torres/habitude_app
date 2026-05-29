# Habitude — Design System

> The authoritative design language. Owned and maintained by the **Designer**.
> Every UI sprint builds against this. Stable like `spec.md`; changes are
> Designer-authored and PM-approved.

## Design thesis

**"A hustler who knows how to relax."** Habitude should feel like a high-performance
workspace that happens to sit inside a Sedona spa. It pushes you to do the work —
but it is grounded, warm, and calm, never frantic or shaming.

The operating principle that makes this concrete:

> **Calm by default. Energy on purpose.**

The resting state of every screen is grounded and quiet — earthy greens, warm sand,
restful sky-blue, generous whitespace. The hot sunset colors (ember orange, prickly-
pear magenta) are *earned*: they ignite for moments of action and achievement —
active focus, hitting a quota, a rank-up, a capacity unlock. The app breathes calm
and rewards effort with fire. That contrast IS the brand.

This also serves the core product philosophy (`spec.md`): calm reduces the AuADHD
cognitive load; reserving intensity for achievement reinforces *process* without
the shame spiral.

---

## Color system

### The palette (Sedona Sunset)

| Token            | Hex       | Name          | Feel                          |
|------------------|-----------|---------------|-------------------------------|
| `juniper`        | `#2F483D` | Juniper       | Deep grounding green; anchor  |
| `sand`           | `#F7CE82` | Desert Sand   | Warm light neutral            |
| `mesaSky`        | `#657CAB` | Mesa Sky      | Calm dusty blue; rest/info    |
| `saguaro`        | `#687229` | Saguaro       | Olive; growth/success         |
| `ember`          | `#F7841E` | Sunset Ember  | Warm action / active focus    |
| `pricklyPear`    | `#C311A8` | Prickly Pear  | High-energy spark; achievement|

### Semantic roles

**Grounding / calm (the default 80% of the UI):**
- `juniper` — primary brand anchor. Dark surfaces, primary text on light, app bars,
  the "spa foundation."
- `sand` — warm neutral. Tint up to near-white for light backgrounds and cards; the
  desert warmth that keeps it from feeling clinical.
- `mesaSky` — rest, calm, informational states, secondary buttons, the "you can
  relax now" cues.

**Energy / action (used sparingly, on purpose):**
- `ember` — primary call-to-action and *active* states: a running focus Tracker,
  "in progress," overtime glow. This is the everyday hustle color.
- `pricklyPear` — reserved spark. Achievement-only: rank-ups, Capacity Unlocks,
  healed consistency ratios, badge unlocks. If it's on screen, something was *won*.
  Never use it for routine UI or it loses its meaning.

**Growth:**
- `saguaro` — success, positive deltas, completed quotas, healthy consistency ratios.

### Surfaces (light + dark)
- **Light mode:** warm off-white base derived from `sand` (heavily tinted, not pure
  white), `juniper` for primary text, cards a half-step warmer than the base.
- **Dark mode:** `juniper` as the deep base, `sand` for primary text, ember/prickly-
  pear accents pop harder against the dark — lean into this for focus sessions.

### Context color-coding (user-customizable)
Per `spec.md` §1, Contexts ("Deep Work," "Admin," etc.) carry user-chosen colors
that propagate through the calendar as visual energy maps.

- The user picks Context colors via a **full color wheel** (HSV picker) — not a
  fixed list. This is a required UI control.
- The six palette colors above ship as **preset swatches** beneath the wheel, so the
  fast path stays on-brand while full freedom remains available.
- Enforce a **minimum contrast** check on the chosen color against both light and
  dark surfaces, and auto-pick a readable text/foreground color for chips and
  calendar blocks. A user must never create an unreadable Context.

---

## Typography

Both families are on Google Fonts (see dependency note below).

- **Headings / display — `Fraunces`.** A warm, optical-size soft serif. It carries
  the "spa luxury" and quiet confidence — editorial, grounded, premium, with enough
  weight at the top end to feel serious rather than soft. Use heavier optical
  weights for big numbers and screen titles.
- **Body / UI — `Figtree`.** A clean, friendly geometric sans with high legibility
  at small sizes — important for an AuADHD audience and for data-dense screens
  (energy points, task lists). Warmer than Inter, calmer than a techy grotesque.
- **Data / timers — `Figtree` with tabular figures** (`fontFeatures: tabularFigures`).
  The big Tracker countdown and energy scores must use tabular numerals so digits
  don't jitter as they change. Consider a heavier weight for the live timer so it
  reads as the focal point.

Rationale for the pairing: the soft serif headings say *relax / premium / grounded*;
the clean sans body says *focused / capable / get-to-work*. The pairing itself
performs the "hustle but calm" thesis.

### Scale (starting point; Designer may refine)
- Display (screen hero / timer): Fraunces, large, heavy optical weight.
- H1 / H2: Fraunces, medium-heavy.
- Body / labels: Figtree, regular/medium.
- Caption / meta: Figtree, smaller, slightly reduced opacity (never below contrast
  minimums).

---

## Core principles (non-negotiable)

1. **Low clutter.** Whitespace is a feature, not wasted space. One primary action
   per screen. The AuADHD user should never feel visually shouted at.
2. **Calm by default, energy on purpose** (see thesis). Hot colors are earned.
3. **No shame.** Visual language for a missed day or a paused timer is neutral or
   gentle — never red alarms, never punishing. Consistency ratios show progress, not
   failure (`spec.md` §5).
4. **Motion restraint.** Animations are soft and brief — easing, fades, a gentle
   "chirp" pulse. Nothing jarring; this is a spa, not a slot machine.
5. **Accessibility.** Meet WCAG AA contrast everywhere, including user-chosen Context
   colors. Respect system text-scaling.

### Voice & tone (microcopy)
Confident and encouraging, never drill-sergeant. It nudges and celebrates; it does
not nag or scold. "Focus goal reached — overtime's yours if you want it." Not
"You're behind." The hustle is in the momentum, not in pressure.

---

## Implementation notes (Flutter)

- Centralize all tokens in `lib/shared/theme/` — a single source for colors,
  text styles, spacing. No feature defines its own raw colors or font sizes; it
  pulls from the theme. (Aligns with `AGENTS.md` §3.)
- Expose the palette as a `ThemeExtension` so semantic tokens (`ember`,
  `pricklyPear`, etc.) are available type-safely, not as scattered `Color(0xFF…)`.
- Build light and dark `ThemeData` from the same token set.

### Dependency note (requires PM sign-off — `AGENTS.md` §2)
This system uses the **`google_fonts`** package for Fraunces + Figtree. Before the
first UI sprint, the PM must record approval of `google_fonts` in `state.md`
(or the Designer/Dev must bundle the font files locally instead). A user-selectable
color wheel will also need a picker package (e.g. `flutter_colorpicker`) — same
rule: PM-approve before use.
