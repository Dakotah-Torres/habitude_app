// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Project _$ProjectFromJson(Map<String, dynamic> json) => _Project(
  id: json['id'] as String,
  goalId: json['goalId'] as String,
  title: json['title'] as String,
  status: $enumDecode(_$ProjectStatusEnumMap, json['status']),
  dueDate: json['dueDate'] == null
      ? null
      : DateTime.parse(json['dueDate'] as String),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$ProjectToJson(_Project instance) => <String, dynamic>{
  'id': instance.id,
  'goalId': instance.goalId,
  'title': instance.title,
  'status': _$ProjectStatusEnumMap[instance.status]!,
  'dueDate': instance.dueDate?.toIso8601String(),
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$ProjectStatusEnumMap = {
  ProjectStatus.active: 'active',
  ProjectStatus.completed: 'completed',
  ProjectStatus.archived: 'archived',
};
