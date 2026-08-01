import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exam_solutions_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/past_exam_solutions_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/mcq_solution_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/text_solution_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/true_false_solution_card.dart';

class PastExamSolutionsScreen extends StatefulWidget {
  final int examId;
  final String? title;

  const PastExamSolutionsScreen({super.key, required this.examId, this.title});

  @override
  State<PastExamSolutionsScreen> createState() =>
      _PastExamSolutionsScreenState();
}

class _PastExamSolutionsScreenState extends State<PastExamSolutionsScreen> {
  late final PastExamSolutionsCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = getIt<PastExamSolutionsCubit>();
    _cubit.getPastExamSolutions(widget.examId);
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasTitle = widget.title != null && widget.title!.isNotEmpty;

    return BlocProvider.value(
      value: _cubit,
      child: Scaffold(
        appBar: CustomAppBar(helpMessage: widget.title ?? ''),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocBuilder<PastExamSolutionsCubit, PastExamSolutionsState>(
          builder: (context, state) {
            return state.when(
              initial: () => const SizedBox.shrink(),
              loading: () => const Center(child: CircularProgressIndicator()),
              success: (questions) => ListView.builder(
                itemCount: hasTitle ? questions.length + 1 : questions.length,
                itemBuilder: (context, index) {
                  if (hasTitle && index == 0) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Text(
                        widget.title!,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.kMediumPrimary(context),
                      ),
                    );
                  }

                  final questionIndex = hasTitle ? index - 1 : index;
                  final question = questions[questionIndex];
                  final type = question.type.toLowerCase();

                  if (type == 'mcq') {
                    return McqSolutionCard(
                      question: question,
                      questionNumber: questionIndex + 1,
                      totalQuestions: questions.length,
                    );
                  } else if (type == 'tf') {
                    return TrueFalseSolutionCard(
                      question: question,
                      questionNumber: questionIndex + 1,
                      totalQuestions: questions.length,
                    );
                  }
                  return TextSolutionCard(
                    question: question,
                    questionNumber: questionIndex + 1,
                    totalQuestions: questions.length,
                  );
                },
              ),
              failure: (e) =>
                  Center(child: Text(NetworkExceptions.getErrorMessage(e))),
            );
          },
        ),
      ),
    );
  }
}
