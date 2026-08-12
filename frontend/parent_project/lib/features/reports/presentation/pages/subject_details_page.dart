import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/generic_tabs.dart'; // عدّل المسار حسب مكانها الفعلي عندك

import 'package:parent_project/features/reports/data/datasource/reports_remote_datasource.dart';
import 'package:parent_project/features/reports/data/repositories/reports_repository.dart';
import 'package:parent_project/features/reports/logic/cubit/subject_details_cubit.dart';
import 'package:parent_project/features/reports/logic/cubit/subject_details_state.dart';

enum SubjectTab { quizzes, exams }

class SubjectDetailsPage extends StatelessWidget {
  final int studentId;
  final int subjectId;
  final String subjectName;

  const SubjectDetailsPage({
    super.key,
    required this.studentId,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SubjectDetailsCubit(
        ReportsRepository(ReportsRemoteDataSource()),
      )..fetchSubjectDetails(studentId: studentId, subjectId: subjectId),
      child: _SubjectDetailsPageView(
        studentId: studentId,
        subjectId: subjectId,
        subjectName: subjectName,
      ),
    );
  }
}

class _SubjectDetailsPageView extends StatefulWidget {
  final int studentId;
  final int subjectId;
  final String subjectName;

  const _SubjectDetailsPageView({
    required this.studentId,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<_SubjectDetailsPageView> createState() => _SubjectDetailsViewState();
}

class _SubjectDetailsViewState extends State<_SubjectDetailsPageView> {
  SubjectTab _selectedTab = SubjectTab.quizzes;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 15),

              // ------- التبويبات -------
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: GenericTabs<SubjectTab>(
                  items: const [
                    TabItem(label: 'الكويزات', value: SubjectTab.quizzes),
                    TabItem(label: 'الاختبارات', value: SubjectTab.exams),
                  ],
                  selectedValue: _selectedTab,
                  onChanged: (tab) => setState(() => _selectedTab = tab),
                  spacing: 15,
                  expandTabs: true,
                ),
              ),
              const SizedBox(height: 10),

              Expanded(
                child: BlocBuilder<SubjectDetailsCubit, SubjectDetailsState>(
                  builder: (context, state) {
                    if (state is SubjectDetailsLoading ||
                        state is SubjectDetailsInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is SubjectDetailsFailure) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 26,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () => context
                                  .read<SubjectDetailsCubit>()
                                  .fetchSubjectDetails(
                                    studentId: widget.studentId,
                                    subjectId: widget.subjectId,
                                  ),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    final response = (state as SubjectDetailsSuccess).response;

                    return _selectedTab == SubjectTab.quizzes
                        ? _buildQuizzesTab(response.quizzes)
                        : _buildExamsTab(response.exams);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ------- الشريط العلوي: عنوان المادة يمين + سهم رجوع يسار -------
  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        border: Border(
          bottom: BorderSide(color: Colors.white12, width: 1),
          top: BorderSide(color: Colors.white12, width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                widget.subjectName,
                style: const TextStyle(color: Colors.white, fontSize: 40),
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.subdirectory_arrow_left_outlined, color: Colors.white, size: 34),
          ),
        ],
      ),
    );
  }

  // ------- تبويب الكويزات -------
  Widget _buildQuizzesTab(List quizzes) {
    if (quizzes.isEmpty) {
      return _buildEmptyState('لا يوجد كويزات بعد');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      itemCount: quizzes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final q = quizzes[index];
        return _buildResultCard(
          title: q.title,
          scoreText: '${q.studentScore} / ${q.teacherAssignedMark}',
          dateText: q.gradedAt.split(' ').first,
        );
      },
    );
  }

  // ------- تبويب الاختبارات -------
  Widget _buildExamsTab(List exams) {
    if (exams.isEmpty) {
      return _buildEmptyState('لا يوجد اختبارات بعد');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      itemCount: exams.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final e = exams[index];
        return _buildResultCard(
          title: e.title,
          scoreText: '${e.studentScore} / ${e.maxScore}',
          dateText: e.gradedAt.split(' ').first,
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.white54, fontSize: 26)),
    );
  }

  // ------- بطاقة نتيجة واحدة (كويز أو اختبار) -------
  Widget _buildResultCard({
    required String title,
    required String scoreText,
    required String dateText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 32)),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.star_rounded, color: AppColors.accentGreen, size: 25),
              const SizedBox(width: 6),
              Text('العلامة: $scoreText', style: const TextStyle(color: Colors.white, fontSize: 26)),
            ],
          ),
        ],
      ),
    );
  }
}