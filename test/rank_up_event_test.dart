import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/gamification/gamification_engine.dart';
import 'package:habitude/features/gamification/rank_up_event.dart';
import 'package:habitude/shared/firestore_paths.dart';

void main() {
  group('RankUpEvent', () {
    test('JSON roundtrip preserves all fields including Rank enum', () {
      final now = DateTime.now().toUtc();
      final event = RankUpEvent(
        id: 'ev1',
        taskId: 't1',
        triggeredAt: now,
        newBaselinePoints: 85,
        newRank: Rank.adept,
      );

      final json = event.toJson();
      expect(json['newRank'], 'adept');

      final fromJson = RankUpEvent.fromJson(json);
      expect(fromJson.id, event.id);
      expect(fromJson.taskId, event.taskId);
      expect(fromJson.triggeredAt, event.triggeredAt);
      expect(fromJson.newBaselinePoints, event.newBaselinePoints);
      expect(fromJson.newRank, event.newRank);
    });
  });

  group('FirestorePaths', () {
    test('rankUpEvents path is correct', () {
      expect(
        FirestorePaths.rankUpEvents('abc123'),
        'users/abc123/rank_up_events',
      );
    });
  });
}
