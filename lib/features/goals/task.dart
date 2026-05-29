import 'package:freezed_annotation/freezed_annotation.dart';

part 'task.freezed.dart';
part 'task.g.dart';

enum TaskType { oneTime, recurring }

enum ParentType { goal, project }

@freezed
abstract class Task with _$Task {
  const factory Task({
    required String id,
    required String parentId,
    required ParentType parentType,
    required String title,
    required int energyScore,
    required TaskType taskType,
    int? weeklyQuota,
    required DateTime createdAt,
  }) = _Task;

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
}
