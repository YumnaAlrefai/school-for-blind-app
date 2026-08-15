import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exam_status.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exams_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/solved_quizzes_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/server_time_service.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/exam.dart';
import 'package:school_for_blind_app/data/models/student/solved_quiz.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_tabs.dart';
import 'package:school_for_blind_app/presentation/widgets/student/library_card.dart';

class StudentLibraryScreen extends StatefulWidget {
  final int subjectId;

  const StudentLibraryScreen({super.key, required this.subjectId});

  @override
  State<StudentLibraryScreen> createState() => _StudentLibraryScreenState();
}

class _StudentLibraryScreenState extends State<StudentLibraryScreen> {
  int _selectedTab = 0;
  late final PastExamsCubit _pastExamsCubit;
  late final SavesCubit _savesCubit;
  late final OfflineLessonsCubit _offlineLessonsCubit;
  late final ExamsCubit _examsCubit;
  late final SolvedQuizzesCubit _solvedQuizzesCubit;
  bool _quizzesFetched = false;
  bool _examsFetched = false;
  bool _pastExamsFetched = false;

  @override
  void initState() {
    super.initState();
    _pastExamsCubit = getIt<PastExamsCubit>();
    _savesCubit = getIt<SavesCubit>();
    _offlineLessonsCubit = getIt<OfflineLessonsCubit>();
    _examsCubit = getIt<ExamsCubit>();
    _solvedQuizzesCubit = getIt<SolvedQuizzesCubit>();
    _quizzesFetched = true;
    _solvedQuizzesCubit.getSolvedQuizzes();
  }

  @override
  void dispose() {
    _pastExamsCubit.close();
    _savesCubit.close();
    _offlineLessonsCubit.close();
    _examsCubit.close();
    _solvedQuizzesCubit.close();
    super.dispose();
  }

