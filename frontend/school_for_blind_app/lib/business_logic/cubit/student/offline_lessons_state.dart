import 'package:school_for_blind_app/data/models/student/offline_lesson_model.dart';

abstract class OfflineLessonsState {}

class OfflineLessonsInitial extends OfflineLessonsState {}

class OfflineLessonDownloadProgress extends OfflineLessonsState {
  final int lessonId;
  final double progress;
  OfflineLessonDownloadProgress(this.lessonId, this.progress);
}

class OfflineLessonDownloadSuccess extends OfflineLessonsState {
  final int lessonId;
  OfflineLessonDownloadSuccess(this.lessonId);
}

class OfflineLessonDownloadFailure extends OfflineLessonsState {
  final int lessonId;
  final String errorMessage;
  OfflineLessonDownloadFailure(this.lessonId, this.errorMessage);
}

class OfflineLessonsLoaded extends OfflineLessonsState {
  final List<OfflineLessonModel> offlineLessons;
  final List<OfflineLessonModel> filteredOfflineLessons;
  final int? currentSubjectId;

  OfflineLessonsLoaded({
    required this.offlineLessons,
    required this.filteredOfflineLessons,
    this.currentSubjectId,
  });

  OfflineLessonsLoaded copyWith({
    List<OfflineLessonModel>? offlineLessons,
    List<OfflineLessonModel>? filteredOfflineLessons,
    int? currentSubjectId,
  }) {
    return OfflineLessonsLoaded(
      offlineLessons: offlineLessons ?? this.offlineLessons,
      filteredOfflineLessons:
          filteredOfflineLessons ?? this.filteredOfflineLessons,
      currentSubjectId: currentSubjectId ?? this.currentSubjectId,
    );
  }
}

class OfflineLessonSaveToggled extends OfflineLessonsState {
  final int lessonId;
  final bool isSaved;
  OfflineLessonSaveToggled(this.lessonId, this.isSaved);
}
