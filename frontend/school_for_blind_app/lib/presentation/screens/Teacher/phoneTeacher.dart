import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/data/models/app_validator.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/otp.dart';

class Phoneteacher extends StatefulWidget {
  const Phoneteacher({super.key});

  @override
  State<Phoneteacher> createState() => _PhoneteacherState();
}

class _PhoneteacherState extends State<Phoneteacher> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // إعادة تهيئة حالة الـ Cubit عند دخول الشاشة
    context.read<AuthCubit>().resetState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // إغلاق لوحة المفاتيح عند الضغط في أي مكان خارج الحقل
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.kTextSecondary,
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView( // منع حدوث overflow عند ظهور لوحة المفاتيح
                child: Container(
                  width: 362,
                  height: 707,
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColors.kTextSecondary,
                    border: Border.all(
                      color: Colors.white24,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                        child: Column(
                          children: [
                            SizedBox(
                              width: 330,
                              height: 70, 
                              child: TextFormField( // تم تحويله إلى TextFormField لدعم الـ Validation
                                controller: _phoneController,
                                textAlign: TextAlign.right,
                                style: const TextStyle(color: Colors.white), 
                                keyboardType: TextInputType.phone,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                // إضافة الـ validator العادي للشاشة
                                validator: (value) {
                                  return AppValidator.phoneValidation(value ?? '');
                                },
                                decoration: InputDecoration(
                                  hintText: "رقم الهاتف",
                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 28),
                                  prefixIcon: const Icon(
                                    Icons.phone_android,
                                    color: AppColors.kPrimaryColor,
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    borderSide: const BorderSide(
                                      color: Colors.grey,
                                    ),
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
                                    borderSide: const BorderSide(
                                      color: Colors.red,
                                    ),
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
                            ),
                            const SizedBox(height: 30),
                            
                            // إدارة الحالات والتنقل بدون أصوات
                            BlocConsumer<AuthCubit, ResultState<dynamic>>(
                              listener: (context, state) {
                                state.whenOrNull(
                                  success: (data) {
                                    // الانتقال مباشرة لواجهة الـ OTP عند النجاح
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const OtpScreen(),
                                      ),
                                    );
                                  },
                                  failure: (networkException) {
                                    // تم الاستغناء عن نطق رسالة الخطأ صوتياً
                                  },
                                );
                              },
                              builder: (context, state) {
                                // إذا كانت الحالة تحميل، تظهر علامة الانتظار
                                if (state is Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.kPrimaryColor,
                                    ),
                                  );
                                }
                                
                                // زر الإرسال بناءً على الحالة الحالية
                                return SizedBox(
                                  width: 193,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // التحقق من صحة المدخلات عبر الـ Form الخاص بالـ TextFormField
                                      if (_formKey.currentState!.validate()) {
                                        // إرسال الرمز عبر الـ Cubit في حال كانت المدخلات سليمة
                                        context.read<AuthCubit>().emitSendOTP(
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
                                      state is Failure ? 'إعادة المحاولة' : 'التالي',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
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