import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class AppTextStyles {
  static TextStyle kBigPrimary = TextStyle(
    fontSize: 64.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.kTextPrimary,
  );

  static TextStyle kBigSecondary = TextStyle(
    fontSize: 64.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.kTextSecondary,
  );

  static TextStyle kMediumPrimary = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.kTextPrimary,
  );

  static TextStyle kMediumSecondary = TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.kTextSecondary,
  );
}
