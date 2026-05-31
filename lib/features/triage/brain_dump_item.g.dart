// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brain_dump_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BrainDumpItem _$BrainDumpItemFromJson(Map<String, dynamic> json) =>
    _BrainDumpItem(
      id: json['id'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      backloggedUntil: json['backloggedUntil'] == null
          ? null
          : DateTime.parse(json['backloggedUntil'] as String),
      scheduledForDate: json['scheduledForDate'] == null
          ? null
          : DateTime.parse(json['scheduledForDate'] as String),
    );

Map<String, dynamic> _$BrainDumpItemToJson(_BrainDumpItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'text': instance.text,
      'createdAt': instance.createdAt.toIso8601String(),
      'backloggedUntil': instance.backloggedUntil?.toIso8601String(),
      'scheduledForDate': instance.scheduledForDate?.toIso8601String(),
    };
