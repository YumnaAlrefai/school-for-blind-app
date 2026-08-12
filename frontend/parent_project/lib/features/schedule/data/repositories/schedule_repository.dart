import '../datasource/schedule_remote_datasource.dart';
import '../models/schedule_response_model.dart';

class ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  ScheduleRepository(this.remoteDataSource);

  Future<ScheduleResponseModel> getSchedule() async {
    return await remoteDataSource.getSchedule();
  }
}