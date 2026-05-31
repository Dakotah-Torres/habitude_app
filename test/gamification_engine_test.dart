import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/gamification/gamification_engine.dart';

void main() {
  group('GamificationEngine', () {
    final t1 = 'task-1';
    final monday = DateTime.utc(2026, 6, 1);

    test('extraCreditThisWeek calculates correctly', () {
      final completions = [
        TaskCompletion(
          id: '1',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
        TaskCompletion(
          id: '2',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
        TaskCompletion(
          id: '3',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
        TaskCompletion(
          id: '4',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
        TaskCompletion(
          id: '5',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
      ];
      expect(extraCreditThisWeek(t1, 3, completions, monday), 2);
      expect(extraCreditThisWeek(t1, 3, completions.sublist(0, 3), monday), 0);
      expect(extraCreditThisWeek(t1, 3, completions.sublist(0, 1), monday), 0);
    });

    test('shouldTriggerCapacityUnlock logic', () {
      final completions = [
        TaskCompletion(
          id: '1',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
        TaskCompletion(
          id: '2',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
        TaskCompletion(
          id: '3',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
        TaskCompletion(
          id: '4',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
        TaskCompletion(
          id: '5',
          taskId: t1,
          energyScore: 1,
          completedAt: monday,
        ),
      ];
      // 1 week window. Hits = 1, extra credit = 2. Size = 1. Ratio = 300%.
      expect(
        shouldTriggerCapacityUnlock(
          t1,
          3,
          completions,
          monday,
          {},
          windowWeeks: 1,
        ),
        isTrue,
      );
      expect(
        shouldTriggerCapacityUnlock(t1, 3, completions, monday, {
          t1,
        }, windowWeeks: 1),
        isFalse,
      );
      expect(
        shouldTriggerCapacityUnlock(
          t1,
          10,
          completions,
          monday,
          {},
          windowWeeks: 1,
        ),
        isFalse,
      );
    });

    test('rankFromUnlockCount categorization', () {
      expect(rankFromUnlockCount(0), Rank.novice);
      expect(rankFromUnlockCount(1), Rank.adept);
      expect(rankFromUnlockCount(4), Rank.adept);
      expect(rankFromUnlockCount(5), Rank.master);
      expect(rankFromUnlockCount(10), Rank.master);
    });

    test('adjustedBaseline calculation', () {
      expect(adjustedBaseline(80, 0), 80);
      expect(adjustedBaseline(80, 3), 95);
    });
  });
}
