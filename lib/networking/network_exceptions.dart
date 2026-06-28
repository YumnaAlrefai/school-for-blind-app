import 'dart:io';
import 'package:dio/dio.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_for_blind_app/data/models/error_model.dart';

part 'network_exceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;
  const factory NetworkExceptions.unauthorizedRequest(String reason) =
      UnauthorizedRequest;
  const factory NetworkExceptions.badRequest() = BadRequest;
  const factory NetworkExceptions.notFound(String reason) = NotFound;
  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;
  const factory NetworkExceptions.notAcceptable() = NotAcceptable;
  const factory NetworkExceptions.requestTimeout() = RequestTimeout;
  const factory NetworkExceptions.sendTimeout() = SendTimeout;
  const factory NetworkExceptions.unprocessableEntity(String reason) =
      UnprocessableEntity;
  const factory NetworkExceptions.conflict() = Conflict;
  const factory NetworkExceptions.internalServerError() = InternalServerError;
  const factory NetworkExceptions.notImplemented() = NotImplemented;
  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;
  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;
  const factory NetworkExceptions.formatException() = FormatException;
  const factory NetworkExceptions.unableToProcess() = UnableToProcess;
  const factory NetworkExceptions.defaultError(String error) = DefaultError;
  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions handleResponse(Response? response) {
    int statusCode = response?.statusCode ?? 0;
    String allErrors = "";

    if (response?.data != null) {
      try {
        if (response?.data is Map) {
          var errorModel = ErrorModel.fromJson(response?.data);
          allErrors = errorModel.error ?? "خطأ غير معروف";
        } else if (response?.data is List) {
          List<ErrorModel> listOfErrors = List.from(
            response?.data,
          ).map((e) => ErrorModel.fromJson(e)).toList();
          allErrors = listOfErrors.map((e) => e.error).join(", ");
        }
      } catch (e) {
        allErrors = "تعذر تحليل الأخطاء";
      }
    } else {
      allErrors = "حدث خطأ برمز الحالة: $statusCode";
    }

    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        return NetworkExceptions.unauthorizedRequest(allErrors);
      case 404:
        return NetworkExceptions.notFound(allErrors);
      case 409:
        return const NetworkExceptions.conflict();
      case 422:
        return NetworkExceptions.unprocessableEntity(allErrors);
      case 500:
        return const NetworkExceptions.internalServerError();
      default:
        return NetworkExceptions.defaultError(
          "تم استلام رمز حالة غير صالح: $statusCode",
        );
    }
  }

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions =
            const NetworkExceptions.unexpectedError();
        if (error is DioException) {
          switch (error.type) {
            case DioExceptionType.cancel:
              networkExceptions = const NetworkExceptions.requestCancelled();
              break;
            case DioExceptionType.connectionTimeout:
              networkExceptions = const NetworkExceptions.requestTimeout();
              break;
            case DioExceptionType.unknown:
              networkExceptions =
                  const NetworkExceptions.noInternetConnection();
              break;
            case DioExceptionType.receiveTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badResponse:
              networkExceptions = NetworkExceptions.handleResponse(
                error.response,
              );
              break;
            case DioExceptionType.sendTimeout:
              networkExceptions = const NetworkExceptions.sendTimeout();
              break;
            case DioExceptionType.badCertificate:
              networkExceptions = const NetworkExceptions.unexpectedError();
              break;
            case DioExceptionType.connectionError:
              networkExceptions =
                  const NetworkExceptions.noInternetConnection();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = const NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = const NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException {
        return const NetworkExceptions.formatException();
      } catch (_) {
        return const NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return const NetworkExceptions.unableToProcess();
      } else {
        return const NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "";
    networkExceptions.when(
      notImplemented: () => errorMessage = "هذه الميزة غير متوفرة حالياً",
      requestCancelled: () => errorMessage = "تم إلغاء الطلب",
      internalServerError: () =>
          errorMessage = "خطأ في الخادم الداخلي، يرجى المحاولة لاحقاً",
      notFound: (String reason) => errorMessage = reason,
      serviceUnavailable: () => errorMessage = "الخدمة غير متوفرة حالياً",
      methodNotAllowed: () => errorMessage = "طريقة الطلب غير مسموح بها",
      badRequest: () => errorMessage = "طلب غير صالح",
      unauthorizedRequest: (String error) => errorMessage = error,
      unprocessableEntity: (String error) => errorMessage = error,
      unexpectedError: () => errorMessage = "حدث خطأ غير متوقع",
      requestTimeout: () => errorMessage = "انتهت مهلة الاتصال بالخادم",
      noInternetConnection: () => errorMessage = "لا يوجد اتصال بالإنترنت",
      conflict: () => errorMessage = "حدث تعارض في البيانات",
      sendTimeout: () => errorMessage = "انتهت مهلة إرسال البيانات",
      unableToProcess: () => errorMessage = "تعذرت معالجة البيانات المستلمة",
      defaultError: (String error) => errorMessage = error,
      formatException: () => errorMessage = "خطأ في تنسيق البيانات المستلمة",
      notAcceptable: () => errorMessage = "الطلب غير مقبول",
    );
    return errorMessage;
  }
}
