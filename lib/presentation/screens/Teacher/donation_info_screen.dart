import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

class DonationInfoScreen extends StatefulWidget {
  const DonationInfoScreen({super.key});

  @override
  State<DonationInfoScreen> createState() => _DonationInfoScreenState();
}

class _DonationInfoScreenState extends State<DonationInfoScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _goToPayment() {
    Navigator.pushNamed(context, AppRoutes.kDonationPaymentScreen);
  }

  @override
  Widget build(BuildContext context) {
    return DonationScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 330.w,
            child: Text(
              'معلومات التبرع:',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.sp,
            fontFamily: 'ArabicTypesetting',
              ),
            ),
          ),
          SizedBox(height: 22.h),
          DonationField(
            icon: Icons.person_outline,
            hint: 'الاسم',
            controller: _nameController,
          ),
          SizedBox(height: 30.h),
          DonationField(
            icon: Icons.attach_money,
            hint: 'المبلغ',
            controller: _amountController,
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 30.h),
          DonationButton(label: 'التالي', onTap: _goToPayment),
        ],
      ),
    );
  }
}

// ============================================================
// Shared widgets used by both donation screens
// ============================================================

/// خلفية موحّدة (لون داكن + توهّج أخضر منتشر + زر رجوع + بطاقة)
class DonationScaffold extends StatelessWidget {
  final Widget child;
  const DonationScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: const Color(0xFF0D1E2D),
        body: Stack(
          children: [
            // التوهّج الأخضر المنتشر في الخلفية كلها
            // Positioned.fill(
            //   child: DecoratedBox(
            //     decoration: BoxDecoration(
            //       gradient: RadialGradient(
            //         center: const Alignment(0, -0.35),
            //         radius: 1.0,
            //         colors: [
            //           AppColors.kPrimaryColor.withOpacity(0.16),
            //           const Color(0xFF12281F).withOpacity(0.5),
            //           const Color(0xFF0D1E2D),
            //         ],
            //         stops: const [0.0, 0.45, 0.85],
            //       ),
            //     ),
            //   ),
            // ),

            SafeArea(
              child: Stack(
                children: [
                  // زر الرجوع أعلى اليسار (شكل ↰)
                  Positioned(
                    top: 4.h,
                    left: 8.w,
                    child: IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Transform.flip(
                        flipX: true,
                        child: const Icon(
                          Icons.shortcut,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  // البطاقة 362×707 — top 83 / left 20 — radius 25
                  Positioned(
                    top: 83.h,
                    left: 20.w,
                    child: Container(
                      width: 362.w,
                      height: 707.h,
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.r),
                        border: Border.all(
                          color: AppColors.kTextPrimary.withOpacity(0.12),
                          width: 1,
                        ),
                        color: Colors.white.withOpacity(0.015),
                      ),
                      // المحتوى في منتصف البطاقة عمودياً
                      child: Center(child: child),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// حقل إدخال موحّد — 330×60 — radius 15
class DonationField extends StatelessWidget {
  final IconData icon;
  final String hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;

  const DonationField({
    super.key,
    required this.icon,
    required this.hint,
    this.controller,
    this.keyboardType,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 330.w,
      height: 60.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: AppColors.kPrimaryColor.withOpacity(0.4),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscureText,
        textAlign: TextAlign.right,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Colors.white, fontSize: 30.sp),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 30.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(top: 12.h, right: 20.w, left: 14.w),
          prefixIcon: Icon(icon, color: AppColors.kPrimaryColor, size: 25.sp),
          prefixIconConstraints: BoxConstraints(minWidth: 44.w),
        ),
      ),
    );
  }
}

/// زر أخضر موحّد — 193×54 — radius 15 — موسّط
class DonationButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  DonationButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 193.w,
      height: 54.h,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.kPrimaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.r),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: const Color(0xFF0D1E2D),
            fontSize: 40.sp,
            fontFamily: 'ArabicTypesetting',
          ),
        ),
      ),
    );
  }
}
