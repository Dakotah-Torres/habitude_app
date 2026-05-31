// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brain_dump_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BrainDumpItem {

 String get id; String get text; DateTime get createdAt; DateTime? get backloggedUntil; DateTime? get scheduledForDate;
/// Create a copy of BrainDumpItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrainDumpItemCopyWith<BrainDumpItem> get copyWith => _$BrainDumpItemCopyWithImpl<BrainDumpItem>(this as BrainDumpItem, _$identity);

  /// Serializes this BrainDumpItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BrainDumpItem&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.backloggedUntil, backloggedUntil) || other.backloggedUntil == backloggedUntil)&&(identical(other.scheduledForDate, scheduledForDate) || other.scheduledForDate == scheduledForDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,createdAt,backloggedUntil,scheduledForDate);

@override
String toString() {
  return 'BrainDumpItem(id: $id, text: $text, createdAt: $createdAt, backloggedUntil: $backloggedUntil, scheduledForDate: $scheduledForDate)';
}


}

/// @nodoc
abstract mixin class $BrainDumpItemCopyWith<$Res>  {
  factory $BrainDumpItemCopyWith(BrainDumpItem value, $Res Function(BrainDumpItem) _then) = _$BrainDumpItemCopyWithImpl;
@useResult
$Res call({
 String id, String text, DateTime createdAt, DateTime? backloggedUntil, DateTime? scheduledForDate
});




}
/// @nodoc
class _$BrainDumpItemCopyWithImpl<$Res>
    implements $BrainDumpItemCopyWith<$Res> {
  _$BrainDumpItemCopyWithImpl(this._self, this._then);

  final BrainDumpItem _self;
  final $Res Function(BrainDumpItem) _then;

/// Create a copy of BrainDumpItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,Object? createdAt = null,Object? backloggedUntil = freezed,Object? scheduledForDate = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,backloggedUntil: freezed == backloggedUntil ? _self.backloggedUntil : backloggedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledForDate: freezed == scheduledForDate ? _self.scheduledForDate : scheduledForDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BrainDumpItem].
extension BrainDumpItemPatterns on BrainDumpItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BrainDumpItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BrainDumpItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BrainDumpItem value)  $default,){
final _that = this;
switch (_that) {
case _BrainDumpItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BrainDumpItem value)?  $default,){
final _that = this;
switch (_that) {
case _BrainDumpItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text,  DateTime createdAt,  DateTime? backloggedUntil,  DateTime? scheduledForDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BrainDumpItem() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.backloggedUntil,_that.scheduledForDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text,  DateTime createdAt,  DateTime? backloggedUntil,  DateTime? scheduledForDate)  $default,) {final _that = this;
switch (_that) {
case _BrainDumpItem():
return $default(_that.id,_that.text,_that.createdAt,_that.backloggedUntil,_that.scheduledForDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text,  DateTime createdAt,  DateTime? backloggedUntil,  DateTime? scheduledForDate)?  $default,) {final _that = this;
switch (_that) {
case _BrainDumpItem() when $default != null:
return $default(_that.id,_that.text,_that.createdAt,_that.backloggedUntil,_that.scheduledForDate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BrainDumpItem implements BrainDumpItem {
  const _BrainDumpItem({required this.id, required this.text, required this.createdAt, this.backloggedUntil, this.scheduledForDate});
  factory _BrainDumpItem.fromJson(Map<String, dynamic> json) => _$BrainDumpItemFromJson(json);

@override final  String id;
@override final  String text;
@override final  DateTime createdAt;
@override final  DateTime? backloggedUntil;
@override final  DateTime? scheduledForDate;

/// Create a copy of BrainDumpItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrainDumpItemCopyWith<_BrainDumpItem> get copyWith => __$BrainDumpItemCopyWithImpl<_BrainDumpItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrainDumpItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BrainDumpItem&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.backloggedUntil, backloggedUntil) || other.backloggedUntil == backloggedUntil)&&(identical(other.scheduledForDate, scheduledForDate) || other.scheduledForDate == scheduledForDate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,createdAt,backloggedUntil,scheduledForDate);

@override
String toString() {
  return 'BrainDumpItem(id: $id, text: $text, createdAt: $createdAt, backloggedUntil: $backloggedUntil, scheduledForDate: $scheduledForDate)';
}


}

/// @nodoc
abstract mixin class _$BrainDumpItemCopyWith<$Res> implements $BrainDumpItemCopyWith<$Res> {
  factory _$BrainDumpItemCopyWith(_BrainDumpItem value, $Res Function(_BrainDumpItem) _then) = __$BrainDumpItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String text, DateTime createdAt, DateTime? backloggedUntil, DateTime? scheduledForDate
});




}
/// @nodoc
class __$BrainDumpItemCopyWithImpl<$Res>
    implements _$BrainDumpItemCopyWith<$Res> {
  __$BrainDumpItemCopyWithImpl(this._self, this._then);

  final _BrainDumpItem _self;
  final $Res Function(_BrainDumpItem) _then;

/// Create a copy of BrainDumpItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,Object? createdAt = null,Object? backloggedUntil = freezed,Object? scheduledForDate = freezed,}) {
  return _then(_BrainDumpItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,backloggedUntil: freezed == backloggedUntil ? _self.backloggedUntil : backloggedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,scheduledForDate: freezed == scheduledForDate ? _self.scheduledForDate : scheduledForDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
