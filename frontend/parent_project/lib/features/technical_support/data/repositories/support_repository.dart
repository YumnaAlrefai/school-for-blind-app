import 'dart:io';

import '../../../auth/data/datasource/support_remote_datasource.dart';
import '../models/support_ticket_response_model.dart';

class SupportRepository {
  final SupportRemoteDataSource remoteDataSource;

  SupportRepository(this.remoteDataSource);

  Future<SupportTicketResponseModel> sendTicket({
    required String message,
    File? image,
    File? audio,
  }) async {
    return await remoteDataSource.sendTicket(
      message: message,
      image: image,
      audio: audio,
    );
  }
}