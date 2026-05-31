# Habitude — Project State

> Living state, owned and updated by the **PM**. The single source of truth for
> where the project stands right now. The PM updates this at the close of every
> sprint and whenever it rules on an escalation.

## Current sprint

**Sprint 10** — Local-First Storage Layer.
UI sprint — Designer pre-specs the Welcome screen before Dev builds.
See `truth/sprint.md`. Status: **awaiting human approval.**

## Locked decisions

> Decisions made and the reasoning behind them, so they are never re-litigated.

### [Job Zero] Background-execution + local-notification packages

**Decision:**
- **Notifications:** `flutter_local_notifications` (v18+)
- **Background execution:** `flutter_foreground_task` (replaces `workmanager`)

**Reasoning:**

`workmanager` was evaluated and rejected. It targets deferrable background work
(sync, cleanup). Android's minimum periodic interval is 15 minutes; iOS
BGTaskScheduler is throttled further by the OS (delays of hours are common).
Neither can reliably enforce a 5-minute Dead-Man's Switch window. Wrong tool.

`flutter_local_notifications` is locked in for all notification display and
scheduling: timer-expiry cue, "Still Focusing?" check-in prompts, and the
auto-stop notification if the Dead-Man's Switch fires. Its scheduled-alarm
primitives (exact alarms on Android with `USE_EXACT_ALARM` permission;
`UNUserNotificationCenter` on iOS) fire even when the app is killed, which is
the minimum viable contract for the Overtime Mechanic.

`flutter_foreground_task` creates an Android Foreground Service. The OS is
legally required to keep a foreground service alive; it cannot be silently
killed. This is the correct primitive for a running timer. A persistent
status-bar notification is shown (standard UX for timer apps). On **iOS**,
background execution remains OS-limited regardless of package; the mitigation
is: (a) persist timer start time and last confirmed check-in to
`shared_preferences` on every state change, (b) pre-schedule check-in
notifications via `flutter_local_notifications` at start of overtime, (c) on
app-foreground reconcile actual elapsed time against stored state and cancel or
reschedule stale notifications. This pattern is battle-tested and requires no
background entitlement on iOS.

**Packages signed off by PM:**

| Package | Purpose |
|---|---|
| `flutter_local_notifications` | Notifications + scheduled alarms |
| `flutter_foreground_task` | Android foreground service / timer persistence |
| `shared_preferences` | Local persistence of timer state (iOS fallback) |
| `firebase_core` | Firebase bootstrap |
| `cloud_firestore` | Primary database |
| `firebase_auth` | Anonymous + future real auth |
| `flutter_riverpod` + `riverpod_annotation` | State management (stack-locked) |
| `freezed` + `freezed_annotation` | Immutable value objects for domain models |
| `json_serializable` | JSON serialization for Firestore mapping |
| `build_runner` | Code generation (Freezed / json_serializable) |
| `timezone` | Required peer dep of `flutter_local_notifications` for `zonedSchedule`. Signed off Sprint 7 — forced transitive requirement of an already-approved package. |

No other packages may be added without PM sign-off recorded here.

**Flutter template default dependencies** (`cupertino_icons` and similar) are
pre-approved as a class. They carry no meaningful risk and are not subject to
the sign-off requirement.

### [Job Zero] Dev may now implement timer persistence — packages are locked.

### [S1 close] Environment — flutter analyze toolchain crash

`flutter analyze` crashed on the dev machine (missing analysis server snapshot)
throughout Sprints 1–7. `dart analyze` accepted as the verification substitute.
The human operator should run:
```
flutter doctor -v
flutter clean && flutter pub get
flutter upgrade --force
```
Dev agents should document in handoff if `flutter analyze` is still broken.

### [S3 close] firebase_auth signed off

`firebase_auth` (latest stable) added as a runtime dependency for Sprint 3.
Anonymous auth strategy chosen; real sign-in methods deferred to Sprint 14.

### [S7] timezone signed off (tie-breaker ruling)

`timezone` is a required peer dependency of `flutter_local_notifications` for
`zonedSchedule`. Approved Sprint 7 as a forced transitive requirement — not a
discretionary addition. Signed off in packages table above.

## Completed

> What has been built and verified, by sprint.

### Sprint 1 — Foundation (closed 2026-05-29)
Project scaffold, domain models, Firebase setup, Goals CRUD provider. 4 tasks, tests pass.

### Sprint 2 — Data Layer Completion (closed 2026-05-29)
ProjectsRepository, TasksRepository, ContextsRepository. 33 tests pass.

### Sprint 3 — Authentication Backbone (closed 2026-05-29)
AuthRepository, anonymous sign-in, UID wiring, Firestore rules. Both HIGH blockers resolved. 39 tests pass.

