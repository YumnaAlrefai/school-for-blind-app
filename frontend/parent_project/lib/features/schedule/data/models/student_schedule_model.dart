import 'schedule_period_model.dart';

class StudentScheduleModel {
  final int studentId;
  final String studentName;
  final int classId;
  final Map<String, List<SchedulePeriodModel>> schedule;

  StudentScheduleModel({
    required this.studentId,
    required this.studentName,
    required this.classId,
    required this.schedule,
  });

  factory StudentScheduleModel.fromJson(Map<String, dynamic> json) {
    final rawSchedule = json["schedule"] as Map<String, dynamic>? ?? {};

    final parsedSchedule = <String, List<SchedulePeriodModel>>{};
    rawSchedule.forEach((day, periods) {
      parsedSchedule[day] = (periods as List? ?? [])
          .map((e) => SchedulePeriodModel.fromJson(e))
          .toList();
    });

    return StudentScheduleModel(
      studentId: json["student_id"] ?? 0,
      studentName: json["student_name"] ?? "",
      classId: json["class_id"] ?? 0,
      schedule: parsedSchedule,
    );
  }
}