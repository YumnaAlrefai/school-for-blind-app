import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';

/// الاستخدام:
///   ConfirmButton(
///     label: 'تأكيد',
///     onPressed: () { ... },
///   )
///
///   ConfirmButton(
///     label: 'إرسال',
///     onPressed: () { ... },
///   )
/// ============================================================
class BuildButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
 
  const BuildButton({
    super.key,
    required this.label,
    required this.onPressed,
  });
 
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 193,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: AppColors.bgDark,
            fontSize: 40,
          ),
        ),
      ),
    );
  }
}