import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/models/lesson.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class LessonsCubit extends Cubit<ResultState<SubjectLessonsResponse>> {
  final StudentRepo studentRepo;

  String _currentSubjectId = '';
  List<Lesson> _allLessons = [];

  LessonsCubit(this.studentRepo) : super(const ResultState.idle());

  void emitGetSubjectLessonsResponse(int id) async {
    emit(const ResultState.loading());
    final response = await studentRepo.getSubjectLessons(id);
    response.when(
      success: (SubjectLessonsResponse data) {
        _allLessons = data.lessons;
        _currentSubjectId = data.subjectId;
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        if (!isClosed) {
          emit(ResultState.failure(networkException));
        }
      },
    );
  }

  void searchLessons(String query) {
    bool isFailureState = state.maybeWhen(
      failure: (_) => true,
      orElse: () => false,
    );

    if (isFailureState) {
      return;
    }

    if (query.isEmpty) {
      emit(
        ResultState.success(
          SubjectLessonsResponse(
            subjectId: _currentSubjectId,
            lessons: _allLessons,
          ),
        ),
      );
    } else {
      final filtered = _allLessons
          .where((lesson) => lesson.title.contains(query))
          .toList();
      emit(
        ResultState.success(
          SubjectLessonsResponse(
            subjectId: _currentSubjectId,
            lessons: filtered,
          ),
        ),
      );
    }
  }
}
