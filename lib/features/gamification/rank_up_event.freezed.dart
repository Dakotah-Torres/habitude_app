// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'rank_up_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RankUpEvent {

 String get id; String get taskId; DateTime get triggeredAt; int get newBaselinePoints; Rank get newRank;
/// Create a copy of RankUpEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RankUpEventCopyWith<RankUpEvent> get copyWith => _$RankUpEventCopyWithImpl<RankUpEvent>(this as RankUpEvent, _$identity);

  /// Serializes this RankUpEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RankUpEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt)&&(identical(other.newBaselinePoints, newBaselinePoints) || other.newBaselinePoints == newBaselinePoints)&&(identical(other.newRank, newRank) || other.newRank == newRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,triggeredAt,newBaselinePoints,newRank);

@override
String toString() {
  return 'RankUpEvent(id: $id, taskId: $taskId, triggeredAt: $triggeredAt, newBaselinePoints: $newBaselinePoints, newRank: $newRank)';
}


}

/// @nodoc
abstract mixin class $RankUpEventCopyWith<$Res>  {
  factory $RankUpEventCopyWith(RankUpEvent value, $Res Function(RankUpEvent) _then) = _$RankUpEventCopyWithImpl;
@useResult
$Res call({
 String id, String taskId, DateTime triggeredAt, int newBaselinePoints, Rank newRank
});




}
/// @nodoc
class _$RankUpEventCopyWithImpl<$Res>
    implements $RankUpEventCopyWith<$Res> {
  _$RankUpEventCopyWithImpl(this._self, this._then);

  final RankUpEvent _self;
  final $Res Function(RankUpEvent) _then;

/// Create a copy of RankUpEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? taskId = null,Object? triggeredAt = null,Object? newBaselinePoints = null,Object? newRank = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,newBaselinePoints: null == newBaselinePoints ? _self.newBaselinePoints : newBaselinePoints // ignore: cast_nullable_to_non_nullable
as int,newRank: null == newRank ? _self.newRank : newRank // ignore: cast_nullable_to_non_nullable
as Rank,
  ));
}

}


/// Adds pattern-matching-related methods to [RankUpEvent].
extension RankUpEventPatterns on RankUpEvent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RankUpEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RankUpEvent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RankUpEvent value)  $default,){
final _that = this;
switch (_that) {
case _RankUpEvent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RankUpEvent value)?  $default,){
final _that = this;
switch (_that) {
case _RankUpEvent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String taskId,  DateTime triggeredAt,  int newBaselinePoints,  Rank newRank)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RankUpEvent() when $default != null:
return $default(_that.id,_that.taskId,_that.triggeredAt,_that.newBaselinePoints,_that.newRank);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String taskId,  DateTime triggeredAt,  int newBaselinePoints,  Rank newRank)  $default,) {final _that = this;
switch (_that) {
case _RankUpEvent():
return $default(_that.id,_that.taskId,_that.triggeredAt,_that.newBaselinePoints,_that.newRank);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String taskId,  DateTime triggeredAt,  int newBaselinePoints,  Rank newRank)?  $default,) {final _that = this;
switch (_that) {
case _RankUpEvent() when $default != null:
return $default(_that.id,_that.taskId,_that.triggeredAt,_that.newBaselinePoints,_that.newRank);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RankUpEvent implements RankUpEvent {
  const _RankUpEvent({required this.id, required this.taskId, required this.triggeredAt, required this.newBaselinePoints, required this.newRank});
  factory _RankUpEvent.fromJson(Map<String, dynamic> json) => _$RankUpEventFromJson(json);

@override final  String id;
@override final  String taskId;
@override final  DateTime triggeredAt;
@override final  int newBaselinePoints;
@override final  Rank newRank;

/// Create a copy of RankUpEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RankUpEventCopyWith<_RankUpEvent> get copyWith => __$RankUpEventCopyWithImpl<_RankUpEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RankUpEventToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RankUpEvent&&(identical(other.id, id) || other.id == id)&&(identical(other.taskId, taskId) || other.taskId == taskId)&&(identical(other.triggeredAt, triggeredAt) || other.triggeredAt == triggeredAt)&&(identical(other.newBaselinePoints, newBaselinePoints) || other.newBaselinePoints == newBaselinePoints)&&(identical(other.newRank, newRank) || other.newRank == newRank));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,taskId,triggeredAt,newBaselinePoints,newRank);

@override
String toString() {
  return 'RankUpEvent(id: $id, taskId: $taskId, triggeredAt: $triggeredAt, newBaselinePoints: $newBaselinePoints, newRank: $newRank)';
}


}

/// @nodoc
abstract mixin class _$RankUpEventCopyWith<$Res> implements $RankUpEventCopyWith<$Res> {
  factory _$RankUpEventCopyWith(_RankUpEvent value, $Res Function(_RankUpEvent) _then) = __$RankUpEventCopyWithImpl;
@override @useResult
$Res call({
 String id, String taskId, DateTime triggeredAt, int newBaselinePoints, Rank newRank
});




}
/// @nodoc
class __$RankUpEventCopyWithImpl<$Res>
    implements _$RankUpEventCopyWith<$Res> {
  __$RankUpEventCopyWithImpl(this._self, this._then);

  final _RankUpEvent _self;
  final $Res Function(_RankUpEvent) _then;

/// Create a copy of RankUpEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? taskId = null,Object? triggeredAt = null,Object? newBaselinePoints = null,Object? newRank = null,}) {
  return _then(_RankUpEvent(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,taskId: null == taskId ? _self.taskId : taskId // ignore: cast_nullable_to_non_nullable
as String,triggeredAt: null == triggeredAt ? _self.triggeredAt : triggeredAt // ignore: cast_nullable_to_non_nullable
as DateTime,newBaselinePoints: null == newBaselinePoints ? _self.newBaselinePoints : newBaselinePoints // ignore: cast_nullable_to_non_nullable
as int,newRank: null == newRank ? _self.newRank : newRank // ignore: cast_nullable_to_non_nullable
as Rank,
  ));
}


}

// dart format on
