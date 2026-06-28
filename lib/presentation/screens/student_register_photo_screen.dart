import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_for_blind_app/business_logic/cubit/auth_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/options_card.dart';

class StudentRegisterPhotoScreen extends StatefulWidget {
  const StudentRegisterPhotoScreen({super.key});

  @override
  State<StudentRegisterPhotoScreen> createState() =>
      _StudentRegisterPhotoScreenState();
}

class _StudentRegisterPhotoScreenState
    extends State<StudentRegisterPhotoScreen> {
  XFile? _documentImage;
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _documentImage = image;
        getIt<VoiceServices>().speak('تم إرفاق الصورة بنجاح');
      });
    }
  }

  Future<void> _showImageSourceSheet(BuildContext context) async {
    showModalBottomSheet(
      backgroundColor: AppColors.kSurfaceColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: AppColors.kPrimaryColor,
                  ),
                  title: Text('الكاميرا', style: AppTextStyles.kMediumPrimary),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                Divider(color: AppColors.kTextPrimary),
                ListTile(
                  leading: Icon(Icons.image, color: AppColors.kPrimaryColor),
                  title: Text('المعرض', style: AppTextStyles.kMediumPrimary),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kBackgroundColor,
      appBar: AppBar(backgroundColor: AppColors.kBackgroundColor),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Text(
              'الرجاء إرفاق صورة الأوراق الثبوتية (كفيف/ضعيف بصر):',
              overflow: TextOverflow.clip,
              maxLines: 2,
              style: AppTextStyles.kMediumPrimary,
            ),
          ),
          SizedBox(height: 20.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _documentImage == null
                    ? OptionsCard(
                        title: 'إضافة صورة',
                        icon: Icons.file_upload_outlined,
                        width: 239,
                        isSelected: false,
                        onTap: () async {
                          await _showImageSourceSheet(context);
                        },
                      )
                    : SizedBox(
                        height: 120,
                        width: 200,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(_documentImage!.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: IconButton(
                                iconSize: 20,
                                style: IconButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _documentImage = null;
                                    getIt<VoiceServices>().speak(
                                      'تم حذف الصورة',
                                    );
                                  });
                                },
                                icon: Icon(Icons.close, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
              ],
            ),
          ),
          SizedBox(height: 30.h),
          BlocConsumer<AuthCubit, ResultState<dynamic>>(
            listener: (context, state) {
              state.whenOrNull(
                success: (data) {
                  getIt<VoiceServices>().speak(data.toString());
                  Navigator.pushNamed(context, AppRoutes.kSUserTypeScreen);
                },
                failure: (networkException) {
                  getIt<VoiceServices>().speak(
                    NetworkExceptions.getErrorMessage(networkException),
                  );
                },
              );
            },
            builder: (context, state) {
              if (state is Loading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.kPrimaryColor,
                  ),
                );
              }
              return PrimaryButton(
                title: 'التالي',
                onPressed: () {
                  if (_documentImage == null) {
                    getIt<VoiceServices>().speak('أرفق صورة ثبوتية');
                  } else {
                    context.read<AuthCubit>().emitRegister(
                      File(_documentImage!.path),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
