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

class StudentRegisterNumberScreen extends StatefulWidget {
  const StudentRegisterNumberScreen({super.key});

  @override
  State<StudentRegisterNumberScreen> createState() =>
      _StudentRegisterNumberScreenState();
}

class _StudentRegisterNumberScreenState
    extends State<StudentRegisterNumberScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
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
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          helpMessage:
              'أنت الآنَ في صفحة إنشاءِ حسابْ، أَدخِلْ رقم هاتِفكَ المحمولِ في الحقل الموجود في منتصف الشاشة باستخدام لوحة المفاتيح العاديةْ، ثم اضغطْ على زر الإرسالِ أسفله، عندها سيتم إرسالُ رمزِ تَحقُّقٍ إلى رقمك على الواتساب والانتقال للصفحة التالية لتأكيد الرمز.',
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
                      hintText: 'رقم الطالب',
                      icon: Icons.phone,
                      controller: _phoneController,
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
                            getIt<VoiceServices>().speak(data.toString());
                            Navigator.pushNamed(
                              context,
                              AppRoutes.kStudentOTPScreen,
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
                          title: state is Failure
                              ? 'إعادة إرسال الرمز'
                              : 'إرسال رمز التحقق',
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
                              context.read<AuthCubit>().emitSendOTP(
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
