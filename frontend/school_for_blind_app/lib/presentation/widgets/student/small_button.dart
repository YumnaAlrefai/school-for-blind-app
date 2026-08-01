import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SmallButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  const SmallButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        fixedSize: Size(75.w, 70.h),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r),
        ),
      ),
      color: Theme.of(context).colorScheme.background,
      icon: icon,
      iconSize: 37.sp,
      onPressed: onPressed,
    );
  }
}
