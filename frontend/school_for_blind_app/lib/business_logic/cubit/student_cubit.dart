import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/models/student.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';

class StudentCubit extends Cubit<ResultState<dynamic>> {
  final StudentRepo studentRepo;

  Student? currentStudent;

  StudentCubit(this.studentRepo) : super(const ResultState.idle());

  void clearStudentData() {
    currentStudent = null;
    emit(const ResultState.idle());
  }

  Future<void> loadStudentData() async {
    emit(const ResultState.loading());
    try {
      final prefs = await SharedPreferences.getInstance();
      String? studentJson = prefs.getString('cachedStudent');

      if (studentJson != null) {
        currentStudent = Student.fromJson(jsonDecode(studentJson));
        emit(ResultState.success(currentStudent));
      } else {
        emit(const ResultState.idle());
      }
    } catch (e) {
      getIt<VoiceServices>().speak(e.toString());
    }
  }

}
