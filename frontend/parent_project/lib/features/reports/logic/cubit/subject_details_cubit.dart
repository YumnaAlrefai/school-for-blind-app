import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/repositories/reports_repository.dart';
import 'subject_details_state.dart';

class SubjectDetailsCubit extends Cubit<SubjectDetailsState> {
  final ReportsRepository repository;

  SubjectDetailsCubit(this.repository) : super(SubjectDetailsInitial());

  Future<void> fetchSubjectDetails({
    required int studentId,
    required int subjectId,
  }) async {
    if (!isClosed)
    emit(SubjectDetailsLoading());

    try {
      final result = await repository.getSubjectDetails(
        studentId: studentId,
        subjectId: subjectId,
      );
      if (!isClosed)
      emit(SubjectDetailsSuccess(result));
    } catch (e) {
      print("FETCH SUBJECT DETAILS ERROR =================");
      print(e);
      if (!isClosed)
      emit(SubjectDetailsFailure(e.toString()));
    }
  }
}