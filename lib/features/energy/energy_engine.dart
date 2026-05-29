import 'package:habitude/features/energy/task_completion.dart';

class EnergyEngine {
  /// Returns the sum of energyScore for all completions whose completedAt
  /// falls on the same UTC calendar date as `day`.
  static int dailyPoints(List<TaskCompletion> completions, DateTime day) {
    final utcDay = day.toUtc();
    return completions
        .where((c) {
          final cDate = c.completedAt.toUtc();
          return cDate.year == utcDay.year &&
              cDate.month == utcDay.month &&
              cDate.day == utcDay.day;
        })
        .fold(0, (sum, c) => sum + c.energyScore);
  }

  /// Returns the rolling 7-day average of daily points.
  /// `history` should contain completions for exactly the 7 UTC calendar days
  /// ending today (inclusive).
  static int energyBaseline(
    List<TaskCompletion> history, {
    int defaultBaseline = 80,
  }) {
    if (history.isEmpty) {
      return defaultBaseline;
    }

    // Group completions by UTC date string to count distinct days
    final pointsByDay = <String, int>{};
    for (final c in history) {
      final utc = c.completedAt.toUtc();
      final dayKey = '${utc.year}-${utc.month}-${utc.day}';
      pointsByDay[dayKey] = (pointsByDay[dayKey] ?? 0) + c.energyScore;
    }

    if (pointsByDay.isEmpty) {
      return defaultBaseline;
    }

    final totalPoints = pointsByDay.values.fold(0, (sum, p) => sum + p);
    return (totalPoints / pointsByDay.length).round();
  }
}
