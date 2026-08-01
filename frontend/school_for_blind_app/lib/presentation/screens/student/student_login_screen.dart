import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/data/models/student/app_validator.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_text_form_field.dart';

class StudentLoginScreen extends StatefulWidget {
  const StudentLoginScreen({super.key});

  @override
  State<StudentLoginScreen> createState() => _StudentLoginScreenState();
}

class _StudentLoginScreenState extends State<StudentLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<AuthCubit>().resetState();
    super.initState();
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
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          helpMessage:
              'أنت الآنَ في صفحة تسجيل الدخولْ، إن كانَ لديك حساب فيُمْكِنُكَ تسجيل الدخول عن طريق كتابة رقم هاتفك المحمول في الحقل الموجود في منتصف الشاشة باستخدام لوحة المفاتيح العاديةْ، ثم الضغط على زر التأكيد أسفله،عندها سيتم إرسال رابط تسجيل الدخول إلى رقمك على الواتساب، وبمجرد الضغط عليه سيتم دخولك إلى التطبيق تلقائياً دون الحاجة لكتابة أي كلمة مرور.',
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextfield(
                      controller: _phoneController,
                      hintText: 'رقم الهاتف',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    SizedBox(height: 30.h),
                    BlocConsumer<AuthCubit, ResultState<dynamic>>(
                      listener: (context, state) {
                        state.whenOrNull(
                          success: (data) {
                            getIt<VoiceServices>().speak(
                              'تم إرسال رابط تسجيل الدخول إلى رقمك على واتساب، يمكنك الضغط على الصورة لفتح التطبيق بسرعة',
                            );
                            context.read<AuthCubit>().resetState();

                            Navigator.pushNamed(
                              context,
                              AppRoutes.kStudentWhatsappScreen,
                            );
                          },
                          failure: (networkException) {
                            getIt<VoiceServices>().speak(
                              NetworkExceptions.getErrorMessage(
                                networkException,
                              ),
                            );
                          },
                        );
                      },
                      builder: (context, state) {
                        if (state is Loading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        }
                        return PrimaryButton(
                          title: 'تأكيد',
                          width: 332,
                          height: 97,
                          fontSize: 48,
                          onPressed: () {
                            if (AppValidator.phoneValidation(
                                  _phoneController.text,
                                ) !=
                                null) {
                              getIt<VoiceServices>().speak(
                                AppValidator.phoneValidation(
                                  _phoneController.text,
                                )!,
                              );
                            } else if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().emitLogin(
                                _phoneController.text,
                              );
                            }
                          },
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
    );
  }
}
