import 'package:equatable/equatable.dart';
import 'package:parent_project/features/reports/data/models/yearly_reports_response_model.dart';

import '../../data/models/daily_reports_response_model.dart';
import '../../data/models/monthly_reports_response_model.dart';


abstract class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class DailyReportsSuccess extends ReportsState {
  final DailyReportsResponseModel response;

  DailyReportsSuccess(this.response);
}

class ReportsFailure extends ReportsState {
  final String message;

  ReportsFailure(this.message);
}
class MonthlyReportsSuccess extends ReportsState {
  final MonthlyReportsResponseModel response;

  MonthlyReportsSuccess(this.response);
}
class YearlyReportsSuccess extends ReportsState {
  final YearlyReportsResponseModel response;

  YearlyReportsSuccess(this.response);
}