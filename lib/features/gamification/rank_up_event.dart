import 'package:freezed_annotation/freezed_annotation.dart';
import 'gamification_engine.dart';

part 'rank_up_event.freezed.dart';
part 'rank_up_event.g.dart';

@freezed
abstract class RankUpEvent with _$RankUpEvent {
  const factory RankUpEvent({
    required String id,
    required String taskId,
    required DateTime triggeredAt,
    required int newBaselinePoints,
    required Rank newRank,
  }) = _RankUpEvent;

  factory RankUpEvent.fromJson(Map<String, dynamic> json) =>
      _$RankUpEventFromJson(json);
}
