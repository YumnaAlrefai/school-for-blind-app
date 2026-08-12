class SubjectQuizModel {
  final String title;
  final int studentScore;
  final int teacherAssignedMark;
  final String gradedAt;

  SubjectQuizModel({
    required this.title,
    required this.studentScore,
    required this.teacherAssignedMark,
    required this.gradedAt,
  });

  factory SubjectQuizModel.fromJson(Map<String, dynamic> json) {
    return SubjectQuizModel(
      title: json["title"] ?? "",
      studentScore: json["student_score"] ?? 0,
      teacherAssignedMark: json["teacher_assigned_mark"] ?? 0,
      gradedAt: json["graded_at"] ?? "",
    );
  }
}