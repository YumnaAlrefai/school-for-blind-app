import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exam_solutions_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/data/models/student/exam_solution.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/exam_solutions_list.dart';

class StudentExamSolutionsScreen extends StatelessWidget {
  final int examId;
  final String title;

  const StudentExamSolutionsScreen({
    super.key,
    required this.examId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ExamSolutionsCubit>()..emitGetExamSolutions(examId),
      child: Scaffold(
        appBar: CustomAppBar(
          helpMessage:
              'أنتَ الآنَ في صَفْحَةِ عَرْضِ الحَلِّ. تُعْرَضُ أَمامَكَ الأَسْئِلَةُ مع إجاباتِها الصَّحيحَةِ لِلنَّشاطِ الّذي اخْتَرْتَهُ. يُمكنُكَ اسْتِعْراضُ الإجاباتِ تِباعاً، أو الضَّغْطُ على زِرِّ الرُّجوعِ في الأعْلى للعودَةِ لِلْمَكْتَبَةِ.',
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body:
            BlocBuilder<ExamSolutionsCubit, ResultState<ExamSolutionsResponse>>(
              builder: (context, state) {
                return state.when(
                  idle: () => const SizedBox(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  failure: (networkException) {
                    getIt<VoiceServices>().speak(
                      NetworkExceptions.getErrorMessage(networkException),
                    );
                    return Center(
                      child: IconButton(
                        onPressed: () => context
                            .read<ExamSolutionsCubit>()
                            .emitGetExamSolutions(examId),
                        icon: const Icon(Icons.refresh),
                        iconSize: 35,
                      ),
                    );
                  },
                  success: (ExamSolutionsResponse response) {
                    return ExamSolutionsList(
                      questions: response.data,
                      totalQuestions: response.data.length,
                    );
                  },
                );
              },
            ),
      ),
    );
  }
}
