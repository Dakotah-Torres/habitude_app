import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'helpers/auth_helper.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late TaskCompletionRepository repository;
  late FakeAuthRepository fakeAuth;
  const testUid = 'fake_uid';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeAuth = FakeAuthRepository(initialUid: testUid);
    repository = TaskCompletionRepository(fakeFirestore, uid: testUid);
  });

  group('TaskCompletionRepository', () {
    test('watchCompletions emits empty list initially', () async {
      final completions = await repository.watchCompletions().first;
      expect(completions, isEmpty);
    });

    test('addCompletion then watchCompletions emits the completion', () async {
      final completion = TaskCompletion(
        id: 'c1',
        taskId: 't1',
        energyScore: 50,
        completedAt: DateTime.now().toUtc(),
      );

      await repository.addCompletion(completion);
      final completions = await repository.watchCompletions().first;

      expect(completions, hasLength(1));
      expect(completions.first, equals(completion));
    });

    test('deleteCompletion removes the completion', () async {
      final completion = TaskCompletion(
        id: 'c1',
        taskId: 't1',
        energyScore: 50,
        completedAt: DateTime.now().toUtc(),
      );

      await repository.addCompletion(completion);
      await repository.deleteCompletion(completion.id);

      final completions = await repository.watchCompletions().first;
      expect(completions, isEmpty);
    });

    test('watchCompletionsSince filters correctly', () async {
      final now = DateTime.now().toUtc();
      final cOld = TaskCompletion(
        id: 'old',
        taskId: 't1',
        energyScore: 50,
        completedAt: now.subtract(const Duration(days: 8)),
      );
      final cNew = TaskCompletion(
        id: 'new',
        taskId: 't1',
        energyScore: 50,
        completedAt: now.subtract(const Duration(days: 3)),
      );

      await repository.addCompletion(cOld);
      await repository.addCompletion(cNew);

      final since = now.subtract(const Duration(days: 7));
      final filtered = await repository.watchCompletionsSince(since).first;

      expect(filtered, hasLength(1));
      expect(filtered.first.id, equals('new'));
    });

    group('Providers', () {
      test(
        'taskCompletionsStreamProvider emits values from repository',
        () async {
          final container = ProviderContainer(
            overrides: [
              authRepositoryProvider.overrideWithValue(fakeAuth),
              taskCompletionRepositoryProvider.overrideWithValue(repository),
            ],
          );
          addTearDown(container.dispose);

          final subscription = container.listen(
            taskCompletionsStreamProvider,
            (prev, next) {},
          );

          final completion = TaskCompletion(
            id: 'c1',
            taskId: 't1',
            energyScore: 50,
            completedAt: DateTime.now().toUtc(),
          );

          var completions = await container.read(
            taskCompletionsStreamProvider.future,
          );
          expect(completions, isEmpty);

          await repository.addCompletion(completion);

          completions = await container.read(
            taskCompletionsStreamProvider.future,
          );
          expect(completions, hasLength(1));
          expect(completions.first.id, equals('c1'));

          subscription.close();
        },
      );
    });
  });
}
