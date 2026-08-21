import 'dart:convert';

class ExamScheduleDetailModel {
  final int id;
  final String title;
  final List<String> columns;
  final List<Map<String, String>> rows;

  ExamScheduleDetailModel({
    required this.id,
    required this.title,
    required this.columns,
    required this.rows,
  });

  factory ExamScheduleDetailModel.fromJson(Map<String, dynamic> json) {
    dynamic examProgram = json["exam_program"] ?? {};

    
    if (examProgram is String) {
      try {
        examProgram = jsonDecode(examProgram);
      } catch (_) {
        examProgram = {};
      }
    }

    final rawRows = (examProgram["rows"] as List? ?? []);

    final parsedRows = rawRows.map<Map<String, String>>((row) {
      final map = Map<String, dynamic>.from(row as Map);
      return {
        'date': (map["date"] ?? '').toString(),
        'subject': (map["subject"] ?? '').toString(),
        'time': (map["time"] ?? '').toString(),
      };
    }).toList();

    return ExamScheduleDetailModel(
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      columns: const ['التاريخ', 'المادة', 'التوقيت'],
      rows: parsedRows,
    );
  }
}