import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_state.dart';
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
        final isFavorite = (data is Map && data['is_favorite'] is bool)
            ? data['is_favorite'] as bool
            : true;
        emit(SavesState.success(id, type, isFavorite));
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
        final isFavorite = (data is Map && data['is_favorite'] is bool)
            ? data['is_favorite'] as bool
            : false;
        emit(SavesState.success(id, type, isFavorite));
      },
      failure: (networkExceptions) {
        emit(SavesState.failure(networkExceptions));
      },
    );
  }
}
