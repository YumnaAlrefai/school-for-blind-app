import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/announcements_repository.dart';
import 'announcements_state.dart';

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  final AnnouncementsRepository repository;
  Timer? _pollingTimer;

  AnnouncementsCubit(this.repository) : super(AnnouncementsInitial());

  Future<void> fetchAnnouncements({bool silent = false}) async {
    if (!silent && !isClosed) emit(AnnouncementsLoading());

    try {
      final result = await repository.getAnnouncements();
      if (!isClosed) emit(AnnouncementsSuccess(result));
    } catch (e) {
      print("FETCH ANNOUNCEMENTS ERROR =================");
      print(e);
      if (!isClosed) emit(AnnouncementsFailure(e.toString()));
    }
  }

  void startPolling() {
    fetchAnnouncements();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      fetchAnnouncements(silent: true);
    });
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}