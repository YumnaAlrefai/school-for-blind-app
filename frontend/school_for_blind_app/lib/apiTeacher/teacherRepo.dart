import 'package:dio/dio.dart';
import 'package:school_for_blind_app/apiTeacher/teacherModel.dart';
import 'package:school_for_blind_app/apiTeacher/web_services.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class TeacherRepo {
  final WebServices webServices;

  TeacherRepo(this.webServices);

  Future<ApiResult<dynamic>> sendOTP(String phone) async {
    try {
      var response = await webServices.sendOTP(phone);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> verifyOTP(String phone, String otp) async {
    try {
      var response = await webServices.verifyOTP(phone, otp);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> registerTeacher({
    required String phone,
    required String fullName,
    required String password,
    required String passwordConfirmation,
    required String subjects,
    required String level,
    required String fcmToken,
    required MultipartFile cvFile,
  }) async {
    try {
      var response = await webServices.registerTeacher(
        phone: phone,
        fullName: fullName,
        password: password,
        passwordConfirmation: passwordConfirmation,
        subjects: subjects,
        level: level,
        fcmToken: fcmToken,
        cvFile: cvFile,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> loginTeacher({
    required String phone,
    required String password,
  }) async {
    try {
      var response = await webServices.loginTeacher(phone, password);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> getLessons() async {
    try {
      var response = await webServices.getLessons();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> uploadLesson({
    required String title,
    required MultipartFile audioFile,
  }) async {
    try {
      var response = await webServices.uploadLesson(
        title: title,
        audioFile: audioFile,
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }
Future<ApiResult<dynamic>> deleteLesson(int lessonId) async {
  try {
    var response = await webServices.deleteLesson(lessonId);
    return ApiResult.success(response);
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
}