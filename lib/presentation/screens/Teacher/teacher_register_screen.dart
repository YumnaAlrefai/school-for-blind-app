import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher_cubit.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

class RegisterTeacher extends StatefulWidget {
  const RegisterTeacher({super.key});

  @override
  State<RegisterTeacher> createState() => _RegisterTeacherState();
}

class _RegisterTeacherState extends State<RegisterTeacher> {
  final _formKey = GlobalKey<FormState>();
  String selectedLevel = "";
  String? _pdfName;
  File? _cvFile;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _subjectController.dispose();
    super.dispose();
  }

  Future<void> _pickPDF() async {
    try {
      FilePickerResult? result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _pdfName = result.files.single.name;
          _cvFile = File(result.files.single.path!);
        });
        print("تم اختيار الملف بنجاح: ${result.files.single.path}");
      } else {
        print("لم يتم اختيار أي ملف");
      }
    } catch (e) {
      print("حدث خطأ أثناء اختيار الملف: $e");
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: isError ? Colors.red : AppColors.kPrimaryColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.88,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey, width: 0.3),
              color: AppColors.kBackgroundColor,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "المعلومات الشخصية:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildTextField(
                    "الاسم الثلاثي",
                    Icons.person,
                    controller: _nameController,
                  ),
                  const SizedBox(height: 20),

                  _buildTextField(
                    "المادة المعطاة",
                    Icons.menu_book_rounded,
                    controller: _subjectController,
                  ),
                  const SizedBox(height: 25),

                  const Text(
                    "المرحلة الدراسية:",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildLevelButton("تاسع"),
                      _buildLevelButton("بكالوريا"),
                    ],
                  ),

                  const SizedBox(height: 25),
                  const Text(
                    "السيرة الذاتية:",
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const SizedBox(height: 10),

                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: _pickPDF,
                      child: Container(
                        width: _pdfName != null ? null : 150,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        decoration: BoxDecoration(
                          color: _pdfName != null
                              ? const Color(0xFFD3FF54).withOpacity(0.1)
                              : Colors.transparent,
                          border: Border.all(
                            color: const Color(0xFFD3FF54).withOpacity(0.5),
                            width: 0.5,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _pdfName != null
                                  ? Icons.check_circle_outline
                                  : Icons.file_upload_outlined,
                              color: const Color(0xFFD3FF54),
                            ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                _pdfName ?? "إضافة ملف",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 20,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Center(
                    child: BlocConsumer<TeacherCubit, ResultState<dynamic>>(
                      listener: (context, state) {
                        state.whenOrNull(
                          success: (message) {
                            _showSnackBar(message.toString(), isError: false);

                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.kTeacherLogin,
                                (route) => false,
                              );
                            });
                          },
                          failure: (networkException) {
                            _showSnackBar(
                              "فشل التسجيل: تأكد من صحة البيانات المرسلة وسجل الهاتف",
                            );
                          },
                        );
                      },
                      builder: (context, state) {
                        bool isLoading = false;
                        state.whenOrNull(loading: () => isLoading = true);

                        if (isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFFD3FF54),
                            ),
                          );
                        }

                        return Center(
                          child: ElevatedButton(
                            onPressed: () {
                              if (_nameController.text.trim().isEmpty) {
                                _showSnackBar("رجاءً أدخل الاسم الثلاثي");
                              } else if (_subjectController.text
                                  .trim()
                                  .isEmpty) {
                                _showSnackBar("رجاءً أدخل المادة المعطاة");
                              } else if (selectedLevel.isEmpty) {
                                _showSnackBar("رجاءً اختر المرحلة الدراسية");
                              } else if (_cvFile == null) {
                                _showSnackBar(
                                  "رجاءً أضف ملف السيرة الذاتية PDF",
                                );
                              } else {
                                final cubit = context.read<TeacherCubit>();
                                cubit.fullName = _nameController.text.trim();
                                cubit.subjects = _subjectController.text.trim();

                                if (selectedLevel == "تاسع") {
                                  cubit.level = "ninth";
                                } else if (selectedLevel == "بكالوريا") {
                                  cubit.level = "twelfth";
                                } else {
                                  cubit.level = selectedLevel;
                                }

                                WidgetsBinding.instance.addPostFrameCallback((
                                  _,
                                ) {
                                  Navigator.pushNamed(
                                    context,
                                    AppRoutes.kTeachersecurity,
                                    arguments:
                                        _cvFile,
                                  );
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD3FF54),
                              minimumSize: const Size(200, 55),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              "التالي",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint,
    IconData icon, {
    bool isPhone = false,
    TextEditingController? controller,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white),
        keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
        inputFormatters: isPhone
            ? [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(10),
              ]
            : [],
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38, fontSize: 22),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 10, right: 12),
            child: Icon(icon, color: const Color(0xFFD3FF54), size: 22),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            minHeight: 0,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFD3FF54), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFD3FF54), width: 2.0),
          ),
          filled: true,
          fillColor: Colors.black.withOpacity(0.1),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 10,
          ),
        ),
      ),
    );
  }

  Widget _buildLevelButton(String label) {
    bool isSelected = selectedLevel == label;
    return GestureDetector(
      onTap: () => setState(() => selectedLevel = label),
      child: Container(
        width: 120,
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.kBackgroundColor,
          border: Border.all(
            color: AppColors.kPrimaryColor,
            width: isSelected ? 2.5 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.kPrimaryColor,
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFFD3FF54) : Colors.white,
              fontSize: 20,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
