import '../datasource/announcements_remote_datasource.dart';
import '../models/announcement_model.dart';
import '../models/exam_schedule_detail_model.dart';

class AnnouncementsRepository {
  final AnnouncementsRemoteDataSource remoteDataSource;

  AnnouncementsRepository(this.remoteDataSource);

  Future<List<AnnouncementModel>> getAnnouncements() async {
    return await remoteDataSource.getAnnouncements();
  }

  Future<ExamScheduleDetailModel> getExamScheduleDetail(int id) async {
    return await remoteDataSource.getExamScheduleDetail(id);
  }
}