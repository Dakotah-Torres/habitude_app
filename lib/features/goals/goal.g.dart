// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Goal _$GoalFromJson(Map<String, dynamic> json) => _Goal(
  id: json['id'] as String,
  title: json['title'] as String,
  type: $enumDecode(_$GoalTypeEnumMap, json['type']),
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$GoalToJson(_Goal instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'type': _$GoalTypeEnumMap[instance.type]!,
  'createdAt': instance.createdAt.toIso8601String(),
};

const _$GoalTypeEnumMap = {
  GoalType.continuous: 'continuous',
  GoalType.finite: 'finite',
};
