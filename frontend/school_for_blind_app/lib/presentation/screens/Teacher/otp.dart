import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/signup.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _isOtpComplete = false;

  @override
  void initState() {
    super.initState();
    for (var controller in _controllers) {
      controller.addListener(_checkOtpCompletion);
    }
  }

  void _checkOtpCompletion() {
    bool complete = _controllers.every(
      (controller) => controller.text.isNotEmpty,
    );
    if (complete != _isOtpComplete) {
      setState(() {
        _isOtpComplete = complete;
      });
    }
  }

  @override
  void dispose() {
    for (var i = 0; i < 6; i++) {
      _controllers[i].dispose();
      _focusNodes[i].dispose();
    }
    super.dispose();
  }

  Widget _buildOtpField(int index) {
    bool isEnabled = index == 0 || _controllers[index - 1].text.isNotEmpty;

    return Container(
      width: 45,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isEnabled
              ? const Color(0xFFD4FF3A)
              : const Color(0xFFD4FF3A).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        enabled: isEnabled, 
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        showCursor: false,
        decoration: const InputDecoration(
          counterText: "",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              if (index < 5) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _focusNodes[index + 1].requestFocus();
                });
              } else {
                _focusNodes[index].unfocus(); 
              }
            });
          } else {
            setState(() {
              if (index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kTextSecondary,
      body: Center(
        child: Container(
          width: 362,
          height: 700,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 0.3),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 150),
                const Text(
                  'رمز التأكيد:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpField(0),
                    _buildOtpField(1),
                    _buildOtpField(2),
                  ],
                ),
                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildOtpField(3),
                    _buildOtpField(4),
                    _buildOtpField(5),
                  ],
                ),
                const SizedBox(height: 40),

                Center(
                  child: SizedBox(
                    width: 180,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isOtpComplete
                          ? () {
                              String fullOtp = _controllers
                                  .map((c) => c.text)
                                  .join();

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const RegisterTeacher(),
                                ),
                              );
                            }
                          : null, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        'التالي',
                        style: TextStyle(
                          color: _isOtpComplete ? Colors.black : Colors.white38,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
