import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/presentation/widgets/glass_effect.dart';
import 'package:school_for_blind_app/presentation/widgets/quiz_show_dialog.dart';

class LessonCard extends StatelessWidget {
  final String lessonName;
  final int lessonNumber;
  final bool viewMenu;
  final String route;
  final dynamic args;

  const LessonCard({
    super.key,
    required this.lessonName,
    required this.lessonNumber,
    required this.viewMenu,
    required this.route,
    this.args,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 18.w),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, route, arguments: args);
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 354.w,
              height: 97.h,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                ),
                border: Border.all(
                  color: Theme.of(context).colorScheme.onBackground,
                  width: 0.2.w,
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(right: 40.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lessonName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.kMediumPrimary(context),
                      ),
                    ),
                    viewMenu
                        ? PopupMenuButton<String>(
                            icon: Icon(
                              Icons.more_vert,
                              size: 34.sp,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onSelected: (String value) async {
                              if (value == 'كويز') {
                                QuizShowDialog.buildQuizShowDialog(context);
                              } else if (value == 'حفظ') {
                                // اضافة للمحفوظات
                              } else if (value == 'تنزيل') {
                                // تنزيل
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                _buildPopupMenu(context),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -25,
              right: -15,
              child: Container(
                height: 55.h,
                width: 55.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.symmetric(
                    horizontal: BorderSide(
                      color: Theme.of(context).colorScheme.onBackground,
                      width: 0.5.w,
                    ),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Center(
                  child: Text(
                    '$lessonNumber',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 48.sp,
                    ),
                  ),
                ),
              ),
            ),
            GlassEffect(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(16)),
            ),
          ],
        ),
      ),
    );
  }

  Divider _buildCustomDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onBackground,
      height: 0,
      thickness: 0.2.w,
    );
  }

  List<PopupMenuEntry<String>> _buildPopupMenu(BuildContext context) {
    return <PopupMenuEntry<String>>[
      PopupMenuItem<String>(
        value: 'كويز',
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.quiz,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 15.w),
                Text('كويز', style: TextStyle(fontSize: 36)),
              ],
            ),
            _buildCustomDivider(context),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'حفظ',
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.bookmark_add_sharp,
                  size: 30,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(width: 10.w),
                Text('حفظ', style: TextStyle(fontSize: 36)),
              ],
            ),
            _buildCustomDivider(context),
          ],
        ),
      ),
      PopupMenuItem<String>(
        value: 'تنزيل',
        child: Row(
          children: [
            Icon(
              Icons.download,
              size: 30,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 10.w),
            Text('تنزيل', style: TextStyle(fontSize: 36)),
          ],
        ),
      ),
    ];
  }
}
