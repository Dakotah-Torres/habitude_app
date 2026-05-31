# Habitude — Handoff Thread (current sprint)

> The live working thread for the **current sprint only.** Every agent reads this
> top to bottom on startup for full context, then acts on the **last entry whose
> `TO:` names their role.** Every agent **appends** its result to the bottom on
> finish — never overwrite or edit earlier entries. The **PM clears this file at
> sprint close** and seeds the next sprint's kickoff. See `AGENTS.md` §9.

---

## [S10] PM → Designer — pre-spec requested
STATUS: approved
SUMMARY: Sprint 10 approved by human operator. Designer to pre-spec the WelcomeScreen — the app's first-launch onboarding surface — before Dev builds.
DETAILS:
  Sprint 10 is a UI sprint. Loop:
    PM → Designer (pre-spec) → Dev → Designer (UI review) → Optimization → Security → PM closes.

  Designer's job (Phase A):
    Append "Sprint 10 visual spec — Welcome Screen" to truth/design.md.
    One surface: WelcomeScreen.
    Required spec elements:
      - Full layout: app name, one-line tagline ("manage energy, not time"),
        optional subtle hero element (described in words), privacy reassurance line,
        two primary tap targets.
      - Option 1 "Continue without account": the default, low-friction path.
        Copy must not use language like "Limited mode" or "Offline only" — the
        local mode is a full first-class path, not a downgrade.
      - Option 2 "Sign in / Create account": the cloud-sync path. In Sprint 10
        this wires up anonymous auth as a placeholder; real sign-in is Sprint 15.
        Copy should frame this as unlocking sync, not fixing a deficiency.
      - Transition out of the screen (e.g., fade to RootScreen). Lightweight —
        no carousel.
      - Design constraints: Sedona Sunset palette, Material 3, calm by default,
        no more than two primary tap targets, screen never shown again after choice.

  Key Dev constraints (carry forward):
    - Three new packages are pre-approved for Sprint 10 only:
        drift (+ drift_flutter) and sqlite3_flutter_libs.
      No other packages without PM sign-off.
    - All DateTime values must use DateTime.now().toUtc() / stored as UTC ISO 8601.
    - No raw Firestore calls in screen/widget files.
    - Local mode must skip Firebase initialization entirely.
    - Repository providers must transparently switch implementations based on
      StorageMode — no feature code should reference local/Firestore repos directly.

  Sprint 10 has 7 Dev tasks (see truth/sprint.md for full acceptance criteria):
    Task 1: StorageMode enum + storageModeProvider + isOnboardingCompleteProvider
    Task 2: AppDatabase (drift) — 8 tables mirroring all domain models
    Task 3: Abstract repository interfaces + Firestore repos implement them
    Task 4: Local repository implementations (8 files, drift-backed)
    Task 5: Repository provider factory (switches on StorageMode)
    Task 6: MigrationService (local → Firestore, one-way)
    Task 7: WelcomeScreen (per Designer spec) + main.dart onboarding gate
VERIFICATION:
  n/a (kickoff — awaiting human approval)
---
