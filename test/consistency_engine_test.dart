import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/gamification/consistency_engine.dart';

void main() {
  group('ConsistencyEngine', () {
    final t1 = 'task-1';
    final monday = DateTime.utc(2026, 6, 1);

    test('evaluationWindowSize handles short history', () {
      final completions = [
        TaskCompletion(
          id: '1',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
      ];
      final size = evaluationWindowSize(t1, completions, monday);
      expect(size, 1);
    });

    test('evaluationWindowSize caps at windowWeeks', () {
      final completions = [
        TaskCompletion(
          id: '1',
          taskId: t1,
          energyScore: 1,
          completedAt: monday.subtract(const Duration(days: 100)),
        ),
      ];
      final size = evaluationWindowSize(t1, completions, monday, windowWeeks: 6);
      expect(size, 6);
    });

    test('Task with quota 3, 6/6 weeks all meeting quota -> ratio = 100.0%', () {
      final completions = <TaskCompletion>[];
      for (int i = 0; i < 6; i++) {
        final weekStart = monday.subtract(Duration(days: i * 7));
        for (int j = 0; j < 3; j++) {
          completions.add(TaskCompletion(
            id: '$i-$j',
            taskId: t1,
            energyScore: 1,
            completedAt: weekStart.add(Duration(hours: j)),
          ));
        }
      }

      final ratio = consistencyRatio(t1, 3, completions, monday);
      expect(ratio, 100.0);
    });

    test('Task with quota 3, 5/6 weeks meeting quota -> ratio ≈ 83.3%', () {
      final completions = <TaskCompletion>[];
      // 5 weeks (i=0,1,2,3,4) hit quota
      for (int i = 0; i < 5; i++) {
        final weekStart = monday.subtract(Duration(days: i * 7));
        for (int j = 0; j < 3; j++) {
          completions.add(TaskCompletion(
            id: '$i-$j',
            taskId: t1,
            energyScore: 1,
            completedAt: weekStart.add(Duration(hours: j)),
          ));
        }
      }
      // Week 6 (i=5) has history but misses quota (only 1 completion)
      completions.add(TaskCompletion(
        id: '5-0',
        taskId: t1,
        energyScore: 1,
        completedAt: monday.subtract(const Duration(days: 5 * 7)),
      ));
      
      final ratio = consistencyRatio(t1, 3, completions, monday);
      expect(ratio, closeTo(83.33, 0.01));
    });

    test('A week with 5 completions against quota 3 counts as 3 hits (1 hit + 2 extra)', () {
      final completions = [
        TaskCompletion(id: '1', taskId: t1, energyScore: 1, completedAt: monday),
        TaskCompletion(id: '2', taskId: t1, energyScore: 1, completedAt: monday),
        TaskCompletion(id: '3', taskId: t1, energyScore: 1, completedAt: monday),
        TaskCompletion(id: '4', taskId: t1, energyScore: 1, completedAt: monday),
        TaskCompletion(id: '5', taskId: t1, energyScore: 1, completedAt: monday),
      ];
      final hits = weeksHittingQuota(t1, 3, completions, monday, windowWeeks: 1);
      expect(hits, 3);
      
      final ratio = consistencyRatio(t1, 3, completions, monday, windowWeeks: 1);
      expect(ratio, 300.0);
    });

    test('completions from outside the window do NOT affect the ratio', () {
      final completions = [
        TaskCompletion(
          id: 'old',
          taskId: t1,
          energyScore: 1,
          completedAt: monday.subtract(const Duration(days: 100)),
        ),
        TaskCompletion(
          id: 'new',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
      ];
      // Quota 1. 1 week meeting quota.
      final hits = weeksHittingQuota(t1, 1, completions, monday, windowWeeks: 6);
      expect(hits, 1);
    });
  });
}
