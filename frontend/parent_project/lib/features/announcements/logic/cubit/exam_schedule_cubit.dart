import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/announcements_repository.dart';
import 'exam_schedule_state.dart';

class ExamScheduleCubit extends Cubit<ExamScheduleState> {
  final AnnouncementsRepository repository;
  Timer? _pollingTimer;

  ExamScheduleCubit(this.repository) : super(ExamScheduleInitial());

  Future<void> fetchDetail(int id, {bool silent = false}) async {
    if (!silent && !isClosed) emit(ExamScheduleLoading());

    try {
      final result = await repository.getExamScheduleDetail(id);
      if (!isClosed) emit(ExamScheduleSuccess(result));
    } catch (e) {
      print("FETCH EXAM SCHEDULE DETAIL ERROR =================");
      print(e);
      if (!isClosed) emit(ExamScheduleFailure(e.toString()));
    }
  }

  void startPolling(int id) {
    fetchDetail(id);
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchDetail(id, silent: true);
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}