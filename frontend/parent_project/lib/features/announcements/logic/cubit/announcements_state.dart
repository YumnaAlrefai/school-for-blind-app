import '../../data/models/announcement_list_item_model.dart';

abstract class AnnouncementsState {}

class AnnouncementsInitial extends AnnouncementsState {}

class AnnouncementsLoading extends AnnouncementsState {}

class AnnouncementsSuccess extends AnnouncementsState {
  final List<AnnouncementListItemModel> items;
  AnnouncementsSuccess(this.items);
}

class AnnouncementsFailure extends AnnouncementsState {
  final String message;
  AnnouncementsFailure(this.message);
}