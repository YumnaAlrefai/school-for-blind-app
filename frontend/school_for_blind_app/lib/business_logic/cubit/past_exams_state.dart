import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/data/models/past_exam.dart';

part 'past_exams_state.freezed.dart';

@freezed
abstract class PastExamsState with _$PastExamsState {
  const factory PastExamsState.initial() = PastExamsInitial;
  const factory PastExamsState.loading() = PastExamsLoading;
  const factory PastExamsState.success(List<PastExam> exams) = PastExamsSuccess;
  const factory PastExamsState.failure(NetworkExceptions networkExceptions) =
      PastExamsFailure;
}
