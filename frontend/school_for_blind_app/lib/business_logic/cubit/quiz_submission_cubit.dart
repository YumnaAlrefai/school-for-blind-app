import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/quiz_submission.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class QuizSubmissionCubit extends Cubit<ResultState<QuizSubmissionResponse>> {
  final StudentRepo studentRepo;

  QuizSubmissionCubit(this.studentRepo) : super(const ResultState.idle());

  void emitSubmitQuiz(FormData formData) async {
    emit(const ResultState.loading());

    final response = await studentRepo.submitQuiz(formData: formData);

    response.when(
      success: (data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
