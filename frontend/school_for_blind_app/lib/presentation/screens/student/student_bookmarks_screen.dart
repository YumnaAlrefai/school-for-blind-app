import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_saved_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saved_exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saved_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saved_past_exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saved_quizzes_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/helpers/user_key_helper.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/exam.dart';
import 'package:school_for_blind_app/data/models/student/lesson.dart';
import 'package:school_for_blind_app/data/models/student/offline_lesson_model.dart';
import 'package:school_for_blind_app/data/models/student/saved_lesson.dart';
import 'package:school_for_blind_app/data/models/student/saved_past_exam.dart';
import 'package:school_for_blind_app/data/models/student/saved_quiz.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_tabs.dart';
import 'package:school_for_blind_app/presentation/widgets/student/library_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/secondary_tabs.dart';
import 'package:school_for_blind_app/presentation/widgets/student/small_button.dart';
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
  late final SavedQuizzesCubit _savedQuizzesCubit;
  late final SavedExamsCubit _savedExamsCubit;

  @override
  void initState() {
    super.initState();
    _savedLessonsCubit = getIt<SavedLessonsCubit>()..getSavedLessons();
    _savesCubit = getIt<SavesCubit>();
    _offlineSavedLessonsCubit = getIt<OfflineSavedLessonsCubit>();
    _offlineLessonsCubit = getIt<OfflineLessonsCubit>();
    _savedPastExamsCubit = getIt<SavedPastExamsCubit>()..getSavedPastExams();
    _savedQuizzesCubit = getIt<SavedQuizzesCubit>()..getSavedQuizzes();
    _savedExamsCubit = getIt<SavedExamsCubit>()..getSavedExams();
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
        ctx.read<SavedQuizzesCubit>().getSavedQuizzes();
        break;
      case 2:
        ctx.read<SavedExamsCubit>().getSavedExams();
        break;
      case 3:
        ctx.read<SavedPastExamsCubit>().getSavedPastExams();
        break;
    }
  }

  Future<void> _onRefresh(BuildContext ctx) async {
    _refreshActiveTab(ctx);
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
        BlocProvider.value(value: _savedQuizzesCubit),
        BlocProvider.value(value: _savedExamsCubit),
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
          BlocListener<SavesCubit, SavesState>(
            listenWhen: (previous, current) => current.maybeWhen(
              success: (id, type, isSaved) => !isSaved && type == "quiz",
              orElse: () => false,
            ),
            listener: (context, state) {
              _savedQuizzesCubit.getSavedQuizzes();
            },
          ),
          BlocListener<SavesCubit, SavesState>(
            listenWhen: (previous, current) => current.maybeWhen(
              success: (id, type, isSaved) => !isSaved && type == "Exam",
              orElse: () => false,
            ),
            listener: (context, state) {
              _savedExamsCubit.getSavedExams();
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
                        getIt<VoiceServices>().speak(
                          'شاشة المحفوظات، هنا يَظهَر كلُّ ما قمتَ بحفظه من دروس وكويزات واختبارات ودورات ليسهل عليك العودة إليها',
                        );
                      },
                    ),
                    SizedBox(width: 20.w),
                  ],
                ),
                backgroundColor: Theme.of(context).colorScheme.background,
                body: Column(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Padding(
                        padding: EdgeInsets.all(10.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTabs(
                              label: 'الدروس',
                              isSelected: _selectedTab == 0,
                              onPressed: () => _onTabChanged(childContext, 0),
                            ),
                            SizedBox(width: 10.w),
                            CustomTabs(
                              label: 'الكويزات',
                              isSelected: _selectedTab == 1,
                              onPressed: () => _onTabChanged(childContext, 1),
                            ),
                            SizedBox(width: 10.w),
                            CustomTabs(
                              label: 'الاختبارات',
                              isSelected: _selectedTab == 2,
                              onPressed: () => _onTabChanged(childContext, 2),
                            ),
                            SizedBox(width: 10.w),
                            CustomTabs(
                              label: 'الدورات',
                              isSelected: _selectedTab == 3,
                              onPressed: () => _onTabChanged(childContext, 3),
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
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () => _onRefresh(childContext),
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return SingleChildScrollView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    child: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minHeight: constraints.maxHeight,
                                      ),
                                      child: Align(
                                        alignment: Alignment.topCenter,
                                        child: SizedBox(
                                          width: 378.w,
                                          child: _buildTabContent(childContext),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
          idle: () => const SizedBox.shrink(),
          loading: () => Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: const Center(child: CircularProgressIndicator()),
          ),
          success: (savedList) {
            if (savedList.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Center(
                  child: Text(
                    "لا يوجد دروس محفوظة",
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final lessonItem = savedList[index];
                final fullLesson = Lesson(
                  id: lessonItem.id,
                  title: lessonItem.title,
                  teacherName: 'غير محدد',
                  teacherId: lessonItem.teacherId,
                  isSaved: true,
                  isQuizSolved: false,
                );

                return LibraryCard(
                  key: ValueKey(lessonItem.id),
                  number: (index + 1),
                  id: lessonItem.id,
                  title: lessonItem.title,
                  itemType: "lesson",
                  route: AppRoutes.kStudentLessonRecordsScreen,
                  args: {
                    'lesson': fullLesson,
                    'isOffline': false,
                    'subjectName': '',
                    'savesCubit': childCtx.read<SavesCubit>(),
                  },
                );
              },
            );
          },
          failure: (networkException) {
            getIt<VoiceServices>().speak(
              NetworkExceptions.getErrorMessage(networkException),
            );
            return Container();
          },
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
          idle: () => const SizedBox.shrink(),
          loading: () => Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: const Center(child: CircularProgressIndicator()),
          ),
          success: (savedList) {
            if (savedList.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Center(
                  child: Text(
                    "لا يوجد دروس محفوظة",
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
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
          failure: (networkException) {
            getIt<VoiceServices>().speak(
              NetworkExceptions.getErrorMessage(networkException),
            );
            return Container();
          },
        );
      },
    );
  }

  Widget _buildQuizzesList() {
    return BlocBuilder<SavedQuizzesCubit, ResultState<List<SavedQuiz>>>(
      bloc: _savedQuizzesCubit,
      builder: (context, state) {
        return state.when(
          idle: () => const SizedBox.shrink(),
          loading: () => Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: const Center(child: CircularProgressIndicator()),
          ),
          success: (savedList) {
            if (savedList.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Center(
                  child: Text(
                    "لا يوجد كويزات محفوظة",
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final quiz = savedList[index];
                return LibraryCard(
                  key: ValueKey(quiz.id),
                  number: index + 1,
                  id: quiz.id,
                  title: quiz.displayTitle,
                  itemType: 'quiz',
                  route: AppRoutes.kStudentQuizReviewScreen,
                  args: {'quizId': quiz.id, 'title': quiz.displayTitle},
                );
              },
            );
          },
          failure: (networkException) {
            getIt<VoiceServices>().speak(
              NetworkExceptions.getErrorMessage(networkException),
            );
            return Container();
          },
        );
      },
    );
  }

  Widget _buildTestsList() {
    return BlocBuilder<SavedExamsCubit, ResultState<List<Exam>>>(
      bloc: _savedExamsCubit,
      builder: (context, state) {
        return state.when(
          idle: () => const SizedBox.shrink(),
          loading: () => Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: const Center(child: CircularProgressIndicator()),
          ),
          success: (savedList) {
            if (savedList.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Center(
                  child: Text(
                    "لا يوجد اختبارات محفوظة",
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
              );
            }
            return ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: savedList.length,
              itemBuilder: (context, index) {
                final exam = savedList[index];
                return LibraryCard(
                  key: ValueKey(exam.id),
                  number: index + 1,
                  id: exam.id,
                  title: exam.title,
                  itemType: 'Exam',
                  route: AppRoutes.kStudentExamSolutionsScreen,
                  args: {'examId': exam.id, 'title': exam.title},
                );
              },
            );
          },
          failure: (networkException) {
            getIt<VoiceServices>().speak(
              NetworkExceptions.getErrorMessage(networkException),
            );
            return Container();
          },
        );
      },
    );
  }

  Widget _buildPastPapersList() {
    return BlocBuilder<SavedPastExamsCubit, ResultState<List<SavedPastExam>>>(
      bloc: _savedPastExamsCubit,
      builder: (context, state) {
        return state.when(
          idle: () => const SizedBox.shrink(),
          loading: () => Padding(
            padding: EdgeInsets.only(top: 40.h),
            child: const Center(child: CircularProgressIndicator()),
          ),
          success: (savedList) {
            if (savedList.isEmpty) {
              return Padding(
                padding: EdgeInsets.only(top: 40.h),
                child: Center(
                  child: Text(
                    "لا يوجد دورات محفوظة",
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
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
          failure: (networkException) {
            getIt<VoiceServices>().speak(
              NetworkExceptions.getErrorMessage(networkException),
            );
            return Container();
          },
        );
      },
    );
  }
}
