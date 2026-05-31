# Sprint 7 — Timer UI + Overtime Mechanic + Dead-Man's Switch

> **Status: AWAITING HUMAN APPROVAL**
> PM wrote this. Dev does not begin until the human operator approves.

**Goal:** Ship the complete, production-quality focus-timer experience — the
app's core differentiator. When this sprint is done, a user can tap "Focus" on
a task, watch a Pomodoro countdown, seamlessly enter overtime, receive check-in
prompts every 30 minutes, and have the Dead-Man's Switch auto-stop the timer
and protect their energy baseline if they go silent.

**Scope:**
- `lib/features/timer/screens/timer_screen.dart` (new)
- `lib/features/timer/timer_foreground_service.dart` (new — `flutter_foreground_task` wrapper)
- `lib/features/timer/timer_state.dart` (extend: add `overtime`, `overtimeSeconds`,
  `lastCheckInAt`, `awaitingCheckIn`)
- `lib/features/timer/timer_notifier.dart` (extend: `checkIn()`, overtime/DMS logic,
  `flutter_foreground_task` + `flutter_local_notifications` integration)
- `lib/features/goals/screens/project_detail_screen.dart` (add "Focus" action on tasks)
- `android/app/src/main/AndroidManifest.xml` (foreground service + notification permissions)
- `ios/Runner/Info.plist` (no background entitlement needed; document iOS strategy)
- `truth/design.md` (Designer appends Sprint 7 spec)

**Sprint type: UI.**
Loop: PM → Designer (pre-spec) → Dev → Designer (UI review) → Optimization → Security → PM closes.

**Packages used this sprint** (all already in pubspec — no new packages):
- `flutter_foreground_task` — Android foreground service
- `flutter_local_notifications` — Overtime + check-in + auto-stop notifications

**Key invariants carried from Sprint 6:**
- All `DateTime` values use `DateTime.now().toUtc()`.
- `TimerNotifier` methods from Sprint 6 (`startTimer`, `stopTimer`, etc.) must
  remain fully tested; new overtime/DMS logic is additive.

---

## Phase A — Designer pre-spec

**Addressee: Designer**

Append a "Sprint 7 visual spec — Timer UI" section to `truth/design.md`.

### Screens / surfaces to spec

| Surface | Description |
|---|---|
| `TimerScreen` | Full-screen focus experience: task name, timer display, controls |
| `TimerScreen — overtime mode` | How the screen changes when countdown hits zero |
| `"Still Focusing?" modal` | In-app check-in dialog during overtime |
| `"Focus" action on task items` | Small addition to task cards in `ProjectDetailScreen` |

### What the spec must include (per surface)

- **TimerScreen (countdown mode):**
  Layout, task name display, timer display format (MM:SS), visual progress
  indicator (arc, ring, or bar), Pause and Stop controls, what Stop shows
  (confirmation or direct?), how the screen is reached (route + source).

- **TimerScreen (overtime mode):**
  How the UI signals the shift from countdown to overtime (visual change,
  copy change). Timer display switches to counting up (+ prefix or "overtime"
  label). Copy that frames overtime positively — reward the hyperfocus, not
  punish it (core philosophy). The Pause and Stop controls remain.

- **"Still Focusing?" modal:**
  Triggered every 30 minutes of overtime. Copy, two actions: "Yes, still here"
  and "Stop timer". Tone: calm, non-intrusive, non-shaming.

- **"Focus" action on task items in ProjectDetailScreen:**
  Where the tap target lives on the task card (trailing icon, overflow menu item,
  or secondary button). What it does (navigates to TimerScreen with the task).

