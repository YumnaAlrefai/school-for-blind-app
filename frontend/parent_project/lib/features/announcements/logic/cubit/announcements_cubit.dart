import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/announcements_repository.dart';
import 'announcements_state.dart';

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  final AnnouncementsRepository repository;

  AnnouncementsCubit(this.repository) : super(AnnouncementsInitial());

  Future<void> fetchAnnouncements() async {
    if (!isClosed) emit(AnnouncementsLoading());

    try {
      final result = await repository.getAnnouncements();
      if (!isClosed) emit(AnnouncementsSuccess(result));
    } catch (e) {
      print("FETCH ANNOUNCEMENTS ERROR =================");
      print(e);
      if (!isClosed) emit(AnnouncementsFailure(e.toString()));
    }
  }
}