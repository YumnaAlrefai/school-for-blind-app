import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/core/services/realtime_service.dart';
import 'package:school_for_blind_app/data/models/student/announcement_model.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class AnnouncementsCubit extends Cubit<ResultState<List<Announcement>>> {
  final StudentRepo studentRepo;
  final RealtimeService realtimeService;

  List<Announcement> _current = [];
  String? _level;

  AnnouncementsCubit(this.studentRepo, this.realtimeService)
    : super(const ResultState.idle());

  void getAnnouncements() async {
    emit(const ResultState.loading());
    final response = await studentRepo.getAnnouncements();
    response.when(
      success: (List<Announcement> data) {
        _current = data;
        emit(ResultState.success(_current));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  Future<void> startListening(String? level) async {
    if (level == null) return;
    _level = level;

    final token = await SecureStorage.getToken();
    if (token == null || token.isEmpty) {
      debugPrint('لم يتم العثور على توكن لتشغيل الإعلانات اللحظية');
      return;
    }
    await realtimeService.init(token);

    await realtimeService.subscribeToAnnouncements(
      targetAudience: 'student',
      level: level,
      onAnnouncementReceived: (announcement) {
        if (_current.any((a) => a.id == announcement.id)) return;
        _current = [announcement, ..._current];
        emit(ResultState.success(List.of(_current)));
      },
    );
  }

  @override
  Future<void> close() {
    if (_level != null) {
      realtimeService.unsubscribeFromAnnouncements(
        targetAudience: 'student',
        level: _level!,
      );
    }
    return super.close();
  }
}
