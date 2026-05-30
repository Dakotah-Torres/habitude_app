// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'timer_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TimerState {

 TimerStatus get status; String? get taskId; String? get trackerId; int get energyScore; int get targetSeconds; int get elapsedSeconds; DateTime? get startedAt;
/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TimerStateCopyWith<TimerState> get copyWith => _$TimerStateCopyWithImpl<TimerState>(this as TimerState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TimerState&&(identical(other.status, status) || other.status == status)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.trackerId, trackerId) || other.trackerId == trackerId)&&(identical(other.energyScore, energyScore) || other.energyScore == energyScore)&&(identical(other.targetSeconds, targetSeconds) || other.targetSeconds == targetSeconds)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}


@override
int get hashCode => Object.hash(runtimeType,status,taskId,trackerId,energyScore,targetSeconds,elapsedSeconds,startedAt);

@override
String toString() {
  return 'TimerState(status: $status, taskId: $taskId, trackerId: $trackerId, energyScore: $energyScore, targetSeconds: $targetSeconds, elapsedSeconds: $elapsedSeconds, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class $TimerStateCopyWith<$Res>  {
  factory $TimerStateCopyWith(TimerState value, $Res Function(TimerState) _then) = _$TimerStateCopyWithImpl;
@useResult
$Res call({
 TimerStatus status, String? taskId, String? trackerId, int energyScore, int targetSeconds, int elapsedSeconds, DateTime? startedAt
});




}
/// @nodoc
class _$TimerStateCopyWithImpl<$Res>
    implements $TimerStateCopyWith<$Res> {
  _$TimerStateCopyWithImpl(this._self, this._then);

  final TimerState _self;
  final $Res Function(TimerState) _then;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? taskId = freezed,Object? trackerId = freezed,Object? energyScore = null,Object? targetSeconds = null,Object? elapsedSeconds = null,Object? startedAt = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TimerStatus,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,trackerId: freezed == trackerId ? _self.trackerId : trackerId // ignore: cast_nullable_to_non_nullable
as String?,energyScore: null == energyScore ? _self.energyScore : energyScore // ignore: cast_nullable_to_non_nullable
as int,targetSeconds: null == targetSeconds ? _self.targetSeconds : targetSeconds // ignore: cast_nullable_to_non_nullable
as int,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TimerState].
extension TimerStatePatterns on TimerState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TimerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TimerState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TimerState value)  $default,){
final _that = this;
switch (_that) {
case _TimerState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TimerState value)?  $default,){
final _that = this;
switch (_that) {
case _TimerState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( TimerStatus status,  String? taskId,  String? trackerId,  int energyScore,  int targetSeconds,  int elapsedSeconds,  DateTime? startedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TimerState() when $default != null:
return $default(_that.status,_that.taskId,_that.trackerId,_that.energyScore,_that.targetSeconds,_that.elapsedSeconds,_that.startedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( TimerStatus status,  String? taskId,  String? trackerId,  int energyScore,  int targetSeconds,  int elapsedSeconds,  DateTime? startedAt)  $default,) {final _that = this;
switch (_that) {
case _TimerState():
return $default(_that.status,_that.taskId,_that.trackerId,_that.energyScore,_that.targetSeconds,_that.elapsedSeconds,_that.startedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( TimerStatus status,  String? taskId,  String? trackerId,  int energyScore,  int targetSeconds,  int elapsedSeconds,  DateTime? startedAt)?  $default,) {final _that = this;
switch (_that) {
case _TimerState() when $default != null:
return $default(_that.status,_that.taskId,_that.trackerId,_that.energyScore,_that.targetSeconds,_that.elapsedSeconds,_that.startedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TimerState implements TimerState {
  const _TimerState({required this.status, this.taskId, this.trackerId, this.energyScore = 0, this.targetSeconds = 1500, this.elapsedSeconds = 0, this.startedAt});
  

@override final  TimerStatus status;
@override final  String? taskId;
@override final  String? trackerId;
@override@JsonKey() final  int energyScore;
@override@JsonKey() final  int targetSeconds;
@override@JsonKey() final  int elapsedSeconds;
@override final  DateTime? startedAt;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TimerStateCopyWith<_TimerState> get copyWith => __$TimerStateCopyWithImpl<_TimerState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TimerState&&(identical(other.status, status) || other.status == status)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.trackerId, trackerId) || other.trackerId == trackerId)&&(identical(other.energyScore, energyScore) || other.energyScore == energyScore)&&(identical(other.targetSeconds, targetSeconds) || other.targetSeconds == targetSeconds)&&(identical(other.elapsedSeconds, elapsedSeconds) || other.elapsedSeconds == elapsedSeconds)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt));
}


@override
int get hashCode => Object.hash(runtimeType,status,taskId,trackerId,energyScore,targetSeconds,elapsedSeconds,startedAt);

@override
String toString() {
  return 'TimerState(status: $status, taskId: $taskId, trackerId: $trackerId, energyScore: $energyScore, targetSeconds: $targetSeconds, elapsedSeconds: $elapsedSeconds, startedAt: $startedAt)';
}


}

/// @nodoc
abstract mixin class _$TimerStateCopyWith<$Res> implements $TimerStateCopyWith<$Res> {
  factory _$TimerStateCopyWith(_TimerState value, $Res Function(_TimerState) _then) = __$TimerStateCopyWithImpl;
@override @useResult
$Res call({
 TimerStatus status, String? taskId, String? trackerId, int energyScore, int targetSeconds, int elapsedSeconds, DateTime? startedAt
});




}
/// @nodoc
class __$TimerStateCopyWithImpl<$Res>
    implements _$TimerStateCopyWith<$Res> {
  __$TimerStateCopyWithImpl(this._self, this._then);

  final _TimerState _self;
  final $Res Function(_TimerState) _then;

/// Create a copy of TimerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? taskId = freezed,Object? trackerId = freezed,Object? energyScore = null,Object? targetSeconds = null,Object? elapsedSeconds = null,Object? startedAt = freezed,}) {
  return _then(_TimerState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TimerStatus,taskId: freezed == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String?,trackerId: freezed == trackerId ? _self.trackerId : trackerId // ignore: cast_nullable_to_non_nullable
as String?,energyScore: null == energyScore ? _self.energyScore : energyScore // ignore: cast_nullable_to_non_nullable
as int,targetSeconds: null == targetSeconds ? _self.targetSeconds : targetSeconds // ignore: cast_nullable_to_non_nullable
as int,elapsedSeconds: null == elapsedSeconds ? _self.elapsedSeconds : elapsedSeconds // ignore: cast_nullable_to_non_nullable
as int,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
