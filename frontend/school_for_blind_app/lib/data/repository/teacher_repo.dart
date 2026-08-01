import 'dart:io';
import 'package:dio/dio.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

import '../web_services/teacher_web_services.dart';

class TeacherRepo {
  final TeacherWebServices webServices;

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
      
      
      print("🚨 THE REAL ERROR IS: $e");
      
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
Future<ApiResult<dynamic>> getMyExams() async {
  try {
    return ApiResult.success(await webServices.getMyExams());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> getMyQuizzes({int? subjectId}) async {
  try {
    return ApiResult.success(
        await webServices.getMyQuizzes(subjectId: subjectId));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> getQuestionBank() async {
  try {
    return ApiResult.success(await webServices.getQuestionBank());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> deleteQuiz(int id) async {
  try {
    return ApiResult.success(await webServices.deleteQuiz(id));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> deleteBankQuestion(int id) async {
  try {
    return ApiResult.success(await webServices.deleteBankQuestion(id));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> addBankQuestion(Map<String, dynamic> body) async {
  try {
    return ApiResult.success(await webServices.addBankQuestion(body));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getQuizById(int id) async {
  try {
    return ApiResult.success(await webServices.getQuizById(id));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> updateQuiz(int id, Map<String, dynamic> body) async {
  try {
    return ApiResult.success(await webServices.updateQuiz(id, body));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getExamById(int id) async {
  try {
    return ApiResult.success(await webServices.getExamById(id));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getQuizzesPendingGrading() async {
  try {
    return ApiResult.success(await webServices.getQuizzesPendingGrading());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> getQuizSubmissions(int id) async {
  try {
    return ApiResult.success(await webServices.getQuizSubmissions(id));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> getPendingTextAnswers(int quizId, int studentId) async {
  try {
    return ApiResult.success(
        await webServices.getPendingTextAnswers(quizId, studentId));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> gradeTextAnswers(
    int quizId, int studentId, Map<String, dynamic> body) async {
  try {
    return ApiResult.success(
        await webServices.gradeTextAnswers(quizId, studentId, body));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getExamsPendingGrading() async {
  try {
    return ApiResult.success(await webServices.getExamsPendingGrading());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> getExamSubmissions(int id) async {
  try {
    return ApiResult.success(await webServices.getExamSubmissions(id));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> getExamPendingTextAnswers(int examId, int studentId) async {
  try {
    return ApiResult.success(
        await webServices.getExamPendingTextAnswers(examId, studentId));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> gradeExamTextAnswers(
    int examId, int studentId, Map<String, dynamic> body) async {
  try {
    return ApiResult.success(
        await webServices.gradeExamTextAnswers(examId, studentId, body));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> sendSupportTicket({
  required String message,
  required File image,
  File? audio,
}) async {
  try {
    return ApiResult.success(await webServices.sendSupportTicket(
      message: message,
      image: image,
      audio: audio,
    ));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getTeacherSchedule() async {
  try {
    return ApiResult.success(await webServices.getTeacherSchedule());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> donationCheckout(Map<String, dynamic> body) async {
  try {
    return ApiResult.success(await webServices.donationCheckout(body));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> donationConfirm(Map<String, dynamic> body) async {
  try {
    return ApiResult.success(await webServices.donationConfirm(body));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getStatistics() async {
  try {
    return ApiResult.success(await webServices.getStatistics());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getAdminChats() async {
  try {
    return ApiResult.success(await webServices.getAdminChats());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> getChatMessages(int chatId) async {
  try {
    return ApiResult.success(await webServices.getChatMessages(chatId));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> sendMessage(int chatId, Map<String, dynamic> body) async {
  try {
    return ApiResult.success(await webServices.sendMessage(chatId, body));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> sendVoiceMessage(
    int chatId, File attachment) async {
  try {
    return ApiResult.success(
        await webServices.sendVoiceMessage(chatId, attachment, 'audio'));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getChannels() async {
  try {
    return ApiResult.success(await webServices.getChannels());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> deleteMessage(int id) async {
  try {
    return ApiResult.success(await webServices.deleteMessage(id));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}

Future<ApiResult<dynamic>> reportMessage(int id, Map<String, dynamic> body) async {
  try {
    return ApiResult.success(await webServices.reportMessage(id, body));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getAnnouncements() async {
  try {
    return ApiResult.success(await webServices.getAnnouncements());
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
Future<ApiResult<dynamic>> getExamSchedule(int id) async {
  try {
    return ApiResult.success(await webServices.getExamSchedule(id));
  } catch (e) {
    return ApiResult.failure(NetworkExceptions.getDioException(e));
  }
}
}