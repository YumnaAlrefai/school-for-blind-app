import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/student/otp_field.dart';

class StudentOtpScreen extends StatefulWidget {
  const StudentOtpScreen({super.key});

  @override
  State<StudentOtpScreen> createState() => _StudentOtpScreenState();
}

class _StudentOtpScreenState extends State<StudentOtpScreen>
    with WidgetsBindingObserver {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );

  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleScreenTap();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    for (var c in _controllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _handleScreenTap();
    }
  }

  void _handleScreenTap() {
    FocusScope.of(context).unfocus();
    int targetIndex = 5;
    for (int i = 0; i < 6; i++) {
      if (_controllers[i].text.isEmpty) {
        targetIndex = i;
        break;
      }
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[targetIndex].requestFocus();
      SystemChannels.textInput.invokeMethod('TextInput.show');
    });
  }

  void _onChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_controllers.every((c) => c.text.isNotEmpty)) {
      final otp = _controllers.map((c) => c.text).join();
      context.read<AuthCubit>().emitVerifyOTP(otp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(
        helpMessage:
            'لقد أرسلْلنا إلى رقمك على الواتساب رمزَ تَحقُّقٍ لإثباتِ أنك صاحبُ الرقم،اِملأ هذا الرمز في الحقول في منتصف الشاشة',
      ),
      body: BlocConsumer<AuthCubit, ResultState<dynamic>>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) {
              getIt<VoiceServices>().speak(data.toString());
              context.read<AuthCubit>().resetState();

              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.kSUserTypeScreen,
                (route) => false,
              );
              Navigator.pushNamed(context, AppRoutes.kStudentAccountsScreen);
              Navigator.pushNamed(
                context,
                AppRoutes.kStudentRegisterNumberScreen,
              );
              Navigator.pushNamed(
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
                          style: AppTextStyles.kMediumPrimary(context),
                        ),
                      ),
                    ),
                    SizedBox(height: 25.h),
                    _buildOTPGrid(),
                    SizedBox(height: 50.h),
                    if (state is Failure)
                      PrimaryButton(
                        title: 'إعادة التأكيد',
                        width: 332,
                        height: 97,
                        fontSize: 48,
                        onPressed: () {
                          final otp = _controllers.map((c) => c.text).join();
                          context.read<AuthCubit>().emitVerifyOTP(otp);
                        },
                      ),
                    SizedBox(height: 50.h),
                  ],
                ),
              ),

              if (state is Loading)
                Container(
                  color: Theme.of(context).colorScheme.background,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.primary,
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
                  _controllers[i - 1].clear();
                  _focusNodes[i - 1].requestFocus();
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
                int currentIndex = i + 3;
                if (currentIndex > 0) {
                  _controllers[currentIndex - 1].clear();
                  _focusNodes[currentIndex - 1].requestFocus();
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