### Sprint 4 — Task Completion Tracking + Energy Budgeting Engine (closed 2026-05-29)
TaskCompletion model/repo, EnergyEngine (pure Dart), EnergyService provider. 57 tests pass.

### Sprint 5 — Goals Hierarchy UI (closed 2026-05-29)
Sedona Sunset theme. 6 screens: GoalsListScreen, GoalFormScreen, GoalDetailScreen,
ProjectFormScreen, ProjectDetailScreen, TaskFormScreen. Cascade delete. 75 tests pass.

### Sprint 6 — Timer Core (closed 2026-05-30)
Tracker model/repo, TimerState + TimerStatus enum, TimerNotifier (startTimer/pauseTimer/
resumeTimer/stopTimer/reconcile), shared_preferences persistence, pure helpers
computeElapsed/isComplete. 93 tests pass.

### Sprint 9 — Gamification Engine (closed 2026-05-31)
ConsistencyEngine (rolling 6-week ISO-week ratio with Extra Credit pooling),
GamificationEngine (extra credit detection, Capacity Unlock trigger at ≥120%,
rank from unlock count, adjusted baseline), RankUpEvent model + repository,
GamificationService providers (taskConsistencyRatios, currentRank,
adjustedEnergyBaseline, pendingCapacityUnlocks). PM tie-breaker on Extra Credit
formula recorded. No new LOW items from Security. 150 tests pass.

### Sprint 8 — Brain Dump + Morning Triage Funnel (closed 2026-05-31)
BrainDumpItem model/repo, TriageService (pure Dart, ISO-week logic), triage_providers.dart,
BrainDumpScreen, TriageFunnelScreen (swipe + explicit buttons, resting directional hints),
root NavigationBar (Goals + Dump tabs). 130 tests pass.

### Sprint 7 — Timer UI + Overtime + Dead-Man's Switch (closed 2026-05-31)

All four tasks delivered. Full UI sprint loop ran (including Designer pre-spec,
two rounds of Designer UI review, Optimization, Security). 100 tests pass.

- **TimerState extended:** `TimerStatus.overtime`, `overtimeSeconds`, `lastCheckInAt`,
  `awaitingCheckIn`.
- **TimerNotifier extended:** `checkIn()`, `_onTargetReached()` (transitions to overtime,
  fires "Focus goal reached!" notification), `_onCheckInDue()` (30-min overtime prompt,
  starts 5-min DMS countdown), `_onDeadMansSwitch()` (auto-stop, caps `durationSeconds`
  at last confirmed check-in time). `reconcile()` also restores `lastCheckInAt`.
  `shared_preferences` key `timer_last_check_in_at` added.
- **TimerForegroundService:** wraps `flutter_foreground_task`; updates status-bar
  notification text on each tick.
- **NotificationService:** wraps `flutter_local_notifications`; `zonedSchedule`
  for "Still Focusing?" check-in; notification actions wired in `main.dart`.
- **TimerScreen:** countdown and overtime modes per Designer spec. Pause/Stop controls
  (Stop requires confirmation). "Still Focusing?" modal on `awaitingCheckIn`.
  Calm inline error panel on start failure.
- **"Focus" action on task cards** in ProjectDetailScreen → navigates to TimerScreen.
- **Platform config:** `AndroidManifest.xml` (FOREGROUND_SERVICE,
  SCHEDULE_EXACT_ALARM, POST_NOTIFICATIONS, service declaration),
  `Info.plist` (iOS strategy documented; no background entitlement).
- **timezone** dependency added and signed off (peer dep of flutter_local_notifications).

## Open / deferred

> Known issues, parked ideas, things to revisit.

- **[MEDIUM]** Improve Firebase init error handling in `main.dart`.
- **[LOW]** Refactor repository `update*()` to use `.update()` instead of `.set()`.
- **[LOW — pre-sign-out]** `currentUserIdProvider` staleness before sign-out.
  File: `lib/shared/auth_repository.dart`.
- **[LOW]** Stale comment in `main.dart:9-15`.
- **[LOW]** `completedAt` must always be `DateTime.now().toUtc()` at every call site.
- **[LOW — pre-deployment]** Non-atomic client-side cascade deletes.
- **[LOW]** `reconcile()` unguarded `DateTime.parse` — now covers two fields
  (startedAtStr + lastCheckInStr).
  File: `lib/features/timer/timer_notifier.dart`.
- **[LOW]** `state.startedAt!` force-unwrap — now at 5 locations in timer_notifier.
- **[LOW — pre-deployment]** `SCHEDULE_EXACT_ALARM` revocation unhandled.
  If user revokes "Alarms & reminders" on Android 12+, `_scheduleCheckInNotification()`
  throws `PlatformException` and DMS notification coverage is silently lost.
  Fix: wrap in try/catch or check `canScheduleExactNotifications()` first; degrade
  to inexact scheduling on failure.
  File: `lib/features/timer/timer_notifier.dart`.
