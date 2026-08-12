import '../../data/models/schedule_response_model.dart';

abstract class ScheduleState {}

class ScheduleInitial extends ScheduleState {}

class ScheduleLoading extends ScheduleState {}

class ScheduleSuccess extends ScheduleState {
  final ScheduleResponseModel response;
  ScheduleSuccess(this.response);
}

class ScheduleFailure extends ScheduleState {
  final String message;
  ScheduleFailure(this.message);
}