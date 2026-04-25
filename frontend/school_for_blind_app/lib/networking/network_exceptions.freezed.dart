// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'network_exceptions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NetworkExceptions {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NetworkExceptions);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions()';
}


}

/// @nodoc
class $NetworkExceptionsCopyWith<$Res>  {
$NetworkExceptionsCopyWith(NetworkExceptions _, $Res Function(NetworkExceptions) __);
}


/// Adds pattern-matching-related methods to [NetworkExceptions].
extension NetworkExceptionsPatterns on NetworkExceptions {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( RequestCancelled value)?  requestCancelled,TResult Function( UnauthorizedRequest value)?  unauthorizedRequest,TResult Function( BadRequest value)?  badRequest,TResult Function( NotFound value)?  notFound,TResult Function( MethodNotAllowed value)?  methodNotAllowed,TResult Function( NotAcceptable value)?  notAcceptable,TResult Function( RequestTimeout value)?  requestTimeout,TResult Function( SendTimeout value)?  sendTimeout,TResult Function( UnprocessableEntity value)?  unprocessableEntity,TResult Function( Conflict value)?  conflict,TResult Function( InternalServerError value)?  internalServerError,TResult Function( NotImplemented value)?  notImplemented,TResult Function( ServiceUnavailable value)?  serviceUnavailable,TResult Function( NoInternetConnection value)?  noInternetConnection,TResult Function( FormatException value)?  formatException,TResult Function( UnableToProcess value)?  unableToProcess,TResult Function( DefaultError value)?  defaultError,TResult Function( UnexpectedError value)?  unexpectedError,required TResult orElse(),}){
final _that = this;
switch (_that) {
case RequestCancelled() when requestCancelled != null:
return requestCancelled(_that);case UnauthorizedRequest() when unauthorizedRequest != null:
return unauthorizedRequest(_that);case BadRequest() when badRequest != null:
return badRequest(_that);case NotFound() when notFound != null:
return notFound(_that);case MethodNotAllowed() when methodNotAllowed != null:
return methodNotAllowed(_that);case NotAcceptable() when notAcceptable != null:
return notAcceptable(_that);case RequestTimeout() when requestTimeout != null:
return requestTimeout(_that);case SendTimeout() when sendTimeout != null:
return sendTimeout(_that);case UnprocessableEntity() when unprocessableEntity != null:
return unprocessableEntity(_that);case Conflict() when conflict != null:
return conflict(_that);case InternalServerError() when internalServerError != null:
return internalServerError(_that);case NotImplemented() when notImplemented != null:
return notImplemented(_that);case ServiceUnavailable() when serviceUnavailable != null:
return serviceUnavailable(_that);case NoInternetConnection() when noInternetConnection != null:
return noInternetConnection(_that);case FormatException() when formatException != null:
return formatException(_that);case UnableToProcess() when unableToProcess != null:
return unableToProcess(_that);case DefaultError() when defaultError != null:
return defaultError(_that);case UnexpectedError() when unexpectedError != null:
return unexpectedError(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( RequestCancelled value)  requestCancelled,required TResult Function( UnauthorizedRequest value)  unauthorizedRequest,required TResult Function( BadRequest value)  badRequest,required TResult Function( NotFound value)  notFound,required TResult Function( MethodNotAllowed value)  methodNotAllowed,required TResult Function( NotAcceptable value)  notAcceptable,required TResult Function( RequestTimeout value)  requestTimeout,required TResult Function( SendTimeout value)  sendTimeout,required TResult Function( UnprocessableEntity value)  unprocessableEntity,required TResult Function( Conflict value)  conflict,required TResult Function( InternalServerError value)  internalServerError,required TResult Function( NotImplemented value)  notImplemented,required TResult Function( ServiceUnavailable value)  serviceUnavailable,required TResult Function( NoInternetConnection value)  noInternetConnection,required TResult Function( FormatException value)  formatException,required TResult Function( UnableToProcess value)  unableToProcess,required TResult Function( DefaultError value)  defaultError,required TResult Function( UnexpectedError value)  unexpectedError,}){
final _that = this;
switch (_that) {
case RequestCancelled():
return requestCancelled(_that);case UnauthorizedRequest():
return unauthorizedRequest(_that);case BadRequest():
return badRequest(_that);case NotFound():
return notFound(_that);case MethodNotAllowed():
return methodNotAllowed(_that);case NotAcceptable():
return notAcceptable(_that);case RequestTimeout():
return requestTimeout(_that);case SendTimeout():
return sendTimeout(_that);case UnprocessableEntity():
return unprocessableEntity(_that);case Conflict():
return conflict(_that);case InternalServerError():
return internalServerError(_that);case NotImplemented():
return notImplemented(_that);case ServiceUnavailable():
return serviceUnavailable(_that);case NoInternetConnection():
return noInternetConnection(_that);case FormatException():
return formatException(_that);case UnableToProcess():
return unableToProcess(_that);case DefaultError():
return defaultError(_that);case UnexpectedError():
return unexpectedError(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( RequestCancelled value)?  requestCancelled,TResult? Function( UnauthorizedRequest value)?  unauthorizedRequest,TResult? Function( BadRequest value)?  badRequest,TResult? Function( NotFound value)?  notFound,TResult? Function( MethodNotAllowed value)?  methodNotAllowed,TResult? Function( NotAcceptable value)?  notAcceptable,TResult? Function( RequestTimeout value)?  requestTimeout,TResult? Function( SendTimeout value)?  sendTimeout,TResult? Function( UnprocessableEntity value)?  unprocessableEntity,TResult? Function( Conflict value)?  conflict,TResult? Function( InternalServerError value)?  internalServerError,TResult? Function( NotImplemented value)?  notImplemented,TResult? Function( ServiceUnavailable value)?  serviceUnavailable,TResult? Function( NoInternetConnection value)?  noInternetConnection,TResult? Function( FormatException value)?  formatException,TResult? Function( UnableToProcess value)?  unableToProcess,TResult? Function( DefaultError value)?  defaultError,TResult? Function( UnexpectedError value)?  unexpectedError,}){
final _that = this;
switch (_that) {
case RequestCancelled() when requestCancelled != null:
return requestCancelled(_that);case UnauthorizedRequest() when unauthorizedRequest != null:
return unauthorizedRequest(_that);case BadRequest() when badRequest != null:
return badRequest(_that);case NotFound() when notFound != null:
return notFound(_that);case MethodNotAllowed() when methodNotAllowed != null:
return methodNotAllowed(_that);case NotAcceptable() when notAcceptable != null:
return notAcceptable(_that);case RequestTimeout() when requestTimeout != null:
return requestTimeout(_that);case SendTimeout() when sendTimeout != null:
return sendTimeout(_that);case UnprocessableEntity() when unprocessableEntity != null:
return unprocessableEntity(_that);case Conflict() when conflict != null:
return conflict(_that);case InternalServerError() when internalServerError != null:
return internalServerError(_that);case NotImplemented() when notImplemented != null:
return notImplemented(_that);case ServiceUnavailable() when serviceUnavailable != null:
return serviceUnavailable(_that);case NoInternetConnection() when noInternetConnection != null:
return noInternetConnection(_that);case FormatException() when formatException != null:
return formatException(_that);case UnableToProcess() when unableToProcess != null:
return unableToProcess(_that);case DefaultError() when defaultError != null:
return defaultError(_that);case UnexpectedError() when unexpectedError != null:
return unexpectedError(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  requestCancelled,TResult Function( String reason)?  unauthorizedRequest,TResult Function()?  badRequest,TResult Function( String reason)?  notFound,TResult Function()?  methodNotAllowed,TResult Function()?  notAcceptable,TResult Function()?  requestTimeout,TResult Function()?  sendTimeout,TResult Function( String reason)?  unprocessableEntity,TResult Function()?  conflict,TResult Function()?  internalServerError,TResult Function()?  notImplemented,TResult Function()?  serviceUnavailable,TResult Function()?  noInternetConnection,TResult Function()?  formatException,TResult Function()?  unableToProcess,TResult Function( String error)?  defaultError,TResult Function()?  unexpectedError,required TResult orElse(),}) {final _that = this;
switch (_that) {
case RequestCancelled() when requestCancelled != null:
return requestCancelled();case UnauthorizedRequest() when unauthorizedRequest != null:
return unauthorizedRequest(_that.reason);case BadRequest() when badRequest != null:
return badRequest();case NotFound() when notFound != null:
return notFound(_that.reason);case MethodNotAllowed() when methodNotAllowed != null:
return methodNotAllowed();case NotAcceptable() when notAcceptable != null:
return notAcceptable();case RequestTimeout() when requestTimeout != null:
return requestTimeout();case SendTimeout() when sendTimeout != null:
return sendTimeout();case UnprocessableEntity() when unprocessableEntity != null:
return unprocessableEntity(_that.reason);case Conflict() when conflict != null:
return conflict();case InternalServerError() when internalServerError != null:
return internalServerError();case NotImplemented() when notImplemented != null:
return notImplemented();case ServiceUnavailable() when serviceUnavailable != null:
return serviceUnavailable();case NoInternetConnection() when noInternetConnection != null:
return noInternetConnection();case FormatException() when formatException != null:
return formatException();case UnableToProcess() when unableToProcess != null:
return unableToProcess();case DefaultError() when defaultError != null:
return defaultError(_that.error);case UnexpectedError() when unexpectedError != null:
return unexpectedError();case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  requestCancelled,required TResult Function( String reason)  unauthorizedRequest,required TResult Function()  badRequest,required TResult Function( String reason)  notFound,required TResult Function()  methodNotAllowed,required TResult Function()  notAcceptable,required TResult Function()  requestTimeout,required TResult Function()  sendTimeout,required TResult Function( String reason)  unprocessableEntity,required TResult Function()  conflict,required TResult Function()  internalServerError,required TResult Function()  notImplemented,required TResult Function()  serviceUnavailable,required TResult Function()  noInternetConnection,required TResult Function()  formatException,required TResult Function()  unableToProcess,required TResult Function( String error)  defaultError,required TResult Function()  unexpectedError,}) {final _that = this;
switch (_that) {
case RequestCancelled():
return requestCancelled();case UnauthorizedRequest():
return unauthorizedRequest(_that.reason);case BadRequest():
return badRequest();case NotFound():
return notFound(_that.reason);case MethodNotAllowed():
return methodNotAllowed();case NotAcceptable():
return notAcceptable();case RequestTimeout():
return requestTimeout();case SendTimeout():
return sendTimeout();case UnprocessableEntity():
return unprocessableEntity(_that.reason);case Conflict():
return conflict();case InternalServerError():
return internalServerError();case NotImplemented():
return notImplemented();case ServiceUnavailable():
return serviceUnavailable();case NoInternetConnection():
return noInternetConnection();case FormatException():
return formatException();case UnableToProcess():
return unableToProcess();case DefaultError():
return defaultError(_that.error);case UnexpectedError():
return unexpectedError();case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  requestCancelled,TResult? Function( String reason)?  unauthorizedRequest,TResult? Function()?  badRequest,TResult? Function( String reason)?  notFound,TResult? Function()?  methodNotAllowed,TResult? Function()?  notAcceptable,TResult? Function()?  requestTimeout,TResult? Function()?  sendTimeout,TResult? Function( String reason)?  unprocessableEntity,TResult? Function()?  conflict,TResult? Function()?  internalServerError,TResult? Function()?  notImplemented,TResult? Function()?  serviceUnavailable,TResult? Function()?  noInternetConnection,TResult? Function()?  formatException,TResult? Function()?  unableToProcess,TResult? Function( String error)?  defaultError,TResult? Function()?  unexpectedError,}) {final _that = this;
switch (_that) {
case RequestCancelled() when requestCancelled != null:
return requestCancelled();case UnauthorizedRequest() when unauthorizedRequest != null:
return unauthorizedRequest(_that.reason);case BadRequest() when badRequest != null:
return badRequest();case NotFound() when notFound != null:
return notFound(_that.reason);case MethodNotAllowed() when methodNotAllowed != null:
return methodNotAllowed();case NotAcceptable() when notAcceptable != null:
return notAcceptable();case RequestTimeout() when requestTimeout != null:
return requestTimeout();case SendTimeout() when sendTimeout != null:
return sendTimeout();case UnprocessableEntity() when unprocessableEntity != null:
return unprocessableEntity(_that.reason);case Conflict() when conflict != null:
return conflict();case InternalServerError() when internalServerError != null:
return internalServerError();case NotImplemented() when notImplemented != null:
return notImplemented();case ServiceUnavailable() when serviceUnavailable != null:
return serviceUnavailable();case NoInternetConnection() when noInternetConnection != null:
return noInternetConnection();case FormatException() when formatException != null:
return formatException();case UnableToProcess() when unableToProcess != null:
return unableToProcess();case DefaultError() when defaultError != null:
return defaultError(_that.error);case UnexpectedError() when unexpectedError != null:
return unexpectedError();case _:
  return null;

}
}

}

/// @nodoc


class RequestCancelled implements NetworkExceptions {
  const RequestCancelled();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestCancelled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.requestCancelled()';
}


}




/// @nodoc


class UnauthorizedRequest implements NetworkExceptions {
  const UnauthorizedRequest(this.reason);
  

