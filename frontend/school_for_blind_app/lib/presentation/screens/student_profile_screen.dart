import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_text_form_field.dart';

class StudentProfileScreen extends StatelessWidget {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        helpMessage:
            'هنا صفحة المعلومات الشخصيْيةْ، تَعرِض هذه الصفحة بياناتك التي قُمْتَ بإدخالها عند إنشاء الحساب.',
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(30.w, 10.h, 10.w, 10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الاسم الكامل:', style: AppTextStyles.kMediumPrimary(context)),
            SizedBox(height: 10.h),
            CustomTextfield(
              controller: TextEditingController(
                text:
                    getIt<StudentCubit>().currentStudent?.fullName ??
                    'الاسم الكامل',
              ),
              readOnly: true,
              icon: Icons.person,
            ),
            SizedBox(height: 15.h),

            Text('اسم الأب:', style: AppTextStyles.kMediumPrimary(context)),
            SizedBox(height: 10.h),
            CustomTextfield(
              controller: TextEditingController(
                text:
                    getIt<StudentCubit>().currentStudent?.fatherName ??
                    'اسم الأب',
              ),
              readOnly: true,
              icon: Icons.person,
            ),
            SizedBox(height: 15.h),

            Text('رقم الهاتف:', style: AppTextStyles.kMediumPrimary(context)),
            SizedBox(height: 10.h),
            CustomTextfield(
              controller: TextEditingController(
                text:
                    getIt<StudentCubit>().currentStudent?.phone ?? 'رقم الهاتف',
              ),
              readOnly: true,
              icon: Icons.phone_android,
            ),
            SizedBox(height: 15.h),

            Text('رقم الأهل:', style: AppTextStyles.kMediumPrimary(context)),
            SizedBox(height: 10.h),
            CustomTextfield(
              controller: TextEditingController(
                text:
                    getIt<StudentCubit>().currentStudent?.parentPhone ??
                    'رقم الأهل',
              ),
              readOnly: true,
              icon: Icons.family_restroom,
            ),
            SizedBox(height: 15.h),

            Text(
              'المرحلة الدراسية:',
              style: AppTextStyles.kMediumPrimary(context),
            ),
            SizedBox(height: 10.h),
            CustomTextfield(
              controller: TextEditingController(
                text: getIt<StudentCubit>().currentStudent?.level == 'ninth'
                    ? 'الصف التاسع'
                    : getIt<StudentCubit>().currentStudent?.level == 'twelfth'
                    ? 'بكالوريا'
                    : 'المرحلة الدراسية',
              ),
              readOnly: true,
              icon: Icons.auto_stories_sharp,
            ),
            SizedBox(height: 15.h),

            Text(
              'الأوراق الثبوتية:',
              style: AppTextStyles.kMediumPrimary(context),
            ),
            SizedBox(height: 10.h),
            Container(
              height: 200.h,
              width: 200.w,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.r),
                child: CachedNetworkImage(
                  imageUrl:
                      "https://stays-ability-accustom.ngrok-free.dev/${getIt<StudentCubit>().currentStudent?.documentaryEvidence}",
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.broken_image,
                      size: 50,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
