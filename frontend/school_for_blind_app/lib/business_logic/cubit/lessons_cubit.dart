

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';

class LessonsCubit extends Cubit<ResultState<dynamic>> {
  final StudentRepo studentRepo;

  List<String> _allLessons = [];

  LessonsCubit(this.studentRepo) : super(const ResultState.idle());

  // void emitGetAllLessons({
  //   String currency = 'usd',
  //   int perPage = 10,
  //   int page = 1,
  //   bool sparkline = true,
  //   String priceChangePercentage = '24h',
  // }) async {
  //   emit(const LessonState.loading());
  //   final data = await LessonRepo.getAllLessons(
  //     currency,
  //     perPage,
  //     page,
  //     sparkline,
  //     priceChangePercentage,
  //   );

  //   data.when(
  //     success: (List<Lesson> allLessons) {
  //       _allLessonsOriginal = allLessons;
  //       emit(LessonState.success(allLessons));
  //     },
  //     failure: (networkException) => emit(LessonState.failure(networkException)),
  //   );
  // }

  void searchLessons(String query) {
    if (query.isEmpty) {
      emit(ResultState.success(_allLessons));
    } else {
      final filtered = _allLessons.where((lesson) {
        return lesson.contains(query);
      }).toList();
      emit(ResultState.success(filtered));
    }
  }
}
