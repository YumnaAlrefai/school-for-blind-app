import 'monthly_report_data_model.dart';

class StudentMonthlyReportModel {
  final String greetingMessage;
  final int studentId;
  final String studentName;
  final MonthlyReportDataModel reportData;
  final String message;

  StudentMonthlyReportModel({
    required this.greetingMessage,
    required this.studentId,
    required this.studentName,
    required this.reportData,
    required this.message,
  });

  factory StudentMonthlyReportModel.fromJson(Map<String, dynamic> json) {
    return StudentMonthlyReportModel(
      greetingMessage: json["greeting_message"] ?? "",
      studentId: json["student_id"] ?? 0,
      studentName: json["student_name"] ?? "",
      reportData: MonthlyReportDataModel.fromJson(json["report_data"] ?? {}),
      message: json["message"] ?? "",
    );
  }
}