import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/offline_lessons_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/lesson_records_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/saves_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/lesson.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/widgets/student/glass_effect.dart';
import 'package:school_for_blind_app/presentation/widgets/student/quiz_show_dialog.dart';

class LessonCard extends StatefulWidget {
  final Lesson lesson;
  final int lessonNumber;
  final bool viewMenu;
  final String route;
  final dynamic args;
  final bool isOffline;
  final int subjectId;
  final String subjectName;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.lessonNumber,
    required this.viewMenu,
    required this.route,
    this.args,
    this.isOffline = false,
    this.subjectId = 0,
    required this.subjectName,
  });

  @override
  State<LessonCard> createState() => _LessonCardState();
}

class _LessonCardState extends State<LessonCard> {
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.lesson.isSaved;
  }

  @override
  void didUpdateWidget(covariant LessonCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.lesson.isSaved != widget.lesson.isSaved) {
      _isSaved = widget.lesson.isSaved;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<SavesCubit, SavesState>(
          listenWhen: (previous, current) {
            return current.maybeWhen(
              success: (id, type, isSaved) =>
                  id == widget.lesson.id && type == "lesson",
              failure: (_) => true,
              orElse: () => false,
            );
          },
          listener: (context, state) {
            state.whenOrNull(
              success: (id, type, isSaved) {
                setState(() {
                  _isSaved = isSaved;
                });
                getIt<VoiceServices>().speak(
                  isSaved ? 'تم حفظ الدرس' : 'تمت إزالة الدرس من المحفوظات',
                );
              },
              failure: (networkExceptions) {
                setState(() {
                  _isSaved = widget.lesson.isSaved;
                });
                getIt<VoiceServices>().speak(
                  'عذراً، فشلت العملية. تحقق من الاتصال',
                );
              },
            );
          },
        ),
        BlocListener<OfflineLessonsCubit, OfflineLessonsState>(
          listenWhen: (previous, current) =>
              (current is OfflineLessonDownloadSuccess &&
                  current.lessonId == widget.lesson.id) ||
              (current is OfflineLessonDownloadFailure &&
                  current.lessonId == widget.lesson.id),
          listener: (context, state) {
            if (state is OfflineLessonDownloadSuccess &&
                state.lessonId == widget.lesson.id) {
              getIt<VoiceServices>().speak('تم تنزيل الدرس بنجاح');
            } else if (state is OfflineLessonDownloadFailure &&
                state.lessonId == widget.lesson.id) {
              getIt<VoiceServices>().speak('فشل تنزيل الدرس، تحقق من الاتصال');
            }
          },
        ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            widget.route,
            arguments: widget.args,
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 354.w,
                height: 97.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                  ),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 0.2.w,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(right: 40.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.lesson.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.kMediumPrimary(context),
                        ),
                      ),
                      widget.viewMenu
                          ? BlocBuilder<
                              OfflineLessonsCubit,
                              OfflineLessonsState
                            >(
                              builder: (context, offlineState) {
                                final offlineCubit = context
                                    .read<OfflineLessonsCubit>();
                                final isDownloaded = offlineCubit.isDownloaded(
                                  widget.lesson.id,
                                );

                                return PopupMenuButton<String>(
                                  icon: const Icon(Icons.more_vert, size: 34),
                                  onSelected: (value) async {
                                    if (value == 'كويز') {
                                      QuizShowDialog.buildQuizShowDialog(
                                        context,
                                        widget.subjectId,
                                        widget.subjectName,
                                        widget.lesson.teacherId,
                                        widget.lesson.id,
                                        widget.lesson.title,
                                      );
                                      return;
                                    }

                                    if (value == 'تنزيل') {
                                      if (isDownloaded ||
                                          offlineCubit.state
                                              is OfflineLessonDownloadProgress) {
                                        return;
                                      }

                                      try {
                                        final lessonRecordsCubit =
                                            getIt<LessonRecordsCubit>();
                                        final response =
                                            await lessonRecordsCubit.studentRepo
                                                .getLessonRecords(
                                                  widget.lesson.id,
                                                );

                                        await response.when(
                                          success: (data) async {
                                            debugPrint(
                                              '🟡 عدد الـ records المستلمة: ${data.record.length}',
                                            );
                                            if (data.record.isEmpty) {
                                              getIt<VoiceServices>().speak(
                                                'لا توجد مقاطع صوتية لهذا الدرس',
                                              );
                                              return;
                                            }
                                            debugPrint(
                                              '🟡 بدء استدعاء downloadLesson...',
                                            );
                                            await offlineCubit.downloadLesson(
                                              lesson: widget.lesson,
                                              subjectId: widget.subjectId,
                                              records: data.record,
                                            );
                                            debugPrint(
                                              '🟢 انتهى استدعاء downloadLesson',
                                            );
                                          },
                                          failure: (networkException) {
                                            getIt<VoiceServices>().speak(
                                              'فشل جلب بيانات الدرس',
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        debugPrint('خطأ أثناء التنزيل: $e');
                                        getIt<VoiceServices>().speak(
                                          'حدث خطأ غير متوقع أثناء التنزيل',
                                        );
                                      }
                                      return;
                                    }

                                    if (widget.isOffline) {
                                      await offlineCubit.toggleSavedLesson(
                                        widget.lesson.id,
                                        subjectId: widget.subjectId,
                                      );
                                    } else {
                                      final savesCubit = context
                                          .read<SavesCubit>();
                                      if (value == 'حفظ') {
                                        await savesCubit.addToSaved(
                                          id: widget.lesson.id,
                                          type: "lesson",
                                        );
                                      } else if (value == 'إلغاء الحفظ') {
                                        await savesCubit.removeFromSaved(
                                          id: widget.lesson.id,
                                          type: "lesson",
                                        );
                                      }
                                    }
                                  },
                                  itemBuilder: (context) {
                                    return <PopupMenuEntry<String>>[
                                      if (!widget.lesson.isQuizSolved)
                                        PopupMenuItem<String>(
                                          value: 'كويز',
                                          child: _buildMenuRow(
                                            context,
                                            Icons.quiz,
                                            'كويز',
                                          ),
                                        ),
                                      !_isSaved
                                          ? PopupMenuItem<String>(
                                              value: 'حفظ',
                                              child: _buildMenuRow(
                                                context,
                                                Icons.bookmark_add_sharp,
                                                'حفظ',
                                              ),
                                            )
                                          : PopupMenuItem<String>(
                                              value: 'إلغاء الحفظ',
                                              child: _buildMenuRow(
                                                context,
                                                Icons.bookmark_remove,
                                                'إلغاء الحفظ',
                                              ),
                                            ),
                                      if (!widget.isOffline && !isDownloaded)
                                        PopupMenuItem<String>(
                                          value: 'تنزيل',
                                          enabled:
                                              offlineState
                                                  is! OfflineLessonDownloadProgress,
                                          child:
                                              offlineState
                                                      is OfflineLessonDownloadProgress &&
                                                  (offlineState
                                                              as OfflineLessonDownloadProgress)
                                                          .lessonId ==
                                                      widget.lesson.id
                                              ? Row(
                                                  children: [
                                                    const Icon(
                                                      Icons.download,
                                                      size: 30,
                                                      color: Colors.blue,
                                                    ),
                                                    SizedBox(width: 12.w),
                                                    Expanded(
                                                      child: Text(
                                                        'جاري التنزيل...',
                                                        style: TextStyle(
                                                          fontSize: 36,
                                                          color: Colors.blue,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              : _buildMenuRow(
                                                  context,
                                                  Icons.download,
                                                  'تنزيل',
                                                ),
                                        ),
                                    ];
                                  },
                                );
                              },
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: -25,
                right: -15,
                child: Container(
                  height: 55.h,
                  width: 55.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: Theme.of(context).colorScheme.onBackground,
                        width: 0.5.w,
                      ),
                    ),
                    color: Theme.of(context).colorScheme.surface,
                  ),
                  child: Center(
                    child: Text(
                      '${widget.lessonNumber}',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 48.sp,
                      ),
                    ),
                  ),
                ),
              ),
              const GlassEffect(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuRow(
    BuildContext context,
    IconData icon,
    String text, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 30,
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        SizedBox(width: 10.w),
        Text(text, style: TextStyle(fontSize: 36, color: color)),
      ],
    );
  }
}
