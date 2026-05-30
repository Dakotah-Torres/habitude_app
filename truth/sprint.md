# Sprint 6 — Timer Core

> **Status: AWAITING HUMAN APPROVAL**
> PM wrote this. Dev does not begin until the human operator approves.

**Goal:** Build the full data and logic layer for the focus timer. When this
sprint is done, the timer can be started, paused, resumed, and stopped from
pure Dart/Riverpod with no UI — and stopping it automatically persists a
`Tracker` record and a `TaskCompletion` to Firestore. The UI (TimerScreen,
foreground service, overtime) comes in Sprint 7.

**Scope:**
- `lib/features/timer/tracker.dart` (new model)
- `lib/features/timer/tracker_repository.dart` (new repository)
- `lib/features/timer/timer_state.dart` (new value object + enum)
- `lib/features/timer/timer_notifier.dart` (new Riverpod Notifier + pure helpers)
- `lib/shared/firestore_paths.dart` (add `trackers` path)

**Sprint type:** Non-UI. Loop: PM → Dev → Optimization → Security → PM closes.

**No new packages.** `shared_preferences` and `flutter_riverpod` are already
in `pubspec.yaml`.

**Design rationale — why Timer is split across two sprints:**
Sprint 6 is the state machine and persistence layer. Sprint 7 adds the
TimerScreen, `flutter_foreground_task` (Android foreground service), the
Overtime Mechanic, and the Dead-Man's Switch. Splitting keeps each sprint
testable independently: Sprint 6's logic is fully unit-testable without Flutter
widgets; Sprint 7 builds on a proven, stable foundation.

**UTC requirement (carried from Sprint 4):** Every `DateTime` created in
this sprint — `startedAt`, `stoppedAt`, `completedAt` — must use
`DateTime.now().toUtc()`.

---

### Task 1 — Tracker model + FirestorePaths update

**File:** `lib/features/timer/tracker.dart`

**Fields:**

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | |
| `taskId` | `String` | The task being focused on |
| `startedAt` | `DateTime` (UTC) | When the timer was started |
| `stoppedAt` | `DateTime?` (UTC) | null while running; set on stop |
| `durationSeconds` | `int` (≥ 0) | Actual logged focus seconds (set on stop) |
| `targetSeconds` | `int` (> 0) | Pomodoro target; default 1500 (25 min) |

**FirestorePaths update:** `lib/shared/firestore_paths.dart`
Add one static method:

| Method | Returns |
|---|---|
| `trackers(String uid)` | `"users/$uid/trackers"` |

**Acceptance criteria:**

- Given any `Tracker` instance `a`, `a.toJson()` then `Tracker.fromJson(map)`
  equals `a` (Freezed `==`).
- Given a `Tracker` with `stoppedAt: null`, roundtrip preserves `stoppedAt == null`.
- `FirestorePaths.trackers("abc123") == "users/abc123/trackers"`.
- All criteria covered by unit tests.

---

### Task 2 — TrackerRepository & Provider

**File:** `lib/features/timer/tracker_repository.dart`

**Interface:**

| Method | Return type | Behavior |
|---|---|---|
| `watchTrackers()` | `Stream<List<Tracker>>` | All trackers for the user |
| `watchTrackersByTask(String taskId)` | `Stream<List<Tracker>>` | Filtered by taskId |
| `addTracker(Tracker t)` | `Future<void>` | Writes to `trackers/{t.id}` |
| `updateTracker(Tracker t)` | `Future<void>` | Overwrites `trackers/{t.id}` |

Note: No delete method. Tracker records are permanent history.

**Providers:**
- `trackerRepositoryProvider` — provides `TrackerRepository`
- `trackersStreamProvider` — `StreamProvider<List<Tracker>>`

**Acceptance criteria** (tests use `fake_cloud_firestore`):

- Given empty collection, `watchTrackers()` emits empty list.
- Given `addTracker(t)`, next `watchTrackers()` snapshot contains `t`.
- Given `addTracker(t)` then `updateTracker(t.copyWith(stoppedAt: now))`,
  next snapshot has `stoppedAt` set.
- Given two trackers with different `taskId`, `watchTrackersByTask(id1)` returns
  only the matching one.
- No raw Firestore calls outside `TrackerRepository`.

---

### Task 3 — TimerState value object

**File:** `lib/features/timer/timer_state.dart`

**Status enum:**

```dart
enum TimerStatus { idle, running, paused }
```

**TimerState** (Freezed, but NOT JSON-serialized — it is ephemeral in-process
state, not persisted to Firestore):

| Field | Type | Notes |
|---|---|---|
| `status` | `TimerStatus` | Current timer status |
| `taskId` | `String?` | null when idle |
| `trackerId` | `String?` | null when idle |
| `energyScore` | `int` | Snapshot of task energy; 0 when idle |
| `targetSeconds` | `int` | Pomodoro target; 1500 default |
| `elapsedSeconds` | `int` | Seconds elapsed so far |
| `startedAt` | `DateTime?` (UTC) | null when idle |

