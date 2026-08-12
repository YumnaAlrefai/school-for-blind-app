import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/announcements_repository.dart';
import '../../data/models/announcement_detail_model.dart';

abstract class AnnouncementDetailState {}

class AnnouncementDetailInitial extends AnnouncementDetailState {}

class AnnouncementDetailLoading extends AnnouncementDetailState {}

class AnnouncementDetailSuccess extends AnnouncementDetailState {
  final AnnouncementDetailModel model;
  AnnouncementDetailSuccess(this.model);
}

class AnnouncementDetailFailure extends AnnouncementDetailState {
  final String message;
  AnnouncementDetailFailure(this.message);
}

class AnnouncementDetailCubit extends Cubit<AnnouncementDetailState> {
  final AnnouncementsRepository repository;

  AnnouncementDetailCubit(this.repository) : super(AnnouncementDetailInitial());

  Future<void> fetchDetail({required int id, required String type}) async {
    if (!isClosed) emit(AnnouncementDetailLoading());

    try {
      final result = await repository.getAnnouncementDetail(id: id, type: type);
      if (!isClosed) emit(AnnouncementDetailSuccess(result));
    } catch (e) {
      print("FETCH ANNOUNCEMENT DETAIL ERROR =================");
      print(e);
      if (!isClosed) emit(AnnouncementDetailFailure(e.toString()));
    }
  }
}