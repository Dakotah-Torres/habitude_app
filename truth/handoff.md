# Habitude — Handoff Thread (current sprint)

> The live working thread for the **current sprint only.** Every agent reads this
> top to bottom on startup for full context, then acts on the **last entry whose
> `TO:` names their role.** Every agent **appends** its result to the bottom on
> finish — never overwrite or edit earlier entries. The **PM clears this file at
> sprint close** and seeds the next sprint's kickoff. See `AGENTS.md` §9.

---

## [S2] PM → Dev — sprint kicked off
STATUS: awaiting-human-approval
SUMMARY: Sprint 2 scoped. Dev does not begin until the human operator approves truth/sprint.md.
DETAILS:
  Sprint 2 builds the remaining three data-layer repositories: Projects, Tasks,
  and Contexts. The pattern mirrors Sprint 1's GoalsRepository exactly — Freezed
  models already exist; only repositories and providers need to be implemented.

  Key files to create:
    lib/features/goals/projects_repository.dart
    lib/features/goals/tasks_repository.dart
    lib/shared/contexts_repository.dart

  All tests use fake_cloud_firestore (already in dev_dependencies). Hardcode
  "test_user" for UID as in Sprint 1 (auth deferred). See truth/sprint.md for
  the full task list and acceptance criteria.

  Environment note: flutter analyze was crashing in Sprint 1 (missing analysis
  server snapshot). If still broken, use `dart analyze` as the substitute and
  document it in your handoff. The human operator should fix the toolchain before
  this sprint begins (see truth/state.md locked decisions).
VERIFICATION:
  n/a (kickoff — awaiting human approval)
---
