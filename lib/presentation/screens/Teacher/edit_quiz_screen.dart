import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

enum EditQuestionType { text, mcq, tf }

extension EditQuestionTypeX on EditQuestionType {
  String get label => switch (this) {
        EditQuestionType.text => 'مقالي',
        EditQuestionType.mcq => 'خيارات',
        EditQuestionType.tf => 'صح أو خطأ',
      };

  String get apiValue => switch (this) {
        EditQuestionType.text => 'TEXT',
        EditQuestionType.mcq => 'mcq',
        EditQuestionType.tf => 'TF',
      };

  /// تحويل نوع السؤال القادم من الباك
  static EditQuestionType fromApi(String v) => switch (v.toLowerCase()) {
        'mcq' => EditQuestionType.mcq,
        'tf' => EditQuestionType.tf,
        _ => EditQuestionType.text,
      };
}

class EditChoiceModel {
  final TextEditingController textController;
  EditChoiceModel({String text = ''})
      : textController = TextEditingController(text: text);
}

class EditQuestionModel {
  EditQuestionType type;
  final TextEditingController descriptionController;
  final TextEditingController pointsController;
  final TextEditingController textAnswerController;

  bool? tfCorrectIsTrue;
  int? correctChoiceIndex;
  List<EditChoiceModel> choices;

  EditQuestionModel({
    this.type = EditQuestionType.text,
    String description = '',
    String points = '',
    String textAnswer = '',
    this.tfCorrectIsTrue,
    this.correctChoiceIndex,
    List<EditChoiceModel>? choices,
  })  : descriptionController = TextEditingController(text: description),
        pointsController = TextEditingController(text: points),
        textAnswerController = TextEditingController(text: textAnswer),
        choices = choices ?? [EditChoiceModel()];

  void dispose() {
    descriptionController.dispose();
    pointsController.dispose();
    textAnswerController.dispose();
    for (final c in choices) {
      c.textController.dispose();
    }
  }
}

/// تعديل كويز: يُحمّل الكويز الحالي بأسئلته، ويُرسل الأسئلة كاملة عند الحفظ
/// (الباك يحذف الأسئلة القديمة وينشئ الجديدة)
class EditQuizScreen extends StatefulWidget {
  final int quizId;
  final String lessonTitle;

  const EditQuizScreen({
    super.key,
    required this.quizId,
    this.lessonTitle = '',
  });

  @override
  State<EditQuizScreen> createState() => _EditQuizScreenState();
}

class _EditQuizScreenState extends State<EditQuizScreen> {
  final List<EditQuestionModel> _questions = [];
  final TextEditingController _timeLimitController = TextEditingController();

