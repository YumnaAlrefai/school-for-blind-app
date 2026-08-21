import '../../data/models/exam_schedule_detail_model.dart';

abstract class ExamScheduleState {}

class ExamScheduleInitial extends ExamScheduleState {}

class ExamScheduleLoading extends ExamScheduleState {}

class ExamScheduleSuccess extends ExamScheduleState {
  final ExamScheduleDetailModel detail;
  ExamScheduleSuccess(this.detail);
}

class ExamScheduleFailure extends ExamScheduleState {
  final String message;
  ExamScheduleFailure(this.message);
}