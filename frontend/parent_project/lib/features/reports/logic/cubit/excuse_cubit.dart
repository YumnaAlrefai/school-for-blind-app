import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/reports_repository.dart';
import '../../data/models/excuse_response_model.dart';

abstract class ExcuseState {}

class ExcuseInitial extends ExcuseState {}

class ExcuseLoading extends ExcuseState {}

class ExcuseSuccess extends ExcuseState {
  final ExcuseResponseModel response;
  ExcuseSuccess(this.response);
}

class ExcuseFailure extends ExcuseState {
  final String message;
  ExcuseFailure(this.message);
}

class ExcuseCubit extends Cubit<ExcuseState> {
  final ReportsRepository repository;

  ExcuseCubit(this.repository) : super(ExcuseInitial());

  Future<void> submitExcuse({
    required int studentId,
    required int roomId,
    required String reason,
  }) async {
    if (!isClosed)
    emit(ExcuseLoading());

    try {
      final result = await repository.submitAbsenceExcuse(
        studentId: studentId,
        roomId: roomId,
        reason: reason,
      );
      if (!isClosed)
      emit(ExcuseSuccess(result));
    } catch (e) {
      print("SUBMIT EXCUSE ERROR =================");
      print(e);
      if (!isClosed)
      emit(ExcuseFailure(e.toString()));
    }
  }
}