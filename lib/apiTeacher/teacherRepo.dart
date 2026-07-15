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
      // ==========================================
      // هذا السطر سيجعل الأيرور يظهر غصب عنه في التيرمنال!
      print("🚨 THE REAL ERROR IS: $e");
      // ==========================================
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> logoutTeacher() async {
    try {
      var response = await webServices.logoutTeacher();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  // ✅ صارت تستقبل subjectId (اختياري) لتفلتر الدروس حسب المادة.
  Future<ApiResult<dynamic>> getLessons({int? subjectId}) async {
    try {
      var response = await webServices.getLessons(subjectId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

Future<ApiResult<dynamic>> uploadLesson({
  required String title,
  required MultipartFile audioFile,
  required int subjectId,
  required int classId,
}) async {
  try {
    var response = await webServices.uploadLesson(
      title: title,
      subjectId: subjectId,
      classId: classId,
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

  Future<ApiResult<dynamic>> getTeacherInfo() async {
    try {
      var response = await webServices.getTeacherInfo();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  /// يستخرج رسالة الخطأ العربية من رد الباك إند (error / details / message).
  String _readCallError(Object e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return 'بطء في الاتصال بالخادم، حاول مرة أخرى';
      }
      final data = e.response?.data;
      if (data is Map) {
        final details = data['details'];
        if (details is Map && details.isNotEmpty) {
          final first = details.values.first;
          if (first is List && first.isNotEmpty) return first.first.toString();
          return first.toString();
        }
        if (data['error'] != null) return data['error'].toString();
        if (data['message'] != null) return data['message'].toString();
      }
    }
    return 'تعذّر تنفيذ الطلب، حاول مرة أخرى';
  }

  Future<ApiResult<dynamic>> startCall({
    required String roomName,
    required String classId,
  }) async {
    try {
      var response = await webServices.startCall(roomName, classId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(
        NetworkExceptions.defaultError(_readCallError(e)),
      );
    }
  }

  Future<ApiResult<dynamic>> muteParticipant({
    required String roomName,
    required String targetId,
    required String targetType,
    required String trackSid,
  }) async {
    try {
      var response = await webServices.muteParticipant(
          roomName, targetId, targetType, trackSid);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> unmuteParticipant({
    required String roomName,
    required String targetId,
    required String targetType,
  }) async {
    try {
      var response =
          await webServices.unmuteParticipant(roomName, targetId, targetType);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> kickParticipant({
    required String roomName,
    required String targetId,
    required String targetType,
  }) async {
    try {
      var response =
          await webServices.kickParticipant(roomName, targetId, targetType);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> endCall({required String roomName}) async {
    try {
      var response = await webServices.endCall(roomName);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }
  Future<ApiResult<dynamic>> createQuiz(Map<String, dynamic> body) async {
  try {
    var response = await webServices.createQuiz(body);
    return ApiResult.success(response);
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> createExam(Map<String, dynamic> body) async {
  try {
    var response = await webServices.createExam(body);
    return ApiResult.success(response);
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
}