import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/data/models/student/announcement_model.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement item;

  const AnnouncementCard({super.key, required this.item});

  String _formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate).toLocal();
      return DateFormat('yyyy-MM-dd HH:mm a').format(parsedDate);
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNavigableProgram = item.type == 'exam_schedule';
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: theme.colorScheme.onSurface.withOpacity(0.2),
          width: 0.8,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26.r),
        clipBehavior: Clip.antiAlias,
        child: Theme(
          data: theme.copyWith(
            dividerColor: Colors.transparent,
            splashColor: theme.colorScheme.primary.withOpacity(0.12),
            highlightColor: Colors.transparent,
          ),
          child: ExpansionTile(
            iconColor: theme.colorScheme.primary,
            collapsedIconColor: theme.colorScheme.onSurface,
            title: Row(
              children: [
                Icon(
                  isNavigableProgram
                      ? Icons.grid_on_rounded
                      : Icons.calendar_today_rounded,
                  color: theme.colorScheme.primary,
                  size: 32.sp,
                ),
                SizedBox(width: 20.w),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      color: theme.colorScheme.onSurface,
                      fontSize: 38.sp,
                      fontFamily: theme.textTheme.bodyLarge?.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isNavigableProgram)
                      RichText(
                        text: TextSpan(
                          text: 'تم نشر ${item.title}، انقر ',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 36.sp,
                            height: 1.6,
                            fontFamily: theme.textTheme.bodyLarge?.fontFamily,
                          ),
                          children: [
                            TextSpan(
                              text: 'هنا',
                              style: TextStyle(
                                color: theme.colorScheme.primary,
                                decoration: TextDecoration.underline,
                                fontFamily:
                                    theme.textTheme.bodyLarge?.fontFamily,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.kStudentExamScheduleScreen,
                                    arguments: item.id,
                                  );
                                },
                            ),
                            const TextSpan(text: ' للإطلاع عليه'),
                          ],
                        ),
                      )
                    else
                      Text(
                        item.contentAsString,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 36.sp,
                          height: 1.6,
                          fontFamily: theme.textTheme.bodyLarge?.fontFamily,
                        ),
                      ),
                    SizedBox(height: 12.h),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        _formatDate(item.createdAt),
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                          fontSize: 28.sp,
                          fontFamily: theme.textTheme.bodyLarge?.fontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
