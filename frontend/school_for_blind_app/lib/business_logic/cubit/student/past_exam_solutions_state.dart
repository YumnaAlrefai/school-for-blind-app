import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/data/models/student/past_exam_solutions.dart';

part 'past_exam_solutions_state.freezed.dart';

@freezed
abstract class PastExamSolutionsState with _$PastExamSolutionsState {
  const factory PastExamSolutionsState.initial() = PastExamSolutionsInitial;
  const factory PastExamSolutionsState.loading() = PastExamSolutionsLoading;
  const factory PastExamSolutionsState.success(
    List<PastExamQuestion> questions,
  ) = PastExamSolutionsSuccess;
  const factory PastExamSolutionsState.failure(
    NetworkExceptions networkExceptions,
  ) = PastExamSolutionsFailure;
}
