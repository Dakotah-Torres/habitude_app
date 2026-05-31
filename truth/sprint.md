# Sprint 10 — Local-First Storage Layer

> **Status: AWAITING HUMAN APPROVAL**
> PM wrote this. Dev does not begin until the human operator approves.

**Goal:** Make the app fully usable without any account. When this sprint is done,
first-time users see a Welcome screen with two paths — "Continue without account"
(local SQLite storage via drift) or "Sign in / Create account" (existing Firestore
+ anonymous auth). All data operations transparently use whichever backend was
chosen. A migration service copies local data to Firestore when a local user later
opts into cloud. No existing feature behavior changes for cloud-mode users.

**Scope:**
- `lib/shared/storage_mode.dart` (new — StorageMode enum + provider)
- `lib/shared/local/app_database.dart` (new — drift database with all tables)
- `lib/shared/local/app_database.g.dart` (generated)
- `lib/shared/migration_service.dart` (new — local → cloud migration)
- `lib/shared/screens/welcome_screen.dart` (new — first-launch onboarding)
- `lib/features/goals/goals_repository_local.dart` (new)
- `lib/features/goals/projects_repository_local.dart` (new)
- `lib/features/goals/tasks_repository_local.dart` (new)
- `lib/features/goals/contexts_repository_local.dart` (new)
- `lib/features/energy/task_completion_repository_local.dart` (new)
- `lib/features/timer/tracker_repository_local.dart` (new)
- `lib/features/triage/brain_dump_repository_local.dart` (new)
- `lib/features/gamification/gamification_repository_local.dart` (new)
- Each existing Firestore repository (add `implements I<Name>Repository`)
- Each existing repository provider (switch implementation on StorageMode)
- `lib/main.dart` (wire Welcome screen, skip Firebase init in local mode)
- `truth/design.md` (Designer appends Sprint 10 spec for the Welcome screen)

**Sprint type: UI** (Welcome screen requires Designer pre-spec and UI review).
Loop: PM → Designer (pre-spec) → Dev → Designer (UI review) → Optimization → Security → PM closes.

**New packages (pre-approved in state.md):**
- `drift: ^2.x` + `drift_flutter: ^0.1.x`
- `sqlite3_flutter_libs: ^0.5.x`

---

## Phase A — Designer pre-spec

**Addressee: Designer**

Append a "Sprint 10 visual spec — Welcome Screen" section to `truth/design.md`.

### Surface to spec: `WelcomeScreen`

This is the only UI surface in Sprint 10. It is shown **once** on first launch.

**What the spec must include:**

- **Layout:** How the two options are presented. This is the user's very first
  impression of the app — it must feel calm, trustworthy, and low-pressure.
  Align with the Sedona Sunset palette and "calm by default" design thesis.
- **Option 1 — "Continue without account":** The default, easy, no-commitment
  path. Should feel like the natural choice for someone not ready to sign in.
  Copy must not shame or pressure the user. (No "Limited mode" or "Offline only"
  language.)
- **Option 2 — "Sign in / Create account":** The cloud-sync path. In Sprint 10
  this uses anonymous auth as a placeholder; real Google/Apple sign-in arrives
  Sprint 15. The button should acknowledge that sign-in unlocks sync, not that
  local-only is inferior.
- **Branding / hero element:** The screen needs an identity — app name, a brief
  one-line tagline that captures the core philosophy ("manage energy, not time"),
  and optionally a subtle hero graphic (described in words, not rendered).
- **No account yet / privacy note:** A short line reassuring the user that local
  data stays on their device and no account is ever required.
- **Transition:** What happens visually after the user taps either option (e.g.,
  fade to main app). Keep it lightweight — no onboarding carousel.

**Design constraints:**
- Sedona Sunset palette, Material 3 base.
- Core philosophy: the choice must feel safe and shame-free. Neither option
  should feel like a downgrade.
- No more than two primary tap targets on this screen.
- The screen should never be shown again once a choice is made.

---

## Phase B — Dev build

**Addressee: Dev** (after Designer hands off)

---

### Task 1 — StorageMode

**File:** `lib/shared/storage_mode.dart`

```dart
enum StorageMode { local, cloud }
```

**Providers:**
- `storageModeProvider` — `AsyncNotifierProvider<StorageModeNotifier, StorageMode>`
  - On first read: checks `shared_preferences` for key `storage_mode`.
    If absent, returns `StorageMode.local` as default (no write yet).
  - `setMode(StorageMode mode)` — persists to `shared_preferences` and updates state.
