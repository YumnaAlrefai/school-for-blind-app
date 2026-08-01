import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 19, right: 19, bottom: 20), 
      height: 78, 
      decoration: BoxDecoration(
        color: AppColors.kTextSecondary,
        borderRadius: BorderRadius.circular(50), 
        border: Border.all(
          color: Colors.white.withOpacity(0.50),
          width: 0.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.15), 
            blurRadius: 4, 
            spreadRadius: 0,
            offset: const Offset(0, 0), 
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        textDirection: TextDirection.ltr, 
        children: [
          _buildNavItem(Icons.chat_outlined, 0),
          _buildNavItem(Icons.archive_outlined, 1),
          _buildNavItem(Icons.add_circle_outline, 2),
          _buildNavItem(Icons.campaign_outlined, 3),
          _buildNavItem(Icons.home_outlined, 4), 
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    final isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque, 
      child: SizedBox(
        height: 78,
        width: 50,
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? AppColors.kPrimaryColor : Colors.white60, 
        ),
      ),
    );
  }
}