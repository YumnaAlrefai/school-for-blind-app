import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class OptionsCard extends StatelessWidget {
  final String title;
  final IconData? icon;
  final double width;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionsCard({
    super.key,
    required this.title,
    this.icon,
    required this.width,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width.w,
        height: 97.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.kPrimaryColor : AppColors.kSurfaceColor,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: AppColors.kPrimaryColor.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? Icon(icon, color: AppColors.kPrimaryColor, size: 35)
                : Container(),
            SizedBox(width: 15.w),
            Text(
              title,
              style: isSelected
                  ? AppTextStyles.kMediumSecondary
                  : AppTextStyles.kMediumPrimary,
            ),
          ],
        ),
      ),
    );
  }
}
