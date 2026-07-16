import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

/// عرض اختبار كامل للقراءة فقط (بدون أي تعديل)
class ViewExamScreen extends StatefulWidget {
  final int examId;
  final String examTitle;

  const ViewExamScreen({
    super.key,
    required this.examId,
    this.examTitle = '',
  });

  @override
  State<ViewExamScreen> createState() => _ViewExamScreenState();
}

class _ViewExamScreenState extends State<ViewExamScreen> {
  bool _loading = true;
  String? _error;

  String _title = '';
  String _duration = '';
  bool _isPublished = false;
  List _questions = const [];

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

    final result = await getIt<TeacherRepo>().getExamById(widget.examId);

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final exam = (map['data'] is Map)
            ? Map<String, dynamic>.from(map['data'])
            : Map<String, dynamic>.from(map);

        setState(() {
          _title = (exam['title'] ?? widget.examTitle).toString();
          _duration = (exam['duration_minutes'] ?? '').toString();
          _isPublished =
              exam['is_published'] == 1 || exam['is_published'] == true;
          _questions =
              (exam['questions'] is List) ? exam['questions'] as List : const [];
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          _loading = false;
          _error = 'تعذّر تحميل الاختبار، حاول مجدداً';
        });
      },
    );
  }

  String _typeLabel(String type) => switch (type.toLowerCase()) {
        'mcq' => 'خيارات',
        'tf' => 'صح أو خطأ',
        _ => 'مقالي',
      };

  /// "2.00" → "2"
  String _cleanNumber(dynamic v) {
    final s = (v ?? '').toString();
    final d = double.tryParse(s);
    if (d == null) return s;
    return d == d.roundToDouble() ? d.toInt().toString() : s;
  }

  String _answerLabel(String type, String answer) {
    if (answer.trim().isEmpty) return 'غير محددة';
    if (type.toLowerCase() == 'tf') {
      final a = answer.toLowerCase();
      if (a == 'true') return 'صح';
      if (a == 'false') return 'خطأ';
    }
    return answer;
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
            _title.isNotEmpty ? _title : 'الاختبار',
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

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      itemCount: _questions.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildInfoRow();
        return _buildQuestionCard(index - 1);
      },
    );
  }

  /// معلومات الاختبار: المدة + حالة النشر
  Widget _buildInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          if (_duration.isNotEmpty) _chip('$_duration دقيقة'),
          _chip('${_questions.length} أسئلة'),
          _chip(
            _isPublished ? 'منشور' : 'بانتظار موافقة الإدارة',
            color: _isPublished ? AppColors.kPrimaryColor : Colors.orangeAccent,
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, {Color? color}) {
    final c = color ?? Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: c.withOpacity(0.4)),
      ),
      child: Text(text, style: TextStyle(color: c, fontSize: 16)),
    );
  }

  /// كارد سؤال — للقراءة فقط
  Widget _buildQuestionCard(int index) {
    final e = _questions[index];
    final q = (e is Map) ? Map<String, dynamic>.from(e) : <String, dynamic>{};

    final type = (q['type'] ?? '').toString();
    final description = (q['description'] ?? '').toString();
    final points = _cleanNumber(q['points']);
    final correctAnswer = (q['correct_answer'] ?? '').toString();
    final choices = (q['choices'] is List) ? q['choices'] as List : const [];

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
          // رقم السؤال + النوع + الدرجة
          Row(
            children: [
              Text(
                '${index + 1}.',
                style: const TextStyle(color: Colors.white54, fontSize: 22),
              ),
              const Spacer(),
              _chip(_typeLabel(type)),
              const SizedBox(width: 8),
              if (points.isNotEmpty) _chip('$points درجة'),
            ],
          ),
          const SizedBox(height: 12),

          // نص السؤال
          Text(
            description,
            style: const TextStyle(color: Colors.white, fontSize: 25),
          ),
          const SizedBox(height: 16),

          // الإجابة
          if (choices.isNotEmpty)
            ...choices.map((c) {
              final m = (c is Map) ? c : const {};
              final text = (m['choice_text'] ?? '').toString();
              final isCorrect = m['is_correct'] == 1 || m['is_correct'] == true;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(
                      isCorrect
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color:
                          isCorrect ? AppColors.kPrimaryColor : Colors.white38,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: isCorrect
                              ? AppColors.kPrimaryColor
                              : Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
          else
            Row(
              children: [
                const Text('الإجابة: ',
                    style: TextStyle(color: Colors.white54, fontSize: 20)),
                Expanded(
                  child: Text(
                    _answerLabel(type, correctAnswer),
                    style: const TextStyle(
                        color: AppColors.kPrimaryColor, fontSize: 22),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}