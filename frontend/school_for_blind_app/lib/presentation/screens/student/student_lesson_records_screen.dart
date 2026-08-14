import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/lesson_records_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_cubit.dart';
import 'package:school_for_blind_app/core/helpers/url_helper.dart';
import 'package:school_for_blind_app/core/helpers/user_key_helper.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/lesson.dart';
import 'package:school_for_blind_app/data/models/student/record_model.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/lesson_card.dart';

class StudentLessonRecordsScreen extends StatefulWidget {
  final String subjectName;
  final dynamic lesson;
  final bool isOffline;

  const StudentLessonRecordsScreen({
    super.key,
    required this.lesson,
    this.isOffline = false,
    required this.subjectName,
  });

  @override
  State<StudentLessonRecordsScreen> createState() =>
      _StudentLessonRecordsScreenState();
}

class _StudentLessonRecordsScreenState
    extends State<StudentLessonRecordsScreen> {
  late final LessonRecordsCubit _recordsCubit;
  late final SavesCubit _savesCubit;
  late final OfflineLessonsCubit _offlineCubit;

  @override
  void initState() {
    super.initState();
    _recordsCubit = getIt<LessonRecordsCubit>();
    _savesCubit = getIt<SavesCubit>();
    _offlineCubit = getIt<OfflineLessonsCubit>();

    _initOfflineCubit();

    if (widget.isOffline) {
      _loadOfflineRecords();
    } else {
      _recordsCubit.emitGetLessonRecords(widget.lesson.id);
    }
  }

  Future<void> _initOfflineCubit() async {
    final userKey = await UserKeyHelper.getCurrentUserKey();
    await _offlineCubit.setUser(userKey);
  }

  Future<void> _loadOfflineRecords() async {
    try {
      final userKey = await UserKeyHelper.getCurrentUserKey();

      final offlineLessons = await _recordsCubit.offlineManager.getLessons(
        userKey,
      );

      final currentOfflineLesson = offlineLessons.firstWhere(
        (l) => l.id == widget.lesson.id,
        orElse: () => throw Exception("Lesson not found"),
      );

      final mappedRecords = currentOfflineLesson.records.map((offlineRecord) {
        return RecordModel(
          id: offlineRecord.id,
          name: offlineRecord.name,
          url: offlineRecord.localUrl,
        );
      }).toList();

      final recordsResponse = LessonRecordsResponse(
        lessonId: widget.lesson.id.toString(),
        record: mappedRecords,
      );

      _recordsCubit.emitSuccess(recordsResponse);
    } catch (e) {
      debugPrint('🔴 خطأ تحميل الدروس الأوفلاين: $e');
      _recordsCubit.emitFailure(e);
    }
  }

  String _formatRecordName(String originalName) {
    final Map<String, String> sectionNames = {
      'قسم 1': 'القسم الأول',
      'قسم 2': 'القسم الثاني',
      'قسم 3': 'القسم الثالث',
      'قسم 4': 'القسم الرابع',
      'قسم 5': 'القسم الخامس',
      'قسم 6': 'القسم السادس',
      'قسم 7': 'القسم السابع',
      'قسم 8': 'القسم الثامن',
      'قسم 9': 'القسم التاسع',
      'قسم 10': 'القسم العاشر',
    };

    return sectionNames[originalName.trim()] ?? originalName;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _recordsCubit),
        BlocProvider.value(value: _savesCubit),
        BlocProvider.value(value: _offlineCubit),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          helpMessage:
              'هنا يَظهَر الدرس مُقَسَّمَنْ إلى أقسامٍ حتى لا يكون طويلنْ، اختَر القسم الذي تريد الاستماع إليه',
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body:
            BlocBuilder<LessonRecordsCubit, ResultState<LessonRecordsResponse>>(
              builder: (context, state) {
                return state.when(
                  idle: () => const SizedBox(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  failure: (error) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Center(
                      child: Text(
                        "فشل في تحميل الأقسام،\n يرجى المحاولة لاحقاً..",
                        style: AppTextStyles.kMediumPrimary(context),
                      ),
                    ),
                  ),
                  success: (recordsData) {
                    if (recordsData.record.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            "لا يوجد أقسام مضافة لهذا الدرس",
                            style: AppTextStyles.kMediumPrimary(context),
                          ),
                        ),
                      );
                    }
                    return ListView(
                      children: [
                        SizedBox(height: 20.h),
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 0, 30.w, 0),
                          child: Text(
                            '${widget.lesson.title}:',
                            style: AppTextStyles.kMediumPrimary(context),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: recordsData.record.length,
                            itemBuilder: (context, index) {
                              final recordItem = recordsData.record[index];
                              final formattedName = _formatRecordName(
                                recordItem.name,
                              );

                              final updatedRecord = RecordModel(
                                id: recordItem.id,
                                name: recordItem.name,
                                url: widget.isOffline
                                    ? recordItem.url
                                    : UrlHelper.fixLocalhost(recordItem.url),
                              );

                              String currentTeacherName =
                                  widget.lesson.teacherName ?? 'غير محدد';

                              final recordLessonObject = Lesson(
                                id: widget.lesson.id,
                                title: formattedName,
                                teacherName: currentTeacherName,
                                teacherId: 1,
                                isSaved: false,
                                isQuizSolved: false,
                              );

                              return LessonCard(
                                lesson: recordLessonObject,
                                lessonNumber: (index + 1),
                                viewMenu: false,
                                route: AppRoutes.kStudentAudioPlayerScreen,
                                args: {
                                  'lessonName': formattedName,
                                  'record': updatedRecord,
                                  'lessonId': widget.lesson.id,
                                  'isOffline': widget.isOffline,
                                },
                                subjectName: widget.subjectName,
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
