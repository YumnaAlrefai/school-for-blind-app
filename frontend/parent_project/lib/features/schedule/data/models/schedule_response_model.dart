import 'student_schedule_model.dart';

class ScheduleResponseModel {
  final String status;
  final List<StudentScheduleModel> data;

  ScheduleResponseModel({required this.status, required this.data});

  factory ScheduleResponseModel.fromJson(Map<String, dynamic> json) {
    return ScheduleResponseModel(
      status: json["status"] ?? "",
      data: (json["data"] as List? ?? [])
          .map((e) => StudentScheduleModel.fromJson(e))
          .toList(),
    );
  }
}