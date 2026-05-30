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

---

## Sprint 5 visual spec — Goals hierarchy UI

Sprint 5 builds the first real app surface: Goals -> Projects -> Tasks. Keep the
experience quiet, scannable, and forgiving. Use Material 3 components and the
existing theme/tokens; do not add packages for fonts, routing, icons, or date
pickers unless PM records sign-off in `truth/state.md`.

### Shared screen structure

- Use `Scaffold` with a calm light background derived from the app surface color.
  App bars are simple and flat, with `juniper`-weighted title treatment and no
  decorative gradients.
- Each list/detail screen uses one primary action: a FAB for create actions. The
  FAB uses the primary/action color (`ember` when tokenized; otherwise
  `Theme.of(context).colorScheme.primary`) and a `+`/add icon.
- Content width is full on phones with 16 px horizontal padding. On wide screens,
  constrain primary content to a readable max width around 720 px and center it.
- Use cards only for repeated list rows or form groups. Cards should be low
  elevation or elevation 0 with a visible outline/tinted surface. Radius should be
  modest, 8 px.
- Loading states use centered `CircularProgressIndicator` plus a short neutral
  label: "Loading goals", "Loading projects", or "Loading tasks". No skeleton
  shimmer this sprint.
- Error states use an inline calm error panel with title "Something did not load",
  the error text in smaller body copy when available, and a retry affordance only
  if the provider can be invalidated locally. Do not crash or show raw stack traces.
- Empty states are supportive, not shaming. Use simple centered content with an
  icon, a short title, one sentence, and the same create action as the FAB.
- Destructive actions always require confirmation in an `AlertDialog`. The dialog
  must name the item being deleted, explain that this removes the item from this
  hierarchy level, and provide `Cancel` plus a clearly labeled destructive action
  (`Delete goal`, `Delete project`, `Delete task`). No single-tap delete.
- Prefer trailing overflow menus (`PopupMenuButton`) for edit/delete on cards and
  details. Long-press can open the same menu or confirmation, but must not be the
  only way to act.
- Avoid shame-coded red for ordinary deletion confirmation. If Material error color
  is used for the final delete button, keep the rest of the dialog neutral.
- All text must respect system text scaling and wrap before overflow. Titles in
  lists are max 2 lines with ellipsis; detail headers can wrap to 3 lines.

### Shared visual language

- Goal type chips:
  - `continuous`: calm growth chip, label "Continuous", saguaro-tinted container.
  - `finite`: structured milestone chip, label "Finite", mesaSky-tinted container.
- Project status badges must be visually distinct:
  - `active`: ember-tinted badge, label "Active". This is the only routine status
    allowed to use action energy because it indicates current momentum.
  - `completed`: saguaro-tinted badge, label "Completed".
  - `archived`: neutral/mesaSky-muted badge, label "Archived".
- Task type chips:
  - `oneTime`: label "One-time".
  - `recurring`: label "Recurring".
- Energy score display:
  - Show as a compact effort indicator: icon or prefix plus "`N` energy".
  - Higher means harder, not worse. Use neutral copy such as "40 energy", never
    "cost", "penalty", or "too much".
  - Use tabular figures when a theme style exists for numeric data.
- Dates:
  - `createdAt` is not shown in Sprint 5 unless needed for debugging; keep UI
    focused on user-authored titles and hierarchy.
  - Project `dueDate` displays as "Due MMM d" when present and is omitted when null.
  - Date input can use Flutter's built-in `showDatePicker`; no date picker package.
- Forms:
  - Put primary form content in a single column with 16 px gaps.
  - Save button is the primary filled action. Cancel is a text button.
  - Validation copy is direct and gentle: "Add a title to save this goal."
  - Disable or show progress on Save while writes are in flight to prevent duplicate
    submissions.

### `GoalsListScreen` (`/goals`, root/home)

**Layout**
- `Scaffold` with app bar title "Habitude".
- Body is an `AsyncValue` view of `goalsStreamProvider`.
- When data exists, show a `ListView.separated` of goal cards. Each card has the
  goal title, a goal type chip, and a trailing chevron. Cards are tappable.
- FAB in lower-right creates a new goal.

**Data shown**
- `Goal.title`: primary text, max 2 lines, ellipsis in lists.
- `Goal.type`: chip using shared goal type styling.
- Do not show goal IDs or raw timestamps.

**User actions**
- Tap goal card: open `GoalDetailScreen`.
- Tap FAB or empty-state action: open `GoalFormScreen` in create mode.
- Optional trailing overflow may expose Edit/Delete once Dev has the form wired,
  but primary Sprint 5 delete requirement is on detail.

