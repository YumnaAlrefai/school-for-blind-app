import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/subject_progress.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class SubjectProgressCubit extends Cubit<ResultState<SubjectProgress>> {
  final StudentRepo studentRepo;

  SubjectProgressCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetSubjectProgress(int id) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getSubjectProgress(id);
    response.when(
      success: (SubjectProgress data) => emit(ResultState.success(data)),
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
