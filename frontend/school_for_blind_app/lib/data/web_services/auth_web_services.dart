import 'package:dio/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'auth_web_services.g.dart';

// @RestApi(baseUrl: 'http://192.168.137.1:8000/api/')
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

  @GET("magic-login")
  Future<dynamic> magicLogin(@Query('token') String token);
}
