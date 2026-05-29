import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/goal.dart';
import 'package:habitude/features/goals/goals_repository.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'helpers/auth_helper.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late GoalsRepository repository;
  late FakeAuthRepository fakeAuth;
  const testUid = 'fake_uid';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeAuth = FakeAuthRepository(initialUid: testUid);
    addTearDown(fakeAuth.dispose);
    repository = GoalsRepository(fakeFirestore, uid: testUid);
  });

  group('GoalsRepository', () {
    test('watchGoals emits empty list initially', () async {
      final goals = await repository.watchGoals().first;
      expect(goals, isEmpty);
    });

    test('addGoal then watchGoals emits the goal', () async {
      final goal = Goal(
        id: 'g1',
        title: 'Title',
        type: GoalType.continuous,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addGoal(goal);
      final goals = await repository.watchGoals().first;

      expect(goals, hasLength(1));
      expect(goals.first, equals(goal));
    });

    test('updateGoal changes the goal title', () async {
      final goal = Goal(
        id: 'g1',
        title: 'Old Title',
        type: GoalType.continuous,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addGoal(goal);
      await repository.updateGoal(goal.copyWith(title: 'New Title'));

      final goals = await repository.watchGoals().first;
      expect(goals.first.title, equals('New Title'));
    });

    test('deleteGoal removes the goal', () async {
      final goal = Goal(
        id: 'g1',
        title: 'Title',
        type: GoalType.continuous,
        createdAt: DateTime.now().toUtc(),
      );

      await repository.addGoal(goal);
      await repository.deleteGoal(goal.id);

      final goals = await repository.watchGoals().first;
      expect(goals, isEmpty);
    });
    group('Providers', () {
      test('goalsStreamProvider emits values from repository', () async {
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuth),
            goalsRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        // Keep the provider alive
        final subscription = container.listen(
          goalsStreamProvider,
          (prev, next) {},
        );

        final goal = Goal(
          id: 'g1',
          title: 'Stream Test',
          type: GoalType.finite,
          createdAt: DateTime.now().toUtc(),
        );

        // Initially empty
        var goals = await container.read(goalsStreamProvider.future);
        expect(goals, isEmpty);

        // Add a goal
        await repository.addGoal(goal);

        // We need to wait for the stream to emit.
        goals = await container.read(goalsStreamProvider.future);
        expect(goals, hasLength(1));
        expect(goals.first.title, equals('Stream Test'));

        subscription.close();
      });
    });
  });
}
