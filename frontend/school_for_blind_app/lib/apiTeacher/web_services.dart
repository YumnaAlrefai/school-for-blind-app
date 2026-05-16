import 'package:dio/dio.dart';
import 'package:school_for_blind_app/apiTeacher/teacherModel.dart';
import 'teacherModel.dart';
import 'package:retrofit/retrofit.dart';

part 'web_services.g.dart';

@RestApi(baseUrl: 'http://10.0.2.2:8000/api/')
abstract class WebServices {
  factory WebServices(Dio dio, {String? baseUrl}) = _WebServices;

  @POST("teacher/register")
  @MultiPart()
  Future<TeacherModel> registerTeacher({
    @Part(name: "phone") required String phone,
    @Part(name: "full_name") required String fullName,
    @Part(name: "password") required String password,
    @Part(name: "password_confirmation") required String passwordConfirmation,
    @Part(name: "subjects") required String subjects,
    @Part(name: "level") required String level,
    @Part(name: "fcm_token") required String fcmToken,
    @Part(name: "cv") required MultipartFile cvFile, 
  });
  // @POST("teacher/send-otp")
  // @FormUrlEncoded
  // Future<dynamic> sendOtp(@Field("phone") String phone);

  // @POST("teacher/verify-otp")
  // @FormUrlEncoded
  // Future<dynamic> verifyOtp(
  //   @Field("phone") String phone,
  //   @Field("code") String code,
  // );
}