# Habitude — Feature Specification

> The authoritative description of *what* to build. Stable. Agents read this for
> requirements. Day-to-day rules and conventions live in `AGENTS.md`; current
> progress lives in `state.md`.

**Target audience:** Neurodivergent users (specifically AuADHD) seeking an
executive function, time-management, and relationship-management tool.

**Core philosophy:** Manage *cognitive capacity*, not just time. Reward the
*process* of focusing, forgive the interruptions, and eliminate the "shame spiral"
of broken streaks.

---

## 1. Data Architecture & Hierarchy

A rigid, memory-efficient data structure that keeps visual clutter low.

- **Goals (Macro):** Top-level containers. Can be continuous (e.g. "Health") or
  finite (e.g. "Learn Rust"). Holds Projects, standalone Tasks, and Trackers.
- **Projects (Tactical):** Finite containers with strict completion states or end
  dates. Exclusively holds Tasks.
- **Tasks (Operational):** The actionable items. Assigned an "Energy Score." Can be
  One-Time (archived on completion) or Recurring (resets based on quota rules).
- **Trackers (Atomic):** The execution engine. Pomodoro-style timers attached to
  Tasks that log focused time and roll "XP" upward through the hierarchy.
- **Contexts (Visual Organization):** Customizable categories (e.g. "Deep Work",
  "Admin") tied to a user-defined color palette. Colors propagate through the
  calendar to create visual energy maps.

## 2. Frictionless Capture & Triage Mode

Designed to eliminate entry friction and decision fatigue.

- **Voice-to-Text OS Hook:** Exposes an intent to native OS assistants
  (Siri/Google Assistant) allowing users to dictate tasks directly into the app
  without opening it.
- **The Brain Dump Inbox:** A raw text database for unassigned thoughts.
- **Morning Triage Funnel:** A daily UI prompt that displays Brain Dump items and
  pending recurring tasks one card at a time. The user has only three actions
  (Tinder-style swipe interface):
  - **Schedule:** Drop onto the daily calendar.
  - **Backlog:** Snooze until tomorrow's Triage.
  - **Remove:** Delete permanently.

## 3. The Energy Budgeting Engine

Replaces traditional time management with cognitive capacity management.

- **Daily Energy Baseline:** A dynamic score based on a rolling 7-day average of
  completed task points (e.g. user averages 80 points/day).
- **Task Energy Cost:** Users assign an Energy Score to every Task (e.g. Email = 10
  pts, Coding = 40 pts).
- **The "Energy Tax" (Fixed Events):** Hard-scheduled events (meetings, classes)
  are assigned energy costs. The app deducts these from the Daily Baseline *before*
  the day begins, presenting the user with their Net Discretionary Energy.
- **Capacity Warning:** If a user schedules Tasks that exceed their Net
  Discretionary Energy, the UI triggers a visual burnout warning.

## 4. Execution Layer: Timers & Calendar

Optimized for the AuADHD hyperfocus state, with built-in safeguards for time
blindness.

- **Drag-and-Drop Scheduling:** Users drag Tasks into the Calendar view. Block size
  is dictated by the estimated focus duration.
- **In-Calendar Launch:** Focus Trackers can be started directly from the Calendar
  block.
- **The Overtime Mechanic:** When a Tracker hits zero, it plays a brief,
  non-intrusive audio cue (a "slight chirp") and triggers a native push
  notification (e.g. *"Focus goal reached! Timer is now tracking overtime."*). It
  then seamlessly transitions to counting *up* to reward hyperfocus.
- **The "Still Focusing?" Check-In:** During Overtime, the app triggers a modal and
  soft notification every 30 minutes asking if the user is still active.
- **The Dead-Man's Switch (Auto-Pause):** The user must tap "Yes" on the check-in
  to keep the timer running. If there is no response within 5 minutes, the Tracker
  automatically stops. The app only logs time up to the *last confirmed check-in*,
  protecting the user's Energy Baseline from runaway timers.

## 5. Gamification & Progression System

Replaces punishing streaks with a forgiving, RPG-style leveling engine.

- **Flexible Quotas:** Recurring tasks are given weekly targets (e.g. "3x a week").
  Once the target is hit, the task stops appearing in the daily Triage.
- **Rolling Consistency Ratios:** Replaces consecutive streaks. Tracked as a
  fraction (e.g. 5/6 completions). Missing a day lowers the percentage but does not
  reset progress to zero.
- **Extra Credit:** Users can manually trigger completed tasks beyond their quota to
  "heal" damaged consistency ratios from previous weeks.
- **Stat Boosts & Rank Ups:** If a user achieves a 120% Consistency Ratio via Extra
  Credit, they trigger a Capacity_Unlock. This permanently increases their Daily
  Energy Baseline (e.g. from 80 to 85) and contributes to global Rank promotions
  (e.g. Novice → Adept → Master).
- **Badge Engine:** Unlockable achievements for volume (hours focused), consistency,
  and CRM engagement.

## 6. Personal Relationship Builder (CRM)

Serves as an external "object permanence" drive for personal relationships.

- **Contact Sync & Folders:** Pulls native contacts; allows grouping into custom
  folders (e.g. "Inner Circle," "Mentors").
- **Cadence Rules:** Users assign follow-up frequencies to individuals or folders
  (e.g. "Every 14 days").
- **Automated Nudges:** When a cadence timer expires, the app automatically
  generates a standalone task ("Follow up with [Name]") and injects it into the
  morning Triage flow.
