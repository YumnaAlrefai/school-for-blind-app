import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/channels_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/student_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/subject_progress_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/channel_model.dart';
import 'package:school_for_blind_app/data/models/student/lesson.dart';
import 'package:school_for_blind_app/data/models/student/subject_progress.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/student/glass_effect.dart';

class SubjectDetailsCard extends StatefulWidget {
  final int subjectId;
  final String subjectName;

  const SubjectDetailsCard({
    super.key,
    required this.subjectName,
    required this.subjectId,
  });

  @override
  State<SubjectDetailsCard> createState() => _SubjectDetailsCardState();
}

class _SubjectDetailsCardState extends State<SubjectDetailsCard> {
  bool _isLoadingChannel = false;
  bool _isLoadingDiscussion = false;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 430.h,
          width: 378.w,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.onBackground,
              width: 0.2.w,
            ),
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.subjectName,
                style: AppTextStyles.kBigPrimary(context),
              ),
              BlocBuilder<LessonsCubit, ResultState<dynamic>>(
                builder: (context, lessonsState) {
                  String teacherName = 'جاري التحميل...';

                  lessonsState.maybeWhen(
                    success: (data) {
                      if (data is SubjectLessonsResponse &&
                          data.lessons.isNotEmpty) {
                        teacherName = data.lessons.first.teacherName;
                      } else if (data is List<Lesson> && data.isNotEmpty) {
                        teacherName = data.first.teacherName;
                      }
                    },
                    orElse: () {},
                  );

                  return BlocBuilder<
                    SubjectProgressCubit,
                    ResultState<SubjectProgress>
                  >(
                    builder: (context, state) {
                      return state.when(
                        idle: () => _buildHeaderRow(teacherName, '0 / 0'),
                        loading: () => _buildHeaderRow(teacherName, '0 / 0'),
                        success: (progressData) => _buildHeaderRow(
                          teacherName,
                          progressData.progressText,
                        ),
                        failure: (error) =>
                            _buildHeaderRow('غير معروف', '0 / 0'),
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 30.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                    title: 'اختبارات',
                    width: 170,
                    height: 62,
                    fontSize: 40,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentExamsScreen,
                      arguments: widget.subjectId,
                    ),
                  ),
                  PrimaryButton(
                    title: 'المكتبة',
                    width: 170,
                    height: 62,
                    fontSize: 40,
                    onPressed: () => Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentLibraryScreen,
                      arguments: widget.subjectId,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PrimaryButton(
                    title: 'قناة المدرس',
                    width: 170,
                    height: 62,
                    fontSize: 40,
                    isLoading: _isLoadingChannel,
                    onPressed: () =>
                        _navigateToChannel(context, isDiscussion: false),
                  ),
                  PrimaryButton(
                    title: 'مجموعة المناقشة',
                    width: 170,
                    height: 62,
                    fontSize: 40,
                    isLoading: _isLoadingDiscussion,
                    onPressed: () =>
                        _navigateToChannel(context, isDiscussion: true),
                  ),
                ],
              ),
            ],
          ),
        ),
        const GlassEffect(borderRadius: BorderRadius.all(Radius.circular(20))),
      ],
    );
  }

  Widget _buildHeaderRow(String teacher, String progress) {
    return Column(
      children: [
        Text(teacher, style: TextStyle(fontSize: 42.sp)),
        Text('عدد الدروس: $progress', style: TextStyle(fontSize: 42.sp)),
      ],
    );
  }

  Future<void> _navigateToChannel(
    BuildContext context, {
    required bool isDiscussion,
  }) async {
    setState(() {
      if (isDiscussion) {
        _isLoadingDiscussion = true;
      } else {
        _isLoadingChannel = true;
      }
    });

    final cubit = getIt<ChannelsCubit>();
    cubit.getAllChannels();

    final state = await cubit.stream.firstWhere(
      (s) => s.maybeWhen(
        success: (_) => true,
        failure: (_) => true,
        orElse: () => false,
      ),
    );

    if (!context.mounted) {
      cubit.close();
      return;
    }

    state.when(
      idle: () {},
      loading: () {},
      success: (channelsResponse) {
        ChannelModel? channel;
        try {
          channel = channelsResponse.data.firstWhere(
            (c) => c.subjectId == widget.subjectId,
          );
        } catch (_) {
          channel = null;
        }

        if (channel == null) {
          getIt<VoiceServices>().speak('لا توجد محادثة مرتبطة بهذه المادة');
          return;
        }

        final currentUserId = getIt<StudentCubit>().currentStudent?.id ?? 302;

        if (isDiscussion) {
          final discussion = channel.discussion;
          if (discussion == null) {
            getIt<VoiceServices>().speak('لا توجد مجموعة نقاش لهذه المادة');
            return;
          }
          Navigator.pushNamed(
            context,
            AppRoutes.kStudentMessagesScreen,
            arguments: {
              'channelId': discussion.id,
              'channelName': discussion.name,
              'currentUserId': currentUserId,
              'icon': Icons.group,
              'isChannel': false,
            },
          );
        } else {
          final title = channel!.subject?.name ?? channel.name;
          Navigator.pushNamed(
            context,
            AppRoutes.kStudentMessagesScreen,
            arguments: {
              'channelId': channel.id,
              'channelName': title,
              'currentUserId': currentUserId,
              'icon': _getChannelIcon(title),
              'isChannel': true,
            },
          );
        }
      },
      failure: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر تحميل بيانات المحادثة')),
        );
      },
    );

    cubit.close();

    if (mounted) {
      setState(() {
        _isLoadingChannel = false;
        _isLoadingDiscussion = false;
      });
    }
  }

  final Map<String, IconData> _subjectIcons = {
    'الفلسفة': Icons.psychology,
    'التاريخ': Icons.history_edu,
    'الجغرافيا': Icons.public,
    'اللغة العربية': Icons.auto_stories,
    'اللغة الإنكليزية': Icons.translate,
    'اللغة الفرنسية': Icons.language,
    'التربية الدينية': Icons.mosque,
    'الرياضيات': Icons.functions,
    'الفيزياء والكيمياء': Icons.science,
    'علم الأحياء والأرض': Icons.biotech,
  };

  IconData _getChannelIcon(String channelName) {
    for (var entry in _subjectIcons.entries) {
      if (channelName.contains(entry.key)) return entry.value;
    }
    return Icons.announcement;
  }
}
