import 'dart:math';
import '../energy/task_completion.dart';

/// Returns the Monday 00:00:00 UTC of the week containing the given date.
DateTime startOfISOWeek(DateTime date) {
  final dateUtc = date.toUtc();
  final utcDate = DateTime.utc(dateUtc.year, dateUtc.month, dateUtc.day);
  return utcDate.subtract(Duration(days: utcDate.weekday - 1));
}

/// Returns the number of calendar weeks in the rolling window [windowStart, today]
/// (inclusive, ISO Monday–Sunday UTC) where completions for taskId met or exceeded quota.
///
/// Binary hit per week: 1 if weekCompletions >= quota, else 0.
int weeksHittingQuota(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today, {
  int windowWeeks = 6,
}) {
  if (quota <= 0) return 0;

  final currentWeekStart = startOfISOWeek(today);
  final windowStart = currentWeekStart.subtract(
    Duration(days: (windowWeeks - 1) * 7),
  );

  int hits = 0;
  for (int i = 0; i < windowWeeks; i++) {
    final weekStart = windowStart.add(Duration(days: i * 7));
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Count completions for this week
    final weekCompletions = completions.where((c) {
      if (c.taskId != taskId) return false;
      final completedAt = c.completedAt.toUtc();
      return !completedAt.isBefore(weekStart) && completedAt.isBefore(weekEnd);
    }).length;

    if (weekCompletions >= quota) {
      hits += 1;
    }
  }

  return hits;
}

/// Returns the sum of max(0, weekCompletions - quota) across every week in the rolling window.
/// This is the healing mechanism that allows ratios above 100%.
int totalWindowExtraCredit(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today, {
  int windowWeeks = 6,
}) {
  if (quota <= 0) return 0;

  final currentWeekStart = startOfISOWeek(today);
  final windowStart = currentWeekStart.subtract(
    Duration(days: (windowWeeks - 1) * 7),
  );

  int totalExtra = 0;
  for (int i = 0; i < windowWeeks; i++) {
    final weekStart = windowStart.add(Duration(days: i * 7));
    final weekEnd = weekStart.add(const Duration(days: 7));

    // Count completions for this week
    final weekCompletions = completions.where((c) {
      if (c.taskId != taskId) return false;
      final completedAt = c.completedAt.toUtc();
      return !completedAt.isBefore(weekStart) && completedAt.isBefore(weekEnd);
    }).length;

    totalExtra += max(0, weekCompletions - quota);
  }

  return totalExtra;
}

/// Returns the number of ISO weeks in the evaluation window (≤ windowWeeks; fewer
/// at the start of the user's history when there are not yet windowWeeks of data).
int evaluationWindowSize(
  String taskId,
  List<TaskCompletion> completions,
  DateTime today, {
  int windowWeeks = 6,
}) {
  final taskCompletions = completions.where((c) => c.taskId == taskId).toList();
  if (taskCompletions.isEmpty) return 0;

  // Find the earliest completion to determine how many weeks of history we have
  taskCompletions.sort((a, b) => a.completedAt.compareTo(b.completedAt));
  final earliestWeekStart = startOfISOWeek(taskCompletions.first.completedAt);

  final currentWeekStart = startOfISOWeek(today);
  final fullWindowStart = currentWeekStart.subtract(
    Duration(days: (windowWeeks - 1) * 7),
  );

  final effectiveStart = earliestWeekStart.isAfter(fullWindowStart)
      ? earliestWeekStart
      : fullWindowStart;

  if (effectiveStart.isAfter(currentWeekStart)) return 0;

  final differenceInDays = currentWeekStart.difference(effectiveStart).inDays;
  return (differenceInDays / 7).floor() + 1;
}

/// Returns (weeksHittingQuota + totalWindowExtraCredit) / evaluationWindowSize * 100.0.
double consistencyRatio(
  String taskId,
  int quota,
  List<TaskCompletion> completions,
  DateTime today, {
  int windowWeeks = 6,
}) {
  final windowSize = evaluationWindowSize(
    taskId,
    completions,
    today,
    windowWeeks: windowWeeks,
  );
  if (windowSize == 0) return 0.0;

  final hits = weeksHittingQuota(
    taskId,
    quota,
    completions,
    today,
    windowWeeks: windowWeeks,
  );

  final extra = totalWindowExtraCredit(
    taskId,
    quota,
    completions,
    today,
    windowWeeks: windowWeeks,
  );

  return ((hits + extra) / windowSize) * 100.0;
}
