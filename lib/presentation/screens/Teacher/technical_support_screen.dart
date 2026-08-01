import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/donation_info_screen.dart';

class TechnicalSupportScreen extends StatefulWidget {
  const TechnicalSupportScreen({super.key});

  @override
  State<TechnicalSupportScreen> createState() => _TechnicalSupportScreenState();
}

class _TechnicalSupportScreenState extends State<TechnicalSupportScreen> {
  final TextEditingController _problemController = TextEditingController();
  File? _selectedImage;

  bool _isButtonEnabled = false;
  bool _sending = false;
  @override
  void initState() {
    super.initState();
    _problemController.addListener(_updateButtonState);  
  }

 void _updateButtonState() {
    final enabled = _problemController.text.trim().isNotEmpty &&
        _selectedImage != null;
    if (enabled != _isButtonEnabled) {
      setState(() => _isButtonEnabled = enabled);
    }
  }

  @override
  void dispose() {
    _problemController.removeListener(_updateButtonState); 
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
      _updateButtonState();
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 20))),
    );
  }

  Future<void> _onSend() async {
    if (!_isButtonEnabled || _sending) return;

    final problem = _problemController.text.trim();
    if (problem.isEmpty) {
      _showMessage('اكتب وصف المشكلة');
      return;
    }

    // الصورة إجبارية
    if (_selectedImage == null) {
      _showMessage('يرجى إرفاق صورة للمشكلة');
      return;
    }

    setState(() => _sending = true);

    final result = await getIt<TeacherRepo>().sendSupportTicket(
      message: problem,
      image: _selectedImage!,      
    );

    if (!mounted) return;
    setState(() => _sending = false);

    result.when(
      success: (_) {
        _showMessage('تم إرسال المشكلة للدعم الفني');
        _problemController.clear();
        setState(() => _selectedImage = null);
        Navigator.pop(context);
      },
      failure: (_) =>
          _showMessage('تعذّر الإرسال، تأكد من الاتصال وحاول مجدداً'),
    );
  }

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF0D1E2D);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(color: Colors.white24, thickness: 1, height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'الدعم الفني',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontFamily: 'ArabicTypesetting',
                      ),
                    ),

                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Transform.flip(
                        flipX: true,
                        child: const Icon(
                          Icons.shortcut,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      tooltip: 'رجوع',
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, thickness: 1, height: 20),

                const SizedBox(height: 20),

                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'صف المشكلة الفنية:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'ArabicTypesetting',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _problemController,
                  maxLines: 4,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  cursorColor: AppColors.kPrimaryColor,
                  decoration: InputDecoration(
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 25,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.03),
                    contentPadding: const EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.25),
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: AppColors.kPrimaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                'لقطة شاشة للمشكلة:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35,
                      fontFamily: 'ArabicTypesetting',
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 160,
                      height: 164,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : const Icon(
                              Icons.add_photo_alternate_outlined,
                              color: AppColors.kPrimaryColor,
                              size: 44,
                            ),
                    ),
                  ),
                ),

                const Spacer(),

                const SizedBox(height: 28),
                Center(
                  child: DonationButton(
                    label: _sending ? 'جارٍ الإرسال...' : 'إرسال',
                    onTap: _sending ? () {} : _onSend,
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
