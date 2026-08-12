import 'subject_quiz_model.dart';
import 'subject_exam_model.dart';

class SubjectDetailsResponseModel {
  final String status;
  final String studentName;
  final List<SubjectQuizModel> quizzes;
  final List<SubjectExamModel> exams;

  SubjectDetailsResponseModel({
    required this.status,
    required this.studentName,
    required this.quizzes,
    required this.exams,
  });

  factory SubjectDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};
    return SubjectDetailsResponseModel(
      status: json["status"] ?? "",
      studentName: data["student_name"] ?? "",
      quizzes: (data["quizzes"] as List? ?? [])
          .map((e) => SubjectQuizModel.fromJson(e))
          .toList(),
      exams: (data["exams"] as List? ?? [])
          .map((e) => SubjectExamModel.fromJson(e))
          .toList(),
    );
  }
}