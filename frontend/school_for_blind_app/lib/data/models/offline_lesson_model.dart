import 'package:school_for_blind_app/data/models/audio_bookmark.dart';

class OfflineLessonModel {
  final int id;
  final int subjectId;
  final String title;
  final String teacherName;
  final List<OfflineRecordModel> records;
  bool isSaved;

  OfflineLessonModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.teacherName,
    required this.records,
    this.isSaved = false,
  });

  factory OfflineLessonModel.fromJson(Map<String, dynamic> json) {
    return OfflineLessonModel(
      id: json['id'] as int,
      subjectId: json['subject_id'] as int,
      title: json['title'] as String,
      teacherName: json['teacher_name'] as String,
      records: (json['records'] as List<dynamic>)
          .map((e) => OfflineRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isSaved: json['is_saved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject_id': subjectId,
      'title': title,
      'teacher_name': teacherName,
      'records': records.map((e) => e.toJson()).toList(),
      'is_saved': isSaved,
    };
  }
}

class OfflineRecordModel {
  final int id;
  final String name;
  final String url;
  final String localUrl;
  final List<AudioBookmark> bookmarks;

  OfflineRecordModel({
    required this.id,
    required this.name,
    required this.url,
    required this.localUrl,
    this.bookmarks = const [],
  });

  factory OfflineRecordModel.fromJson(Map<String, dynamic> json) {
    return OfflineRecordModel(
      id: json['id'] as int,
      name: json['name'] as String,
      url: json['url'] as String,
      localUrl: json['localUrl'] as String,
      bookmarks: (json['bookmarks'] as List<dynamic>? ?? [])
          .map((e) => AudioBookmark.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
      'localUrl': localUrl,
      'bookmarks': bookmarks.map((e) => e.toJson()).toList(),
    };
  }
}
