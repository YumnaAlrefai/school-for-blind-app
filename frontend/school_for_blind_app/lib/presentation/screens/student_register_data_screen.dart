import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/level_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/app_validator.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_text_form_field.dart';
import 'package:school_for_blind_app/presentation/widgets/options_card.dart';
import 'package:school_for_blind_app/presentation/widgets/small_button.dart';

class StudentRegisterDataScreen extends StatefulWidget {
  const StudentRegisterDataScreen({super.key});

  @override
  State<StudentRegisterDataScreen> createState() =>
      _StudentRegisterDataScreenState();
}

class _StudentRegisterDataScreenState extends State<StudentRegisterDataScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _parentPhoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _parentPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 100.w,
          toolbarHeight: 100,
          backgroundColor: Theme.of(context).colorScheme.background,
          leading: Center(
            child: Row(
              children: [
                SizedBox(width: 20.w),
                SmallButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      AppRoutes.kSUserTypeScreen,
                      (route) => false,
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentAccountsScreen,
                    );
                    Navigator.pushNamed(
                      context,
                      AppRoutes.kStudentRegisterNumberScreen,
                    );
                  },
                ),
              ],
            ),
          ),
          actions: [
            SmallButton(
              icon: const Icon(Icons.question_mark_outlined),
              onPressed: () {
                getIt<VoiceServices>().speak(
                  'هذه صفحةُ إدخال معلوماتِ حسابِكَ الشخصية، املأْ جميع الحقول للمتابعةْ',
                );
              },
            ),
            SizedBox(width: 20.w),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Form(
          key: _formKey,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 10.h),
                    CustomTextfield(
                      controller: _fullNameController,
                      hintText: 'الاسم الكامل',
                      icon: Icons.person,
                      inputFormatters: [],
                    ),
                    SizedBox(height: 30.h),
                    CustomTextfield(
                      controller: _fatherNameController,
                      hintText: 'اسم الأب',
                      icon: Icons.person,
                      inputFormatters: [],
                    ),
                    SizedBox(height: 30.h),
                    CustomTextfield(
                      controller: _parentPhoneController,
                      hintText: 'رقم أهل الطالب',
                      icon: Icons.family_restroom,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.only(right: 35),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'المرحلة الدراسية:',
                            style: AppTextStyles.kMediumPrimary(context),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    BlocBuilder<LevelCubit, StudentLevel>(
                      builder: (context, selectedLevel) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            OptionsCard(
                              title: 'تاسع',
                              width: 157,
                              height: 97,
                              isSelected: selectedLevel == StudentLevel.ninth,
                              onTap: () => context
                                  .read<LevelCubit>()
                                  .selectLevel(StudentLevel.ninth),
                            ),
                            SizedBox(width: 20.w),
                            OptionsCard(
                              title: 'بكالوريا',
                              width: 157,
                              height: 97,
                              isSelected: selectedLevel == StudentLevel.twelfth,
                              onTap: () => context
                                  .read<LevelCubit>()
                                  .selectLevel(StudentLevel.twelfth),
                            ),
                          ],
                        );
                      },
                    ),
                    SizedBox(height: 30.h),
                    BlocBuilder<AuthCubit, ResultState<dynamic>>(
                      builder: (context, state) {
                        if (state is Loading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        }
                        return PrimaryButton(
                          title: 'التالي',
                          width: 332,
                          height: 97,
                          fontSize: 48,
                          onPressed: () {
                            if (_fullNameController.text.isEmpty ||
                                _parentPhoneController.text.isEmpty ||
                                _fatherNameController.text.isEmpty) {
                              getIt<VoiceServices>().speak(
                                'يرجى تعبئة جميع الحقول',
                              );
                            } else if (AppValidator.phoneValidation(
                                  _parentPhoneController.text,
                                ) !=
                                null) {
                              getIt<VoiceServices>().speak(
                                AppValidator.phoneValidation(
                                  _parentPhoneController.text,
                                )!,
                              );
                            } else if (context.read<LevelCubit>().state ==
                                StudentLevel.none) {
                              getIt<VoiceServices>().speak(
                                'اختر المرحلة الدراسية',
                              );
                            } else if (_formKey.currentState!.validate()) {
                              context.read<AuthCubit>().saveRegistrationData(
                                fullName: _fullNameController.text,
                                fatherName: _fatherNameController.text,
                                parentPhone: _parentPhoneController.text,
                                level: context.read<LevelCubit>().state.name,
                              );
                              Navigator.pushNamed(
                                context,
                                AppRoutes.kStudentRegisterPhotoScreen,
                              );
                            } else {
                              getIt<VoiceServices>().speak(
                                'يرجى التأكد من صحة البيانات المدخلة',
                              );
                            }
                          },
                        );
                      },
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
