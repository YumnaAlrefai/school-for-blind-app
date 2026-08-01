import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/teacher_home_screen.dart';


class TaughtSubject {
  final int id;
  final String name;
  const TaughtSubject({required this.id, required this.name});

  factory TaughtSubject.fromJson(Map<String, dynamic> json) => TaughtSubject(
        id: json['id'] as int,
        name: (json['name'] ?? '').toString(),
      );
}

class TeacherLessonsCubit extends Cubit<ResultState<dynamic>> {
  final TeacherRepo teacherRepo;

  List<TeacherLesson> lessons = [];

  
  List<TaughtSubject> taughtSubjects = [];

  
  TaughtSubject? selectedSubject;
 String teacherName = '';
String teacherPhone = '';
  TeacherLessonsCubit(this.teacherRepo) : super(const ResultState.idle());

  
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

  
  Future<void> selectSubject(TaughtSubject subject) async {
    if (selectedSubject?.id == subject.id) return;
    selectedSubject = subject;
    emit(const ResultState.loading());
    await _fetchLessons();
  }

  
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
      emit(ResultState.success(List<TeacherLesson>.from(lessons)));
    },
    
      failure: (e) => emit(ResultState.failure(e)),
    );
  }

  
 List<TeacherLesson> _parseLessons(dynamic data) {
  try {
    final Map map = _asMap(data);
    final List rawList = (map['lessons'] ?? []) as List;
    return rawList.map((e) => TeacherLesson.fromJson(_castMap(e))).toList();
  } catch (e, st) {
    print('🔴 PARSE ERROR: $e');   
    print(st);
    return [];
  }
}

  
  
  
  
  
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
    print('🔴 UPLOAD FAILED: $networkException'); 
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
        emit(ResultState.success(List<TeacherLesson>.from(lessons)));
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

  
  Map _asMap(dynamic v) => v is Map ? v : const {};
  Map<String, dynamic> _castMap(dynamic v) =>
      v is Map ? Map<String, dynamic>.from(v) : <String, dynamic>{};
}