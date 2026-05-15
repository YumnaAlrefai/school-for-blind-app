import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:flutter/services.dart';

class OTPField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final VoidCallback onBackspace;

  const OTPField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Container(
        width: 85.w,
        height: 85.h,
        decoration: BoxDecoration(
          color: AppColors.kBackgroundColor,
          borderRadius: BorderRadius.circular(15.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.kPrimaryColor.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: KeyboardListener(
          focusNode: FocusNode(),
          onKeyEvent: (event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.backspace &&
                controller.text.isEmpty) {
              onBackspace();
            }
          },
          child: TextField(
            controller: controller,
            focusNode: focusNode,
            onChanged: onChanged,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            decoration: const InputDecoration(
              counterText: "",
              border: InputBorder.none,
            ),
            style: AppTextStyles.kMediumPrimary,
          ),
        ),
      ),
    );
  }
}
