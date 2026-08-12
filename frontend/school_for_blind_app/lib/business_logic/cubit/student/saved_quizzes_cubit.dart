import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/student/saved_quiz.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class SavedQuizzesCubit extends Cubit<ResultState<List<SavedQuiz>>> {
  final StudentRepo studentRepo;

  SavedQuizzesCubit(this.studentRepo) : super(const ResultState.idle());

  void getSavedQuizzes() async {
    emit(const ResultState.loading());
    final response = await studentRepo.getSavedQuizzes();
    response.when(
      success: (quizzes) => emit(ResultState.success(quizzes)),
      failure: (e) => emit(ResultState.failure(e)),
    );
  }
}
