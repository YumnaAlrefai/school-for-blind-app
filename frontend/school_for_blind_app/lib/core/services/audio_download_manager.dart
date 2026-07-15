import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class AudioDownloadManager {
  static final Dio _dio = Dio();

  static Future<String?> downloadLessonAudio({
    required int lessonId,
    required String url,
    Function(int received, int total)? onProgress,
  }) async {
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final String downloadPath = '${appDocDir.path}/lessons_audio';
      final Directory dir = Directory(downloadPath);

      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }

      String extension = 'mp3';
      try {
        String extracted = url.split('.').last.split('?').first;
        if (extracted.length <= 4 && extracted.isNotEmpty) {
          extension = extracted;
        }
      } catch (_) {}

      final String fileLocalPath = '$downloadPath/lesson_$lessonId.$extension';
      debugPrint("📂 المسار المحلي للحفظ: $fileLocalPath");

      await _dio.download(
        url,
        fileLocalPath,
        onReceiveProgress: onProgress,
        options: Options(
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
        ),
      );

      debugPrint("✅ تم التحميل بنجاح وحفظ الملف!");
      return fileLocalPath;
    } catch (e) {
      if (e is DioException) {
        debugPrint("Dio Error Type: ${e.type}");
        debugPrint("Dio Error Message: ${e.message}");
        debugPrint("Dio Response: ${e.response}");
      }
      return null;
    }
  }
}
