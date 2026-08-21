import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/glass_card.dart';
import 'package:parent_project/Widget/build_button.dart';
import 'package:parent_project/Widget/build_text_field.dart';
import 'package:parent_project/Widget/theme_listener.dart';
import '../../logic/cubit/donation_cubit.dart';
import '../../logic/cubit/donation_state.dart';

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final limited =
        digitsOnly.length > 19 ? digitsOnly.substring(0, 19) : digitsOnly;

    final buffer = StringBuffer();
    for (int i = 0; i < limited.length; i++) {
      if (i != 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(limited[i]);
    }
    final formatted = buffer.toString();

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digitsOnly =
        newValue.text.replaceAll(RegExp(r'[^0-9]'), '');
    final limited =
        digitsOnly.length > 4 ? digitsOnly.substring(0, 4) : digitsOnly;

    String formatted = limited;
    if (limited.length >= 3) {
      formatted = '${limited.substring(0, 2)}/${limited.substring(2)}';
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DonationPaymentPage extends StatefulWidget {
  final String clientSecret;
  final String paymentIntentId;

  const DonationPaymentPage({
    super.key,
    required this.clientSecret,
    required this.paymentIntentId,
  });

  @override
  State<DonationPaymentPage> createState() => _DonationPaymentPageState();
}

class _DonationPaymentPageState extends State<DonationPaymentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  @override
  void dispose() {
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  bool _parseExpiry(String raw, void Function(int month, int year) onParsed) {
    final cleaned = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleaned.length < 4) return false;

    final month = int.tryParse(cleaned.substring(0, 2));
    final yearPart = cleaned.substring(2, 4);
    final year = int.tryParse(yearPart);

    if (month == null || year == null) return false;
    if (month < 1 || month > 12) return false;

    onParsed(month, 2000 + year);
    return true;
  }

  void _submit() {
    final cardNumber =
        cardNumberController.text.replaceAll(RegExp(r'\s'), '').trim();
    final cvv = cvvController.text.trim();
    final postalCode = postalCodeController.text.trim();

    if (cardNumber.isEmpty || cardNumber.length < 12) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم بطاقة صحيح')),
      );
      return;
    }

    if (cvv.isEmpty || cvv.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الرمز السري (CVC) بشكل صحيح')),
      );
      return;
    }

    int? expMonth;
    int? expYear;
    final validExpiry = _parseExpiry(expiryDateController.text, (m, y) {
      expMonth = m;
      expYear = y;
    });

    if (!validExpiry) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال تاريخ الصلاحية بصيغة MM/YY')),
      );
      return;
    }

    final cardDetails = CardDetails(
      number: cardNumber,
      expirationMonth: expMonth,
      expirationYear: expYear,
      cvc: cvv,
    );

    context.read<DonationCubit>().payWithCard(
          clientSecret: widget.clientSecret,
          paymentIntentId: widget.paymentIntentId,
          cardDetails: cardDetails,
          postalCode: postalCode.isEmpty ? '10001' : postalCode,
        );
  }

  @override
  Widget build(BuildContext context) {
    return ThemeListener(
      builder: (context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: AppColors.bgDark,
          resizeToAvoidBottomInset: false,
          body: BlocConsumer<DonationCubit, DonationState>(
            listener: (context, state) {
              if (state is DonationConfirmSuccess) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (state is DonationConfirmFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
                Navigator.popUntil(context, (route) => route.isFirst);
              } else if (state is DonationPaymentFailure) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
            builder: (context, state) {
              final isLoading =
                  state is DonationPaymentLoading ||
                  state is DonationConfirmLoading;

              return Stack(
                children: [
                  SafeArea(
                    child: Stack(
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(
                                  context,
                                ).viewInsets.bottom,
                              ),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15,
                                    ),
                                    child: GlassCard(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 80,
                                          top: 80,
                                          left: 16,
                                          right: 16,
                                        ),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  'بيانات البطاقة:',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                    color:
                                                        AppColors.textPrimary,
                                                    fontSize: 40,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 20),

                                              BuildTextField(
                                                controller:
                                                    cardNumberController,
                                                iconPath:
                                                    'assets/icons/money-check-solid.svg',
                                                iconSize: 30,
                                                hint: 'رقم البطاقة',
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  _CardNumberFormatter(),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              BuildTextField(
                                                controller:
                                                    expiryDateController,
                                                iconPath:
                                                    'assets/icons/calendar-event.svg',
                                                iconSize: 20,
                                                hint:
                                                    'تاريخ الصلاحية (مثال: 12/25)',
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  _ExpiryDateFormatter(),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              BuildTextField(
                                                controller: cvvController,
                                                iconPath:
                                                    'assets/icons/padlock2.svg',
                                                hint: 'الرمز السري',
                                                isPassword: true,
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                  LengthLimitingTextInputFormatter(
                                                      4),
                                                ],
                                              ),
                                              const SizedBox(height: 20),
                                              BuildTextField(
                                                controller:
                                                    postalCodeController,
                                                iconPath:
                                                    'assets/icons/mail-outline.svg',
                                                iconSize: 27,
                                                hint:
                                                    'الرمز البريدي (اختياري)',
                                              ),
                                              const SizedBox(height: 40),
                                              isLoading
                                                  ? CircularProgressIndicator(
                                                      color: AppColors
                                                          .textPrimary,
                                                    )
                                                  : BuildButton(
                                                      label: 'إرسال',
                                                      onPressed: _submit,
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
                          },
                        ),
                        Positioned(
                          top: 8,
                          left: 12,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(
                              Icons.subdirectory_arrow_left_outlined,
                              color: AppColors.textPrimary,
                              size: 34,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}