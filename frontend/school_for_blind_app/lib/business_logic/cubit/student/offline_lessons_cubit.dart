import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/core/services/offline_manager.dart';
import 'package:school_for_blind_app/data/models/student/lesson.dart';
import 'package:school_for_blind_app/data/models/student/record_model.dart';
import 'offline_lessons_state.dart';

class OfflineLessonsCubit extends Cubit<OfflineLessonsState> {
  final OfflineManager offlineManager = OfflineManager();
  String? _currentUserKey;

  OfflineLessonsCubit() : super(OfflineLessonsInitial());

  Future<void> setUser(String userKey) async {
    _currentUserKey = userKey;
    await offlineManager.openUserBox(userKey);
  }

  String? get currentUserKey => _currentUserKey;

  void loadOfflineLessons({int? subjectId}) {
    if (_currentUserKey == null) return;

    try {
      final allLessons = offlineManager.getLessonsSync(
        _currentUserKey!,
        subjectId: subjectId,
      );
      emit(
        OfflineLessonsLoaded(
          offlineLessons: allLessons,
          filteredOfflineLessons: allLessons,
          currentSubjectId: subjectId,
        ),
      );
    } catch (e) {
      emit(
        OfflineLessonsLoaded(
          offlineLessons: [],
          filteredOfflineLessons: [],
          currentSubjectId: subjectId,
        ),
      );
    }
  }

  void searchOfflineLessons(String query, {int? subjectId}) {
    if (state is! OfflineLessonsLoaded || _currentUserKey == null) return;

    final loaded = state as OfflineLessonsLoaded;
    final allLessons = loaded.offlineLessons;

    if (query.trim().isEmpty) {
      final filtered = subjectId != null
          ? allLessons.where((l) => l.subjectId == subjectId).toList()
          : allLessons;
      emit(loaded.copyWith(filteredOfflineLessons: filtered));
      return;
    }

    final lowerQuery = query.toLowerCase().trim();
    final filtered = allLessons.where((lesson) {
      final matchSubject = subjectId == null || lesson.subjectId == subjectId;
      final matchText =
          lesson.title.toLowerCase().contains(lowerQuery) ||
          (lesson.teacherName?.toLowerCase().contains(lowerQuery) ?? false);
      return matchSubject && matchText;
    }).toList();

    emit(loaded.copyWith(filteredOfflineLessons: filtered));
  }

  Future<void> downloadLesson({
    required Lesson lesson,
    required int subjectId,
    required List<RecordModel> records,
  }) async {
    if (_currentUserKey == null) return;

    if (state is! OfflineLessonDownloadProgress) {
      emit(OfflineLessonDownloadProgress(lesson.id, 0.0));
    }

    try {
      await offlineManager.downloadAndSaveLesson(
        userKey: _currentUserKey!,
        lesson: lesson,
        subjectId: subjectId,
        records: records,
        onProgress: (progress) {
          emit(OfflineLessonDownloadProgress(lesson.id, progress));
        },
      );

      emit(OfflineLessonDownloadSuccess(lesson.id));
      loadOfflineLessons(subjectId: subjectId);
    } catch (e) {
      emit(OfflineLessonDownloadFailure(lesson.id, e.toString()));
      loadOfflineLessons(subjectId: subjectId);
    }
  }

  bool isDownloaded(int lessonId) {
    if (_currentUserKey == null) return false;
    return offlineManager.isLessonDownloaded(_currentUserKey!, lessonId);
  }

  Future<void> deleteLesson(int lessonId) async {
    if (_currentUserKey == null) return;
    await offlineManager.deleteLesson(_currentUserKey!, lessonId);
    loadOfflineLessons();
  }

  Future<void> toggleSavedLesson(int lessonId, {int? subjectId}) async {
    if (_currentUserKey == null) return;
    try {
      final isSaved = await offlineManager.toggleSavedLocally(
        _currentUserKey!,
        lessonId,
      );
      emit(OfflineLessonSaveToggled(lessonId, isSaved));
      loadOfflineLessons(subjectId: subjectId);
    } catch (_) {}
  }
}
