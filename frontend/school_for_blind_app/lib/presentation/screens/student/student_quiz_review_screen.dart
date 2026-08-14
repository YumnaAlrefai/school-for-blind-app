import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/quiz_review_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/data/models/student/quiz_review.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/quiz_review_list.dart';

class StudentQuizReviewScreen extends StatelessWidget {
  final int quizId;
  final String title;

  const StudentQuizReviewScreen({
    super.key,
    required this.quizId,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<QuizReviewCubit>()..emitGetQuizReview(quizId),
      child: Scaffold(
        appBar: CustomAppBar(
          helpMessage:
              'أنتَ الآنَ في صَفْحَةِ عَرْضِ الحَلِّ. تُعْرَضُ أَمامَكَ الأَسْئِلَةُ مع إجاباتِها الصَّحيحَةِ لِلنَّشاطِ الّذي اخْتَرْتَهُ. يُمكنُكَ اسْتِعْراضُ الإجاباتِ تِباعاً، أو الضَّغْطُ على زِرِّ الرُّجوعِ في الأعْلى للعودَةِ لِلْمَكْتَبَةِ.',
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocBuilder<QuizReviewCubit, ResultState<QuizReviewResponse>>(
          builder: (context, state) {
            return state.when(
              idle: () => const SizedBox(),
              loading: () => const Center(child: CircularProgressIndicator()),
              failure: (networkException) {
                getIt<VoiceServices>().speak(
                  NetworkExceptions.getErrorMessage(networkException),
                );
                return Center(
                  child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                    ),
                    onPressed: () => context
                        .read<QuizReviewCubit>()
                        .emitGetQuizReview(quizId),
                    icon: Icon(
                      Icons.refresh,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    iconSize: 35,
                  ),
                );
              },
              success: (QuizReviewResponse response) {
                return QuizReviewList(questions: response.data.questions);
              },
            );
          },
        ),
      ),
    );
  }
}
