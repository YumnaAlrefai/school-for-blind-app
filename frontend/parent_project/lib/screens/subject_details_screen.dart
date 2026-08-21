import 'package:flutter/material.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/generic_tabs.dart'; 

enum SubjectTab { quizzes, exams }

class SubjectDetailsScreen extends StatefulWidget {
  final String subjectName;
  const SubjectDetailsScreen({super.key, required this.subjectName});

  @override
  State<SubjectDetailsScreen> createState() => _SubjectDetailsScreenState();
}

class _SubjectDetailsScreenState extends State<SubjectDetailsScreen> {
  SubjectTab _selectedTab = SubjectTab.quizzes;

  final List<Map<String, dynamic>> _dummyQuizzes = const [
    {
      'title': 'المعرفة ومصادرها',
      'student_score': 85,
      'teacher_assigned_mark': 85,
      'graded_at': '2026-07-17 14:49:34',
    },
    {
      'title': 'كويز الوجود والعدم',
      'student_score': 70,
      'teacher_assigned_mark': 90,
      'graded_at': '2026-07-10 11:20:00',
    },
  ];

  final List<Map<String, dynamic>> _dummyExams = const [
    {
      'title': 'مذاكرة الفلسفة',
      'max_score': 200,
      'student_score': '180.00',
      'graded_at': '2026-07-17 14:49:34',
    },
  ];

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
                child: _selectedTab == SubjectTab.quizzes
                    ? _buildQuizzesTab()
                    : _buildExamsTab(),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        border: const Border(
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

  Widget _buildQuizzesTab() {
    if (_dummyQuizzes.isEmpty) {
      return _buildEmptyState('لا يوجد كويزات بعد');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      itemCount: _dummyQuizzes.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final q = _dummyQuizzes[index];
        return _buildResultCard(
          title: q['title'] as String,
          scoreText: '${q['student_score']} / ${q['teacher_assigned_mark']}',
          dateText: (q['graded_at'] as String).split(' ').first,
        );
      },
    );
  }

  Widget _buildExamsTab() {
    if (_dummyExams.isEmpty) {
      return _buildEmptyState('لا يوجد اختبارات بعد');
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
      itemCount: _dummyExams.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final e = _dummyExams[index];
        return _buildResultCard(
          title: e['title'] as String,
          scoreText: '${e['student_score']} / ${e['max_score']}',
          dateText: (e['graded_at'] as String).split(' ').first,
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Text(message, style: const TextStyle(color: Colors.white54, fontSize: 26)),
    );
  }

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
              Icon(Icons.star_rounded, color: AppColors.accentGreen, size: 25),
              const SizedBox(width: 6),
              Text('العلامة: $scoreText', style: const TextStyle(color: Colors.white, fontSize: 26)),
            ],
          ),
        ],
      ),
    );
  }
}