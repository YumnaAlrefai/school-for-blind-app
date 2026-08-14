import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/donation_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_text_form_field.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_dropdown_field.dart';

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

  int? selectedMonth;
  int? selectedYear;

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
        'صيغة التاريخ غير صحيحة، يرجى اختيار الشهر والسنة',
      );
      return;
    }

    final int? month = int.tryParse(expiryParts[0]);
    final int? year = int.tryParse(expiryParts[1]);

    if (month == null || year == null) {
      getIt<VoiceServices>().speak('التاريخ المدخل غير صالح');
      return;
    }

    try {
      context.read<DonationCubit>().emit(const ResultState.loading());

      final cardDetails = CardDetails(
        number: _cardNumberController.text.trim().replaceAll(' ', ''),
        expirationMonth: month,
        expirationYear: year,
        cvc: _cvcController.text.trim(),
      );

      await Stripe.instance.dangerouslyUpdateCardDetails(cardDetails);

      final String postalCode = _postalController.text.trim().isEmpty
          ? '10001'
          : _postalController.text.trim();

      final paymentIntent = await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: widget.clientSecret,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              address: Address(
                postalCode: postalCode,
                country: 'US',
                city: 'Test',
                line1: 'Test',
                line2: '',
                state: '',
              ),
            ),
          ),
        ),
      );

      if (paymentIntent.status == PaymentIntentsStatus.Succeeded) {
        if (mounted) {
          context.read<DonationCubit>().emitConfirmPayment(
            widget.paymentIntentId,
          );
        }
      } else {
        context.read<DonationCubit>().emit(const ResultState.idle());
        getIt<VoiceServices>().speak(
          'عملية الدفع غير مكتملة، يرجى المحاولة مجدداً',
        );
      }
    } catch (e) {
      if (mounted) {
        context.read<DonationCubit>().emit(const ResultState.idle());
        getIt<VoiceServices>().speak(
          'فشلت عملية الدفع، يرجى التحقق من كَرت الدفع الخاص بك',
        );
        debugPrint("Stripe Exception الحقيقي هو: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: CustomAppBar(
          helpMessage:
              'أنتَ الآنَ في صفحةِ إدْخالِ مَعْلوماتِ البطاقَةِ المَصْرِفِيَّةِ لإتمامِ التَّبَرُّعِ، اِمْلَأْ رَقْمَ البطاقَةِ، وتاريخَ انْتِهاءِ صلاحيتها والرمزَ السِّرِّيَّ والبريدي، ثمّ اضْغَطْ على زِرِّ الإرسال لإتمامِ العَمَلِيَّةِ بأَمانٍ.',
        ),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomDropdownField(
                        hintText: 'الشهر',
                        icon: Icons.calendar_today,
                        value: selectedMonth,
                        items: List.generate(12, (i) => i + 1),
                        onChanged: (val) {
                          setState(() => selectedMonth = val);
                          final yy =
                              selectedYear ?? (DateTime.now().year % 100);
                          _expiryController.text =
                              '${selectedMonth.toString().padLeft(2, '0')}/${yy.toString().padLeft(2, '0')}';
                        },
                      ),
                      SizedBox(width: 16.w),
                      CustomDropdownField(
                        hintText: 'السنة',
                        icon: Icons.calendar_month,
                        value: selectedYear,
                        items: List.generate(
                          15,
                          (i) => (DateTime.now().year + i) % 100,
                        ),
                        onChanged: (val) {
                          setState(() => selectedYear = val);
                          final mm = selectedMonth ?? 1;
                          _expiryController.text =
                              '${mm.toString().padLeft(2, '0')}/${selectedYear.toString().padLeft(2, '0')}';
                        },
                      ),
                    ],
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
