// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Task _$TaskFromJson(Map<String, dynamic> json) => _Task(
  id: json['id'] as String,
  parentId: json['parentId'] as String,
  parentType: $enumDecode(_$ParentTypeEnumMap, json['parentType']),
  title: json['title'] as String,
  energyScore: (json['energyScore'] as num).toInt(),
  taskType: $enumDecode(_$TaskTypeEnumMap, json['taskType']),
  weeklyQuota: (json['weeklyQuota'] as num?)?.toInt(),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$TaskToJson(_Task instance) => <String, dynamic>{
  'id': instance.id,
  'parentId': instance.parentId,
  'parentType': _$ParentTypeEnumMap[instance.parentType]!,
  'title': instance.title,
  'energyScore': instance.energyScore,
  'taskType': _$TaskTypeEnumMap[instance.taskType]!,
  'weeklyQuota': instance.weeklyQuota,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$ParentTypeEnumMap = {
  ParentType.goal: 'goal',
  ParentType.project: 'project',
};

const _$TaskTypeEnumMap = {
  TaskType.oneTime: 'oneTime',
  TaskType.recurring: 'recurring',
};
