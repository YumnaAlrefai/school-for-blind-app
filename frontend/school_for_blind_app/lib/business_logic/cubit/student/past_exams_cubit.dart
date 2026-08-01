import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exams_state.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class PastExamsCubit extends Cubit<PastExamsState> {
  final StudentRepo studentRepo;

  PastExamsCubit(this.studentRepo) : super(const PastExamsState.initial());

  Future<void> getPastExams(int subjectId) async {
    emit(const PastExamsState.loading());
    final response = await studentRepo.getPastExams(subjectId);
    response.when(
      success: (exams) => emit(PastExamsState.success(exams)),
      failure: (e) => emit(PastExamsState.failure(e)),
    );
  }
}
