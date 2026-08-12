class MonthlyReportDataModel {
  final int year;
  final int month;
  final List<String> weakSubjects;
  final int neglectedExams;
  final int neglectedQuizzes;
  final int solvedQuizzesCount;
  final int attendancePercentage;

  MonthlyReportDataModel({
    required this.year,
    required this.month,
    required this.weakSubjects,
    required this.neglectedExams,
    required this.neglectedQuizzes,
    required this.solvedQuizzesCount,
    required this.attendancePercentage,
  });

  factory MonthlyReportDataModel.fromJson(Map<String, dynamic> json) {
    return MonthlyReportDataModel(
      year: json["year"] ?? 0,
      month: json["month"] ?? 0,
      weakSubjects: (json["weak_subjects"] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      neglectedExams: json["neglected_exams"] ?? 0,
      neglectedQuizzes: json["neglected_quizzes"] ?? 0,
      solvedQuizzesCount: json["solved_quizzes_count"] ?? 0,
      attendancePercentage: json["attendance_percentage"] ?? 0,
    );
  }
}