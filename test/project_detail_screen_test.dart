import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/projects_repository.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/goals/tasks_repository.dart';
import 'package:habitude/features/goals/screens/project_detail_screen.dart';
import 'package:habitude/shared/theme.dart';

void main() {
  group('ProjectDetailScreen', () {
    testWidgets('rendered with project and 3 fake tasks → 3 items visible', (
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
        Task(
          id: 't2',
          parentId: 'p1',
          parentType: ParentType.project,
          title: 'Task 2',
          energyScore: 20,
          taskType: TaskType.recurring,
          weeklyQuota: 3,
          createdAt: DateTime.now(),
        ),
        Task(
          id: 't3',
          parentId: 'p1',
          parentType: ParentType.project,
          title: 'Task 3',
          energyScore: 30,
          taskType: TaskType.oneTime,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectStreamProvider(
              'p1',
            ).overrideWith((ref) => Stream.value(project)),
            tasksByParentStreamProvider(
              'p1',
            ).overrideWith((ref) => Stream.value(tasks)),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ProjectDetailScreen(projectId: 'p1'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Project 1'), findsOneWidget);
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('Task 3'), findsOneWidget);
      expect(find.byType(Card), findsNWidgets(3));
    });

    testWidgets('does not render tasks with a non-project parent type', (
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
          title: 'Project Task',
          energyScore: 10,
          taskType: TaskType.oneTime,
          createdAt: DateTime.now(),
        ),
        Task(
          id: 't2',
          parentId: 'p1',
          parentType: ParentType.goal,
          title: 'Goal Task',
          energyScore: 10,
          taskType: TaskType.oneTime,
          createdAt: DateTime.now(),
        ),
      ];

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectStreamProvider(
              'p1',
            ).overrideWith((ref) => Stream.value(project)),
            tasksByParentStreamProvider(
              'p1',
            ).overrideWith((ref) => Stream.value(tasks)),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ProjectDetailScreen(projectId: 'p1'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      expect(find.text('Project Task'), findsOneWidget);
      expect(find.text('Goal Task'), findsNothing);
    });

    testWidgets('tap delete task → show confirmation dialog', (tester) async {
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

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            projectStreamProvider(
              'p1',
            ).overrideWith((ref) => Stream.value(project)),
            tasksByParentStreamProvider(
              'p1',
            ).overrideWith((ref) => Stream.value(tasks)),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const ProjectDetailScreen(projectId: 'p1'),
          ),
        ),
      );

      await tester.pump();
      await tester.pump();

      // Tap the overflow menu (PopupMenuButton) in the task card
      await tester.tap(
        find.descendant(
          of: find.byType(Card),
          matching: find.byType(PopupMenuButton<String>),
        ),
      );
      await tester.pumpAndSettle();

      // Tap 'Delete task'
      await tester.tap(find.text('Delete task'));
      await tester.pumpAndSettle();

      // Check for AlertDialog
      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.textContaining('Delete "Task 1"?'), findsOneWidget);
    });
  });
}
