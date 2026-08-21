import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/theme_listener.dart';

import 'package:parent_project/features/reports/data/datasource/reports_remote_datasource.dart';
import 'package:parent_project/features/reports/data/repositories/reports_repository.dart';
import 'package:parent_project/features/reports/logic/cubit/reports_cubit.dart';
import 'package:parent_project/features/reports/logic/cubit/reports_state.dart';

import 'package:parent_project/Widget/app_colors.dart';

class MonthlyTab1 extends StatefulWidget {
  const MonthlyTab1({super.key});

  @override
  State<MonthlyTab1> createState() => MonthlyTab1State();
}

class MonthlyTab1State extends State<MonthlyTab1> {
  late final ReportsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ReportsCubit(ReportsRepository(ReportsRemoteDataSource()))
      ..fetchMonthlyReports();
  }

  Future<void> refresh() => _cubit.fetchMonthlyReports();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: const _MonthlyTab1View(),
    );
  }
}

class _MonthlyTab1View extends StatelessWidget {
  const _MonthlyTab1View();

  @override
  Widget build(BuildContext context) {
    return ThemeListener(
      builder: (context) =>  BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading || state is ReportsInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ReportsFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.overlay70, fontSize: 30),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () =>
                      context.read<ReportsCubit>().fetchMonthlyReports(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final response = (state as MonthlyReportsSuccess).response;

        if (response.data.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'لا يوجد تقرير شهري متاح',
                style: TextStyle(color: AppColors.overlay70, fontSize: 30),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final student in response.data) ...[
              _MonthlyReportCard(
                year: student.reportData.year.toString(),
                month: student.reportData.month.toString(),
                neglectedExams: student.reportData.neglectedExams.toString(),
                neglectedQuizzes:
                    student.reportData.neglectedQuizzes.toString(),
                attendancePercentage:
                    '${student.reportData.attendancePercentage}%',
                solvedQuizzesCount:
                    student.reportData.solvedQuizzesCount.toString(),
                weakSubjects: student.reportData.weakSubjects.isEmpty
                    ? 'لا يوجد'
                    : student.reportData.weakSubjects.join(' - '),
                studentName: student.studentName,
              ),
              const SizedBox(height: 20),
            ],
          ],
        );
      },),
    );
  }
}


class _MonthlyReportCard extends StatelessWidget {
  final String year;
  final String month;
  final String neglectedExams;
  final String neglectedQuizzes;
  final String attendancePercentage;
  final String solvedQuizzesCount;
  final String weakSubjects;
  final String studentName;

  const _MonthlyReportCard({
    required this.year,
    required this.month,
    required this.neglectedExams,
    required this.neglectedQuizzes,
    required this.attendancePercentage,
    required this.solvedQuizzesCount,
    required this.weakSubjects,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تقرير شهر $month سنة $year للطالب $studentName :',
            textAlign: TextAlign.right,
            style: TextStyle(color: AppColors.textPrimary, fontSize: 32, height: 1.5),
          ),
          const SizedBox(height: 14),
          Text('نسبة الحضور: $attendancePercentage', style: TextStyle(color: AppColors.overlay70, fontSize: 32)),
          const SizedBox(height: 10),
          Text('عدد الكويزات المحلولة خلال الشهر: $solvedQuizzesCount', style: TextStyle(color: AppColors.overlay70, fontSize: 32)),
          const SizedBox(height: 10),
          Text('المواد الضعيف بها الطالب: $weakSubjects', style: TextStyle(color: AppColors.overlay70, fontSize: 32)),
          Text('الاختبارات المهملة: $neglectedExams', style: TextStyle(color: AppColors.overlay70, fontSize: 32)),
          Text('الكويزات المهمَلة: $neglectedQuizzes', style: TextStyle(color: AppColors.overlay70, fontSize: 32)),
        ],
      ),
    );
  }
}