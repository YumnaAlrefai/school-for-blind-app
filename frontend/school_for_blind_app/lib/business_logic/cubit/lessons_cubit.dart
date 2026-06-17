import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_home_screen.dart';

class LessonsCubit extends Cubit<ResultState<dynamic>> {
  final TeacherRepo teacherRepo;

  /// دروس المدرس (القادمة من السيرفر: المدخلة بالـ Seeder + المرفوعة من الجوال)
  List<Lesson> lessons = [];

  LessonsCubit(this.teacherRepo) : super(const ResultState.idle());

  /// جلب الدروس — تُستدعى عند فتح الشاشة وبعد كل رفع ناجح
  void emitGetLessons() async {
    emit(const ResultState.loading());

    final result = await teacherRepo.getLessons();

    result.when(
      success: (data) {
        final List list = (data is Map) ? (data['data'] ?? []) : (data ?? []);
        lessons = list.map((json) => Lesson.fromJson(json)).toList();
        emit(ResultState.success(lessons));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  /// رفع درس جديد من جوال المدرس — بنفس أسلوب رفع الـ CV في TeacherCubit
  void emitUploadLesson({
    required String title,
    required File audioFile,
  }) async {
    emit(const ResultState.loading());

    try {
      MultipartFile multipartFile = await MultipartFile.fromFile(
        audioFile.path,
        filename: audioFile.path.split('/').last,
        contentType: MediaType('audio', 'mpeg'),
      );

      final result = await teacherRepo.uploadLesson(
        title: title.trim(),
        audioFile: multipartFile,
      );

      result.when(
        success: (data) {
          // إشارة مميزة حتى تفرّق شاشة الرفع بين نجاح الرفع ونجاح الجلب
          emit(const ResultState.success('lesson_uploaded'));
        },
        failure: (networkException) {
          emit(ResultState.failure(networkException));
        },
      );
    } catch (e) {
      emit(ResultState.failure(NetworkExceptions.getDioException(e)));
    }
  }
  void emitDeleteLesson(int lessonId) async {
  emit(const ResultState.loading());

  final result = await teacherRepo.deleteLesson(lessonId);

  result.when(
    success: (data) {
      // حذف الدرس من القائمة المحلية فوراً بدون إعادة جلب كامل
      lessons.removeWhere((lesson) => lesson.id == lessonId);
      emit(ResultState.success(List<Lesson>.from(lessons)));
    },
    failure: (networkException) {
      emit(ResultState.failure(networkException));
    },
  );
}
}