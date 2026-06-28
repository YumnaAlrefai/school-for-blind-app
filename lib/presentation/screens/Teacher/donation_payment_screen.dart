import 'package:flutter/material.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/donation_info_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DonationPaymentScreen extends StatefulWidget {
  const DonationPaymentScreen({super.key});

  @override
  State<DonationPaymentScreen> createState() => _DonationPaymentScreenState();
}

class _DonationPaymentScreenState extends State<DonationPaymentScreen> {
  final TextEditingController _cardController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _zipController = TextEditingController();

  @override
  void dispose() {
    _cardController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _submit() {
    // هنا يمكنك إرسال بيانات التبرع للسيرفر
    showDialog(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          backgroundColor: const Color(0xFF12283A),
          title: const Text('شكراً لك', style: TextStyle(color: Colors.white)),
          content: const Text(
            'تم استلام تبرعك بنجاح.',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // إغلاق الرسالة
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('حسناً'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DonationScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'معلومات التبرع:',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40,
              fontFamily: 'ArabicTypesetting',
            ),
          ),
          const SizedBox(height: 24),
          DonationField(
            icon: Icons.credit_score,
            hint: 'رقم البطاقة',
            controller: _cardController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          DonationField(
            icon: Icons.calendar_today_outlined,
            hint: 'تاريخ انتهاء الصلاحية',
            controller: _expiryController,
            keyboardType: TextInputType.datetime,
          ),
          const SizedBox(height: 16),
          DonationField(
            icon: Icons.lock_outline,
            hint: 'الرمز السري',
            controller: _cvvController,
            keyboardType: TextInputType.number,
            obscureText: true,
          ),
          const SizedBox(height: 16),
          DonationField(
            icon: Icons.markunread_outlined,
            hint: 'الرمز البريدي',
            controller: _zipController,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 28),
          Center(
            child: DonationButton(label: 'إرسال', onTap: _submit),
          ),
        ],
      ),
    );
  }
}
