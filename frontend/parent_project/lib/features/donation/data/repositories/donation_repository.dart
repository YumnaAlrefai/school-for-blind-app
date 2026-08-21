import '../datasource/donation_remote_datasource.dart';
import '../models/donation_checkout_response_model.dart';
import '../models/donation_confirm_response_model.dart';

class DonationRepository {
  final DonationRemoteDataSource remoteDataSource;

  DonationRepository(this.remoteDataSource);

  Future<DonationCheckoutResponseModel> checkout({
    required double amount,
    String? name,
  }) {
    return remoteDataSource.checkout(amount: amount, name: name);
  }

  Future<DonationConfirmResponseModel> confirm(String paymentIntentId) {
    return remoteDataSource.confirm(paymentIntentId);
  }
}