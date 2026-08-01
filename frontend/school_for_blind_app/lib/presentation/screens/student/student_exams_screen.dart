import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exam_status.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exams_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/services/exam_join_store.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/server_time_service.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/exam.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/exam_card.dart';

class StudentExamsScreen extends StatefulWidget {
  final int subjectId;

  const StudentExamsScreen({super.key, required this.subjectId});

  @override
  State<StudentExamsScreen> createState() => _StudentExamsScreenState();
}

class _StudentExamsScreenState extends State<StudentExamsScreen> {
  late final ExamsCubit _examsCubit;
  Timer? _statusRefreshTimer;

  @override
  void initState() {
    super.initState();
    _examsCubit = getIt<ExamsCubit>();
    _examsCubit.emitGetExams(widget.subjectId);
    _statusRefreshTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _statusRefreshTimer?.cancel();
    _examsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _examsCubit,
      child: Scaffold(
        appBar: const CustomAppBar(helpMessage: ''),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: RefreshIndicator(
          onRefresh: () async {
            _examsCubit.emitGetExams(widget.subjectId);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    width: 378.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          _buildExamsList(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

void _onExamTap(Exam exam, ExamStatus status) {
  switch (status) {
    case ExamStatus.ongoing:
      Navigator.pushNamed(
        context,
        AppRoutes.kStudentExamScreen,
        arguments: {
          'examId': exam.id,
          'totalQuestions': exam.numOfQuestions,
          'durationMinutes': exam.durationMinutes,
          'examDate': exam.examDate,
          'subjectId': exam.subjectId,
        },
      );
      break;
    case ExamStatus.upcoming:
    case ExamStatus.locked:
    case ExamStatus.ended:
    case ExamStatus.notScheduled:
      break; // الكارد أصلاً معطّل بصرياً، هاد سطر أمان إضافي بس
  }
}

Widget _buildExamsList() {
  return BlocBuilder<ExamsCubit, ResultState<ExamsResponse>>(
    builder: (context, state) {
      return state.when(
        idle: () => const SizedBox.shrink(),
        loading: () => Padding(
          padding: EdgeInsets.only(top: 240.h),
          child: const Center(child: CircularProgressIndicator()),
        ),
        success: (ExamsResponse response) {
          final exams = response.data;
          if (exams.isEmpty) {
            return Padding(
              padding: EdgeInsets.only(top: 240.h),
              child: Text(
                'لا يوجد اختبارات حالياً',
                style: AppTextStyles.kMediumPrimary(context),
              ),
            );
          }
          return FutureBuilder<Set<int>>(
            future: ExamJoinStore.loadJoinedIds(exams.map((e) => e.id).toList()),
            builder: (context, snapshot) {
              final joinedIds = snapshot.data ?? const <int>{};
              final now = ServerTimeService.instance.now();
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: exams.length,
                itemBuilder: (context, index) {
                  final exam = exams[index];
                  final status = exam.statusAt(
                    now,
                    alreadyJoined: joinedIds.contains(exam.id),
                  );
                  return ExamCard(
                    key: ValueKey(exam.id),
                    number: index + 1,
                    exam: exam,
                    status: status,
                    onTap: () => _onExamTap(exam, status),
                  );
                },
              );
            },
          );
        },
        failure: (networkException) {
          final errorMessage = NetworkExceptions.getErrorMessage(networkException);
          getIt<VoiceServices>().speak(errorMessage);
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [SizedBox(height: 200)],
          );
        },
      );
    },
  );
}
}
