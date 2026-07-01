import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/subject_progress_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/models/lesson.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/lesson_card.dart';
import 'package:school_for_blind_app/presentation/widgets/lesson_skeleton.dart';
import 'package:school_for_blind_app/presentation/widgets/online_offline_tabs.dart';
import 'package:school_for_blind_app/presentation/widgets/search_lessons_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/subject_details_card.dart';

class StudentSubjectDetailsScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const StudentSubjectDetailsScreen({
    super.key,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<StudentSubjectDetailsScreen> createState() =>
      _StudentSubjectDetailsScreenState();
}

class _StudentSubjectDetailsScreenState
    extends State<StudentSubjectDetailsScreen> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  late final LessonsCubit _lessonsCubit;
  late final SubjectProgressCubit _progressCubit;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _lessonsCubit = getIt<LessonsCubit>()
      ..emitGetSubjectLessonsResponse(widget.subjectId);
    _progressCubit = getIt<SubjectProgressCubit>()
      ..emitGetSubjectProgress(widget.subjectId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _lessonsCubit),
        BlocProvider.value(value: _progressCubit),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(helpMessage: ''),
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
                    SubjectDetailsCard(subjectName: widget.subjectName),
                    _buildSearchLessonsBar(),
                    SizedBox(height: 15.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OnlineOfflineTabs(
                          label: 'أونلاين',
                          isSelected: _selectedTab == 0,
                          onPressed: () => setState(() => _selectedTab = 0),
                        ),
                        OnlineOfflineTabs(
                          label: 'المحملة',
                          isSelected: _selectedTab == 1,
                          onPressed: () => setState(() => _selectedTab = 1),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    _selectedTab == 0
                        ? _buildOnlineLessonsList()
                        : //_buildOfflineLessonsList(),
                        Container()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SearchLessonsBar _buildSearchLessonsBar() {
    return SearchLessonsBar(
      isSearching: _isSearching,
      controller: _searchController,
      onSearchTap: () {
        setState(() {
          _isSearching = !_isSearching;
          if (!_isSearching) {
            _searchController.clear();
            if (_selectedTab == 0) {
              _lessonsCubit.searchLessons("");
            } else {
              //بحث الاوفلاين
            }
          }
        });
      },
    );
  }

  BlocBuilder<LessonsCubit, ResultState<SubjectLessonsResponse>> _buildOnlineLessonsList() {
    return BlocBuilder<LessonsCubit, ResultState<SubjectLessonsResponse>>(
      builder: (context, state) {
        return state.when(
          idle: () => const SizedBox(),
          loading: () => const Center(child: LessonsSkeleton()),
          success: (data) {
            final lessonsList = data.lessons;
            if (lessonsList.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    "لا يوجد دروس مطابقة",
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: lessonsList.length,
              itemBuilder: (context, index) {
                final lesson = lessonsList[index];
                return LessonCard(
                  lessonName: lesson.title,
                  lessonNumber: (index + 1),
                  viewMenu: true,
                  route: AppRoutes.kStudentLessonRecordsScreen,
                  args: [lesson],
                );
              },
            );
          },
          failure: (networkException) {
            getIt<VoiceServices>().speak(
              NetworkExceptions.getErrorMessage(networkException),
            );
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "فشل تحميل الدروس",
                  style: AppTextStyles.kMediumPrimary(context),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
