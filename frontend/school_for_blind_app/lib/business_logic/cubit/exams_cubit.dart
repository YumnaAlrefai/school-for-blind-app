import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/exam.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class ExamsCubit extends Cubit<ResultState<ExamsResponse>> {
  final StudentRepo studentRepo;

  ExamsCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetExams(int subjectId) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getExams(subjectId);
    response.when(
      success: (ExamsResponse data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
