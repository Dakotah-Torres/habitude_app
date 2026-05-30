import 'package:freezed_annotation/freezed_annotation.dart';

part 'tracker.freezed.dart';
part 'tracker.g.dart';

@freezed
abstract class Tracker with _$Tracker {
  const factory Tracker({
    required String id,
    required String taskId,
    required DateTime startedAt,
    DateTime? stoppedAt,
    @Default(0) int durationSeconds,
    @Default(1500) int targetSeconds,
  }) = _Tracker;

  factory Tracker.fromJson(Map<String, dynamic> json) =>
      _$TrackerFromJson(json);
}
