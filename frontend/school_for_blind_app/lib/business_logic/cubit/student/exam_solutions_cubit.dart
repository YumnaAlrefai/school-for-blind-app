import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/exam_solution.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class ExamSolutionsCubit extends Cubit<ResultState<ExamSolutionsResponse>> {
  final StudentRepo studentRepo;

  ExamSolutionsCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetExamSolutions(int examId) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getExamSolutions(examId);
    response.when(
      success: (ExamSolutionsResponse data) {
        for (var i = 0; i < data.data.length; i++) {
          data.data[i].questionNumber = i + 1;
        }
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
