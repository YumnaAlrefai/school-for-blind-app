import 'student_monthly_report_model.dart';

class MonthlyReportsResponseModel {
  final String status;
  final List<StudentMonthlyReportModel> data;

  MonthlyReportsResponseModel({
    required this.status,
    required this.data,
  });

  factory MonthlyReportsResponseModel.fromJson(Map<String, dynamic> json) {
    return MonthlyReportsResponseModel(
      status: json["status"] ?? "",
      data: (json["data"] as List? ?? [])
          .map((e) => StudentMonthlyReportModel.fromJson(e))
          .toList(),
    );
  }
}