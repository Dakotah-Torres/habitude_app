import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/triage/brain_dump_item.dart';

part 'triage_service.freezed.dart';

@freezed
abstract class TriageItem with _$TriageItem {
  const factory TriageItem.brainDump(BrainDumpItem item) = _TriageBrainDump;
  const factory TriageItem.task(Task task, int completionsThisWeek) =
      _TriageTask;
}

class TriageService {
  // Returns brain dump items eligible for today's triage:
  // scheduledForDate is null AND (backloggedUntil is null OR
  // backloggedUntil UTC calendar date <= today UTC calendar date).
  List<BrainDumpItem> todaysBrainDumpItems(
    List<BrainDumpItem> items,
    DateTime today,
  ) {
    final todayDate = DateTime.utc(today.year, today.month, today.day);

    return items.where((item) {
      if (item.scheduledForDate != null) return false;
      if (item.backloggedUntil == null) return true;

      final backlogDate = DateTime.utc(
        item.backloggedUntil!.year,
        item.backloggedUntil!.month,
        item.backloggedUntil!.day,
      );
      return !backlogDate.isAfter(todayDate);
    }).toList();
  }

  // Returns recurring tasks that have not yet met their weeklyQuota
  // in the ISO calendar week containing `today` (Monday–Sunday UTC).
  List<Task> pendingRecurringTasks(
    List<Task> tasks,
    List<TaskCompletion> completions,
    DateTime today,
  ) {
    return tasks.where((task) {
      if (task.taskType != TaskType.recurring || task.weeklyQuota == null) {
        return false;
      }

      final count = completionsThisWeek(task.id, completions, today);
      return count < task.weeklyQuota!;
    }).toList();
  }

  // Helper: count completions for a given taskId whose completedAt falls
  // in the same ISO week as today.
  int completionsThisWeek(
    String taskId,
    List<TaskCompletion> completions,
    DateTime today,
  ) {
    final utcToday = today.toUtc();
    final startOfWeek = DateTime.utc(
      utcToday.year,
      utcToday.month,
      utcToday.day,
    ).subtract(Duration(days: utcToday.weekday - 1));

    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return completions.where((c) {
      if (c.taskId != taskId) return false;
      final completedAt = c.completedAt.toUtc();
      return !completedAt.isBefore(startOfWeek) &&
          completedAt.isBefore(endOfWeek);
    }).length;
  }
}
