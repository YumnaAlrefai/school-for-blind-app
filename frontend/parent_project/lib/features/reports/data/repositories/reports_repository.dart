import 'package:parent_project/features/reports/data/models/objection_response_model.dart';
import 'package:parent_project/features/reports/data/models/subject_details_response_model.dart';
import 'package:parent_project/features/reports/data/models/yearly_reports_response_model.dart';

import '../datasource/reports_remote_datasource.dart';
import '../models/daily_reports_response_model.dart';
import '../models/excuse_response_model.dart';
import '../models/monthly_reports_response_model.dart';
class ReportsRepository {
  final ReportsRemoteDataSource remoteDataSource;

  ReportsRepository(this.remoteDataSource);

  Future<DailyReportsResponseModel> getDailyReports() async {
    return await remoteDataSource.getDailyReports();
  }
  Future<ExcuseResponseModel> submitAbsenceExcuse({
  required int studentId,
  required int roomId,
  required String reason,
}) async {
  return await remoteDataSource.submitAbsenceExcuse(
    studentId: studentId,
    roomId: roomId,
    reason: reason,
  );
}
Future<MonthlyReportsResponseModel> getMonthlyReports() async {
  return await remoteDataSource.getMonthlyReports();
}
Future<YearlyReportsResponseModel> getYearlyReports() async {
  return await remoteDataSource.getYearlyReports();
}
Future<SubjectDetailsResponseModel> getSubjectDetails({
  required int studentId,
  required int subjectId,
}) async {
  return await remoteDataSource.getSubjectDetails(
    studentId: studentId,
    subjectId: subjectId,
  );
}
Future<ObjectionResponseModel> submitPunishmentObjection({
  required int studentId,
  required int punishableRecordId,
  required String reason,
}) {
  return remoteDataSource.submitPunishmentObjection(
    studentId: studentId,
    punishableRecordId: punishableRecordId,
    reason: reason,
  );
}
}