**Empty state**
- Title: "Start with one goal."
- Body: "Name the direction you want your effort to point."
- Action: "Add goal" opens create form.

**Loading state**
- Centered progress indicator with "Loading goals".

**Error state**
- Calm error panel: "Something did not load" and "Your goals are still safe. Try
  again in a moment." Include technical error text only as small secondary text.

**Navigation**
- FAB/empty action -> `GoalFormScreen(create)`.
- Goal tap -> `GoalDetailScreen(goal)`.

### `GoalFormScreen` (`/goals/new`, `/goals/:id/edit`)

**Layout**
- App bar title is "New goal" in create mode and "Edit goal" in edit mode.
- Body is a single form column: title field, type segmented control/radio group,
  bottom action row.
- Use `TextFormField` for title and `SegmentedButton<GoalType>` or accessible
  radio tiles for type.

**Data shown**
- Create mode starts with empty title and default `GoalType.continuous`.
- Edit mode pre-populates `Goal.title` and `Goal.type`.
- Type labels: "Continuous" and "Finite". Optional helper text may explain:
  "Continuous supports ongoing effort" and "Finite has a finish line."

**User actions**
- Save validates title is non-empty after trim, then calls add/update.
- Cancel pops without saving.
- System back behaves like Cancel if there are no submitted writes.

**Empty state**
- Not applicable; this is a form.

**Loading state**
- During save, keep form visible, disable fields/actions, and show progress in the
  Save button area.

**Error state**
- Field validation: "Add a title to save this goal."
- Save failure: inline message above actions, "Goal was not saved. Nothing was
  lost; try again."

**Navigation**
- Successful save -> `Navigator.pop`.
- Cancel/back -> `Navigator.pop`.

### `GoalDetailScreen` (`/goals/:id`)

**Layout**
- App bar title can be "Goal" with edit/delete overflow menu.
- Header area shows goal title and type chip.
- Below header, section title "Projects" and an `AsyncValue` list from
  `watchProjectsByGoal(goal.id)`.
- Project cards use title, status badge, optional due date, and trailing chevron.
- FAB creates a project inside this goal.

**Data shown**
- `Goal.title`: prominent header, wraps up to 3 lines.
- `Goal.type`: shared chip.
- Each `Project.title`: primary list text, max 2 lines.
- Each `Project.status`: shared status badge.
- `Project.dueDate`: small secondary text "Due MMM d" when non-null.

**User actions**
- App bar Edit: open `GoalFormScreen(edit)`.
- App bar Delete: open confirmation dialog; confirm calls
  `goalsRepository.deleteGoal(goal.id)` and pops back to goals list.
- Tap project card: open `ProjectDetailScreen`.
- Project overflow Edit: open `ProjectFormScreen(edit)`.
- Project overflow Delete: confirmation dialog; confirm calls
  `projectsRepository.deleteProject(project.id)`. This is optional for Sprint 5
  if deletion is implemented only on project detail, but never single-tap.
- FAB/empty action: open `ProjectFormScreen(create, goalId: goal.id)`.

**Empty state**
- Title: "No projects yet."
- Body: "Break this goal into a first clear project when you are ready."
- Action: "Add project".

**Loading state**
- Header remains visible. Project area shows centered progress with
  "Loading projects".

**Error state**
- Project area shows calm error panel. Goal header remains visible.

**Navigation**
- Edit goal -> `GoalFormScreen(edit)`.
- Delete confirmed -> pop to `GoalsListScreen`.
- Add project -> `ProjectFormScreen(create)`.
- Project tap -> `ProjectDetailScreen(project)`.

### `ProjectFormScreen` (`/goals/:id/projects/new`, `/projects/:id/edit`)

**Layout**
- App bar title is "New project" or "Edit project".
- Form column: title field, status selector, optional due date row, actions.
- Status selector should be `SegmentedButton<ProjectStatus>` where width allows;
  otherwise use radio tiles so labels do not squeeze.
- Due date row shows "No due date" or formatted date plus buttons to choose/clear.

**Data shown**
- Create mode starts with empty title, `ProjectStatus.active`, and no due date.
- Edit mode pre-populates `Project.title`, `Project.status`, and `Project.dueDate`.
- Status uses the same labels/colors as project badges.

**User actions**
- Save validates non-empty title, then calls add/update.
- Choose due date opens Flutter `showDatePicker`.
- Clear due date sets `dueDate` to null.
- Cancel pops without saving.

**Empty state**
- Not applicable; this is a form.

**Loading state**
- During save, disable form/actions and show Save progress.

**Error state**
- Title validation: "Add a title to save this project."
- Save failure: inline message, "Project was not saved. Nothing was lost; try
  again."

