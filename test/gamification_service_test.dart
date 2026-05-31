import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/energy_service.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';
import 'package:habitude/features/gamification/gamification_engine.dart';
import 'package:habitude/features/gamification/gamification_service.dart';
import 'package:habitude/features/gamification/gamification_repository.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/goals/tasks_repository.dart';

void main() {
  group('GamificationService', () {
    test('taskConsistencyRatios computed correctly', () async {
      final t1 = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Task 1',
        energyScore: 10,
        taskType: TaskType.recurring,
        weeklyQuota: 3,
        createdAt: DateTime.now().toUtc(),
      );

      final container = ProviderContainer(
        overrides: [
          tasksStreamProvider.overrideWith((ref) => Stream.value([t1])),
          taskCompletionsStreamProvider.overrideWith(
            (ref) => Stream.value([
              TaskCompletion(
                id: 'c1',
                taskId: 't1',
                energyScore: 10,
                completedAt: DateTime.now().toUtc(),
              ),
              TaskCompletion(
                id: 'c2',
                taskId: 't1',
                energyScore: 10,
                completedAt: DateTime.now().toUtc(),
              ),
              TaskCompletion(
                id: 'c3',
                taskId: 't1',
                energyScore: 10,
                completedAt: DateTime.now().toUtc(),
              ),
            ]),
          ),
        ],
      );

      container.listen(tasksStreamProvider, (_, _) {});
      container.listen(taskCompletionsStreamProvider, (_, _) {});

      await container.read(tasksStreamProvider.future);
      await container.read(taskCompletionsStreamProvider.future);

      final ratios = container.read(taskConsistencyRatiosProvider);
      expect(ratios['t1'], 100.0);
    });

    test('currentRank derived from unlockedTaskIds count', () async {
      final container = ProviderContainer(
        overrides: [
          unlockedTaskIdsProvider.overrideWith(
            (ref) => Stream.value({'t1', 't2'}),
          ),
        ],
      );

      container.listen(unlockedTaskIdsProvider, (_, _) {});
      await container.read(unlockedTaskIdsProvider.future);

      final rank = container.read(currentRankProvider);
      expect(rank, Rank.adept);
    });

    test(
      'adjustedEnergyBaseline combines energyService baseline and unlocks',
      () async {
        final container = ProviderContainer(
          overrides: [
            energyBaselineProvider.overrideWith((ref) => Stream.value(80)),
            unlockedTaskIdsProvider.overrideWith(
              (ref) => Stream.value({'t1', 't2', 't3'}),
            ),
          ],
        );

        container.listen(energyBaselineProvider, (_, _) {});
        container.listen(unlockedTaskIdsProvider, (_, _) {});

        await container.read(energyBaselineProvider.future);
        await container.read(unlockedTaskIdsProvider.future);

        final adjusted = container.read(adjustedEnergyBaselineProvider);
        expect(adjusted, 95);
      },
    );

    test('pendingCapacityUnlocks detects tasks ready to unlock', () async {
      final t1 = Task(
        id: 't1',
        parentId: 'p1',
        parentType: ParentType.project,
        title: 'Task 1',
        energyScore: 10,
        taskType: TaskType.recurring,
        weeklyQuota: 3,
        createdAt: DateTime.now().toUtc(),
      );

      final container = ProviderContainer(
        overrides: [
          tasksStreamProvider.overrideWith((ref) => Stream.value([t1])),
          taskCompletionsStreamProvider.overrideWith(
            (ref) => Stream.value([
              TaskCompletion(
                id: 'c1',
                taskId: 't1',
                energyScore: 10,
                completedAt: DateTime.now().toUtc(),
              ),
              TaskCompletion(
                id: 'c2',
                taskId: 't1',
                energyScore: 10,
                completedAt: DateTime.now().toUtc(),
              ),
              TaskCompletion(
                id: 'c3',
                taskId: 't1',
                energyScore: 10,
                completedAt: DateTime.now().toUtc(),
              ),
              TaskCompletion(
                id: 'c4',
                taskId: 't1',
                energyScore: 10,
                completedAt: DateTime.now().toUtc(),
              ),
            ]),
          ),
          unlockedTaskIdsProvider.overrideWith(
            (ref) => Stream.value(<String>{}),
          ),
        ],
      );

      container.listen(tasksStreamProvider, (_, _) {});
      container.listen(taskCompletionsStreamProvider, (_, _) {});
      container.listen(unlockedTaskIdsProvider, (_, _) {});

      await container.read(tasksStreamProvider.future);
      await container.read(taskCompletionsStreamProvider.future);
      await container.read(unlockedTaskIdsProvider.future);

      final pending = container.read(pendingCapacityUnlocksProvider);
      expect(pending, contains('t1'));
    });
  });
}
