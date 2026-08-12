import 'support_ticket_data_model.dart';

class SupportTicketResponseModel {
  final bool success;
  final String message;
  final SupportTicketDataModel data;

  SupportTicketResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory SupportTicketResponseModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      data: SupportTicketDataModel.fromJson(json["data"] ?? {}),
    );
  }
}