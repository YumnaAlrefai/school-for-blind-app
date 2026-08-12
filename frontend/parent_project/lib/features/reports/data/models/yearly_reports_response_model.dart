import 'student_yearly_report_model.dart';

class YearlyReportsResponseModel {
  final String status;
  final List<StudentYearlyReportModel> data;

  YearlyReportsResponseModel({
    required this.status,
    required this.data,
  });

  factory YearlyReportsResponseModel.fromJson(Map<String, dynamic> json) {
    return YearlyReportsResponseModel(
      status: json["status"] ?? "",
      data: (json["data"] as List? ?? [])
          .map((e) => StudentYearlyReportModel.fromJson(e))
          .toList(),
    );
  }
}