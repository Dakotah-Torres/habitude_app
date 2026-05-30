// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tracker.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Tracker {

 String get id; String get taskId; DateTime get startedAt; DateTime? get stoppedAt; int get durationSeconds; int get targetSeconds;
/// Create a copy of Tracker
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TrackerCopyWith<Tracker> get copyWith => _$TrackerCopyWithImpl<Tracker>(this as Tracker, _$identity);

  /// Serializes this Tracker to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Tracker&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.stoppedAt, stoppedAt) || other.stoppedAt == stoppedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.targetSeconds, targetSeconds) || other.targetSeconds == targetSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,startedAt,stoppedAt,durationSeconds,targetSeconds);

@override
String toString() {
  return 'Tracker(id: $id, taskId: $taskId, startedAt: $startedAt, stoppedAt: $stoppedAt, durationSeconds: $durationSeconds, targetSeconds: $targetSeconds)';
}


}

/// @nodoc
abstract mixin class $TrackerCopyWith<$Res>  {
  factory $TrackerCopyWith(Tracker value, $Res Function(Tracker) _then) = _$TrackerCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, DateTime startedAt, DateTime? stoppedAt, int durationSeconds, int targetSeconds
});




}
/// @nodoc
class _$TrackerCopyWithImpl<$Res>
    implements $TrackerCopyWith<$Res> {
  _$TrackerCopyWithImpl(this._self, this._then);

  final Tracker _self;
  final $Res Function(Tracker) _then;

/// Create a copy of Tracker
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? startedAt = null,Object? stoppedAt = freezed,Object? durationSeconds = null,Object? targetSeconds = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stoppedAt: freezed == stoppedAt ? _self.stoppedAt : stoppedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,targetSeconds: null == targetSeconds ? _self.targetSeconds : targetSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Tracker].
extension TrackerPatterns on Tracker {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Tracker value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Tracker() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Tracker value)  $default,){
final _that = this;
switch (_that) {
case _Tracker():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Tracker value)?  $default,){
final _that = this;
switch (_that) {
case _Tracker() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  DateTime startedAt,  DateTime? stoppedAt,  int durationSeconds,  int targetSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Tracker() when $default != null:
return $default(_that.id,_that.taskId,_that.startedAt,_that.stoppedAt,_that.durationSeconds,_that.targetSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  DateTime startedAt,  DateTime? stoppedAt,  int durationSeconds,  int targetSeconds)  $default,) {final _that = this;
switch (_that) {
case _Tracker():
return $default(_that.id,_that.taskId,_that.startedAt,_that.stoppedAt,_that.durationSeconds,_that.targetSeconds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  DateTime startedAt,  DateTime? stoppedAt,  int durationSeconds,  int targetSeconds)?  $default,) {final _that = this;
switch (_that) {
case _Tracker() when $default != null:
return $default(_that.id,_that.taskId,_that.startedAt,_that.stoppedAt,_that.durationSeconds,_that.targetSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Tracker implements Tracker {
  const _Tracker({required this.id, required this.taskId, required this.startedAt, this.stoppedAt, this.durationSeconds = 0, this.targetSeconds = 1500});
  factory _Tracker.fromJson(Map<String, dynamic> json) => _$TrackerFromJson(json);

@override final  String id;
@override final  String taskId;
@override final  DateTime startedAt;
@override final  DateTime? stoppedAt;
@override@JsonKey() final  int durationSeconds;
@override@JsonKey() final  int targetSeconds;

/// Create a copy of Tracker
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TrackerCopyWith<_Tracker> get copyWith => __$TrackerCopyWithImpl<_Tracker>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TrackerToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Tracker&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.stoppedAt, stoppedAt) || other.stoppedAt == stoppedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.targetSeconds, targetSeconds) || other.targetSeconds == targetSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,startedAt,stoppedAt,durationSeconds,targetSeconds);

@override
String toString() {
  return 'Tracker(id: $id, taskId: $taskId, startedAt: $startedAt, stoppedAt: $stoppedAt, durationSeconds: $durationSeconds, targetSeconds: $targetSeconds)';
}


}

/// @nodoc
abstract mixin class _$TrackerCopyWith<$Res> implements $TrackerCopyWith<$Res> {
  factory _$TrackerCopyWith(_Tracker value, $Res Function(_Tracker) _then) = __$TrackerCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, DateTime startedAt, DateTime? stoppedAt, int durationSeconds, int targetSeconds
});




}
/// @nodoc
class __$TrackerCopyWithImpl<$Res>
    implements _$TrackerCopyWith<$Res> {
  __$TrackerCopyWithImpl(this._self, this._then);

  final _Tracker _self;
  final $Res Function(_Tracker) _then;

/// Create a copy of Tracker
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? startedAt = null,Object? stoppedAt = freezed,Object? durationSeconds = null,Object? targetSeconds = null,}) {
  return _then(_Tracker(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,stoppedAt: freezed == stoppedAt ? _self.stoppedAt : stoppedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,targetSeconds: null == targetSeconds ? _self.targetSeconds : targetSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
