import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/exam_submission.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';

import '../../../networking/api_result.dart' show ApiResultPatterns;

class ExamSubmissionCubit extends Cubit<ResultState<ExamSubmissionResponse>> {
  final StudentRepo studentRepo;

  ExamSubmissionCubit(this.studentRepo) : super(const ResultState.idle());

  void emitSubmitExam(FormData formData) async {
    emit(const ResultState.loading());
    final response = await studentRepo.submitExam(formData: formData);
    response.when(
      success: (data) => emit(ResultState.success(data)),
      failure: (networkException) =>
          emit(ResultState.failure(networkException)),
    );
  }
}
