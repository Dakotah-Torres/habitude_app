import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/goals/tasks_repository.dart';
import 'package:habitude/features/goals/screens/task_form_screen.dart';
import 'package:habitude/shared/theme.dart';

class FakeTasksRepository extends Fake implements TasksRepository {
  Task? lastAddedTask;
  Task? lastUpdatedTask;

  @override
  Future<void> addTask(Task task) async {
    lastAddedTask = task;
  }

  @override
  Future<void> updateTask(Task task) async {
    lastUpdatedTask = task;
  }
}

void main() {
  late FakeTasksRepository fakeRepository;

  setUp(() {
    fakeRepository = FakeTasksRepository();
  });

  group('TaskFormScreen', () {
    testWidgets('create mode → fill → save → addTask called', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tasksRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TaskFormScreen(
              parentId: 'p1',
              parentType: ParentType.project,
            ),
          ),
        ),
      );

      await tester.enterText(find.byType(TextFormField).at(0), 'New Task');
      await tester.enterText(find.byType(TextFormField).at(1), '42');
      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(fakeRepository.lastAddedTask, isNotNull);
      expect(fakeRepository.lastAddedTask!.title, equals('New Task'));
      expect(fakeRepository.lastAddedTask!.energyScore, equals(42));
      expect(fakeRepository.lastAddedTask!.taskType, equals(TaskType.oneTime));
    });

    testWidgets('select recurring → weeklyQuota field appears', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            tasksRepositoryProvider.overrideWithValue(fakeRepository),
          ],
          child: MaterialApp(
            theme: AppTheme.light,
            home: const TaskFormScreen(
              parentId: 'p1',
              parentType: ParentType.project,
            ),
          ),
        ),
      );

      expect(find.text('Weekly Target'), findsNothing);

      await tester.tap(find.text('Recurring'));
      await tester.pump();

      expect(find.text('Weekly Target'), findsOneWidget);
    });
  });
}
