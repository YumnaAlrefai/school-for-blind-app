import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/quiz%20_questions_%20screen.dart';

class AddQuizScreen extends StatefulWidget {
  final int lessonId;
  const AddQuizScreen({super.key, required this.lessonId});

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

  void _onEnterQuestions() {
    final duration = int.tryParse(_durationController.text.trim());
    final count = int.tryParse(_questionsCountController.text.trim());

    if (duration == null || duration <= 0) {
      _showMessage('أدخل مدة صحيحة للكويز');
      return;
    }
    if (count == null || count <= 0) {
      _showMessage('أدخل عدد الأسئلة');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => QuizQuestionsScreen(
          lessonId: widget.lessonId,
          timeLimit: duration,
          numOfQuestions: count,
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 16))),
    );
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
                const SizedBox(height: 30),
                _buildTopBar(),
                const SizedBox(height: 120),
                _buildInputField(
                  controller: _durationController,
                  hint: 'مدة الكويز',
                  icon: Icons.access_time,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 25),
                _buildInputField(
                  controller: _questionsCountController,
                  hint: 'عدد الأسئلة الكلي',
                  icon: Icons.help_outline,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 25),
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
            fontSize: 30,
            fontFamily: "Arabic Typesetting",
                fontWeight: FontWeight.w300,

          ),
        ),
        IconButton(
          icon: const Icon(Icons.subdirectory_arrow_left,
              size: 30, color: Colors.white),
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
      height: 75,
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor.withOpacity(0.20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kPrimaryColor.withOpacity(0.5)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 30),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.45),
            fontSize: 30,
          ),
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
      height: 75,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor.withOpacity(0.55),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.kPrimaryColor.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Icon(Icons.login, color: AppColors.kPrimaryColor, size: 26),
          const Expanded(
            child: Text(
              'إدخال الأسئلة',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 30),
            ),
          ),
          const SizedBox(width: 20),
        ],
      ),
    ),
  );
}
}