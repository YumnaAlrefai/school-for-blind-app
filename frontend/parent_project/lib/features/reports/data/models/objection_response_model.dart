class ObjectionDataModel {
  final int id;
  final int studentId;
  final int caregiverId;
  final String punishableRecordId;
  final String reason;
  final String status;
  final String createdAt;
  final String updatedAt;

  ObjectionDataModel({
    required this.id,
    required this.studentId,
    required this.caregiverId,
    required this.punishableRecordId,
    required this.reason,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ObjectionDataModel.fromJson(Map<String, dynamic> json) {
    return ObjectionDataModel(
      id: json["id"] ?? 0,
      studentId: json["student_id"] ?? 0,
      caregiverId: json["caregiver_id"] ?? 0,
      punishableRecordId: json["punishable_record_id"]?.toString() ?? "",
      reason: json["reason"] ?? "",
      status: json["status"] ?? "",
      createdAt: json["created_at"] ?? "",
      updatedAt: json["updated_at"] ?? "",
    );
  }
}

class ObjectionResponseModel {
  final String status;
  final String message;
  final ObjectionDataModel data;

  ObjectionResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  bool get isSuccess => status == "success";

  factory ObjectionResponseModel.fromJson(Map<String, dynamic> json) {
    return ObjectionResponseModel(
      status: json["status"] ?? "",
      message: json["message"] ?? "",
      data: ObjectionDataModel.fromJson(json["data"] ?? {}),
    );
  }
}