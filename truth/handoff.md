# Habitude — Handoff Thread (current sprint)

> The live working thread for the **current sprint only.** Every agent reads this
> top to bottom on startup for full context, then acts on the **last entry whose
> `TO:` names their role.** Every agent **appends** its result to the bottom on
> finish — never overwrite or edit earlier entries. The **PM clears this file at
> sprint close** and seeds the next sprint's kickoff. See `AGENTS.md` §9.

---

## [S7] PM → Designer — pre-spec requested
STATUS: approved
SUMMARY: Sprint 7 approved by human operator 2026-05-30. Designer to pre-spec TimerScreen, overtime mode, "Still Focusing?" modal, and "Focus" action on task cards.
DETAILS:
  Sprint 7 is a UI sprint. The loop is:
    PM → Designer (pre-spec) → Dev → Designer (UI review) → Optimization → Security → PM closes.

  Designer's job (Phase A):
    Append "Sprint 7 visual spec — Timer UI" to truth/design.md. Cover:
      1. TimerScreen (countdown mode) — layout, task title, timer display (MM:SS),
         progress indicator, Pause + Stop controls, navigation.
      2. TimerScreen (overtime mode) — how UI shifts when Pomodoro completes,
         counting-up display, positive/forgiving framing for the hyperfocus state.
      3. "Still Focusing?" in-app modal — copy, two actions (Yes / Stop timer),
         calm non-shaming tone.
      4. "Focus" action on task cards in ProjectDetailScreen — tap target location.
      5. Notification copy (for Dev reference):
           a. Foreground service status bar (countdown + overtime variants)
           b. "Still Focusing?" check-in (title + body + two action button labels)
           c. Auto-stop / Dead-Man's Switch notification (calm, non-shaming)

    Design constraints: Sedona Sunset palette, Material 3 base, reward hyperfocus
    (overtime is positive), never shame the user (DMS auto-stop is protective).
    Pause and Stop must be visually distinct.

  No new packages — flutter_foreground_task and flutter_local_notifications are
  already in pubspec from Job Zero.

  See truth/sprint.md for full Dev acceptance criteria.
VERIFICATION:
  n/a (kickoff — awaiting human approval)
---

## [S7] Designer → Dev — approved
STATUS: approved
SUMMARY: Added the Sprint 7 Timer UI visual spec to truth/design.md. Dev can build TimerScreen, overtime mode, check-in modal, task-card Focus action, and notification copy against that spec.
DETAILS:
  Updated truth/design.md with a new section titled "Sprint 7 visual spec — Timer UI".

  The spec covers:
    - Shared timer principles: low-clutter, timer-first layout, tabular numerals, Sedona Sunset palette, calm countdown, earned/positive overtime, visually distinct Pause vs Stop.
    - TimerScreen countdown mode: route/source from ProjectDetailScreen task cards, task title, MM:SS countdown, progress ring/bar, Pause/Resume, Stop confirmation, start-failure and existing-timer states.
    - TimerScreen overtime mode: stable layout shift, +MM:SS / +H:MM:SS count-up display, "Overtime" label, positive hyperfocus copy, ember/pricklyPear used sparingly.
    - "Still Focusing?" modal: trigger from awaitingCheckIn, calm copy, "Yes, still here" and "Stop timer" actions, non-shaming protective tone.
    - "Focus" action on task cards: visible tap target, recommended trailing compact play/Focus button, no hiding the primary focus workflow behind overflow/long-press only.
    - Notification copy for countdown foreground service, overtime foreground service, Pomodoro completion, Still Focusing check-in actions, and Dead-Man's Switch auto-stop.

  Key constraints for Dev:
    - No new packages.
    - No raw Timer/Timer.periodic in TimerScreen; all ticking remains in TimerNotifier.
    - No raw Firestore calls in screens/widgets.
    - All new DateTime values for timer/notifications/DMS must use DateTime.now().toUtc().
    - Document emulator/device manual verification for foreground service and notifications in Dev handoff.
    - Pause and Stop must remain visually distinct; Stop requires confirmation.
VERIFICATION:
  Read agents/designer.md, truth/handoff.md, truth/journal.md, truth/sprint.md, truth/design.md, and current timer/goals screen file list. Ran `tail -n 240 truth/design.md` and `git diff -- truth/design.md`; both confirmed the Sprint 7 visual spec was appended. No code was compiled because this Designer pre-spec changed documentation only.
---
