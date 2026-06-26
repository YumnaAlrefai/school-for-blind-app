import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTextStyles {
  static TextStyle kBigPrimary(BuildContext context) => TextStyle(
    fontSize: 64.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onBackground,
  );

  static TextStyle kBigSecondary(BuildContext context) => TextStyle(
    fontSize: 64.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onPrimary,
  );

  static TextStyle kMediumPrimary(BuildContext context) => TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onBackground,
  );

  static TextStyle kMediumSecondary(BuildContext context) => TextStyle(
    fontSize: 48.sp,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onPrimary,
  );
}
