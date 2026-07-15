import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/helpers/user_key_helper.dart';
import 'package:school_for_blind_app/core/services/offline_manager.dart';
import 'package:school_for_blind_app/data/models/audio_bookmark.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class AudioBookmarksCubit extends Cubit<ResultState<List<AudioBookmark>>> {
  final OfflineManager offlineManager;

  String? _userKey;
  int? _lessonId;
  int? _recordId;
  bool _isOffline = false;

  AudioBookmarksCubit({OfflineManager? offlineManager})
    : offlineManager = offlineManager ?? OfflineManager(),
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
        // TODO لجلب العلامات الاونلاين
        emit(const ResultState.success([]));
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
    current.add(AudioBookmark(position: position));
    current.sort((a, b) => a.position.compareTo(b.position));
    emit(ResultState.success(current));
    await _persist(current);
  }

  Future<void> updateBookmarkTitle(int index, String? title) async {
    final current = state.maybeWhen(
      success: (list) => List<AudioBookmark>.from(list),
      orElse: () => <AudioBookmark>[],
    );
    if (index < 0 || index >= current.length) return;
    current[index] = current[index].copyWith(
      title: title,
      clearTitle: title == null,
    );
    emit(ResultState.success(current));
    await _persist(current);
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
    current.removeAt(index);
    emit(ResultState.success(current));
    await _persist(current);
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
    } else {
      // TODO لتحديث وحفظ العلامات الاونلاين
    }
  }
}
