import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_home_screen.dart';

/// مادة يدرّسها المدرس — تجي من teacher/info ضمن مصفوفة taught_subjects
class TaughtSubject {
  final int id;
  final String name;
  const TaughtSubject({required this.id, required this.name});

  factory TaughtSubject.fromJson(Map<String, dynamic> json) => TaughtSubject(
        id: json['id'] as int,
        name: (json['name'] ?? '').toString(),
      );
}

class LessonsCubit extends Cubit<ResultState<dynamic>> {
  final TeacherRepo teacherRepo;

  List<Lesson> lessons = [];

  /// كل المواد التي يدرّسها المدرس (للسهم/القائمة)
  List<TaughtSubject> taughtSubjects = [];

  /// المادة المعروضة حالياً
  TaughtSubject? selectedSubject;
 String teacherName = '';
String teacherPhone = '';
  LessonsCubit(this.teacherRepo) : super(const ResultState.idle());

  /// تُستدعى عند فتح الشاشة: تجيب مواد المدرس ثم دروس أول مادة
  Future<void> emitInitLessons() async {
    emit(const ResultState.loading());

    final infoResult = await teacherRepo.getTeacherInfo();

    await infoResult.when(
      success: (data) async {
  final Map teacher = _asMap(_asMap(data)['data'] ?? data);

teacherName = (teacher['full_name'] ?? '').toString();
teacherPhone = (teacher['phone'] ?? '').toString();
print('🟣 DRAWER DATA — name: "$teacherName", phone: "$teacherPhone"');

final List subs = (teacher['subjects'] ?? []) as List;
        taughtSubjects =
            subs.map((e) => TaughtSubject.fromJson(_castMap(e))).toList();
        selectedSubject =
            taughtSubjects.isNotEmpty ? taughtSubjects.first : null;

        await _fetchLessons();
      },
      failure: (e) async => emit(ResultState.failure(e)),
    );
  }

  /// تبديل المادة المعروضة — يعيد جلب دروسها فقط
  Future<void> selectSubject(TaughtSubject subject) async {
    if (selectedSubject?.id == subject.id) return;
    selectedSubject = subject;
    emit(const ResultState.loading());
    await _fetchLessons();
  }

  /// جلب دروس المادة المختارة (نفس المنطق القديم بس مع فلتر subject_id)
  void emitGetLessons() async {
    emit(const ResultState.loading());
    await _fetchLessons();
  }

  Future<void> _fetchLessons() async {
  print('🟤 FETCHING lessons for subject: ${selectedSubject?.id} (${selectedSubject?.name})');
  final result = await teacherRepo.getLessons(subjectId: selectedSubject?.id);
  result.when(
    success: (data) {
      lessons = _parseLessons(data);
      print('🟤 PARSED ${lessons.length} lessons');
      emit(ResultState.success(List<Lesson>.from(lessons)));
    },
    
      failure: (e) => emit(ResultState.failure(e)),
    );
  }

  /// يفكّ شكل رد Laravel: { "lessons": { "data": [...] } }
 List<Lesson> _parseLessons(dynamic data) {
  try {
    final Map map = _asMap(data);
    final List rawList = (map['lessons'] ?? []) as List;
    return rawList.map((e) => Lesson.fromJson(_castMap(e))).toList();
  } catch (e, st) {
    print('🔴 PARSE ERROR: $e');   // ⬅️ يكشف السطر الغلط
    print(st);
    return [];
  }
}

  // ────────────────────────────────────────────────────────────
  // ⚠️ الرفع لسا زي ما هو (title + audio فقط).
  // لازم نضيف subject_id (من selectedSubject) + class_id قبل ما يشتغل فعلياً.
  // متوقّف على قرار الـ class_id (شوفي الملاحظة بالرسالة).
  // ────────────────────────────────────────────────────────────
void emitUploadLesson({
  required String title,
  required File audioFile,
  required int subjectId,
  required int classId,
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
      subjectId: subjectId,
      classId: classId,
    );

    result.when(
  success: (data) => emit(const ResultState.success('lesson_uploaded')),
  failure: (networkException) {
    print('🔴 UPLOAD FAILED: $networkException'); // ⬅️ مؤقت
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
        lessons.removeWhere((lesson) => lesson.id == lessonId);
        emit(ResultState.success(List<Lesson>.from(lessons)));
      },
      failure: (networkException) => emit(ResultState.failure(networkException)),
    );
  }
  void emitCreateQuiz(Map<String, dynamic> body) async {
  emit(const ResultState.loading());

  final result = await teacherRepo.createQuiz(body);

  result.when(
    success: (data) => emit(const ResultState.success('quiz_created')),
    failure: (networkException) =>
        emit(ResultState.failure(networkException)),
  );
}
void emitCreateExam(Map<String, dynamic> body) async {
  emit(const ResultState.loading());

  final result = await teacherRepo.createExam(body);

  result.when(
    success: (data) => emit(const ResultState.success('exam_created')),
    failure: (networkException) =>
        emit(ResultState.failure(networkException)),
  );
}

  // helpers
  Map _asMap(dynamic v) => v is Map ? v : const {};
  Map<String, dynamic> _castMap(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
}