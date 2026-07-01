import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/lesson_records_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/lesson.dart';
import 'package:school_for_blind_app/data/models/record_model.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/lesson_card.dart';

class StudentLessonRecordsScreen extends StatefulWidget {
  final Lesson lesson;
  const StudentLessonRecordsScreen({super.key, required this.lesson});

  @override
  State<StudentLessonRecordsScreen> createState() =>
      _StudentLessonRecordsScreenState();
}

class _StudentLessonRecordsScreenState
    extends State<StudentLessonRecordsScreen> {
  late final LessonRecordsCubit _recordsCubit;

  @override
  void initState() {
    super.initState();
    _recordsCubit = getIt<LessonRecordsCubit>()
      ..emitGetLessonRecords(widget.lesson.id);
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
    return BlocProvider(
      create: (context) => _recordsCubit,
      child: Scaffold(
        appBar: const CustomAppBar(helpMessage: ''),
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
                          padding: EdgeInsets.all(20.0),
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
                              return LessonCard(
                                lessonName: formattedName,
                                lessonNumber: (index + 1),
                                viewMenu: false,
                                route: AppRoutes.kStudentAudioPlayerScreen,
                                args: {
                                  'lessonName': formattedName,
                                  'record': recordItem,
                                },
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
