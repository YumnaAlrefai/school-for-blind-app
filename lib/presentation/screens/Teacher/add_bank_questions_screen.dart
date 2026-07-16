import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

enum BankQuestionType { text, mcq, tf }

extension BankQuestionTypeX on BankQuestionType {
  String get label => switch (this) {
        BankQuestionType.text => 'مقالي',
        BankQuestionType.mcq => 'خيارات',
        BankQuestionType.tf => 'صح أو خطأ',
      };

  String get apiValue => switch (this) {
        BankQuestionType.text => 'TEXT',
        BankQuestionType.mcq => 'mcq',
        BankQuestionType.tf => 'TF',
      };
}

class BankChoiceModel {
  final TextEditingController textController;
  BankChoiceModel({String text = ''})
      : textController = TextEditingController(text: text);
}

class BankQuestionModel {
  BankQuestionType type;
  final TextEditingController descriptionController;
  final TextEditingController pointsController;
  final TextEditingController textAnswerController;

  bool? tfCorrectIsTrue;
  int? correctChoiceIndex;
  List<BankChoiceModel> choices;

  BankQuestionModel({this.type = BankQuestionType.text})
      : descriptionController = TextEditingController(),
        pointsController = TextEditingController(),
        textAnswerController = TextEditingController(),
        tfCorrectIsTrue = null,
        correctChoiceIndex = null,
        choices = [BankChoiceModel()];

  void dispose() {
    descriptionController.dispose();
    pointsController.dispose();
    textAnswerController.dispose();
    for (final c in choices) {
      c.textController.dispose();
    }
  }
}

/// إضافة أسئلة إلى بنك الأسئلة — تُرفع سؤالاً سؤالاً إلى POST /api/question-bank
class AddBankQuestionsScreen extends StatefulWidget {
  const AddBankQuestionsScreen({super.key});

  @override
  State<AddBankQuestionsScreen> createState() => _AddBankQuestionsScreenState();
}

class _AddBankQuestionsScreenState extends State<AddBankQuestionsScreen> {
  final List<BankQuestionModel> _questions = [BankQuestionModel()];

  static const int _maxChoices = 4;
  bool _uploading = false;

  @override
  void dispose() {
    for (final q in _questions) {
      q.dispose();
    }
    super.dispose();
  }

  void _addQuestion() {
    setState(() => _questions.add(BankQuestionModel()));
  }

  void _removeQuestion(int index) {
    if (_questions.length == 1) {
      _showMessage('يجب إدخال سؤال واحد على الأقل');
      return;
    }
    setState(() {
      _questions[index].dispose();
      _questions.removeAt(index);
    });
  }

  void _addChoice(BankQuestionModel q) {
    if (q.choices.length >= _maxChoices) {
      _showMessage('الحد الأقصى $_maxChoices خيارات');
      return;
    }
    setState(() => q.choices.add(BankChoiceModel()));
  }

  void _removeChoice(BankQuestionModel q, int choiceIndex) {
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

  /// يبني جسم سؤال واحد بشكل ما يتوقّعه الباك
  Map<String, dynamic> _questionBody(BankQuestionModel q) {
    final base = <String, dynamic>{
      'type': q.type.apiValue,
      'description': q.descriptionController.text.trim(),
      'points': int.parse(q.pointsController.text.trim()),
    };

    switch (q.type) {
      case BankQuestionType.text:
        base['correct_answer'] = q.textAnswerController.text.trim();
        break;
      case BankQuestionType.tf:
        base['correct_answer'] = q.tfCorrectIsTrue! ? 'True' : 'False';
        break;
      case BankQuestionType.mcq:
        base['choices'] = List.generate(q.choices.length, (idx) {
          return {
            'text': q.choices[idx].textController.text.trim(),
            'is_correct': idx == q.correctChoiceIndex,
          };
        }).where((c) => (c['text'] as String).isNotEmpty).toList();
        break;
    }
    return base;
  }

  Future<void> _upload() async {
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

      if (q.type == BankQuestionType.text) {
        if (q.textAnswerController.text.trim().isEmpty) {
          _showMessage('اكتب إجابة السؤال المقالي رقم $n');
          return;
        }
      } else if (q.type == BankQuestionType.tf) {
        if (q.tfCorrectIsTrue == null) {
          _showMessage('اختر الإجابة الصحيحة (صح/خطأ) للسؤال رقم $n');
          return;
        }
      } else if (q.type == BankQuestionType.mcq) {
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

    setState(() => _uploading = true);

    final repo = getIt<TeacherRepo>();
    int uploaded = 0;
    String? errorMsg;

    for (final q in _questions) {
      final result = await repo.addBankQuestion(_questionBody(q));
      var failed = false;
      result.when(
        success: (_) => uploaded++,
        failure: (_) {
          failed = true;
          errorMsg = 'تعذّر رفع السؤال رقم ${uploaded + 1}';
        },
      );
      if (failed) break;
    }

    if (!mounted) return;
    setState(() => _uploading = false);

    if (errorMsg != null) {
      _showMessage('$errorMsg (تم رفع $uploaded من ${_questions.length})');
      return;
    }

    _showMessage('تمت إضافة الأسئلة بنجاح');
    Navigator.pop(context, true); 
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
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.only(top: 20, bottom: 10),
                    itemCount: _questions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _questions.length) {
                        return _buildAddQuestionButton();
                      }
                      return _buildQuestionCard(index);
                    },
                  ),
                ),
                _buildUploadButton(),
                const SizedBox(height: 40),
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
          'أسئلة إضافية: ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: "Arabic Typesetting",
            fontWeight: FontWeight.w300,
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
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(BankQuestionModel q) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<BankQuestionType>(
          value: q.type,
          isDense: true,
          dropdownColor: AppColors.kSurfaceColor,
          iconEnabledColor: Colors.white70,
          iconSize: 25,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          items: BankQuestionType.values
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

  Widget _buildBodyByType(BankQuestionModel q) {
    switch (q.type) {
      case BankQuestionType.text:
        return _buildTextAnswer(q);
      case BankQuestionType.tf:
        return _buildTrueFalse(q);
      case BankQuestionType.mcq:
        return _buildChoices(q);
    }
  }

  Widget _buildTextAnswer(BankQuestionModel q) {
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

  Widget _buildTrueFalse(BankQuestionModel q) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTfRow(q, isTrue: true, label: 'صح'),
        const SizedBox(height: 9),
        _buildTfRow(q, isTrue: false, label: 'خطأ'),
      ],
    );
  }

  Widget _buildTfRow(BankQuestionModel q,
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

  Widget _buildChoices(BankQuestionModel q) {
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

  Widget _buildUploadButton() {
    return Center(
      child: SizedBox(
        width: 332,
        height: 54,
        child: ElevatedButton(
          onPressed: _uploading ? null : _upload,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.kPrimaryColor,
            disabledBackgroundColor: AppColors.kPrimaryColor.withOpacity(0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: _uploading
              ? const SizedBox(
                  width: 20,
                  height: 26,
                  child: CircularProgressIndicator(
                      color: Colors.black, strokeWidth: 3),
                )
              : const Text(
                  'إضافة ',
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