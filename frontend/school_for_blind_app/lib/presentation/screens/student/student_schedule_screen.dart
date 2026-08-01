import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/schedule_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/voice_services.dart';
import 'package:school_for_blind_app/core/theme/app_text_styles.dart';
import 'package:school_for_blind_app/data/models/student/schedule_model.dart';
import 'package:school_for_blind_app/networking/network_exceptions.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';

class StudentScheduleScreen extends StatelessWidget {
  const StudentScheduleScreen({Key? key}) : super(key: key);

  final Map<String, String> daysMap = const {
    "1": "الأحد",
    "2": "الإثنين",
    "3": "الثلاثاء",
    "4": "الأربعاء",
    "5": "الخميس",
    "6": "الجمعة",
    "7": "السبت",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: CustomAppBar(helpMessage: ''),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 27.w),
              child: Text(
                'برنامج الدوام:',
                style: AppTextStyles.kMediumPrimary(context),
              ),
            ),
            Expanded(
              child: BlocBuilder<ScheduleCubit, ResultState<ScheduleResponse>>(
                builder: (context, state) {
                  return state.when(
                    idle: () => const SizedBox.shrink(),
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    success: (scheduleData) =>
                        _buildScheduleGrid(scheduleData.data, context),
                    failure: (networkException) {
                      getIt<VoiceServices>().speak(
                        NetworkExceptions.getErrorMessage(networkException),
                      );
                      return RefreshIndicator(
                        onRefresh: () async {
                          context.read<ScheduleCubit>().emitGetSchedule();
                        },
                        child: ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: const [SizedBox(height: 200)],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleGrid(
    Map<String, List<ScheduleItem>> scheduleMap,
    BuildContext context,
  ) {
    List<String> availableDaysKeys = scheduleMap.keys.toList();
    int maxPeriods = 0;
    scheduleMap.forEach((key, items) {
      for (var item in items) {
        if (item.periodNumber > maxPeriods) {
          maxPeriods = item.periodNumber;
        }
      }
    });
    if (maxPeriods == 0) maxPeriods = 7;

    return RefreshIndicator(
      color: Theme.of(context).colorScheme.background,
      backgroundColor: Theme.of(context).colorScheme.primary,
      onRefresh: () async {
        context.read<ScheduleCubit>().emitGetSchedule();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.all(15.w),
            child: Table(
              defaultColumnWidth: FixedColumnWidth(160.w),
              border: TableBorder.all(
                color: Theme.of(context).colorScheme.onSurface,
                width: 1,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  children: [
                    _buildHeaderCell('الوقت', context),
                    ...availableDaysKeys.map((dayKey) {
                      return _buildHeaderCell(
                        daysMap[dayKey] ?? 'يوم $dayKey',
                        context,
                      );
                    }).toList(),
                  ],
                ),
                for (int period = 1; period <= maxPeriods; period++)
                  TableRow(
                    children: [
                      _buildTimeCell(scheduleMap, period, context),
                      ...availableDaysKeys.map((dayKey) {
                        final items = scheduleMap[dayKey] ?? [];
                        final match = items.firstWhere(
                          (element) => element.periodNumber == period,
                          orElse: () => ScheduleItem(
                            id: -1,
                            dayOfWeek: '',
                            periodNumber: 0,
                            startTime: '',
                            endTime: '',
                            subject: null,
                          ),
                        );

                        return _buildContentCell(
                          (match.id != -1 && match.subject != null)
                              ? match.subject!.name
                              : '-',
                          context,
                        );
                      }).toList(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String title, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 6.w),
      alignment: Alignment.center,
      child: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 36,
        ),
      ),
    );
  }

  Widget _buildTimeCell(
    Map<String, List<ScheduleItem>> scheduleMap,
    int period,
    BuildContext context,
  ) {
    String timeText = '';
    for (var list in scheduleMap.values) {
      for (var item in list) {
        if (item.periodNumber == period) {
          timeText = item.startTime.length >= 5
              ? item.startTime.substring(0, 5)
              : item.startTime;
          break;
        }
      }
      if (timeText.isNotEmpty) break;
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 6.w),
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.background,
      child: Text(
        timeText.isEmpty ? '-' : timeText,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 36,
        ),
      ),
    );
  }

  Widget _buildContentCell(String subjectName, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 6.w),
      alignment: Alignment.center,
      color: Theme.of(context).colorScheme.background,
      child: Text(
        subjectName,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 36,
        ),
      ),
    );
  }
}
