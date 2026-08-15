import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:school_for_blind_app/data/models/notifications_response_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const NotificationCard({super.key, required this.item});

  String _formatDateWithTime(String timestamp) {
    try {
      final parsedDate = DateTime.parse(timestamp).toLocal();
      return DateFormat('yyyy-MM-dd hh:mm a').format(parsedDate);
    } catch (_) {
      return timestamp;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String titleText =
        (item.title != null && item.title.trim().isNotEmpty)
        ? item.title
        : "إشعار جديد";

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: theme.colorScheme.onSurface, width: 0.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
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
            title: Text(
              titleText,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: 38.sp,
                fontFamily: theme.textTheme.bodyLarge?.fontFamily,
              ),
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.body,
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
                        _formatDateWithTime(item.timestamp),
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
