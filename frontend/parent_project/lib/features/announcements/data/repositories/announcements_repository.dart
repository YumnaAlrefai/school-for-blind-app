import '../datasource/announcements_remote_datasource.dart';
import '../models/announcement_list_item_model.dart';
import '../models/announcement_detail_model.dart';

class AnnouncementsRepository {
  final AnnouncementsRemoteDataSource remoteDataSource;

  AnnouncementsRepository(this.remoteDataSource);

  Future<List<AnnouncementListItemModel>> getAnnouncements() async {
    return await remoteDataSource.getAnnouncements();
  }

  Future<AnnouncementDetailModel> getAnnouncementDetail({
    required int id,
    required String type,
  }) async {
    return await remoteDataSource.getAnnouncementDetail(id: id, type: type);
  }
}