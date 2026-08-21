class DonationConfirmResponseModel {
  final String? status; 
  final String message;

  DonationConfirmResponseModel({
    this.status,
    required this.message,
  });

  factory DonationConfirmResponseModel.fromJson(Map<String, dynamic> json) {
    return DonationConfirmResponseModel(
      status: json['status'],
      message: json['message'] ?? '',
    );
  }
}