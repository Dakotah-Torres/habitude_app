import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';
import 'package:habitude/features/timer/timer_state.dart';
import 'package:habitude/features/timer/tracker.dart';
import 'package:habitude/features/timer/tracker_repository.dart';

part 'timer_notifier.g.dart';

const _kTaskId = 'timer_task_id';
const _kTrackerId = 'timer_tracker_id';
const _kEnergyScore = 'timer_energy_score';
const _kTargetSecs = 'timer_target_secs';
const _kStartedAt = 'timer_started_at';
const _kElapsed = 'timer_elapsed';

int computeElapsed(DateTime startedAt, DateTime now) {
  final diff = now.difference(startedAt).inSeconds;
  return diff < 0 ? 0 : diff;
}

bool isComplete(int elapsedSeconds, int targetSeconds) {
  return elapsedSeconds >= targetSeconds;
}

@Riverpod(name: 'timerNotifierProvider')
class TimerNotifier extends _$TimerNotifier {
  Timer? _timer;

  @override
  TimerState build() {
    ref.onDispose(() => _timer?.cancel());
    reconcile();
    return const TimerState(status: TimerStatus.idle);
  }

  Future<void> reconcile() async {
    final prefs = await SharedPreferences.getInstance();
    final taskId = prefs.getString(_kTaskId);
    final trackerId = prefs.getString(_kTrackerId);
    final startedAtStr = prefs.getString(_kStartedAt);

    if (taskId != null && trackerId != null && startedAtStr != null) {
      final startedAt = DateTime.parse(startedAtStr).toUtc();
      final energyScore = prefs.getInt(_kEnergyScore) ?? 0;
      final targetSeconds = prefs.getInt(_kTargetSecs) ?? 1500;
      final pausedElapsed = prefs.getInt(_kElapsed);

      if (pausedElapsed != null) {
        state = TimerState(
          status: TimerStatus.paused,
          taskId: taskId,
          trackerId: trackerId,
          energyScore: energyScore,
          targetSeconds: targetSeconds,
          elapsedSeconds: pausedElapsed,
          startedAt: startedAt,
        );
      } else {
        final elapsed = computeElapsed(startedAt, DateTime.now().toUtc());
        state = TimerState(
          status: TimerStatus.running,
          taskId: taskId,
          trackerId: trackerId,
          energyScore: energyScore,
          targetSeconds: targetSeconds,
          elapsedSeconds: elapsed,
          startedAt: startedAt,
        );
        _startTicking();
      }
    }
  }

  Future<void> startTimer({
    required String taskId,
    required int energyScore,
    int targetSeconds = 1500,
  }) async {
    final now = DateTime.now().toUtc();
    final trackerId = now.millisecondsSinceEpoch.toString();

    final tracker = Tracker(
      id: trackerId,
      taskId: taskId,
      startedAt: now,
      targetSeconds: targetSeconds,
    );

    await ref.read(trackerRepositoryProvider).addTracker(tracker);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kTaskId, taskId);
    await prefs.setString(_kTrackerId, trackerId);
    await prefs.setInt(_kEnergyScore, energyScore);
    await prefs.setInt(_kTargetSecs, targetSeconds);
    await prefs.setString(_kStartedAt, now.toIso8601String());
    await prefs.remove(_kElapsed);

    state = TimerState(
      status: TimerStatus.running,
      taskId: taskId,
      trackerId: trackerId,
      energyScore: energyScore,
      targetSeconds: targetSeconds,
      elapsedSeconds: 0,
      startedAt: now,
    );

    _startTicking();
  }

  Future<void> pauseTimer() async {
    if (state.status != TimerStatus.running) return;

    _timer?.cancel();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kElapsed, state.elapsedSeconds);

    state = state.copyWith(status: TimerStatus.paused);
  }

  Future<void> resumeTimer() async {
    if (state.status != TimerStatus.paused) return;

    final now = DateTime.now().toUtc();
    final adjustedStartedAt = now.subtract(
      Duration(seconds: state.elapsedSeconds),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kStartedAt, adjustedStartedAt.toIso8601String());
    await prefs.remove(_kElapsed);

    state = state.copyWith(
      status: TimerStatus.running,
      startedAt: adjustedStartedAt,
    );
    _startTicking();
  }

  Future<void> stopTimer() async {
    _timer?.cancel();

    final stoppedAt = DateTime.now().toUtc();
    final trackerId = state.trackerId;
    final taskId = state.taskId;

    if (trackerId != null && taskId != null) {
      final tracker = Tracker(
        id: trackerId,
        taskId: taskId,
        startedAt: state.startedAt!,
        stoppedAt: stoppedAt,
        durationSeconds: state.elapsedSeconds,
        targetSeconds: state.targetSeconds,
      );
      await ref.read(trackerRepositoryProvider).updateTracker(tracker);

      final completion = TaskCompletion(
        id: stoppedAt.millisecondsSinceEpoch.toString(),
        taskId: taskId,
        energyScore: state.energyScore,
        completedAt: stoppedAt,
      );
      await ref
          .read(taskCompletionRepositoryProvider)
          .addCompletion(completion);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kTaskId);
    await prefs.remove(_kTrackerId);
    await prefs.remove(_kEnergyScore);
    await prefs.remove(_kTargetSecs);
    await prefs.remove(_kStartedAt);
    await prefs.remove(_kElapsed);

    state = const TimerState(status: TimerStatus.idle);
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      state = state.copyWith(elapsedSeconds: state.elapsedSeconds + 1);
    });
  }
}
