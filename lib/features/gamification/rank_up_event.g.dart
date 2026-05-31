// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rank_up_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RankUpEvent _$RankUpEventFromJson(Map<String, dynamic> json) => _RankUpEvent(
  id: json['id'] as String,
  taskId: json['taskId'] as String,
  triggeredAt: DateTime.parse(json['triggeredAt'] as String),
  newBaselinePoints: (json['newBaselinePoints'] as num).toInt(),
  newRank: $enumDecode(_$RankEnumMap, json['newRank']),
);

Map<String, dynamic> _$RankUpEventToJson(_RankUpEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'triggeredAt': instance.triggeredAt.toIso8601String(),
      'newBaselinePoints': instance.newBaselinePoints,
      'newRank': _$RankEnumMap[instance.newRank]!,
    };

const _$RankEnumMap = {
  Rank.novice: 'novice',
  Rank.adept: 'adept',
  Rank.master: 'master',
};
