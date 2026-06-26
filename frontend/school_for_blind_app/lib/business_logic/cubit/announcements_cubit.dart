import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/announcement.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class AnnouncementsCubit extends Cubit<ResultState<dynamic>> {
  final StudentRepo studentRepo;
  List<Announcement> _allAnnouncements = [];

  AnnouncementsCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetAllAnnouncements() async {
    emit(const ResultState.loading());
    final data = await studentRepo.getAnnouncements();
    data.when(
      success: (List<Announcement> allAnnouncementsResponse) {
        _allAnnouncements = allAnnouncementsResponse;
        emit(ResultState.success(allAnnouncementsResponse));
      },
      failure: (networkException) =>
          emit(ResultState.failure(networkException)),
    );
  }

  void searchAnnouncement(String query) {
    if (query.isEmpty) {
      emit(ResultState.success(_allAnnouncements));
    } else {
      final filtered = _allAnnouncements.where((announcement) {
        return announcement.content.toLowerCase().contains(query.toLowerCase());
      }).toList();
      emit(ResultState.success(filtered));
    }
  }
}
