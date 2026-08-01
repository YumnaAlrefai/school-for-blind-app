import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/schedule_model.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class ScheduleCubit extends Cubit<ResultState<ScheduleResponse>> {
  final StudentRepo studentRepo;

  ScheduleCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetSchedule() async {
    emit(const ResultState.loading());
    final response = await studentRepo.getStudentSchedule();
    response.when(
      success: (ScheduleResponse data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
