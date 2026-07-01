import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnlineOfflineTabs extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onPressed;

  const OnlineOfflineTabs({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? colorScheme.primary : colorScheme.surface,
        foregroundColor: isSelected
            ? colorScheme.onPrimary
            : colorScheme.onSurface,
        fixedSize: Size(170.w, 55.h),
        side: isSelected
            ? BorderSide.none
            : BorderSide(color: colorScheme.onSurface, width: 0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      onPressed: onPressed,
      child: Text(label, style: TextStyle(fontSize: 32.sp)),
    );
  }
}
