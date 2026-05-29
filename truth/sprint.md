# Sprint 4 — Task Completion Tracking + Energy Budgeting Engine

> **Status: AWAITING HUMAN APPROVAL**
> PM wrote this. Dev does not begin until the human operator approves.

**Goal:** Build the data primitive for recording task completions, then implement
the Energy Budgeting Engine as a pure, fully-tested logic layer. This is the
core differentiator of Habitude — cognitive capacity management instead of time
management. No UI required this sprint.

**Scope:**
- `lib/features/energy/task_completion.dart` (new model)
- `lib/features/energy/task_completion_repository.dart` (new repository)
- `lib/features/energy/energy_engine.dart` (new pure logic)
- `lib/features/energy/energy_service.dart` (new Riverpod provider)
- `lib/shared/firestore_paths.dart` (add `taskCompletions` path)

**Sprint type:** Non-UI. Loop: PM → Dev → Optimization → Security → PM closes.

**No new packages.** All dependencies already in `pubspec.yaml`.

**Design note — why TaskCompletion is a separate model (not a field on Task):**
A recurring `Task` can be completed many times (weekly quota). A one-time `Task`
can be un-completed (undo). The energy baseline needs a dated, immutable record
per completion event. Adding `completedAt` to `Task` handles only the last
completion and loses history. A flat `task_completions` collection with one
document per completion event is the correct data shape.

**Design note — energy tax and capacity warning are out of scope this sprint:**
The spec's Energy Tax (deducting fixed events) and Capacity Warning (checking
scheduled task load) both depend on the Calendar feature (Sprint 12). Implementing
them now would require stub models with no real backing. Deferred deliberately.

---

### Task 1 — TaskCompletion model + FirestorePaths update

**File:** `lib/features/energy/task_completion.dart`

**Fields:**

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | |
| `taskId` | `String` | References the parent Task |
| `energyScore` | `int` (≥ 0) | Snapshot of the task's energy at completion time |
| `completedAt` | `DateTime` (UTC) | When the completion occurred |

**FirestorePaths update:** `lib/shared/firestore_paths.dart`
Add one static method:

| Method | Returns |
|---|---|
| `taskCompletions(String uid)` | `"users/$uid/task_completions"` |

**Acceptance criteria:**

- Given any `TaskCompletion` instance `a`, `a.toJson()` then
  `TaskCompletion.fromJson(map)` equals `a` (Freezed `==`).
- Given two `TaskCompletion` instances with identical fields, `a == b` is true.
- `FirestorePaths.taskCompletions("abc123") == "users/abc123/task_completions"`.
- All criteria covered by unit tests.

---

### Task 2 — TaskCompletionRepository & Provider

**File:** `lib/features/energy/task_completion_repository.dart`

**`TaskCompletionRepository` interface:**

| Method | Return type | Behavior |
|---|---|---|
| `watchCompletions()` | `Stream<List<TaskCompletion>>` | Real-time stream, all completions for the user |
| `watchCompletionsSince(DateTime since)` | `Stream<List<TaskCompletion>>` | Stream filtered to `completedAt >= since` |
| `addCompletion(TaskCompletion c)` | `Future<void>` | Writes to `task_completions/{c.id}` |
| `deleteCompletion(String id)` | `Future<void>` | Deletes `task_completions/{id}` (supports undo) |

**Providers** (using `riverpod_annotation` / `@riverpod`):
- `taskCompletionRepositoryProvider` — provides `TaskCompletionRepository`
- `taskCompletionsStreamProvider` — `StreamProvider<List<TaskCompletion>>`
  consuming `watchCompletions()`

**Acceptance criteria** (tests use `fake_cloud_firestore`):

- Given an empty collection, `watchCompletions()` emits an empty list (no error).
- Given `addCompletion(c)`, the next `watchCompletions()` snapshot contains `c`
  (full Freezed equality).
