import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/core/theme/theme_cubit.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomDrawer extends StatelessWidget {
  final String userName;
  final String userPhone;

  const CustomDrawer({
    super.key,
    required this.userName,
    required this.userPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        color: const Color(0xFF0D1E2D),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  userPhone,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 20),

                Divider(color: Colors.white.withOpacity(0.2), thickness: 1),
                const SizedBox(height: 20),

                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildDrawerItem(Icons.person, 'المعلومات الشخصية', () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TeacherProfil(),
                          ),
                        );
                      }),
                      _buildDrawerItem(
                        Icons.grid_on_sharp,
                        'برنامج الدوام',
                        () {
                          Navigator.pop(context);
                        },
                      ),
                      _buildDrawerItem(Icons.bar_chart, 'الإحصائيات', () {
                        Navigator.pop(context);
                      }),

                      // ================= زر الثيمات (قائمة منسدلة) =================
                      BlocBuilder<ThemeCubit, ThemeMode>(
                        bloc: getIt<ThemeCubit>(),
                        builder: (context, mode) {
                          final themeCubit = getIt<ThemeCubit>();
                          final isDark = mode == ThemeMode.dark;

                          return PopupMenuButton<ThemeMode>(
                            initialValue: mode,
                            onSelected: (ThemeMode selectedMode) {
                              themeCubit.setTheme(selectedMode);
                            },
                            offset: const Offset(0, 45),
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<ThemeMode>>[
                                  const PopupMenuItem<ThemeMode>(
                                    value: ThemeMode.light,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('الوضع الفاتح'),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.light_mode,
                                          color: Colors.amber,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuItem<ThemeMode>(
                                    value: ThemeMode.dark,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text('الوضع الداكن'),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.dark_mode,
                                          color: Colors.blueGrey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                            child: _buildThemeDropdownButton(
                              icon: isDark ? Icons.dark_mode : Icons.light_mode,
                              title: 'الثيمات',
                              currentModeText: isDark ? 'داكن' : 'فاتح',
                            ),
                          );
                        },
                      ),

                      _buildDrawerItem(Icons.volunteer_activism, 'تبرع لنا', () {
                        Navigator.pop(
                          context,
                        ); // إغلاق القائمة الجانبية (Drawer) أولاً
                        Navigator.pushNamed(
                          context,
                          AppRoutes
                              .kDonationInfoScreen, // الانتقال إلى واجهة التبرع باستخدام الـ Route المعرف لديكِ
                        );
                      }),
                      _buildDrawerItem(Icons.contact_support, 'تواصل معنا', () {
                        Navigator.pop(
                          context,
                        ); // إغلاق القائمة الجانبية (Drawer) أولاً
                        Navigator.pushNamed(
                          context,
                          AppRoutes
                              .kTechnicalSupportScreen, // الانتقال لواجهة الدعم الفني
                        );
                      }),
                    ],
                  ),
                ),

                // ================= زر تسجيل الخروج =================
                Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.red.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    onTap: () => _logout(context),
                    borderRadius: BorderRadius.circular(12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.logout, color: Colors.red, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// تسجيل الخروج: يمسح حالة الدخول محلياً فوراً، ينادي السيرفر بالخلفية،
  /// ثم ينتقل لشاشة الدخول (بدون انتظار حتى لا يعلق).
  Future<void> _logout(BuildContext context) async {
    Navigator.pop(context); // اقفل الدراور

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('teacherLoggedIn', false);
    await prefs.remove('cachedteacher');

    // نداء السيرفر بالخلفية (لا ننتظره)
    getIt<TeacherCubit>().emitLogoutTeacher();

    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.kTeacherLogin, // ← تأكدي أنه اسم راوت دخول المدرّس الصحيح
        (route) => false,
      );
    }
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 48,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              children: [
                Icon(icon, color: AppColors.kPrimaryColor, size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.white.withOpacity(0.7),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeDropdownButton({
    required IconData icon,
    required String title,
    required String currentModeText,
  }) {
    return Container(
      height: 48,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 0.5),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(icon, color: AppColors.kPrimaryColor, size: 22),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                currentModeText,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 20,
                color: Colors.white.withOpacity(0.7),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
