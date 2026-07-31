import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/realtime_service.dart';
import 'package:school_for_blind_app/data/models/message_model.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class MessagesCubit extends Cubit<ResultState<MessagesResponse>> {
  final StudentRepo studentRepo;
  int? _currentChannelId;
  int? _currentUserId;

  MessagesCubit(this.studentRepo) : super(const ResultState.idle());

  Future<void> getChannelMessages(int channelId, {int? currentUserId}) async {
    _currentChannelId = channelId;
    if (currentUserId != null) {
      _currentUserId = currentUserId;
    }

    emit(const ResultState.loading());
    final result = await studentRepo.getChannelMessages(channelId);

    if (isClosed) return;

    result.when(
      success: (data) {
        debugPrint('///////////isBanned = ${data.isBanned}');
        emit(ResultState.success(data));
        _subscribeToRealtime(channelId);
      },
      failure: (error) => emit(ResultState.failure(error)),
    );
  }

  Future<void> sendMessage(
    String body, {
    File? attachment,
    String? attachmentType,
  }) async {
    if (_currentChannelId == null) return;

    final result = await studentRepo.sendMessage(
      _currentChannelId!,
      body,
      attachment,
    );

    if (isClosed) return;

    result.when(
      success: (response) => _appendMessage(response.data),
      failure: (error) => print('send failed: $error'),
    );
  }

  void _subscribeToRealtime(int channelId) {
    getIt<RealtimeService>().subscribeToConversation(
      channelId,
      onMessageReceived: (message) {
        if (_currentUserId == null || message.senderId != _currentUserId) {
          _appendMessage(message);
        }
      },
      onMessageDeleted: (deletedMessageId) {
        _removeMessageLocally(deletedMessageId);
      },
    );
  }

  void _appendMessage(MessageModel message) {
    state.whenOrNull(
      success: (data) {
        if (data.data.any((m) => m.id == message.id)) return;

        final updated = MessagesResponse(
          success: data.success,
          data: [...data.data, message],
          isBanned: data.isBanned,
        );
        emit(ResultState.success(updated));
      },
    );
  }

  void _removeMessageLocally(int messageId) {
    state.whenOrNull(
      success: (data) {
        final updatedList = data.data.where((m) => m.id != messageId).toList();
        final updated = MessagesResponse(
          success: data.success,
          data: updatedList,
          isBanned: data.isBanned,
        );
        emit(ResultState.success(updated));
      },
    );
  }

  @override
  Future<void> close() {
    if (_currentChannelId != null) {
      getIt<RealtimeService>().unsubscribeFromConversation(_currentChannelId!);
    }
    return super.close();
  }

  void emitReportMessage({
    required int messageId,
    required String reason,
  }) async {
    await studentRepo.reportMessage(messageId: messageId, reason: reason);
  }

  void emitDeleteMessage(int id) async {
    _removeMessageLocally(id);

    final data = await studentRepo.deleteMessage(id);
    data.when(
      success: (_) {},
      failure: (networkException) {
        if (_currentChannelId != null) {
          getChannelMessages(_currentChannelId!, currentUserId: _currentUserId);
        }
      },
    );
  }
}
