import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/schedule_repository.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final ScheduleRepository repository;
  Timer? _pollingTimer;

  ScheduleCubit(this.repository) : super(ScheduleInitial());

  Future<void> fetchSchedule({bool silent = false}) async {
    if (!silent && !isClosed) emit(ScheduleLoading());

    try {
      final result = await repository.getSchedule();
      if (!isClosed) emit(ScheduleSuccess(result));
    } catch (e) {
      print("FETCH SCHEDULE ERROR =================");
      print(e);

      
      if (!isClosed) {
        if (!silent || state is! ScheduleSuccess) {
          emit(ScheduleFailure(e.toString()));
        }
       
      }
    }
  }

  void startPolling() {
    fetchSchedule();

    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchSchedule(silent: true);
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}