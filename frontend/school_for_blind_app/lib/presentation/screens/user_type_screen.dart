import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/role_cubit.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هل أنت؟', style: AppTextStyles.kBigPrimary),
            SizedBox(height: 20.h),
            BlocConsumer<RoleCubit, UserRole>(
              listener: (context, state) {
                if (state == UserRole.student) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentAccountsScreen,
                    );
                  });
                } else if (state == UserRole.teacher) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.kTeacherAccountsScreen,
                  );
                }
              },
              builder: (context, selectedRole) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RoleCard(
                      title: 'طالب',
                      isSelected: selectedRole == UserRole.student,
                      onTap: () => context.read<RoleCubit>().selectRole(
                        UserRole.student,
                      ),
                    ),
                    RoleCard(
                      title: 'معلم',
                      isSelected: selectedRole == UserRole.teacher,
                      onTap: () => context.read<RoleCubit>().selectRole(
                        UserRole.teacher,
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 30.sp),
          ],
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const RoleCard({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 170.w,
        height: 97.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor
              : AppColors.kBackgroundColor,
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
        child: Text(
          title,
          style: isSelected
              ? AppTextStyles.kMediumSecondary
              : AppTextStyles.kMediumPrimary,
        ),
      ),
    );
  }
}
