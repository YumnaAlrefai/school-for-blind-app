import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exam_detail_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/announcement_model.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';

class StudentExamScheduleScreen extends StatelessWidget {
  final int examId;

  const StudentExamScheduleScreen({Key? key, required this.examId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ExamDetailCubit>()..getExamDetail(examId),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: const CustomAppBar(
          helpMessage:
              'هذه شاشة عرض برنامج الامتحانات أو المذاكرات، سيَظهَر لك الجدول بشكلِ أعمدةٍ تمثل اليوم والتاريخ، المادة، والتوقيت، والأسطر هي الأيام',
        ),
        body: SafeArea(
          child: BlocBuilder<ExamDetailCubit, ResultState<ExamDetailResponse>>(
            builder: (context, state) {
              return state.when(
                idle: () => const SizedBox.shrink(),
                loading: () => Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                success: (data) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.h,
                          horizontal: 27.w,
                        ),
                        child: Text(
                          '${data.title}:',
                          style: AppTextStyles.kMediumPrimary(context),
                        ),
                      ),
                      Expanded(
                        child: _buildExamTable(data.examProgram, context),
                      ),
                    ],
                  );
                },
                failure: (networkException) {
                  getIt<VoiceServices>().speak(
                    NetworkExceptions.getErrorMessage(networkException),
                  );
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ExamDetailCubit>().getExamDetail(examId);
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: const [SizedBox(height: 200)],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildExamTable(ExamProgramData? examProgram, BuildContext context) {
    if (examProgram == null || examProgram.rows.isEmpty) {
      return Center(
        child: Text(
          'لا توجد تفاصيل متاحة لجدول الامتحان.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 24.sp,
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.background,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onRefresh: () async {},
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(180.w),
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  children: examProgram.columns.map((columnTitle) {
                    return _buildHeaderCell(columnTitle, context);
                  }).toList(),
                ),

                ...examProgram.rows.map((row) {
                  return TableRow(
                    children: [
                      _buildContentCell(row.date, context),
                      _buildContentCell(row.subject, context),
                      _buildContentCell(row.time, context),
                    ],
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String title, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 6.w),
      alignment: Alignment.center,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 36.sp,
        ),
      ),
    );
  }

  Widget _buildContentCell(String text, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 6.w),
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.background,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 36.sp,
        ),
      ),
    );
  }
}
