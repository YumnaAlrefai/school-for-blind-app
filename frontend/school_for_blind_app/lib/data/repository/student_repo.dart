import 'dart:io';

import 'package:dio/dio.dart';
import 'package:school_for_blind_app/data/models/audio_bookmark.dart';
import 'package:school_for_blind_app/data/models/call.dart';
import 'package:school_for_blind_app/data/models/channel_model.dart';
import 'package:school_for_blind_app/data/models/exam.dart';
import 'package:school_for_blind_app/data/models/exam_submission.dart';
import 'package:school_for_blind_app/data/models/join_call_response.dart';
import 'package:school_for_blind_app/data/models/lesson.dart';
import 'package:school_for_blind_app/data/models/message_model.dart';
import 'package:school_for_blind_app/data/models/quiz_info.dart';
import 'package:school_for_blind_app/data/models/quiz_questions.dart';
import 'package:school_for_blind_app/data/models/quiz_submission.dart';
import 'package:school_for_blind_app/data/models/record_model.dart';
import 'package:school_for_blind_app/data/models/saved_lesson.dart';
import 'package:school_for_blind_app/data/models/saved_past_exam.dart';
import 'package:school_for_blind_app/data/models/schedule_model.dart';
import 'package:school_for_blind_app/data/models/subject_progress.dart';
import 'package:school_for_blind_app/data/web_services/student_web_services.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/data/models/past_exam.dart';
import 'package:school_for_blind_app/data/models/past_exam_solutions.dart';

import '../models/exam_question.dart';

class StudentRepo {
  final StudentWebServices webServices;

  StudentRepo(this.webServices);

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

