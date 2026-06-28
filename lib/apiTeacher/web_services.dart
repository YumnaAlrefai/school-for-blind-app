import 'package:dio/dio.dart';
import 'package:school_for_blind_app/apiTeacher/teacherModel.dart';
import 'teacherModel.dart';
import 'package:retrofit/retrofit.dart';

part 'web_services.g.dart';

@RestApi(baseUrl: 'https://average-mutilator-untrained.ngrok-free.dev/api/')
abstract class WebServices {
  factory WebServices(Dio dio, {String? baseUrl}) = _WebServices;

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

@GET("teacher/lessons")
Future<dynamic> getLessons();

@POST("teacher/lessons")
@MultiPart()
Future<dynamic> uploadLesson({
  @Part(name: "title") required String title,
  @Part(name: "audio") required MultipartFile audioFile,
});
@DELETE("teacher/lessons/{id}")
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
}
