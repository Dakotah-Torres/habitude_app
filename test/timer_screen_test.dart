import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/timer/timer_notifier.dart';
import 'package:habitude/features/timer/timer_state.dart';
import 'package:habitude/features/timer/screens/timer_screen.dart';
import 'package:habitude/shared/theme.dart';

class FakeTimerNotifier extends TimerNotifier {
  TimerState? manualState;
  bool startCalled = false;
  bool stopCalled = false;
  bool checkInCalled = false;
  bool shouldFailStart = false;

  @override
  TimerState build() {
    return manualState ?? const TimerState(status: TimerStatus.idle);
  }

  @override
  Future<void> startTimer({
    required String taskId,
    required String taskTitle,
    required int energyScore,
    int targetSeconds = 1500,
  }) async {
    if (shouldFailStart) {
      throw Exception('Failed to start');
    }
    startCalled = true;
  }

  @override
  Future<void> stopTimer() async {
    stopCalled = true;
  }

  @override
  Future<void> checkIn() async {
    checkInCalled = true;
  }
}

void main() {
  final task = Task(
    id: 't1',
    parentId: 'p1',
    parentType: ParentType.project,
    title: 'Test Task',
    energyScore: 30,
    taskType: TaskType.oneTime,
    createdAt: DateTime.now(),
  );

  group('TimerScreen', () {
    testWidgets('shows task title and countdown', (tester) async {
      final fakeNotifier = FakeTimerNotifier();
      fakeNotifier.manualState = TimerState(
        status: TimerStatus.running,
        taskId: 't1',
        elapsedSeconds: 60,
        targetSeconds: 1500,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [timerNotifierProvider.overrideWith(() => fakeNotifier)],
          child: MaterialApp(
            theme: AppTheme.light,
            home: TimerScreen(task: task),
          ),
        ),
      );

      expect(find.text('Test Task'), findsOneWidget);
      // 1500 - 60 = 1440s = 24:00
      expect(find.text('24:00'), findsOneWidget);
    });

    testWidgets('shows overtime display when status is overtime', (
      tester,
    ) async {
      final fakeNotifier = FakeTimerNotifier();
      fakeNotifier.manualState = TimerState(
        status: TimerStatus.overtime,
        taskId: 't1',
        elapsedSeconds: 1500,
        overtimeSeconds: 125, // 02:05
        targetSeconds: 1500,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [timerNotifierProvider.overrideWith(() => fakeNotifier)],
          child: MaterialApp(
            theme: AppTheme.light,
            home: TimerScreen(task: task),
          ),
        ),
      );

      expect(find.text('+02:05'), findsOneWidget);
      expect(find.text('Overtime'), findsOneWidget);
    });

    testWidgets('shows check-in modal when awaitingCheckIn is true', (
      tester,
    ) async {
      final fakeNotifier = FakeTimerNotifier();
      fakeNotifier.manualState = TimerState(
        status: TimerStatus.overtime,
        taskId: 't1',
        awaitingCheckIn: true,
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [timerNotifierProvider.overrideWith(() => fakeNotifier)],
          child: MaterialApp(
            theme: AppTheme.light,
            home: TimerScreen(task: task),
          ),
        ),
      );

      await tester.pump(); // Handle post-frame or listen

      expect(find.text('Still focusing?'), findsOneWidget);

      await tester.tap(find.text('Yes, still here'));
      expect(fakeNotifier.checkInCalled, isTrue);
    });

    testWidgets('tapping stop shows confirmation dialog', (tester) async {
      final fakeNotifier = FakeTimerNotifier();
      fakeNotifier.manualState = TimerState(
        status: TimerStatus.running,
        taskId: 't1',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [timerNotifierProvider.overrideWith(() => fakeNotifier)],
          child: MaterialApp(
            theme: AppTheme.light,
            home: TimerScreen(task: task),
          ),
        ),
      );

      await tester.tap(find.text('Stop'));
      await tester.pumpAndSettle();

      expect(find.text('Stop this focus session?'), findsOneWidget);

      await tester.tap(find.text('Stop timer'));
      expect(fakeNotifier.stopCalled, isTrue);
    });

    testWidgets('shows calm error panel when timer start fails', (
      tester,
    ) async {
      final fakeNotifier = FakeTimerNotifier();
      fakeNotifier.shouldFailStart = true;

      await tester.pumpWidget(
        ProviderScope(
          overrides: [timerNotifierProvider.overrideWith(() => fakeNotifier)],
          child: MaterialApp(
            theme: AppTheme.light,
            home: TimerScreen(task: task),
          ),
        ),
      );

      await tester.pump(); // Handle post-frame _maybeStartTimer

      expect(find.text('Timer did not start'), findsOneWidget);
      expect(
        find.text('Nothing was logged. Try again when you are ready.'),
        findsOneWidget,
      );
    });
  });
}
