import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/solved_quiz.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class SolvedQuizzesCubit extends Cubit<ResultState<List<SolvedQuiz>>> {
  final StudentRepo studentRepo;

  SolvedQuizzesCubit(this.studentRepo) : super(const ResultState.idle());

  void getSolvedQuizzes() async {
    emit(const ResultState.loading());
    final response = await studentRepo.getSolvedQuizzes();
    response.when(
      success: (SolvedQuizzesResponse data) {
        emit(ResultState.success(data.data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
