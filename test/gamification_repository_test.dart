import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/gamification/gamification_engine.dart';
import 'package:habitude/features/gamification/gamification_repository.dart';
import 'package:habitude/features/gamification/rank_up_event.dart';

void main() {
  group('GamificationRepository', () {
    late FakeFirebaseFirestore firestore;
    late GamificationRepository repository;
    const uid = 'user123';

    setUp(() {
      firestore = FakeFirebaseFirestore();
      repository = GamificationRepository(firestore, uid: uid);
    });

    test('watchAllRankUpEvents emits empty list when collection is empty', () async {
      final events = await repository.watchAllRankUpEvents().first;
      expect(events, isEmpty);
    });

    test('after addRankUpEvent, watchAllRankUpEvents emits a list containing it', () async {
      final event = RankUpEvent(
        id: 'ev1',
        taskId: 't1',
        triggeredAt: DateTime.now().toUtc(),
        newBaselinePoints: 85,
        newRank: Rank.adept,
      );

      await repository.addRankUpEvent(event);

      final events = await repository.watchAllRankUpEvents().first;
      expect(events, hasLength(1));
      expect(events.first.id, event.id);
    });

    test('watchUnlockedTaskIds returns distinct taskIds', () async {
      final now = DateTime.now().toUtc();
      final event1 = RankUpEvent(
        id: 'ev1',
        taskId: 't1',
        triggeredAt: now,
        newBaselinePoints: 85,
        newRank: Rank.adept,
      );
      final event2 = RankUpEvent(
        id: 'ev2',
        taskId: 't2',
        triggeredAt: now.add(const Duration(minutes: 1)),
        newBaselinePoints: 90,
        newRank: Rank.adept,
      );

      await repository.addRankUpEvent(event1);
      await repository.addRankUpEvent(event2);

      final unlocked = await repository.watchUnlockedTaskIds().first;
      expect(unlocked, contains('t1'));
      expect(unlocked, contains('t2'));
      expect(unlocked, hasLength(2));
    });
  });
}
