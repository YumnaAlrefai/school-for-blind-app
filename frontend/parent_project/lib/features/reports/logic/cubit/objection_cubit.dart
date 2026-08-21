import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/reports_repository.dart';
import '../../data/models/objection_response_model.dart';

abstract class ObjectionState {}

class ObjectionInitial extends ObjectionState {}

class ObjectionLoading extends ObjectionState {}

class ObjectionSuccess extends ObjectionState {
  final ObjectionResponseModel response;
  ObjectionSuccess(this.response);
}

class ObjectionFailure extends ObjectionState {
  final String message;
  ObjectionFailure(this.message);
}

class ObjectionCubit extends Cubit<ObjectionState> {
  final ReportsRepository repository;

  ObjectionCubit(this.repository) : super(ObjectionInitial());

  Future<void> submitObjection({
    required int studentId,
    required int punishableRecordId,
    required String reason,
  }) async {
    if (!isClosed) emit(ObjectionLoading());

    try {
      final result = await repository.submitPunishmentObjection(
        studentId: studentId,
        punishableRecordId: punishableRecordId,
        reason: reason,
      );
      if (!isClosed) emit(ObjectionSuccess(result));
    } catch (e) {
      print("SUBMIT OBJECTION ERROR =================");
      print(e);
      if (!isClosed) emit(ObjectionFailure(e.toString()));
    }
  }
}