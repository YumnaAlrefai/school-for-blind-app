class YearlyReportDataModel {
  final String academicYear;
  final int totalStudentScore;
  final int totalMaxScore;
  final int finalAveragePercentage;

  YearlyReportDataModel({
    required this.academicYear,
    required this.totalStudentScore,
    required this.totalMaxScore,
    required this.finalAveragePercentage,
  });

  factory YearlyReportDataModel.fromJson(Map<String, dynamic> json) {
    return YearlyReportDataModel(
      academicYear: json["academic_year"] ?? "",
      totalStudentScore: json["total_student_score"] ?? 0,
      totalMaxScore: json["total_max_score"] ?? 0,
      finalAveragePercentage: json["final_average_percentage"] ?? 0,
    );
  }
}