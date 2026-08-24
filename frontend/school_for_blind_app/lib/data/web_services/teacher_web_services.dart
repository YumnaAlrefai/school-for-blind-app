import 'dart:io';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'teacher_web_services.g.dart';

@RestApi(baseUrl: 'https://stays-ability-accustom.ngrok-free.dev/api/')
abstract class TeacherWebServices {
  factory TeacherWebServices(Dio dio, {String? baseUrl}) = _TeacherWebServices;

  @POST('otp/send')
  Future<dynamic> sendOTP(@Query("phone") String phone);

  @POST('otp/verify')
  Future<dynamic> verifyOTP(
    @Query("phone") String phone,
    @Query("otp") String otp,
  );

  @POST("teacher/register")
  @MultiPart()
  Future<dynamic> registerTeacher({
    @Part(name: "phone") required String phone,
    @Part(name: "full_name") required String fullName,
    @Part(name: "password") required String password,
    @Part(name: "password_confirmation") required String passwordConfirmation,
    @Part(name: "subjects") required String subjects,
    @Part(name: "level") required String level,
    @Part(name: "fcm_token") required String fcmToken,
    @Part(name: "cv") required MultipartFile cvFile,
  });

  @POST("teacher/login")
  @FormUrlEncoded()
  Future<dynamic> loginTeacher(
    @Field("phone") String phone,
    @Field("password") String password,
  );

  @POST("teacher/logout")
  Future<dynamic> logoutTeacher();

  @GET("lessons")
  Future<dynamic> getLessons(@Query("subject_id") int? subjectId);

  @POST("lessons")
  @MultiPart()
  Future<dynamic> uploadLesson({
    @Part(name: "title") required String title,
    @Part(name: "subject_id") required int subjectId,
    @Part(name: "class_id") required int classId,
    @Part(name: "audio_file") required MultipartFile audioFile,
  });

  @DELETE("lessons/{id}")
  Future<dynamic> deleteLesson(@Path("id") int id);

  @GET("teacher/info")
  Future<dynamic> getTeacherInfo();

  @POST("call/start")
  @FormUrlEncoded()
  Future<dynamic> startCall(
    @Field("room_name") String roomName,
    @Field("class_id") String classId,
  );

  @POST("call/mute")
  @FormUrlEncoded()
  Future<dynamic> muteParticipant(
    @Field("room_name") String roomName,
    @Field("target_id") String targetId,
    @Field("target_type") String targetType,
    @Field("track_sid") String trackSid,
  );

  @POST("unmute-participant")
  @FormUrlEncoded()
  Future<dynamic> unmuteParticipant(
    @Field("room_name") String roomName,
    @Field("target_id") String targetId,
    @Field("target_type") String targetType,
  );

  @POST("call/kick")
  @FormUrlEncoded()
  Future<dynamic> kickParticipant(
    @Field("room_name") String roomName,
    @Field("target_id") String targetId,
    @Field("target_type") String targetType,
  );

  @POST("call/end")
  @FormUrlEncoded()
  Future<dynamic> endCall(@Field("room_name") String roomName);

  @POST("quizzes")
  Future<dynamic> createQuiz(@Body() Map<String, dynamic> body);

  @POST("exam")
  Future<dynamic> createExam(@Body() Map<String, dynamic> body);

  @GET("exam/my-exams")
  Future<dynamic> getMyExams();

  @GET("quizzes/teacher/list")
  Future<dynamic> getMyQuizzes({@Query("subject_id") int? subjectId});

  @GET("question-bank")
  Future<dynamic> getQuestionBank();

  @DELETE("quizzes/{id}")
  Future<dynamic> deleteQuiz(@Path("id") int id);

  @DELETE("question-bank/{id}")
  Future<dynamic> deleteBankQuestion(@Path("id") int id);

  @POST("question-bank")
  Future<dynamic> addBankQuestion(@Body() Map<String, dynamic> body);
  @GET("quizzes/{id}")
  Future<dynamic> getQuizById(@Path("id") int id);

  @POST("quizzes/{id}")
  Future<dynamic> updateQuiz(
    @Path("id") int id,
    @Body() Map<String, dynamic> body,
  );
  @GET("exam/my-exams/{id}")
  Future<dynamic> getExamById(@Path("id") int id);
  @GET("quizzes/teacher/pending-grading")
  Future<dynamic> getQuizzesPendingGrading();

  @GET("quizzes/{id}/submissions")
  Future<dynamic> getQuizSubmissions(@Path("id") int id);

  @GET("quizzes/{id}/students/{sid}/pending-answers")
  Future<dynamic> getPendingTextAnswers(
    @Path("id") int quizId,
    @Path("sid") int studentId,
  );

  @POST("quizzes/{id}/students/{sid}/grade")
  Future<dynamic> gradeTextAnswers(
    @Path("id") int quizId,
    @Path("sid") int studentId,
    @Body() Map<String, dynamic> body,
  );
  @GET("exam/pending-grading")
  Future<dynamic> getExamsPendingGrading();

  @GET("exam/{id}/submissions")
  Future<dynamic> getExamSubmissions(@Path("id") int id);

  @GET("exam/{id}/students/{sid}/pending-answers")
  Future<dynamic> getExamPendingTextAnswers(
    @Path("id") int examId,
    @Path("sid") int studentId,
  );

  @POST("exam/{id}/students/{sid}/grade")
  Future<dynamic> gradeExamTextAnswers(
    @Path("id") int examId,
    @Path("sid") int studentId,
    @Body() Map<String, dynamic> body,
  );
  @POST("support-tickets")
  @MultiPart()
  Future<dynamic> sendSupportTicket({
    @Part(name: "message") required String message,
    @Part(name: "image") required File image,
    @Part(name: "audio") File? audio,
  });
  @GET("teacher/schedule")
  Future<dynamic> getTeacherSchedule();
  @POST("donation/checkout")
  Future<dynamic> donationCheckout(@Body() Map<String, dynamic> body);

  @POST("donation/confirm")
  Future<dynamic> donationConfirm(@Body() Map<String, dynamic> body);
  @GET("teacher/all-subjects/statistics")
  Future<dynamic> getStatistics();

  @GET("teacher/channels/admin-chats")
  Future<dynamic> getAdminChats();

  @GET("teacher/channels/{id}/messages")
  Future<dynamic> getChatMessages(@Path("id") int chatId);
  @POST("teacher/channels/{id}/messages")
  Future<dynamic> sendMessage(
    @Path("id") int chatId,
    @Body() Map<String, dynamic> body,
  );
  @POST("teacher/channels/{id}/messages")
  @MultiPart()
  Future<dynamic> sendVoiceMessage(
    @Path("id") int chatId,
    @Part(name: "attachment") File attachment,
    @Part(name: "attachment_type") String attachmentType,
  );
  @GET("teacher/channels")
  Future<dynamic> getChannels();
  @DELETE("messages/{id}")
  Future<dynamic> deleteMessage(@Path("id") int id);

  @POST("messages/{id}/report")
  Future<dynamic> reportMessage(
    @Path("id") int id,
    @Body() Map<String, dynamic> body,
  );
  @GET("announcements")
  Future<dynamic> getAnnouncements();
  @GET("announcements/exam/{id}")
  Future<dynamic> getExamSchedule(@Path("id") int id);
}
