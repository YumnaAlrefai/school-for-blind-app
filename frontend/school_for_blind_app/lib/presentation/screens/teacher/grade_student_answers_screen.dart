import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

import '../../../data/repository/teacher_repo.dart';

class TextAnswerItem {
  final int answerId;
  final String questionText;
  final String studentAnswer;
  final num maxPoints;
  final num earnedPoints;
  final bool isGraded;
  final TextEditingController pointsController;

  TextAnswerItem({
    required this.answerId,
    required this.questionText,
    required this.studentAnswer,
    required this.maxPoints,
    required this.earnedPoints,
    required this.isGraded,
  }) : pointsController = TextEditingController(
         text: isGraded ? _clean(earnedPoints) : '',
       );

  static String _clean(num v) =>
      v == v.roundToDouble() ? v.toInt().toString() : v.toString();

  void dispose() => pointsController.dispose();
}

class GradeStudentAnswersScreen extends StatefulWidget {
  final int quizId;
  final int studentId;
  final String studentName;

  final bool isExam;

  const GradeStudentAnswersScreen({
    super.key,
    required this.quizId,
    required this.studentId,
    this.studentName = '',
    this.isExam = false,
  });

  @override
  State<GradeStudentAnswersScreen> createState() =>
      _GradeStudentAnswersScreenState();
}

class _GradeStudentAnswersScreenState extends State<GradeStudentAnswersScreen> {
  bool _loading = true;
  bool _saving = false;
  String? _error;

  num _currentScore = 0;
  List<TextAnswerItem> _answers = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final a in _answers) {
      a.dispose();
    }
    super.dispose();
  }

  static String _cleanNumber(dynamic v) {
    final d = double.tryParse('${v ?? ''}');
    if (d == null) return '${v ?? ''}';
    return d == d.roundToDouble() ? d.toInt().toString() : '$d';
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final repo = getIt<TeacherRepo>();
    final result = widget.isExam
        ? await repo.getExamPendingTextAnswers(widget.quizId, widget.studentId)
        : await repo.getPendingTextAnswers(widget.quizId, widget.studentId);

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final raw = (map['answers_to_grade'] is List)
            ? map['answers_to_grade'] as List
            : const [];

        final items = <TextAnswerItem>[];
        for (final e in raw) {
          if (e is! Map) continue;
          final a = Map<String, dynamic>.from(e);
          final q = (a['question'] is Map)
              ? Map<String, dynamic>.from(a['question'])
              : <String, dynamic>{};

          items.add(
            TextAnswerItem(
              answerId: int.tryParse('${a['id']}') ?? 0,
              questionText: (q['description'] ?? '').toString(),
              studentAnswer: (a['text_answer'] ?? '').toString(),
              maxPoints: num.tryParse('${q['points']}') ?? 0,
              earnedPoints: num.tryParse('${a['points_earned']}') ?? 0,
              isGraded: a['is_graded'] == 1 || a['is_graded'] == true,
            ),
          );
        }

        setState(() {
          _answers = items;
          _currentScore = num.tryParse('${map['current_score']}') ?? 0;
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          _loading = false;
          _error = 'تعذّر تحميل إجابات الطالب، حاول مجدداً';
        });
      },
    );
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 22))),
    );
  }

  Future<void> _save() async {
    final grades = <Map<String, dynamic>>[];

    for (int i = 0; i < _answers.length; i++) {
      final a = _answers[i];
      final text = a.pointsController.text.trim();
      final n = i + 1;

      if (text.isEmpty) {
        _showMessage('أدخل علامة السؤال رقم $n');
        return;
      }

      final points = num.tryParse(text);
      if (points == null || points < 0) {
        _showMessage('أدخل علامة صحيحة للسؤال رقم $n');
        return;
      }

      if (points > a.maxPoints) {
        _showMessage(
          'علامة السؤال رقم $n لا يمكن أن تتجاوز ${_cleanNumber(a.maxPoints)}',
        );
        return;
      }

      grades.add({'answer_id': a.answerId, 'points': points});
    }

    if (grades.isEmpty) {
      _showMessage('لا توجد إجابات للتصحيح');
      return;
    }

    setState(() => _saving = true);

    final repo = getIt<TeacherRepo>();
    final body = {'grades': grades};
    final result = widget.isExam
        ? await repo.gradeExamTextAnswers(widget.quizId, widget.studentId, body)
        : await repo.gradeTextAnswers(widget.quizId, widget.studentId, body);

    if (!mounted) return;
    setState(() => _saving = false);

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final newScore = map['new_total_score'];
        _showMessage(
          newScore != null
              ? 'تم رصد العلامات — المجموع: ${_cleanNumber(newScore)}'
              : 'تم رصد العلامات بنجاح',
        );
        Navigator.pop(context, true);
      },
      failure: (_) => _showMessage('تعذّر حفظ العلامات، حاول مجدداً'),
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
            widget.studentName.isNotEmpty ? widget.studentName : 'حل الطالب',
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
          icon: const Icon(
            Icons.subdirectory_arrow_left,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.white70, fontSize: 20),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: _load,
              child: const Text(
                'إعادة المحاولة',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ],
        ),
      );
    }

    if (_answers.isEmpty) {
      return Center(
        child: Text(
          'لا توجد أسئلة مقالية للتصحيح',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22),
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 16, bottom: 10),
            itemCount: _answers.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) return _buildScoreChip();
              return _buildAnswerCard(index - 1);
            },
          ),
        ),
        _buildSaveButton(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildScoreChip() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.kPrimaryColor.withOpacity(0.4),
              ),
            ),
            child: Text(
              'العلامة الحالية: ${_cleanNumber(_currentScore)}',
              style: const TextStyle(
                color: AppColors.kPrimaryColor,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${_answers.length} أسئلة مقالية',
            style: const TextStyle(color: Colors.white54, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerCard(int index) {
    final a = _answers[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kSurfaceColor.withOpacity(0.35),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${index + 1}.',
                style: const TextStyle(color: Colors.white54, fontSize: 22),
              ),
              const Spacer(),
              if (a.isGraded)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kPrimaryColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'مصحّح',
                    style: TextStyle(
                      color: AppColors.kPrimaryColor,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),

          Text(
            a.questionText,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
          const SizedBox(height: 16),

          const Text(
            'إجابة الطالب',
            style: TextStyle(color: Colors.white54, fontSize: 18),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.kBackgroundColor.withOpacity(0.4),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white12),
            ),
            child: Text(
              a.studentAnswer.trim().isEmpty
                  ? 'لم يجب الطالب'
                  : a.studentAnswer,
              style: TextStyle(
                color: a.studentAnswer.trim().isEmpty
                    ? Colors.white38
                    : Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              const Text(
                'العلامة: ',
                style: TextStyle(color: Colors.white54, fontSize: 20),
              ),
              SizedBox(
                width: 70,
                child: TextField(
                  controller: a.pointsController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                  decoration: const InputDecoration(
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 25),
                    isDense: true,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.kPrimaryColor),
                    ),
                  ),
                ),
              ),
              Text(
                ' / ${_cleanNumber(a.maxPoints)}',
                style: const TextStyle(color: Colors.white54, fontSize: 20),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Center(
      child: SizedBox(
        width: 332,
        height: 54,
        child: ElevatedButton(
          onPressed: _saving ? null : _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimaryColor,
            disabledBackgroundColor: AppColors.kPrimaryColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _saving
              ? const SizedBox(
                  width: 20,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  'رصد العلامات ',
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Arabic Typesetting",
                    fontSize: 25,
                    fontWeight: FontWeight.w300,
                  ),
                ),
        ),
      ),
    );
  }
}
