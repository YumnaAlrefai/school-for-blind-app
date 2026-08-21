import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/glass_card.dart';
import 'package:parent_project/Widget/build_button.dart';
import 'package:parent_project/Widget/build_text_field.dart';

class LogParent extends StatefulWidget {
  const LogParent({super.key});

  @override
  State<LogParent> createState() => _LogParentState();
}

class _LogParentState extends State<LogParent> {
  bool _obscurePassword = true;

 
  static const Color fieldBorder = Color.fromARGB(69, 212, 255, 84);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: Stack(
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
                  padding: const EdgeInsets.only(
                    bottom: 85,
                    top: 85,
                    left: 20,
                    right: 20,
                
                    ),
                  child: GlassCard(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BuildTextField(
                            iconPath:'assets/icons/phone-portrait-outline.svg',
                            hint: 'رقم الهاتف',
                            keyboardType: TextInputType.phone,
                          ),
                          const SizedBox(height: 25),
                          BuildTextField(
                            iconPath: 'assets/icons/padlock.svg',
                            hint: 'كلمة المرور',
                            isPassword: true,
                          ),
                          const SizedBox(height: 40),
                          BuildButton(label: 'تأكيد',onPressed: () {  },)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}