import 'package:freezed_annotation/freezed_annotation.dart';

part 'brain_dump_item.freezed.dart';
part 'brain_dump_item.g.dart';

@freezed
abstract class BrainDumpItem with _$BrainDumpItem {
  const factory BrainDumpItem({
    required String id,
    required String text,
    required DateTime createdAt,
    DateTime? backloggedUntil,
    DateTime? scheduledForDate,
  }) = _BrainDumpItem;

  factory BrainDumpItem.fromJson(Map<String, dynamic> json) =>
      _$BrainDumpItemFromJson(json);
}
