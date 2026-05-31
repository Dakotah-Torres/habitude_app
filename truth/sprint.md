# Sprint 8 — Brain Dump + Morning Triage Funnel

> **Status: AWAITING HUMAN APPROVAL**
> PM wrote this. Dev does not begin until the human operator approves.

**Goal:** Build the frictionless capture and daily decision-clearing workflow.
When this sprint is done, users can dump unstructured thoughts into an inbox at
any time and then clear their head each morning with a fast swipe-based triage
that surfaces brain dump items and pending recurring tasks.

**Scope:**
- `lib/features/triage/brain_dump_item.dart` (new model)
- `lib/features/triage/brain_dump_repository.dart` (new repository)
- `lib/features/triage/triage_service.dart` (new pure logic)
- `lib/features/triage/screens/brain_dump_screen.dart` (new screen)
- `lib/features/triage/screens/triage_funnel_screen.dart` (new screen)
- `lib/shared/firestore_paths.dart` (add `brainDumpItems` path)
- `truth/design.md` (Designer appends Sprint 8 spec)

**Sprint type: UI.**
Loop: PM → Designer (pre-spec) → Dev → Designer (UI review) → Optimization → Security → PM closes.

**No new packages.** All dependencies already in `pubspec.yaml`.

**Design note — "Schedule" without a Calendar:**
The spec defines "Schedule" as dropping an item onto the daily calendar. The
Calendar is Sprint 11. For Sprint 8, the "Schedule" action marks the brain dump
item as `scheduledForDate = today (UTC)` and removes it from the triage queue.
When the Calendar is built in Sprint 11, scheduled items will surface there.
This is an intentional MVP compromise — do not build a calendar picker here.

**Design note — Voice-to-Text OS Hook:**
Exposing intents to Siri/Google Assistant requires platform-native App Extensions
and significant platform config. Deferred to production hardening (Sprint 15).

---

## Phase A — Designer pre-spec

**Addressee: Designer**

Append a "Sprint 8 visual spec — Brain Dump + Triage" section to `truth/design.md`.

### Surfaces to spec

| Surface | Description |
|---|---|
| `BrainDumpScreen` | Inbox list — view + add + delete brain dump items; entry point to triage |
| `TriageFunnelScreen` | One-card-at-a-time swipe interface (Brain Dump items + pending recurring tasks) |
| Navigation entry point | How the user reaches BrainDumpScreen from the app (e.g., bottom nav, FAB, app bar action on GoalsListScreen) |

### What the spec must include (per surface)

**BrainDumpScreen:**
- Layout: list of brain dump items (text + relative timestamp), text-input area
  to capture a new item, and a "Start Triage" button/FAB.
- Empty state: what the screen shows when the inbox is empty.
- Item actions: how an item is deleted (swipe, overflow, etc.) with confirmation
  or undo affordance consistent with core philosophy (forgiveness over destruction).
- "Start Triage" affordance: disabled/hidden when there are no items to triage
  (brain dump empty AND no pending recurring tasks), or always visible?

**TriageFunnelScreen:**
- Layout: one card at a time, filling most of the screen.
- Card content: for a brain dump item — the text; for a recurring task — title,
  energy score, weekly quota progress (e.g. "1 of 3 this week").
- Three actions and their gestures/buttons:
  - **Do Today** (formerly "Schedule") — right swipe or right button
  - **Tomorrow** (Backlog) — left swipe or left button
  - **Remove** — downward swipe or explicit button/icon
- Visual swipe indicators: hint to the user which direction maps to which action.
- Completion state: all cards processed — calm "All caught up!" confirmation.
- Tone: non-shaming. Backlogging is not failure. Removing is not failure.

**Navigation entry point:**
- Where in the existing app structure does the user reach BrainDumpScreen?
  Spec a concrete navigation location (e.g., persistent bottom nav bar added to
  GoalsListScreen, or an icon in the GoalsListScreen app bar).
  If a bottom navigation bar is introduced, spec the tab structure.

### Design constraints
- Sedona Sunset palette, Material 3 base.
- Core philosophy: triage is about reducing decision friction, not adding it.
  Cards should be large and tap targets generous.
- Triage must work in under a minute for a typical 5-item inbox.
- Swipe indicators must be clear before the user commits — directional hints
  visible from the resting card state.

---

## Phase B — Dev build

**Addressee: Dev** (after Designer hands off)

### Task 1 — BrainDumpItem model + FirestorePaths update

**File:** `lib/features/triage/brain_dump_item.dart`

**Fields:**

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | |
| `text` | `String` | The raw captured thought |
| `createdAt` | `DateTime` (UTC) | |
| `backloggedUntil` | `DateTime?` (UTC date, time zeroed) | null = not backlogged; set = snoozed until this date |
| `scheduledForDate` | `DateTime?` (UTC date, time zeroed) | null = unscheduled; set = scheduled for calendar |

**FirestorePaths update:**
Add `brainDumpItems(String uid)` → `"users/$uid/brain_dump_items"`.

**Acceptance criteria:**
- JSON roundtrip preserves all fields including null optionals.
- `FirestorePaths.brainDumpItems("abc123") == "users/abc123/brain_dump_items"`.
- Unit tests cover both.

---

### Task 2 — BrainDumpRepository & Provider

**File:** `lib/features/triage/brain_dump_repository.dart`

**Interface:**

| Method | Return | Behavior |
|---|---|---|
| `watchAllItems()` | `Stream<List<BrainDumpItem>>` | All items, ordered by createdAt desc |
| `watchActiveItems(DateTime today)` | `Stream<List<BrainDumpItem>>` | Items where `scheduledForDate == null` AND (`backloggedUntil == null` OR `backloggedUntil` day ≤ `today` day) |
| `addItem(BrainDumpItem item)` | `Future<void>` | |
| `updateItem(BrainDumpItem item)` | `Future<void>` | Used for backlog/schedule actions |
| `deleteItem(String id)` | `Future<void>` | Used for Remove action |

