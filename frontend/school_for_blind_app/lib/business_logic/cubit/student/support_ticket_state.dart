import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

part 'support_ticket_state.freezed.dart';

@freezed
class SupportTicketState with _$SupportTicketState {
  const factory SupportTicketState.initial() = _Initial;
  const factory SupportTicketState.loading() = _Loading;
  const factory SupportTicketState.success(String message) = _Success;
  const factory SupportTicketState.failure(
    NetworkExceptions networkExceptions,
  ) = _Failure;
}
