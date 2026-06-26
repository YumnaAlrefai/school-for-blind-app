import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class CustomTextfield extends StatelessWidget {
  final String? hintText;
  final IconData? icon;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool readOnly;

  const CustomTextfield({
    super.key,
    this.hintText,
    this.icon,
    this.inputFormatters,
    required this.controller,
    this.validator,
    this.keyboardType,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 332.w,
      height: 97.h,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        validator: validator,
        inputFormatters: inputFormatters,
        style: AppTextStyles.kMediumPrimary(context),
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: AppTextStyles.kMediumPrimary(context),
          prefixIcon: Icon(icon),
          prefixIconColor: Theme.of(context).colorScheme.primary,
          suffixIcon: readOnly
              ? Icon(
                  Icons.lock,
                  color: Theme.of(context).colorScheme.onBackground,
                )
              : SizedBox(),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 2.w),
        ),
        readOnly: readOnly,
      ),
    );
  }
}
