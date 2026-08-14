import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/quiz_questions_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/models/student/quiz_questions.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/student/quiz_questions_list.dart';
import 'package:school_for_blind_app/presentation/widgets/student/quiz_timer.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/quiz_submission_cubit.dart';
import 'package:http_parser/http_parser.dart';

class StudentQuizScreen extends StatefulWidget {
  final int subjectId;
  final String subjectName;
  final int quizId;
  final int totalQuestions;
  final int durationMinutes;

  const StudentQuizScreen({
    super.key,
    required this.quizId,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.subjectId,
    required this.subjectName,
  });

  @override
  State<StudentQuizScreen> createState() => _StudentQuizScreenState();
}

class _StudentQuizScreenState extends State<StudentQuizScreen> {
  final Map<int, dynamic> _studentAnswers = {};
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _isTimeUp = false;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.durationMinutes * 60;
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startTimer(List<Question> questions) {
    if (_countdownTimer != null) return;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
        _checkAndPlayVoiceAlerts(_remainingSeconds);
      } else {
        _countdownTimer?.cancel();
        setState(() {
          _isTimeUp = true;
        });
        getIt<VoiceServices>().speak(
          'انتهى وقت الاختبار تماماً. تم إيقاف إمكانية التعديل، يرجى الضغط على زر إنهاء وتسليم الكويز أسفل الشاشة لإرسال إجاباتك.',
        );
      }
    });
  }

  void _checkAndPlayVoiceAlerts(int secondsLeft) {
    if (secondsLeft == 300) {
      getIt<VoiceServices>().speak(
        'تنبيه، متبقي خمس دقائق على نهاية وقت الاختبار.',
      );
    } else if (secondsLeft == 60) {
      getIt<VoiceServices>().speak(
        'تنبيه، متبقي دقيقة واحدة فقط، يرجى إنهاء الإجابات.',
      );
    }
  }

  Future<FormData> _prepareQuizBody(List<Question> questions) async {
    final Map<String, dynamic> formMap = {'quiz_id': widget.quizId};

    int index = 0;
    for (var question in questions) {
      final String currentType = question.type.toUpperCase();
      final answer = _studentAnswers[question.id];

      formMap['answers[$index][question_id]'] = question.id;

      if (currentType == 'MCQ') {
        formMap['answers[$index][choice_id]'] = answer;
        formMap['answers[$index][text_answer]'] = null;
        formMap['answers[$index][audio_answer]'] = null;
      } else if (currentType == 'TF') {
        formMap['answers[$index][choice_id]'] = null;
        formMap['answers[$index][text_answer]'] = answer == true
            ? 'True'
            : 'False';
        formMap['answers[$index][audio_answer]'] = null;
      } else if (currentType == 'TEXT') {
        final Map<String, dynamic>? textData = answer as Map<String, dynamic>?;
        final String? audioPath = textData?['audio'];
        final String? textAnswer = textData?['text']?.trim();

        formMap['answers[$index][choice_id]'] = null;

        if (audioPath != null && audioPath.isNotEmpty) {
          final String fileName = audioPath.split('/').last;

          formMap['answers[$index][audio_answer]'] =
              await MultipartFile.fromFile(
                audioPath,
                filename: fileName,
                contentType: MediaType('audio', 'x-m4a'),
              );
          formMap['answers[$index][text_answer]'] = null;
        } else if (textAnswer != null && textAnswer.isNotEmpty) {
          formMap['answers[$index][audio_answer]'] = null;
          formMap['answers[$index][text_answer]'] = textAnswer;
        } else {
          formMap['answers[$index][audio_answer]'] = null;
          formMap['answers[$index][text_answer]'] = '';
        }
      }
      index++;
    }

    return FormData.fromMap(formMap);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<QuizQuestionsCubit>()..emitGetQuizQuestions(widget.quizId),
        ),
        BlocProvider(create: (context) => getIt<QuizSubmissionCubit>()),
      ],
      child: BlocBuilder<QuizQuestionsCubit, ResultState<QuizQuestionsResponse>>(
        builder: (context, state) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (didPop, result) async {
              if (didPop) return;
              getIt<VoiceServices>().speak(
                'إذا أردت المغادرة عليك تسليم الكويز أوَّلاً',
              );
            },
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: const CustomAppBar(
                helpMessage:
                    ' شاشة الكويز، تظهر لك الأسئلة مع مؤقِّت انتهاء الوقت، المؤقِّت يبدأ عند انضمامكَ للكويز، السؤال النصي يمكنك الإجابة عنه كتابةً أو عن طريق تسجيل مقطع صوتي، والسؤال الاختياري وسؤال الصح والخطأ يجب أن تختار الخيار المناسب، عند الانتهاء من الحل اضغط زر تسليم الأجوبة، وانتبِهْ من أنك حللتَ كل الأسئلة',
                showBackButton: false,
              ),
              body: BlocListener<QuizSubmissionCubit, ResultState<dynamic>>(
                listener: (context, submitState) {
                  submitState.whenOrNull(
                    success: (data) {
                      if (data != null && data.status == 'success') {
                        getIt<VoiceServices>().speak('تم تسليم الكويز بنجاح!');
                        Navigator.pop(context);
                        Navigator.pushNamed(
                          context,
                          AppRoutes.kStudentSubjectDetailsScreen,
                          arguments: {
                            'subjectId': widget.subjectId,
                            'subjectName': widget.subjectName,
                          },
                        );
                      }
                    },
                    failure: (networkException) {
                      getIt<VoiceServices>().speak(
                        NetworkExceptions.getErrorMessage(networkException),
                      );
                    },
                  );
                },
                child:
                    BlocBuilder<
                      QuizQuestionsCubit,
                      ResultState<QuizQuestionsResponse>
                    >(
                      builder: (context, state) {
                        return state.when(
                          idle: () => const SizedBox(),
                          loading: () => Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
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
                              child: Center(
                                child: IconButton(
                                  onPressed: () => context
                                      .read<QuizQuestionsCubit>()
                                      .emitGetQuizQuestions(widget.quizId),
                                  icon: const Icon(Icons.refresh),
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primaryContainer,
                                  iconSize: 35,
                                ),
                              ),
                            );
                          },
                          success: (QuizQuestionsResponse response) {
                            final questions = response.questions;
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (_countdownTimer == null) {
                                getIt<VoiceServices>().speak(
                                  'بدأ وقت الاختبار. لديك ${widget.durationMinutes} دقائق للإجابة على الأسئلة.',
                                );
                                _startTimer(questions);
                              }
                            });
                            return Column(
                              children: [
                                SizedBox(height: 10.h),
                                QuizTimer(remainingSeconds: _remainingSeconds),
                                SizedBox(height: 10.h),
                                Expanded(
                                  child: QuizQuestionsList(
                                    questions: questions,
                                    studentAnswers: _studentAnswers,
                                    totalQuestions: widget.totalQuestions,
                                    isTimeUp: _isTimeUp,
                                    onAnswerChanged: (questionId, value) {
                                      setState(() {
                                        _studentAnswers[questionId] = value;
                                      });
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(16.w),
                                  child: SizedBox(
                                    width: 352.w,
                                    height: 70.h,
                                    child:
                                        BlocBuilder<
                                          QuizSubmissionCubit,
                                          ResultState<dynamic>
                                        >(
                                          builder: (context, submitState) {
                                            return submitState.maybeWhen(
                                              loading: () => Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Theme.of(
                                                        context,
                                                      ).colorScheme.primary,
                                                    ),
                                              ),
                                              orElse: () => PrimaryButton(
                                                title: 'إنهاء وتسليم الكويز',
                                                width: 300.w,
                                                height: 100.h,
                                                fontSize: 48.sp,
                                                onPressed: () async {
                                                  getIt<VoiceServices>().speak(
                                                    'جاري رفع الإجابات...',
                                                  );
                                                  try {
                                                    final FormData formData =
                                                        await _prepareQuizBody(
                                                          questions,
                                                        );
                                                    if (context.mounted) {
                                                      context
                                                          .read<
                                                            QuizSubmissionCubit
                                                          >()
                                                          .emitSubmitQuiz(
                                                            formData,
                                                          );
                                                    }
                                                  } catch (e) {
                                                    getIt<VoiceServices>().speak(
                                                      'حدث خطأ أثناء تحضير الملفات',
                                                    );
                                                  }
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
              ),
            ),
          );
        },
      ),
    );
  }
}
