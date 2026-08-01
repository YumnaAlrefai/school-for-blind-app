import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher/teacher_lessons_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';


class BankItem {
  final int id;
  final String title;
  final int? subjectId;
  final Map<String, dynamic> raw; 

  const BankItem({
    required this.id,
    required this.title,
    this.subjectId,
    this.raw = const {},
  });
}


enum BankTab { exams, quizzes, extra }

extension BankTabX on BankTab {
  String get label => switch (this) {
    BankTab.exams => 'اختباراتي',
    BankTab.quizzes => 'كويزاتي',
    BankTab.extra => 'أسئلة إضافية',
  };

  
  
  bool get canEdit => this == BankTab.quizzes;

  
  bool get canDelete => this != BankTab.exams;
}

class QuestionBankScreen extends StatefulWidget {
  const QuestionBankScreen({super.key});

  @override
  State<QuestionBankScreen> createState() => _QuestionBankScreenState();
}

class _QuestionBankScreenState extends State<QuestionBankScreen> {
  BankTab _tab = BankTab.exams;

  bool _loading = true;
  String? _error;
  List<BankItem> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  int? get _currentSubjectId => getIt<TeacherLessonsCubit>().selectedSubject?.id;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final repo = getIt<TeacherRepo>();
    final result = switch (_tab) {
      BankTab.exams => await repo.getMyExams(),
      BankTab.quizzes => await repo.getMyQuizzes(subjectId: _currentSubjectId),
      BankTab.extra => await repo.getQuestionBank(),
    };