 final  String reason;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnauthorizedRequestCopyWith<UnauthorizedRequest> get copyWith => _$UnauthorizedRequestCopyWithImpl<UnauthorizedRequest>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnauthorizedRequest&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'NetworkExceptions.unauthorizedRequest(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $UnauthorizedRequestCopyWith<$Res> implements $NetworkExceptionsCopyWith<$Res> {
  factory $UnauthorizedRequestCopyWith(UnauthorizedRequest value, $Res Function(UnauthorizedRequest) _then) = _$UnauthorizedRequestCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$UnauthorizedRequestCopyWithImpl<$Res>
    implements $UnauthorizedRequestCopyWith<$Res> {
  _$UnauthorizedRequestCopyWithImpl(this._self, this._then);

  final UnauthorizedRequest _self;
  final $Res Function(UnauthorizedRequest) _then;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(UnauthorizedRequest(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class BadRequest implements NetworkExceptions {
  const BadRequest();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BadRequest);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.badRequest()';
}


}




/// @nodoc


class NotFound implements NetworkExceptions {
  const NotFound(this.reason);
  

 final  String reason;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NotFoundCopyWith<NotFound> get copyWith => _$NotFoundCopyWithImpl<NotFound>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFound&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'NetworkExceptions.notFound(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $NotFoundCopyWith<$Res> implements $NetworkExceptionsCopyWith<$Res> {
  factory $NotFoundCopyWith(NotFound value, $Res Function(NotFound) _then) = _$NotFoundCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$NotFoundCopyWithImpl<$Res>
    implements $NotFoundCopyWith<$Res> {
  _$NotFoundCopyWithImpl(this._self, this._then);

  final NotFound _self;
  final $Res Function(NotFound) _then;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(NotFound(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MethodNotAllowed implements NetworkExceptions {
  const MethodNotAllowed();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MethodNotAllowed);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.methodNotAllowed()';
}


}




/// @nodoc


class NotAcceptable implements NetworkExceptions {
  const NotAcceptable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotAcceptable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.notAcceptable()';
}


}




/// @nodoc


class RequestTimeout implements NetworkExceptions {
  const RequestTimeout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequestTimeout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.requestTimeout()';
}


}




/// @nodoc


class SendTimeout implements NetworkExceptions {
  const SendTimeout();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SendTimeout);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.sendTimeout()';
}


}




/// @nodoc


class UnprocessableEntity implements NetworkExceptions {
  const UnprocessableEntity(this.reason);
  

