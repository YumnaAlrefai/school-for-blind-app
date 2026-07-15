import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/quiz_info.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class QuizInfoCubit extends Cubit<ResultState<QuizInfoResponse>> {
  final StudentRepo studentRepo;

  QuizInfoCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetQuizInfo(int subjectId, int teacherId, int lessonId) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getQuizInfo(
      subjectId,
      teacherId,
      lessonId,
    );
    response.when(
      success: (QuizInfoResponse data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
