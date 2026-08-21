import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/subject_icon.dart';
import 'package:parent_project/Widget/theme_listener.dart';

import 'package:parent_project/features/reports/data/datasource/reports_remote_datasource.dart';
import 'package:parent_project/features/reports/data/repositories/reports_repository.dart';
import 'package:parent_project/features/reports/logic/cubit/reports_cubit.dart';
import 'package:parent_project/features/reports/logic/cubit/reports_state.dart';
import 'package:parent_project/features/reports/data/models/subject_yearly_model.dart';

class YearlyTab1 extends StatefulWidget {
  final SubjectIcon Function(String subjectName) iconResolver;
  final void Function(int studentId, int subjectId, String subjectName) onSubjectTap;

  const YearlyTab1({
    super.key,
    required this.iconResolver,
    required this.onSubjectTap,
  });

  @override
  State<YearlyTab1> createState() => YearlyTab1State();
}

class YearlyTab1State extends State<YearlyTab1> {
  late final ReportsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = ReportsCubit(ReportsRepository(ReportsRemoteDataSource()))
      ..fetchYearlyReports();
  }

  Future<void> refresh() => _cubit.fetchYearlyReports();

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: _YearlyTab1View(
        iconResolver: widget.iconResolver,
        onSubjectTap: widget.onSubjectTap,
      ),
    );
  }
}

class _YearlyTab1View extends StatelessWidget {
  final SubjectIcon Function(String subjectName) iconResolver;
  final void Function(int studentId, int subjectId, String subjectName) onSubjectTap;

  const _YearlyTab1View({
    required this.iconResolver,
    required this.onSubjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeListener(
      builder: (context) => BlocBuilder<ReportsCubit, ReportsState>(
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
                      context.read<ReportsCubit>().fetchYearlyReports(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final response = (state as YearlyReportsSuccess).response;

        if (response.data.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'لا يوجد تقرير سنوي متاح',
                style: TextStyle(color: AppColors.overlay70, fontSize: 30),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final student in response.data) ...[
              _StudentYearlySection(
                studentId: student.studentId,
                studentName: student.studentName,
                finalScore:
                    '${student.reportData.totalStudentScore}/${student.reportData.totalMaxScore}',
                subjects: student.subjects,
                iconResolver: iconResolver,
                onSubjectTap: onSubjectTap,
              ),
              const SizedBox(height: 35),
            ],
          ],
        );
      },),
    );
  }
}


class _StudentYearlySection extends StatelessWidget {
  final int studentId;
  final String studentName;
  final String finalScore;
  final List<SubjectYearlyModel> subjects;
  final SubjectIcon Function(String subjectName) iconResolver;
  final void Function(int studentId, int subjectId, String subjectName) onSubjectTap;

  const _StudentYearlySection({
    required this.studentId,
    required this.studentName,
    required this.finalScore,
    required this.subjects,
    required this.iconResolver,
    required this.onSubjectTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('علامات المواد للطالب $studentName:', style: TextStyle(color: AppColors.textPrimary, fontSize: 35)),

        const SizedBox(height: 20),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: subjects.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final subject = subjects[index];
              return _SubjectGlassCard(
                subjectIcon: iconResolver(subject.name),
                label: subject.name,
                onTap: () => onSubjectTap(studentId, subject.id, subject.name),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        _AverageCard(finalScore: finalScore),
      ],
    );
  }
}


class _SubjectGlassCard extends StatelessWidget {
  final SubjectIcon subjectIcon;
  final String label;
  final VoidCallback onTap;

  const _SubjectGlassCard({required this.subjectIcon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130,
        width: 130,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.subjectCardTint,
          borderRadius: BorderRadius.circular(10),
          border: Border(
            top: BorderSide(color: AppColors.subjectCardBorder, width: 1.1),
            bottom: BorderSide(color: AppColors.subjectCardBorder, width: 1.1),
            left: BorderSide(color: AppColors.subjectCardBorder, width: 0.5),
            right: BorderSide(color: AppColors.subjectCardBorder, width: 0.5),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            subjectIcon.build(color: AppColors.accentGreen),
            const SizedBox(height: 8),
            Text(label, textAlign: TextAlign.center, style: TextStyle(color: AppColors.textPrimary, fontSize: 28)),
          ],
        ),
      ),
    );
  }
}

class _AverageCard extends StatelessWidget {
  final String finalScore;

  const _AverageCard({required this.finalScore});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 105,
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.accentGreen, const Color(0xFF628500)],
        ),
      ),
      child: Column(
        children: [
          const Text('المعدل النهائي:', style: TextStyle(color: Colors.white, fontSize: 35, fontWeight: FontWeight.w500)),
          const SizedBox(height: 1),
          Text(finalScore, style: const TextStyle(color: Colors.white, fontSize: 30)),
        ],
      ),
    );
  }
}