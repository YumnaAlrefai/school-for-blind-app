import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/schedule_repository.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository repository;
  Timer? _pollingTimer;

  ScheduleCubit(this.repository) : super(ScheduleInitial());

  Future<void> fetchSchedule({bool silent = false}) async {
    // silent = true تعني تحديث بالخلفية بدون إظهار Loading Spinner
    // (حتى ما يومض الجدول كل 30 ثانية أمام المستخدم)
    if (!silent && !isClosed) emit(ScheduleLoading());

    try {
      final result = await repository.getSchedule();
      if (!isClosed) emit(ScheduleSuccess(result));
    } catch (e) {
      print("FETCH SCHEDULE ERROR =================");
      print(e);
      if (!isClosed) emit(ScheduleFailure(e.toString()));
    }
  }

  void startPolling() {
    fetchSchedule(); // أول جلب فوري مع Loading

    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchSchedule(silent: true); // بعدها تحديث صامت كل 30 ثانية
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}