**Default (idle) state:**
```dart
TimerState(
  status: TimerStatus.idle,
  targetSeconds: 1500,
  elapsedSeconds: 0,
)
```

**Acceptance criteria:**

- Default state has `status == idle`, `elapsedSeconds == 0`, `taskId == null`.
- Freezed equality: two `TimerState` instances with identical fields are `==`.
- Unit tests for both criteria.

---

### Task 4 — TimerNotifier + pure helpers

**File:** `lib/features/timer/timer_notifier.dart`

**Pure helper functions** (pure Dart, no imports beyond `dart:core` and
`timer_state.dart`; place in the same file or a co-located `timer_math.dart`):

```dart
// Seconds elapsed from startedAt to now. Always >= 0.
int computeElapsed(DateTime startedAt, DateTime now);

// True if elapsed >= target (timer complete).
bool isComplete(int elapsedSeconds, int targetSeconds);
```

**TimerNotifier** (`Notifier<TimerState>` via `@riverpod`):

| Method | Parameters | Behavior |
|---|---|---|
| `startTimer` | `taskId, energyScore, {targetSeconds = 1500}` | Creates a `Tracker` in `TrackerRepository` (startedAt = now.toUtc(), stoppedAt null, durationSeconds 0). Saves `taskId`, `trackerId`, `energyScore`, `targetSeconds`, and `startedAt.toIso8601String()` to `shared_preferences`. Starts a `Timer.periodic(1 second)` that calls `_tick()`. State → running. |
| `pauseTimer` | — | Cancels the periodic timer. Saves current `elapsedSeconds` to `shared_preferences` (key `timer_elapsed`). State → paused. |
| `resumeTimer` | — | Reads `elapsedSeconds` from `shared_preferences`. Restarts `Timer.periodic`. State → running. |
| `stopTimer` | — | Cancels the periodic timer. Updates the `Tracker` via `TrackerRepository.updateTracker()` (stoppedAt = now.toUtc(), durationSeconds = elapsedSeconds). Creates a `TaskCompletion` via `TaskCompletionRepository.addCompletion()` (completedAt = now.toUtc(), energyScore = state.energyScore). Clears all timer keys from `shared_preferences`. State → idle. |
| `reconcile` | — | Called on notifier build. Reads `shared_preferences` for in-progress timer. If found, computes elapsed using `computeElapsed(startedAt, now)` and restores state to running; restarts `Timer.periodic`. If nothing found, state stays idle. |

**`_tick()` (private):** increments `elapsedSeconds` by 1. Does NOT auto-stop
at target — the UI (Sprint 7) will observe `isComplete()` and offer the
overtime transition. The notifier ticks indefinitely until `stopTimer()` or
`pauseTimer()` is called.

**shared_preferences keys** (constants in the file):
```dart
const _kTaskId     = 'timer_task_id';
const _kTrackerId  = 'timer_tracker_id';
const _kEnergyScore = 'timer_energy_score';
const _kTargetSecs = 'timer_target_secs';
const _kStartedAt  = 'timer_started_at';   // ISO 8601 UTC string
const _kElapsed    = 'timer_elapsed';       // int, written on pause
```

**Providers:**
- `timerNotifierProvider` — `NotifierProvider<TimerNotifier, TimerState>`

**Acceptance criteria** (tests use `ProviderContainer` with overridden
`trackerRepositoryProvider`, `taskCompletionRepositoryProvider`, and a fake
`SharedPreferences`):

- Given `startTimer(taskId: 'task1', energyScore: 30)`, state becomes running
  with `taskId == 'task1'` and `elapsedSeconds == 0`.
- Given `startTimer(...)` then `stopTimer()`, state becomes idle, a `Tracker`
  with non-null `stoppedAt` exists in the fake TrackerRepository, and a
  `TaskCompletion` with `energyScore == 30` and non-null UTC `completedAt`
  exists in the fake TaskCompletionRepository.
- Given `startTimer(...)` then `pauseTimer()`, state is paused; calling
  `resumeTimer()` brings state back to running.
- `computeElapsed(startedAt, now)` where `now - startedAt == 90 seconds` returns 90.
- `computeElapsed` returns 0 when `now <= startedAt` (no negative elapsed).
- `isComplete(1500, 1500)` returns true. `isComplete(1499, 1500)` returns false.
- Given `shared_preferences` seeded with a valid in-progress timer (taskId,
  trackerId, startedAt = 60 seconds ago), `reconcile()` restores state to
  running with `elapsedSeconds == 60`.
- All criteria covered by unit tests.

**Note on Timer.periodic in tests:** Do not advance the clock in tests — only
test the start/stop/pause/resume state transitions and repository side-effects
directly. The periodic tick math (`computeElapsed`) is tested via the pure
helper functions.

---

## Out of scope for Sprint 6

- TimerScreen (any UI) — Sprint 7
- `flutter_foreground_task` Android foreground service — Sprint 7
- Overtime Mechanic and Dead-Man's Switch — Sprint 7
- `flutter_local_notifications` integration — Sprint 7
- Task-level `targetSeconds` customisation (all timers default to 1500 s)

---

## Approval

- [ ] Human operator approved this sprint scope.