  static const int _maxChoices = 4;

  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  @override
  void dispose() {
    _timeLimitController.dispose();
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  String _cleanNumber(dynamic v) {
    final s = (v ?? '').toString();
    final d = double.tryParse(s);
    if (d == null) return s;
    return d == d.roundToDouble() ? d.toInt().toString() : s;
  }

  Future<void> _loadQuiz() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await getIt<TeacherRepo>().getQuizById(widget.quizId);

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final quiz = (map['quiz'] is Map)
            ? Map<String, dynamic>.from(map['quiz'])
            : Map<String, dynamic>.from(map);

        _timeLimitController.text = (quiz['timelimit'] ?? '').toString();

        final rawQuestions =
            (quiz['questions'] is List) ? quiz['questions'] as List : const [];

        for (final e in rawQuestions) {
          if (e is! Map) continue;
          final q = Map<String, dynamic>.from(e);

          final type = EditQuestionTypeX.fromApi((q['type'] ?? '').toString());
          final answer = (q['correct_answer'] ?? '').toString();

          final rawChoices =
              (q['choices'] is List) ? q['choices'] as List : const [];
          final choices = <EditChoiceModel>[];
          int? correctIndex;

          for (int i = 0; i < rawChoices.length; i++) {
            final c = rawChoices[i];
            if (c is! Map) continue;
            choices.add(
              EditChoiceModel(text: (c['choice_text'] ?? '').toString()),
            );
            if (c['is_correct'] == 1 || c['is_correct'] == true) {
              correctIndex = i;
            }
          }

          // صح/خطأ
          bool? tfValue;
          if (type == EditQuestionType.tf) {
            final a = answer.toLowerCase();
            if (a == 'true') tfValue = true;
            if (a == 'false') tfValue = false;
          }

          _questions.add(
            EditQuestionModel(
              type: type,
              description: (q['description'] ?? '').toString(),
              points: _cleanNumber(q['points']),
              textAnswer: type == EditQuestionType.text ? answer : '',
              tfCorrectIsTrue: tfValue,
              correctChoiceIndex: correctIndex,
              choices: choices.isEmpty ? [EditChoiceModel()] : choices,
            ),
          );
        }

        setState(() => _loading = false);
      },
      failure: (_) {
        setState(() {
          _loading = false;
          _error = 'تعذّر تحميل الكويز، حاول مجدداً';
        });
      },
    );
  }

  void _addQuestion() {
    setState(() => _questions.add(EditQuestionModel()));
  }

  void _removeQuestion(int index) {
    if (_questions.length == 1) {
      _showMessage('يجب أن يحتوي الكويز على سؤال واحد على الأقل');
      return;
    }
    setState(() {
      _questions[index].dispose();
      _questions.removeAt(index);
    });
  }

  void _addChoice(EditQuestionModel q) {
    if (q.choices.length >= _maxChoices) {
      _showMessage('الحد الأقصى $_maxChoices خيارات');
      return;
    }
    setState(() => q.choices.add(EditChoiceModel()));
  }

  void _removeChoice(EditQuestionModel q, int choiceIndex) {
    if (q.choices.length == 1) {
      _showMessage('يجب أن يحتوي السؤال على خيار واحد على الأقل');
      return;
    }
    setState(() {
      if (q.correctChoiceIndex != null) {
        if (choiceIndex == q.correctChoiceIndex) {
          q.correctChoiceIndex = null;
        } else if (choiceIndex < q.correctChoiceIndex!) {
          q.correctChoiceIndex = q.correctChoiceIndex! - 1;
        }
      }
      q.choices[choiceIndex].textController.dispose();
      q.choices.removeAt(choiceIndex);
    });
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 25))),
    );
  }

  Future<void> _save() async {
    final timeLimit = int.tryParse(_timeLimitController.text.trim());
    if (timeLimit == null || timeLimit <= 0) {
      _showMessage('أدخل مدة صحيحة للكويز');
      return;
    }

    if (_questions.isEmpty) {
      _showMessage('يجب أن يحتوي الكويز على سؤال واحد على الأقل');
      return;
    }

    int totalMark = 0;

    for (int i = 0; i < _questions.length; i++) {
      final q = _questions[i];
      final n = i + 1;

      if (q.descriptionController.text.trim().isEmpty) {
        _showMessage('اكتب نص السؤال رقم $n');
        return;
      }
      final points = int.tryParse(q.pointsController.text.trim());
      if (points == null || points <= 0) {
        _showMessage('أدخل درجة صحيحة للسؤال رقم $n');
        return;
      }
      totalMark += points;

      if (q.type == EditQuestionType.text) {
        if (q.textAnswerController.text.trim().isEmpty) {
          _showMessage('اكتب إجابة السؤال المقالي رقم $n');
          return;
        }
      } else if (q.type == EditQuestionType.tf) {
        if (q.tfCorrectIsTrue == null) {
          _showMessage('اختر الإجابة الصحيحة (صح/خطأ) للسؤال رقم $n');
          return;
        }
      } else if (q.type == EditQuestionType.mcq) {
        final filled =
            q.choices.where((c) => c.textController.text.trim().isNotEmpty);
        if (filled.length < 2) {
          _showMessage('أضف خيارين على الأقل للسؤال رقم $n');
          return;
        }
        if (q.correctChoiceIndex == null ||
            q.choices[q.correctChoiceIndex!].textController.text
                .trim()
                .isEmpty) {
          _showMessage('حدد الإجابة الصحيحة للسؤال رقم $n');
          return;
        }
      }
    }

    final questionsJson = _questions.map((q) {
      final base = <String, dynamic>{
        'type': q.type.apiValue,
        'description': q.descriptionController.text.trim(),
        'points': int.parse(q.pointsController.text.trim()),
      };

      switch (q.type) {
        case EditQuestionType.text:
          base['correct_answer'] = q.textAnswerController.text.trim();
          break;
        case EditQuestionType.tf:
          base['correct_answer'] = q.tfCorrectIsTrue! ? 'True' : 'False';
          break;
        case EditQuestionType.mcq:
          base['choices'] = List.generate(q.choices.length, (idx) {
            return {
              'text': q.choices[idx].textController.text.trim(),
              'is_correct': idx == q.correctChoiceIndex,
            };
          }).where((c) => (c['text'] as String).isNotEmpty).toList();
          break;
      }
      return base;
    }).toList();

    final body = {
      'timelimit': timeLimit,
      'numofquestions': _questions.length,
      'totalmark': totalMark,
      'questions': questionsJson,
    };

    setState(() => _saving = true);

    final result = await getIt<TeacherRepo>().updateQuiz(widget.quizId, body);

    if (!mounted) return;
    setState(() => _saving = false);

    result.when(
      success: (_) {
        _showMessage('تم تعديل الكويز بنجاح');
        Navigator.pop(context, true);
      },
      failure: (_) => _showMessage('تعذّر حفظ التعديلات، حاول مجدداً'),
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
            widget.lessonTitle.isNotEmpty
                ? 'تعديل: ${widget.lessonTitle}'
                : 'تعديل الكويز',
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
              onPressed: _loadQuiz,
              child: const Text('إعادة المحاولة',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            itemCount: _questions.length + 2, // حقل المدة + زر الإضافة
            itemBuilder: (context, index) {
              if (index == 0) return _buildTimeLimitField();
              if (index == _questions.length + 1) {
                return _buildAddQuestionButton();
              }
              return _buildQuestionCard(index - 1);
            },
          ),
        ),
        _buildSaveButton(),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget _buildTimeLimitField() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor.withOpacity(0.20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.30)),
      ),
      child: TextField(
        controller: _timeLimitController,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white, fontSize: 25),
        decoration: InputDecoration(
          hintText: 'مدة الكويز',
          hintStyle:
              TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 25),
          prefixIcon:
              const Icon(Icons.access_time, color: AppColors.kPrimaryColor),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildQuestionCard(int index) {
    final q = _questions[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.kSurfaceColor.withOpacity(0.35),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextField(
                  controller: q.descriptionController,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                  decoration: InputDecoration(
                    hintText: 'السؤال',
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 25),
                    isDense: true,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.kPrimaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _buildTypeDropdown(q),
            ],
          ),
          const SizedBox(height: 16),
          _buildBodyByType(q),
          const SizedBox(height: 12),
          Row(
            children: [
              SizedBox(
                width: 90,
                child: TextField(
                  controller: q.pointsController,
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 25),
                  decoration: InputDecoration(
                    hintText: 'الدرجة',
                    hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.4), fontSize: 25),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _removeQuestion(index),
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(EditQuestionModel q) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<EditQuestionType>(
          value: q.type,
          isDense: true,
          dropdownColor: AppColors.kSurfaceColor,
          iconEnabledColor: Colors.white70,
          iconSize: 25,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: EditQuestionType.values
              .map((t) => DropdownMenuItem(value: t, child: Text(t.label)))
              .toList(),
          onChanged: (t) {
            if (t == null) return;
            setState(() => q.type = t);
          },
        ),
      ),
    );
  }

  Widget _buildBodyByType(EditQuestionModel q) {
    switch (q.type) {
      case EditQuestionType.text:
        return _buildTextAnswer(q);
      case EditQuestionType.tf:
        return _buildTrueFalse(q);
      case EditQuestionType.mcq:
        return _buildChoices(q);
    }
  }

  Widget _buildTextAnswer(EditQuestionModel q) {
    return TextField(
      controller: q.textAnswerController,
      textAlign: TextAlign.right,
      minLines: 1,
      maxLines: null,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      style: const TextStyle(color: Colors.white, fontSize: 25),
      decoration: InputDecoration(
        hintText: 'الإجابة',
        hintStyle:
            TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 25),
        isDense: true,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.kPrimaryColor),
        ),
      ),
    );
  }

  Widget _buildTrueFalse(EditQuestionModel q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTfRow(q, isTrue: true, label: 'صح'),
        const SizedBox(height: 9),
        _buildTfRow(q, isTrue: false, label: 'خطأ'),
      ],
    );
  }

  Widget _buildTfRow(EditQuestionModel q,
      {required bool isTrue, required String label}) {
    return GestureDetector(
      onTap: () => setState(() => q.tfCorrectIsTrue = isTrue),
      child: Row(
        children: [
          Radio<bool>(
            value: isTrue,
            groupValue: q.tfCorrectIsTrue,
            activeColor: AppColors.kPrimaryColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            onChanged: (v) => setState(() => q.tfCorrectIsTrue = v),
          ),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(color: Colors.white, fontSize: 25)),
        ],
      ),
    );
  }

  Widget _buildChoices(EditQuestionModel q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...List.generate(q.choices.length, (i) {
          final choice = q.choices[i];
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Radio<int>(
                  value: i,
                  groupValue: q.correctChoiceIndex,
                  activeColor: AppColors.kPrimaryColor,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                  onChanged: (v) => setState(() => q.correctChoiceIndex = v),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: choice.textController,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                    decoration: InputDecoration(
                      hintText: 'الخيار ${i + 1}',
                      hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4), fontSize: 25),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _removeChoice(q, i),
                  child:
                      const Icon(Icons.close, color: Colors.white38, size: 20),
                ),
              ],
            ),
          );
        }),
        if (q.choices.length < _maxChoices)
          GestureDetector(
            onTap: () => _addChoice(q),
            child: Row(
              children: [
                const Icon(Icons.add_box_outlined,
                    color: AppColors.kPrimaryColor, size: 22),
                const SizedBox(width: 8),
                Text('إضافة خيار',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.7), fontSize: 25)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildAddQuestionButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: _addQuestion,
        child: Container(
          margin: const EdgeInsets.only(bottom: 5),
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.kTextPrimary, width: 2),
          ),
          child: const Icon(Icons.add, color: AppColors.kTextPrimary, size: 12),
        ),
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
                      color: Colors.black, strokeWidth: 3),
                )
              : const Text(
                  'حفظ التعديلات ',
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