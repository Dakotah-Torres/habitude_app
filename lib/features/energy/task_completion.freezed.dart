// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_completion.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TaskCompletion {

 String get id; String get taskId; int get energyScore; DateTime get completedAt;
/// Create a copy of TaskCompletion
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCompletionCopyWith<TaskCompletion> get copyWith => _$TaskCompletionCopyWithImpl<TaskCompletion>(this as TaskCompletion, _$identity);

  /// Serializes this TaskCompletion to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskCompletion&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.energyScore, energyScore) || other.energyScore == energyScore)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,energyScore,completedAt);

@override
String toString() {
  return 'TaskCompletion(id: $id, taskId: $taskId, energyScore: $energyScore, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class $TaskCompletionCopyWith<$Res>  {
  factory $TaskCompletionCopyWith(TaskCompletion value, $Res Function(TaskCompletion) _then) = _$TaskCompletionCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, int energyScore, DateTime completedAt
});




}
/// @nodoc
class _$TaskCompletionCopyWithImpl<$Res>
    implements $TaskCompletionCopyWith<$Res> {
  _$TaskCompletionCopyWithImpl(this._self, this._then);

  final TaskCompletion _self;
  final $Res Function(TaskCompletion) _then;

/// Create a copy of TaskCompletion
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? energyScore = null,Object? completedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,energyScore: null == energyScore ? _self.energyScore : energyScore // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskCompletion].
extension TaskCompletionPatterns on TaskCompletion {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskCompletion value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskCompletion() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskCompletion value)  $default,){
final _that = this;
switch (_that) {
case _TaskCompletion():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskCompletion value)?  $default,){
final _that = this;
switch (_that) {
case _TaskCompletion() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  int energyScore,  DateTime completedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskCompletion() when $default != null:
return $default(_that.id,_that.taskId,_that.energyScore,_that.completedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  int energyScore,  DateTime completedAt)  $default,) {final _that = this;
switch (_that) {
case _TaskCompletion():
return $default(_that.id,_that.taskId,_that.energyScore,_that.completedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  int energyScore,  DateTime completedAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskCompletion() when $default != null:
return $default(_that.id,_that.taskId,_that.energyScore,_that.completedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TaskCompletion implements TaskCompletion {
  const _TaskCompletion({required this.id, required this.taskId, required this.energyScore, required this.completedAt});
  factory _TaskCompletion.fromJson(Map<String, dynamic> json) => _$TaskCompletionFromJson(json);

@override final  String id;
@override final  String taskId;
@override final  int energyScore;
@override final  DateTime completedAt;

/// Create a copy of TaskCompletion
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCompletionCopyWith<_TaskCompletion> get copyWith => __$TaskCompletionCopyWithImpl<_TaskCompletion>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskCompletionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskCompletion&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.energyScore, energyScore) || other.energyScore == energyScore)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,energyScore,completedAt);

@override
String toString() {
  return 'TaskCompletion(id: $id, taskId: $taskId, energyScore: $energyScore, completedAt: $completedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskCompletionCopyWith<$Res> implements $TaskCompletionCopyWith<$Res> {
  factory _$TaskCompletionCopyWith(_TaskCompletion value, $Res Function(_TaskCompletion) _then) = __$TaskCompletionCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, int energyScore, DateTime completedAt
});




}
/// @nodoc
class __$TaskCompletionCopyWithImpl<$Res>
    implements _$TaskCompletionCopyWith<$Res> {
  __$TaskCompletionCopyWithImpl(this._self, this._then);

  final _TaskCompletion _self;
  final $Res Function(_TaskCompletion) _then;

/// Create a copy of TaskCompletion
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? energyScore = null,Object? completedAt = null,}) {
  return _then(_TaskCompletion(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,energyScore: null == energyScore ? _self.energyScore : energyScore // ignore: cast_nullable_to_non_nullable
as int,completedAt: null == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
