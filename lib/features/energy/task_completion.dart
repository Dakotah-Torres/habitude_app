import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_completion.freezed.dart';
part 'task_completion.g.dart';

@freezed
abstract class TaskCompletion with _$TaskCompletion {
  const factory TaskCompletion({
    required String id,
    required String taskId,
    required int energyScore,
    required DateTime completedAt,
  }) = _TaskCompletion;

  factory TaskCompletion.fromJson(Map<String, dynamic> json) =>
      _$TaskCompletionFromJson(json);
}
