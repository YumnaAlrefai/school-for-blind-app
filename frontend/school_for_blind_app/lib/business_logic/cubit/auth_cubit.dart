import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/data/repository/auth_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<ResultState<dynamic>> {
  final AuthRepo authRepo;
  AuthCubit(this.authRepo) : super(const ResultState.idle());

  String studentPhone = "";

  String fullName = "";
  String fatherName = "";
  String parentPhone = "";
  String studentLevel = "";

  void resetState() {
    emit(const ResultState.idle());
  }

  void emitSendOTP(String phone) async {
    studentPhone = phone;
    emit(const ResultState.loading());

    final result = await authRepo.sendOTP(phone);
    result.when(
      success: (data) {
        emit(ResultState.success(data['message']));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  void emitVerifyOTP(String otp) async {
    emit(const ResultState.loading());
    final result = await authRepo.verifyOTP(studentPhone, otp);

    result.when(
      success: (data) {
        emit(ResultState.success(data['message']));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  void saveRegistrationData({
    required String fullName,
    required String fatherName,
    required String parentPhone,
    required String level,
  }) {
    this.fullName = fullName;
    this.fatherName = fatherName;
    this.parentPhone = parentPhone;
    studentLevel = level;
  }

  void emitRegister(File documentaryEvidence) async {
    emit(const ResultState.loading());
    final result = await authRepo.register(
      fullName,
      fatherName,
      studentPhone,
      parentPhone,
      studentLevel,
      documentaryEvidence,
    );

    result.when(
      success: (data) {
        emit(ResultState.success(data['message']));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  void emitLogin(String phone) async {
    emit(const ResultState.loading());
    studentPhone = phone;
    final result = await authRepo.login(phone);
    result.when(
      success: (data) {
        emit(ResultState.success(data['message']));
      },
      failure: (error) => emit(ResultState.failure(error)),
    );
  }

  void emitMagicLink(Uri uri) async {
    emit(const ResultState.loading());
    String? token = Uri.decodeFull(uri.queryParameters['token'] ?? '');
    if (token.isNotEmpty) {
      final result = await authRepo.magicLogin(token);

      result.when(
        success: (data) async {
          SecureStorage.saveToken(data.token);

          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);

          emit(ResultState.success(data));
        },
        failure: (error) => emit(ResultState.failure(error)),
      );
    }
  }
}