    result.when(
      success: (data) {
        setState(() {
          _items = _parse(data);
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          _loading = false;
          _error = 'تعذّر تحميل البيانات، حاول مجدداً';
        });
      },
    );
  }

  
  List _rawList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      for (final key in ['data', 'exams', 'quizzes', 'questions']) {
        final v = data[key];
        if (v is List) return v;
        if (v is Map && v['data'] is List) return v['data'];
      }
    }
    return const [];
  }

  List<BankItem> _parse(dynamic data) {
    final raw = _rawList(data);
    final items = <BankItem>[];

    for (final e in raw) {
      if (e is! Map) continue;
      final map = Map<String, dynamic>.from(e);

      final id = int.tryParse('${map['id']}') ?? 0;
      final subjectId = int.tryParse('${map['subject_id']}');

      String title;
      switch (_tab) {
        case BankTab.exams:
          title = (map['title'] ?? '').toString();
          break;
        case BankTab.quizzes:
          final lesson = map['lesson'];
          title = (lesson is Map ? (lesson['title'] ?? '') : '').toString();
          if (title.trim().isEmpty) {
            title = (map['lesson_title'] ?? map['subject_name'] ?? '')
                .toString();
          }
          break;
        case BankTab.extra:
          title = (map['description'] ?? '').toString();
          break;
      }
      if (title.trim().isEmpty) title = 'بدون عنوان';

      items.add(BankItem(id: id, title: title, subjectId: subjectId, raw: map));
    }

    final sid = _currentSubjectId;
    if (sid != null && items.any((i) => i.subjectId != null)) {
      return items
          .where((i) => i.subjectId == null || i.subjectId == sid)
          .toList();
    }
    return items;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 25))),
    );
  }

  Future<void> _confirmDelete(BankItem item) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: AppColors.kSurfaceColor,
          title: const Text(
            'تأكيد الحذف',
            style: TextStyle(color: Colors.white, fontSize: 40),
          ),
          content: Text(
            'هل تريد حذف "${item.title}"؟',
            style: const TextStyle(color: Colors.white70, fontSize: 26),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.white70, fontSize: 26),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text(
                'حذف',
                style: TextStyle(color: Colors.redAccent, fontSize: 26),
              ),
            ),
          ],
        ),
      ),
    );

    if (ok != true) return;

    final repo = getIt<TeacherRepo>();
    final result = _tab == BankTab.quizzes
        ? await repo.deleteQuiz(item.id)
        : await repo.deleteBankQuestion(item.id);

    result.when(
      success: (_) {
        _showMessage('تم الحذف بنجاح');
        _load();
      },
      failure: (_) => _showMessage('تعذّر الحذف، حاول مجدداً'),
    );
  }

  void _onEdit(BankItem item) async {
    final updated = await Navigator.pushNamed<bool>(
      context,
      AppRoutes.kEditQuiz,
      arguments: {'quizId': item.id, 'lessonTitle': item.title},
    );
    if (updated == true && mounted) _load();
  }

  String _typeLabel(String type) => switch (type.toLowerCase()) {
    'mcq' => 'خيارات',
    'tf' => 'صح أو خطأ',
    _ => 'مقالي',
  };

  String _cleanNumber(String v) {
    final d = double.tryParse(v);
    if (d == null) return v;
    return d == d.roundToDouble() ? d.toInt().toString() : v;
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

  Widget _chip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  
  void _showQuestionDetails(BankItem item) {
    final map = item.raw;
    final type = (map['type'] ?? '').toString();
    final description = (map['description'] ?? '').toString();
    final points = (map['points'] ?? '').toString();
    final correctAnswer = (map['correct_answer'] ?? '').toString();
    final choices = (map['choices'] is List)
        ? map['choices'] as List
        : const [];

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kBackgroundColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _chip(_typeLabel(type)),
                      const SizedBox(width: 10),
                      if (points.isNotEmpty)
                        _chip('${_cleanNumber(points)} درجة'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'السؤال',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'الإجابة',
                    style: TextStyle(color: Colors.white54, fontSize: 18),
                  ),
                  const SizedBox(height: 6),
                  if (choices.isNotEmpty)
                    ...choices.map((c) {
                      final m = (c is Map) ? c : const {};
                      final text = (m['choice_text'] ?? '').toString();
                      final isCorrect =
                          m['is_correct'] == 1 || m['is_correct'] == true;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Icon(
                              isCorrect
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: isCorrect
                                  ? AppColors.kPrimaryColor
                                  : Colors.white38,
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
                    Text(
                      _answerLabel(type, correctAnswer),
                      style: const TextStyle(
                        color: AppColors.kPrimaryColor,
                        fontSize: 22,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTopBar(),
                const SizedBox(height: 20),
                _buildSubjectHeader(),
                const SizedBox(height: 12),
                _buildTabs(),
                const SizedBox(height: 16),
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
        const Text(
          'البنك',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: "Arabic Typesetting",
            fontWeight: FontWeight.w300,
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

  
  Widget _buildSubjectHeader() {
    final cubit = getIt<TeacherLessonsCubit>();
    return BlocBuilder<TeacherLessonsCubit, ResultState<dynamic>>(
      bloc: cubit,
      builder: (context, state) {
        final subject = cubit.selectedSubject;
        final hasMultiple = cubit.taughtSubjects.length > 1;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: hasMultiple ? () => _showSubjectsSheet(cubit) : null,
          child: Row(
            children: [
              Text(
                subject != null ? '${subject.name}:' : 'المادة',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (hasMultiple) ...[
                const SizedBox(width: 4),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 26,
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  void _showSubjectsSheet(TeacherLessonsCubit cubit) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: cubit.taughtSubjects.map((s) {
              final selected = s.id == cubit.selectedSubject?.id;
              return ListTile(
                title: Text(
                  s.name,
                  style: TextStyle(
                    color: selected ? AppColors.kPrimaryColor : Colors.white,
                    fontSize: 18,
                  ),
                ),
                trailing: selected
                    ? const Icon(Icons.check, color: AppColors.kPrimaryColor)
                    : null,
                onTap: () async {
                  Navigator.pop(sheetCtx);
                  await cubit.selectSubject(s);
                  if (mounted) _load(); 
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Row(
      children: BankTab.values.map((t) {
        final isSelected = _tab == t;
        return Expanded(
          
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ), 
            child: GestureDetector(
              onTap: () {
                if (_tab == t) return;
                setState(() => _tab = t);
                _load();
              },
              child: Container(
                height: 37,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.kPrimaryColor
                      : Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  t.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontSize: 25,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
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

    
    final showAddButton = _tab == BankTab.extra;

    if (_items.isEmpty && !showAddButton) {
      return Center(
        child: Text(
          'لا يوجد عناصر هنا بعد',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _items.length + (showAddButton ? 1 : 0),
      itemBuilder: (context, i) {
        if (i == _items.length) return _buildAddQuestionsButton();
        return _buildItemCard(_items[i]);
      },
    );
  }

  
  Widget _buildAddQuestionsButton() {
    return GestureDetector(
      onTap: () async {
        final added = await Navigator.pushNamed<bool>(
          context,
          AppRoutes.kAddBankQuestions,
        );
        if (added == true && mounted) _load();
      },
      child: Container(
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'إضافة أسئلة جديدة',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.add_box_outlined,
              color: AppColors.kPrimaryColor,
              size: 26,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemCard(BankItem item) {
    final VoidCallback? onTap = switch (_tab) {
      BankTab.extra => () => _showQuestionDetails(item),
      BankTab.exams => () => Navigator.pushNamed(
        context,
        AppRoutes.kViewExam,
        arguments: {'examId': item.id, 'examTitle': item.title},
      ),
      _ => null,
    };

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        height: 66,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.30)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(color: Colors.white, fontSize: 22),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            
            if (_tab.canEdit) ...[
              GestureDetector(
                onTap: () => _onEdit(item),
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
            ],
            
            if (_tab.canDelete)
              GestureDetector(
                onTap: () => _confirmDelete(item),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 26,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
