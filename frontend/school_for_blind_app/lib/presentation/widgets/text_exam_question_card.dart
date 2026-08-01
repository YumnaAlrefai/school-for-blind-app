import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/exam_question.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';
import 'package:school_for_blind_app/presentation/widgets/input_section.dart';

class TextExamQuestionCard extends StatefulWidget {
  final ExamQuestion question;
  final int totalQuestions;
  final String currentAnswer;
  final Function(String text) onAnswerChanged;
  final Function(String? audioPath) onAudioChanged;

  const TextExamQuestionCard({
    super.key,
    required this.question,
    required this.totalQuestions,
    required this.currentAnswer,
    required this.onAnswerChanged,
    required this.onAudioChanged,
  });

  @override
  State<TextExamQuestionCard> createState() => _TextExamQuestionCardState();
}

class _TextExamQuestionCardState extends State<TextExamQuestionCard> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.currentAnswer);
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    widget.onAnswerChanged(_controller.text);
  }

  @override
  void didUpdateWidget(covariant TextExamQuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentAnswer != _controller.text) {
      _controller.removeListener(_onTextChanged);
      _controller.text = widget.currentAnswer;
      _controller.addListener(_onTextChanged);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${widget.question.questionNumber}/${widget.totalQuestions}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 32.sp,
                      ),
                    ),
                    Text(
                      '${widget.question.mark} درجات',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontSize: 32.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                Center(
                  child: Text(
                    '"${widget.question.text}"',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
                SizedBox(height: 25.h),
                InputSection(
                  hintText: 'أدخل إجابتك..',
                  controller: _controller,
                  audioFilePrefix:
                      'exam_question_${widget.question.questionNumber}',
                  onAudioChanged: widget.onAudioChanged,
                ),
              ],
            ),
          ),
          GlassEffect(borderRadius: BorderRadius.circular(15.r)),
        ],
      ),
    );
  }
}
