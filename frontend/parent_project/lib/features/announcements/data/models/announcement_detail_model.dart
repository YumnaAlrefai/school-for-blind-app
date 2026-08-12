class AnnouncementDetailModel {
  final String title;
  final List<String> columns;
  final List<List<String>> rows;

  AnnouncementDetailModel({
    required this.title,
    required this.columns,
    required this.rows,
  });

  // type يحدد من أين نقرأ الجدول: exam_program أو timetable_data
  factory AnnouncementDetailModel.fromJson(
    Map<String, dynamic> json,
    String type,
  ) {
    final tableKey = type == 'exam_schedule' ? 'exam_program' : 'timetable_data';
    final table = json[tableKey] ?? {};

    final columns = (table["columns"] as List? ?? [])
        .map((e) => e.toString())
        .toList();

    final rows = (table["rows"] as List? ?? []).map((row) {
      final rowMap = row as Map<String, dynamic>;
      // نأخذ القيم بنفس ترتيب مفاتيحها بالـ JSON، والمفروض يطابق ترتيب columns
      return rowMap.values.map((v) => v?.toString() ?? '').toList();
    }).toList();

    return AnnouncementDetailModel(
      title: json["title"] ?? "",
      columns: columns,
      rows: rows,
    );
  }
}