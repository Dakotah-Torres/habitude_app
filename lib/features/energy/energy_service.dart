import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:habitude/features/energy/energy_engine.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';

part 'energy_service.g.dart';

@riverpod
Stream<int> energyBaseline(Ref ref) {
  final controller = StreamController<int>();
  final subscription = ref.listen(taskCompletionsStreamProvider, (_, next) {
    final completions = next.asData?.value;
    if (completions != null && !controller.isClosed) {
      controller.add(_baselineFromCompletions(completions));
    }

    final error = next.asError;
    if (error != null && !controller.isClosed) {
      controller.addError(error.error, error.stackTrace);
    }
  });

  ref.onDispose(() {
    subscription.close();
    controller.close();
  });

  return controller.stream;
}

int _baselineFromCompletions(List<TaskCompletion> completions) {
  final now = DateTime.now().toUtc();
  final sevenDaysAgo = DateTime.utc(
    now.year,
    now.month,
    now.day,
  ).subtract(const Duration(days: 6));

  final filtered = completions.where((c) {
    final completedAt = c.completedAt.toUtc();
    return completedAt.isAfter(sevenDaysAgo) ||
        completedAt.isAtSameMomentAs(sevenDaysAgo);
  }).toList();

  return EnergyEngine.energyBaseline(filtered);
}
