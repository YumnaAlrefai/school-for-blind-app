import 'user_model.dart';


class LoginResponseModel {

  final bool status;
  final String message;
  final String token;
  final UserModel user;


  LoginResponseModel({
    required this.status,
    required this.message,
    required this.token,
    required this.user,
  });


  factory LoginResponseModel.fromJson(
      Map<String,dynamic> json
  ){

    final data = json["data"] ?? {};

    return LoginResponseModel(

      status: json["success"] ?? false,

      message: json["message"] ?? "",

      token: data["token"] ?? "",

      user: UserModel.fromJson(
        data["user"] ?? {},
      ),

    );

  }

}