// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'past_exams_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PastExamsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PastExamsState()';
}


}

/// @nodoc
class $PastExamsStateCopyWith<$Res>  {
$PastExamsStateCopyWith(PastExamsState _, $Res Function(PastExamsState) __);
}


/// Adds pattern-matching-related methods to [PastExamsState].
extension PastExamsStatePatterns on PastExamsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PastExamsInitial value)?  initial,TResult Function( PastExamsLoading value)?  loading,TResult Function( PastExamsSuccess value)?  success,TResult Function( PastExamsFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PastExamsInitial() when initial != null:
return initial(_that);case PastExamsLoading() when loading != null:
return loading(_that);case PastExamsSuccess() when success != null:
return success(_that);case PastExamsFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PastExamsInitial value)  initial,required TResult Function( PastExamsLoading value)  loading,required TResult Function( PastExamsSuccess value)  success,required TResult Function( PastExamsFailure value)  failure,}){
final _that = this;
switch (_that) {
case PastExamsInitial():
return initial(_that);case PastExamsLoading():
return loading(_that);case PastExamsSuccess():
return success(_that);case PastExamsFailure():
return failure(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PastExamsInitial value)?  initial,TResult? Function( PastExamsLoading value)?  loading,TResult? Function( PastExamsSuccess value)?  success,TResult? Function( PastExamsFailure value)?  failure,}){
final _that = this;
switch (_that) {
case PastExamsInitial() when initial != null:
return initial(_that);case PastExamsLoading() when loading != null:
return loading(_that);case PastExamsSuccess() when success != null:
return success(_that);case PastExamsFailure() when failure != null:
return failure(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<PastExam> exams)?  success,TResult Function( NetworkExceptions networkExceptions)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PastExamsInitial() when initial != null:
return initial();case PastExamsLoading() when loading != null:
return loading();case PastExamsSuccess() when success != null:
return success(_that.exams);case PastExamsFailure() when failure != null:
return failure(_that.networkExceptions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<PastExam> exams)  success,required TResult Function( NetworkExceptions networkExceptions)  failure,}) {final _that = this;
switch (_that) {
case PastExamsInitial():
return initial();case PastExamsLoading():
return loading();case PastExamsSuccess():
return success(_that.exams);case PastExamsFailure():
return failure(_that.networkExceptions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<PastExam> exams)?  success,TResult? Function( NetworkExceptions networkExceptions)?  failure,}) {final _that = this;
switch (_that) {
case PastExamsInitial() when initial != null:
return initial();case PastExamsLoading() when loading != null:
return loading();case PastExamsSuccess() when success != null:
return success(_that.exams);case PastExamsFailure() when failure != null:
return failure(_that.networkExceptions);case _:
  return null;

}
}

}

/// @nodoc


class PastExamsInitial implements PastExamsState {
  const PastExamsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PastExamsState.initial()';
}


}




/// @nodoc


class PastExamsLoading implements PastExamsState {
  const PastExamsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PastExamsState.loading()';
}


}




/// @nodoc


class PastExamsSuccess implements PastExamsState {
  const PastExamsSuccess(final  List<PastExam> exams): _exams = exams;
  

 final  List<PastExam> _exams;
 List<PastExam> get exams {
  if (_exams is EqualUnmodifiableListView) return _exams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exams);
}


/// Create a copy of PastExamsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PastExamsSuccessCopyWith<PastExamsSuccess> get copyWith => _$PastExamsSuccessCopyWithImpl<PastExamsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamsSuccess&&const DeepCollectionEquality().equals(other._exams, _exams));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_exams));

@override
String toString() {
  return 'PastExamsState.success(exams: $exams)';
}


}

/// @nodoc
abstract mixin class $PastExamsSuccessCopyWith<$Res> implements $PastExamsStateCopyWith<$Res> {
  factory $PastExamsSuccessCopyWith(PastExamsSuccess value, $Res Function(PastExamsSuccess) _then) = _$PastExamsSuccessCopyWithImpl;
@useResult
$Res call({
 List<PastExam> exams
});




}
/// @nodoc
class _$PastExamsSuccessCopyWithImpl<$Res>
    implements $PastExamsSuccessCopyWith<$Res> {
  _$PastExamsSuccessCopyWithImpl(this._self, this._then);

  final PastExamsSuccess _self;
  final $Res Function(PastExamsSuccess) _then;

/// Create a copy of PastExamsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? exams = null,}) {
  return _then(PastExamsSuccess(
null == exams ? _self._exams : exams // ignore: cast_nullable_to_non_nullable
as List<PastExam>,
  ));
}


}

/// @nodoc


class PastExamsFailure implements PastExamsState {
  const PastExamsFailure(this.networkExceptions);
  

 final  NetworkExceptions networkExceptions;

/// Create a copy of PastExamsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PastExamsFailureCopyWith<PastExamsFailure> get copyWith => _$PastExamsFailureCopyWithImpl<PastExamsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamsFailure&&(identical(other.networkExceptions, networkExceptions) || other.networkExceptions == networkExceptions));
}


@override
int get hashCode => Object.hash(runtimeType,networkExceptions);

@override
String toString() {
  return 'PastExamsState.failure(networkExceptions: $networkExceptions)';
}


}

/// @nodoc
abstract mixin class $PastExamsFailureCopyWith<$Res> implements $PastExamsStateCopyWith<$Res> {
  factory $PastExamsFailureCopyWith(PastExamsFailure value, $Res Function(PastExamsFailure) _then) = _$PastExamsFailureCopyWithImpl;
@useResult
$Res call({
 NetworkExceptions networkExceptions
});


$NetworkExceptionsCopyWith<$Res> get networkExceptions;

}
/// @nodoc
class _$PastExamsFailureCopyWithImpl<$Res>
    implements $PastExamsFailureCopyWith<$Res> {
  _$PastExamsFailureCopyWithImpl(this._self, this._then);

  final PastExamsFailure _self;
  final $Res Function(PastExamsFailure) _then;

/// Create a copy of PastExamsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? networkExceptions = null,}) {
  return _then(PastExamsFailure(
null == networkExceptions ? _self.networkExceptions : networkExceptions // ignore: cast_nullable_to_non_nullable
as NetworkExceptions,
  ));
}

/// Create a copy of PastExamsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NetworkExceptionsCopyWith<$Res> get networkExceptions {
  
  return $NetworkExceptionsCopyWith<$Res>(_self.networkExceptions, (value) {
    return _then(_self.copyWith(networkExceptions: value));
  });
}
}

// dart format on
