# Habitude — Project State

> Living state, owned and updated by the **PM**. The single source of truth for
> where the project stands right now. The PM updates this at the close of every
> sprint and whenever it rules on an escalation.

## Current sprint

**Sprint 6** — Timer Core: `Tracker` model, `TrackerRepository`, `TimerState`,
and `TimerNotifier` (Riverpod state machine with shared_preferences persistence).
Non-UI sprint. See `truth/sprint.md`. Status: **awaiting human approval (2026-05-29).**

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

**Packages signed off by PM (added to pubspec when Dev scaffolds):**

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

No other packages may be added without PM sign-off recorded here.

**Flutter template default dependencies** (`cupertino_icons` and similar) are
pre-approved as a class. They carry no meaningful risk and are not subject to
the sign-off requirement. Rationale: they are injected by `flutter create` and
contain no behavior beyond bundled assets. (Ruling 2026-05-29, Sprint 1 close.)

### [Job Zero] Dev may now implement timer persistence — packages are locked.

### [S1 close] Environment — flutter analyze toolchain crash

`flutter analyze` crashed on the dev machine (missing analysis server snapshot)
throughout Sprints 1–5. This is a machine/environment issue, not an app-code
issue. `dart analyze` passed cleanly and was accepted as the verification
substitute. The human operator should run:
```
flutter doctor -v
flutter clean && flutter pub get
flutter upgrade --force
```
…to restore `flutter analyze`. Dev agents should document in handoff if
`flutter analyze` is still broken.

### [S3 close] firebase_auth signed off

`firebase_auth` (latest stable) added as a runtime dependency for Sprint 3.
Anonymous auth strategy chosen; real sign-in methods deferred to Sprint 14.

## Completed

> What has been built and verified, by sprint.

### Sprint 1 — Foundation (closed 2026-05-29)

All four tasks delivered, tests passing, Security-approved.

- **Project scaffold:** Feature-first folder structure. All Job Zero packages pinned.
- **Core domain models:** `Goal`, `Project`, `Task`, `Context` — Freezed + JSON roundtrip.
- **Firebase setup:** `firebase_core` in `main.dart`. `FirestorePaths`. Credential stubs + `.gitignore`.
- **Goals Riverpod provider:** CRUD + stream providers. Tested with `fake_cloud_firestore`.

### Sprint 2 — Data Layer Completion (closed 2026-05-29)

All three tasks delivered, 33 tests passing, Security-approved.

- **ProjectsRepository:** `watchProjects()`, `watchProjectsByGoal()`, CRUD.
- **TasksRepository:** `watchTasks()`, `watchTasksByParent()`, CRUD. `weeklyQuota` roundtrip verified.
- **ContextsRepository:** `watchContexts()`, CRUD. `colorHex` string preservation verified.

### Sprint 3 — Authentication Backbone (closed 2026-05-29)

All four tasks delivered, 39 tests passing, Security-approved. Both HIGH blockers resolved.

- **AuthRepository:** Anonymous sign-in, `currentUserId`, `authStateChanges`. `FakeAuthRepository` for tests.
- **UID wiring:** `"test_user"` removed from all repositories. `currentUserIdProvider` wired in.
- **Anonymous sign-in bootstrap:** `main.dart` calls `signInAnonymously()` before `runApp()`; errors rethrown.
- **Firestore rules:** Ownership rule for `users/{userId}/{document=**}`. Default deny.

### Sprint 4 — Task Completion Tracking + Energy Budgeting Engine (closed 2026-05-29)

All four tasks delivered, 57 tests passing, Security-approved.

- **TaskCompletion model:** Freezed + JSON roundtrip. `FirestorePaths.taskCompletions(uid)` added.
- **TaskCompletionRepository:** `watchCompletions()`, `watchCompletionsSince()`, `addCompletion()`, `deleteCompletion()`.
- **EnergyEngine:** Pure Dart. `dailyPoints()` + `energyBaseline()` (rolling 7-day avg, default 80).
- **EnergyService:** `energyBaselineProvider` (`StreamProvider<int>`). Live baseline from Firestore.

### Sprint 5 — Goals Hierarchy UI (closed 2026-05-29)

All six screens delivered, 75 tests passing, Security-approved. Full UI sprint loop ran (Designer pre-spec → Dev → Designer review → Optimization → Security → fix → re-review).

- **Sedona Sunset theme:** `lib/shared/theme.dart` — Material 3 palette and typography.
- **GoalsListScreen:** Goals list, empty/loading/error states, FAB, navigation.
- **GoalFormScreen:** Create/edit Goal. Inline save-error messages. Validation.
- **GoalDetailScreen:** Goal header + Projects list. Cascade delete (projects + tasks). 720 px wide-layout cap.
- **ProjectFormScreen:** Create/edit Project. Status labels: Active / Completed / Archived.
- **ProjectDetailScreen:** Project header + Tasks list. Overflow menu (Edit/Delete) with confirmation. Cascade delete (tasks). Loading/error panels keep header visible.
- **TaskFormScreen:** Create/edit Task. `weeklyQuota` field toggles with `taskType`. Inline save errors.
- **watchById() providers** added to Goals, Projects, Tasks repositories for detail-screen streams.
- **Cascade delete:** Client-side sequential cascade with loading overlay and context.mounted guards.

## Open / deferred

> Known issues, parked ideas, things to revisit.

- **[MEDIUM]** Improve Firebase initialization error handling in `main.dart`
  for production (avoid silent failure on `Firebase.initializeApp()`).
- **[LOW]** Refactor all repository `update*()` methods to use `.update()` instead
  of `.set()` to preserve server-side fields.
- **[LOW — pre-sign-out]** `currentUserIdProvider` does not watch `authStateChanges`;
  will hold stale UID if sign-out/session expiry is added. Must fix before any
  sign-out sprint. File: `lib/shared/auth_repository.dart`.
- **[LOW]** Stale `"as per sprint scope (empty shell)"` comment in `main.dart:9-15`.
- **[LOW — must fix when task-completion UI is built]** `completedAt` stored as ISO
  8601 string with no enforced UTC normalization in `TaskCompletionRepository`.
  All call sites must use `DateTime.now().toUtc()`. Enforced in Sprint 5 screens;
  must remain enforced in Sprint 6 TimerNotifier.
  File: `lib/features/energy/task_completion_repository.dart:29`.
- **[LOW — pre-deployment]** Client-side cascade deletes (Goal → Projects → Tasks;
  Project → Tasks) are sequential and non-atomic. A network drop mid-cascade
  leaves partial state. Before multi-user or paid-tier deployment, switch to
  Firestore batched writes (≤500 ops/batch) or Cloud Functions for atomic
  server-side enforcement.
  Files: `lib/features/goals/screens/goal_detail_screen.dart`,
  `lib/features/goals/screens/project_detail_screen.dart`.

## Tie-breaker rulings

> Conflicts the PM has resolved (`AGENTS.md` §8), with reasoning.

- _None yet._
