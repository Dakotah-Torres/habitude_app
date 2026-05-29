# AGENTS.md — Habitude

Authoritative rules for **every** agent working in this repo, regardless of tool
(Claude Code, Codex CLI, Gemini CLI). Read this in full before acting.

The detailed feature spec lives in `truth/spec.md`. **This file is rules only —
keep it lean.** Do not append spec detail here.

---

## 1. What this is

Habitude is an executive-function, time-management, and relationship-management
app for neurodivergent (AuADHD) users.

**Core philosophy: manage cognitive *capacity*, not time. Reward the *process* of
focusing, forgive interruptions, and eliminate the shame of broken streaks.**

When a decision is ambiguous, lean toward forgiveness and reducing user
friction/shame. This principle outranks feature-completeness — if a "correct"
implementation would punish the user for a missed day or a runaway timer, it is
wrong for this app.

---

## 2. Stack (locked)

- **Framework:** Flutter
- **Backend:** Firebase
- **State management:** Riverpod

No agent may add, remove, or swap a dependency without explicit **PM sign-off
recorded in `truth/state.md`.**

**Open decision — PM must finalize before Sprint 1:** the background-execution and
local-notification packages powering the Overtime Mechanic and the Dead-Man's
Switch (candidates: `flutter_local_notifications`, `workmanager`). Timer behavior
**must** survive app-backgrounding and device lock. Do not implement timer
persistence until these packages are locked in `state.md`.

---

## 3. Structure & naming

**Feature-first.** Group by domain, not by layer. Each feature folder owns its own
widgets, providers, and models.

```
lib/
  features/
    goals/      # Goals → Projects → Tasks hierarchy
    energy/     # Energy budgeting engine
    triage/     # Brain Dump inbox + morning triage funnel
    timer/      # Trackers, overtime mechanic, dead-man's switch
    crm/        # Personal relationship builder
  shared/       # Cross-feature widgets, utils, theme, types
```

- Files: `snake_case.dart`
- Classes / enums: `PascalCase`
- Variables / functions: `camelCase`
- One feature = one folder. Do **not** scatter a feature's files across `shared/`.
- Only put something in `shared/` if two or more features genuinely use it.

---

## 4. Definition of Done

An agent may report `done` **only** when ALL of the following are true:

1. Code compiles and runs.
2. Tests are written against the sprint's acceptance criteria, **and they pass.**
3. The conventions in this file are followed.
4. A line has been appended to `truth/journal.md` (see §7).
5. A handoff report has been emitted (see §6).

"Done" is this checklist — never a judgment call or a feeling.

---

## 5. The truth files (shared memory)

All agents read these on startup and treat them as ground truth.

- `truth/spec.md` — the full feature spec. *What* to build. Stable.
- `truth/state.md` — living project state: current sprint, what's done, open
  decisions and the reasoning behind them. **PM owns it and updates it each sprint.**
- `truth/sprint.md` — the current sprint's tasks, each with explicit acceptance
  criteria. **PM writes it.**
- `truth/journal.md` — append-only, permanent one-line activity log (see §7).
- `truth/handoff.md` — the live handoff thread for the **current sprint** (see §9).
  This is the working context every agent reads on startup and appends to on finish.

---

## 6. The fleet & the loop

Five roles. The loop depends on whether the sprint touches UI.

**Non-UI sprint** (data layer, logic, infra):
**PM → Dev → Optimization → Security → (fixes → Dev → re-review) → PM closes.**

**UI sprint** (any sprint building or changing screens):
**PM → Designer (pre-spec) → Dev → Designer (UI review) → Optimization → Security → PM closes.**

- **PM** — decomposes the spec into `sprint.md`, does the final-pass approval,
  updates `state.md`. Acts as **tie-breaker** (see §8). Decides whether a sprint is
  a UI sprint and therefore involves the Designer.
- **Designer** — owns `truth/design.md` (the design system). On a UI sprint, first
  produces the visual spec for that sprint's screens **before** the Dev builds, then
  **reviews** the built UI against `design.md`; **approves or returns a fix list**
  to Dev. Sits out non-UI sprints entirely.
- **Dev** — builds the sprint tasks and their tests. On UI sprints, builds against
  the Designer's spec. Hands to Designer (UI) or Optimization (non-UI).
- **Optimization** — reviews the diff, removes dead/unused code, improves clarity
  and performance; **approves or returns a fix list** to Dev.
- **Security** — reviews for vulnerabilities and unsafe patterns; **approves or
  returns a fix list** to Dev.

Every handoff is written to `truth/handoff.md` (see §9), not just printed to the
terminal. The human operator no longer relays messages between agents — the file
carries them.

---

## 7. The journal rule

Every agent appends **one line** to `truth/journal.md` per action taken.
**Never edit or delete existing lines** — the journal is append-only.

Format:

```
[S<sprint#>][Role] What you did. → NextRole
```

Example:

```
[S1][Dev] Implemented energy baseline calc, 7-day rolling avg. Tests pass. → Optimization
[S1][Opt] Baseline recalculated on every render; memoized it. → Security
```

On startup, **read the journal first** to pick up the thread of what has happened.

---

## 8. The tie-breaker

If two agents give conflicting instructions (e.g. Optimization and Security
disagree), **do not try to satisfy both.** Stop. Write the conflict into your
handoff entry's `DETAILS` field and **escalate to the PM.** The PM — or the human
operator — rules. One arbiter, always. This is what prevents infinite
Optimization↔Security loops.

---

## 9. The handoff file (`truth/handoff.md`)

This is how agents pass work without the human relaying it. It holds the **full
running thread of the current sprint** — every handoff, in order — so any agent
that picks up the baton has the complete context of what has happened this sprint.

### On startup (every agent)
1. Read your role brief in `agents/`.
2. Read `truth/handoff.md` **top to bottom** for the full sprint context.
3. Act on the **last entry whose `TO:` field names your role.** Everything above it
   is context, not your current instruction.

### On finish (every agent)
**Append** a new entry to the **bottom** of `truth/handoff.md`. Never overwrite or
edit earlier entries — it is append-only within a sprint. Newest entry is always
last.

### Entry format

```
## [S<sprint#>] <FromRole> → <ToRole> — <status>
STATUS: approved | changes-requested | blocked
SUMMARY: one or two sentences.
DETAILS:
  <Everything the next agent needs to act WITHOUT asking a follow-up.>
VERIFICATION:
  <Exact command output: what `flutter analyze`, `flutter test`, etc. printed.>
---
```

### The detail rule (critical)
A handoff entry must be **self-sufficient.** Because no human is trimming or
relaying it, include the full picture:

- **Kickbacks to Dev (Optimization or Security):** list *every* issue with (a) the
  reason it's a problem, (b) the exact file and line, (c) the verbatim error or
  warning output, and (d) severity. The Dev must be able to fix everything from the
  entry alone.
- **Dev → reviewer:** what was built, which files changed, what the tests cover,
  and any known gaps or assumptions.
- **Escalation → PM:** the conflict, both positions in full, and the context needed
  to rule.

When in doubt, include more. Over-detailing a handoff costs nothing; an
under-detailed one forces a wasted round trip.

### Clearing the thread (PM only)
At **sprint close**, after rolling the outcome into `state.md` and `journal.md`,
the **PM clears `truth/handoff.md`** and seeds it with the kickoff entry for the
next sprint. No other agent ever clears it. `journal.md` remains the permanent
record; `handoff.md` only ever holds the sprint in progress.

