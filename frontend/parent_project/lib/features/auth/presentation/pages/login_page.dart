import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/build_button.dart';
import 'package:parent_project/Widget/build_text_field.dart';
import 'package:parent_project/Widget/glass_card.dart';
import 'package:parent_project/features/auth/logic/cubit/auth_cubit.dart';
import 'package:parent_project/features/auth/logic/cubit/auth_state.dart';
import 'package:parent_project/screens/reports_parent.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  static const Color bgDark = Color(0xFF000F24);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bgDark,
        
         resizeToAvoidBottomInset: false,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.response.message)));

              /// هنا تحفظ التوكن
              /// ثم تنتقل للصفحة الرئيسية
              Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ReportsParent(),
      ),
    );
            }

            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/background_waves.png',
                    fit: BoxFit.cover,
                  ),
                ),

                SafeArea(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                       // vertical: 85,
                      ),
                      child: GlassCard(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 165,top: 165,left: 16,right: 16),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BuildTextField(
                                  controller: phoneController,
                                  hint: "رقم الهاتف",
                                  iconPath:
                                      "assets/icons/phone-portrait-outline.svg",
                                  keyboardType: TextInputType.phone,
                                ),

                                const SizedBox(height: 25),

                                BuildTextField(
                                  controller: passwordController,
                                  hint: "كلمة المرور",
                                  iconPath: "assets/icons/padlock.svg",
                                  isPassword: true,
                                ),

                                const SizedBox(height: 40),

                                state is AuthLoading
                                    ? const CircularProgressIndicator()
                                    : BuildButton(
                                        label: "تأكيد",
                                        onPressed: () {
                                          if (!_formKey.currentState!
                                              .validate()) {
                                            return;
                                          }

                                          context.read<AuthCubit>().login(
                                            phone: phoneController.text.trim(),
                                            password: passwordController.text
                                                .trim(),
                                          );
                                        },
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
