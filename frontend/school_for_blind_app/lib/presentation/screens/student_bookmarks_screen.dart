import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/offline_lessons_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/offline_saved_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/saved_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/saved_past_exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/saves_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/helpers/user_key_helper.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/offline_lesson_model.dart';
import 'package:school_for_blind_app/data/models/saved_lesson.dart';
import 'package:school_for_blind_app/data/models/saved_past_exam.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_tabs.dart';
import 'package:school_for_blind_app/presentation/widgets/library_card.dart';
import 'package:school_for_blind_app/presentation/widgets/library_card_skeleton.dart';
import 'package:school_for_blind_app/presentation/widgets/secondary_tabs.dart';
import 'package:school_for_blind_app/presentation/widgets/small_button.dart';
import 'package:visibility_detector/visibility_detector.dart';

class StudentBookmarksScreen extends StatefulWidget {
  const StudentBookmarksScreen({super.key});

  @override
  State<StudentBookmarksScreen> createState() => _StudentBookmarksScreenState();
}

class _StudentBookmarksScreenState extends State<StudentBookmarksScreen> {
  int _selectedTab = 0;
  int _selectedSubTab = 0;

  late final SavedLessonsCubit _savedLessonsCubit;
  late final SavesCubit _savesCubit;
  late final OfflineSavedLessonsCubit _offlineSavedLessonsCubit;
  late final OfflineLessonsCubit _offlineLessonsCubit;
  late final SavedPastExamsCubit _savedPastExamsCubit;

  @override
  void initState() {
    super.initState();
    _savedLessonsCubit = getIt<SavedLessonsCubit>()..getSavedLessons();
    _savesCubit = getIt<SavesCubit>();
    _offlineSavedLessonsCubit = getIt<OfflineSavedLessonsCubit>();
    _offlineLessonsCubit = getIt<OfflineLessonsCubit>();
    _savedPastExamsCubit = getIt<SavedPastExamsCubit>()..getSavedPastExams();
    _initOfflineUser();
  }

  Future<void> _initOfflineUser() async {
    final userKey = await UserKeyHelper.getCurrentUserKey();
    await _offlineLessonsCubit.setUser(userKey);
  }