- **Notification copy (for Dev reference):**
  Three notifications to specify copy for:
  1. Foreground service status bar (shown while timer runs): title + body for
     countdown mode and overtime mode.
  2. "Still Focusing?" check-in (fired every 30 min of overtime): title + body
     + two action button labels ("Yes, still here" / "Stop timer").
  3. Auto-stop notification (fired when Dead-Man's Switch fires): title + body
     (calm, non-shaming — the user didn't fail, the timer just protected them).

### Design constraints
- Honour the Sedona Sunset palette and Material 3 base from `design.md`.
- Core philosophy: reward focus, never shame interruption. Overtime is positive.
  Dead-Man's Switch firing is protective, not a failure message.
- The timer display must be immediately readable at a glance.
- Pause vs. Stop must be visually distinct — accidental stops are frustrating.

---

## Phase B — Dev build

**Addressee: Dev** (after Designer hands off)

### Task 1 — Extend TimerState + TimerNotifier for overtime and Dead-Man's Switch

**File updates:** `lib/features/timer/timer_state.dart`,
`lib/features/timer/timer_notifier.dart`

**TimerState additions:**

| Field | Type | Notes |
|---|---|---|
| `status` | `TimerStatus` | Add `TimerStatus.overtime` to enum |
| `overtimeSeconds` | `int` | Counts up from 0 once overtime begins; 0 in other states |
| `lastCheckInAt` | `DateTime?` (UTC) | Set on `startTimer`; updated on each `checkIn()` |
| `awaitingCheckIn` | `bool` | True when the 30-min prompt is active; triggers in-app modal |

**TimerNotifier additions:**

| Method | Behavior |
|---|---|
| `checkIn()` | Sets `lastCheckInAt = now.toUtc()`. Sets `awaitingCheckIn = false`. Cancels and reschedules the next check-in notification (30 min from now). Resets the 5-minute Dead-Man's Switch countdown. |
| Internal `_onTargetReached()` | Called when `elapsedSeconds >= targetSeconds` in `_tick()`. Transitions status to `overtime`. Fires the "Focus goal reached!" local notification. Schedules the first "Still Focusing?" check-in notification at `now + 30 min`. Sets `lastCheckInAt = now.toUtc()`. |
| Internal `_onCheckInDue()` | Called 30 minutes into overtime (and every 30 min after). Sets `awaitingCheckIn = true`. Starts a 5-minute `Timer` (the Dead-Man's Switch countdown). |
| Internal `_onDeadMansSwitch()` | Called if no `checkIn()` within 5 minutes of `_onCheckInDue()`. Calls `stopTimer()` with `durationSeconds` capped at `lastCheckInAt - startedAt` in seconds (only log confirmed focus time). |

**Overtime tick:** `_tick()` also increments `overtimeSeconds` when
`status == overtime`.

**shared_preferences additions** (persist across app restarts):
```dart
const _kLastCheckInAt = 'timer_last_check_in_at'; // ISO 8601 UTC string
```
`reconcile()` must also restore `lastCheckInAt` and reschedule check-in
notifications if the app restarts mid-overtime.

**Acceptance criteria:**

- Given `startTimer(...)` runs until `elapsedSeconds == targetSeconds`, status
  transitions to `overtime` and `overtimeSeconds` begins incrementing.
- Given overtime status and `_onCheckInDue()` fires, `awaitingCheckIn == true`.
- Given `awaitingCheckIn == true` and `checkIn()` called, `awaitingCheckIn == false`
  and `lastCheckInAt` is updated.
- Given `awaitingCheckIn == true` and Dead-Man's Switch fires (5-min timer expires
  without `checkIn()`), `stopTimer()` is invoked and the resulting `Tracker.durationSeconds`
  equals `(lastCheckInAt - startedAt).inSeconds`, not the full elapsed time.
- All existing Sprint 6 TimerNotifier tests still pass.
- Pure helper `computeElapsed` and `isComplete` unchanged and still pass.

---

### Task 2 — flutter_foreground_task + flutter_local_notifications integration

**New file:** `lib/features/timer/timer_foreground_service.dart`

A thin wrapper class `TimerForegroundService` that:
- `start(String taskTitle, int targetSeconds)` — calls
  `FlutterForegroundTask.startService()` with an initial notification using the
  countdown copy from the Designer's spec.
- `update(int elapsedSeconds, int targetSeconds, bool isOvertime)` — calls
  `FlutterForegroundTask.updateService()` with refreshed notification text
  (countdown or overtime copy). Called by `TimerNotifier._tick()`.
- `stop()` — calls `FlutterForegroundTask.stopService()`.

**`flutter_local_notifications` integration** (add to `TimerNotifier`):
- **"Focus goal reached!" notification:** fired once in `_onTargetReached()`.
  Non-actionable; copy from Designer spec.
- **"Still Focusing?" check-in notification:** scheduled in
  `_onCheckInDue()`/`checkIn()`. Two action buttons (tap maps to `checkIn()` or
  `stopTimer()`). Cancel the pending notification on `checkIn()` and `stopTimer()`.
- **Auto-stop notification:** fired in `_onDeadMansSwitch()`. Non-actionable;
  calm, non-shaming copy from Designer spec.

**Platform config (Dev responsibility):**

`android/app/src/main/AndroidManifest.xml`:
- `FOREGROUND_SERVICE` permission
- `FOREGROUND_SERVICE_SPECIAL_USE` or `FOREGROUND_SERVICE_MEDIA_PLAYBACK`
  (check `flutter_foreground_task` docs for current requirement)
- `USE_EXACT_ALARM` or `SCHEDULE_EXACT_ALARM` permission for
  `flutter_local_notifications` exact alarms
- Service declaration for `flutter_foreground_task`'s built-in service class

`ios/Runner/Info.plist`:
- No background entitlement needed. Add a comment block documenting the iOS
  strategy: timer start time and last check-in persisted to `shared_preferences`;
  check-in notifications pre-scheduled via `flutter_local_notifications` at
  overtime start; reconcile on foreground restores state.

`lib/main.dart`: call `FlutterForegroundTask.init()` with notification channel
config before `runApp()`.

**Acceptance criteria:**

- `TimerForegroundService.start()` calls `FlutterForegroundTask.startService()`
  (verified by mock/spy in widget test or manual note in handoff).
- `TimerForegroundService.update()` calls `FlutterForegroundTask.updateService()`.
- `TimerForegroundService.stop()` calls `FlutterForegroundTask.stopService()`.
- Platform config files exist with the required entries (Security will verify).
- `FlutterForegroundTask.init()` is called in `main.dart` before `runApp()`.

Note: `flutter_foreground_task` and `flutter_local_notifications` require device
or emulator testing for full validation. Provide manual verification steps in
the handoff (e.g., run on Android emulator, confirm service notification appears).

---

### Task 3 — TimerScreen

**New file:** `lib/features/timer/screens/timer_screen.dart`

Implements the TimerScreen per the Designer's spec. Receives `Task` as a
constructor argument (navigated to from `ProjectDetailScreen`).

Behaviour:
- Reads `timerNotifierProvider` for state.
- On enter: calls `timerNotifier.startTimer(task.id, task.energyScore)` if
  state is idle (guard: if already running for a different task, show a
  "Timer in progress" alert instead of starting a second timer).
- Displays: task title, timer (MM:SS countdown or overtime countup per state),
  progress indicator.
- **Pause/Resume button:** calls `pauseTimer()` / `resumeTimer()`.
- **Stop button:** shows confirmation dialog (per Designer spec); on confirm calls
  `stopTimer()` then pops.
- **Overtime mode:** TimerScreen observes `status == overtime` and switches
  display per the Designer's spec.
- **"Still Focusing?" modal:** TimerScreen observes `awaitingCheckIn == true` and
  shows the in-app modal (per Designer spec). "Yes" calls `checkIn()`;
  "Stop timer" calls `stopTimer()` then pops.

**Acceptance criteria:**

- Widget test: rendered with a fake `timerNotifierProvider` in `running` state,
  task title is visible, countdown display is visible.
- Widget test: fake provider in `overtime` state → overtime display is visible.
- Widget test: `awaitingCheckIn == true` → "Still Focusing?" modal is present.
- Widget test: tap "Yes" in modal → `checkIn()` called on notifier.
- Widget test: tap Stop → confirmation dialog appears; tap confirm → `stopTimer()` called.
- No raw `Timer` or `Timer.periodic` in the screen widget (all tick logic stays
  in `TimerNotifier`).
- No raw Firestore calls in the screen.

---

### Task 4 — "Focus" action on task items in ProjectDetailScreen

**File update:** `lib/features/goals/screens/project_detail_screen.dart`

Add a "Focus" tap target to task items per the Designer's spec. On tap:
navigates to `TimerScreen(task: task)`.

**Acceptance criteria:**

- Widget test: task card in `ProjectDetailScreen` has a "Focus" tap target.
- Widget test: tapping it pushes `TimerScreen` onto the navigator.
- Existing `ProjectDetailScreen` widget tests still pass.

---

## Out of scope for Sprint 7

- Calendar view / drag-and-drop scheduling
- Energy tax / capacity warning
- Task-level `targetSeconds` customisation (all timers default to 25 min)
- Audio cue on Pomodoro completion (the spec mentions "a slight chirp" — deferred
  pending a sound-asset decision and `audioplayers` package sign-off)
- XP / gamification hooks from timer (Gamification sprint)

---

## Approval

- [x] Human operator approved this sprint scope. (2026-05-30)
