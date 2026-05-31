# Sprint 9 — Gamification Engine

> **Status: AWAITING HUMAN APPROVAL**
> PM wrote this. Dev does not begin until the human operator approves.

**Goal:** Build the pure-Dart computation layer for the gamification system. When
this sprint is done, the app can calculate rolling consistency ratios per recurring
task, detect Extra Credit completions, trigger Capacity Unlocks (permanent baseline
bumps) when a task's consistency ratio reaches 120%, persist rank-up events, and
expose the current global rank (Novice → Adept → Master) and baseline through
Riverpod providers.

**Scope:**
- `lib/features/gamification/consistency_engine.dart` (new pure Dart engine)
- `lib/features/gamification/gamification_engine.dart` (new pure Dart engine)
- `lib/features/gamification/rank_up_event.dart` (new model)
- `lib/features/gamification/gamification_repository.dart` (new repository)
- `lib/features/gamification/gamification_service.dart` (new Riverpod service + providers)
- `lib/shared/firestore_paths.dart` (add `rankUpEvents` path)

**Sprint type: Non-UI.**
Loop: PM → Dev → Optimization → Security → PM closes.

**No new packages.** All dependencies already in `pubspec.yaml`.

---

## Phase B — Dev build

**Addressee: Dev**

---

### Task 1 — ConsistencyEngine (pure Dart)

**File:** `lib/features/gamification/consistency_engine.dart`

Pure Dart file — no Flutter, Riverpod, or Firestore imports.

**Core concept:** A rolling consistency ratio measures how reliably a user hits a
recurring task's weekly quota over the past N weeks (default: 6 weeks). It is a
fraction `completionsHit / weeksEvaluated` expressed as a percentage, where
`completionsHit` = the number of weeks in the window where
`completionsThisWeek >= task.weeklyQuota`. This replaces streak-based scoring —
missing a week lowers the ratio but does not reset to zero.

**Functions:**

```dart
// Returns the number of calendar weeks in the rolling window [windowStart, today]
// (inclusive, ISO Monday–Sunday UTC) where completions for taskId met or exceeded quota.
// windowStart defaults to the Monday 6 ISO weeks before the week containing today.
int weeksHittingQuota(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today, {
  int windowWeeks = 6,
});

// Returns the number of ISO weeks in the evaluation window (≤ windowWeeks; fewer
// at the start of the user's history when there are not yet windowWeeks of data).
int evaluationWindowSize(
  String taskId,
  List<TaskCompletion> completions,
  DateTime today, {
  int windowWeeks = 6,
});

// Returns weeksHittingQuota / evaluationWindowSize as a percentage (0.0–∞).
// Returns 0.0 if evaluationWindowSize is 0.
// Values above 100.0 are possible via Extra Credit weeks (see Task 2).
double consistencyRatio(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today, {
  int windowWeeks = 6,
});
```

**ISO week definition:** Monday 00:00:00 UTC through Sunday 23:59:59 UTC.

**Evaluation window:** The 6 ISO weeks ending with the week that contains `today`
(i.e., the current week is included in the window, even if it is not yet complete).

