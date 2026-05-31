# Habitude — Handoff Thread (current sprint)

> The live working thread for the **current sprint only.** Every agent reads this
> top to bottom on startup for full context, then acts on the **last entry whose
> `TO:` names their role.** Every agent **appends** its result to the bottom on
> finish — never overwrite or edit earlier entries. The **PM clears this file at
> sprint close** and seeds the next sprint's kickoff. See `AGENTS.md` §9.

---

## [S9] PM → Dev — kickoff
STATUS: approved
SUMMARY: Sprint 9 approved by human operator. Dev to build the Gamification Engine: ConsistencyEngine, GamificationEngine, RankUpEvent model/repo, and GamificationService providers.
DETAILS:
  Sprint 9 is a non-UI sprint. Loop:
    PM → Dev → Optimization → Security → PM closes.

  Five tasks — all in lib/features/gamification/:
    Task 1: ConsistencyEngine (pure Dart)
      - consistency_engine.dart
      - weeksHittingQuota(), evaluationWindowSize(), consistencyRatio()
      - Rolling 6-week ISO-week window; ratio = weeksHittingQuota / windowSize * 100
      - Extra Credit week still counts as 1 hit (not inflated)
    Task 2: GamificationEngine (pure Dart)
      - gamification_engine.dart
      - extraCreditThisWeek(), shouldTriggerCapacityUnlock(), rankFromUnlockCount(),
        adjustedBaseline()
      - Capacity Unlock fires when consistencyRatio >= 120% and taskId not yet unlocked
      - Rank: Novice (0), Adept (1–4), Master (5+)
    Task 3: RankUpEvent model + FirestorePaths
      - rank_up_event.dart — @freezed model with id, taskId, triggeredAt (UTC),
        newBaselinePoints, newRank
      - Add rankUpEvents(String uid) to lib/shared/firestore_paths.dart
    Task 4: GamificationRepository + providers
      - gamification_repository.dart
      - watchAllRankUpEvents(), addRankUpEvent(), watchUnlockedTaskIds()
      - Providers: gamificationRepositoryProvider, rankUpEventsProvider,
        unlockedTaskIdsProvider
    Task 5: GamificationService providers
      - gamification_service.dart
      - taskConsistencyRatios, currentRank, adjustedEnergyBaseline,
        pendingCapacityUnlocks providers

  Key constraints:
    - consistency_engine.dart and gamification_engine.dart must be pure Dart:
      no Flutter, Riverpod, or Firestore imports.
    - gamification_service.dart may use Riverpod — it is the wiring layer.
    - All DateTime values use UTC (DateTime.now().toUtc(), DateTime.utc(...)).
    - No new packages without PM sign-off.
    - No raw Firestore calls outside the repository.
    - Tests: pure Dart unit tests for engines; fake_cloud_firestore for repository;
      Riverpod fakes for service providers.

  Existing providers to wire into GamificationService:
    - EnergyService baseline (Sprint 4) — lib/features/energy/energy_service.dart
    - TasksRepository / tasksProvider (Sprint 2) — for recurring tasks list
    - TaskCompletionRepository / allCompletionsProvider (Sprint 4) — for completions

  See truth/sprint.md for full acceptance criteria per task.
VERIFICATION:
  n/a (kickoff — awaiting human approval)
---
