import 'package:freezed_annotation/freezed_annotation.dart';
import 'consistency_engine.dart';
import '../energy/task_completion.dart';

enum Rank {
  @JsonValue('novice')
  novice,
  @JsonValue('adept')
  adept,
  @JsonValue('master')
  master,
}

/// Returns completions for taskId this ISO week that exceed the quota.
int extraCreditThisWeek(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today,
) {
  if (quota <= 0) return 0;

  final weekStart = startOfISOWeek(today);
  final weekEnd = weekStart.add(const Duration(days: 7));

  final weekCompletions = completions.where((c) {
    if (c.taskId != taskId) return false;
    final completedAt = c.completedAt.toUtc();
    return !completedAt.isBefore(weekStart) && completedAt.isBefore(weekEnd);
  }).length;

  if (weekCompletions <= quota) return 0;
  return weekCompletions - quota;
}

/// Returns true if the task's consistencyRatio >= 120.0 AND the task has not
/// already triggered an unlock.
bool shouldTriggerCapacityUnlock(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today,
  Set<String> previouslyUnlocked, {
  int windowWeeks = 6,
}) {
  if (previouslyUnlocked.contains(taskId)) return false;

  final ratio = consistencyRatio(
    taskId,
    quota,
    completions,
    today,
    windowWeeks: windowWeeks,
  );
  return ratio >= 120.0;
}

/// Returns the Rank based on total unlock count.
Rank rankFromUnlockCount(int totalUnlocks) {
  if (totalUnlocks <= 0) return Rank.novice;
  if (totalUnlocks <= 4) return Rank.adept;
  return Rank.master;
}

/// Returns the adjusted daily energy baseline:
/// baselinePoints + (totalCapacityUnlocks * 5).
int adjustedBaseline(int baselinePoints, int totalCapacityUnlocks) {
  return baselinePoints + (totalCapacityUnlocks * 5);
}
