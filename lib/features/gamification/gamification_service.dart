import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'consistency_engine.dart';
import 'gamification_engine.dart';
import 'gamification_repository.dart';
import '../energy/energy_service.dart';
import '../energy/task_completion_repository.dart';
import '../goals/task.dart';
import '../goals/tasks_repository.dart';

part 'gamification_service.g.dart';

@riverpod
Map<String, double> taskConsistencyRatios(Ref ref) {
  final tasks = ref.watch(tasksStreamProvider).value ?? [];
  final completions = ref.watch(taskCompletionsStreamProvider).value ?? [];
  final today = DateTime.now().toUtc();

  final ratios = <String, double>{};
  for (final task in tasks) {
    if (task.taskType == TaskType.recurring && task.weeklyQuota != null) {
      final ratio = consistencyRatio(
        task.id,
        task.weeklyQuota!,
        completions,
        today,
      );
      ratios[task.id] = ratio;
    }
  }
  return ratios;
}

@riverpod
Rank currentRank(Ref ref) {
  final unlockedIds = ref.watch(unlockedTaskIdsProvider).value ?? {};
  return rankFromUnlockCount(unlockedIds.length);
}

@riverpod
int adjustedEnergyBaseline(Ref ref) {
  final baseBaseline = ref.watch(energyBaselineProvider).value ?? 80;
  final unlockedIds = ref.watch(unlockedTaskIdsProvider).value ?? {};
  return adjustedBaseline(baseBaseline, unlockedIds.length);
}

@riverpod
List<String> pendingCapacityUnlocks(Ref ref) {
  final tasks = ref.watch(tasksStreamProvider).value ?? [];
  final completions = ref.watch(taskCompletionsStreamProvider).value ?? [];
  final unlockedIds = ref.watch(unlockedTaskIdsProvider).value ?? {};
  final today = DateTime.now().toUtc();

  final pending = <String>[];
  for (final task in tasks) {
    if (task.taskType == TaskType.recurring && task.weeklyQuota != null) {
      final shouldUnlock = shouldTriggerCapacityUnlock(
        task.id,
        task.weeklyQuota!,
        completions,
        today,
        unlockedIds,
      );
      if (shouldUnlock) {
        pending.add(task.id);
      }
    }
  }
  return pending;
}
