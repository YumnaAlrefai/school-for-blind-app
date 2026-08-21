import 'package:equatable/equatable.dart';

abstract class DonationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DonationInitial extends DonationState {}

class DonationCheckoutLoading extends DonationState {}

class DonationCheckoutSuccess extends DonationState {
  final String clientSecret;
  final String paymentIntentId;
  DonationCheckoutSuccess(this.clientSecret, this.paymentIntentId);
  @override
  List<Object?> get props => [clientSecret, paymentIntentId];
}

class DonationCheckoutFailure extends DonationState {
  final String message;
  DonationCheckoutFailure(this.message);
  @override
  List<Object?> get props => [message];
}


class DonationPaymentLoading extends DonationState {}

class DonationPaymentFailure extends DonationState {
  final String message;
  DonationPaymentFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class DonationConfirmLoading extends DonationState {}

class DonationConfirmSuccess extends DonationState {
  final String message;
  DonationConfirmSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class DonationConfirmFailure extends DonationState {
  final String message;
  DonationConfirmFailure(this.message);
  @override
  List<Object?> get props => [message];
}