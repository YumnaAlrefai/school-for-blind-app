import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/presentation/widgets/small_button.dart';

class StudentAnnouncementsScreen extends StatelessWidget {
  const StudentAnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        leadingWidth: 100.w,
        toolbarHeight: 100,
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Text(
          ' الإعلانات',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 48,
          ),
        ),
        actions: [
          SmallButton(
            icon: const Icon(Icons.question_mark_outlined),
            onPressed: () {
              getIt<VoiceServices>().speak('');
            },
          ),
          SizedBox(width: 20.w),
        ],
      ),
    );
  }
}
