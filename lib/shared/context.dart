import 'package:freezed_annotation/freezed_annotation.dart';

part 'context.freezed.dart';
part 'context.g.dart';

@freezed
abstract class Context with _$Context {
  const factory Context({
    required String id,
    required String name,
    required String colorHex,
  }) = _Context;

  factory Context.fromJson(Map<String, dynamic> json) =>
      _$ContextFromJson(json);
}
