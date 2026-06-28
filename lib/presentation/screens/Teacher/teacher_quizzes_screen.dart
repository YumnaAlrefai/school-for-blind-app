import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

class AddQuizScreen extends StatefulWidget {
  const AddQuizScreen({super.key});

  @override
  State<AddQuizScreen> createState() => _AddQuizScreenState();
}

class _AddQuizScreenState extends State<AddQuizScreen> {
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _questionsCountController =
      TextEditingController();

  @override
  void dispose() {
    _durationController.dispose();
    _questionsCountController.dispose();
    super.dispose();
  }

  /// الانتقال إلى شاشة إدخال الأسئلة
  void _onEnterQuestions() {
    // TODO: استبدل AppRoutes.kAddQuestions باسم مسار شاشة إدخال الأسئلة لديك
    // Navigator.pushNamed(
    //   context,
    //   AppRoutes.kAddQuestions,
    //   arguments: {
    //     'duration': _durationController.text.trim(),
    //     'questionsCount': _questionsCountController.text.trim(),
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                _buildTopBar(),
                const SizedBox(height: 60),
                _buildInputField(
                  controller: _durationController,
                  hint: 'مدة الكويز',
                  icon: Icons.access_time,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildInputField(
                  controller: _questionsCountController,
                  hint: 'عدد الأسئلة الكلي',
                  icon: Icons.help_outline,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                _buildEnterQuestionsButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'رفع كويز',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w500,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.subdirectory_arrow_left,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 20),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 20,
          ),
          // الأيقونة على اليمين (بداية السطر في RTL)
          prefixIcon: Icon(icon, color: AppColors.kPrimaryColor, size: 26),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildEnterQuestionsButton() {
    return GestureDetector(
      onTap: _onEnterQuestions,
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.kPrimaryColor.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 16),
            Icon(Icons.input, color: AppColors.kPrimaryColor, size: 26),
            const Expanded(
              child: Text(
                'إدخال الأسئلة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            const SizedBox(width: 42), // موازنة لعرض الأيقونة لتبقى الكتابة بالمنتصف
          ],
        ),
      ),
    );
  }
}