import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/lesson_card.dart';

class StudentLessonRecordsScreen extends StatelessWidget {
  final String lessonName;
  const StudentLessonRecordsScreen({super.key, required this.lessonName});

  @override
  Widget build(BuildContext context) {
    List records = ['القسم الاول', 'القسم الثاني', 'القسم الثالث'];
    return Scaffold(
      appBar: CustomAppBar(helpMessage: ''),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 30.w),

            child: Text(
              '$lessonName:',
              style: AppTextStyles.kMediumPrimary(context),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),

            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: records.length,
              itemBuilder: (context, index) => LessonCard(
                lessonName: records[index],
                lessonNumber: (index + 1),
                viewMenu: false,
                route: AppRoutes.kStudentAudioPlayerScreen,
                args: [lessonName, (index + 1)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