**Navigation**
- Successful save -> `Navigator.pop`.
- Cancel/back -> `Navigator.pop`.

### `ProjectDetailScreen` (`/projects/:id`)

**Layout**
- App bar title can be "Project" with edit/delete overflow menu.
- Header shows project title, status badge, optional due date.
- Below header, section title "Tasks" and an `AsyncValue` list from
  `watchTasksByParent(project.id)`.
- Task cards show title, energy indicator, task type chip, optional weekly quota
  for recurring tasks, and trailing edit affordance or chevron.
- FAB creates a task inside this project.

**Data shown**
- `Project.title`: prominent header.
- `Project.status`: shared status badge.
- `Project.dueDate`: "Due MMM d" when present.
- `Task.title`: primary list text, max 2 lines.
- `Task.energyScore`: compact "`N` energy" indicator.
- `Task.taskType`: shared task type chip.
- `Task.weeklyQuota`: for recurring tasks only, secondary text like
  "`N`/week target"; hidden for one-time tasks and when null.

**User actions**
- App bar Edit: open `ProjectFormScreen(edit)`.
- App bar Delete: confirmation dialog; confirm calls
  `projectsRepository.deleteProject(project.id)` and pops to goal detail.
- Tap task card or card Edit: open `TaskFormScreen(edit)`.
- Task overflow Delete: confirmation dialog; confirm calls
  `tasksRepository.deleteTask(task.id)`.
- FAB/empty action: open `TaskFormScreen(create, parentId: project.id,
  parentType: ParentType.project)`.

**Empty state**
- Title: "No tasks yet."
- Body: "Add one next action. Small counts."
- Action: "Add task".

**Loading state**
- Header remains visible. Task area shows centered progress with "Loading tasks".

**Error state**
- Task area shows calm error panel. Project header remains visible.

**Navigation**
- Edit project -> `ProjectFormScreen(edit)`.
- Delete confirmed -> pop to the parent goal detail.
- Add task -> `TaskFormScreen(create)`.
- Task tap/edit -> `TaskFormScreen(edit)`.

### `TaskFormScreen` (`/projects/:id/tasks/new`, `/tasks/:id/edit`)

**Layout**
- App bar title is "New task" or "Edit task".
- Form column: title field, energy score numeric input, task type selector,
  conditional weekly quota numeric input, actions.
- Energy score input should be a numeric `TextFormField` with helper text:
  "Higher means this asks for more effort."
- Task type selector should be a segmented control or radio group with "One-time"
  and "Recurring".

**Data shown**
- Create mode starts with empty title, energy score default 0 or a low neutral
  default if Dev/PM has already defined one, `TaskType.oneTime`, and no weekly
  quota.
- Edit mode pre-populates all fields from `Task`.
- `weeklyQuota` field is visible and required only for `TaskType.recurring`.
- `weeklyQuota` is hidden and saved as null for `TaskType.oneTime`.

**User actions**
- Save validates title is non-empty, energy score is an integer >= 0, and recurring
  weekly quota is an integer > 0.
- Save calls add/update on `tasksRepository`.
- Cancel pops without saving.
- No task completion action is designed for this sprint. If Dev discovers an
  unavoidable `TaskCompletion` creation call site, `completedAt` must use
  `DateTime.now().toUtc()`.

**Empty state**
- Not applicable; this is a form.

**Loading state**
- During save, disable form/actions and show Save progress.

**Error state**
- Title validation: "Add a title to save this task."
- Energy validation: "Energy must be zero or more."
- Weekly quota validation: "Add a weekly target for recurring tasks."
- Save failure: inline message, "Task was not saved. Nothing was lost; try again."

**Navigation**
- Successful save -> `Navigator.pop`.
- Cancel/back -> `Navigator.pop`.

### Sprint 5 implementation notes for Dev

- `GoalsListScreen` becomes `home:` in `MaterialApp`.
- Use built-in `Navigator.push` / `Navigator.pop`; no routing package.
- Use existing Riverpod providers and repositories only. Screens/widgets must not
  make raw Firestore calls.
- Keep generated IDs and `createdAt` construction in UI code minimal and consistent
  with existing repository tests. Use UTC for created timestamps where the model
  stores a new `DateTime`.
- This sprint is out of scope for marking tasks complete and writing
  `TaskCompletion` records. If a completion record is introduced despite that, its
  `completedAt` must be `DateTime.now().toUtc()`.
- If `google_fonts` has not been PM-approved by implementation time, use the
  current Material 3 text theme and map hierarchy through `TextTheme` styles rather
  than adding the package.
