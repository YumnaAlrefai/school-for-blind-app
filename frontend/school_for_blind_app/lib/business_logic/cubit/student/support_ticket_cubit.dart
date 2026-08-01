import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/support_ticket_state.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class SupportTicketCubit extends Cubit<SupportTicketState> {
  final StudentRepo studentRepo;

  SupportTicketCubit(this.studentRepo)
    : super(const SupportTicketState.initial());

  Future<void> sendSupportTicket({
    String? message,
    File? audio,
    File? image,
  }) async {
    emit(const SupportTicketState.loading());
    final response = await studentRepo.storeSupportTicket(
      message: message,
      audio: audio,
      image: image,
    );
    response.when(
      success: (msg) {
        emit(SupportTicketState.success(msg));
      },
      failure: (networkExceptions) {
        emit(SupportTicketState.failure(networkExceptions));
      },
    );
  }
}
