import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class CustomDropdownField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final int? value;
  final List<int> items;
  final Function(int?) onChanged;

  const CustomDropdownField({
    super.key,
    required this.hintText,
    required this.icon,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final baseStyle = AppTextStyles.kMediumPrimary(context);

    return Container(
      width: 157.w,
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
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: value,
                style: baseStyle.copyWith(fontFamily: 'ArabicTypesetting'),
                hint: Text(hintText, style: baseStyle),
                items: items
                    .map(
                      (e) => DropdownMenuItem<int>(
                        value: e,
                        child: Text(
                          e.toString().padLeft(2, '0'),
                          style: baseStyle.copyWith(
                            fontFamily: 'ArabicTypesetting',
                          ),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
                isExpanded: true,
                iconSize: 22.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
