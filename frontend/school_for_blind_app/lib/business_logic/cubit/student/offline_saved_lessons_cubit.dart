import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/helpers/user_key_helper.dart';
import 'package:school_for_blind_app/core/services/offline_manager.dart';
import 'package:school_for_blind_app/data/models/student/offline_lesson_model.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class OfflineSavedLessonsCubit
    extends Cubit<ResultState<List<OfflineLessonModel>>> {
  final OfflineManager offlineManager;

  OfflineSavedLessonsCubit({OfflineManager? offlineManager})
    : offlineManager = offlineManager ?? OfflineManager(),
      super(const ResultState.idle());

  Future<void> getSavedLessons() async {
    emit(const ResultState.loading());
    try {
      final userKey = await UserKeyHelper.getCurrentUserKey();
      final savedLessons = offlineManager.getSavedLessonsSync(userKey);
      emit(ResultState.success(savedLessons));
    } catch (e) {
      emit(ResultState.failure(NetworkExceptions.defaultError(e.toString())));
    }
  }
}
