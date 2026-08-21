import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/reports_repository.dart';
import 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final ReportsRepository repository;

  ReportsCubit(this.repository) : super(ReportsInitial());

  Future<void> fetchDailyReports() async {
    emit(ReportsLoading());

    try {
      final result = await repository.getDailyReports();
      if (!isClosed) {
        emit(DailyReportsSuccess(result));
      }
    } catch (e) {
      print("FETCH DAILY REPORTS ERROR =================");
      print(e);
      if (!isClosed) {
        emit(ReportsFailure(e.toString()));
      }
    }
  }

  Future<void> fetchMonthlyReports() async {
    emit(ReportsLoading());

    try {
      final result = await repository.getMonthlyReports();
      if (!isClosed) {
        emit(MonthlyReportsSuccess(result));
      }
    } catch (e) {
      print("FETCH MONTHLY REPORTS ERROR =================");
      print(e);
      if (!isClosed) {
        emit(ReportsFailure(e.toString()));
      }
    }
  }

  Future<void> fetchYearlyReports() async {
    emit(ReportsLoading());

    try {
      final result = await repository.getYearlyReports();
      if (!isClosed) {
        emit(YearlyReportsSuccess(result));
      }
    } catch (e) {
      print("FETCH YEARLY REPORTS ERROR =================");
      print(e);
      if (!isClosed) {
        emit(ReportsFailure(e.toString()));
      }
    }
  }
}