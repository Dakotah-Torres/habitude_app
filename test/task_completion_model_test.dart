import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/shared/firestore_paths.dart';

void main() {
  group('TaskCompletion Model', () {
    test('roundtrip toJson/fromJson preserves equality', () {
      final now = DateTime.now().toUtc();
      final completion = TaskCompletion(
        id: 'c1',
        taskId: 't1',
        energyScore: 50,
        completedAt: now,
      );

      final json = completion.toJson();
      final fromJson = TaskCompletion.fromJson(json);

      expect(fromJson, equals(completion));
    });

    test('value equality works', () {
      final now = DateTime.now().toUtc();
      final c1 = TaskCompletion(
        id: 'c1',
        taskId: 't1',
        energyScore: 50,
        completedAt: now,
      );
      final c2 = TaskCompletion(
        id: 'c1',
        taskId: 't1',
        energyScore: 50,
        completedAt: now,
      );

      expect(c1, equals(c2));
    });
  });

  group('FirestorePaths', () {
    test('taskCompletions path is correct', () {
      expect(
        FirestorePaths.taskCompletions('abc123'),
        equals('users/abc123/task_completions'),
      );
    });
  });
}