**Extra Credit week:** A week where `completionsThisWeek > quota` still counts as
1 hit in `weeksHittingQuota` (capped at 1 per week for ratio purposes — Extra
Credit's effect is in Task 2, not here).

**Acceptance criteria** (pure Dart unit tests):
- Task with quota 3, 6/6 weeks all meeting quota → ratio = 100.0%.
- Task with quota 3, 5/6 weeks meeting quota → ratio ≈ 83.3%.
- Task with quota 3, 0/6 weeks meeting quota → ratio = 0.0%.
- Task with no completions at all → ratio = 0.0, windowSize = 0.
- Task in its first week (only 1 week of history) → windowSize = 1.
- A week with 5 completions against quota 3 counts as 1 hit, not 5/3.
- completions from outside the window do NOT affect the ratio.
- Edge: today is Monday — the previous Sunday is in the prior week.

---

### Task 2 — GamificationEngine (pure Dart)

**File:** `lib/features/gamification/gamification_engine.dart`

Pure Dart file — no Flutter, Riverpod, or Firestore imports.

**Core concepts:**

- **Extra Credit:** A completion beyond the weekly quota for a recurring task.
  Extra Credit completions "heal" past consistency by counting in future ratio
  windows. The engine exposes how many Extra Credit completions exist for the
  current week.
- **Capacity Unlock:** Triggered when a task's `consistencyRatio` reaches or
  exceeds 120.0%. Each unlock permanently increases the user's Daily Energy
  Baseline by 5 points. An unlock fires **once per task** when it first crosses
  the 120% threshold; it does not fire again unless the ratio dips below 100%
  and climbs back to 120%.
- **Global Rank:** Computed from the total number of Capacity Unlocks the user
  has ever received. Novice (0 unlocks), Adept (1–4 unlocks), Master (5+ unlocks).

```dart
enum Rank { novice, adept, master }

// Returns completions for taskId this ISO week that exceed the quota.
// e.g. quota=3, 5 completions this week → 2 Extra Credit completions.
int extraCreditThisWeek(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today,
);

// Returns true if the task's consistencyRatio >= 120.0 AND the task has not
// already triggered an unlock (i.e., its id is not in previouslyUnlocked).
bool shouldTriggerCapacityUnlock(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today,
  Set<String> previouslyUnlocked, {
  int windowWeeks = 6,
});

// Returns the Rank based on total unlock count.
Rank rankFromUnlockCount(int totalUnlocks);

// Returns the adjusted daily energy baseline:
// baselinePoints + (totalCapacityUnlocks * 5).
int adjustedBaseline(int baselinePoints, int totalCapacityUnlocks);
```

**Acceptance criteria** (pure Dart unit tests):
- `extraCreditThisWeek`: quota 3, 5 completions this week → 2. Quota 3, 3 completions → 0. Quota 3, 1 completion → 0.
- `shouldTriggerCapacityUnlock`: ratio ≥ 120% and task not in previouslyUnlocked → true. Ratio ≥ 120% but task already in previouslyUnlocked → false. Ratio < 120% → false.
- `rankFromUnlockCount`: 0 → novice, 1 → adept, 4 → adept, 5 → master, 10 → master.
- `adjustedBaseline`: 80 pts, 3 unlocks → 95 pts. 80 pts, 0 unlocks → 80 pts.
- Extra Credit completions in current week are counted in `extraCreditThisWeek` but do NOT inflate `consistencyRatio` above 100% for the current week (the ratio window counts a week as 1 hit regardless of completions beyond quota).

---

### Task 3 — RankUpEvent model + FirestorePaths update

**File:** `lib/features/gamification/rank_up_event.dart`

**Fields:**

| Field | Type | Notes |
|---|---|---|
| `id` | `String` | |
| `taskId` | `String` | The recurring task that triggered the unlock |
| `triggeredAt` | `DateTime` (UTC) | When the unlock was detected |
| `newBaselinePoints` | `int` | The user's adjusted baseline after this unlock |
| `newRank` | `Rank` | The global rank at the time of this unlock |

Use `@freezed` + `@JsonSerializable`. `Rank` enum must be JSON-serializable
(use `@JsonValue` or a custom converter).

**FirestorePaths update:**
Add `rankUpEvents(String uid)` → `"users/$uid/rank_up_events"`.

**Acceptance criteria:**
- JSON roundtrip preserves all fields including `Rank` enum value.
- `FirestorePaths.rankUpEvents("abc123") == "users/abc123/rank_up_events"`.
- Unit tests cover both.

---

### Task 4 — GamificationRepository & Provider

**File:** `lib/features/gamification/gamification_repository.dart`

**Interface:**

| Method | Return | Behavior |
|---|---|---|
| `watchAllRankUpEvents()` | `Stream<List<RankUpEvent>>` | All events, ordered by triggeredAt asc |
| `addRankUpEvent(RankUpEvent event)` | `Future<void>` | |
| `watchUnlockedTaskIds()` | `Stream<Set<String>>` | The set of taskIds that have ever triggered an unlock |

**Provider:**
- `gamificationRepositoryProvider`
- `rankUpEventsProvider` — `StreamProvider<List<RankUpEvent>>`
- `unlockedTaskIdsProvider` — `StreamProvider<Set<String>>`

**Acceptance criteria** (tests use `fake_cloud_firestore`):
- Given empty collection, `watchAllRankUpEvents` emits empty list.
- After `addRankUpEvent`, `watchAllRankUpEvents` emits a list containing it.
- `watchUnlockedTaskIds` returns the set of distinct taskIds from all events.
- No raw Firestore calls outside repository.

---

### Task 5 — GamificationService providers

**File:** `lib/features/gamification/gamification_service.dart`

Riverpod providers that wire `ConsistencyEngine`, `GamificationEngine`, and the
existing `EnergyEngine`/`EnergyService` together. Not a pure Dart file — Riverpod
imports are fine here.

**Providers to expose:**

```dart
// Map from taskId → consistencyRatio (%) for all recurring tasks with a weeklyQuota.
// Computed from allCompletionsProvider + all recurring tasks.
@riverpod
Map<String, double> taskConsistencyRatios(Ref ref);

// The current global rank derived from unlockedTaskIdsProvider count.
@riverpod
Rank currentRank(Ref ref);

// The adjusted daily energy baseline:
// energyService baseline + (unlockCount * 5).
@riverpod
int adjustedEnergyBaseline(Ref ref);

// Detects any recurring tasks that should now trigger a Capacity Unlock
// (ratio >= 120%, not yet in unlockedTaskIds).
// Returns their taskIds. The caller (future UI sprint) will create RankUpEvents
// and call gamificationRepository.addRankUpEvent().
// This sprint: expose the detection provider only; writing is deferred to a
// future sprint when the UI confirms the unlock to the user.
@riverpod
List<String> pendingCapacityUnlocks(Ref ref);
```

**Acceptance criteria** (unit tests using fakes):
- `taskConsistencyRatios`: given a task with 6/6 weeks at quota, ratio = 100.0.
- `currentRank`: 0 unlocks → Rank.novice; 1 unlock → Rank.adept; 5 unlocks → Rank.master.
- `adjustedEnergyBaseline`: 80-point baseline + 3 unlocks → 95.
- `pendingCapacityUnlocks`: task with ratio ≥ 120% not yet in unlockedTaskIds → appears; task already unlocked → does not appear.

---

## Out of scope for Sprint 9

- Gamification UI (rank display, badge gallery, capacity-unlock animation) — Sprint 13
- Badge engine (volume/consistency/CRM achievements) — Sprint 13
- Writing `RankUpEvent` from UI confirmation — Sprint 13
- CRM integration — Sprint 10

---

## Approval

- [ ] Human operator approved this sprint scope.
