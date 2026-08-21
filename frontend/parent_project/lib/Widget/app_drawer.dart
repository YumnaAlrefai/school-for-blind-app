import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'theme_controller.dart';
import 'theme_listener.dart';

class AppDrawer extends StatelessWidget {
  final VoidCallback onSchedulePressed;
  final VoidCallback onThemesPressed;
  final VoidCallback onDonatePressed;
  final VoidCallback onSupportPressed;
  final VoidCallback onLogoutPressed;

  const AppDrawer({
    super.key,
    required this.onSchedulePressed,
    required this.onThemesPressed,
    required this.onDonatePressed,
    required this.onSupportPressed,
    required this.onLogoutPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ThemeListener(
  builder: (context) => Drawer(
        backgroundColor: AppColors.cardDark,
        width: MediaQuery.of(context).size.width * 0.78,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 25, 16, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 25),
                _drawerItem(label: 'برنامج الدوام', icon: Icons.calendar_month_rounded, onTap: () { Navigator.pop(context); onSchedulePressed(); }),
                const SizedBox(height: 15),
                _ThemeDrawerItem(),
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
                    icon: Icon(Icons.logout_rounded, color: AppColors.redX, size: 25),
                    label: Text('تسجيل الخروج', style: TextStyle(color: AppColors.redX, fontSize: 32)),
                  ),
                ),
              ],
            ),
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
        decoration: BoxDecoration(color: AppColors.bgDark, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.overlay24, width: 0.5)),
        child: Row(
          children: [
            Icon(icon, color: AppColors.accentGreen, size: 25),
            const SizedBox(width: 10),
            Expanded(child: Text(label, textAlign: TextAlign.right, style: TextStyle(color: AppColors.textPrimary, fontSize: 32))),
            Icon(Icons.chevron_right_rounded, color: AppColors.overlay38, size: 22),
          ],
        ),
      ),
    );
  }
}

class _ThemeDrawerItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: AppColors.isDarkMode,
      builder: (context, isDark, _) {
        return PopupMenuButton<bool>(
          color: AppColors.cardDark,
          elevation: 6,
          padding: EdgeInsets.zero,
          offset: const Offset(0, 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.overlay24, width: 0.5),
          ),
          position: PopupMenuPosition.under,
          onSelected: (value) => ThemeController.instance.setDark(value),
          itemBuilder: (context) => [
            _menuItem(value: true, label: 'داكن (الافتراضي)', selected: isDark),
            _menuItem(value: false, label: 'فاتح', selected: !isDark),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.bgDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.overlay24, width: 0.5),
            ),
            child: Row(
              children: [
                Icon(
                  isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: AppColors.accentGreen,
                  size: 25,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'الثيمات',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 32),
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: AppColors.overlay38, size: 22),
              ],
            ),
          ),
        );
      },
    );
  }

  PopupMenuItem<bool> _menuItem({
    required bool value,
    required String label,
    required bool selected,
  }) {
    return PopupMenuItem<bool>(
      value: value,
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: selected ? AppColors.overlay12 : Colors.transparent,
        child: Text(
          label,
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 16),
        ),
      ),
    );
  }
}