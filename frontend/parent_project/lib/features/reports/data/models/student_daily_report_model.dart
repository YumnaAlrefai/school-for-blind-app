import 'report_data_model.dart';

class StudentDailyReportModel {
  final String greetingMessage;
  final int studentId;
  final String studentName;
  final ReportDataModel reportData;
  final String message;

  StudentDailyReportModel({
    required this.greetingMessage,
    required this.studentId,
    required this.studentName,
    required this.reportData,
    required this.message,
  });

  factory StudentDailyReportModel.fromJson(Map<String, dynamic> json) {
    return StudentDailyReportModel(
      greetingMessage: json["greeting_message"] ?? "",
      studentId: json["student_id"] ?? 0,
      studentName: json["student_name"] ?? "",
      reportData: ReportDataModel.fromJson(json["report_data"] ?? {}),
      message: json["message"] ?? "",
    );
  }
}