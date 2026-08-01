import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/presentation/widgets/student/small_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String helpMessage;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.helpMessage,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leadingWidth: 100.w,
      toolbarHeight: 100,
      backgroundColor: Theme.of(context).colorScheme.background,
      leading: showBackButton
          ? Center(
              child: Row(
                children: [
                  SizedBox(width: 20.w),
                  SmallButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          : null,
      actions: [
        SmallButton(
          icon: const Icon(Icons.question_mark_outlined),
          onPressed: () {
            getIt<VoiceServices>().speak(helpMessage);
          },
        ),
        SizedBox(width: 20.w),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
