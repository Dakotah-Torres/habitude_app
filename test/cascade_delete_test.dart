import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/goals_repository.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/projects_repository.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/goals/tasks_repository.dart';
import 'package:habitude/features/goals/screens/goal_detail_screen.dart';
import 'package:habitude/features/goals/screens/project_detail_screen.dart';
import 'package:habitude/shared/theme.dart';

class FakeGoalsRepository extends Fake implements GoalsRepository {
  final List<String> deletedGoalIds = [];
  Goal? goal;

  @override
  Stream<Goal> watchGoal(String id) => Stream.value(goal!);

  @override
  Future<void> deleteGoal(String id) async {
    deletedGoalIds.add(id);
  }
}

class FakeProjectsRepository extends Fake implements ProjectsRepository {
  final List<String> deletedProjectIds = [];
  List<Project> projects = [];

  @override
  Stream<Project> watchProject(String id) =>
      Stream.value(projects.firstWhere((p) => p.id == id));

  @override
  Stream<List<Project>> watchProjectsByGoal(String goalId) =>
      Stream.value(projects);

  @override
  Future<void> deleteProject(String id) async {
    deletedProjectIds.add(id);
  }
}

class FakeTasksRepository extends Fake implements TasksRepository {
  final List<String> deletedTaskIds = [];
  List<Task> tasks = [];

  @override
  Stream<List<Task>> watchTasksByParent(String parentId) =>
      Stream.value(tasks.where((t) => t.parentId == parentId).toList());

  @override
  Future<void> deleteTask(String id) async {
    deletedTaskIds.add(id);
  }
}

void main() {
  late FakeGoalsRepository fakeGoalsRepo;
  late FakeProjectsRepository fakeProjectsRepo;
  late FakeTasksRepository fakeTasksRepo;

  setUp(() {
    fakeGoalsRepo = FakeGoalsRepository();
    fakeProjectsRepo = FakeProjectsRepository();
    fakeTasksRepo = FakeTasksRepository();
  });

  group('Cascade Delete', () {
    testWidgets('GoalDetailScreen delete → deletes all projects and tasks', (
      tester,
    ) async {
      final goal = Goal(
        id: 'g1',
        title: 'Goal 1',
        type: GoalType.continuous,
        createdAt: DateTime.now(),
      );
      final projects = [
        Project(
          id: 'p1',
          goalId: 'g1',
          title: 'Project 1',
          status: ProjectStatus.active,
          createdAt: DateTime.now(),
        ),
      ];
      final tasks = [
        Task(
          id: 't1',
          parentId: 'p1',
          parentType: ParentType.project,
          title: 'Task 1',
          energyScore: 10,
          taskType: TaskType.oneTime,
          createdAt: DateTime.now(),
        ),
      ];

      fakeGoalsRepo.goal = goal;
      fakeProjectsRepo.projects = projects;
      fakeTasksRepo.tasks = tasks;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            goalsRepositoryProvider.overrideWithValue(fakeGoalsRepo),
            projectsRepositoryProvider.overrideWithValue(fakeProjectsRepo),
            tasksRepositoryProvider.overrideWithValue(fakeTasksRepo),
            // Streams are overridden by the fake repositories above
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const GoalDetailScreen(goalId: 'g1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open menu in AppBar
      await tester.tap(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(PopupMenuButton<String>),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Delete
      await tester.tap(find.text('Delete goal'));
      await tester.pumpAndSettle();

      // Confirm in dialog
      await tester.tap(find.text('Delete goal'));

      // We expect a loading state now
      await tester.pump();
      expect(
        find.text('Deleting goal and all nested items...'),
        findsOneWidget,
      );

      await tester.pumpAndSettle();

      expect(fakeTasksRepo.deletedTaskIds, contains('t1'));
      expect(fakeProjectsRepo.deletedProjectIds, contains('p1'));
      expect(fakeGoalsRepo.deletedGoalIds, contains('g1'));
    });

    testWidgets('ProjectDetailScreen delete → deletes all tasks', (
      tester,
    ) async {
      final project = Project(
        id: 'p1',
        goalId: 'g1',
        title: 'Project 1',
        status: ProjectStatus.active,
        createdAt: DateTime.now(),
      );
      final tasks = [
        Task(
          id: 't1',
          parentId: 'p1',
          parentType: ParentType.project,
          title: 'Task 1',
          energyScore: 10,
          taskType: TaskType.oneTime,
          createdAt: DateTime.now(),
        ),
      ];

      fakeProjectsRepo.projects = [project];
      fakeTasksRepo.tasks = tasks;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectsRepositoryProvider.overrideWithValue(fakeProjectsRepo),
            tasksRepositoryProvider.overrideWithValue(fakeTasksRepo),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ProjectDetailScreen(projectId: 'p1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Open menu in AppBar
      await tester.tap(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.byType(PopupMenuButton<String>),
        ),
      );
      await tester.pumpAndSettle();

      // Tap Delete
      await tester.tap(find.text('Delete project'));
      await tester.pumpAndSettle();

      // Confirm in dialog
      await tester.tap(find.text('Delete project'));

      await tester.pump();
      expect(find.text('Deleting project and tasks...'), findsOneWidget);

      await tester.pumpAndSettle();

      expect(fakeTasksRepo.deletedTaskIds, contains('t1'));
      expect(fakeProjectsRepo.deletedProjectIds, contains('p1'));
    });
  });
}
