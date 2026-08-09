import 'package:shared_preferences/shared_preferences.dart';

class ExamSubmitStore {
  static String _key(int examId) => 'exam_submitted_$examId';

  static Future<bool> isSubmitted(int examId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key(examId)) ?? false;
  }

  static Future<void> markSubmitted(int examId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(examId), true);
  }

  static Future<Set<int>> loadSubmittedIds(List<int> examIds) async {
    final prefs = await SharedPreferences.getInstance();
    return examIds.where((id) => prefs.getBool(_key(id)) ?? false).toSet();
  }
}
