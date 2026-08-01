import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/exam_question.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart'
    show ApiResultPatterns;

class ExamQuestionsCubit extends Cubit<ResultState<ExamQuestionsResponse>> {
  final StudentRepo studentRepo;

  ExamQuestionsCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetExamQuestions(int examId) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getExamQuestions(examId);
    response.when(
      success: (ExamQuestionsResponse data) {
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
