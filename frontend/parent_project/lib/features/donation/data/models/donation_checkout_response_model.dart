class DonationCheckoutResponseModel {
  final String status;
  final String clientSecret;
  final String paymentIntentId;

  DonationCheckoutResponseModel({
    required this.status,
    required this.clientSecret,
    required this.paymentIntentId,
  });

  factory DonationCheckoutResponseModel.fromJson(Map<String, dynamic> json) {
    return DonationCheckoutResponseModel(
      status: json['status'] ?? '',
      clientSecret: json['client_secret'] ?? '',
      paymentIntentId: json['payment_intent_id'] ?? '',
    );
  }
}