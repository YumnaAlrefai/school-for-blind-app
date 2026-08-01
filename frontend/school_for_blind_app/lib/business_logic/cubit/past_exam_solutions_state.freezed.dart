// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'past_exam_solutions_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PastExamSolutionsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamSolutionsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PastExamSolutionsState()';
}


}

/// @nodoc
class $PastExamSolutionsStateCopyWith<$Res>  {
$PastExamSolutionsStateCopyWith(PastExamSolutionsState _, $Res Function(PastExamSolutionsState) __);
}


/// Adds pattern-matching-related methods to [PastExamSolutionsState].
extension PastExamSolutionsStatePatterns on PastExamSolutionsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( PastExamSolutionsInitial value)?  initial,TResult Function( PastExamSolutionsLoading value)?  loading,TResult Function( PastExamSolutionsSuccess value)?  success,TResult Function( PastExamSolutionsFailure value)?  failure,required TResult orElse(),}){
final _that = this;
switch (_that) {
case PastExamSolutionsInitial() when initial != null:
return initial(_that);case PastExamSolutionsLoading() when loading != null:
return loading(_that);case PastExamSolutionsSuccess() when success != null:
return success(_that);case PastExamSolutionsFailure() when failure != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( PastExamSolutionsInitial value)  initial,required TResult Function( PastExamSolutionsLoading value)  loading,required TResult Function( PastExamSolutionsSuccess value)  success,required TResult Function( PastExamSolutionsFailure value)  failure,}){
final _that = this;
switch (_that) {
case PastExamSolutionsInitial():
return initial(_that);case PastExamSolutionsLoading():
return loading(_that);case PastExamSolutionsSuccess():
return success(_that);case PastExamSolutionsFailure():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( PastExamSolutionsInitial value)?  initial,TResult? Function( PastExamSolutionsLoading value)?  loading,TResult? Function( PastExamSolutionsSuccess value)?  success,TResult? Function( PastExamSolutionsFailure value)?  failure,}){
final _that = this;
switch (_that) {
case PastExamSolutionsInitial() when initial != null:
return initial(_that);case PastExamSolutionsLoading() when loading != null:
return loading(_that);case PastExamSolutionsSuccess() when success != null:
return success(_that);case PastExamSolutionsFailure() when failure != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<PastExamQuestion> questions)?  success,TResult Function( NetworkExceptions networkExceptions)?  failure,required TResult orElse(),}) {final _that = this;
switch (_that) {
case PastExamSolutionsInitial() when initial != null:
return initial();case PastExamSolutionsLoading() when loading != null:
return loading();case PastExamSolutionsSuccess() when success != null:
return success(_that.questions);case PastExamSolutionsFailure() when failure != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<PastExamQuestion> questions)  success,required TResult Function( NetworkExceptions networkExceptions)  failure,}) {final _that = this;
switch (_that) {
case PastExamSolutionsInitial():
return initial();case PastExamSolutionsLoading():
return loading();case PastExamSolutionsSuccess():
return success(_that.questions);case PastExamSolutionsFailure():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<PastExamQuestion> questions)?  success,TResult? Function( NetworkExceptions networkExceptions)?  failure,}) {final _that = this;
switch (_that) {
case PastExamSolutionsInitial() when initial != null:
return initial();case PastExamSolutionsLoading() when loading != null:
return loading();case PastExamSolutionsSuccess() when success != null:
return success(_that.questions);case PastExamSolutionsFailure() when failure != null:
return failure(_that.networkExceptions);case _:
  return null;

}
}

}

/// @nodoc


class PastExamSolutionsInitial implements PastExamSolutionsState {
  const PastExamSolutionsInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamSolutionsInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PastExamSolutionsState.initial()';
}


}




/// @nodoc


class PastExamSolutionsLoading implements PastExamSolutionsState {
  const PastExamSolutionsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamSolutionsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'PastExamSolutionsState.loading()';
}


}




/// @nodoc


class PastExamSolutionsSuccess implements PastExamSolutionsState {
  const PastExamSolutionsSuccess(final  List<PastExamQuestion> questions): _questions = questions;
  

 final  List<PastExamQuestion> _questions;
 List<PastExamQuestion> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of PastExamSolutionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PastExamSolutionsSuccessCopyWith<PastExamSolutionsSuccess> get copyWith => _$PastExamSolutionsSuccessCopyWithImpl<PastExamSolutionsSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamSolutionsSuccess&&const DeepCollectionEquality().equals(other._questions, _questions));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'PastExamSolutionsState.success(questions: $questions)';
}


}

/// @nodoc
abstract mixin class $PastExamSolutionsSuccessCopyWith<$Res> implements $PastExamSolutionsStateCopyWith<$Res> {
  factory $PastExamSolutionsSuccessCopyWith(PastExamSolutionsSuccess value, $Res Function(PastExamSolutionsSuccess) _then) = _$PastExamSolutionsSuccessCopyWithImpl;
@useResult
$Res call({
 List<PastExamQuestion> questions
});




}
/// @nodoc
class _$PastExamSolutionsSuccessCopyWithImpl<$Res>
    implements $PastExamSolutionsSuccessCopyWith<$Res> {
  _$PastExamSolutionsSuccessCopyWithImpl(this._self, this._then);

  final PastExamSolutionsSuccess _self;
  final $Res Function(PastExamSolutionsSuccess) _then;

/// Create a copy of PastExamSolutionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? questions = null,}) {
  return _then(PastExamSolutionsSuccess(
null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<PastExamQuestion>,
  ));
}


}

/// @nodoc


class PastExamSolutionsFailure implements PastExamSolutionsState {
  const PastExamSolutionsFailure(this.networkExceptions);
  

 final  NetworkExceptions networkExceptions;

/// Create a copy of PastExamSolutionsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PastExamSolutionsFailureCopyWith<PastExamSolutionsFailure> get copyWith => _$PastExamSolutionsFailureCopyWithImpl<PastExamSolutionsFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PastExamSolutionsFailure&&(identical(other.networkExceptions, networkExceptions) || other.networkExceptions == networkExceptions));
}


@override
int get hashCode => Object.hash(runtimeType,networkExceptions);

@override
String toString() {
  return 'PastExamSolutionsState.failure(networkExceptions: $networkExceptions)';
}


}

/// @nodoc
abstract mixin class $PastExamSolutionsFailureCopyWith<$Res> implements $PastExamSolutionsStateCopyWith<$Res> {
  factory $PastExamSolutionsFailureCopyWith(PastExamSolutionsFailure value, $Res Function(PastExamSolutionsFailure) _then) = _$PastExamSolutionsFailureCopyWithImpl;
@useResult
$Res call({
 NetworkExceptions networkExceptions
});


$NetworkExceptionsCopyWith<$Res> get networkExceptions;

}
/// @nodoc
class _$PastExamSolutionsFailureCopyWithImpl<$Res>
    implements $PastExamSolutionsFailureCopyWith<$Res> {
  _$PastExamSolutionsFailureCopyWithImpl(this._self, this._then);

  final PastExamSolutionsFailure _self;
  final $Res Function(PastExamSolutionsFailure) _then;

/// Create a copy of PastExamSolutionsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? networkExceptions = null,}) {
  return _then(PastExamSolutionsFailure(
null == networkExceptions ? _self.networkExceptions : networkExceptions // ignore: cast_nullable_to_non_nullable
as NetworkExceptions,
  ));
}

/// Create a copy of PastExamSolutionsState
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
