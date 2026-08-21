import 'package:flutter/material.dart';
import 'app_colors.dart';

class MonthlyTab extends StatelessWidget {
  const MonthlyTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _MonthlyReportCard(
          year: '2026',
          month: '6',
          neglectedExams: '2',
          neglectedQuizzes: '25',
          attendancePercentage: '90%',
          solvedQuizzesCount: '30',
          weakSubjects: 'التاريخ - الجغرافيا',
          studentName: 'رغد',
        ),
        SizedBox(height: 20),
        _MonthlyReportCard(
          year: '2026',
          month: '7',
          neglectedExams: '2',
          neglectedQuizzes: '25',
          attendancePercentage: '50%',
          solvedQuizzesCount: '10',
          weakSubjects: 'الفلسفة',
          studentName: 'رغد',
        ),
      ],
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
            'تقرير شهر $month سنة $year للطالب/ة $studentName :',
            textAlign: TextAlign.right,
            style: const TextStyle(color: Colors.white, fontSize: 32, height: 1.5),
          ),
          const SizedBox(height: 14),
          Text('نسبة الحضور: $attendancePercentage', style: const TextStyle(color: Colors.white70, fontSize: 32)),
          const SizedBox(height: 10),
          Text('عدد الكويزات المحلولة خلال الشهر: $solvedQuizzesCount', style: const TextStyle(color: Colors.white70, fontSize: 32)),
          const SizedBox(height: 10),
          Text('المواد الضعيف بها الطالب: $weakSubjects', style: const TextStyle(color: Colors.white70, fontSize: 32)),
          Text('الاختبارات المهملة: $neglectedExams', style: const TextStyle(color: Colors.white70, fontSize: 32)),
          Text('الكويزات المهمَلة: $neglectedQuizzes', style: const TextStyle(color: Colors.white70, fontSize: 32)),
        ],
      ),
    );
  }
}