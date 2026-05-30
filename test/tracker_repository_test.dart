import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/timer/tracker.dart';
import 'package:habitude/features/timer/tracker_repository.dart';
import 'package:habitude/shared/auth_repository.dart';
import 'helpers/auth_helper.dart';

void main() {
  late FakeFirebaseFirestore fakeFirestore;
  late TrackerRepository repository;
  late FakeAuthRepository fakeAuth;
  const testUid = 'fake_uid';

  setUp(() {
    fakeFirestore = FakeFirebaseFirestore();
    fakeAuth = FakeAuthRepository(initialUid: testUid);
    addTearDown(fakeAuth.dispose);
    repository = TrackerRepository(fakeFirestore, uid: testUid);
  });

  group('TrackerRepository', () {
    test('watchTrackers emits empty list initially', () async {
      final trackers = await repository.watchTrackers().first;
      expect(trackers, isEmpty);
    });

    test('addTracker then watchTrackers emits the tracker', () async {
      final tracker = Tracker(
        id: 'tr1',
        taskId: 't1',
        startedAt: DateTime.now().toUtc(),
      );

      await repository.addTracker(tracker);
      final trackers = await repository.watchTrackers().first;

      expect(trackers, hasLength(1));
      expect(trackers.first, equals(tracker));
    });

    test('updateTracker changes the stoppedAt field', () async {
      final now = DateTime.now().toUtc();
      final tracker = Tracker(id: 'tr1', taskId: 't1', startedAt: now);

      await repository.addTracker(tracker);
      final stoppedAt = now.add(const Duration(minutes: 25));
      await repository.updateTracker(
        tracker.copyWith(stoppedAt: stoppedAt, durationSeconds: 1500),
      );

      final trackers = await repository.watchTrackers().first;
      expect(trackers.first.stoppedAt, equals(stoppedAt));
      expect(trackers.first.durationSeconds, equals(1500));
    });

    test('watchTrackersByTask filters correctly', () async {
      final now = DateTime.now().toUtc();
      final t1 = Tracker(id: 'tr1', taskId: 'task1', startedAt: now);
      final t2 = Tracker(id: 'tr2', taskId: 'task2', startedAt: now);

      await repository.addTracker(t1);
      await repository.addTracker(t2);

      final task1Trackers = await repository.watchTrackersByTask('task1').first;
      expect(task1Trackers, hasLength(1));
      expect(task1Trackers.first.id, equals('tr1'));
    });

    group('Providers', () {
      test('trackersStreamProvider emits values from repository', () async {
        final container = ProviderContainer(
          overrides: [
            authRepositoryProvider.overrideWithValue(fakeAuth),
            trackerRepositoryProvider.overrideWithValue(repository),
          ],
        );
        addTearDown(container.dispose);

        final subscription = container.listen(
          trackersStreamProvider,
          (prev, next) {},
        );

        final tracker = Tracker(
          id: 'tr1',
          taskId: 'task1',
          startedAt: DateTime.now().toUtc(),
        );

        var trackers = await container.read(trackersStreamProvider.future);
        expect(trackers, isEmpty);

        await repository.addTracker(tracker);

        trackers = await container.read(trackersStreamProvider.future);
        expect(trackers, hasLength(1));
        expect(trackers.first.id, equals('tr1'));

        subscription.close();
      });
    });
  });
}
