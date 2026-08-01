import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class DonationCubit extends Cubit<ResultState<dynamic>> {
  final StudentRepo studentRepo;
  DonationCubit(this.studentRepo) : super(const ResultState.idle());

  void emitDonate(Map<String, dynamic> donation) async {
    emit(const ResultState.loading());
    final result = await studentRepo.donate(donation);
    result.when(
      success: (data) {
        emit(ResultState.success(data));
      },
      failure: (error) => emit(ResultState.failure(error)),
    );
  }
  
  void emitConfirmPayment(String paymentIntentId) async {
    emit(const ResultState.loading());
    final result = await studentRepo.confirmPayment(paymentIntentId);
    result.when(
      success: (data) => emit(ResultState.success(data)),
      failure: (error) => emit(ResultState.failure(error)),
    );
  }
}
