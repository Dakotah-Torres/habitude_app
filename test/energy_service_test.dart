import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/energy_service.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';

void main() {
  test('energyBaselineProvider emits 80 for empty list', () async {
    final container = ProviderContainer(
      overrides: [
        taskCompletionsStreamProvider.overrideWith((ref) => Stream.value([])),
      ],
    );
    addTearDown(container.dispose);

    // Use listen to keep the provider alive during the await
    final subscription = container.listen(energyBaselineProvider, (_, _) {});

    final baseline = await container.read(energyBaselineProvider.future);
    expect(baseline, equals(80));

    subscription.close();
  });

  test('energyBaselineProvider emits 100 for seven 100-point days', () async {
    final now = DateTime.now().toUtc();
    final completions = [
      for (var i = 0; i < 7; i++)
        TaskCompletion(
          id: '$i',
          taskId: 't',
          energyScore: 100,
          completedAt: now.subtract(Duration(days: i)),
        ),
    ];

    final container = ProviderContainer(
      overrides: [
        taskCompletionsStreamProvider.overrideWith(
          (ref) => Stream.value(completions),
        ),
      ],
    );
    addTearDown(container.dispose);

    final subscription = container.listen(energyBaselineProvider, (_, _) {});

    final baseline = await container.read(energyBaselineProvider.future);
    expect(baseline, equals(100));

    subscription.close();
  });

  test('energyBaselineProvider averages three days of data', () async {
    final now = DateTime.now().toUtc();
    final completions = [
      TaskCompletion(id: '1', taskId: 't', energyScore: 80, completedAt: now),
      TaskCompletion(
        id: '2',
        taskId: 't',
        energyScore: 90,
        completedAt: now.subtract(const Duration(days: 1)),
      ),
      TaskCompletion(
        id: '3',
        taskId: 't',
        energyScore: 100,
        completedAt: now.subtract(const Duration(days: 2)),
      ),
    ];

    final container = ProviderContainer(
      overrides: [
        taskCompletionsStreamProvider.overrideWith(
          (ref) => Stream.value(completions),
        ),
      ],
    );
    addTearDown(container.dispose);

    final subscription = container.listen(energyBaselineProvider, (_, _) {});

    final baseline = await container.read(energyBaselineProvider.future);
    expect(baseline, equals(90));

    subscription.close();
  });

  test(
    'energyBaselineProvider excludes completions older than 7 days',
    () async {
      final now = DateTime.now().toUtc();
      final completions = [
        // Today (Day 0) - 100
        TaskCompletion(
          id: '1',
          taskId: 't',
          energyScore: 100,
          completedAt: now,
        ),
        // Yesterday (Day 1) - 80
        TaskCompletion(
          id: '2',
          taskId: 't',
          energyScore: 80,
          completedAt: now.subtract(const Duration(days: 1)),
        ),
        // Day 6 ago - 60
        TaskCompletion(
          id: '3',
          taskId: 't',
          energyScore: 60,
          completedAt: now.subtract(const Duration(days: 6)),
        ),
        // Day 7 ago (Old, should be excluded) - 200
        TaskCompletion(
          id: '4',
          taskId: 't',
          energyScore: 200,
          completedAt: now.subtract(const Duration(days: 7, hours: 1)),
        ),
      ];

      final container = ProviderContainer(
        overrides: [
          taskCompletionsStreamProvider.overrideWith(
            (ref) => Stream.value(completions),
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(energyBaselineProvider, (_, _) {});

      final baseline = await container.read(energyBaselineProvider.future);
      // (100 + 80 + 60) / 3 = 80
      expect(baseline, equals(80));

      subscription.close();
    },
  );

  test('energyBaselineProvider emits live baseline updates', () async {
    final now = DateTime.now().toUtc();
    final controller = StreamController<List<TaskCompletion>>();
    addTearDown(controller.close);

    final container = ProviderContainer(
      overrides: [
        taskCompletionsStreamProvider.overrideWith((ref) => controller.stream),
      ],
    );
    addTearDown(container.dispose);

    final emitted = <int>[];
    final subscription = container.listen(
      energyBaselineProvider,
      (_, next) => next.whenData(emitted.add),
    );
    addTearDown(subscription.close);

    controller.add([]);
    await Future<void>.delayed(Duration.zero);
    controller.add([
      TaskCompletion(id: '1', taskId: 't', energyScore: 100, completedAt: now),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(emitted, equals([80, 100]));
  });
}
