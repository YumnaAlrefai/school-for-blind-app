import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.hasNotification = false,
  });
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool hasNotification;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.onSurface,
          width: 0.5,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 36,
          ),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.primary,
          size: 32,
        ),
      ),
    );
  }
}
