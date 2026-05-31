import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';
import 'package:habitude/features/goals/tasks_repository.dart';
import 'package:habitude/features/triage/brain_dump_repository.dart';
import 'package:habitude/features/triage/triage_service.dart';

part 'triage_providers.g.dart';

@riverpod
TriageService triageService(Ref ref) {
  return TriageService();
}

@riverpod
int triagePendingCount(Ref ref) {
  final activeItems = ref.watch(brainDumpActiveItemsProvider).value ?? [];
  final tasks = ref.watch(tasksStreamProvider).value ?? [];
  final completions = ref.watch(taskCompletionsStreamProvider).value ?? [];
  final service = ref.watch(triageServiceProvider);
  final today = DateTime.now().toUtc();

  final pendingItems = service.todaysBrainDumpItems(activeItems, today);
  final pendingTasks = service.pendingRecurringTasks(tasks, completions, today);

  return pendingItems.length + pendingTasks.length;
}

@riverpod
List<TriageItem> triageQueue(Ref ref) {
  final activeItems = ref.watch(brainDumpActiveItemsProvider).value ?? [];
  final tasks = ref.watch(tasksStreamProvider).value ?? [];
  final completions = ref.watch(taskCompletionsStreamProvider).value ?? [];
  final service = ref.watch(triageServiceProvider);
  final today = DateTime.now().toUtc();

  final pendingItems = service.todaysBrainDumpItems(activeItems, today);
  final pendingTasks = service.pendingRecurringTasks(tasks, completions, today);

  return [
    for (final item in pendingItems) TriageItem.brainDump(item),
    for (final task in pendingTasks)
      TriageItem.task(
        task,
        service.completionsThisWeek(task.id, completions, today),
      ),
  ];
}
