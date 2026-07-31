import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/offline_lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/offline_lessons_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/saves_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/saves_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';

class LibraryCard extends StatefulWidget {
  final int number;
  final int id;
  final String title;
  final String itemType;
  final String route;
  final dynamic args;
  final bool isOffline;
  final bool initialIsSaved;

  const LibraryCard({
    super.key,
    required this.number,
    required this.id,
    required this.title,
    required this.itemType,
    required this.route,
    this.args,
    this.isOffline = false,
    this.initialIsSaved = true,
  });

  @override
  State<LibraryCard> createState() => _LibraryCardState();
}

class _LibraryCardState extends State<LibraryCard> {
  late bool _isSaved;

  @override
  void initState() {
    super.initState();
    _isSaved = widget.initialIsSaved;
  }

  @override
  void didUpdateWidget(covariant LibraryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIsSaved != widget.initialIsSaved) {
      setState(() {
        _isSaved = widget.initialIsSaved;
      });
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
                  id == widget.id && type == widget.itemType,
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
                if (isSaved) {
                  getIt<VoiceServices>().speak('تمت الإضافة إلى المحفوظات');
                } else {
                  getIt<VoiceServices>().speak('تمت الإزالة من المحفوظات');
                }
              },
              failure: (networkExceptions) {
                setState(() {
                  _isSaved = true;
                });
                getIt<VoiceServices>().speak(
                  NetworkExceptions.getErrorMessage(networkExceptions),
                );
              },
            );
          },
        ),
        BlocListener<OfflineLessonsCubit, OfflineLessonsState>(
          listenWhen: (previous, current) =>
              widget.isOffline &&
              current is OfflineLessonSaveToggled &&
              current.lessonId == widget.id,
          listener: (context, state) {
            if (state is OfflineLessonSaveToggled) {
              setState(() {
                _isSaved = state.isSaved;
              });
              if (state.isSaved) {
                getIt<VoiceServices>().speak('تمت الإضافة إلى المحفوظات');
              } else {
                getIt<VoiceServices>().speak('تمت الإزالة من المحفوظات');
              }
            }
          },
        ),
      ],
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(
            context,
            widget.route,
            arguments: widget.args,
          ),
          child: Container(
            width: 354.w,
            height: 97.h,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 0.2,
              ),
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: Stack(
                children: [
                  GlassEffect(borderRadius: BorderRadius.circular(15.r)),
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.w),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.surface,
                              border: Border.all(
                                color: Theme.of(context).colorScheme.onSurface,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              "${widget.number}",
                              style: TextStyle(
                                fontSize: 24.sp,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              widget.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.kMediumPrimary(context),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (widget.isOffline) {
                                context
                                    .read<OfflineLessonsCubit>()
                                    .toggleSavedLesson(widget.id);
                              } else {
                                final savesCubit = context.read<SavesCubit>();
                                if (_isSaved) {
                                  savesCubit.removeFromSaved(
                                    id: widget.id,
                                    type: widget.itemType,
                                  );
                                } else {
                                  savesCubit.addToSaved(
                                    id: widget.id,
                                    type: widget.itemType,
                                  );
                                }
                              }
                            },
                            icon: Icon(
                              _isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_outline,
                              color: Theme.of(context).colorScheme.primary,
                              size: 34.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
