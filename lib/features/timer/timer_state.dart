import 'package:freezed_annotation/freezed_annotation.dart';

part 'timer_state.freezed.dart';

enum TimerStatus { idle, running, paused, overtime }

@freezed
abstract class TimerState with _$TimerState {
  const factory TimerState({
    required TimerStatus status,
    String? taskId,
    String? trackerId,
    @Default(0) int energyScore,
    @Default(1500) int targetSeconds,
    @Default(0) int elapsedSeconds,
    @Default(0) int overtimeSeconds,
    DateTime? startedAt,
    DateTime? lastCheckInAt,
    @Default(false) bool awaitingCheckIn,
  }) = _TimerState;
}
