import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/quiz_review.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class QuizReviewCubit extends Cubit<ResultState<QuizReviewResponse>> {
  final StudentRepo studentRepo;

  QuizReviewCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetQuizReview(int quizId) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getQuizReview(quizId);
    response.when(
      success: (QuizReviewResponse data) {
        for (var i = 0; i < data.data.questions.length; i++) {
          data.data.questions[i].questionNumber = i + 1;
        }
        emit(ResultState.success(data));
      },
      failure: (networkException) =>
          emit(ResultState.failure(networkException)),
    );
  }
}
