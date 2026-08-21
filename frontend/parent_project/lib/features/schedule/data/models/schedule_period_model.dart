import 'schedule_subject_model.dart';
import 'schedule_class_model.dart';

class SchedulePeriodModel {
  final int id;
  final int classId;
  final int teacherId;
  final int subjectId;
  final String dayOfWeek;
  final int periodNumber;
  final String startTime;
  final String endTime;
  final ScheduleSubjectModel subject;
  final ScheduleClassModel? studentClass;

  SchedulePeriodModel({
    required this.id,
    required this.classId,
    required this.teacherId,
    required this.subjectId,
    required this.dayOfWeek,
    required this.periodNumber,
    required this.startTime,
    required this.endTime,
    required this.subject,
    this.studentClass,
  });

  factory SchedulePeriodModel.fromJson(Map<String, dynamic> json) {
    return SchedulePeriodModel(
      id: json["id"] ?? 0,
      classId: json["class_id"] ?? 0,
      teacherId: json["teacher_id"] ?? 0,
      subjectId: json["subject_id"] ?? 0,
      dayOfWeek: json["day_of_week"] ?? "",
      periodNumber: json["period_number"] ?? 0,
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
      subject: ScheduleSubjectModel.fromJson(json["subject"] ?? {}),
      studentClass: json["student_class"] != null
          ? ScheduleClassModel.fromJson(json["student_class"])
          : null,
    );
  }
}