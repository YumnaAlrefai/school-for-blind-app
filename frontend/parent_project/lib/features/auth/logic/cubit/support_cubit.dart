import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/features/auth/logic/support_state.dart';

import '../../data/repositories/support_repository.dart';

class SupportCubit extends Cubit<SupportState> {
  final SupportRepository repository;

  SupportCubit(this.repository) : super(SupportInitial());

  Future<void> sendTicket({
    required String message,
    File? image,
    File? audio,
  }) async {
    emit(SupportLoading());

    try {
      final result = await repository.sendTicket(
        message: message,
        image: image,
        audio: audio,
      );

      emit(SupportSuccess(result));
    } catch (e) {
      print("SEND TICKET ERROR =================");
      print(e);
      emit(SupportFailure(e.toString()));
    }
  }
}