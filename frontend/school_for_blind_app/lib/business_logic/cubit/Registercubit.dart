import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/apiTeacher/teacherModel.dart';
import 'package:school_for_blind_app/business_logic/cubit/resultState.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class RegisterCubit extends Cubit<ResultState<TeacherModel>> {
  final TeacherRepo teacherRepo;
  RegisterCubit(this.teacherRepo) : super(const ResultState.idle());

  void emitRegisterTeacher({
    required String phone,
    required String fullName,
    required String password,
    required String passwordConfirmation,
    required String subjects,
    required String level,
    required String fcmToken,
    required String cvPath, 
  }) async {
    emit(const ResultState.loading());

    MultipartFile file = await MultipartFile.fromFile(
      cvPath,
      filename: cvPath.split('/').last,
    );

    var result = await teacherRepo.registerTeacher(
      phone: phone,
      fullName: fullName,
      password: password,
      passwordConfirmation: passwordConfirmation,
      subjects: subjects,
      level: level,
      fcmToken: fcmToken,
      cvFile: file,
    );

    result.when(
      success: (TeacherModel teacher) {
        emit(ResultState.success(teacher));
      },
      failure: (networkExceptions) {
        emit(ResultState.failure(networkExceptions));
      },
    );
  }
}