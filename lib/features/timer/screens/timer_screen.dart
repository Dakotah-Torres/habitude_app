import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitude/features/goals/task.dart';
import 'package:habitude/features/timer/timer_notifier.dart';
import 'package:habitude/features/timer/timer_state.dart';
import 'package:habitude/shared/theme.dart';

class TimerScreen extends ConsumerStatefulWidget {
  final Task task;

  const TimerScreen({super.key, required this.task});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _maybeStartTimer();
    });
  }

  Future<void> _maybeStartTimer() async {
    final timerState = ref.read(timerNotifierProvider);
    if (timerState.status == TimerStatus.idle) {
      try {
        await ref
            .read(timerNotifierProvider.notifier)
            .startTimer(
              taskId: widget.task.id,
              taskTitle: widget.task.title,
              energyScore: widget.task.energyScore,
            );
      } catch (e) {
        if (mounted) {
          setState(() {
            _errorMessage = 'Timer did not start';
          });
        }
      }
    } else if (timerState.taskId != widget.task.id) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Timer already running'),
          content: const Text(
            'Finish or stop the current session before starting another.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      ).then((_) {
        if (mounted) Navigator.pop(context);
      });
    }

    if (timerState.awaitingCheckIn) {
      _showCheckInModal();
    }
  }

  @override
  Widget build(BuildContext context) {
    final timerState = ref.watch(timerNotifierProvider);

    // Watch for check-in modal
    ref.listen(timerNotifierProvider.select((s) => s.awaitingCheckIn), (
      previous,
      next,
    ) {
      if (next == true) {
        _showCheckInModal();
      }
    });

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Focus'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.task.title,
                    style: Theme.of(
                      context,
                    ).textTheme.titleMedium?.copyWith(color: AppColors.mesaSky),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceLight,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.juniper.withAlpha(25),
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.info_outline,
                          color: AppColors.juniper,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                color: AppColors.juniper,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Nothing was logged. Try again when you are ready.',
                          style: TextStyle(color: AppColors.juniper),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final isOvertime = timerState.status == TimerStatus.overtime;
    final displayTime = isOvertime
        ? _formatOvertime(timerState.overtimeSeconds)
        : _formatCountdown(
            timerState.targetSeconds - timerState.elapsedSeconds,
          );

    final progress = isOvertime
        ? 1.0
        : (timerState.elapsedSeconds / timerState.targetSeconds).clamp(
            0.0,
            1.0,
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Focusing on',
                    style: TextStyle(fontSize: 14, color: AppColors.mesaSky),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      widget.task.title,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.juniper,
                            fontWeight: FontWeight.bold,
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 48),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 240,
                        height: 240,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 12,
                          color: isOvertime
                              ? AppColors.ember
                              : AppColors.juniper,
                          backgroundColor: AppColors.surfaceLight,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isOvertime)
                            const Text(
                              'Overtime',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.ember,
                              ),
                            ),
                          Text(
                            displayTime,
                            style: Theme.of(context).textTheme.displayLarge
                                ?.copyWith(
                                  color: AppColors.juniper,
                                  fontWeight: FontWeight.bold,
                                  fontFeatures: [
                                    const FontFeature.tabularFigures(),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  Text(
                    isOvertime
                        ? 'Focus goal reached — overtime is yours if you want it.'
                        : 'Stay with this until the bell.',
                    style: TextStyle(
                      color: isOvertime ? AppColors.saguaro : AppColors.mesaSky,
                      fontWeight: isOvertime
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _PauseResumeButton(status: timerState.status),
                      const SizedBox(width: 32),
                      _StopButton(onStop: _confirmStop),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showCheckInModal() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Still focusing?'),
        content: const Text(
          'No pressure. If you are still in it, we will keep overtime going. If not, we can stop here and protect your energy record.',
        ),
        actions: [
          OutlinedButton(
            onPressed: () {
              ref.read(timerNotifierProvider.notifier).stopTimer();
              Navigator.pop(context); // Close dialog
              Navigator.pop(this.context); // Pop screen
            },
            child: const Text('Stop timer'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(timerNotifierProvider.notifier).checkIn();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.ember,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, still here'),
          ),
        ],
      ),
    );
  }

  void _confirmStop() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Stop this focus session?'),
        content: const Text(
          'We will save the focus time you have already logged.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep focusing'),
          ),
          TextButton(
            onPressed: () {
              ref.read(timerNotifierProvider.notifier).stopTimer();
              Navigator.pop(context); // Close dialog
              Navigator.pop(this.context); // Pop screen
            },
            child: const Text('Stop timer'),
          ),
        ],
      ),
    );
  }

  String _formatCountdown(int seconds) {
    final s = seconds.clamp(0, double.infinity).toInt();
    final mins = s ~/ 60;
    final secs = s % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  String _formatOvertime(int seconds) {
    final absSeconds = seconds.abs();
    final hours = absSeconds ~/ 3600;
    final mins = (absSeconds % 3600) ~/ 60;
    final secs = absSeconds % 60;

    if (hours > 0) {
      return '+$hours:${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '+${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }
}

class _PauseResumeButton extends ConsumerWidget {
  final TimerStatus status;

  const _PauseResumeButton({required this.status});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPaused = status == TimerStatus.paused;
    final label = isPaused ? 'Resume' : 'Pause';
    final icon = isPaused ? Icons.play_arrow : Icons.pause;

    return FilledButton.tonalIcon(
      onPressed: () {
        if (isPaused) {
          ref.read(timerNotifierProvider.notifier).resumeTimer();
        } else {
          ref.read(timerNotifierProvider.notifier).pauseTimer();
        }
      },
      icon: Icon(icon),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.surfaceLight,
        foregroundColor: AppColors.juniper,
      ),
    );
  }
}

class _StopButton extends StatelessWidget {
  final VoidCallback onStop;

  const _StopButton({required this.onStop});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onStop,
      icon: const Icon(Icons.stop),
      label: const Text('Stop'),
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.mesaSky,
        side: const BorderSide(color: AppColors.mesaSky),
      ),
    );
  }
}
