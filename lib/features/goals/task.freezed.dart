// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Task {

 String get id; String get parentId; ParentType get parentType; String get title; int get energyScore; TaskType get taskType; int? get weeklyQuota; DateTime get createdAt;
/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskCopyWith<Task> get copyWith => _$TaskCopyWithImpl<Task>(this as Task, _$identity);

  /// Serializes this Task to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Task&&(identical(other.id, id) || other.id == id)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.parentType, parentType) || other.parentType == parentType)&&(identical(other.title, title) || other.title == title)&&(identical(other.energyScore, energyScore) || other.energyScore == energyScore)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.weeklyQuota, weeklyQuota) || other.weeklyQuota == weeklyQuota)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentId,parentType,title,energyScore,taskType,weeklyQuota,createdAt);

@override
String toString() {
  return 'Task(id: $id, parentId: $parentId, parentType: $parentType, title: $title, energyScore: $energyScore, taskType: $taskType, weeklyQuota: $weeklyQuota, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TaskCopyWith<$Res>  {
  factory $TaskCopyWith(Task value, $Res Function(Task) _then) = _$TaskCopyWithImpl;
@useResult
$Res call({
 String id, String parentId, ParentType parentType, String title, int energyScore, TaskType taskType, int? weeklyQuota, DateTime createdAt
});




}
/// @nodoc
class _$TaskCopyWithImpl<$Res>
    implements $TaskCopyWith<$Res> {
  _$TaskCopyWithImpl(this._self, this._then);

  final Task _self;
  final $Res Function(Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? parentId = null,Object? parentType = null,Object? title = null,Object? energyScore = null,Object? taskType = null,Object? weeklyQuota = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,parentId: null == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String,parentType: null == parentType ? _self.parentType : parentType // ignore: cast_nullable_to_non_nullable
as ParentType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,energyScore: null == energyScore ? _self.energyScore : energyScore // ignore: cast_nullable_to_non_nullable
as int,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as TaskType,weeklyQuota: freezed == weeklyQuota ? _self.weeklyQuota : weeklyQuota // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Task].
extension TaskPatterns on Task {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Task value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Task value)  $default,){
final _that = this;
switch (_that) {
case _Task():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Task value)?  $default,){
final _that = this;
switch (_that) {
case _Task() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String parentId,  ParentType parentType,  String title,  int energyScore,  TaskType taskType,  int? weeklyQuota,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.parentId,_that.parentType,_that.title,_that.energyScore,_that.taskType,_that.weeklyQuota,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String parentId,  ParentType parentType,  String title,  int energyScore,  TaskType taskType,  int? weeklyQuota,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Task():
return $default(_that.id,_that.parentId,_that.parentType,_that.title,_that.energyScore,_that.taskType,_that.weeklyQuota,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String parentId,  ParentType parentType,  String title,  int energyScore,  TaskType taskType,  int? weeklyQuota,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Task() when $default != null:
return $default(_that.id,_that.parentId,_that.parentType,_that.title,_that.energyScore,_that.taskType,_that.weeklyQuota,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Task implements Task {
  const _Task({required this.id, required this.parentId, required this.parentType, required this.title, required this.energyScore, required this.taskType, this.weeklyQuota, required this.createdAt});
  factory _Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

@override final  String id;
@override final  String parentId;
@override final  ParentType parentType;
@override final  String title;
@override final  int energyScore;
@override final  TaskType taskType;
@override final  int? weeklyQuota;
@override final  DateTime createdAt;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskCopyWith<_Task> get copyWith => __$TaskCopyWithImpl<_Task>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Task&&(identical(other.id, id) || other.id == id)&&(identical(other.parentId, parentId) || other.parentId == parentId)&&(identical(other.parentType, parentType) || other.parentType == parentType)&&(identical(other.title, title) || other.title == title)&&(identical(other.energyScore, energyScore) || other.energyScore == energyScore)&&(identical(other.taskType, taskType) || other.taskType == taskType)&&(identical(other.weeklyQuota, weeklyQuota) || other.weeklyQuota == weeklyQuota)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,parentId,parentType,title,energyScore,taskType,weeklyQuota,createdAt);

@override
String toString() {
  return 'Task(id: $id, parentId: $parentId, parentType: $parentType, title: $title, energyScore: $energyScore, taskType: $taskType, weeklyQuota: $weeklyQuota, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TaskCopyWith<$Res> implements $TaskCopyWith<$Res> {
  factory _$TaskCopyWith(_Task value, $Res Function(_Task) _then) = __$TaskCopyWithImpl;
@override @useResult
$Res call({
 String id, String parentId, ParentType parentType, String title, int energyScore, TaskType taskType, int? weeklyQuota, DateTime createdAt
});




}
/// @nodoc
class __$TaskCopyWithImpl<$Res>
    implements _$TaskCopyWith<$Res> {
  __$TaskCopyWithImpl(this._self, this._then);

  final _Task _self;
  final $Res Function(_Task) _then;

/// Create a copy of Task
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? parentId = null,Object? parentType = null,Object? title = null,Object? energyScore = null,Object? taskType = null,Object? weeklyQuota = freezed,Object? createdAt = null,}) {
  return _then(_Task(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,parentId: null == parentId ? _self.parentId : parentId // ignore: cast_nullable_to_non_nullable
as String,parentType: null == parentType ? _self.parentType : parentType // ignore: cast_nullable_to_non_nullable
as ParentType,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,energyScore: null == energyScore ? _self.energyScore : energyScore // ignore: cast_nullable_to_non_nullable
as int,taskType: null == taskType ? _self.taskType : taskType // ignore: cast_nullable_to_non_nullable
as TaskType,weeklyQuota: freezed == weeklyQuota ? _self.weeklyQuota : weeklyQuota // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
