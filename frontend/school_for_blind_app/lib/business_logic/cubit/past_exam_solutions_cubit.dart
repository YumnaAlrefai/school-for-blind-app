import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/past_exam_solutions_state.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class PastExamSolutionsCubit extends Cubit<PastExamSolutionsState> {
  final StudentRepo studentRepo;

  PastExamSolutionsCubit(this.studentRepo)
    : super(const PastExamSolutionsState.initial());

  Future<void> getPastExamSolutions(int examId) async {
    emit(const PastExamSolutionsState.loading());
    final response = await studentRepo.getPastExamSolutions(examId);
    response.when(
      success: (questions) => emit(PastExamSolutionsState.success(questions)),
      failure: (e) => emit(PastExamSolutionsState.failure(e)),
    );
  }
}
