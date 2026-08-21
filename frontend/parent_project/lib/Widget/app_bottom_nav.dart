import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final bool isHomeActive;
  final VoidCallback onHomeTap;
  final VoidCallback onAnnouncementsTap;

  const AppBottomNav({
    super.key,
    required this.isHomeActive,
    required this.onHomeTap,
    required this.onAnnouncementsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [BoxShadow(color: AppColors.textPrimary.withOpacity(0.5), blurRadius: 5)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onHomeTap,
            icon: Icon(Icons.home_rounded, color: isHomeActive ? AppColors.accentGreen : AppColors.overlay54, size: 36),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: onAnnouncementsTap,
            icon: Icon(Icons.campaign_rounded, color: !isHomeActive ? AppColors.accentGreen : AppColors.overlay54, size: 40),
          ),
        ],
      ),
    );
  }
}