import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/teacher_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
// تأكدي من استيراد ملف الـ routes الخاص بك، كمثال:
// import 'package:school_for_blind_app/core/routing/routes.dart'; 

class Phoneteacher extends StatelessWidget {
  const Phoneteacher({super.key});

  @override
  Widget build(BuildContext context) {
    // تم إزالة الـ BlocProvider من هنا لأن الـ Router يقوم بحقنه تلقائياً الآن
    return const PhoneTeacherForm();
  }
}

class PhoneTeacherForm extends StatefulWidget {
  const PhoneTeacherForm({super.key});

  @override
  State<PhoneTeacherForm> createState() => _PhoneTeacherFormState();
}

class _PhoneTeacherFormState extends State<PhoneTeacherForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.kTextSecondary,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
              child: Form(
                key: _formKey,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 362),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.kTextSecondary,
                    border: Border.all(color: Colors.white24, width: 1),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        textAlign: TextAlign.right,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'الرجاء إدخال رقم الهاتف';
                          }
                          if (value.length < 10) {
                            return 'يجب أن يتكون الرقم من 10 خانات';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "رقم الهاتف",
                          hintStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 24,
                          ),
                          prefixIcon: const Icon(
                            Icons.phone_android,
                            color: AppColors.kPrimaryColor,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: AppColors.kPrimaryColor,
                              width: 2,
                            ),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: 193,
                        height: 54,
                        child: BlocConsumer<TeacherCubit, ResultState<dynamic>>(
                          listener: (context, state) {
                            state.whenOrNull(
                              success: (data) {
                                // التعديل الجوهري: الانتقال باستخدام الـ Named Route المعرف في الـ Router
                                Navigator.pushNamed(context, AppRoutes.kTeacherotb);
                              },
                              failure: (networkException) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'فشل إرسال الرمز، تحقق من الاتصال بالشبكة',
                                      textAlign: TextAlign.right,
                                    ),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              },
                            );
                          },
                          builder: (context, state) {
                            bool isLoading = state.toString().contains('loading');

                            if (isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.kPrimaryColor,
                                ),
                              );
                            }

                            bool isFailure = state.toString().contains('failure');

                            return ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<TeacherCubit>().emitSendOTP(
                                    _phoneController.text,
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFD3FF54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              child: Text(
                                isFailure ? 'إعادة إرسال الرمز' : 'إرسال رمز التحقق',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}