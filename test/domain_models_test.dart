import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/project.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/shared/context.dart';

void main() {
  group('Goal Model', () {
    test('roundtrip JSON', () {
      final now = DateTime.now().toUtc();
      final goal = Goal(
        id: '1',
        title: 'Exercise',
        type: GoalType.continuous,
        createdAt: now,
      );

      final json = goal.toJson();
      final fromJson = Goal.fromJson(json);

      expect(fromJson, equals(goal));
      expect(fromJson.createdAt, equals(now));
    });

    test('equality', () {
      final now = DateTime.now().toUtc();
      final g1 = Goal(
        id: '1',
        title: 'T',
        type: GoalType.finite,
        createdAt: now,
      );
      final g2 = Goal(
        id: '1',
        title: 'T',
        type: GoalType.finite,
        createdAt: now,
      );

      expect(g1 == g2, isTrue);
    });
  });

  group('Project Model', () {
    test('roundtrip JSON with null dueDate', () {
      final now = DateTime.now().toUtc();
      final project = Project(
        id: 'p1',
        goalId: 'g1',
        title: 'Project 1',
        status: ProjectStatus.active,
        dueDate: null,
        createdAt: now,
      );

      final json = project.toJson();
      final fromJson = Project.fromJson(json);

      expect(fromJson, equals(project));
      expect(fromJson.dueDate, isNull);
    });

    test('roundtrip JSON with dueDate', () {
      final now = DateTime.now().toUtc();
      final due = now.add(const Duration(days: 7));
      final project = Project(
        id: 'p1',
        goalId: 'g1',
        title: 'Project 1',
        status: ProjectStatus.active,
        dueDate: due,
        createdAt: now,
      );

      final json = project.toJson();
      final fromJson = Project.fromJson(json);

      expect(fromJson, equals(project));
      expect(fromJson.dueDate, equals(due));
    });
  });

  group('Task Model', () {
    test('roundtrip JSON with null weeklyQuota', () {
      final now = DateTime.now().toUtc();
      final task = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Task 1',
        energyScore: 5,
        taskType: TaskType.oneTime,
        weeklyQuota: null,
        createdAt: now,
      );

      final json = task.toJson();
      final fromJson = Task.fromJson(json);

      expect(fromJson, equals(task));
      expect(fromJson.weeklyQuota, isNull);
    });

    test('roundtrip JSON with weeklyQuota', () {
      final now = DateTime.now().toUtc();
      final task = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Task 1',
        energyScore: 5,
        taskType: TaskType.recurring,
        weeklyQuota: 3,
        createdAt: now,
      );

      final json = task.toJson();
      final fromJson = Task.fromJson(json);

      expect(fromJson, equals(task));
      expect(fromJson.weeklyQuota, equals(3));
    });
  });

  group('Context Model', () {
    test('roundtrip JSON', () {
      final context = const Context(id: 'c1', name: 'Work', colorHex: 'FF6B35');

      final json = context.toJson();
      final fromJson = Context.fromJson(json);

      expect(fromJson, equals(context));
    });
  });
}
