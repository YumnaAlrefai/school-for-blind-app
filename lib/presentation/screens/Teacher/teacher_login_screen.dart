import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher_cubit.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/apiTeacher/web_services.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

class LoginTeacher extends StatefulWidget {
  const LoginTeacher({super.key});

  @override
  State<LoginTeacher> createState() => _LoginTeacherState();
}

class _LoginTeacherState extends State<LoginTeacher> {
  bool _isObscured = true;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.right,
          style: const TextStyle(
            fontSize: 20,
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
    return BlocProvider<TeacherCubit>(
      create: (context) {
        final dio = Dio();
        final webServices = WebServices(dio);
        final teacherRepo = TeacherRepo(webServices);
        return TeacherCubit(teacherRepo);
      },
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.kBackgroundColor,
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                color: AppColors.kBackgroundColor,
              ),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 150,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey, width: 0.3),
                      color: AppColors.kBackgroundColor,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                              ],
                              decoration: _buildInputDecoration(
                                "رقم الهاتف",
                                Icons.phone_android,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "يرجى إدخال رقم الهاتف";
                                } else if (!value.startsWith("09")) {
                                  return "يجب أن يبدأ الرقم بـ 09";
                                } else if (value.length != 10) {
                                  return "يجب أن يتكون الرقم من 10 خانات";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _isObscured,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                              decoration:
                                  _buildInputDecoration(
                                    "كلمة المرور",
                                    Icons.lock_outline,
                                  ).copyWith(
                                    prefixIcon: IconButton(
                                      icon: Icon(
                                        _isObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white54,
                                        size: 20,
                                      ),
                                      onPressed: () => setState(
                                        () => _isObscured = !_isObscured,
                                      ),
                                    ),
                                  ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "يرجى إدخال كلمة المرور";
                                } else if (value.length < 6) {
                                  return "يجب أن لا تقل عن 6 أرقام/حروف";
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                          BlocConsumer<TeacherCubit, ResultState<dynamic>>(
                            listener: (context, state) {
                              state.whenOrNull(
                                success: (data) {
                                  // _showSnackBar(
                                  //   "تم تسجيل الدخول بنجاح",
                                  //   isError: false,
                                  // );

                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    if (context.mounted) {
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.kSubjectScreen,
                                        (route) => false,
                                      );
                                    }
                                  });
                                },
                                failure: (error) {
                                  _showSnackBar(
                                    "فشل تسجيل الدخول: تحقق من البيانات أو السيرفر",
                                  );
                                },
                              );
                            },
                            builder: (context, state) {
                              bool isLoading = state.maybeWhen(
                                loading: () => true,
                                orElse: () => false,
                              );

                              if (isLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFD3FF54),
                                  ),
                                );
                              }

                              return GestureDetector(
                                onTap: () {
                                  if (_formKey.currentState!.validate()) {
                                    final cubit = context.read<TeacherCubit>();
                                    cubit.emitLoginTeacher(
                                      phone: _phoneController.text.trim(),
                                      password: _passwordController.text.trim(),
                                    );
                                  }
                                },
                                child: Container(
                                  width: 193,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: AppColors.kPrimaryColor,
                                    borderRadius: BorderRadius.circular(15),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0xFFD3FF54,
                                        ).withOpacity(0.3),
                                        blurRadius: 10,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      "تأكيد",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 32,
                                        fontFamily: 'ArabicTypesetting',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'ليس لديك حساب؟',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 18,
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.kTeacherRegister,
                                ),
                                child: const Text(
                                  'إنشاء حساب',
                                  style: TextStyle(
                                    color: Color(0xFFD3FF54),
                                    fontSize: 24,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54, fontSize: 32),
      prefixIcon: Icon(icon, color: const Color(0xFFD3FF54)),
      errorStyle: const TextStyle(
        color: Colors.redAccent,
        fontFamily: 'ArabicTypesetting',
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.white24),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFD3FF54)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Colors.redAccent, width: 2),
      ),
    );
  }
}
