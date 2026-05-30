import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/timer/timer_state.dart';

void main() {
  group('TimerState', () {
    test('default state values', () {
      const state = TimerState(status: TimerStatus.idle);

      expect(state.status, equals(TimerStatus.idle));
      expect(state.elapsedSeconds, equals(0));
      expect(state.taskId, isNull);
      expect(state.trackerId, isNull);
      expect(state.energyScore, equals(0));
      expect(state.targetSeconds, equals(1500));
      expect(state.startedAt, isNull);
    });

    test('equality', () {
      final now = DateTime.now().toUtc();
      final s1 = TimerState(
        status: TimerStatus.running,
        taskId: 't1',
        trackerId: 'tr1',
        energyScore: 30,
        targetSeconds: 1500,
        elapsedSeconds: 10,
        startedAt: now,
      );
      final s2 = TimerState(
        status: TimerStatus.running,
        taskId: 't1',
        trackerId: 'tr1',
        energyScore: 30,
        targetSeconds: 1500,
        elapsedSeconds: 10,
        startedAt: now,
      );

      expect(s1 == s2, isTrue);
    });
  });
}