  void _onTabChanged(BuildContext ctx, int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
    });
    _refreshActiveTab(ctx);
  }

  void _onSubTabChanged(BuildContext ctx, int subTabIndex) {
    setState(() {
      _selectedSubTab = subTabIndex;
    });
    _refreshActiveTab(ctx);
  }

  void _refreshActiveTab(BuildContext ctx) {
    switch (_selectedTab) {
      case 0:
        if (_selectedSubTab == 0) {
          ctx.read<SavedLessonsCubit>().getSavedLessons();
        } else {
          ctx.read<OfflineSavedLessonsCubit>().getSavedLessons();
        }
        break;
      case 1:
        // ctx.read<SavedQuizzesCubit>().getSavedQuizzes();
        break;
      case 2:
        // TODO للاختبارات
        break;
      case 3:
        ctx.read<SavedPastExamsCubit>().getSavedPastExams();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _savedLessonsCubit),
        BlocProvider.value(value: _savesCubit),
        BlocProvider.value(value: _offlineSavedLessonsCubit),
        BlocProvider.value(value: _offlineLessonsCubit),
        BlocProvider.value(value: _savedPastExamsCubit),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<SavesCubit, SavesState>(
            listenWhen: (previous, current) => current.maybeWhen(
              success: (id, type, isSaved) => !isSaved && type == "lesson",
              orElse: () => false,
            ),
            listener: (context, state) {
              _savedLessonsCubit.getSavedLessons();
            },
          ),
          BlocListener<OfflineLessonsCubit, OfflineLessonsState>(
            listenWhen: (previous, current) =>
                current is OfflineLessonSaveToggled && !current.isSaved,
            listener: (context, state) {
              _offlineSavedLessonsCubit.getSavedLessons();
            },
          ),
          BlocListener<SavesCubit, SavesState>(
            listenWhen: (previous, current) => current.maybeWhen(
              success: (id, type, isSaved) => !isSaved && type == "PastExam",
              orElse: () => false,
            ),
            listener: (context, state) {
              _savedPastExamsCubit.getSavedPastExams();
            },
          ),
        ],
        child: Builder(
          builder: (childContext) {
            return VisibilityDetector(
              key: const Key('student_bookmarks_screen_key'),
              onVisibilityChanged: (visibilityInfo) {
                if (visibilityInfo.visibleFraction == 1.0) {
                  _refreshActiveTab(childContext);
                }
              },
              child: Scaffold(
                appBar: AppBar(
                  leadingWidth: 100.w,
                  toolbarHeight: 100,
                  backgroundColor: Theme.of(context).colorScheme.background,
                  title: Text(
                    ' المحفوظات',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 48,
                    ),
                  ),
                  actions: [
                    SmallButton(
                      icon: const Icon(Icons.question_mark_outlined),
                      onPressed: () {
                        getIt<VoiceServices>().speak('');
                      },
                    ),
                    SizedBox(width: 20.w),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SingleChildScrollView(
                      child: SizedBox(
                        width: 378.w,
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.all(10.w),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomTabs(
                                      label: 'الدروس',
                                      isSelected: _selectedTab == 0,
                                      onPressed: () =>
                                          _onTabChanged(childContext, 0),
                                    ),
                                    SizedBox(width: 10.w),
                                    CustomTabs(
                                      label: 'الكويزات',
                                      isSelected: _selectedTab == 1,
                                      onPressed: () =>
                                          _onTabChanged(childContext, 1),
                                    ),
                                    SizedBox(width: 10.w),
                                    CustomTabs(
                                      label: 'الاختبارات',
                                      isSelected: _selectedTab == 2,
                                      onPressed: () =>
                                          _onTabChanged(childContext, 2),
                                    ),
                                    SizedBox(width: 10.w),
                                    CustomTabs(
                                      label: 'الدورات',
                                      isSelected: _selectedTab == 3,
                                      onPressed: () =>
                                          _onTabChanged(childContext, 3),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10.h),
                            _selectedTab == 0
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SecondaryTabs(
                                        label: 'اونلاين',
                                        isSelected: _selectedSubTab == 0,
                                        onPressed: () =>
                                            _onSubTabChanged(childContext, 0),
                                      ),
                                      SizedBox(width: 15.w),
                                      SecondaryTabs(
                                        label: 'اوفلاين',
                                        isSelected: _selectedSubTab == 1,
                                        onPressed: () =>
                                            _onSubTabChanged(childContext, 1),
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            SizedBox(height: 30.h),
                            _buildTabContent(childContext),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabContent(BuildContext childCtx) {
    switch (_selectedTab) {
      case 0:
        return _selectedSubTab == 0
            ? _buildOnlineLessonsList(childCtx)
            : _buildOfflineLessonsList(childCtx);
      case 1:
        return _buildQuizzesList();
      case 2:
        return _buildTestsList();
      default:
        return _buildPastPapersList();
    }
  }

  Widget _buildOnlineLessonsList(BuildContext childCtx) {
    return BlocBuilder<SavedLessonsCubit, ResultState<List<SavedLesson>>>(
      bloc: childCtx.read<SavedLessonsCubit>(),
      builder: (context, state) {
        return state.when(
          idle: () => const Center(child: LibraryCardSkeleton()),
          loading: () => const Center(child: LibraryCardSkeleton()),
          success: (savedList) {
            if (savedList.isEmpty) {
              return Center(
                child: Text(
                  "لا يوجد دروس محفوظة",
                  style: AppTextStyles.kMediumPrimary(context),
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final lessonItem = savedList[index];

                return LibraryCard(
                  key: ValueKey(lessonItem.id),
                  number: (index + 1),
                  id: lessonItem.id,
                  title: lessonItem.title,
                  itemType: "lesson",
                  route: AppRoutes.kStudentLessonRecordsScreen,
                  args: {
                    'lesson': lessonItem,
                    'isOffline': false,
                    'subjectName': '',
                    'savesCubit': childCtx.read<SavesCubit>(),
                  },
                );
              },
            );
          },
          failure: (networkException) => Center(
            child: Text(
              "فشل تحميل المحفوظات",
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfflineLessonsList(BuildContext childCtx) {
    return BlocBuilder<
      OfflineSavedLessonsCubit,
      ResultState<List<OfflineLessonModel>>
    >(
      bloc: childCtx.read<OfflineSavedLessonsCubit>(),
      builder: (context, state) {
        return state.when(
          idle: () => const Center(child: LibraryCardSkeleton()),
          loading: () => const Center(child: LibraryCardSkeleton()),
          success: (savedList) {
            if (savedList.isEmpty) {
              return Center(
                child: Text(
                  "لا يوجد دروس محفوظة",
                  style: AppTextStyles.kMediumPrimary(context),
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final lessonItem = savedList[index];

                return LibraryCard(
                  key: ValueKey(lessonItem.id),
                  number: (index + 1),
                  id: lessonItem.id,
                  title: lessonItem.title,
                  itemType: "lesson",
                  route: AppRoutes.kStudentLessonRecordsScreen,
                  isOffline: true,
                  args: {
                    'lesson': lessonItem,
                    'isOffline': true,
                    'subjectName': '',
                  },
                );
              },
            );
          },
          failure: (networkException) => Center(
            child: Text(
              "فشل تحميل المحفوظات",
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
        );
      },
    );
  }

  Widget _buildQuizzesList() => Container();
  Widget _buildTestsList() => Container();
  Widget _buildPastPapersList() {
    return BlocBuilder<SavedPastExamsCubit, ResultState<List<SavedPastExam>>>(
      bloc: _savedPastExamsCubit,
      builder: (context, state) {
        return state.when(
          idle: () => const Center(child: LibraryCardSkeleton()),
          loading: () => const Center(child: LibraryCardSkeleton()),
          success: (savedList) {
            if (savedList.isEmpty) {
              return Center(
                child: Text(
                  "لا يوجد دورات محفوظة",
                  style: AppTextStyles.kMediumPrimary(context),
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final examItem = savedList[index];
                return LibraryCard(
                  key: ValueKey(examItem.id),
                  number: index + 1,
                  id: examItem.id,
                  title: examItem.title,
                  itemType: 'PastExam',
                  route: AppRoutes.kStudentPastExamSolutionsScreen,
                  args: {'examId': examItem.id, 'title': examItem.title},
                );
              },
            );
          },
          failure: (networkException) => Center(
            child: Text(
              "فشل تحميل المحفوظات",
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
        );
      },
    );
  }
}
