import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:school_for_blind_app/data/models/join_call_response.dart';
import 'package:school_for_blind_app/data/models/lesson.dart';
import 'package:school_for_blind_app/data/models/quiz_info.dart';
import 'package:school_for_blind_app/data/models/quiz_questions.dart';
import 'package:school_for_blind_app/data/models/quiz_submission.dart';
import 'package:school_for_blind_app/data/models/record_model.dart';
import 'package:school_for_blind_app/data/models/saved_lesson.dart';
import 'package:school_for_blind_app/data/models/subject_progress.dart';

part 'student_web_services.g.dart';

// @RestApi(baseUrl: 'http://192.168.137.1:8000/api/')
@RestApi(baseUrl: 'https://stays-ability-accustom.ngrok-free.dev/api/')
abstract class StudentWebServices {
  factory StudentWebServices(Dio dio, {String? baseUrl}) = _StudentWebServices;

  @POST('otp/send')
  Future<dynamic> sendOTP(@Query("phone") String phone);

  @POST('otp/verify')
  Future<dynamic> verifyOTP(
    @Query("phone") String phone,
    @Query("otp") String otp,
  );

  @POST('register')
  @MultiPart()
  Future<dynamic> register(
    @Part(name: "fullname") String fullName,
    @Part(name: "fathersname") String fatherName,
    @Part(name: "phone") String phone,
    @Part(name: "parent_phone") String parentPhone,
    @Part(name: "level") String level,
    @Part(name: "DocumentaryEvidence") MultipartFile documentaryEvidence,
  );

  @POST('login')
  Future<dynamic> login(@Field("phone") String phone);

  // @GET("magic-login")
  // Future<dynamic> magicLogin(@Query('token') String token);
  @GET("https://stays-ability-accustom.ngrok-free.dev/magic-login")
  Future<dynamic> magicLogin(@Query('token') String token);

  @POST("auth/exchange-token")
  Future<dynamic> exchangeToken(@Field('token') String token);

  @POST('logout')
  Future<dynamic> logout();

  @GET('call/active-calls')
  Future<dynamic> getCalls();

  @POST('call/join')
  Future<JoinCallResponse> joinCall(@Field("room_name") String roomName);

  @POST("donation/checkout")
  Future<dynamic> donate(@Body() Map<String, dynamic> donation);

  @POST("donation/confirm")
  Future<dynamic> confirmPayment(@Body() Map<String, dynamic> body);

  @GET("subjects/{id}/lessons/progress")
  Future<SubjectProgress> getSubjectProgress(@Path('id') int subjectId);

  @GET("subjects/{id}/lessons")
  Future<SubjectLessonsResponse> getSubjectLessons(@Path('id') int subjectId);

  @GET("lessons/{id}/record")
  Future<LessonRecordsResponse> getLessonRecords(@Path('id') int lessonId);

  @POST("student/quizzes/search-info")
  Future<QuizInfoResponse> getQuizInfo(@Body() Map<String, int> body);

  @GET("student/quizzes/{id}/questions")
  Future<QuizQuestionsResponse> getQuizQuestions(@Path('id') int quizId);

  @POST("quiz/submit")
  Future<QuizSubmissionResponse> submitQuiz(@Body() FormData formData);

  @POST("favorites/toggle")
  Future<dynamic> addToSaved(@Body() Map<String, dynamic> body);
  
  @POST("favorites/remove")
  Future<dynamic> removeFromSaved(@Body() Map<String, dynamic> body);

  @GET("favorites/lessons")
  Future<List<SavedLesson>> getSavedLessons();

}