  Future<ApiResult<dynamic>> register(
    String fullName,
    String fatherName,
    String phone,
    String parentPhone,
    String level,
    File documentaryEvidence,
  ) async {
    try {
      var response = await webServices.register(
        fullName,
        fatherName,
        phone,
        parentPhone,
        level,
        await MultipartFile.fromFile(
          documentaryEvidence.path,
          filename: documentaryEvidence.path.split('/').last,
        ),
      );
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> login(String phone) async {
    try {
      var response = await webServices.login(phone);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> magicLogin(String token) async {
    try {
      var response = await webServices.magicLogin(token);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<dynamic>> exchangeToken(String oldToken) async {
    try {
      var response = await webServices.exchangeToken(oldToken);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<dynamic>> logout() async {
    try {
      var response = await webServices.logout();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<List<Call>>> getCalls() async {
    try {
      final Map<String, dynamic> response = await webServices.getCalls();
      final List<dynamic> rawList = response['data'];
      List<Call> calls = rawList.map((json) => Call.fromJson(json)).toList();

      return ApiResult.success(calls);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<JoinCallResponse>> joinCall(String roomName) async {
    try {
      var response = await webServices.joinCall(roomName);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<dynamic>> donate(Map<String, dynamic> donation) async {
    try {
      var response = await webServices.donate(donation);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> confirmPayment(String paymentIntentId) async {
    try {
      var response = await webServices.confirmPayment({
        "payment_intent_id": paymentIntentId,
      });
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<SubjectProgress>> getSubjectProgress(int subjectId) async {
    try {
      SubjectProgress response = await webServices.getSubjectProgress(
        subjectId,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<SubjectLessonsResponse>> getSubjectLessons(
    int subjectId,
  ) async {
    try {
      SubjectLessonsResponse response = await webServices.getSubjectLessons(
        subjectId,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<LessonRecordsResponse>> getLessonRecords(
    int lessonId,
  ) async {
    try {
      LessonRecordsResponse response = await webServices.getLessonRecords(
        lessonId,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<QuizInfoResponse>> getQuizInfo(
    int subjectId,
    int teacherId,
    int lessonId,
  ) async {
    try {
      var response = await webServices.getQuizInfo({
        "subject_id": subjectId,
        "teacher_id": teacherId,
        "lesson_id": lessonId,
      });
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<QuizQuestionsResponse>> getQuizQuestions(int quizId) async {
    try {
      var response = await webServices.getQuizQuestions(quizId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<QuizSubmissionResponse>> submitQuiz({
    required FormData formData,
  }) async {
    try {
      var response = await webServices.submitQuiz(formData);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> addToSaved(int id, String type) async {
    try {
      var response = await webServices.addToSaved({"id": id, "type": type});
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> removeFromSaved(int id, String type) async {
    try {
      var response = await webServices.removeFromSaved({
        "id": id,
        "type": type,
      });
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<SavedLesson>>> getSavedLessons() async {
    try {
      var response = await webServices.getSavedLessons();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<SavedPastExam>>> getSavedPastExams() async {
    try {
      var response = await webServices.getSavedPastExams();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<AudioBookmark>>> getBookmarks(int recordingId) async {
    try {
      final response = await webServices.getBookmarks(recordingId);
      final List<dynamic> rawList = response['bookmarks'];
      final bookmarks = rawList
          .map(
            (json) => AudioBookmark.fromApiJson(json as Map<String, dynamic>),
          )
          .toList();
      return ApiResult.success(bookmarks);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<AudioBookmark>> addBookmark({
    required int recordingId,
    required int lessonId,
    required int timestampInSeconds,
    String? name,
  }) async {
    try {
      final formMap = {
        'recording_id': recordingId.toString(),
        'lesson_id': lessonId.toString(),
        'timestamp_in_seconds': timestampInSeconds.toString(),
        if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
      };
      final formData = FormData.fromMap(formMap);
      final response = await webServices.addBookmark(formData);
      final bookmarkJson = response['bookmark'] as Map<String, dynamic>;
      return ApiResult.success(AudioBookmark.fromApiJson(bookmarkJson));
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<AudioBookmark>> updateBookmark({
    required int bookmarkId,
    String? name,
  }) async {
    try {
      final response = await webServices.updateBookmark(bookmarkId, {
        'name': name,
      });
      final bookmarkJson = response['bookmark'] as Map<String, dynamic>;
      return ApiResult.success(AudioBookmark.fromApiJson(bookmarkJson));
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> deleteBookmark(int bookmarkId) async {
    try {
      var response = await webServices.deleteBookmark(bookmarkId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<String>> storeSupportTicket({
    String? message,
    File? audio,
    File? image,
  }) async {
    try {
      final response = await webServices.storeSupportTicket(
        message: message,
        audio: audio,
        image: image,
      );
      final data = response as Map<String, dynamic>;
      final successMessage =
          data['message'] as String? ?? 'تم إرسال تذكرة الدعم بنجاح.';
      return ApiResult.success(successMessage);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<PastExam>>> getPastExams(int subjectId) async {
    try {
      final response = await webServices.getPastExams(subjectId);
      return ApiResult.success(response.data);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<List<PastExamQuestion>>> getPastExamSolutions(
    int examId,
  ) async {
    try {
      final response = await webServices.getPastExamSolutions(examId);
      return ApiResult.success(response.data);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ChannelsResponse>> getAllChannels() async {
    try {
      var response = await webServices.getAllChannels();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<MessagesResponse>> getChannelMessages(int channelId) async {
    try {
      final response = await webServices.getChannelMessages(channelId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<SendMessageResponse>> sendMessage(
    int channelId,
    String body,
    File? attachment,
  ) async {
    try {
      final response = await webServices.sendMessage(
        channelId,
        body,
        attachment,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  Future<ApiResult<dynamic>> reportMessage({
    required int messageId,
    required String reason,
  }) async {
    try {
      final response = await webServices.reportMessage(messageId, reason);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<dynamic>> deleteMessage(int messageId) async {
    try {
      final response = await webServices.deleteMessage(messageId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ExamsResponse>> getExams(int subjectId) async {
    try {
      var response = await webServices.getExams(subjectId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ExamQuestionsResponse>> getExamQuestions(int examId) async {
    try {
      var response = await webServices.getExamQuestions(examId);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ExamSubmissionResponse>> submitExam({
    required FormData formData,
  }) async {
    try {
      var response = await webServices.submitExam(formData);
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }

  Future<ApiResult<ScheduleResponse>> getStudentSchedule() async {
    try {
      var response = await webServices.getStudentSchedule();
      return ApiResult.success(response);
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getDioException(e));
    }
  }
}