- Given `addCompletion(c)` then `deleteCompletion(c.id)`, the next snapshot is empty.
- Given `addCompletion(cOld)` where `cOld.completedAt = T - 8 days` and
  `addCompletion(cNew)` where `cNew.completedAt = T - 3 days`, when
  `watchCompletionsSince(T - 7 days)` emits, the result contains only `cNew`.
- `taskCompletionsStreamProvider` tested with `ProviderContainer`: stream emits
  expected values.
- No raw Firestore calls outside `TaskCompletionRepository`.

---

### Task 3 — EnergyEngine pure functions

**File:** `lib/features/energy/energy_engine.dart`

A pure Dart file — **no Flutter imports, no Riverpod, no Firestore.** Only
`dart:core` and the `TaskCompletion` model.

**Functions:**

```dart
// Returns the sum of energyScore for all completions whose completedAt
// falls on the same UTC calendar date as `day`.
int dailyPoints(List<TaskCompletion> completions, DateTime day);

// Returns the rolling 7-day average of daily points.
// `history` should contain completions for exactly the 7 UTC calendar days
// ending today (inclusive) — the caller is responsible for this window.
// - If history spans fewer than 7 distinct days with any completions,
//   average only the days that have at least one completion.
// - If history is empty, return defaultBaseline.
int energyBaseline(
  List<TaskCompletion> history, {
  int defaultBaseline = 80,
});
```

**Acceptance criteria** (pure Dart unit tests — no Flutter test runner needed):

- Given 7 days, each with completions totalling 100 pts, `energyBaseline` returns 100.
- Given 3 days with completions totalling 80, 100, and 60 pts (in any order),
  `energyBaseline` returns 80 (average of three days: (80+100+60)/3 = 80).
- Given an empty list, `energyBaseline` returns `defaultBaseline` (80 by default).
- Given `defaultBaseline: 60` passed explicitly, empty list returns 60.
- Given completions on day D and day D+1, `dailyPoints(completions, D)` returns
  only the sum for day D (day D+1 completions are excluded).
- Given two completions on the same day with scores 30 and 50,
  `dailyPoints` returns 80.
- Given a `TaskCompletion` with `completedAt` at 23:59 UTC on day D and another
  at 00:01 UTC on day D+1, `dailyPoints(completions, D)` returns only the first
  score (UTC date boundary is respected).

---

### Task 4 — EnergyService provider

**File:** `lib/features/energy/energy_service.dart`

**Provider:**

```dart
@riverpod
Stream<int> energyBaseline(Ref ref);
```

Behavior:
1. Watches `taskCompletionsStreamProvider` (live Firestore stream of all completions).
2. Filters the emitted list to completions whose `completedAt` is within the last
   7 UTC calendar days (today inclusive). Uses `DateTime.now().toUtc()` for "today."
3. Passes the filtered list to `EnergyEngine.energyBaseline()`.
4. Emits the resulting `int`.

**Acceptance criteria** (tests use `ProviderContainer` + overridden providers):

- Given `taskCompletionsStreamProvider` overridden to emit a list with 7 days of
  100-pt completions, `energyBaselineProvider` emits 100.
- Given the override emitting an empty list, `energyBaselineProvider` emits 80
  (the default baseline).
- Given the override emitting 3 days of data (80, 90, 100 pts), `energyBaselineProvider`
  emits 90 (average: (80+90+100)/3 = 90).
- Given the override emitting a mix of completions where some are older than 7 days,
  `energyBaselineProvider` excludes the old ones from the average.

---

## Out of scope for Sprint 4

- Energy tax (fixed event deductions) — deferred to Calendar sprint
- Capacity warning UI — deferred to Calendar sprint
- Task completion UI (marking a task done from a screen) — deferred to Goals UI sprint
- `weeklyQuota` reset logic and rolling consistency ratios — Gamification sprint
- Any screen or widget

---

## Approval

- [x] Human operator approved this sprint scope. (2026-05-29)
