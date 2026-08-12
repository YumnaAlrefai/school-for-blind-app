import 'yearly_report_data_model.dart';
import 'subject_yearly_model.dart';

class StudentYearlyReportModel {
  final String greetingMessage;
  final int studentId;
  final String studentName;
  final YearlyReportDataModel reportData;
  final List<SubjectYearlyModel> subjects;

  StudentYearlyReportModel({
    required this.greetingMessage,
    required this.studentId,
    required this.studentName,
    required this.reportData,
    required this.subjects,
  });

  factory StudentYearlyReportModel.fromJson(Map<String, dynamic> json) {
    return StudentYearlyReportModel(
      greetingMessage: json["greeting_message"] ?? "",
      studentId: json["student_id"] ?? 0,
      studentName: json["student_name"] ?? "",
      reportData: YearlyReportDataModel.fromJson(json["report_data"] ?? {}),
      subjects: (json["subjects"] as List? ?? [])
          .map((e) => SubjectYearlyModel.fromJson(e))
          .toList(),
    );
  }
}