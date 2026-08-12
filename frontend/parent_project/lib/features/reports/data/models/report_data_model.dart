import 'attendance_model.dart';
import 'punishment_model.dart';
import 'grade_model.dart';

class ReportDataModel {
  final String date;
  final List<AttendanceModel> attendance;
  final List<PunishmentModel> punishments;
  final List<GradeModel> gradesToday;

  ReportDataModel({
    required this.date,
    required this.attendance,
    required this.punishments,
    required this.gradesToday,
  });

  factory ReportDataModel.fromJson(Map<String, dynamic> json) {
    return ReportDataModel(
      date: json["date"] ?? "",
      attendance: (json["attendance"] as List? ?? [])
          .map((e) => AttendanceModel.fromJson(e))
          .toList(),
      punishments: (json["punishments"] as List? ?? [])
          .map((e) => PunishmentModel.fromJson(e))
          .toList(),
      gradesToday: (json["grades_today"] as List? ?? [])
          .map((e) => GradeModel.fromJson(e))
          .toList(),
    );
  }
}