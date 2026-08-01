import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exams_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
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
  bool _pastExamsFetched = false;

  @override
  void initState() {
    super.initState();
    _pastExamsCubit = getIt<PastExamsCubit>();
    _savesCubit = getIt<SavesCubit>();
    _offlineLessonsCubit = getIt<OfflineLessonsCubit>();
  }

  @override
  void dispose() {
    _pastExamsCubit.close();
    _savesCubit.close();
    _offlineLessonsCubit.close();
    super.dispose();
  }

  void _onTabChanged(int tabIndex) {
    setState(() {
      _selectedTab = tabIndex;
      if (tabIndex == 0) {
        //TODO
      } else if (tabIndex == 1) {
        //TODO
      } else {
        if (!_pastExamsFetched) {
          _pastExamsFetched = true;
          _pastExamsCubit.getPastExams(widget.subjectId);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _savesCubit),
        BlocProvider.value(value: _offlineLessonsCubit),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(helpMessage: ''),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  width: 378.w,
                  child: Column(
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
                      _selectedTab == 0
                          ? _buildQuizzesList()
                          : (_selectedTab == 1
                                ? _buildTestsList()
                                : _buildPastPapersList()),
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

  _buildQuizzesList() {
    return Container();
  }

  _buildTestsList() {
    return Container();
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
