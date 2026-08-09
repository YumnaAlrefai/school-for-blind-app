import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/announcement_model.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class ExamDetailCubit extends Cubit<ResultState<ExamDetailResponse>> {
  final StudentRepo studentRepo;

  ExamDetailCubit(this.studentRepo) : super(const ResultState.idle());

  void getExamDetail(int id) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getExamDetail(id);
    response.when(
      success: (ExamDetailResponse data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
