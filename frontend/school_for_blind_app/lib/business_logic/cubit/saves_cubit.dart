import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/saves_state.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class SavesCubit extends Cubit<SavesState> {
  final StudentRepo studentRepo;

  SavesCubit(this.studentRepo) : super(const SavesState.initial());

  Future<void> addToSaved({required int id, required String type}) async {
    emit(SavesState.loading());
    final response = await studentRepo.addToSaved(id, type);
    response.when(
      success: (data) {
        emit(SavesState.success(id, type, true));
      },
      failure: (networkExceptions) {
        emit(SavesState.failure(networkExceptions));
      },
    );
  }

  Future<void> removeFromSaved({required int id, required String type}) async {
    emit(SavesState.loading());
    final response = await studentRepo.removeFromSaved(id, type);
    response.when(
      success: (data) {
        emit(SavesState.success(id, type, false));
      },
      failure: (networkExceptions) {
        emit(SavesState.failure(networkExceptions));
      },
    );
  }
}
