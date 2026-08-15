import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/exam.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class SavedExamsCubit extends Cubit<ResultState<List<Exam>>> {
  final StudentRepo studentRepo;

  SavedExamsCubit(this.studentRepo) : super(const ResultState.idle());

  void getSavedExams() async {
    emit(const ResultState.loading());
    final response = await studentRepo.getSavedExams();
    response.when(
      success: (exams) => emit(ResultState.success(exams)),
      failure: (e) => emit(ResultState.failure(e)),
    );
  }
}
