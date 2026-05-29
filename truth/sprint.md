# Sprint 2 — Data Layer Completion

> **Status: AWAITING HUMAN APPROVAL**
> PM wrote this. Dev does not begin until the human operator approves.

**Goal:** Implement Riverpod data providers for Projects, Tasks, and Contexts —
the remaining three domain models from Sprint 1. This completes the full CRUD
data layer and unblocks all future UI sprints.

**Scope:** `lib/features/goals/` (projects, tasks), `lib/shared/` (contexts)

**Sprint type:** Non-UI. Loop: PM → Dev → Optimization → Security → PM closes.

**Environment note:** `flutter analyze` was crashing on the dev machine in
Sprint 1 (missing analysis server snapshot). If still broken, document it in
the handoff and use `dart analyze` as the substitute. The human operator should
fix the toolchain before this sprint begins (see `state.md` locked decisions).

---

### Task 1 — Projects Repository & Provider

**File:** `lib/features/goals/projects_repository.dart`

**`ProjectsRepository` interface:**

| Method | Return type | Behavior |
|---|---|---|
| `watchProjects()` | `Stream<List<Project>>` | Real-time stream of all projects for the user |
| `watchProjectsByGoal(String goalId)` | `Stream<List<Project>>` | Stream filtered to one parent goal |
| `addProject(Project project)` | `Future<void>` | Writes to `projects/{project.id}` |
| `updateProject(Project project)` | `Future<void>` | Overwrites `projects/{project.id}` |
| `deleteProject(String id)` | `Future<void>` | Deletes `projects/{id}` |

**Providers** (using `riverpod_annotation` / `@riverpod`):
- `projectsRepositoryProvider` — provides `ProjectsRepository`
- `projectsStreamProvider` — `StreamProvider<List<Project>>` consuming `watchProjects()`

**Acceptance criteria** (tests use `fake_cloud_firestore`):

- Given an empty collection, when `watchProjects()` emits, then the list is empty
  (no error thrown).
- Given `addProject(projectA)`, when the next `watchProjects()` snapshot emits,
  then the list contains exactly `projectA` (full Freezed equality).
- Given `addProject(projectA)` then `deleteProject(projectA.id)`, when the next
  snapshot emits, then the list is empty.
- Given `addProject(projectA)` then `updateProject(projectA.copyWith(title: "New"))`,
  when the next snapshot emits, then `list[0].title == "New"`.
- Given `addProject(projectA)` and `addProject(projectB)` where `projectA.goalId !=
  projectB.goalId`, when `watchProjectsByGoal(projectA.goalId)` emits, then only
  `projectA` is in the result.
- `projectsStreamProvider` tested with `ProviderContainer`: overriding
  `projectsRepositoryProvider` with a fake, the stream emits the expected values.
- No raw Firestore calls outside of `ProjectsRepository`.

---

### Task 2 — Tasks Repository & Provider

**File:** `lib/features/goals/tasks_repository.dart`

**`TasksRepository` interface:**

| Method | Return type | Behavior |
|---|---|---|
| `watchTasks()` | `Stream<List<Task>>` | Real-time stream of all tasks for the user |
| `watchTasksByParent(String parentId)` | `Stream<List<Task>>` | Stream filtered to one parent (goal or project) |
| `addTask(Task task)` | `Future<void>` | Writes to `tasks/{task.id}` |
| `updateTask(Task task)` | `Future<void>` | Overwrites `tasks/{task.id}` |
| `deleteTask(String id)` | `Future<void>` | Deletes `tasks/{id}` |

**Providers** (using `riverpod_annotation` / `@riverpod`):
- `tasksRepositoryProvider` — provides `TasksRepository`
- `tasksStreamProvider` — `StreamProvider<List<Task>>` consuming `watchTasks()`

**Acceptance criteria** (tests use `fake_cloud_firestore`):

- Given an empty collection, when `watchTasks()` emits, then the list is empty
  (no error thrown).
- Given `addTask(taskA)`, when the next `watchTasks()` snapshot emits, then the
  list contains exactly `taskA` (full Freezed equality).
- Given `addTask(taskA)` then `deleteTask(taskA.id)`, when the next snapshot
  emits, then the list is empty.
- Given `addTask(taskA)` then `updateTask(taskA.copyWith(title: "New"))`, when the
  next snapshot emits, then `list[0].title == "New"`.
- Given `addTask(taskA)` and `addTask(taskB)` where `taskA.parentId != taskB.parentId`,
  when `watchTasksByParent(taskA.parentId)` emits, then only `taskA` is in the result.
- Given a `Task` with `taskType: oneTime` and `weeklyQuota: null`, the add→watch
  roundtrip preserves `weeklyQuota == null` (no coercion).
- Given a `Task` with `taskType: recurring` and `weeklyQuota: 3`, the add→watch
  roundtrip preserves `weeklyQuota == 3`.
- `tasksStreamProvider` tested with `ProviderContainer`: overriding
  `tasksRepositoryProvider` with a fake, the stream emits the expected values.
- No raw Firestore calls outside of `TasksRepository`.

---

### Task 3 — Contexts Repository & Provider

**File:** `lib/shared/contexts_repository.dart`

**`ContextsRepository` interface:**

| Method | Return type | Behavior |
|---|---|---|
| `watchContexts()` | `Stream<List<Context>>` | Real-time stream of all contexts for the user |
| `addContext(Context context)` | `Future<void>` | Writes to `contexts/{context.id}` |
| `updateContext(Context context)` | `Future<void>` | Overwrites `contexts/{context.id}` |
| `deleteContext(String id)` | `Future<void>` | Deletes `contexts/{id}` |

**Providers** (using `riverpod_annotation` / `@riverpod`):
- `contextsRepositoryProvider` — provides `ContextsRepository`
- `contextsStreamProvider` — `StreamProvider<List<Context>>` consuming `watchContexts()`

**Acceptance criteria** (tests use `fake_cloud_firestore`):

- Given an empty collection, when `watchContexts()` emits, then the list is empty
  (no error thrown).
- Given `addContext(ctxA)`, when the next `watchContexts()` snapshot emits, then
  the list contains exactly `ctxA` (full Freezed equality).
- Given `addContext(ctxA)` then `deleteContext(ctxA.id)`, when the next snapshot
  emits, then the list is empty.
- Given `addContext(ctxA)` then `updateContext(ctxA.copyWith(name: "New"))`, when
  the next snapshot emits, then `list[0].name == "New"`.
- Given a `Context` with `colorHex: "FF6B35"`, the add→watch roundtrip preserves
  the exact string `"FF6B35"` (no case mutation or `#` prefix added).
- `contextsStreamProvider` tested with `ProviderContainer`: overriding
  `contextsRepositoryProvider` with a fake, the stream emits the expected values.
- No raw Firestore calls outside of `ContextsRepository`.

---

## Out of scope for Sprint 2

- Any screen/widget UI
- Authentication / real user IDs (continue using `"test_user"` hardcode)
- Energy engine, triage, timer, CRM
- Fixing the `flutter analyze` toolchain crash (environment issue, not app code)

---

## Approval

- [ ] Human operator approved this sprint scope.
