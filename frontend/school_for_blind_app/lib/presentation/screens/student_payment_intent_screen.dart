import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/donation_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_text_form_field.dart';

class StudentPaymentIntentScreen extends StatefulWidget {
  const StudentPaymentIntentScreen({super.key});

  @override
  State<StudentPaymentIntentScreen> createState() =>
      _StudentPaymentIntentScreenState();
}

class _StudentPaymentIntentScreenState
    extends State<StudentPaymentIntentScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(helpMessage: ''),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextfield(
                    controller: _amountController,
                    hintText: 'المبلغ',
                    icon: Icons.attach_money_rounded,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 30.h),
                  BlocConsumer<DonationCubit, ResultState<dynamic>>(
                    listener: (context, state) {
                      state.whenOrNull(
                        success: (data) {
                          getIt<VoiceServices>().speak(
                            'تم تسجيل طلب التبرع بنجاح، يرجى إدخال معلومات بطاقة الدفع',
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.kStudentPaymentScreen,
                            arguments: [
                              data['client_secret'].toString(),
                              data['payment_intent_id'].toString(),
                            ],
                          );
                        },
                        failure: (networkException) {
                          getIt<VoiceServices>().speak(
                            NetworkExceptions.getErrorMessage(networkException),
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
                          if (_amountController.text.trim().isEmpty) {
                            getIt<VoiceServices>().speak(
                              'أدخل المبلغ الذي تريد التبرع به',
                            );
                          } else {
                            Map<String, dynamic> donationBody = {
                              "amount": int.parse(_amountController.text),
                            };
                            context.read<DonationCubit>().emitDonate(
                              donationBody,
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
    );
  }
}
