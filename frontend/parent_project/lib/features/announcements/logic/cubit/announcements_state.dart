import '../../data/models/announcement_model.dart';

abstract class AnnouncementsState {}

class AnnouncementsInitial extends AnnouncementsState {}

class AnnouncementsLoading extends AnnouncementsState {}

class AnnouncementsSuccess extends AnnouncementsState {
  final List<AnnouncementModel> announcements;
  AnnouncementsSuccess(this.announcements);
}

class AnnouncementsFailure extends AnnouncementsState {
  final String message;
  AnnouncementsFailure(this.message);
}