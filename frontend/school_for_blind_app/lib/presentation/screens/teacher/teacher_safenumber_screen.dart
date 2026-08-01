import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher/teacher_cubit.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

class SecurityScreen extends StatefulWidget {
  final File cvFile;
  const SecurityScreen({super.key, required this.cvFile});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
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
      backgroundColor: AppColors.kTextSecondary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Container(
            width: 362,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 0.3),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                    'الأمان:',
                    style: 
                    TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),

                  
                  buildPasswordField(
                    hint: 'كلمة المرور',
                    controller: _passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'الرجاء إدخال رمز الأمان';
                      }
                      if (value.length < 8) {
                        return 'يجب أن لا يقل عن 8 أحرف';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 15),

                  
                  buildPasswordField(
                    hint: 'تأكيد كلمة المرور',
                    controller: _confirmPasswordController,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'كلمة المرور غير متطابقة';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 40),

                  
                  Center(
                    child: BlocConsumer<TeacherCubit, ResultState<dynamic>>(
                      listener: (context, state) {
                        state.whenOrNull(
                          success: (message) {
                            _showSnackBar("تم إنشاء الحساب بنجاح!", isError: false);
                            
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              AppRoutes.kTeacherLogin,
                              (route) => false,
                            );
                          },
                          failure: (networkException) {
                            _showSnackBar("فشل التسجيل: تأكد من صحة البيانات أو حاول لاحقاً");
                          },
                        );
                      },
                      builder: (context, state) {
                        bool isLoading = false;
                        state.whenOrNull(loading: () => isLoading = true);

                        if (isLoading) {
                          return const CircularProgressIndicator(
                            color: Color(0xFFD4FF5E),
                          );
                        }

                        return SizedBox(
                          width: 193,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                
                                final cubit = context.read<TeacherCubit>();
                                cubit.password = _passwordController.text;
                                cubit.passwordConfirmation = _confirmPasswordController.text;

                                
                                cubit.emitRegisterTeacher(widget.cvFile);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD4FF5E),
                              foregroundColor: AppColors.kTextSecondary,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: const Text(
                              'تأكيد',
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPasswordField({
    required String hint,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: controller,
        validator: validator,
        obscureText: true,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 24),
          suffixIcon: const Icon(Icons.visibility_off_outlined, color: Colors.grey, size: 20),
          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFD4FF5E), size: 22),
          filled: true,
          fillColor: Colors.transparent,
          contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFD3FF54), width: 0.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFD3FF54), width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
        ),
      ),
    );
  }
}