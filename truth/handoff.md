# Habitude — Handoff Thread (current sprint)

> The live working thread for the **current sprint only.** Every agent reads this
> top to bottom on startup for full context, then acts on the **last entry whose
> `TO:` names their role.** Every agent **appends** its result to the bottom on
> finish — never overwrite or edit earlier entries. The **PM clears this file at
> sprint close** and seeds the next sprint's kickoff. See `AGENTS.md` §9.

---

## [S6] PM → Dev — sprint kicked off
STATUS: awaiting-human-approval
SUMMARY: Sprint 6 scoped. Dev does not begin until the human operator approves truth/sprint.md.
DETAILS:
  Sprint 6 builds the timer logic layer only — no UI.

  Four tasks:
    1. Tracker model (Freezed, JSON roundtrip) + FirestorePaths.trackers(uid)
       File: lib/features/timer/tracker.dart

    2. TrackerRepository — addTracker, updateTracker, watchTrackers,
       watchTrackersByTask. No delete (records are permanent history).
       File: lib/features/timer/tracker_repository.dart

    3. TimerState — Freezed value object (NOT JSON-serialized; ephemeral).
       TimerStatus enum: idle | running | paused.
       File: lib/features/timer/timer_state.dart

    4. TimerNotifier — Riverpod Notifier<TimerState> with startTimer, pauseTimer,
       resumeTimer, stopTimer, reconcile methods. Pure helpers: computeElapsed(),
       isComplete(). shared_preferences keys for persistence.
       On stopTimer: updates Tracker + creates TaskCompletion in Firestore.
       On reconcile (build): restores in-progress timer from shared_preferences.
       File: lib/features/timer/timer_notifier.dart

  UTC requirement: all DateTime values (startedAt, stoppedAt, completedAt) must
  use DateTime.now().toUtc().

  No new packages. See truth/sprint.md for full acceptance criteria.

  Environment note: use `dart analyze` as substitute if `flutter analyze` is
  still broken; document in handoff either way.
VERIFICATION:
  n/a (kickoff — awaiting human approval)
---
