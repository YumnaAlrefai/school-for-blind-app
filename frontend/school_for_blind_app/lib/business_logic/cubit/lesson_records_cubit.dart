import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/services/offline_manager.dart';
import 'package:school_for_blind_app/data/models/record_model.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class LessonRecordsCubit extends Cubit<ResultState<LessonRecordsResponse>> {
  final StudentRepo studentRepo;
  final OfflineManager offlineManager = OfflineManager();

  LessonRecordsCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetLessonRecords(int lessonId) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getLessonRecords(lessonId);
    response.when(
      success: (LessonRecordsResponse data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  void emitSuccess(LessonRecordsResponse data) {
    emit(ResultState.success(data));
  }

  void emitFailure(dynamic error) {
    emit(ResultState.failure(NetworkExceptions.getDioException(error)));
  }
}
