import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/presentation/widgets/quiz_question_card.dart';
import 'package:school_for_blind_app/presentation/widgets/small_button.dart';

class StudentQuizScreen extends StatelessWidget {
  const StudentQuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  //////////////اضافة تحذير
                  Navigator.pop(context);
                },
              ),
            ],
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
      backgroundColor: Theme.of(context).colorScheme.background,
      // body: ListView.builder(
      //   itemCount: 10,
      //   itemBuilder: (context, index) {
      //     if (index == 0) {
      //       return Stack(
      //         children: [
      //           QuizQuestionCard(),
      //           Align(
      //             alignment: AlignmentGeometry.topCenter,
      //             child: CircleAvatar(radius: 40, child: Text('3:00:00')),
      //           ),
      //         ],
      //       );
      //     } else {
      //       return QuizQuestionCard();
      //     }
      //   },
      // ),
      body: QuizQuestionCard(),
    );
  }
}
