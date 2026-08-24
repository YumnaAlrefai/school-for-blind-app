import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class DismissalCubit extends Cubit<ResultState<bool>> {
  final StudentRepo studentRepo;

  DismissalCubit(this.studentRepo) : super(const ResultState.idle());

  Future<void> checkDismissal() async {
    emit(const ResultState.loading());
    final response = await studentRepo.checkDismissal();
    response.when(
      success: (bool isDismissed) => emit(ResultState.success(isDismissed)),
      failure: (networkException) =>
          emit(ResultState.failure(networkException)),
    );
  }
}
