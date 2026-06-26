import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';
import 'package:school_for_blind_app/presentation/widgets/lesson_card.dart';

class StudentSubjectDetailsScreen extends StatefulWidget {
  final String subjectName;

  const StudentSubjectDetailsScreen({super.key, required this.subjectName});

  @override
  State<StudentSubjectDetailsScreen> createState() =>
      _StudentSubjectDetailsScreenState();
}

class _StudentSubjectDetailsScreenState
    extends State<StudentSubjectDetailsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List lessons = [
    'قواعد المعرفة',
    'قوانين الفكر',
    'قواعد المعرفة',
    'قوانين الفكر',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(helpMessage: ''),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: SizedBox(
              width: 378.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 363.h,
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'اسم المدرس',
                                  style: TextStyle(fontSize: 36.sp),
                                ),
                                Text(
                                  'عدد الدروس',
                                  style: TextStyle(fontSize: 36.sp),
                                ),
                              ],
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
                                    AppRoutes.kStudentProfileScreen,
                                  ),
                                ),
                                PrimaryButton(
                                  title: 'المكتبة',
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
                            SizedBox(height: 10.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                PrimaryButton(
                                  title: 'قناة المدرس',
                                  width: 170,
                                  height: 62,
                                  fontSize: 40,
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.kStudentProfileScreen,
                                    );
                                  },
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
                      GlassEffect(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                    ],
                  ),
                  SearchLessonsBar(
                    isSearching: _isSearching,
                    controller: _searchController,
                    onSearchTap: () {
                      setState(() {
                        _isSearching = !_isSearching;
                        if (!_isSearching) {
                          _searchController.clear();
                          if (context.read<LessonsCubit>().state is Success) {
                            context.read<LessonsCubit>().searchLessons("");
                          }
                        }
                      });
                    },
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: lessons.length,
                    itemBuilder: (context, index) => LessonCard(
                      lessonName: lessons[index],
                      lessonNumber: (index + 1),
                      viewMenu: true,
                      route: AppRoutes.kStudentLessonRecordsScreen,
                      args: lessons[index],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SearchLessonsBar extends StatelessWidget {
  final bool isSearching;
  final TextEditingController controller;
  final VoidCallback onSearchTap;
  const SearchLessonsBar({
    super.key,
    required this.isSearching,
    required this.controller,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            child: isSearching
                ? TextField(
                    controller: controller,
                    autofocus: true,
                    onChanged: (value) {
                      if (context.read<LessonsCubit>().state is Failure) {
                        return;
                      }
                      context.read<LessonsCubit>().searchLessons(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'البحث عن درس',
                      //hintStyle: TextStyle(fontStyle: AppTextStyles.kMediumSecondary(context)),
                      border: InputBorder.none,
                    ),
                  )
                : Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'الدروس:',
                      style: AppTextStyles.kMediumPrimary(context),
                    ),
                  ),
          ),
        ),

        IconButton(
          onPressed: () {},
          icon: Icon(isSearching ? Icons.close : Icons.search, size: 34),
          color: isSearching
              ? Theme.of(context).colorScheme.onBackground
              : Theme.of(context).colorScheme.primary,
        ),
      ],
    );
  }
}
