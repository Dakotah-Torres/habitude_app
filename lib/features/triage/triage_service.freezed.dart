// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'triage_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TriageItem {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TriageItem);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TriageItem()';
}


}

/// @nodoc
class $TriageItemCopyWith<$Res>  {
$TriageItemCopyWith(TriageItem _, $Res Function(TriageItem) __);
}


/// Adds pattern-matching-related methods to [TriageItem].
extension TriageItemPatterns on TriageItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _TriageBrainDump value)?  brainDump,TResult Function( _TriageTask value)?  task,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TriageBrainDump() when brainDump != null:
return brainDump(_that);case _TriageTask() when task != null:
return task(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _TriageBrainDump value)  brainDump,required TResult Function( _TriageTask value)  task,}){
final _that = this;
switch (_that) {
case _TriageBrainDump():
return brainDump(_that);case _TriageTask():
return task(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _TriageBrainDump value)?  brainDump,TResult? Function( _TriageTask value)?  task,}){
final _that = this;
switch (_that) {
case _TriageBrainDump() when brainDump != null:
return brainDump(_that);case _TriageTask() when task != null:
return task(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( BrainDumpItem item)?  brainDump,TResult Function( Task task,  int completionsThisWeek)?  task,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TriageBrainDump() when brainDump != null:
return brainDump(_that.item);case _TriageTask() when task != null:
return task(_that.task,_that.completionsThisWeek);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( BrainDumpItem item)  brainDump,required TResult Function( Task task,  int completionsThisWeek)  task,}) {final _that = this;
switch (_that) {
case _TriageBrainDump():
return brainDump(_that.item);case _TriageTask():
return task(_that.task,_that.completionsThisWeek);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( BrainDumpItem item)?  brainDump,TResult? Function( Task task,  int completionsThisWeek)?  task,}) {final _that = this;
switch (_that) {
case _TriageBrainDump() when brainDump != null:
return brainDump(_that.item);case _TriageTask() when task != null:
return task(_that.task,_that.completionsThisWeek);case _:
  return null;

}
}

}

/// @nodoc


class _TriageBrainDump implements TriageItem {
  const _TriageBrainDump(this.item);
  

 final  BrainDumpItem item;

/// Create a copy of TriageItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriageBrainDumpCopyWith<_TriageBrainDump> get copyWith => __$TriageBrainDumpCopyWithImpl<_TriageBrainDump>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriageBrainDump&&(identical(other.item, item) || other.item == item));
}


@override
int get hashCode => Object.hash(runtimeType,item);

@override
String toString() {
  return 'TriageItem.brainDump(item: $item)';
}


}

/// @nodoc
abstract mixin class _$TriageBrainDumpCopyWith<$Res> implements $TriageItemCopyWith<$Res> {
  factory _$TriageBrainDumpCopyWith(_TriageBrainDump value, $Res Function(_TriageBrainDump) _then) = __$TriageBrainDumpCopyWithImpl;
@useResult
$Res call({
 BrainDumpItem item
});


$BrainDumpItemCopyWith<$Res> get item;

}
/// @nodoc
class __$TriageBrainDumpCopyWithImpl<$Res>
    implements _$TriageBrainDumpCopyWith<$Res> {
  __$TriageBrainDumpCopyWithImpl(this._self, this._then);

  final _TriageBrainDump _self;
  final $Res Function(_TriageBrainDump) _then;

/// Create a copy of TriageItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? item = null,}) {
  return _then(_TriageBrainDump(
null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as BrainDumpItem,
  ));
}

/// Create a copy of TriageItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BrainDumpItemCopyWith<$Res> get item {
  
  return $BrainDumpItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

/// @nodoc


class _TriageTask implements TriageItem {
  const _TriageTask(this.task, this.completionsThisWeek);
  

 final  Task task;
 final  int completionsThisWeek;

/// Create a copy of TriageItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TriageTaskCopyWith<_TriageTask> get copyWith => __$TriageTaskCopyWithImpl<_TriageTask>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TriageTask&&(identical(other.task, task) || other.task == task)&&(identical(other.completionsThisWeek, completionsThisWeek) || other.completionsThisWeek == completionsThisWeek));
}


@override
int get hashCode => Object.hash(runtimeType,task,completionsThisWeek);

@override
String toString() {
  return 'TriageItem.task(task: $task, completionsThisWeek: $completionsThisWeek)';
}


}

/// @nodoc
abstract mixin class _$TriageTaskCopyWith<$Res> implements $TriageItemCopyWith<$Res> {
  factory _$TriageTaskCopyWith(_TriageTask value, $Res Function(_TriageTask) _then) = __$TriageTaskCopyWithImpl;
@useResult
$Res call({
 Task task, int completionsThisWeek
});


$TaskCopyWith<$Res> get task;

}
/// @nodoc
class __$TriageTaskCopyWithImpl<$Res>
    implements _$TriageTaskCopyWith<$Res> {
  __$TriageTaskCopyWithImpl(this._self, this._then);

  final _TriageTask _self;
  final $Res Function(_TriageTask) _then;

/// Create a copy of TriageItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? task = null,Object? completionsThisWeek = null,}) {
  return _then(_TriageTask(
null == task ? _self.task : task // ignore: cast_nullable_to_non_nullable
as Task,null == completionsThisWeek ? _self.completionsThisWeek : completionsThisWeek // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of TriageItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TaskCopyWith<$Res> get task {
  
  return $TaskCopyWith<$Res>(_self.task, (value) {
    return _then(_self.copyWith(task: value));
  });
}
}

// dart format on