 final  String reason;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnprocessableEntityCopyWith<UnprocessableEntity> get copyWith => _$UnprocessableEntityCopyWithImpl<UnprocessableEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnprocessableEntity&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'NetworkExceptions.unprocessableEntity(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $UnprocessableEntityCopyWith<$Res> implements $NetworkExceptionsCopyWith<$Res> {
  factory $UnprocessableEntityCopyWith(UnprocessableEntity value, $Res Function(UnprocessableEntity) _then) = _$UnprocessableEntityCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$UnprocessableEntityCopyWithImpl<$Res>
    implements $UnprocessableEntityCopyWith<$Res> {
  _$UnprocessableEntityCopyWithImpl(this._self, this._then);

  final UnprocessableEntity _self;
  final $Res Function(UnprocessableEntity) _then;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(UnprocessableEntity(
null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class Conflict implements NetworkExceptions {
  const Conflict();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Conflict);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.conflict()';
}


}




/// @nodoc


class InternalServerError implements NetworkExceptions {
  const InternalServerError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InternalServerError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.internalServerError()';
}


}




/// @nodoc


class NotImplemented implements NetworkExceptions {
  const NotImplemented();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotImplemented);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.notImplemented()';
}


}




/// @nodoc


class ServiceUnavailable implements NetworkExceptions {
  const ServiceUnavailable();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ServiceUnavailable);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.serviceUnavailable()';
}


}




