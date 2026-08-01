import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/quiz_info_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/student/glass_effect.dart';

class QuizShowDialog {
  static Future<dynamic> buildQuizShowDialog(
    BuildContext context,
    int subjectId,
    String subjectName,
    int teacherId,
    int lessonId,
    String lessonTitle,
  ) {
    final quizCubit = context.read<QuizInfoCubit>();
    quizCubit.emitGetQuizInfo(subjectId, teacherId, lessonId);

    return showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: quizCubit,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          child: Container(
            width: 450.w,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Stack(
              fit: StackFit.loose,
              children: [
                Positioned.fill(
                  child: GlassEffect(borderRadius: BorderRadius.circular(15.r)),
                ),
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.quiz_rounded,
                                color: Theme.of(context).colorScheme.primary,
                                size: 36.r,
                              ),
                              SizedBox(width: 20.w),
                              Text(
                                'كويز',
                                style: TextStyle(
                                  fontSize: 38.sp,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            iconSize: 20,
                            style: IconButton.styleFrom(
                              backgroundColor: const Color(0xffff3333),
                            ),
                            onPressed: () {
                              Navigator.pop(dialogContext);
                            },
                            icon: const Icon(Icons.close, color: Colors.white),
                          ),
                        ],
                      ),
                      const Divider(thickness: 0.2),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 12.h,
                          horizontal: 16.w,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.background.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(15.r),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.onBackground,
                            width: 0.2,
                          ),
                        ),
                        child: Text(
                          lessonTitle,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.kMediumPrimary(context),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      BlocBuilder<QuizInfoCubit, ResultState<dynamic>>(
                        builder: (context, state) {
                          return state.when(
                            idle: () => const SizedBox(),
                            loading: () => Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.h),
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            failure: (networkException) {
                              getIt<VoiceServices>().speak(
                                NetworkExceptions.getErrorMessage(
                                  networkException,
                                ),
                              );
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                child: IconButton(
                                  onPressed: () => context
                                      .read<QuizInfoCubit>()
                                      .emitGetQuizInfo(
                                        subjectId,
                                        teacherId,
                                        lessonId,
                                      ),
                                  icon: const Icon(Icons.refresh),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  iconSize: 35,
                                ),
                              );
                            },
                            success: (quizResponse) {
                              if (quizResponse.status == 'error') {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Text(
                                    quizResponse.message ??
                                        'هذا الكويز غير متاح حالياً',
                                    textAlign: TextAlign.center,
                                    style: AppTextStyles.kMediumPrimary(
                                      context,
                                    ),
                                  ),
                                );
                              }
                              final quizData = quizResponse?.data;
                              if (quizData == null) {
                                return Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  child: Text(
                                    quizResponse.message ??
                                        'لا تتوفر تفاصيل لهذا الكويز',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 34.sp,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                    ),
                                  ),
                                );
                              }
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildInfoCard(
                                          context,
                                          icon: Icons.emoji_events,
                                          title: 'الدرجة:',
                                          value: '${quizData.totalMark} درجة',
                                          iconColor: Colors.amber,
                                        ),
                                      ),
                                      SizedBox(width: 10.w),
                                      Expanded(
                                        child: _buildInfoCard(
                                          context,
                                          icon: Icons.help,
                                          title: 'الأسئلة:',
                                          value:
                                              '${quizData.totalQuestions} سؤال',
                                          iconColor: Colors.blue,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 10.h),
                                  _buildInfoCard(
                                    context,
                                    icon: Icons.timer,
                                    title: 'المدة:',
                                    value: '${quizData.durationMinutes} دقيقة',
                                    iconColor: const Color(0xFFFF3333),
                                  ),
                                  SizedBox(height: 12.h),
                                  PrimaryButton(
                                    title: 'بدء الآن',
                                    width: 155.w,
                                    height: 65.h,
                                    onPressed: () {
                                      Navigator.pop(dialogContext);
                                      Navigator.pop(dialogContext);
                                      Navigator.pushNamed(
                                        context,
                                        AppRoutes.kStudentQuizScreen,
                                        arguments: [
                                          subjectId,
                                          subjectName,
                                          quizData.quizId,
                                          quizData.totalQuestions,
                                          quizData.durationMinutes,
                                        ],
                                      );
                                    },
                                    fontSize: 48.sp,
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildInfoCard(
  BuildContext context, {
  required IconData icon,
  required String title,
  required String value,
  required Color iconColor,
}) {
  return Container(
    padding: EdgeInsets.all(12.w),
    width: 140.w,
    height: 133.h,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.background.withOpacity(0.4),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: Theme.of(context).colorScheme.onBackground,
        width: 0.2,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: iconColor, size: 30.r),
            SizedBox(width: 12.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 35.sp,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 35.sp,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    ),
  );
}
