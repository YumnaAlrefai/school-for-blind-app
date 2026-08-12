import 'student_daily_report_model.dart';

class DailyReportsResponseModel {
  final String status;
  final List<StudentDailyReportModel> data;

  DailyReportsResponseModel({
    required this.status,
    required this.data,
  });

  factory DailyReportsResponseModel.fromJson(Map<String, dynamic> json) {
    return DailyReportsResponseModel(
      status: json["status"] ?? "",
      data: (json["data"] as List? ?? [])
          .map((e) => StudentDailyReportModel.fromJson(e))
          .toList(),
    );
  }
}