/// @nodoc


class NoInternetConnection implements NetworkExceptions {
  const NoInternetConnection();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NoInternetConnection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.noInternetConnection()';
}


}




/// @nodoc


class FormatException implements NetworkExceptions {
  const FormatException();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FormatException);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.formatException()';
}


}




/// @nodoc


class UnableToProcess implements NetworkExceptions {
  const UnableToProcess();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnableToProcess);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.unableToProcess()';
}


}




/// @nodoc


class DefaultError implements NetworkExceptions {
  const DefaultError(this.error);
  

 final  String error;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DefaultErrorCopyWith<DefaultError> get copyWith => _$DefaultErrorCopyWithImpl<DefaultError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DefaultError&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'NetworkExceptions.defaultError(error: $error)';
}


}

/// @nodoc
abstract mixin class $DefaultErrorCopyWith<$Res> implements $NetworkExceptionsCopyWith<$Res> {
  factory $DefaultErrorCopyWith(DefaultError value, $Res Function(DefaultError) _then) = _$DefaultErrorCopyWithImpl;
@useResult
$Res call({
 String error
});




}
/// @nodoc
class _$DefaultErrorCopyWithImpl<$Res>
    implements $DefaultErrorCopyWith<$Res> {
  _$DefaultErrorCopyWithImpl(this._self, this._then);

  final DefaultError _self;
  final $Res Function(DefaultError) _then;

/// Create a copy of NetworkExceptions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,}) {
  return _then(DefaultError(
null == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnexpectedError implements NetworkExceptions {
  const UnexpectedError();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedError);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'NetworkExceptions.unexpectedError()';
}


}




// dart format on
