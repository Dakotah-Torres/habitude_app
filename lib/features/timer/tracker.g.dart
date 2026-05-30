// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tracker.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Tracker _$TrackerFromJson(Map<String, dynamic> json) => _Tracker(
  id: json['id'] as String,
  taskId: json['taskId'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  stoppedAt: json['stoppedAt'] == null
      ? null
      : DateTime.parse(json['stoppedAt'] as String),
  durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
  targetSeconds: (json['targetSeconds'] as num?)?.toInt() ?? 1500,
);

Map<String, dynamic> _$TrackerToJson(_Tracker instance) => <String, dynamic>{
  'id': instance.id,
  'taskId': instance.taskId,
  'startedAt': instance.startedAt.toIso8601String(),
  'stoppedAt': instance.stoppedAt?.toIso8601String(),
  'durationSeconds': instance.durationSeconds,
  'targetSeconds': instance.targetSeconds,
};
