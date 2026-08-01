import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/helpers/user_key_helper.dart';
import 'package:school_for_blind_app/core/services/offline_manager.dart';
import 'package:school_for_blind_app/data/models/student/audio_bookmark.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class AudioBookmarksCubit extends Cubit<ResultState<List<AudioBookmark>>> {
  final OfflineManager offlineManager;
  final StudentRepo studentRepo;

  String? _userKey;
  int? _lessonId;
  int? _recordId;
  bool _isOffline = false;

  AudioBookmarksCubit({
    OfflineManager? offlineManager,
    required this.studentRepo,
  }) : offlineManager = offlineManager ?? OfflineManager(),
       super(const ResultState.idle());

  Future<void> init({
    required int lessonId,
    required int recordId,
    required bool isOffline,
  }) async {
    _lessonId = lessonId;
    _recordId = recordId;
    _isOffline = isOffline;

    emit(const ResultState.loading());
    try {
      if (_isOffline) {
        _userKey = await UserKeyHelper.getCurrentUserKey();
        final bookmarks = await offlineManager.getBookmarks(
          userKey: _userKey!,
          lessonId: lessonId,
          recordId: recordId,
        );
        emit(ResultState.success(bookmarks));
      } else {
        final result = await studentRepo.getBookmarks(recordId);
        result.when(
          success: (bookmarks) => emit(ResultState.success(bookmarks)),
          failure: (error) => emit(ResultState.failure(error)),
        );
      }
    } catch (e) {
      emit(ResultState.failure(NetworkExceptions.defaultError(e.toString())));
    }
  }

  Future<void> addBookmark(Duration position) async {
    final current = state.maybeWhen(
      success: (list) => List<AudioBookmark>.from(list),
      orElse: () => <AudioBookmark>[],
    );

    if (_isOffline) {
      current.add(AudioBookmark(position: position));
      current.sort((a, b) => a.position.compareTo(b.position));
      emit(ResultState.success(current));
      await _persist(current);
    } else {
      if (_lessonId == null || _recordId == null) return;
      final result = await studentRepo.addBookmark(
        recordingId: _recordId!,
        lessonId: _lessonId!,
        timestampInSeconds: position.inSeconds,
      );
      result.when(
        success: (newBookmark) {
          current.add(newBookmark);
          current.sort((a, b) => a.position.compareTo(b.position));
          emit(ResultState.success(current));
        },
        failure: (error) {},
      );
    }
  }

  Future<void> updateBookmarkTitle(int index, String? title) async {
    final current = state.maybeWhen(
      success: (list) => List<AudioBookmark>.from(list),
      orElse: () => <AudioBookmark>[],
    );
    if (index < 0 || index >= current.length) return;

    if (_isOffline) {
      current[index] = current[index].copyWith(
        title: title,
        clearTitle: title == null,
      );
      emit(ResultState.success(current));
      await _persist(current);
    } else {
      final serverId = current[index].serverId;
      if (serverId == null) return;
      final result = await studentRepo.updateBookmark(
        bookmarkId: serverId,
        name: title,
      );
      result.when(
        success: (updatedBookmark) {
          current[index] = updatedBookmark;
          emit(ResultState.success(current));
        },
        failure: (error) {},
      );
    }
  }

  Future<void> setEditing(int index, bool isEditing) async {
    final current = state.maybeWhen(
      success: (list) => List<AudioBookmark>.from(list),
      orElse: () => <AudioBookmark>[],
    );
    if (index < 0 || index >= current.length) return;
    current[index] = current[index].copyWith(isEditing: isEditing);
    emit(ResultState.success(current));
  }

  Future<void> deleteBookmark(int index) async {
    final current = state.maybeWhen(
      success: (list) => List<AudioBookmark>.from(list),
      orElse: () => <AudioBookmark>[],
    );
    if (index < 0 || index >= current.length) return;

    if (_isOffline) {
      current.removeAt(index);
      emit(ResultState.success(current));
      await _persist(current);
    } else {
      final serverId = current[index].serverId;
      if (serverId == null) return;
      final result = await studentRepo.deleteBookmark(serverId);
      result.when(
        success: (_) {
          current.removeAt(index);
          emit(ResultState.success(current));
        },
        failure: (error) {},
      );
    }
  }

  Future<void> _persist(List<AudioBookmark> bookmarks) async {
    if (_isOffline) {
      if (_userKey == null || _lessonId == null || _recordId == null) return;
      await offlineManager.saveBookmarks(
        userKey: _userKey!,
        lessonId: _lessonId!,
        recordId: _recordId!,
        bookmarks: bookmarks,
      );
    }
  }
}
