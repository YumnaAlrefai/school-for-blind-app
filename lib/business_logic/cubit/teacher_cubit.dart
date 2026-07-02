import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/apiTeacher/teacherModel.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart'; // سطر مهم لتعريف الـ MediaType الخاص بالـ PDF

class TeacherCubit extends Cubit<ResultState<dynamic>> {
  TeacherModel? currentTeacher;
  final TeacherRepo teacherRepo;

  TeacherCubit(this.teacherRepo) : super(const ResultState.idle());

  String teacherPhone = "";
  String fullName = "";
  String password = "";
  String passwordConfirmation = "";
  String subjects = "";
  String level = "";
  String fcmToken = "default_token";

  void resetState() {
    emit(const ResultState.idle());
  }

  void emitSendOTP(String phone) async {
    emit(const ResultState.loading());

    teacherPhone = phone;

    final result = await teacherRepo.sendOTP(phone);

    result.when(
      success: (data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  void emitVerifyOTP(String otpCode) async {
    emit(const ResultState.loading());

    final result = await teacherRepo.verifyOTP(teacherPhone, otpCode);

    result.when(
      success: (data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  void saveTeacherRegistrationData({
    required String fullName,
    required String password,
    required String passwordConfirmation,
    required String subjects,
    required String level,
    String? fcmToken,
  }) {
    this.fullName = fullName;
    this.password = password;
    this.passwordConfirmation = passwordConfirmation;
    this.subjects = subjects;
    this.level = level;
    if (fcmToken != null) this.fcmToken = fcmToken;
  }

  void emitRegisterTeacher(File cvFile) async {
    emit(const ResultState.loading());

    try {
      // 1. صياغة ملف الـ PDF وتحديد الـ ContentType لكي يقبله السيرفر فوراً
      MultipartFile multipartFile = await MultipartFile.fromFile(
        cvFile.path,
        filename: cvFile.path.split('/').last,
        contentType: MediaType('application', 'pdf'),
      );

      // طباعة البيانات في الـ Console قبل الإرسال للتأكد منها أثناء التجربة والـ Debugging
      print(" جاري إرسال بيانات التسجيل لـ API المعلم...");
      print(
        "الاسم: $fullName | المادة: $subjects | المرحلة: $level | الهاتف المستخدم: $teacherPhone",
      );

      // 2. إرسال البيانات الحقيقية مباشرة دون أي قيم افتراضية
      final result = await teacherRepo.registerTeacher(
        phone: teacherPhone.trim(),
        fullName: fullName.trim(),
        password: password.trim(),
        passwordConfirmation: passwordConfirmation.trim(),
        subjects: subjects.trim(),
        level: level.trim(),
        fcmToken: fcmToken.trim(),
        cvFile: multipartFile,
      );

      result.when(
        success: (data) async {
          if (data is Map && data.containsKey('token')) {
            await SecureStorage.saveToken(data['token']);
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
          }

          final message = (data is Map) ? data['message'] : data.toString();
          emit(ResultState.success(message));
        },
        failure: (networkException) {
          // طباعة الخطأ الفعلي القادم من السيرفر بدقة لتسهيل معرفة الحقل المرفوض
          print(
            " فشل الطلب من السيرفر. السبب الفعلي: ${networkException.toString()}",
          );
          emit(ResultState.failure(networkException));
        },
      );
    } catch (e) {
      emit(ResultState.failure(NetworkExceptions.getDioException(e)));
    }
  }

  void emitLoginTeacher({
    required String phone,
    required String password,
  }) async {
    emit(const ResultState.loading());

    final result = await teacherRepo.loginTeacher(
      phone: phone,
      password: password,
    );
    result.when(
      success: (data) async {
        try {
          String accessToken = data['access_token'];
          TeacherModel teacherData = TeacherModel.fromJson(data['user']);

          await SecureStorage.saveToken(accessToken);

          final prefs = await SharedPreferences.getInstance();

          String teacherJson = jsonEncode(teacherData.toJson());

          await prefs.setString('cachedteacher', teacherJson);
          await prefs.setBool('teacherLoggedIn', true); // ← مفتاح واضح للمدرّس

          emit(ResultState.success(teacherData));
        } catch (parseError) {
          emit(
            ResultState.failure(NetworkExceptions.getDioException(parseError)),
          );
        }
        emit(ResultState.success(data));
      },
      failure: (error) => emit(ResultState.failure(error)),
    );
  }

  Future<void> loadTeacherData() async {
    emit(const ResultState.loading());
    try {
      final prefs = await SharedPreferences.getInstance();
      String? teacherJson = prefs.getString('cachedTeacher');

      if (teacherJson != null) {
        currentTeacher = TeacherModel.fromJson(jsonDecode(teacherJson));
        emit(ResultState.success(currentTeacher));
      } else {
        emit(const ResultState.idle());
      }
    } catch (e) {}
  }

  void emitLogoutTeacher() async {
    emit(const ResultState.loading());

    final result = await teacherRepo.logoutTeacher();

    result.when(
      success: (data) async {
        await _clearLocalTeacherData();
        emit(ResultState.success(data));
      },
      failure: (networkException) async {
        // حتى لو فشل الاتصال بالسيرفر، نفضل مسح البيانات محلياً لكي لا يعلق المستخدم داخل التطبيق
        await _clearLocalTeacherData();
        emit(ResultState.failure(networkException));
      },
    );
  }

  // دالة مساعدة لتنظيف كاش الجهاز بالكامل
  Future<void> _clearLocalTeacherData() async {
    currentTeacher = null;
    await SecureStorage.deleteToken(); // تأكدي أن كلاس SecureStorage يحتوي على دالة الحذف delete أو المسح
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cachedteacher');
    await prefs.remove('login');
    await prefs.setBool('teacherLoggedIn', false); // ← نفس المفتاح
    await prefs.remove('cachedteacher');
  }
}