  void _onTabChanged(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
      if (tabIndex == 0) {
        if (!_quizzesFetched) {
          _quizzesFetched = true;
          _solvedQuizzesCubit.getSolvedQuizzes();
        }
      } else if (tabIndex == 1) {
        if (!_examsFetched) {
          _examsFetched = true;
          _examsCubit.emitGetExams(widget.subjectId);
        }
      } else {
        if (!_pastExamsFetched) {
          _pastExamsFetched = true;
          _pastExamsCubit.getPastExams(widget.subjectId);
        }
      }
    });
  }

  Future<void> _onRefresh() async {
    if (_selectedTab == 0) {
      _solvedQuizzesCubit.getSolvedQuizzes();
    } else if (_selectedTab == 1) {
      _examsCubit.emitGetExams(widget.subjectId);
    } else {
      _pastExamsCubit.getPastExams(widget.subjectId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _savesCubit),
        BlocProvider.value(value: _offlineLessonsCubit),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          helpMessage:
              'أنتَ الآنَ في مَكْتَبَةِ الحُلُولْ، تَحْتَوي هذه الشّاشَةُ على ثلاثةِ أَقْسامٍ للأنْشِطَةِ المَحْلولَةِ سابِقَنْ: الكويزاتُ، الاِخْتِباراتُ، والدَّوْراتُ، يُمكنُكَ التَّنَقُّلُ بَيْنَ الأَقْسامِ وَاخْتِيارُ أيِّ نَشاطٍ لِعَرْضِ حَلِّهِ بالتَّفْصيلْ.',
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
                      label: 'الكويزات',
                      isSelected: _selectedTab == 0,
                      onPressed: () => _onTabChanged(0),
                    ),
                    SizedBox(width: 10.w),
                    CustomTabs(
                      label: 'الاختبارات',
                      isSelected: _selectedTab == 1,
                      onPressed: () => _onTabChanged(1),
                    ),
                    SizedBox(width: 10.w),
                    CustomTabs(
                      label: 'الدورات',
                      isSelected: _selectedTab == 2,
                      onPressed: () => _onTabChanged(2),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: _onRefresh,
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: constraints.maxHeight,
                              ),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: 378.w,
                                  child: _selectedTab == 0
                                      ? _buildQuizzesList()
                                      : (_selectedTab == 1
                                            ? _buildTestsList()
                                            : _buildPastPapersList()),
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
  }

  Widget _buildQuizzesList() {
    return BlocProvider.value(
      value: _solvedQuizzesCubit,
      child: BlocBuilder<SolvedQuizzesCubit, ResultState<List<SolvedQuiz>>>(
        builder: (context, state) {
          return state.when(
            idle: () => const SizedBox.shrink(),
            loading: () => Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: const Center(child: CircularProgressIndicator()),
            ),
            success: (quizzes) {
              if (quizzes.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    'لا يوجد كويزات محلولة',
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: quizzes.length,
                itemBuilder: (context, index) {
                  final quiz = quizzes[index];
                  return LibraryCard(
                    key: ValueKey(quiz.submissionId),
                    number: index + 1,
                    id: quiz.quizId,
                    title: quiz.quizTitle,
                    itemType: 'quiz',
                    initialIsSaved: quiz.isFavorited,
                    route: AppRoutes.kStudentQuizReviewScreen,
                    args: {'quizId': quiz.quizId, 'title': quiz.quizTitle},
                  );
                },
              );
            },
            failure: (e) {
              getIt<VoiceServices>().speak(
                NetworkExceptions.getErrorMessage(e),
              );
              return Container();
            },
          );
        },
      ),
    );
  }

  Widget _buildTestsList() {
    return BlocProvider.value(
      value: _examsCubit,
      child: BlocBuilder<ExamsCubit, ResultState<ExamsResponse>>(
        builder: (context, state) {
          return state.when(
            idle: () => const SizedBox.shrink(),
            loading: () => Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: const Center(child: CircularProgressIndicator()),
            ),
            success: (ExamsResponse response) {
              final now = ServerTimeService.instance.now();
              final endedExams = response.data.where((exam) {
                return exam.statusAt(
                      now,
                      alreadyJoined: true,
                      alreadySubmitted: false,
                    ) ==
                    ExamStatus.ended;
              }).toList();

              if (endedExams.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    'لا يوجد اختبارات منتهية بعد',
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: endedExams.length,
                itemBuilder: (context, index) {
                  final exam = endedExams[index];
                  return LibraryCard(
                    key: ValueKey(exam.id),
                    number: index + 1,
                    id: exam.id,
                    title: exam.title,
                    itemType: 'Exam',
                    initialIsSaved: exam.isFavorited,
                    route: AppRoutes.kStudentExamSolutionsScreen,
                    args: {'examId': exam.id, 'title': exam.title},
                  );
                },
              );
            },
            failure: (e) {
              getIt<VoiceServices>().speak(
                NetworkExceptions.getErrorMessage(e),
              );
              return Container();
            },
          );
        },
      ),
    );
  }

  _buildPastPapersList() {
    return BlocProvider.value(
      value: _pastExamsCubit,
      child: BlocBuilder<PastExamsCubit, PastExamsState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => Padding(
              padding: EdgeInsets.only(top: 40.h),
              child: const Center(child: CircularProgressIndicator()),
            ),
            success: (exams) {
              if (exams.isEmpty) {
                return Padding(
                  padding: EdgeInsets.only(top: 40.h),
                  child: Text(
                    'لا يوجد دورات',
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  return LibraryCard(
                    key: ValueKey(exam.id),
                    number: index + 1,
                    id: exam.id,
                    title: exam.title,
                    itemType: 'PastExam',
                    initialIsSaved: exam.isSaved,
                    route: AppRoutes.kStudentPastExamSolutionsScreen,
                    args: {'examId': exam.id, 'title': exam.title},
                  );
                },
              );
            },
            failure: (e) {
              getIt<VoiceServices>().speak(
                NetworkExceptions.getErrorMessage(e),
              );
              return Container();
            },
          );
        },
      ),
    );
  }
}
