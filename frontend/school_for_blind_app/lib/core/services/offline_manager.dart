import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/core/helpers/url_helper.dart';
import 'package:school_for_blind_app/data/models/audio_bookmark.dart';
import 'package:school_for_blind_app/data/models/lesson.dart';
import 'package:school_for_blind_app/data/models/offline_lesson_model.dart';
import 'package:school_for_blind_app/data/models/record_model.dart';

class OfflineManager {
  late final Dio _dio;

  OfflineManager() {
    _dio = Dio(BaseOptions(headers: {'ngrok-skip-browser-warning': 'true'}));

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await SecureStorage.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  String _getBoxName(String userKey) => 'offline_user_${userKey}';

  Future<Box<String>> _getBox(String userKey) async {
    final boxName = _getBoxName(userKey);
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<String>(boxName);
    }
    return Hive.box<String>(boxName);
  }

  Future<void> openUserBox(String userKey) async {
    final boxName = _getBoxName(userKey);
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox<String>(boxName);
    }
  }

  Future<bool> toggleSavedLocally(String userKey, int lessonId) async {
    final box = await _getBox(userKey);
    final jsonString = box.get(lessonId.toString());
    if (jsonString == null) throw Exception('الدرس غير موجود محلياً');

    final lesson = OfflineLessonModel.fromJson(jsonDecode(jsonString));
    lesson.isSaved = !lesson.isSaved;
    await box.put(lessonId.toString(), jsonEncode(lesson.toJson()));
    return lesson.isSaved;
  }

  List<OfflineLessonModel> getSavedLessonsSync(String userKey) {
    return getLessonsSync(userKey).where((l) => l.isSaved).toList();
  }

  Future<List<AudioBookmark>> getBookmarks({
    required String userKey,
    required int lessonId,
    required int recordId,
  }) async {
    try {
      final box = await _getBox(userKey);
      final jsonString = box.get(lessonId.toString());
      if (jsonString == null) return [];

      final lesson = OfflineLessonModel.fromJson(jsonDecode(jsonString));
      final record = lesson.records.firstWhere(
        (r) => r.id == recordId,
        orElse: () => throw Exception('Record not found'),
      );
      return record.bookmarks;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveBookmarks({
    required String userKey,
    required int lessonId,
    required int recordId,
    required List<AudioBookmark> bookmarks,
  }) async {
    final box = await _getBox(userKey);
    final jsonString = box.get(lessonId.toString());
    if (jsonString == null) return;

    final lesson = OfflineLessonModel.fromJson(jsonDecode(jsonString));
    final recordIndex = lesson.records.indexWhere((r) => r.id == recordId);
    if (recordIndex == -1) return;

    final oldRecord = lesson.records[recordIndex];
    lesson.records[recordIndex] = OfflineRecordModel(
      id: oldRecord.id,
      name: oldRecord.name,
      url: oldRecord.url,
      localUrl: oldRecord.localUrl,
      bookmarks: bookmarks,
    );

    await box.put(lessonId.toString(), jsonEncode(lesson.toJson()));
  }

  Future<void> downloadAndSaveLesson({
    required String userKey,
    required Lesson lesson,
    required int subjectId,
    required List<RecordModel> records,
    Function(double progress)? onProgress,
  }) async {
    debugPrint('🟡 بدء التنزيل - عدد المقاطع: ${records.length}');
    try {
      final directory = await getApplicationDocumentsDirectory();
      debugPrint('🟡 مسار الحفظ: ${directory.path}');

      List<OfflineRecordModel> offlineRecords = [];
      int totalRecords = records.length;

      for (int i = 0; i < totalRecords; i++) {
        final record = records[i];
        final fixedUrl = UrlHelper.fixLocalhost(record.url);
        debugPrint('🟡 الرابط الأصلي: ${record.url}');
        debugPrint('🟢 الرابط بعد التصحيح: $fixedUrl');

        String filePath = '${directory.path}/record_${record.id}.mp3';

        await _dio.download(
          fixedUrl,
          filePath,
          options: Options(
            headers: {"Accept": "*/*", "Connection": "keep-alive"},
            receiveTimeout: const Duration(minutes: 5),
            sendTimeout: const Duration(minutes: 5),
          ),
          onReceiveProgress: (received, total) {
            debugPrint('⬇️ تحميل: $received / $total');
            if (total != -1 && onProgress != null) {
              double currentProgress = received / total;
              double overallProgress = (i + currentProgress) / totalRecords;
              onProgress(overallProgress);
            }
          },
        );

        debugPrint('✅ انتهى تحميل المقطع ${record.id}');

        offlineRecords.add(
          OfflineRecordModel(
            id: record.id,
            name: record.name,
            url: record.url,
            localUrl: filePath,
          ),
        );
      }

      final offlineLesson = OfflineLessonModel(
        id: lesson.id,
        subjectId: subjectId,
        title: lesson.title,
        teacherName: lesson.teacherName,
        records: offlineRecords,
      );

      final box = await _getBox(userKey);
      final jsonString = jsonEncode(offlineLesson.toJson());
      await box.put(lesson.id.toString(), jsonString);
      debugPrint('✅✅ تم حفظ الدرس بنجاح بالـ Hive');
    } catch (e, stackTrace) {
      debugPrint('🔴 خطأ أثناء التنزيل: $e');
      debugPrint('🔴 StackTrace: $stackTrace');
      throw Exception('فشل التنزيل: $e');
    }
  }

  List<OfflineLessonModel> getLessonsSync(String userKey, {int? subjectId}) {
    try {
      final box = Hive.box<String>(_getBoxName(userKey));
      final allLessons = box.values.map((jsonString) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return OfflineLessonModel.fromJson(jsonMap);
      }).toList();

      if (subjectId != null) {
        return allLessons
            .where((lesson) => lesson.subjectId == subjectId)
            .toList();
      }
      return allLessons;
    } catch (e) {
      return [];
    }
  }

  Future<List<OfflineLessonModel>> getLessons(
    String userKey, {
    int? subjectId,
  }) async {
    try {
      final box = await _getBox(userKey);
      final allLessons = box.values.map((jsonString) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        return OfflineLessonModel.fromJson(jsonMap);
      }).toList();

      if (subjectId != null) {
        return allLessons
            .where((lesson) => lesson.subjectId == subjectId)
            .toList();
      }
      return allLessons;
    } catch (e) {
      return [];
    }
  }

  Future<void> deleteLesson(String userKey, int lessonId) async {
    try {
      final box = await _getBox(userKey);
      final jsonString = box.get(lessonId.toString());
      if (jsonString != null) {
        final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
        final lesson = OfflineLessonModel.fromJson(jsonMap);

        for (var record in lesson.records) {
          final file = File(record.localUrl);
          if (await file.exists()) await file.delete();
        }
      }
      await box.delete(lessonId.toString());
    } catch (e) {}
  }

  bool isLessonDownloaded(String userKey, int lessonId) {
    final box = Hive.box<String>(_getBoxName(userKey));
    return box.containsKey(lessonId.toString());
  }
}
