class LogoutResponseModel {
  final bool success;
  final String message;

  LogoutResponseModel({
    required this.success,
    required this.message,
  });

  factory LogoutResponseModel.fromJson(Map<String, dynamic> json) {
    return LogoutResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
    );
  }
}