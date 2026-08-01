import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/theme_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/core/theme/app_themes.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(22.w),
              decoration: BoxDecoration(
                color: Theme.of(
                  context,
                ).colorScheme.background.withOpacity(0.4),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).colorScheme.onBackground,
                    width: 0.7,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getIt<StudentCubit>().currentStudent?.fullName ?? "طالب",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.kBigPrimary(context),
                  ),
                  Text(
                    getIt<StudentCubit>().currentStudent?.phone ?? "09********",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 32),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Tile(
              icon: Icons.person,
              title: 'المعلومات الشخصية',
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.kStudentProfileScreen);
              },
            ),
            Tile(
              icon: Icons.grid_on_sharp,
              title: 'برنامج الدوام',
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AppRoutes.kStudentScheduleScreen);
              },
            ),
            Tile(
              icon: Icons.dark_mode,
              title: 'الثيمات',
              trailing: DropdownButton<AppThemeType>(
                iconEnabledColor: Theme.of(context).colorScheme.onBackground,
                menuWidth: 280.w,
                underline: SizedBox(),
                dropdownColor: Theme.of(context).colorScheme.surface,
                selectedItemBuilder: (BuildContext context) {
                  return [
                    AppThemeType.yellowAndNavy,
                    AppThemeType.redAndBlack,
                    AppThemeType.orangeAndGrey,
                    AppThemeType.yellowAndBlack,
                    AppThemeType.whiteAndGreen,
                    AppThemeType.greenAndNavy,
                    AppThemeType.blueAndNavy,
                    AppThemeType.purpleAndNavy,
                    AppThemeType.pinkAndNavy,
                    AppThemeType.light,
                    AppThemeType.whiteAndBlack,
                  ].map<Widget>((AppThemeType item) {
                    return SizedBox(width: 55.w);
                  }).toList();
                },
                items: const [
                  DropdownMenuItem(
                    value: AppThemeType.yellowAndNavy,
                    child: Text(
                      'أصفر مع كحلي (الافتراضي)',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.redAndBlack,
                    child: Text('أحمر مع أسود', style: TextStyle(fontSize: 25)),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.orangeAndGrey,
                    child: Text(
                      'برتقالي مع رمادي',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.yellowAndBlack,
                    child: Text('أصفر مع أسود', style: TextStyle(fontSize: 25)),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.whiteAndGreen,
                    child: Text('أبيض مع أخضر', style: TextStyle(fontSize: 25)),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.greenAndNavy,
                    child: Text('أخضر مع كحلي', style: TextStyle(fontSize: 25)),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.blueAndNavy,
                    child: Text('أزرق مع كحلي', style: TextStyle(fontSize: 25)),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.purpleAndNavy,
                    child: Text(
                      'بنفسجي مع كحلي',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.pinkAndNavy,
                    child: Text('زهري مع كحلي', style: TextStyle(fontSize: 25)),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.light,
                    child: Text(
                      'كرزي مع وردي فاتح',
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  DropdownMenuItem(
                    value: AppThemeType.whiteAndBlack,
                    child: Text('أبيض مع أسود', style: TextStyle(fontSize: 25)),
                  ),
                ],
                onChanged: (AppThemeType? value) {
                  if (value == null) return;
                  context.read<ThemeCubit>().changeTheme(value);
                },
              ),
            ),
            Tile(
              icon: Icons.volunteer_activism,
              title: 'تبرع لنا',
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.kStudentPaymentIntentScreen,
                );
              },
            ),
            Tile(
              icon: Icons.contact_support,
              title: 'تواصل معنا',
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  AppRoutes.kStudentContactSupportScreen,
                );
              },
            ),
            const Spacer(),
            BlocConsumer<AuthCubit, ResultState>(
              listener: (context, state) {
                state.whenOrNull(
                  success: (data) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.kSUserTypeScreen,
                      (route) => false,
                    );
                  },
                  failure: (networkException) {
                    getIt<VoiceServices>().speak(
                      NetworkExceptions.getErrorMessage(networkException),
                    );
                  },
                );
              },
              builder: (context, state) {
                if (state is Loading) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 30.w),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFf3333),
                      ),
                    ),
                  );
                }
                return LogoutTile();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LogoutTile extends StatelessWidget {
  const LogoutTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15.w, 0, 15.w, 20.w),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.r),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
            side: BorderSide(color: Color(0xFFFf3333), width: 0.3),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
          leading: const Icon(
            Icons.logout_rounded,
            color: Color(0xFFFf3333),
            size: 32,
          ),
          title: Padding(
            padding: EdgeInsets.only(right: 25.w),
            child: Text(
              'تسجيل الخروج',
              style: const TextStyle(color: Color(0xFFFf3333), fontSize: 32),
            ),
          ),
          onTap: () {
            context.read<AuthCubit>().emitLogout();
          },
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const Tile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.w),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: Theme.of(context).colorScheme.onBackground,
            width: 0.2,
          ),
        ),
        tileColor: Theme.of(context).colorScheme.background.withOpacity(0.4),
        leading: Icon(
          icon,
          size: 32,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(title, style: const TextStyle(fontSize: 32)),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
