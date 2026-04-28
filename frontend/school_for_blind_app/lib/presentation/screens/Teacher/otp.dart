import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/safe.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kTextSecondary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Container(
            width: 362,
            height: 707,
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),

             color: AppColors.kTextSecondary,

              border: Border.all(
                color: Colors.white24,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'رمز التأكيد:',
                    style: TextStyle(
                     
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Pinput(
                  length: 6,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  defaultPinTheme: PinTheme(
                    width: 45,
                    height: 45,
                    textStyle: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFD3FF54).withOpacity(0.6),
                      ),
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFD3FF54),
                        width: 2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 50),
                SizedBox(
                  width: 193,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SecurityScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD3FF54),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: const Text('التالي', style: TextStyle(color: Colors.black, fontSize: 40, fontWeight: FontWeight.bold)),
                  ),
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}