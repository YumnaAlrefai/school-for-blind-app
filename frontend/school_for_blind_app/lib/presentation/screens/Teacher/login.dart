import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart'; // ضروري لاستخدام الـ Formatters

class LoginTeacher extends StatefulWidget {
  const LoginTeacher({super.key});

  @override
  State<LoginTeacher> createState() => _LoginTeacherState();
}

class _LoginTeacherState extends State<LoginTeacher> {
  bool _isObscured = true;
  
  // مفتاح النموذج للتحقق من الحقول
  final _formKey = GlobalKey<FormState>();
  
  // المتحكمات بالنصوص
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // تشغيل عملية التحقق عند الضغط على زر تأكيد
    if (_formKey.currentState!.validate()) {
      // إذا كانت البيانات صحيحة
      print("البيانات صحيحة: ${_phoneController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
        color:  AppColors.kBackgroundColor,
        ),
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            height: MediaQuery.of(context).size.height * 0.80, // زدنا الطول قليلاً لاستيعاب رسائل الخطأ
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey, width: 0.3),
            color: AppColors.kBackgroundColor,
            ),
            child: Form(
              key: _formKey, // ربط النموذج بالمفتاح
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TextFormField(
                      
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.white,fontSize: 30),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      decoration: _buildInputDecoration("رقم الهاتف", Icons.phone_android),
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
                      style: const TextStyle(color: Colors.white,fontSize: 30),
                      decoration: _buildInputDecoration("كلمة المرور", Icons.lock_outline,).copyWith(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured ? Icons.visibility_off : Icons.visibility,
                            color: Colors.white54,
                            size: 20,
                          ),
                          onPressed: () => setState(() => _isObscured = !_isObscured),
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

                  GestureDetector(
                    onTap: _submitForm,
                    child: Container(
                      width: 180,
                      height: 54,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3FF54),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFD3FF54).withOpacity(0.3),
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
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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

  // دالة مساعدة لبناء تصميم الحقول لتقليل تكرار الكود
  InputDecoration _buildInputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white54),
      prefixIcon: Icon(icon, color: const Color(0xFFD3FF54)),
      errorStyle: const TextStyle(color: Colors.redAccent),   
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