import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class CustomTextfield extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  const CustomTextfield({
    super.key,
    this.hintText,
    this.icon,
    this.inputFormatters,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 332.w,
      height: 97.h,
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
      child: TextFormField(
        controller: controller,
        validator: validator,
        inputFormatters: inputFormatters,
        style: AppTextStyles.kMediumPrimary,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.kMediumPrimary,
          prefixIcon: Icon(icon),
          prefixIconColor: AppColors.kPrimaryColor,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            vertical: 15.h,
            horizontal: 20.w,
          ),
        ),
      ),
    );
  }
}
