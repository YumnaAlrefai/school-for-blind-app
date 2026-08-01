import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/quiz_questions.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class QuizQuestionsCubit extends Cubit<ResultState<QuizQuestionsResponse>> {
  final StudentRepo studentRepo;

  QuizQuestionsCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetQuizQuestions(int quizId) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getQuizQuestions(quizId);
    response.when(
      success: (QuizQuestionsResponse data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