**Providers:**
- `brainDumpRepositoryProvider`
- `brainDumpActiveItemsProvider` — `StreamProvider<List<BrainDumpItem>>` consuming
  `watchActiveItems(DateTime.now().toUtc())` — items available in today's triage.

**Acceptance criteria** (tests use `fake_cloud_firestore`):
- Given empty collection, `watchActiveItems` emits empty list.
- Given item with `backloggedUntil = yesterday`, it appears in `watchActiveItems(today)`.
- Given item with `backloggedUntil = tomorrow`, it does NOT appear in `watchActiveItems(today)`.
- Given item with `scheduledForDate = today`, it does NOT appear in `watchActiveItems(today)`.
- Given `deleteItem(id)`, next `watchAllItems()` does not contain that item.
- No raw Firestore calls outside repository.

---

### Task 3 — TriageService pure logic

**File:** `lib/features/triage/triage_service.dart`

Pure Dart file — no Flutter, Riverpod, or Firestore imports.

**Functions:**

```dart
// Returns brain dump items eligible for today's triage:
// scheduledForDate is null AND (backloggedUntil is null OR
// backloggedUntil UTC calendar date <= today UTC calendar date).
List<BrainDumpItem> todaysBrainDumpItems(
  List<BrainDumpItem> items,
  DateTime today,
);

// Returns recurring tasks that have not yet met their weeklyQuota
// in the ISO calendar week containing `today` (Monday–Sunday UTC).
// A task is "pending" if:
//   completionsThisWeek(task.id, completions, today) < task.weeklyQuota!
// Only tasks with taskType == recurring and weeklyQuota != null are considered.
List<Task> pendingRecurringTasks(
  List<Task> tasks,
  List<TaskCompletion> completions,
  DateTime today,
);

// Helper: count completions for a given taskId whose completedAt falls
// in the same ISO week as today.
int completionsThisWeek(
  String taskId,
  List<TaskCompletion> completions,
  DateTime today,
);
```

**ISO week definition:** Monday 00:00:00 UTC through Sunday 23:59:59 UTC of the
week containing `today`.

**Acceptance criteria** (pure Dart unit tests):
- `todaysBrainDumpItems`: item with null backloggedUntil and null scheduledForDate
  appears; item with scheduledForDate set does not appear; item backlogged until
  tomorrow does not appear; item backlogged until yesterday appears.
- `pendingRecurringTasks`: task with `weeklyQuota: 3` and 2 completions this week
  appears; same task with 3 completions does not appear; one-time task never appears.
- `completionsThisWeek`: completions on Monday and Sunday of same week are counted;
  completion on previous Sunday is not counted.
- Edge: today is Monday — previous Sunday's completion is NOT in the same week.

---

### Task 4 — BrainDumpScreen

**File:** `lib/features/triage/screens/brain_dump_screen.dart`

Built per the Designer's spec. Uses `brainDumpRepositoryProvider`.

**Acceptance criteria:**
- Widget test: 3 active items → 3 items rendered.
- Widget test: empty inbox → empty state visible.
- Widget test: submit non-empty text → `addItem` called; text field clears.
- Widget test: submit empty text → `addItem` NOT called.
- Widget test: delete action (per Designer's spec) → `deleteItem` called after
  confirmation (if spec requires it) or immediately (if not).
- "Start Triage" tap → navigates to `TriageFunnelScreen`.
- No raw Firestore calls.

---

### Task 5 — TriageFunnelScreen

**File:** `lib/features/triage/screens/triage_funnel_screen.dart`

Built per the Designer's spec. Takes a combined list of `BrainDumpItem` and
pending recurring `Task` items as its input (passed from the caller or read
via providers using `TriageService`).

Actions per card:
- **Do Today** → if `BrainDumpItem`: call `updateItem` with `scheduledForDate = today.toUtc()`. If `Task`: create a `TaskCompletion` (with `completedAt = DateTime.now().toUtc()`, `energyScore = task.energyScore`). Advance to next card.
- **Tomorrow** → if `BrainDumpItem`: call `updateItem` with `backloggedUntil = tomorrow.toUtc()`. If `Task`: no-op (task re-appears tomorrow naturally). Advance to next card.
- **Remove** → if `BrainDumpItem`: call `deleteItem`. If `Task`: no-op (recurring tasks cannot be deleted from triage). Advance to next card.

**Acceptance criteria:**
- Widget test: 2 cards → both rendered sequentially; after swiping/actioning both,
  completion state ("All caught up!") appears.
- Widget test: "Do Today" on a BrainDumpItem card → `updateItem` called with
  non-null `scheduledForDate`.
- Widget test: "Tomorrow" on a BrainDumpItem card → `updateItem` called with
  non-null `backloggedUntil` = tomorrow.
- Widget test: "Remove" on a BrainDumpItem card → `deleteItem` called.
- Widget test: "Do Today" on a recurring Task card → `addCompletion` called with
  correct `taskId` and UTC `completedAt`.
- No raw Firestore calls.

---

## Out of scope for Sprint 8

- Voice-to-text OS hook (Siri/Google Assistant intents) — Sprint 15
- Calendar-based scheduling (drag onto calendar) — Sprint 11
- "Schedule to a specific goal/project" picker — deferred
- Triage notifications / daily reminder to triage — deferred

---

## Approval

- [x] Human operator approved this sprint scope. (2026-05-31)
