import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

class TeacherProfil extends StatelessWidget {
  const TeacherProfil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Transform.flip(
                  flipX: true, 
                  child: const Icon(Icons.shortcut, color: Colors.white,size: 30),
                ),
              ),

              _buildProfileField(
                "الاسم الكامل:",
                " غالية الياسين",
                Icons.person,
              ),
              _buildProfileField("اسم الأب:", "وليد", Icons.person),
              _buildProfileField(
                "رقم الهاتف:",
                "0943576695",
                Icons.phone_android,
              ),
              _buildProfileField("المادة المعطاة:", "فلسفة", Icons.menu_book),
              _buildProfileField("المرحلة الدراسية:", "بكالوريا", Icons.school),

              _buildCvField("السيرة الذاتية:", Icons.picture_as_pdf),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileField(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 30)),
        const SizedBox(height: 4),
        Container(
          width: 354,
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(icon, color: AppColors.kPrimaryColor, size: 28),
              const SizedBox(width: 12),
              Text(
                value,
                style: const TextStyle(color: Colors.white, fontSize: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCvField(String label, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 40)),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: Center(
            child: Icon(icon, color: AppColors.kPrimaryColor, size: 30),
          ),
        ),
      ],
    );
  }
}
