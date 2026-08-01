import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/saved_lesson.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class SavedLessonsCubit extends Cubit<ResultState<List<SavedLesson>>> {
  final StudentRepo studentRepo;

  SavedLessonsCubit(this.studentRepo) : super(const ResultState.idle());

  Future<void> getSavedLessons() async {
    emit(const ResultState.loading());
    final response = await studentRepo.getSavedLessons();

    response.when(
      success: (data) {
        emit(ResultState.success(data));
      },
      failure: (networkExceptions) {
        emit(ResultState.failure(networkExceptions));
      },
    );
  }
}
