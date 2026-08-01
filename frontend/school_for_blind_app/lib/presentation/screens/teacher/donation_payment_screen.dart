import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/donation_info_screen.dart';


class DonationPaymentScreen extends StatefulWidget {
  final String donorName;
  final num amount;

  const DonationPaymentScreen({
    super.key,
    this.donorName = '',
    required this.amount,
  });

  @override
  State<DonationPaymentScreen> createState() => _DonationPaymentScreenState();
}

class _DonationPaymentScreenState extends State<DonationPaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _postalController = TextEditingController();

  bool _processing = false;
  bool _stripeReady = false;
  String? _initError;

  static const String _publishableKey ='pk_test_51TuITGGaofOb9itwQMf2VMYOxOMPSIVPgI3dsJD8iYIOTVknzw9bCi8jBaqFh3d98GBk0QHtq2YqHvOCP4l8YLhL00mI4V5B3f';


  @override
  void initState() {
    super.initState();
    _initStripe();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  Future<void> _initStripe() async {
    try {
      if (!_publishableKey.startsWith('pk_')) {
        throw Exception('مفتاح Stripe غير مضبوط');
      }
      Stripe.publishableKey = _publishableKey;
      await Stripe.instance.applySettings();
      if (mounted) setState(() => _stripeReady = true);
    } catch (e) {
      debugPrint('🔴 STRIPE INIT ERROR: $e');
      if (mounted) setState(() => _initError = 'تعذّر تهيئة بوابة الدفع');
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(fontSize: 20))),
    );
  }

  ({int month, int year})? _parseExpiry(String raw) {
    final cleaned = raw.replaceAll(RegExp(r'\s'), '');
    final parts = cleaned.split('/');
    if (parts.length != 2) return null;
    final m = int.tryParse(parts[0]);
    var y = int.tryParse(parts[1]);
    if (m == null || y == null) return null;
    if (m < 1 || m > 12) return null;
    if (y < 100) y += 2000; 
    return (month: m, year: y);
  }

  Future<void> _onSend() async {
    if (_processing) return;

    final cardNumber = _cardNumberController.text.replaceAll(' ', '').trim();
    if (cardNumber.length < 13) {
      _showMessage('أدخل رقم بطاقة صحيح');
      return;
    }
    final expiry = _parseExpiry(_expiryController.text);
    if (expiry == null) {
      _showMessage('أدخل تاريخ صلاحية صحيح (مثال: 12/30)');
      return;
    }
    final cvc = _cvcController.text.trim();
    if (cvc.length < 3) {
      _showMessage('أدخل الرمز السري (CVC)');
      return;
    }

    setState(() => _processing = true);
    final repo = getIt<TeacherRepo>();

    try {
      await Stripe.instance.dangerouslyUpdateCardDetails(
        CardDetails(
          number: cardNumber,
          expirationMonth: expiry.month,
          expirationYear: expiry.year,
          cvc: cvc,
        ),
      );

      final body = <String, dynamic>{'amount': widget.amount};
      if (widget.donorName.trim().isNotEmpty) {
        body['name'] = widget.donorName.trim();
      }

      final checkout = await repo.donationCheckout(body);

      String? clientSecret;
      String? paymentIntentId;
      checkout.when(
        success: (data) {
          final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
          clientSecret = map['client_secret']?.toString();
          paymentIntentId = map['payment_intent_id']?.toString();
        },
        failure: (_) {},
      );

      if (clientSecret == null || clientSecret!.isEmpty) {
        setState(() => _processing = false);
        _showMessage('تعذّر بدء عملية التبرع، حاول مجدداً');
        return;
      }

      final postal = _postalController.text.trim();
      await Stripe.instance.confirmPayment(
        paymentIntentClientSecret: clientSecret!,
        data: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: widget.donorName.trim().isEmpty
                  ? null
                  : widget.donorName.trim(),
              address: postal.isEmpty
                  ? null
                  : Address(
                      postalCode: postal,
                      city: null,
                      country: null,
                      line1: null,
                      line2: null,
                      state: null,
                    ),
            ),
          ),
        ),
      );

      if (paymentIntentId != null && paymentIntentId!.isNotEmpty) {
        await repo.donationConfirm({'payment_intent_id': paymentIntentId});
      }

      if (!mounted) return;
      setState(() => _processing = false);
      _showThankYouDialog();
    } on StripeException catch (e) {
      debugPrint('🔴 STRIPE ERROR: ${e.error}');
      if (!mounted) return;
      setState(() => _processing = false);
      _showMessage(e.error.localizedMessage ?? 'فشلت عملية الدفع');
    } catch (e) {
      debugPrint('🔴 PAY ERROR: $e');
      if (!mounted) return;
      setState(() => _processing = false);
      _showMessage('حدث خطأ أثناء الدفع، حاول مجدداً');
    }
  }

  void _showThankYouDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF12283A),
          title: const Text('شكراً لك',
              style: TextStyle(color: Colors.white, fontSize: 26)),
          content: const Text('تم استلام تبرعك بنجاح.',
              style: TextStyle(color: Colors.white70, fontSize: 20)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('حسناً',
                  style:
                      TextStyle(color: AppColors.kPrimaryColor, fontSize: 20)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_initError != null) {
      return DonationScaffold(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_initError!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white70, fontSize: 22.sp)),
              SizedBox(height: 16.h),
              TextButton(
                onPressed: () {
                  setState(() => _initError = null);
                  _initStripe();
                },
                child: Text('إعادة المحاولة',
                    style: TextStyle(
                        color: AppColors.kPrimaryColor, fontSize: 20.sp)),
              ),
            ],
          ),
        ),
      );
    }

    if (!_stripeReady) {
      return const DonationScaffold(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
        ),
      );
    }

    return DonationScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 330.w,
            child: Text(
              'معلومات التبرع:',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.sp,
                fontFamily: 'ArabicTypesetting',
              ),
            ),
          ),
          SizedBox(height: 20.h),

          _buildField(
            controller: _cardNumberController,
            hint: 'رقم البطاقة',
            icon: Icons.credit_card,
            keyboardType: TextInputType.number,
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
            ],
          ),
          SizedBox(height: 16.h),

          _buildField(
            controller: _expiryController,
            hint: 'تاريخ انتهاء الصلاحية',
            icon: Icons.calendar_today,
            keyboardType: TextInputType.number,
            formatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9/]')),
              LengthLimitingTextInputFormatter(5),
            ],
          ),
          SizedBox(height: 16.h),

          _buildField(
            controller: _cvcController,
            hint: 'الرمز السري',
            icon: Icons.lock_outline,
            keyboardType: TextInputType.number,
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
          ),
          SizedBox(height: 16.h),

          _buildField(
            controller: _postalController,
            hint: 'الرمز البريدي',
            icon: Icons.mail_outline,
            keyboardType: TextInputType.number,
            formatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(10),
            ],
          ),
          SizedBox(height: 28.h),

          _processing
              ? const CircularProgressIndicator(color: AppColors.kPrimaryColor)
              : DonationButton(label: 'إرسال', onTap: _onSend),
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? formatters,
  }) {
    return Container(
      width: 330.w,
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        border: Border.all(
          color: AppColors.kPrimaryColor.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.kPrimaryColor, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: formatters,
              textAlign: TextAlign.right,
              style: TextStyle(color: Colors.white, fontSize: 25.sp),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    TextStyle(color: Colors.white38, fontSize: 25.sp),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}