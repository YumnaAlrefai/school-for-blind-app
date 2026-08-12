import 'package:equatable/equatable.dart';
import 'package:parent_project/features/auth/data/models/support_ticket_response_model.dart';


abstract class SupportState extends Equatable {
  const SupportState();

  @override
  List<Object?> get props => [];
}

class SupportInitial extends SupportState {}

class SupportLoading extends SupportState {}

class SupportSuccess extends SupportState {
  final SupportTicketResponseModel response;

  SupportSuccess(this.response);
}

class SupportFailure extends SupportState {
  final String message;

  SupportFailure(this.message);
}