import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';

class StudentWaitingScreen extends StatefulWidget {
  const StudentWaitingScreen({super.key});

  @override
  State<StudentWaitingScreen> createState() => _StudentWaitingScreenState();
}

class _StudentWaitingScreenState extends State<StudentWaitingScreen> {
  @override
  void initState() {
    super.initState();

    String oldToken = getIt<AuthCubit>().tempToken;
    context.read<AuthCubit>().emitExchangeToken(oldToken);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: BlocListener<AuthCubit, ResultState<dynamic>>(
        listener: (context, state) {
          state.whenOrNull(
            success: (data) async {
              await getIt<StudentCubit>().loadStudentData();
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.kStudentMainScreen,
                (route) => false,
              );
            },
            failure: (error) {
              getIt<VoiceServices>().speak(
                NetworkExceptions.getErrorMessage(error),
              );
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.kSUserTypeScreen,
                (route) => false,
              );
            },
          );
        },
        child: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
