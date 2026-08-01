import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/role_cubit.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/options_card.dart';

class UserTypeScreen extends StatelessWidget {
  const UserTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        helpMessage:
            'أهْلَنْ بكَ في تطبيقِ مدرسَتِنا، أنت الآن في صفحة تحديد نوع الحسابْ، يوجد في منتصف الشاشة زِرّرانْ، الزِرُّ الأول هو للدخول بحسابِ طالب، وُالزِّرُّ الثاني للدخول بحسابِ مدرس.',
        showBackButton: false,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('هل أنت؟', style: AppTextStyles.kBigPrimary(context)),
            SizedBox(height: 10.h),
            BlocConsumer<RoleCubit, UserRole>(
              listener: (context, state) {
                if (state == UserRole.student || state == UserRole.teacher) {
                  Navigator.pushNamed(
                    context,
                    state == UserRole.student
                        ? AppRoutes.kStudentAccountsScreen
                        : AppRoutes.kTeacherAccountsScreen,
                  ).then((_) {
                    context.read<RoleCubit>().resetRole();
                  });
                }
              },
              builder: (context, selectedRole) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    OptionsCard(
                      title: 'طالب',
                      width: 170,
                      height: 97,
                      isSelected: selectedRole == UserRole.student,
                      onTap: () => context.read<RoleCubit>().selectRole(
                        UserRole.student,
                      ),
                    ),
                    OptionsCard(
                      title: 'معلم',
                      width: 170,
                      height: 97,
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
