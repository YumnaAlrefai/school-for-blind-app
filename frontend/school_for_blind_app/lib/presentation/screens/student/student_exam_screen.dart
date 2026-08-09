import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:school_for_blind_app/core/services/server_time_service.dart';
import 'package:school_for_blind_app/core/services/exam_join_store.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/core/services/exam_submit_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exam_questions_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/exam_submission_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/models/student/exam_question.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/student/quiz_timer.dart';

import '../../widgets/student/exam_questions_list.dart';

class StudentExamScreen extends StatefulWidget {
  final int subjectId;
  final int examId;
  final int totalQuestions;
  final int durationMinutes;
  final DateTime examDate;

  const StudentExamScreen({
    super.key,
    required this.examId,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.examDate,
    required this.subjectId,
  });

  @override
  State<StudentExamScreen> createState() => _StudentExamScreenState();
}

class _StudentExamScreenState extends State<StudentExamScreen> {
  static const int _joinWindowMinutes = 10;

  final Map<int, dynamic> _studentAnswers = {};
  Timer? _countdownTimer;
  int _remainingSeconds = 0;
  bool _isTimeUp = false;
  bool _isCheckingAccess = true;
  bool _accessDenied = false;

  @override
  void initState() {
    super.initState();
    _checkAccessAndInit();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkAccessAndInit() async {
    final alreadySubmitted = await ExamSubmitStore.isSubmitted(widget.examId);
    if (alreadySubmitted) {
      _denyAccess('لقد قمت بتسليم هذا الاختبار مسبقاً.');
      return;
    }
    if (alreadySubmitted) {
      _denyAccess('لقد قمت بتسليم هذا الاختبار مسبقاً.');
      return;
    }

    final now = ServerTimeService.instance.now();
    final start = widget.examDate;
    final end = start.add(Duration(minutes: widget.durationMinutes));
    final joinDeadline = start.add(const Duration(minutes: _joinWindowMinutes));

    if (now.isBefore(start)) {
      _denyAccess('لم يبدأ هذا الاختبار بعد.');
      return;
    }
    if (now.isAfter(end)) {
      _denyAccess('انتهى وقت هذا الاختبار.');
      return;
    }

    final alreadyJoined = await ExamJoinStore.isJoined(widget.examId);
    if (now.isAfter(joinDeadline) && !alreadyJoined) {
      _denyAccess('انتهت مهلة الدخول لهذا الاختبار (10 دقائق من وقت بدايته).');
      return;
    }

    if (!alreadyJoined) {
      await ExamJoinStore.markJoined(widget.examId);
    }

    _remainingSeconds = end.difference(now).inSeconds.clamp(0, 1 << 30);
    setState(() {
      _isCheckingAccess = false;
    });
  }

  void _denyAccess(String message) {
    setState(() {
      _isCheckingAccess = false;
      _accessDenied = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getIt<VoiceServices>().speak(message);
    });
  }

  void _startTimer(List<ExamQuestion> questions) {
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
          'انتهى وقت الاختبار تماماً. جارٍ تسليم إجاباتك تلقائياً.',
        );
        _autoSubmit(questions);
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

  void _autoSubmit(List<ExamQuestion> questions) async {
    if (!mounted) return;
    try {
      final formData = await _prepareExamBody(questions);
      if (mounted) {
        context.read<ExamSubmissionCubit>().emitSubmitExam(formData);
      }
    } catch (e) {
      getIt<VoiceServices>().speak('حدث خطأ أثناء التسليم التلقائي');
    }
  }

  Future<FormData> _prepareExamBody(List<ExamQuestion> questions) async {
    final Map<String, dynamic> formMap = {'exam_id': widget.examId};

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
            ? 'true'
            : 'false';
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
    if (_isCheckingAccess) {
      return Scaffold(
        appBar: const CustomAppBar(helpMessage: '', showBackButton: false),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_accessDenied) {
      return Scaffold(
        appBar: const CustomAppBar(helpMessage: '', showBackButton: true),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Text(
              'لا يمكنك الدخول لهذا الاختبار الآن.',
              textAlign: TextAlign.center,
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
        ),
      );
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<ExamQuestionsCubit>()..emitGetExamQuestions(widget.examId),
        ),
        BlocProvider(create: (context) => getIt<ExamSubmissionCubit>()),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          getIt<VoiceServices>().speak(
            'إذا أردت المغادرة عليك تسليم الاختبار أوَّلاً',
          );
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: const CustomAppBar(helpMessage: '', showBackButton: false),
          body: BlocListener<ExamSubmissionCubit, ResultState<dynamic>>(
            listener: (context, submitState) {
              submitState.whenOrNull(
                success: (data) async {
                  if (data != null && data.status == 'success') {
                    await ExamSubmitStore.markSubmitted(widget.examId);
                    getIt<VoiceServices>().speak('تم تسليم الاختبار بنجاح!');
                    if (context.mounted) Navigator.pop(context);
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
                  ExamQuestionsCubit,
                  ResultState<ExamQuestionsResponse>
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
                          NetworkExceptions.getErrorMessage(networkException),
                        );
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.h),
                          child: Center(
                            child: IconButton(
                              onPressed: () => context
                                  .read<ExamQuestionsCubit>()
                                  .emitGetExamQuestions(widget.examId),
                              icon: const Icon(Icons.refresh),
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              iconSize: 35,
                            ),
                          ),
                        );
                      },
                      success: (ExamQuestionsResponse response) {
                        final questions = response.data;
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_countdownTimer == null) {
                            getIt<VoiceServices>().speak(
                              'الاختبار جارٍ الآن. الوقت المتبقي أمامك ${(_remainingSeconds / 60).ceil()} دقيقة تقريباً.',
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
                              child: ExamQuestionsList(
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
                                      ExamSubmissionCubit,
                                      ResultState<dynamic>
                                    >(
                                      builder: (context, submitState) {
                                        return submitState.maybeWhen(
                                          loading: () => Center(
                                            child: CircularProgressIndicator(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                            ),
                                          ),
                                          orElse: () => PrimaryButton(
                                            title: 'إنهاء وتسليم الاختبار',
                                            width: 300.w,
                                            height: 100.h,
                                            fontSize: 48.sp,
                                            onPressed: () async {
                                              getIt<VoiceServices>().speak(
                                                'جاري رفع الإجابات...',
                                              );
                                              try {
                                                final formData =
                                                    await _prepareExamBody(
                                                      questions,
                                                    );
                                                if (context.mounted) {
                                                  context
                                                      .read<
                                                        ExamSubmissionCubit
                                                      >()
                                                      .emitSubmitExam(formData);
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
      ),
    );
  }
}
