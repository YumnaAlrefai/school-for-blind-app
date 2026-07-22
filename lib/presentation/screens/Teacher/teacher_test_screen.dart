import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/test_questions_screen.dart';




class AddTestScreen extends StatefulWidget {
  const AddTestScreen({super.key});

  @override
  State<AddTestScreen> createState() => _AddTestScreenState();
}

class _AddTestScreenState extends State<AddTestScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _questionsCountController =
      TextEditingController();

  
  int _selectedCategoryIndex = 0;

  @override
  void dispose() {
    _titleController.dispose();
    _durationController.dispose();
    _questionsCountController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 16))),
    );
  }

  
  void _onEnterQuestions() {
    final title = _titleController.text.trim();
    final duration = int.tryParse(_durationController.text.trim());
    final count = int.tryParse(_questionsCountController.text.trim());

    if (title.isEmpty) {
      _showMessage('أدخل عنوان الاختبار');
      return;
    }
    if (duration == null || duration <= 0) {
      _showMessage('أدخل مدة صحيحة للاختبار');
      return;
    }
    if (count == null || count <= 0) {
      _showMessage('أدخل عدد الأسئلة');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TestQuestionsScreen(
          testTitle: title,
          durationMinutes: duration,
          numOfQuestions: count,
        ),
      ),
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
                const SizedBox(height: 10),
                _buildTopBar(),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 40),
                        _buildInputField(
                          controller: _titleController,
                          icon: Icons.description_outlined,
                          hint: 'عنوان الاختبار',
                        ),
                        const SizedBox(height: 20),
                        _buildInputField(
                          controller: _durationController,
                          hint: 'مدة الاختبار',
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

                _buildCategories(),
                const SizedBox(height: 20),
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
          'رفع الاختبارات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
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
      height: 75,
      decoration: BoxDecoration(
        color: AppColors.kBackgroundColor.withOpacity(0.20),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color:AppColors.kPrimaryColor,width: 0.5),
        
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: const TextStyle(color: Colors.white, fontSize: 40),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.45),
            
            fontSize: 32,
          ),
          
          prefixIcon: Icon(icon, color: AppColors.kPrimaryColor, size: 26),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }

  Widget _buildEnterQuestionsButton() {
    return GestureDetector(
      onTap: _onEnterQuestions,
      child: Container(
        height: 75,
        width:35,
        decoration: BoxDecoration(
          color: AppColors.kSurfaceColor.withOpacity(0.50),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.kPrimaryColor.withOpacity(0.6)),
        ),
        child: Row(
          children: [
            const SizedBox(width: 20),
            const Expanded(
              child: Text(
                'إدخال الأسئلة',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 32),
              ),
            ),
            Icon(Icons.login, color: AppColors.kPrimaryColor, size: 26),
            const SizedBox(width: 20),
          ],
        ),
      ),
    );
  }

  
  Widget _buildCategories() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildCategoryButton(
          text: 'الاختبارات',
          index: 0,
          onTap: () => setState(() => _selectedCategoryIndex = 0),
        ),
        const SizedBox(width: 12),
        _buildCategoryButton(
          text: 'الدروس',
          index: 1,
          onTap: () {
            
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildCategoryButton({
    required String text,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = _selectedCategoryIndex == index;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 161,
        height: 30,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.kPrimaryColor
              : Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 25,
          ),
        ),
      ),
    );
  }
}
