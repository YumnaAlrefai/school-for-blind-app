class SubjectYearlyModel {
  final int id;
  final String name;
  final String gradeLevel;
  final int? numberOfLessons;
  final int totalLessons;

  SubjectYearlyModel({
    required this.id,
    required this.name,
    required this.gradeLevel,
    required this.numberOfLessons,
    required this.totalLessons,
  });

  factory SubjectYearlyModel.fromJson(Map<String, dynamic> json) {
    return SubjectYearlyModel(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      gradeLevel: json["grade_level"] ?? "",
      numberOfLessons: json["number_of_lessons"],
      totalLessons: json["total_lessons"] ?? 0,
    );
  }
}