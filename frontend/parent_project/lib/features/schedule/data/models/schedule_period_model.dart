import 'schedule_subject_model.dart';

class SchedulePeriodModel {
  final int id;
  final int subjectId;
  final String dayOfWeek;
  final int periodNumber;
  final String startTime;
  final String endTime;
  final ScheduleSubjectModel subject;

  SchedulePeriodModel({
    required this.id,
    required this.subjectId,
    required this.dayOfWeek,
    required this.periodNumber,
    required this.startTime,
    required this.endTime,
    required this.subject,
  });

  factory SchedulePeriodModel.fromJson(Map<String, dynamic> json) {
    return SchedulePeriodModel(
      id: json["id"] ?? 0,
      subjectId: json["subject_id"] ?? 0,
      dayOfWeek: json["day_of_week"] ?? "",
      periodNumber: json["period_number"] ?? 0,
      startTime: json["start_time"] ?? "",
      endTime: json["end_time"] ?? "",
      subject: ScheduleSubjectModel.fromJson(json["subject"] ?? {}),
    );
  }
}