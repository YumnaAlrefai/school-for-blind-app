import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

enum QuestionType { text, mcq, tf }

extension QuestionTypeX on QuestionType {
  /// الاسم المعروض بالعربي
  String get label => switch (this) {
    QuestionType.text => 'مقالي',
    QuestionType.mcq => 'خيارات',
    QuestionType.tf => 'صح أو خطأ',
  };

  /// القيمة المرسلة للباك
  String get apiValue => switch (this) {
    QuestionType.text => 'TEXT',
    QuestionType.mcq => 'mcq',
    QuestionType.tf => 'TF',
  };
}

/// خيار ضمن سؤال من نوع mcq
class ChoiceModel {
  final TextEditingController textController;
  bool isCorrect;
  ChoiceModel({String text = '', this.isCorrect = false})
    : textController = TextEditingController(text: text);
}

/// نموذج سؤال محلي (قبل الإرسال)
class QuestionModel {
  QuestionType type;
  final TextEditingController descriptionController;
  final TextEditingController pointsController;

  // مقالي (TEXT)
  final TextEditingController textAnswerController;

  // صح أو خطأ (TF): true = صح
  bool? tfCorrectIsTrue;

  // خيارات (mcq)
  List<ChoiceModel> choices;
  int? correctChoiceIndex;

  QuestionModel({this.type = QuestionType.text})
    : descriptionController = TextEditingController(),
      pointsController = TextEditingController(),
      textAnswerController = TextEditingController(),
      tfCorrectIsTrue = null,
           choices = [ChoiceModel()],
      correctChoiceIndex = null;

  void dispose() {
    descriptionController.dispose();
    pointsController.dispose();
    textAnswerController.dispose();
    for (final c in choices) {
      c.textController.dispose();
    }
  }
}

class QuizQuestionsScreen extends StatefulWidget {
  final int lessonId;
  final int timeLimit;
  final int numOfQuestions;

  const QuizQuestionsScreen({
    super.key,
    required this.lessonId,
    required this.timeLimit,
    required this.numOfQuestions,
  });

  @override
  State<QuizQuestionsScreen> createState() => _QuizQuestionsScreenState();
}

class _QuizQuestionsScreenState extends State<QuizQuestionsScreen> {
  late final List<QuestionModel> _questions;

  static const int _maxChoices = 4;

  int get _maxQuestions => widget.numOfQuestions;

  @override
  void initState() {
    super.initState();
    _questions = [QuestionModel()];
  }

