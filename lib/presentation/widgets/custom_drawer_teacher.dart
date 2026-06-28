import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_profile_screen.dart';

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
                      _buildDrawerItem(Icons.grid_on_sharp, 'برنامج الدوام', () {
                        Navigator.pop(context);
                      }),
                      _buildDrawerItem(Icons.bar_chart, 'الإحصائيات', () {
                        Navigator.pop(context);
                      }),
                      _buildDrawerItem(Icons.dark_mode, 'الثيمات', () {
                        Navigator.pop(context);
                      }),
                      _buildDrawerItem(
                        Icons.volunteer_activism,
                        'تبرع لنا',
                        () {
                          Navigator.pop(context);
                        },
                      ),
                      _buildDrawerItem(Icons.contact_support, 'تواصل معنا', () {
                        Navigator.pop(context);
                      }),
                    ],
                  ),
                ),

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
                    onTap: () {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: [
                        Text(
                          'تسجيل الخروج',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 30,
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
}
