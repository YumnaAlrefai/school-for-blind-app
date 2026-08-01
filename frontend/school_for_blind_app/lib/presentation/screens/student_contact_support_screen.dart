import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_for_blind_app/business_logic/cubit/support_ticket_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/support_ticket_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_buttons.dart';
import 'package:school_for_blind_app/presentation/widgets/input_section.dart';
import 'package:school_for_blind_app/presentation/widgets/options_card.dart';

class StudentContactSupportScreen extends StatefulWidget {
  const StudentContactSupportScreen({super.key});

  @override
  State<StudentContactSupportScreen> createState() =>
      _StudentContactSupportScreenState();
}

class _StudentContactSupportScreenState
    extends State<StudentContactSupportScreen> {
  TextEditingController controller = TextEditingController();
  XFile? _problemImg;
  String? _finalAudioPath;

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _problemImg = image;
        getIt<VoiceServices>().speak('تم إرفاق الصورة بنجاح');
      });
    }
  }

  void _submit(BuildContext context) {
    final hasText = controller.text.trim().isNotEmpty;
    final hasAudio = _finalAudioPath != null;

    if (!hasText && !hasAudio) {
      getIt<VoiceServices>().speak('يرجى كتابة أو تسجيل وصف للمشكلة أولاً');
      return;
    }

    context.read<SupportTicketCubit>().sendSupportTicket(
      message: hasText ? controller.text.trim() : null,
      audio: hasAudio ? File(_finalAudioPath!) : null,
      image: _problemImg != null ? File(_problemImg!.path) : null,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SupportTicketCubit>(),
      child: BlocConsumer<SupportTicketCubit, SupportTicketState>(
        listener: (context, state) {
          state.whenOrNull(
            success: (message) {
              getIt<VoiceServices>().speak(message);
              Navigator.pop(context);
            },
            failure: (error) {
              getIt<VoiceServices>().speak(
                NetworkExceptions.getErrorMessage(error),
              );
            },
          );
        },
        builder: (context, state) {
          final isLoading = state.maybeWhen(
            loading: () => true,
            orElse: () => false,
          );

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBar(helpMessage: ''),
            backgroundColor: Theme.of(context).colorScheme.background,
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    'صِف المشكلة:',
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: InputSection(
                    controller: controller,
                    audioFilePrefix: 'student_contact_support_voice',
                    hintText: 'أواجه مشكلة في..',
                    onAudioChanged: (path) {
                      _finalAudioPath = path;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: Text(
                    'لقطة شاشة للمشكلة (اختياري):',
                    style: AppTextStyles.kMediumPrimary(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _problemImg == null
                          ? OptionsCard(
                              icon: Icons.add_photo_alternate_outlined,
                              iconSize: 45,
                              height: 200,
                              width: 200,
                              isSelected: false,
                              onTap: () async {
                                _pickImageFromGallery();
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
                                      File(_problemImg!.path),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: IconButton(
                                      iconSize: 20,
                                      style: IconButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xffff3333,
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _problemImg = null;
                                          getIt<VoiceServices>().speak(
                                            'تم حذف الصورة',
                                          );
                                        });
                                      },
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ],
                  ),
                ),
                SizedBox(height: 5.h),
                Center(
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : PrimaryButton(
                          title: 'إرسال',
                          width: 332,
                          height: 97,
                          onPressed: () => _submit(context),
                          fontSize: 48,
                        ),
                ),
                const SizedBox(height: 0),
              ],
            ),
          );
        },
      ),
    );
  }
}
