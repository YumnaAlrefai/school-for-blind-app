import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/glass_card.dart';
import 'package:parent_project/Widget/build_button.dart';
import 'package:parent_project/Widget/build_text_field.dart';

class DonationParent extends StatefulWidget {
  const DonationParent({super.key});

  @override
  State<DonationParent> createState() => _DonationParentState();
}

class _DonationParentState extends State<DonationParent> {
  final _formKey = GlobalKey<FormState>();

  // ------- كونترولرز الصفحة الأولى -------
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  // ------- كونترولرز الصفحة الثانية -------
  // موجودة هون (بالصفحة الأولى) عشان تبقى حية بالذاكرة
  // حتى لو المستخدم رجع من الصفحة الثانية وفتحها من جديد
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController expiryDateController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    amountController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    postalCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background_waves.png',
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
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
                                    bottom: 160,
                                    top: 160,
                                    left: 16,
                                    right: 16,
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'معلومات التبرع:',
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        BuildTextField(
                                          controller: nameController,
                                          iconPath: 'assets/icons/account.svg',
                                          hint: 'الاسم',
                                        ),
                                        const SizedBox(height: 20),
                                        BuildTextField(
                                          controller: amountController,
                                          iconPath:
                                              'assets/icons/money-bill-wave-solid.svg',
                                          hint: 'المبلغ',
                                          keyboardType: TextInputType.phone,
                                        ),
                                        const SizedBox(height: 40),
                                        BuildButton(
                                          label: 'التالي',
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DonationParent2(
                                                  cardNumberController:
                                                      cardNumberController,
                                                  expiryDateController:
                                                      expiryDateController,
                                                  cvvController: cvvController,
                                                  postalCodeController:
                                                      postalCodeController,
                                                ),
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
                          ),
                        ),
                      );
                    },
                  ),

                  // ------- سهم الرجوع أعلى اليسار -------
                  Positioned(
                    top: 8,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.subdirectory_arrow_left_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DonationParent2 extends StatefulWidget {
  final TextEditingController cardNumberController;
  final TextEditingController expiryDateController;
  final TextEditingController cvvController;
  final TextEditingController postalCodeController;

  const DonationParent2({
    super.key,
    required this.cardNumberController,
    required this.expiryDateController,
    required this.cvvController,
    required this.postalCodeController,
  });

  @override
  State<DonationParent2> createState() => _DonationParentState2();
}

class _DonationParentState2 extends State<DonationParent2> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/images/background_waves.png',
                fit: BoxFit.cover,
              ),
            ),

            SafeArea(
              child: Stack(
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
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
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            'معلومات التبرع:',
                                            textAlign: TextAlign.right,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 40,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 20),
                                        BuildTextField(
                                          controller:
                                              widget.cardNumberController,
                                          iconPath:
                                              'assets/icons/money-check-solid.svg',
                                          iconSize: 30,
                                          hint: 'رقم البطاقة',
                                          keyboardType: TextInputType.phone,
                                        ),
                                        const SizedBox(height: 20),
                                        BuildTextField(
                                          controller:
                                              widget.expiryDateController,
                                          iconPath:
                                              'assets/icons/calendar-event.svg',
                                          iconSize: 20,
                                          hint: 'تاريخ انتهاء الصلاحية',
                                          keyboardType: TextInputType.phone,
                                        ),
                                        const SizedBox(height: 20),
                                        BuildTextField(
                                          controller: widget.cvvController,
                                          iconPath:
                                              'assets/icons/padlock2.svg',
                                          hint: 'الرمز السري',
                                          isPassword: true,
                                        ),
                                        const SizedBox(height: 20),
                                        BuildTextField(
                                          controller:
                                              widget.postalCodeController,
                                          iconPath:
                                              'assets/icons/mail-outline.svg',
                                          iconSize: 27,
                                          hint: 'الرمز البريدي',
                                        ),
                                        const SizedBox(height: 40),
                                        BuildButton(
                                          label: 'إرسال',
                                          onPressed: () {},
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

                  // ------- سهم الرجوع أعلى اليسار -------
                  Positioned(
                    top: 8,
                    left: 12,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.subdirectory_arrow_left_outlined,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}