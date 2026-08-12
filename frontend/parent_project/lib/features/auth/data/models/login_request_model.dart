class LoginRequestModel {
  final String phone;
  final String password;

  const LoginRequestModel({
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "password": password,
    };
  }

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      phone: json["phone"] ?? "",
      password: json["password"] ?? "",
    );
  }

  LoginRequestModel copyWith({
    String? phone,
    String? password,
  }) {
    return LoginRequestModel(
      phone: phone ?? this.phone,
      password: password ?? this.password,
    );
  }
}