class SubjectExamModel {
  final String title;
  final int maxScore;
  final String studentScore;
  final String gradedAt;

  SubjectExamModel({
    required this.title,
    required this.maxScore,
    required this.studentScore,
    required this.gradedAt,
  });

  factory SubjectExamModel.fromJson(Map<String, dynamic> json) {
    return SubjectExamModel(
      title: json["title"] ?? "",
      maxScore: json["max_score"] ?? 0,
      studentScore: json["student_score"]?.toString() ?? "",
      gradedAt: json["graded_at"] ?? "",
    );
  }
}