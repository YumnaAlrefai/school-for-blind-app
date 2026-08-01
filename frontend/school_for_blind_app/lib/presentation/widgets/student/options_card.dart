import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class OptionsCard extends StatelessWidget {
  final String? title;
  final IconData? icon;
  final double width;
  final double height;
  final double? iconSize;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionsCard({
    super.key,
    this.title,
    this.icon,
    required this.width,
    required this.isSelected,
    required this.onTap,
    required this.height,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: height.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                    size: iconSize,
                  )
                : Container(),
            SizedBox(width: 15.w),
            title != null
                ? Text(
                    title!,
                    style: isSelected
                        ? AppTextStyles.kMediumSecondary(context)
                        : AppTextStyles.kMediumPrimary(context),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
