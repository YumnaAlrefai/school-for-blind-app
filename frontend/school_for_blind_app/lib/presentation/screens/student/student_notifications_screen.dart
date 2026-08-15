import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/notifications_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/notifications_response_model.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/notification_card.dart';
import 'package:school_for_blind_app/presentation/widgets/student/small_button.dart';

class StudentNotificationsScreen extends StatelessWidget {
  const StudentNotificationsScreen({Key? key}) : super(key: key);

  Map<String, List<NotificationItem>> _groupNotificationsByDate(
    List<NotificationItem> list,
  ) {
    Map<String, List<NotificationItem>> grouped = {};
    for (var item in list) {
      DateTime parsedDate = DateTime.parse(item.timestamp);
      String dateKey =
          "${parsedDate.day}/${parsedDate.month}/${parsedDate.year}";
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
              getIt<VoiceServices>().speak(
                'أنتَ الآنَ في صَفْحَةِ الإِشْعارَاتِ. تُعْرَضُ هُنا أحدثُ التَّنْبِيهاتِ والمُسْتَجِدّاتِ الخاصَّةِ بكَ بترتيبٍ زَمَنِيٍّ. يُمكنُكَ الضَّغْطُ على الزر في أعلى الشاشة لكتم الإشعارات أو إلغاء كتمها',
              );
            },
          ),
          SizedBox(width: 20.w),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          child: RefreshIndicator(
            backgroundColor: Theme.of(context).colorScheme.surface,
            color: Theme.of(context).colorScheme.primary,
            onRefresh: () async {
              context.read<NotificationsCubit>().emitGetNotifications();
            },
            child:
                BlocBuilder<
                  NotificationsCubit,
                  ResultState<NotificationsResponse>
                >(
                  builder: (context, state) {
                    return state.when(
                      idle: () => const SizedBox.shrink(),
                      loading: () => Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      success: (NotificationsResponse response) {
                        final notifications = response.data.notifications;
                        if (notifications.isEmpty) {
                          return ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 200.h),
                              Center(
                                child: Text(
                                  "لا توجد إشعارات",
                                  style: AppTextStyles.kMediumPrimary(context),
                                ),
                              ),
                            ],
                          );
                        }
                        final groupedData = _groupNotificationsByDate(
                          notifications,
                        );
                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: groupedData.keys.length,
                          itemBuilder: (context, index) {
                            String dateKey = groupedData.keys.elementAt(index);
                            List<NotificationItem> items =
                                groupedData[dateKey]!;

                            return Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 8.h),
                                  child: Text(
                                    dateKey,
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface,
                                      fontSize: 36.sp,
                                    ),
                                  ),
                                ),
                                ...items
                                    .map((item) => NotificationCard(item: item))
                                    .toList(),
                              ],
                            );
                          },
                        );
                      },
                      failure: (error) {
                        getIt<VoiceServices>().speak(
                          NetworkExceptions.getErrorMessage(error),
                        );
                        return ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(height: 200.h),
                            Center(child: Container()),
                          ],
                        );
                      },
                    );
                  },
                ),
          ),
        ),
      ),
    );
  }
}
