class ScheduleSubjectModel {
  final int id;
  final String name;
  final String gradeLevel;
  final int? numberOfLessons;
  final int totalLessons;

  ScheduleSubjectModel({
    required this.id,
    required this.name,
    this.gradeLevel = "",
    this.numberOfLessons,
    this.totalLessons = 0,
  });

  factory ScheduleSubjectModel.fromJson(Map<String, dynamic> json) {
    return ScheduleSubjectModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      gradeLevel: json["grade_level"] ?? "",
      numberOfLessons: json["number_of_lessons"],
      totalLessons: json["total_lessons"] ?? 0,
    );
  }
}