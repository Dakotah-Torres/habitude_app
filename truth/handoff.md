# Habitude — Handoff Thread (current sprint)

> The live working thread for the **current sprint only.** Every agent reads this
> top to bottom on startup for full context, then acts on the **last entry whose
> `TO:` names their role.** Every agent **appends** its result to the bottom on
> finish — never overwrite or edit earlier entries. The **PM clears this file at
> sprint close** and seeds the next sprint's kickoff. See `AGENTS.md` §9.

---

## [S8] PM → Designer — pre-spec requested
STATUS: approved
SUMMARY: Sprint 8 approved by human operator 2026-05-31. Designer to pre-spec BrainDumpScreen, TriageFunnelScreen, and the navigation entry point.
DETAILS:
  Sprint 8 is a UI sprint. Loop:
    PM → Designer (pre-spec) → Dev → Designer (UI review) → Optimization → Security → PM closes.

  Designer's job (Phase A):
    Append "Sprint 8 visual spec — Brain Dump + Triage" to truth/design.md.
    Cover three surfaces:
      1. BrainDumpScreen — inbox list, text capture, delete, "Start Triage" action,
         empty state.
      2. TriageFunnelScreen — one-card-at-a-time, swipe gestures for Do Today /
         Tomorrow / Remove, card content for BrainDumpItem vs recurring Task,
         swipe direction indicators, "All caught up!" completion state.
      3. Navigation entry point — where in the existing app the user reaches
         BrainDumpScreen (bottom nav, GoalsListScreen app bar icon, etc.).
         If a bottom nav bar is introduced, spec the full tab structure.

    Design constraints: Sedona Sunset palette, Material 3, core philosophy
    (triage is frictionless; backlogging and removing are not failure).
    See truth/sprint.md Phase A for the full per-surface detail requirements.

  Key Dev constraints (carry forward):
    - No new packages without PM sign-off.
    - All DateTime values must use DateTime.now().toUtc().
    - "Schedule" / "Do Today" = set scheduledForDate = today.toUtc() on
      BrainDumpItem. Calendar drag-drop is Sprint 11.
    - No raw Firestore calls in screen/widget files.
VERIFICATION:
  n/a (kickoff — awaiting human approval)
---

## [S8] Designer → Dev — approved
STATUS: approved
SUMMARY: Added the Sprint 8 Brain Dump + Triage visual spec to truth/design.md. Dev can build BrainDumpScreen, TriageFunnelScreen, and the root navigation entry point against that spec.
DETAILS:
  Updated truth/design.md with a new section titled "Sprint 8 visual spec — Brain Dump + Triage".

  The spec covers:
    - Shared triage principles: reduce cognitive load, no shame language, backlogging/removing as valid decisions, large cards, explicit buttons plus gestures, visible swipe direction hints.
    - Navigation entry point: introduce a Material 3 bottom NavigationBar at the root with two tabs: Goals and Dump. Timer remains task-driven and is not a bottom tab.
    - BrainDumpScreen: capture-first layout, multi-line input, Add button, active inbox list, relative timestamps, Start triage affordance, empty/loading/error states, delete/remove with undo preferred or confirmation fallback.
    - TriageFunnelScreen: one-card-at-a-time layout, progress text, large card, explicit Tomorrow/Remove/Do Today controls, right/left/down swipe mapping, resting swipe indicators, BrainDumpItem and recurring Task card content.
    - Triage actions: Do Today schedules brain dump items for today or completes recurring tasks; Tomorrow backlogs brain dump items or no-ops recurring tasks; Remove deletes brain dump items or no-ops recurring tasks.
    - Completion state: "All caught up!" with supportive copy and Done action.

  Key constraints for Dev:
    - No new packages.
    - No raw Firestore calls in screens/widgets.
    - All new DateTime values must use DateTime.now().toUtc().
    - Date-only values for scheduledForDate and backloggedUntil should be normalized to the UTC calendar date.
    - Do not build a calendar picker or schedule-to-specific-date flow this sprint.
    - Use built-in Flutter navigation; no routing package.
VERIFICATION:
  Read agents/designer.md, truth/handoff.md, truth/journal.md, truth/sprint.md, truth/design.md, and the current feature file list. Ran `tail -n 260 truth/design.md` and `git diff -- truth/design.md`; both confirmed the Sprint 8 visual spec was appended. No code was compiled because this Designer pre-spec changed documentation only.
---
