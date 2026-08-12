class GradeModel {
  final String type;
  final String score;
  final String title;
  final String subjectName;

  GradeModel({
    required this.type,
    required this.score,
    required this.title,
    required this.subjectName,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    return GradeModel(
      type: json["type"] ?? "",
      // السيرفر يرجع score أحيانًا int وأحيانًا String، فنحولها نص دائمًا
      score: json["score"]?.toString() ?? "",
      title: json["title"] ?? "",
      subjectName: json["subject_name"] ?? "",
    );
  }
}