- **[LOW — pre-deployment]** `confirmedDuration` can be negative on clock skew.
  `lastRef.difference(state.startedAt!).inSeconds` — clamp to `max(0, ...)`.
  File: `lib/features/timer/timer_notifier.dart:346`.
- **[LOW — pre-deployment]** Brain dump text has no client-side max-length cap.
  `BrainDumpScreen._addItem()` trims and rejects empty input but places no upper bound.
  Cap at 1000 characters before the Firestore write.
  File: `lib/features/triage/screens/brain_dump_screen.dart`.
- **[LOW — pre-deployment]** `primaryVelocity!` force-unwrap in `_TriageCard` swipe handlers.
  `details.primaryVelocity!` on `onHorizontalDragEnd` and `onVerticalDragEnd` — replace
  with `details.primaryVelocity ?? 0.0`.
  File: `lib/features/triage/screens/triage_funnel_screen.dart:173,175,180`.

## Tie-breaker rulings

### [S9] Consistency ratio formula — tie-breaker ruling

**Conflict:** Sprint 9 spec said Extra Credit weeks count as 1 hit (capped, correct)
AND that `consistencyRatio >= 120%` triggers a Capacity Unlock (correct) AND that
"Extra Credit does not inflate ratio above 100% for the current week" — the last
clause was ambiguous and made the 120% threshold mathematically unreachable.

**Ruling:** The per-week binary cap applies only to `weeksHittingQuota`. Extra Credit
completions are summed across the entire window and added separately to the numerator.

**Canonical formula:**
```
consistencyRatio = (weeksHittingQuota + totalWindowExtraCredit) / windowSize × 100
```
Where `totalWindowExtraCredit` = sum of max(0, weekCompletions − quota) for every
week in the rolling window.

**Example:** 6-week window, all 6 weeks hit quota, 2 total EC completions →
`(6 + 2) / 6 × 100 = 133%` → Capacity Unlock triggers.

The conflicting acceptance bullet in sprint.md ("Extra Credit completions do NOT
inflate consistencyRatio above 100% for the current week") is superseded by this
ruling. `truth/spec.md §5` explicitly states Extra Credit heals past consistency
and that 120% is achievable — the sprint spec cannot contradict the feature spec.

### [Pre-S10] Hybrid local-first architecture — locked

**Decision:** The app ships with two storage modes.

**`StorageMode.local` (default):**
- Chosen on first launch from the Welcome screen ("Continue without account").
- All data is stored on-device via SQLite (`drift`).
- No Firebase, no network calls, no account required.
- App is fully functional in this mode indefinitely.

**`StorageMode.cloud`:**
- Chosen from the Welcome screen ("Create Account / Sign in").
- Backed by Firestore + Firebase Auth (anonymous auth now; real sign-in Sprint 15).
- Multi-device sync and cloud backup.

**Welcome screen (Sprint 10):**
- Shown on first launch only (not shown again once a mode is chosen).
- Two clear options: "Continue without account" and "Sign in / Create account".
- "Sign in / Create account" in Sprint 10 uses anonymous auth as a placeholder;
  real Google/Apple sign-in is wired in Sprint 15 and upgrades the anonymous session.

**Local → Cloud migration (Sprint 10):**
- When a local-mode user later chooses to sign in (from settings or a prompt),
  all local data is migrated to Firestore before switching StorageMode to cloud.
- Migration is a one-way operation; no cloud → local migration in scope.

**Repository pattern:**
- Every repository interface is backed by two implementations:
  `<Repo>Local` (drift) and `<Repo>Firestore` (existing).
- A `repositoryModeProvider` reads `StorageMode` and returns the correct
  implementation. All feature providers consume the interface, never the
  concrete class directly.

**Packages added (Sprint 10):**
- `drift` + `drift_flutter` — SQLite ORM
- `sqlite3_flutter_libs` — native SQLite binaries (required peer dep)

These three packages are hereby signed off by PM for Sprint 10.

> Conflicts the PM has resolved (`AGENTS.md` §8), with reasoning.

### [S7] timezone dependency — approved

Dev added `timezone: ^0.11.0` to `pubspec.yaml` without explicit prior sign-off.
**Ruling:** Approved. `timezone` is a required peer dependency of
`flutter_local_notifications` for `zonedSchedule` — the only correct API for
exact-alarm notifications that survive backgrounding, which is the core contract
of the Dead-Man's Switch. This is a forced transitive requirement of a package
already in the approved stack, not a discretionary addition.
