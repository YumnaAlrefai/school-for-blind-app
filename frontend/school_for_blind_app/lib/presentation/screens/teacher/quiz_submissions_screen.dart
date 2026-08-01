import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/grade_student_answers_screen.dart';

class StudentSubmission {
  final int studentId;
  final String fullName;
  final String status; 
  final num totalScore;

  const StudentSubmission({
    required this.studentId,
    required this.fullName,
    required this.status,
    required this.totalScore,
  });

  bool get isGraded => status.toLowerCase() == 'graded';
}


class QuizSubmissionsScreen extends StatefulWidget {
  
  final int quizId;
  final String quizTitle;

  
  final bool isExam;

  const QuizSubmissionsScreen({
    super.key,
    required this.quizId,
    this.quizTitle = '',
    this.isExam = false,
  });

  @override
  State<QuizSubmissionsScreen> createState() => _QuizSubmissionsScreenState();
}

class _QuizSubmissionsScreenState extends State<QuizSubmissionsScreen> {
  bool _loading = true;
  String? _error;
  List<StudentSubmission> _submissions = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final repo = getIt<TeacherRepo>();
    final result = widget.isExam
        ? await repo.getExamSubmissions(widget.quizId)
        : await repo.getQuizSubmissions(widget.quizId);

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final raw = (map['submissions'] is List)
            ? map['submissions'] as List
            : const [];

        final items = <StudentSubmission>[];
        for (final e in raw) {
          if (e is! Map) continue;
          final s = Map<String, dynamic>.from(e);
          final student =
              (s['student'] is Map) ? Map<String, dynamic>.from(s['student']) : {};

          items.add(StudentSubmission(
            studentId: int.tryParse('${s['student_id']}') ?? 0,
            fullName:
                (student['fullname'] ?? student['full_name'] ?? 'طالب')
                    .toString(),
            status: (s['status'] ?? '').toString(),
            totalScore: num.tryParse('${s['total_score']}') ?? 0,
          ));
        }

        setState(() {
          _submissions = items;
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          _loading = false;
          _error = 'تعذّر تحميل الحلول، حاول مجدداً';
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTopBar(),
                const SizedBox(height: 20),
                Expanded(child: _buildBody()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            widget.quizTitle.isNotEmpty ? '${widget.quizTitle}:' : 'حلول الطلاب',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: "Arabic Typesetting",
              fontWeight: FontWeight.w300,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.subdirectory_arrow_left,
              size: 30, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_error!,
                style: const TextStyle(color: Colors.white70, fontSize: 20)),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _load,
              child: const Text('إعادة المحاولة',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      );
    }

    if (_submissions.isEmpty) {
      return Center(
        child: Text(
          'لم يقدّم أي طالب بعد',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _submissions.length,
      itemBuilder: (context, i) => _buildStudentCard(_submissions[i]),
    );
  }

  Widget _buildStudentCard(StudentSubmission s) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () async {
        final graded = await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) => GradeStudentAnswersScreen(
              quizId: widget.quizId,
              studentId: s.studentId,
              studentName: s.fullName,
              isExam: widget.isExam,
            ),
          ),
        );
        if (graded == true && mounted) _load();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.30)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                s.fullName,
                style: const TextStyle(color: Colors.white, fontSize: 22),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (s.isGraded ? AppColors.kPrimaryColor : Colors.orangeAccent)
                    .withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                s.isGraded ? 'مصحّح' : 'بانتظار التصحيح',
                style: TextStyle(
                  color:
                      s.isGraded ? AppColors.kPrimaryColor : Colors.orangeAccent,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}