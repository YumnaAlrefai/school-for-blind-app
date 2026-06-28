import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/lessons_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

class AddLessonScreen extends StatefulWidget {
  const AddLessonScreen({super.key});

  @override
  State<AddLessonScreen> createState() => _AddLessonScreenState();
}

class _AddLessonScreenState extends State<AddLessonScreen> {
  final TextEditingController _titleController = TextEditingController();
  File? _audioFile;
  String? _audioFileName;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickAudioFile() async {
    // ✅ تصحيح: FilePicker.platform وليس FilePicker مباشرة
    final result = await FilePicker.pickFiles(type: FileType.audio);

    if (result != null && result.files.single.path != null) {
      setState(() {
        _audioFile = File(result.files.single.path!);
        _audioFileName = result.files.single.name;

        // اقتراح اسم الملف كعنوان إذا كان الحقل فارغاً
        if (_titleController.text.trim().isEmpty) {
          _titleController.text =
              _audioFileName!.replaceAll(RegExp(r'\.[^.]+$'), '');
        }
      });
    }
  }

  void _uploadLesson() {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('أدخل اسم الدرس أولاً');
      return;
    }
    if (_audioFile == null) {
      _showMessage('اختر ملف الصوت أولاً');
      return;
    }

    getIt<LessonsCubit>().emitUploadLesson(
      title: title,
      audioFile: _audioFile!,
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 18))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false, // نلغي السهم الافتراضي (يمين)
          centerTitle: true,
          title: const Text(
            'إضافة درس جديد',
            style: TextStyle(color: Colors.white, fontSize: 25),
          ),
          // ✅ في RTL الـ actions تظهر يساراً — هنا نضع سهم الرجوع
          actions: [
            IconButton(
             icon: Transform.flip(
                  flipX: true, 
                  child: const Icon(Icons.shortcut, color: Colors.white,size: 30),
                ),
              onPressed: () => Navigator.pop(context),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: BlocConsumer<LessonsCubit, ResultState<dynamic>>(
          bloc: getIt<LessonsCubit>(),
          listener: (context, state) {
            state.whenOrNull(
              success: (data) {
                if (data == 'lesson_uploaded') {
                  _showMessage('تم رفع الدرس بنجاح');
                  getIt<LessonsCubit>().emitGetLessons();
                  Navigator.pop(context);
                }
              },
              failure: (error) {
                _showMessage('فشل رفع الدرس، تأكد من الاتصال وحاول مجدداً');
              },
            );
          },
          builder: (context, state) {
            final isUploading = state.maybeWhen(
              loading: () => true,
              orElse: () => false,
            );

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 15),

                  // حقل اسم الدرس
                  TextField(
                    controller: _titleController,
                    enabled: !isUploading,
                    style: const TextStyle(color: Colors.white, fontSize: 25),
                    decoration: InputDecoration(
                      hintText: 'اسم الدرس...',
                      hintStyle: const TextStyle(
                          color: Colors.white38, fontSize: 25),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 25),

                  // صندوق اختيار ملف الصوت
                  GestureDetector(
                    onTap: isUploading ? null : _pickAudioFile,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _audioFile != null
                              ? AppColors.kPrimaryColor
                              : Colors.white.withOpacity(0.30),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _audioFile != null
                                ? Icons.audio_file
                                : Icons.upload_file,
                            color: _audioFile != null
                                ? AppColors.kPrimaryColor
                                : Colors.white54,
                            size: 35,
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Text(
                              _audioFileName ?? 'اضغط لاختيار ملف الصوت',
                              style: TextStyle(
                                color: _audioFile != null
                                    ? Colors.white
                                    : Colors.white54,
                                fontSize: 25,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  if (isUploading) ...[
                    const SizedBox(height: 30),
                    const LinearProgressIndicator(
                      color: Colors.white,
                      backgroundColor: Colors.white12,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'جاري رفع الدرس إلى السيرفر...',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 18),
                    ),
                  ],

                  const Spacer(),

                  // ✅ زر الرفع: عرض مصغّر وفي المنتصف بدل امتداد الشاشة
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 60,
                      child: ElevatedButton(
                        onPressed: isUploading ? null : _uploadLesson,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.kPrimaryColor,
                          disabledBackgroundColor:
                              AppColors.kPrimaryColor.withOpacity(0.4),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: isUploading
                            ? const SizedBox(
                                width: 28,
                                height: 28,
                                child: CircularProgressIndicator(
                                  color: Colors.black,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Text(
                                'رفع الدرس',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}