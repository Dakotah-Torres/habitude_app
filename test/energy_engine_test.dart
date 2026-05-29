import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/energy_engine.dart';
import 'package:habitude/features/energy/task_completion.dart';

void main() {
  group('EnergyEngine', () {
    test('dailyPoints sums completions on the same UTC day', () {
      final d1 = DateTime.utc(2026, 5, 29, 12);
      final d2 = DateTime.utc(2026, 5, 30, 12);

      final completions = [
        TaskCompletion(id: '1', taskId: 't1', energyScore: 30, completedAt: d1),
        TaskCompletion(id: '2', taskId: 't2', energyScore: 50, completedAt: d1),
        TaskCompletion(
          id: '3',
          taskId: 't3',
          energyScore: 100,
          completedAt: d2,
        ),
      ];

      expect(EnergyEngine.dailyPoints(completions, d1), equals(80));
    });

    test('dailyPoints respects UTC boundaries', () {
      final d1End = DateTime.utc(2026, 5, 29, 23, 59);
      final d2Start = DateTime.utc(2026, 5, 30, 0, 1);

      final completions = [
        TaskCompletion(
          id: '1',
          taskId: 't1',
          energyScore: 30,
          completedAt: d1End,
        ),
        TaskCompletion(
          id: '2',
          taskId: 't2',
          energyScore: 50,
          completedAt: d2Start,
        ),
      ];

      expect(
        EnergyEngine.dailyPoints(completions, DateTime.utc(2026, 5, 29)),
        equals(30),
      );
    });

    test('energyBaseline returns defaultBaseline when empty', () {
      expect(EnergyEngine.energyBaseline([]), equals(80));
      expect(EnergyEngine.energyBaseline([], defaultBaseline: 60), equals(60));
    });

    test('energyBaseline averages points over distinct days', () {
      final d1 = DateTime.utc(2026, 5, 25);
      final d2 = DateTime.utc(2026, 5, 26);
      final d3 = DateTime.utc(2026, 5, 27);

      final completions = [
        TaskCompletion(id: '1', taskId: 't1', energyScore: 80, completedAt: d1),
        TaskCompletion(
          id: '2',
          taskId: 't2',
          energyScore: 100,
          completedAt: d2,
        ),
        TaskCompletion(id: '3', taskId: 't3', energyScore: 60, completedAt: d3),
      ];

      expect(EnergyEngine.energyBaseline(completions), equals(80));
    });

    test('energyBaseline handles 7 days of constant points', () {
      final completions = <TaskCompletion>[];
      for (int i = 0; i < 7; i++) {
        completions.add(
          TaskCompletion(
            id: '$i',
            taskId: 't',
            energyScore: 100,
            completedAt: DateTime.utc(2026, 5, 20 + i),
          ),
        );
      }

      expect(EnergyEngine.energyBaseline(completions), equals(100));
    });
  });
}
