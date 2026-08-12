class ExcuseResponseModel {
  final String status;
  final String message;

  ExcuseResponseModel({
    required this.status,
    required this.message,
  });

  bool get isSuccess => status == "success";

  factory ExcuseResponseModel.fromJson(Map<String, dynamic> json) {
    return ExcuseResponseModel(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
    );
  }
}