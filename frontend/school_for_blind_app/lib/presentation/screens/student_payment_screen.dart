import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:school_for_blind_app/business_logic/cubit/donation_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_text_form_field.dart';

class StudentPaymentScreen extends StatefulWidget {
  final String clientSecret;
  final String paymentIntentId;

  const StudentPaymentScreen({
    super.key,
    required this.clientSecret,
    required this.paymentIntentId,
  });

  @override
  State<StudentPaymentScreen> createState() => _StudentPaymentScreenState();
}

class _StudentPaymentScreenState extends State<StudentPaymentScreen> {
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _postalController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _payWithStripe() async {
    if (_cardNumberController.text.trim().isEmpty ||
        _expiryController.text.trim().isEmpty ||
        _cvcController.text.trim().isEmpty) {
      getIt<VoiceServices>().speak(
        'الرجاء إدخال كافة معلومات البطاقة المطلوبة',
      );
      return;
    }
    final expiryParts = _expiryController.text.trim().split('/');
    if (expiryParts.length != 2) {
      getIt<VoiceServices>().speak(
        'صيغة التاريخ غير صحيحة، يرجى إدخال الشهر ثم السنة',
      );
      return;
    }
    final int? month = int.tryParse(expiryParts[0]);
    final int? year = int.tryParse(expiryParts[1]);

    if (month == null || year == null) {
      getIt<VoiceServices>().speak('التاريخ المدخل غير صالحة');
      return;
    }
    try {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      context.read<DonationCubit>().emit(const ResultState.loading());
      await Stripe.instance.dangerouslyUpdateCardDetails(
        CardDetails(
          number: _cardNumberController.text.trim(),
          expirationMonth: month,
          expirationYear: year,
          cvc: _cvcController.text.trim(),
        ),
      );
      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: widget.clientSecret,
        data: const PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );
      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        if (mounted) {
          context.read<DonationCubit>().emitConfirmPayment(
            widget.paymentIntentId,
          );
        }
      } else {
        // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
        context.read<DonationCubit>().emit(const ResultState.idle());
        getIt<VoiceServices>().speak(
          'عملية الدفع غير مكتملة، يرجى المحاولة مجدداً',
        );
      }
    } catch (e) {
      if (mounted) {
        // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
        context.read<DonationCubit>().emit(const ResultState.idle());
        getIt<VoiceServices>().speak(
          'فشلت عملية الدفع، يرجى التحقق من كَرت الدفع الخاص بك',
        );
        debugPrint("Stripe Exception: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(helpMessage: ''),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextfield(
                    controller: _cardNumberController,
                    hintText: 'رقم البطاقة',
                    icon: Icons.credit_card,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextfield(
                    controller: _expiryController,
                    hintText: 'الانتهاء MM/YY',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.datetime,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextfield(
                    controller: _cvcController,
                    hintText: 'الرمز السري',
                    icon: Icons.lock_outline,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 20.h),
                  CustomTextfield(
                    controller: _postalController,
                    hintText: 'الرمز البريدي',
                    icon: Icons.mail_outline,
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 40.h),
                  BlocConsumer<DonationCubit, ResultState<dynamic>>(
                    listener: (context, state) {
                      state.whenOrNull(
                        success: (data) {
                          getIt<VoiceServices>().speak(
                            'تمت عملية التبرع بنجاح، شكراً جزيلَنْ لدعمكم مدرسة المكفوفين',
                          );
                          Navigator.pop(context);
                        },
                        failure: (networkException) {
                          getIt<VoiceServices>().speak(
                            NetworkExceptions.getErrorMessage(networkException),
                          );
                        },
                      );
                    },
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        orElse: () => PrimaryButton(
                          title: 'إرسال',
                          width: 332,
                          height: 97,
                          fontSize: 48,
                          onPressed: _payWithStripe,
                        ),
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
