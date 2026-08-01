import 'package:shared_preferences/shared_preferences.dart';

class ExamJoinStore {
  static String _key(int examId) => 'exam_joined_$examId';

  static Future<bool> isJoined(int examId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_key(examId)) ?? false;
  }

  static Future<void> markJoined(int examId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_key(examId), true);
  }

  static Future<Set<int>> loadJoinedIds(List<int> examIds) async {
    final prefs = await SharedPreferences.getInstance();
    return examIds.where((id) => prefs.getBool(_key(id)) ?? false).toSet();
  }
}