  @override
  void dispose() {
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    if (_questions.length >= _maxQuestions) {
      _showMessage('لقد وصلت للحد الأقصى لعدد الأسئلة ($_maxQuestions)');
      return;
    }
    setState(() => _questions.add(QuestionModel()));
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

  void _addChoice(QuestionModel q) {
    if (q.choices.length >= _maxChoices) {
      _showMessage('الحد الأقصى $_maxChoices خيارات');
      return;
    }
    setState(() => q.choices.add(ChoiceModel()));
  }

  void _removeChoice(QuestionModel q, int choiceIndex) {
    if (q.choices.length == 1) {
      _showMessage('يجب أن يحتوي السؤال على خيار واحد على الأقل');
      return;
    }
    setState(() {
      q.choices[choiceIndex].textController.dispose();
      q.choices.removeAt(choiceIndex);
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  void _uploadQuiz() {
    if (_questions.length != widget.numOfQuestions) {
      _showMessage(
        'عدد الأسئلة المدخل (${_questions.length}) لا يطابق العدد المطلوب (${widget.numOfQuestions})',
      );
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
if (q.type == QuestionType.text) {
        if (q.textAnswerController.text.trim().isEmpty) {
          _showMessage('اكتب إجابة السؤال المقالي رقم $n');
          return;
        }
      } else if (q.type == QuestionType.tf) {
        if (q.tfCorrectIsTrue == null) {
          _showMessage('اختر الإجابة الصحيحة (صح/خطأ) للسؤال رقم $n');
          return;
        }
     } else if (q.type == QuestionType.mcq) {
  final filled = q.choices.where(
    (c) => c.textController.text.trim().isNotEmpty,
  );
  if (filled.length < 2) {
    _showMessage('أضف خيارين على الأقل للسؤال رقم $n');
    return;
  }
  
  // التعديل هنا: نتحقق إذا كان المؤشر فارغاً أو يشير إلى خيار نصّه فارغ
  if (q.correctChoiceIndex == null || 
      q.choices[q.correctChoiceIndex!].textController.text.trim().isEmpty) {
    _showMessage('حدد الإجابة الصحيحة للسؤال رقم $n');
    return;
  }
}
    }

    final questionsJson = _questions.map((q) {
      final base = {
        'type': q.type.apiValue,
        'description': q.descriptionController.text.trim(),
        'points': int.parse(q.pointsController.text.trim()),
      };

      switch (q.type) {
        case QuestionType.text:
          base['correct_answer'] = q.textAnswerController.text.trim();
          break;
      case QuestionType.tf:
          base['correct_answer'] = q.tfCorrectIsTrue! ? 'True' : 'False';
          break;
        case QuestionType.mcq:
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
      'lesson_id': widget.lessonId,
      'timelimit': widget.timeLimit,
      'numofquestions': _questions.length,
      'totalmark': totalMark,
      'questions': questionsJson,
    };

    getIt<LessonsCubit>().emitCreateQuiz(body);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: BlocConsumer<LessonsCubit, ResultState<dynamic>>(
            bloc: getIt<LessonsCubit>(),
            listener: (context, state) {
              state.whenOrNull(
                success: (data) {
                  if (data == 'quiz_created') {
                    _showMessage('تم رفع الكويز بنجاح');
                    Navigator.of(context)
                      ..pop()
                      ..pop();
                  }
                },
                failure: (_) => _showMessage(
                  'فشل رفع الكويز، تأكد من الاتصال وحاول مجدداً',
                ),
              );
            },
            builder: (context, state) {
              final isUploading = state.maybeWhen(
                loading: () => true,
                orElse: () => false,
              );

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    _buildTopBar(),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        itemCount:
                            _questions.length +
                            (_questions.length < _maxQuestions ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == _questions.length) {
                            return _buildAddQuestionButton();
                          }
                          return _buildQuestionCard(index);
                        },
                      ),
                    ),
                    _buildUploadButton(isUploading),
                    const SizedBox(height: 40),
                  ],
                ),
              );
            },
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
          'الأسئلة: ',
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
          // سطر: نص السؤال (يمين) + نوع السؤال (يسار)
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
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 25,
                    ),
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
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 25,
                    ),
                    isDense: true,
                    border: InputBorder.none,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => _removeQuestion(index),
                child: const Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(QuestionModel q) {
    return Container(
      height: 40, 
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<QuestionType>(
          value: q.type,
          isDense: true,
          dropdownColor: AppColors.kSurfaceColor,
          iconEnabledColor: Colors.white70,
          iconSize: 25,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16, 
          ),
          items: QuestionType.values
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

  Widget _buildBodyByType(QuestionModel q) {
    switch (q.type) {
      case QuestionType.text:
        return _buildTextAnswer(q);
      case QuestionType.tf:
        return _buildTrueFalse(q);
      case QuestionType.mcq:
        return _buildChoices(q);
    }
  }

  Widget _buildTextAnswer(QuestionModel q) {
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
        hintStyle: TextStyle(
          color: Colors.white.withOpacity(0.4),
          fontSize: 25,
        ),
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

Widget _buildTrueFalse(QuestionModel q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTfRow(q, isTrue: true, label: 'صح'),
        const SizedBox(height: 9),
        _buildTfRow(q, isTrue: false, label: 'خطأ'),
      ],
    );
  }

  Widget _buildTfRow(QuestionModel q,
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

  Widget _buildChoices(QuestionModel q) {
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
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 25,
                      ),
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _removeChoice(q, i),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white38,
                    size: 20,
                  ),
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
                const Icon(
                  Icons.add_box_outlined,
                  color: AppColors.kPrimaryColor,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  'إضافة خيار',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 25,
                  ),
                ),
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

  Widget _buildUploadButton(bool isUploading) {
    return Center(
      child: SizedBox(
        width: 332,
        height: 54,
        child: ElevatedButton(
          onPressed: isUploading ? null : _uploadQuiz,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimaryColor,
            disabledBackgroundColor: AppColors.kPrimaryColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: isUploading
              ? const SizedBox(
                  width: 20,
                  height: 26,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    strokeWidth: 3,
                  ),
                )
              : const Text(
                  'رفع ',
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

class _TfRow extends StatelessWidget {
  final String label;
  const _TfRow({required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white54, width: 1.5),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 25)),
      ],
    );
  }
}
