import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/timer/tracker.dart';

void main() {
  group('Tracker Model', () {
    test('roundtrip JSON with null stoppedAt', () {
      final now = DateTime.now().toUtc();
      final tracker = Tracker(
        id: 'tr1',
        taskId: 't1',
        startedAt: now,
        stoppedAt: null,
        durationSeconds: 0,
        targetSeconds: 1500,
      );

      final json = tracker.toJson();
      final fromJson = Tracker.fromJson(json);

      expect(fromJson, equals(tracker));
      expect(fromJson.stoppedAt, isNull);
    });

    test('roundtrip JSON with stoppedAt', () {
      final now = DateTime.now().toUtc();
      final stop = now.add(const Duration(minutes: 25));
      final tracker = Tracker(
        id: 'tr1',
        taskId: 't1',
        startedAt: now,
        stoppedAt: stop,
        durationSeconds: 1500,
        targetSeconds: 1500,
      );

      final json = tracker.toJson();
      final fromJson = Tracker.fromJson(json);

      expect(fromJson, equals(tracker));
      expect(fromJson.stoppedAt, equals(stop));
      expect(fromJson.durationSeconds, equals(1500));
    });

    test('equality', () {
      final now = DateTime.now().toUtc();
      final t1 = Tracker(id: 'tr1', taskId: 't1', startedAt: now);
      final t2 = Tracker(id: 'tr1', taskId: 't1', startedAt: now);

      expect(t1 == t2, isTrue);
    });
  });
}
