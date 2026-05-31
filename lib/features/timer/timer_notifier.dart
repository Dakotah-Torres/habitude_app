import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:habitude/features/energy/task_completion.dart';
import 'package:habitude/features/energy/task_completion_repository.dart';
import 'package:habitude/features/timer/timer_foreground_service.dart';
import 'package:habitude/features/timer/timer_state.dart';
import 'package:habitude/features/timer/tracker.dart';
import 'package:habitude/features/timer/tracker_repository.dart';
import 'package:habitude/shared/notification_service.dart';

part 'timer_notifier.g.dart';

const _kTaskId = 'timer_task_id';
const _kTrackerId = 'timer_tracker_id';
const _kEnergyScore = 'timer_energy_score';
const _kTargetSecs = 'timer_target_secs';
const _kStartedAt = 'timer_started_at';
const _kElapsed = 'timer_elapsed';
const _kLastCheckInAt = 'timer_last_check_in_at';

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
  Timer? _dmsTimer;
  String? _currentTaskTitle;

  @override
  TimerState build() {
    ref.onDispose(() {
      _timer?.cancel();
      _dmsTimer?.cancel();
    });
    reconcile();
    return const TimerState(status: TimerStatus.idle);
  }

  Future<void> reconcile() async {
    final prefs = await SharedPreferences.getInstance();
    final taskId = prefs.getString(_kTaskId);
    final trackerId = prefs.getString(_kTrackerId);
    final startedAtStr = prefs.getString(_kStartedAt);
    final lastCheckInStr = prefs.getString(_kLastCheckInAt);

    if (taskId != null && trackerId != null && startedAtStr != null) {
      final startedAt = DateTime.parse(startedAtStr).toUtc();
      final lastCheckInAt = lastCheckInStr != null
          ? DateTime.parse(lastCheckInStr).toUtc()
          : null;
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
          lastCheckInAt: lastCheckInAt,
        );
      } else {
        final now = DateTime.now().toUtc();
        final elapsed = computeElapsed(startedAt, now);

        if (elapsed >= targetSeconds) {
          final overtimeSeconds = elapsed - targetSeconds;
          state = TimerState(
            status: TimerStatus.overtime,
            taskId: taskId,
            trackerId: trackerId,
            energyScore: energyScore,
            targetSeconds: targetSeconds,
            elapsedSeconds: targetSeconds,
            overtimeSeconds: overtimeSeconds,
            startedAt: startedAt,
            lastCheckInAt: lastCheckInAt,
          );
          // Check if we missed a check-in while app was closed
          final lastRef = lastCheckInAt ?? startedAt;
          final timeSinceLastCheckIn = now.difference(lastRef).inSeconds;
          if (timeSinceLastCheckIn >= 1800) {
            _onCheckInDue();
          } else {
            _scheduleCheckInNotification(1800 - timeSinceLastCheckIn);
          }
        } else {
          state = TimerState(
            status: TimerStatus.running,
            taskId: taskId,
            trackerId: trackerId,
            energyScore: energyScore,
            targetSeconds: targetSeconds,
            elapsedSeconds: elapsed,
            startedAt: startedAt,
            lastCheckInAt: lastCheckInAt,
          );
        }
        _startTicking();
      }
    }
  }

  Future<void> startTimer({
    required String taskId,
    required String taskTitle,
    required int energyScore,
    int targetSeconds = 1500,
  }) async {
    _currentTaskTitle = taskTitle;
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
    await prefs.setString(_kLastCheckInAt, now.toIso8601String());
    await prefs.remove(_kElapsed);

    state = TimerState(
      status: TimerStatus.running,
      taskId: taskId,
      trackerId: trackerId,
      energyScore: energyScore,
      targetSeconds: targetSeconds,
      elapsedSeconds: 0,
      startedAt: now,
      lastCheckInAt: now,
    );

    TimerForegroundService.start(taskTitle, _formatDuration(targetSeconds));
    _startTicking();
  }

  Future<void> pauseTimer() async {
    if (state.status != TimerStatus.running &&
        state.status != TimerStatus.overtime) {
      return;
    }

    _timer?.cancel();
    _dmsTimer?.cancel();
    TimerForegroundService.stop();
    _cancelAllNotifications();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_kElapsed, state.elapsedSeconds);

    state = state.copyWith(status: TimerStatus.paused);
  }

  Future<void> resumeTimer() async {
    if (state.status != TimerStatus.paused) {
      return;
    }

    final now = DateTime.now().toUtc();
    final adjustedStartedAt = now.subtract(
      Duration(seconds: state.elapsedSeconds + state.overtimeSeconds),
    );
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kStartedAt, adjustedStartedAt.toIso8601String());
    await prefs.remove(_kElapsed);

    state = state.copyWith(
      status: state.elapsedSeconds >= state.targetSeconds
          ? TimerStatus.overtime
          : TimerStatus.running,
      startedAt: adjustedStartedAt,
    );

    if (state.status == TimerStatus.overtime) {
      _scheduleCheckInNotification(1800);
    }

    TimerForegroundService.start(
      _currentTaskTitle ?? 'Task',
      state.status == TimerStatus.overtime
          ? _formatDuration(state.overtimeSeconds, isOvertime: true)
          : _formatDuration(state.targetSeconds - state.elapsedSeconds),
    );
    _startTicking();
  }

  Future<void> stopTimer() async {
    _timer?.cancel();
    _dmsTimer?.cancel();
    TimerForegroundService.stop();
    _cancelAllNotifications();

    final stoppedAt = DateTime.now().toUtc();
    final trackerId = state.trackerId;
    final taskId = state.taskId;

    if (trackerId != null && taskId != null) {
      final tracker = Tracker(
        id: trackerId,
        taskId: taskId,
        startedAt: state.startedAt!,
        stoppedAt: stoppedAt,
        durationSeconds: state.elapsedSeconds + state.overtimeSeconds,
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
    await prefs.remove(_kLastCheckInAt);

    state = const TimerState(status: TimerStatus.idle);
  }

  Future<void> checkIn() async {
    final now = DateTime.now().toUtc();
    _dmsTimer?.cancel();
    _cancelAllNotifications();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kLastCheckInAt, now.toIso8601String());

    state = state.copyWith(
      lastCheckInAt: now,
      awaitingCheckIn: false,
    );

    _scheduleCheckInNotification(1800);
  }

  void _startTicking() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tick();
    });
  }

  void _tick() {
    final now = DateTime.now().toUtc();
    if (state.status == TimerStatus.running) {
      final newElapsed = state.elapsedSeconds + 1;
      if (newElapsed >= state.targetSeconds) {
        _onTargetReached();
      } else {
        state = state.copyWith(elapsedSeconds: newElapsed);
        TimerForegroundService.update(
          _currentTaskTitle ?? 'Task',
          _formatDuration(state.targetSeconds - newElapsed),
          false,
        );
      }
    } else if (state.status == TimerStatus.overtime) {
      final newOvertime = state.overtimeSeconds + 1;
      state = state.copyWith(overtimeSeconds: newOvertime);

      TimerForegroundService.update(
        _currentTaskTitle ?? 'Task',
        _formatDuration(newOvertime, isOvertime: true),
        true,
      );

      // Check if check-in is due (every 30 mins)
      final lastRef = state.lastCheckInAt ?? state.startedAt!;
      if (now.difference(lastRef).inSeconds >= 1800 && !state.awaitingCheckIn) {
        _onCheckInDue();
      }
    }
  }

  void _onTargetReached() {
    final now = DateTime.now().toUtc();
    state = state.copyWith(
      status: TimerStatus.overtime,
      elapsedSeconds: state.targetSeconds,
      overtimeSeconds: 0,
      lastCheckInAt: now,
    );

    ref.read(notificationServiceProvider).show(
          id: 100,
          title: 'Focus goal reached',
          body: 'Overtime is yours if you want it.',
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'timer_channel',
              'Timer Notifications',
              importance: Importance.high,
              priority: Priority.high,
            ),
          ),
        );

    _scheduleCheckInNotification(1800);
  }

  void _onCheckInDue() {
    state = state.copyWith(awaitingCheckIn: true);

    _dmsTimer?.cancel();
    _dmsTimer = Timer(const Duration(minutes: 5), () {
      _onDeadMansSwitch();
    });
  }

  void _onDeadMansSwitch() async {
    final lastRef = state.lastCheckInAt ?? state.startedAt!;
    final confirmedDuration = lastRef.difference(state.startedAt!).inSeconds;

    _timer?.cancel();
    _dmsTimer?.cancel();
    TimerForegroundService.stop();
    _cancelAllNotifications();

    final stoppedAt = DateTime.now().toUtc();
    final trackerId = state.trackerId;
    final taskId = state.taskId;

    if (trackerId != null && taskId != null) {
      final tracker = Tracker(
        id: trackerId,
        taskId: taskId,
        startedAt: state.startedAt!,
        stoppedAt: stoppedAt,
        durationSeconds: confirmedDuration,
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
    await prefs.remove(_kLastCheckInAt);

    state = const TimerState(status: TimerStatus.idle);

    ref.read(notificationServiceProvider).show(
          id: 102,
          title: 'Timer paused for you',
          body:
              'We saved your confirmed focus time and stopped the timer to protect your energy record.',
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'timer_channel',
              'Timer Notifications',
              importance: Importance.defaultImportance,
            ),
          ),
        );
  }

  String _formatDuration(int seconds, {bool isOvertime = false}) {
    final absSeconds = seconds.abs();
    final hours = absSeconds ~/ 3600;
    final mins = (absSeconds % 3600) ~/ 60;
    final secs = absSeconds % 60;

    final prefix = isOvertime ? '+' : '';

    if (hours > 0) {
      return '$prefix$hours:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '$prefix${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  Future<void> _scheduleCheckInNotification(int secondsFromNow) async {
    final now = DateTime.now().toUtc();
    final scheduledDate = tz.TZDateTime.from(
      now.add(Duration(seconds: secondsFromNow)),
      tz.local,
    );

    await ref.read(notificationServiceProvider).zonedSchedule(
          id: 101,
          title: 'Still focusing?',
          body:
              'Tap to keep overtime going, or stop here and save what you logged.',
          scheduledDate: scheduledDate,
          notificationDetails: const NotificationDetails(
            android: AndroidNotificationDetails(
              'timer_channel',
              'Timer Notifications',
              importance: Importance.high,
              priority: Priority.high,
              actions: [
                AndroidNotificationAction('check_in', 'Yes, still here'),
                AndroidNotificationAction('stop_timer', 'Stop timer'),
              ],
            ),
            iOS: DarwinNotificationDetails(
              presentBanner: true,
              presentList: true,
              presentSound: true,
            ),
          ),
          androidScheduleMode: true,
        );
  }

  void _cancelAllNotifications() {
    ref.read(notificationServiceProvider).cancelAll();
  }
}
