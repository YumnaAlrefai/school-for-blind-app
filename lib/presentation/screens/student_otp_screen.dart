import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/otp_field.dart';

class StudentOtpScreen extends StatefulWidget {
  const StudentOtpScreen({super.key});

  @override
  State<StudentOtpScreen> createState() => _StudentOtpScreenState();
}

class _StudentOtpScreenState extends State<StudentOtpScreen> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleScreenTap();
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _handleScreenTap() {
    for (int i = 0; i < 6; i++) {
      if (_controllers[i].text.isEmpty) {
        _focusNodes[i].requestFocus();
        return;
      }
    }
    _focusNodes[5].requestFocus();
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }

    if (_controllers.every((c) => c.text.isNotEmpty)) {
      final otp = _controllers.map((c) => c.text).join();
      context.read<AuthCubit>().emitVerifyOTP(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(backgroundColor: AppColors.kBackgroundColor),
      body: BlocConsumer<AuthCubit, ResultState<dynamic>>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              getIt<VoiceServices>().speak(data.toString());
              context.read<AuthCubit>().resetState();
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.kStudentRegisterDataScreen,
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
          return Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _handleScreenTap,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 30),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          'رمز التحقق:',
                          style: AppTextStyles.kMediumPrimary,
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    _buildOTPGrid(),
                  ],
                ),
              ),

              if (state is Loading)
                Container(
                  color: AppColors.kBackgroundColor,
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.kPrimaryColor,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildOTPGrid() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            3,
            (i) => OTPField(
              controller: _controllers[i],
              focusNode: _focusNodes[i],
              onChanged: (val) => _onChanged(val, i),
              onBackspace: () {
                if (i > 0) {
                  _focusNodes[i - 1].requestFocus();
                  _controllers[i - 1].clear();
                }
              },
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            3,
            (i) => OTPField(
              controller: _controllers[i + 3],
              focusNode: _focusNodes[i + 3],
              onChanged: (val) => _onChanged(val, i + 3),
              onBackspace: () {
                if ((i + 3) > 0) {
                  _focusNodes[i + 3 - 1].requestFocus();
                  _controllers[i + 3 - 1].clear();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
