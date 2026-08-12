import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppDrawer extends StatelessWidget {
  final String studentName;
  final String phoneNumber;
  final VoidCallback onSchedulePressed;
  final VoidCallback onThemesPressed;
  final VoidCallback onDonatePressed;
  final VoidCallback onSupportPressed;
  final VoidCallback onLogoutPressed;

  const AppDrawer({
    super.key,
    required this.studentName,
    required this.phoneNumber,
    required this.onSchedulePressed,
    required this.onThemesPressed,
    required this.onDonatePressed,
    required this.onSupportPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.cardDark,
      width: MediaQuery.of(context).size.width * 0.78,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 25, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Text(studentName, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 35)),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(phoneNumber, style: const TextStyle(color: Colors.white54, fontSize: 28)),
              ),
               const SizedBox(height: 35),
              const Divider(color: Colors.white24, thickness: 1, height:1 ),
              const SizedBox(height: 20),
              _drawerItem(label: 'برنامج الدوام', icon: Icons.calendar_month_rounded, onTap: () { Navigator.pop(context); onSchedulePressed(); }),
              const SizedBox(height: 15),
              _drawerItem(label: 'الثيمات', icon: Icons.dark_mode_rounded, onTap: () { Navigator.pop(context); onThemesPressed(); }),
              const SizedBox(height: 15),
              _drawerItem(label: 'تبرع لنا', icon: Icons.volunteer_activism_rounded, onTap: () { Navigator.pop(context); onDonatePressed(); }),
              const SizedBox(height: 15),
              _drawerItem(label: 'تواصل معنا', icon: Icons.help_rounded, onTap: () { Navigator.pop(context); onSupportPressed(); }),
              const Spacer(),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.redX, width: 1)),
                child: TextButton.icon(
                  onPressed: onLogoutPressed,
                  icon: const Icon(Icons.logout_rounded, color: AppColors.redX, size: 25),
                  label: const Text('تسجيل الخروج', style: TextStyle(color: AppColors.redX, fontSize: 32)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _drawerItem({required String label, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: AppColors.bgDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white24, width: 0.5)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accentGreen, size: 25),
            const SizedBox(width: 10),
            Expanded(child: Text(label, textAlign: TextAlign.right, style: const TextStyle(color: Colors.white, fontSize: 32))),
            const Icon(Icons.chevron_right_rounded, color: Colors.white38, size: 22),
          ],
        ),
      ),
    );
  }
}