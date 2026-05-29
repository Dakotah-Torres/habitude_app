# Habitude — Project State

> Living state, owned and updated by the **PM**. The single source of truth for
> where the project stands right now. The PM updates this at the close of every
> sprint and whenever it rules on an escalation.

## Current sprint

**Sprint 2** — Data Layer Completion: Projects, Tasks, and Contexts repositories.
See `truth/sprint.md`. Status: **awaiting human approval (2026-05-29).**

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
throughout Sprint 1. This is a machine/environment issue, not an app-code issue.
`dart analyze` passed cleanly and was accepted as the verification substitute for
Sprint 1. The human operator should run:
```
flutter doctor -v
flutter clean && flutter pub get
flutter upgrade --force
```
…to restore `flutter analyze` before Sprint 2 review. Dev agents should
document in handoff if `flutter analyze` is still broken.

## Completed

> What has been built and verified, by sprint.

### Sprint 1 — Foundation (closed 2026-05-29)

All four tasks delivered, tests passing, Security-approved.

- **Project scaffold:** Feature-first folder structure in place. All Job Zero
  packages pinned in `pubspec.yaml`. `flutter test` passes; `dart analyze`
  clean. (`flutter analyze` environment issue — see locked decision above.)
- **Core domain models:** `Goal`, `Project`, `Task`, `Context` as Freezed
  value objects with JSON roundtrip. Enums co-located. All model unit tests pass.
- **Firebase setup:** `firebase_core` initialized in `main.dart`.
  `FirestorePaths` abstract class in `lib/shared/firestore_paths.dart` with
  unit tests. Placeholder credential stubs in place; real credentials are
  `.gitignore`-protected (Security fix applied this sprint).
- **Goals Riverpod provider:** `GoalsRepository` with `watchGoals`,
  `addGoal`, `updateGoal`, `deleteGoal`. `goalsRepositoryProvider` and
  `goalsStreamProvider` via `riverpod_annotation`. Tested with
  `fake_cloud_firestore`.

**Sprint 1 debt items (tracked, not blocking Sprint 2):**
- [HIGH — pre-auth blocker] Replace hardcoded `test_user` UID with
  `FirebaseAuth.instance.currentUser!.uid` + null-guard.
- [HIGH — pre-deployment blocker] Create and deploy `firestore.rules`
  (allow `users/{uid}/**` read/write only for `request.auth.uid == uid`).
- [MEDIUM] Improve Firebase initialization error handling in `main.dart`.
- [LOW] Refactor `GoalsRepository.updateGoal` to use `.update()` instead of
  `.set()` to preserve server-side fields.

## Open / deferred

> Known issues, parked ideas, things to revisit.

- **[HIGH — pre-auth blocker]** Replace hardcoded `test_user` UID in
  `goals_repository.dart` (and all future repositories) with
  `FirebaseAuth.instance.currentUser!.uid` and add null-guard.
- **[HIGH — pre-deployment blocker]** Create and deploy `firestore.rules`
  (allow `users/{uid}/**` read/write only for `request.auth.uid == uid`).
- **[MEDIUM]** Improve Firebase initialization error handling in `main.dart`
  for production (avoid silent failure).
- **[LOW]** Refactor `GoalsRepository.updateGoal` to use `.update()` instead of
  `.set()` to preserve server-side fields.

## Tie-breaker rulings

> Conflicts the PM has resolved (`AGENTS.md` §8), with reasoning.

- _None yet._
