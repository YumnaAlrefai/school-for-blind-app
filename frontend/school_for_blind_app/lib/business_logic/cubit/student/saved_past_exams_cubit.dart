import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/saved_past_exam.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class SavedPastExamsCubit extends Cubit<ResultState<List<SavedPastExam>>> {
  final StudentRepo studentRepo;

  SavedPastExamsCubit(this.studentRepo) : super(const ResultState.idle());

  Future<void> getSavedPastExams() async {
    emit(const ResultState.loading());
    final response = await studentRepo.getSavedPastExams();

    response.when(
      success: (data) => emit(ResultState.success(data)),
      failure: (e) => emit(ResultState.failure(e)),
    );
  }
}
