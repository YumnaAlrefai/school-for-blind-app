import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final double width;
  final double height;
  final double fontSize;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    required this.title,
    required this.width,
    required this.height,
    required this.onPressed,
    super.key,
    required this.fontSize,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: width.w,
      height: height.h,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
            side: BorderSide(
              color: isLoading ? colorScheme.onSurface : colorScheme.primary,
              width: 0.2.w,
            ),
          ),
          backgroundColor: isLoading
              ? colorScheme.surface
              : colorScheme.primary,
          disabledBackgroundColor: colorScheme.surface,
          padding: EdgeInsets.zero,
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize.sp,
            fontWeight: FontWeight.w400,
            color: isLoading ? colorScheme.onSurface : colorScheme.background,
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const SecondaryButton({
    required this.title,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
        minimumSize: Size(332.w, 97.h),
      ),
      child: Text(title, style: AppTextStyles.kMediumPrimary(context)),
    );
  }
}
