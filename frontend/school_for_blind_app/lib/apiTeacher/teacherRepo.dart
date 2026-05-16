

import 'package:dio/dio.dart';
import 'package:school_for_blind_app/apiTeacher/teacherModel.dart';
import 'package:school_for_blind_app/apiTeacher/web_services.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class TeacherRepo {
  final WebServices webServices;

  TeacherRepo(this.webServices);

  Future<ApiResult<TeacherModel>> registerTeacher({
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
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}