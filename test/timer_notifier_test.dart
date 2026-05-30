import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';
import 'package:habitude/features/timer/timer_notifier.dart';
import 'package:habitude/features/timer/timer_state.dart';
import 'package:habitude/features/timer/tracker.dart';
import 'package:habitude/features/timer/tracker_repository.dart';

class FakeTrackerRepository extends Fake implements TrackerRepository {
  final List<Tracker> trackers = [];
  @override
  Future<void> addTracker(Tracker t) async => trackers.add(t);
  @override
  Future<void> updateTracker(Tracker t) async {
    final idx = trackers.indexWhere((existing) => existing.id == t.id);
    if (idx != -1) trackers[idx] = t;
  }
}

class FakeTaskCompletionRepository extends Fake
    implements TaskCompletionRepository {
  final List<TaskCompletion> completions = [];
  @override
  Future<void> addCompletion(TaskCompletion c) async => completions.add(c);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Timer Pure Helpers', () {
    test('computeElapsed returns correct seconds', () {
      final start = DateTime.utc(2026, 1, 1, 12, 0, 0);
      final now = DateTime.utc(2026, 1, 1, 12, 1, 30);
      expect(computeElapsed(start, now), equals(90));
    });

    test('computeElapsed returns 0 if now is before start', () {
      final start = DateTime.utc(2026, 1, 1, 12, 0, 0);
      final now = DateTime.utc(2026, 1, 1, 11, 59, 0);
      expect(computeElapsed(start, now), equals(0));
    });

    test('isComplete works correctly', () {
      expect(isComplete(1500, 1500), isTrue);
      expect(isComplete(1501, 1500), isTrue);
      expect(isComplete(1499, 1500), isFalse);
    });
  });

  group('TimerNotifier', () {
    late FakeTrackerRepository trackerRepo;
    late FakeTaskCompletionRepository completionRepo;

    setUp(() {
      trackerRepo = FakeTrackerRepository();
      completionRepo = FakeTaskCompletionRepository();
      SharedPreferences.setMockInitialValues({});
    });

    ProviderContainer createContainer() {
      return ProviderContainer(
        overrides: [
          trackerRepositoryProvider.overrideWithValue(trackerRepo),
          taskCompletionRepositoryProvider.overrideWithValue(completionRepo),
        ],
      );
    }

    test('startTimer updates state and repository', () async {
      final container = createContainer();
      final notifier = container.read(timerNotifierProvider.notifier);

      await notifier.startTimer(taskId: 't1', energyScore: 30);

      final state = container.read(timerNotifierProvider);
      expect(state.status, equals(TimerStatus.running));
      expect(state.taskId, equals('t1'));
      expect(state.energyScore, equals(30));
      expect(state.elapsedSeconds, equals(0));
      expect(trackerRepo.trackers, hasLength(1));
      expect(trackerRepo.trackers.first.taskId, equals('t1'));
    });

    test('pause and resume toggle state', () async {
      final container = createContainer();
      final notifier = container.read(timerNotifierProvider.notifier);

      await notifier.startTimer(taskId: 't1', energyScore: 30);
      await notifier.pauseTimer();

      expect(
        container.read(timerNotifierProvider).status,
        equals(TimerStatus.paused),
      );

      await notifier.resumeTimer();
      expect(
        container.read(timerNotifierProvider).status,
        equals(TimerStatus.running),
      );
    });

    test('stopTimer updates records and clears state', () async {
      final container = createContainer();
      final notifier = container.read(timerNotifierProvider.notifier);

      await notifier.startTimer(taskId: 't1', energyScore: 30);
      await notifier.stopTimer();

      expect(
        container.read(timerNotifierProvider).status,
        equals(TimerStatus.idle),
      );
      expect(trackerRepo.trackers.first.stoppedAt, isNotNull);
      expect(completionRepo.completions, hasLength(1));
      expect(completionRepo.completions.first.energyScore, equals(30));
    });

    test('reconcile restores state from SharedPreferences', () async {
      final now = DateTime.now().toUtc();
      final sixtySecsAgo = now.subtract(const Duration(seconds: 60));

      SharedPreferences.setMockInitialValues({
        'timer_task_id': 't1',
        'timer_tracker_id': 'tr1',
        'timer_energy_score': 30,
        'timer_target_secs': 1500,
        'timer_started_at': sixtySecsAgo.toIso8601String(),
      });

      final container = createContainer();

      TimerState? newState;
      final subscription = container.listen(timerNotifierProvider, (
        prev,
        next,
      ) {
        newState = next;
      }, fireImmediately: true);

      // Trigger build happens on listen/read

      // Wait for async reconcile
      await Future.delayed(const Duration(milliseconds: 200));

      expect(newState, isNotNull);
      expect(newState!.status, equals(TimerStatus.running));
      expect(newState!.taskId, equals('t1'));
      expect(newState!.elapsedSeconds, greaterThanOrEqualTo(60));

      subscription.close();
    });

    test(
      'resumeTimer adjusts persisted start time to exclude paused time',
      () async {
        final now = DateTime.now().toUtc();
        final tenMinutesAgo = now.subtract(const Duration(minutes: 10));

        SharedPreferences.setMockInitialValues({
          'timer_task_id': 't1',
          'timer_tracker_id': 'tr1',
          'timer_energy_score': 30,
          'timer_target_secs': 1500,
          'timer_started_at': tenMinutesAgo.toIso8601String(),
          'timer_elapsed': 60,
        });

        final container = createContainer();
        final subscription = container.listen(
          timerNotifierProvider,
          (prev, next) {},
          fireImmediately: true,
        );
        await Future.delayed(const Duration(milliseconds: 200));

        final notifier = container.read(timerNotifierProvider.notifier);
        expect(
          container.read(timerNotifierProvider).status,
          TimerStatus.paused,
        );
        expect(container.read(timerNotifierProvider).elapsedSeconds, 60);

        await notifier.resumeTimer();

        final prefs = await SharedPreferences.getInstance();
        final persistedStartedAt = DateTime.parse(
          prefs.getString('timer_started_at')!,
        ).toUtc();

        expect(prefs.containsKey('timer_elapsed'), isFalse);
        expect(
          computeElapsed(persistedStartedAt, DateTime.now().toUtc()),
          lessThan(70),
        );
        expect(container.read(timerNotifierProvider).elapsedSeconds, 60);

        subscription.close();
        container.dispose();
      },
    );
  });
}