- `isOnboardingCompleteProvider` — `FutureProvider<bool>` — true if `storage_mode`
  key exists in `shared_preferences` (i.e., user has made a choice).

**Acceptance criteria:**
- First launch (no key): `storageModeProvider` returns `StorageMode.local`.
- After `setMode(StorageMode.cloud)`: `storageModeProvider` returns `StorageMode.cloud`
  and the key is persisted in `shared_preferences`.
- `isOnboardingCompleteProvider` returns false when no key exists, true after `setMode`.

---

### Task 2 — Drift database

**File:** `lib/shared/local/app_database.dart`

A single `drift` `DriftDatabase` class with tables for all eight entity types.
Use `drift_flutter` for the SQLite connection on mobile.

**Tables (column names mirror JSON field names from the Freezed models):**

| Table | Key columns |
|---|---|
| `goals` | id TEXT PK, title, description, goalType, energyScore, weeklyQuota, contextId, createdAt, completedAt, archivedAt |
| `projects` | id TEXT PK, goalId, title, description, status, dueDate, createdAt, completedAt |
| `tasks` | id TEXT PK, parentId, parentType, title, description, taskType, energyScore, weeklyQuota, contextId, status, dueDate, estimatedMinutes, createdAt, completedAt |
| `contexts` | id TEXT PK, name, colorHex, createdAt |
| `task_completions` | id TEXT PK, taskId, completedAt, energyScore |
| `trackers` | id TEXT PK, taskId, startedAt, pausedAt, stoppedAt, durationSeconds, overtimeSeconds, lastCheckInAt, status |
| `brain_dump_items` | id TEXT PK, text, createdAt, backloggedUntil, scheduledForDate |
| `rank_up_events` | id TEXT PK, taskId, triggeredAt, newBaselinePoints, newRank |

All DateTime columns are stored as ISO 8601 TEXT (UTC). Nullable columns are
`TEXT?` or `INTEGER?` as appropriate.

