// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_completion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TaskCompletion _$TaskCompletionFromJson(Map<String, dynamic> json) =>
    _TaskCompletion(
      id: json['id'] as String,
      taskId: json['taskId'] as String,
      energyScore: (json['energyScore'] as num).toInt(),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$TaskCompletionToJson(_TaskCompletion instance) =>
    <String, dynamic>{
      'id': instance.id,
      'taskId': instance.taskId,
      'energyScore': instance.energyScore,
      'completedAt': instance.completedAt.toIso8601String(),
    };
