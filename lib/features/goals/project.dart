import 'package:freezed_annotation/freezed_annotation.dart';

part 'project.freezed.dart';
part 'project.g.dart';

enum ProjectStatus { active, completed, archived }

@freezed
abstract class Project with _$Project {
  const factory Project({
    required String id,
    required String goalId,
    required String title,
    required ProjectStatus status,
    DateTime? dueDate,
    required DateTime createdAt,
  }) = _Project;

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);
}