**Acceptance criteria:**
- Database opens without error on first use.
- Each table can insert, update, delete, and select rows.
- Unit tests (using drift's in-memory `NativeDatabase.memory()`) cover insert +
  select roundtrip for at least one row per table.

---

### Task 3 — Abstract repository interfaces

Add an abstract interface class for every repository that will have two
implementations. Place each interface in the same file as the existing Firestore
repository (or a `_interface.dart` sibling — Dev's choice, keep it simple).

**Interfaces required:**

```dart
abstract class IGoalsRepository {
  Stream<List<Goal>> watchAll();
  Future<void> addGoal(Goal goal);
  Future<void> updateGoal(Goal goal);
  Future<void> deleteGoal(String id);
}

abstract class IProjectsRepository { /* same pattern */ }
abstract class ITasksRepository { /* same pattern */ }
abstract class IContextsRepository { /* same pattern */ }
abstract class ITaskCompletionRepository { /* same pattern */ }
abstract class ITrackerRepository { /* same pattern */ }
abstract class IBrainDumpRepository {
  Stream<List<BrainDumpItem>> watchAllItems();
  Stream<List<BrainDumpItem>> watchActiveItems(DateTime today);
  Future<void> addItem(BrainDumpItem item);
  Future<void> updateItem(BrainDumpItem item);
  Future<void> deleteItem(String id);
}
abstract class IGamificationRepository {
  Stream<List<RankUpEvent>> watchAllRankUpEvents();
  Future<void> addRankUpEvent(RankUpEvent event);
  Stream<Set<String>> watchUnlockedTaskIds();
}
```

Make each existing Firestore repository class `implements` its interface.

**Acceptance criteria:**
- `dart analyze` passes — no type errors after adding `implements`.
- All existing tests still pass.

---

### Task 4 — Local repository implementations

One local implementation per interface, backed by the drift database from Task 2.
Each class `implements` its interface.

**Files:**
- `lib/features/goals/goals_repository_local.dart` → `class GoalsRepositoryLocal implements IGoalsRepository`
- `lib/features/goals/projects_repository_local.dart`
- `lib/features/goals/tasks_repository_local.dart`
- `lib/features/goals/contexts_repository_local.dart`
- `lib/features/energy/task_completion_repository_local.dart`
- `lib/features/timer/tracker_repository_local.dart`
- `lib/features/triage/brain_dump_repository_local.dart`
- `lib/features/gamification/gamification_repository_local.dart`

Each local repo receives the `AppDatabase` as a constructor parameter.
`watchAll*` / `watchActive*` methods return `Stream` from drift's `watch()` query.
All DateTime fields must be stored/retrieved as UTC ISO 8601 strings.

**Acceptance criteria** (unit tests using drift in-memory database):
- For each local repository: add an item, watch stream, verify it emits the item.
- For `BrainDumpRepositoryLocal.watchActiveItems`: same three filter tests as
  the Firestore version (backloggedUntil yesterday appears; tomorrow does not;
  scheduledForDate set does not appear).
- No raw SQL strings — use drift's type-safe query API only.

---

### Task 5 — Repository provider factory

Update each repository provider to return the correct implementation based on
`storageModeProvider`. Use a pattern like:

```dart
@riverpod
IGoalsRepository goalsRepository(Ref ref) {
  final mode = ref.watch(storageModeProvider).valueOrNull ?? StorageMode.local;
  return mode == StorageMode.cloud
      ? GoalsRepository(ref)       // existing Firestore impl
      : GoalsRepositoryLocal(ref.watch(appDatabaseProvider));
}
```

Add `appDatabaseProvider` — a singleton `Provider<AppDatabase>` that lazily opens
the drift database once and reuses it.

**Acceptance criteria:**
- In cloud mode, all feature providers still use Firestore repositories (no regression).
- In local mode, all feature providers use the drift-backed local repositories.
- Switching `StorageMode` via `setMode()` invalidates all repository providers and
  re-resolves them to the new implementation.
- All existing tests still pass (they already use fakes, so mode-switching doesn't break them).

---

### Task 6 — Migration service

**File:** `lib/shared/migration_service.dart`

```dart
class MigrationService {
  // Reads all data from local drift repositories, writes each record to
  // Firestore under the authenticated user's UID, then calls
  // storageModeNotifier.setMode(StorageMode.cloud).
  // Returns normally on success; throws on any Firestore write failure.
  // Does NOT delete local data — local DB is kept as a fallback cache.
  Future<void> migrateLocalToCloud(String uid);
}
```

**Provider:** `migrationServiceProvider`

**Acceptance criteria:**
- Unit test (using fake repositories): after `migrateLocalToCloud`, all records
  present in the local DB appear in the fake Firestore repository, and
  `storageModeProvider` returns `StorageMode.cloud`.
- If any Firestore write fails, the error propagates and `StorageMode` is NOT
  changed (no partial migration leaves the app in an inconsistent state).

---

### Task 7 — WelcomeScreen

**File:** `lib/shared/screens/welcome_screen.dart`

Built per the Designer's spec. Uses `storageModeProvider` and
`isOnboardingCompleteProvider`.

**Behavior:**
- Shown on app launch only when `isOnboardingCompleteProvider` is false.
- "Continue without account" → `storageModeNotifier.setMode(StorageMode.local)` →
  navigate to `RootScreen`.
- "Sign in / Create account" → trigger anonymous Firebase Auth sign-in →
  `storageModeNotifier.setMode(StorageMode.cloud)` → navigate to `RootScreen`.
- On either path: once `setMode` is called, `isOnboardingCompleteProvider`
  becomes true and `WelcomeScreen` is never shown again.

**main.dart change:** On startup, check `isOnboardingCompleteProvider`:
- false → show `WelcomeScreen`
- true → show `RootScreen` directly (existing behavior for returning users)

Skip Firebase initialization entirely when `StorageMode.local` is active.

**Acceptance criteria:**
- Widget test: WelcomeScreen renders both options.
- Widget test: tapping "Continue without account" calls `setMode(local)` and
  navigates away from WelcomeScreen.
- Widget test: tapping "Sign in" triggers auth and calls `setMode(cloud)`.
- Widget test: when `isOnboardingCompleteProvider` is true, WelcomeScreen is
  not shown (app goes directly to RootScreen).
- No raw Firebase calls inside `welcome_screen.dart`.

---

## Out of scope for Sprint 10

- Settings screen toggle for switching storage mode post-onboarding — future sprint
- Cloud → local migration (reverse) — not planned
- Real Google/Apple sign-in — Sprint 15
- Data conflict resolution if the same local DB is migrated twice — deferred

---

## Approval

- [ ] Human operator approved this sprint scope.
