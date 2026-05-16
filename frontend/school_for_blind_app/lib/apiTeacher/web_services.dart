import 'package:dio/dio.dart';
import 'package:school_for_blind_app/apiTeacher/teacherModel.dart';
import 'teacherModel.dart';
import 'package:retrofit/retrofit.dart';

part 'web_services.g.dart';

@RestApi(baseUrl: 'https://stays-ability-accustom.ngrok-free.dev/api/')
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
}