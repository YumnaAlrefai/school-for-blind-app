import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/quiz_info_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/subject_progress_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/helpers/user_key_helper.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/models/student/lesson.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/offline_lesson_model.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/lesson_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/lesson_skeleton.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_tabs.dart';
import 'package:school_for_blind_app/presentation/widgets/student/search_lessons_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/subject_details_card.dart';

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
  late final OfflineLessonsCubit _offlineCubit;
  late final QuizInfoCubit _quizInfoCubit;
  late final SavesCubit _savesCubit;

  String? _userKey;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    _lessonsCubit = getIt<LessonsCubit>()
      ..emitGetSubjectLessonsResponse(widget.subjectId);

    _progressCubit = getIt<SubjectProgressCubit>()
      ..emitGetSubjectProgress(widget.subjectId);

    _quizInfoCubit = getIt<QuizInfoCubit>();
    _savesCubit = getIt<SavesCubit>();

    _offlineCubit = getIt<OfflineLessonsCubit>();

    _initUserAndOffline();

    _searchController.addListener(_onSearchChanged);
  }

  Future<void> _initUserAndOffline() async {
    _userKey = await UserKeyHelper.getCurrentUserKey();
    await _offlineCubit.setUser(_userKey!);
    _offlineCubit.loadOfflineLessons(subjectId: widget.subjectId);
  }

  void _performSearch(String query) {
    if (_selectedTab == 0) {
      _lessonsCubit.searchLessons(query);
    } else if (_userKey != null) {
      _offlineCubit.searchOfflineLessons(query, subjectId: widget.subjectId);
    }
  }

  void _onTabChanged(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;

      if (tabIndex == 0) {
        final isIdle = _lessonsCubit.state.maybeWhen(
          idle: () => true,
          orElse: () => false,
        );
        if (isIdle) {
          _lessonsCubit.emitGetSubjectLessonsResponse(widget.subjectId);
        }
      } else if (_userKey != null) {
        _offlineCubit.loadOfflineLessons(subjectId: widget.subjectId);
      }

      final currentQuery = _searchController.text.trim();
      _performSearch(currentQuery);
    });
  }

  void _onSearchChanged() {
    final query = _searchController.text.trim();
    _performSearch(query);
  }

  Future<void> _onRefresh() async {
    if (_selectedTab == 0) {
      _lessonsCubit.emitGetSubjectLessonsResponse(widget.subjectId);
    } else if (_userKey != null) {
      _offlineCubit.loadOfflineLessons(subjectId: widget.subjectId);
    }
    _progressCubit.emitGetSubjectProgress(widget.subjectId);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _lessonsCubit),
        BlocProvider.value(value: _progressCubit),
        BlocProvider.value(value: _offlineCubit),
        BlocProvider.value(value: _quizInfoCubit),
        BlocProvider.value(value: _savesCubit),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(
          helpMessage:
              'شاشة تفاصيل المادة، فيها الدروس المُسَجَّلة صوتياً، زر الانتقال لمكتبة الحلول، زر الانتقال لاختبارات المادة، الوصولُ السريعُ لقناة مدرس المادة او مجموعة مناقشة المادة، يمكنك تنزيل الدروس للاستماع لها  عند عدم الاتصال بالانترنت، يمكنك أَيضاً حفظ الدرس إلى المحفوظات، أو عرض الكويز الخاص به',
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RefreshIndicator(
              onRefresh: _onRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  width: 378.w,
                  child: Column(
                    children: [
                      SubjectDetailsCard(
                        subjectName: widget.subjectName,
                        subjectId: widget.subjectId,
                      ),
                      _buildSearchLessonsBar(),
                      SizedBox(height: 15.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTabs(
                            label: 'أونلاين',
                            isSelected: _selectedTab == 0,
                            onPressed: () => _onTabChanged(0),
                          ),
                          CustomTabs(
                            label: 'المحملة',
                            isSelected: _selectedTab == 1,
                            onPressed: () => _onTabChanged(1),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      _selectedTab == 0
                          ? _buildOnlineLessonsList()
                          : _buildOfflineLessonsList(),
                    ],
                  ),
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
            } else if (_userKey != null) {
              _offlineCubit.loadOfflineLessons(subjectId: widget.subjectId);
            }
          }
        });
      },
    );
  }

  BlocBuilder<LessonsCubit, ResultState<SubjectLessonsResponse>>
  _buildOnlineLessonsList() {
    return BlocBuilder<LessonsCubit, ResultState<SubjectLessonsResponse>>(
      builder: (context, state) {
        return state.when(
          idle: () => const Center(child: LessonsSkeleton()),
          loading: () => const Center(child: LessonsSkeleton()),

          success: (data) {
            final lessonsList = data.lessons;
            if (lessonsList.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    _searchController.text.isNotEmpty
                        ? "لا يوجد دروس مطابقة"
                        : "لا يوجد دروس في هذه المادة حالياً",
                    style: AppTextStyles.kMediumPrimary(context),
                    textAlign: TextAlign.center,
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
                  key: ValueKey(lesson.id),
                  subjectId: widget.subjectId,
                  subjectName: widget.subjectName,
                  lesson: lesson,
                  lessonNumber: (index + 1),
                  viewMenu: true,
                  route: AppRoutes.kStudentLessonRecordsScreen,
                  args: {
                    'lesson': lesson,
                    'isOffline': false,
                    'subjectName': widget.subjectName,
                  },
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
                child: Container(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildOfflineLessonsList() {
    return BlocBuilder<OfflineLessonsCubit, OfflineLessonsState>(
      builder: (context, state) {
        List<OfflineLessonModel> filteredLessons = [];

        if (state is OfflineLessonsLoaded) {
          filteredLessons = state.filteredOfflineLessons;
        } else {
          try {
            final cubit = context.read<OfflineLessonsCubit>();
            if (cubit.currentUserKey != null) {
              final all = cubit.offlineManager.getLessonsSync(
                cubit.currentUserKey!,
                subjectId: widget.subjectId,
              );
              filteredLessons = all;
            }
          } catch (_) {}
        }

        if (filteredLessons.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                _isSearching && _searchController.text.isNotEmpty
                    ? "لا يوجد دروس مطابقة"
                    : "لا توجد دروس محملة بعد",
                style: AppTextStyles.kMediumPrimary(context),
              ),
            ),
          );
        }

        return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: filteredLessons.length,
          itemBuilder: (context, index) {
            final offlineLesson = filteredLessons[index];
            final lesson = Lesson(
              id: offlineLesson.id,
              title: offlineLesson.title,
              teacherName: offlineLesson.teacherName,
              teacherId: 1,
              isSaved: offlineLesson.isSaved,
              isQuizSolved: false,
            );

            return LessonCard(
              key: ValueKey(offlineLesson.id),
              subjectId: widget.subjectId,
              subjectName: widget.subjectName,
              lesson: lesson,
              lessonNumber: (index + 1),
              viewMenu: true,
              route: AppRoutes.kStudentLessonRecordsScreen,
              args: {
                'subjectId': widget.subjectId,
                'subjectName': widget.subjectName,
                'lesson': lesson,
                'isOffline': true,
              },
              isOffline: true,
            );
          },
        );
      },
    );
  }
}
