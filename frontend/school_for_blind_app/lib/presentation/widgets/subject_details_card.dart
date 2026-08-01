import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/subject_progress_cubit.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/lesson.dart';
import 'package:school_for_blind_app/data/models/subject_progress.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';

class SubjectDetailsCard extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const SubjectDetailsCard({
    super.key,
    required this.subjectName,
    required this.subjectId,
  });

  @override
  State<SubjectDetailsCard> createState() => _SubjectDetailsCardState();
}

class _SubjectDetailsCardState extends State<SubjectDetailsCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 430.h,
          width: 378.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onBackground,
              width: 0.2.w,
            ),
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.subjectName,
                style: AppTextStyles.kBigPrimary(context),
              ),
              BlocBuilder<LessonsCubit, ResultState<dynamic>>(
                builder: (context, lessonsState) {
                  String teacherName = 'جاري التحميل...';

                  lessonsState.maybeWhen(
                    success: (data) {
                      if (data is SubjectLessonsResponse &&
                          data.lessons.isNotEmpty) {
                        teacherName = data.lessons.first.teacherName;
                      } else if (data is List<Lesson> && data.isNotEmpty) {
                        teacherName = data.first.teacherName;
                      }
                    },
                    orElse: () {},
                  );

                  return BlocBuilder<
                    SubjectProgressCubit,
                    ResultState<SubjectProgress>
                  >(
                    builder: (context, state) {
                      return state.when(
                        idle: () => _buildHeaderRow(teacherName, '0 / 0'),
                        loading: () => _buildHeaderRow(teacherName, '0 / 0'),
                        success: (progressData) => _buildHeaderRow(
                          teacherName,
                          progressData.progressText,
                        ),
                        failure: (error) =>
                            _buildHeaderRow('غير معروف', '0 / 0'),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                    title: 'اختبارات',
                    width: 170,
                    height: 62,
                    fontSize: 40,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentExamsScreen,
                      arguments: widget.subjectId,
                    ),
                  ),
                  PrimaryButton(
                    title: 'المكتبة',
                    width: 170,
                    height: 62,
                    fontSize: 40,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentLibraryScreen,
                      arguments: widget.subjectId,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                    title: 'قناة المدرس',
                    width: 170,
                    height: 62,
                    fontSize: 40,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentProfileScreen,
                    ),
                  ),
                  PrimaryButton(
                    title: 'مجموعة المناقشة',
                    width: 170,
                    height: 62,
                    fontSize: 40,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentProfileScreen,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const GlassEffect(borderRadius: BorderRadius.all(Radius.circular(20))),
      ],
    );
  }

  Widget _buildHeaderRow(String teacher, String progress) {
    return Column(
      children: [
        Text(teacher, style: TextStyle(fontSize: 42.sp)),
        Text('عدد الدروس: $progress', style: TextStyle(fontSize: 42.sp)),
      ],
    );
  }
}
