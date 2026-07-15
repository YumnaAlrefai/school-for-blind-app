import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/models/student.dart';
import 'package:school_for_blind_app/data/repository/student_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthCubit extends Cubit<ResultState<dynamic>> {
  final StudentRepo studentRepo;
  AuthCubit(this.studentRepo) : super(const ResultState.idle());

  String studentPhone = "";

  String fullName = "";
  String fatherName = "";
  String parentPhone = "";
  String studentLevel = "";
  String tempToken = "";

  void resetState() {
    emit(const ResultState.idle());
  }

  void emitSendOTP(String phone) async {
    studentPhone = phone;
    emit(const ResultState.loading());

    final result = await studentRepo.sendOTP(phone);
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
    final result = await studentRepo.verifyOTP(studentPhone, otp);

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
    final result = await studentRepo.register(
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
    final result = await studentRepo.login(phone);
    result.when(
      success: (data) {
        emit(ResultState.success(data['message']));
      },
      failure: (error) => emit(ResultState.failure(error)),
    );
  }

  bool magicLinkCalled = false;

  void emitMagicLink(Uri uri) {
    String? token = Uri.decodeFull(uri.queryParameters['token'] ?? '');

    if (token.isNotEmpty) {
      tempToken = token;
    }
  }

  bool exchangeCalled = false;

  void emitExchangeToken(String oldToken) async {
    if (exchangeCalled) return;
    exchangeCalled = true;
    emit(const ResultState.loading());
    final result = await studentRepo.exchangeToken(oldToken);
    result.when(
      success: (data) async {
        try {
          String accessToken = data['access_token'];
          Student studentData = Student.fromJson(data['student']);

          await SecureStorage.saveToken(accessToken);

          final userKey = accessToken.hashCode.toString();
          getIt<OfflineLessonsCubit>().setUser(userKey);

          final prefs = await SharedPreferences.getInstance();

          String studentJson = jsonEncode(studentData.toJson());
          await prefs.setString('cachedStudent', studentJson);
          await prefs.setBool('login', true);

          emit(ResultState.success(studentData));
        } catch (parseError) {
          emit(
            ResultState.failure(NetworkExceptions.getDioException(parseError)),
          );
        }
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  Future<void> emitLogout() async {
    emit(const ResultState.loading());
    final result = await studentRepo.logout();

    await result.when(
      success: (data) async {
        await SecureStorage.deleteToken();

        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('cachedStudent');
        await prefs.setBool('login', false);

        getIt<StudentCubit>().clearStudentData();

        getIt<VoiceServices>().speak('تَمَّ تَسْجِيلُ الخُرُوجِ بِنَجَاحْ');

        emit(const ResultState.success(null));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }
}
