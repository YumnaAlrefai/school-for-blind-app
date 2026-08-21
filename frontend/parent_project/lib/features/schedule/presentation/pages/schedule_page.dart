import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/Widget/theme_listener.dart';

import 'package:parent_project/features/schedule/data/datasource/schedule_remote_datasource.dart';
import 'package:parent_project/features/schedule/data/repositories/schedule_repository.dart';
import 'package:parent_project/features/schedule/data/models/schedule_period_model.dart';
import 'package:parent_project/features/schedule/logic/cubit/schedule_cubit.dart';
import 'package:parent_project/features/schedule/logic/cubit/schedule_state.dart';

class _WeekDay {
  final String key;
  final String label;
  const _WeekDay(this.key, this.label);
}

const List<_WeekDay> _weekDays = [
  _WeekDay('1', 'الأحد'),
  _WeekDay('2', 'الاثنين'),
  _WeekDay('3', 'الثلاثاء'),
  _WeekDay('4', 'الأربعاء'),
  _WeekDay('5', 'الخميس'),
 // _WeekDay('6', 'الجمعة'),
  //_WeekDay('7', 'السبت'),
];

class SchedulePage1 extends StatelessWidget {
  const SchedulePage1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleCubit(
        ScheduleRepository(ScheduleRemoteDataSource()),
      )..startPolling(),
      child: const _Schedule1View(),
    );
  }
}

class _Schedule1View extends StatelessWidget {
  const _Schedule1View();

  @override
  Widget build(BuildContext context) {
    return
    ThemeListener(
  builder: (context) =>
     Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(context),
              Expanded(
                child: BlocBuilder<ScheduleCubit, ScheduleState>(
                  builder: (context, state) {
                    if (state is ScheduleLoading || state is ScheduleInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ScheduleFailure) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.overlay70, fontSize: 26),
                            ),
                            const SizedBox(height: 15),
                            ElevatedButton(
                              onPressed: () =>
                                  context.read<ScheduleCubit>().fetchSchedule(),
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      );
                    }

                    final response = (state as ScheduleSuccess).response;

                    if (response.data.isEmpty) {
                      return Center(
                        child: Text(
                          'لا يوجد برنامج دوام متاح حاليًا',
                          style: TextStyle(color: AppColors.overlay70, fontSize: 28),
                        ),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final student in response.data) ...[
                            _buildStudentSchedule(
                              studentName: student.studentName,
                              scheduleByDay: student.schedule,
                            ),
                            const SizedBox(height: 30),
                          ],
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.subdirectory_arrow_left_outlined, color: AppColors.textPrimary, size: 34),
        ),
      ),
    );
  }

  Widget _buildStudentSchedule({
    required String studentName,
    required Map<String, List<SchedulePeriodModel>> scheduleByDay,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'برنامج الدوام للطالب $studentName:',
          textAlign: TextAlign.right,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 32),
        ),
        const SizedBox(height: 14),
        _buildScheduleTable(scheduleByDay),
      ],
    );
  }

  Widget _buildScheduleTable(Map<String, List<SchedulePeriodModel>> scheduleByDay) {
    final Set<int> periodNumbers = {};
    for (final periods in scheduleByDay.values) {
      for (final p in periods) {
        periodNumbers.add(p.periodNumber);
      }
    }
    final sortedPeriodNumbers = periodNumbers.toList()..sort();

    if (sortedPeriodNumbers.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Text(
          'لا يوجد حصص مسجلة',
          style: TextStyle(color: AppColors.overlay54, fontSize: 24),
        ),
      );
    }

    return ClipRRect(
      child: Table(
        border: TableBorder.all(color: AppColors.bgDark, width: 1),
        columnWidths: const {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1.3),
          2: FlexColumnWidth(1.3),
          3: FlexColumnWidth(1.3),
          4: FlexColumnWidth(1.3),
          5: FlexColumnWidth(1.3),
         // 6: FlexColumnWidth(1.3),
         // 7: FlexColumnWidth(1.3),
        },
        children: [
          _buildHeaderRow(),
          for (final periodNumber in sortedPeriodNumbers)
            _buildDataRow(periodNumber, scheduleByDay),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    final headers = ['الوقت', ..._weekDays.map((d) => d.label)];
    return TableRow(
      decoration: BoxDecoration(color: AppColors.accentGreen),
      children: headers
          .map((text) => _buildCell(text, textColor: AppColors.bgDark))
          .toList(),
    );
  }

  TableRow _buildDataRow(
    int periodNumber,
    Map<String, List<SchedulePeriodModel>> scheduleByDay,
  ) {
    String timeLabel = '';
    for (final periods in scheduleByDay.values) {
      final match = periods.where((p) => p.periodNumber == periodNumber);
      if (match.isNotEmpty) {
        final p = match.first;
        timeLabel = _formatTime(p.startTime);
        break;
      }
    }

    return TableRow(
      decoration: BoxDecoration(color: AppColors.cardDark),
      children: [
        _buildCell(timeLabel, textColor: AppColors.textPrimary),
        for (final day in _weekDays)
          _buildCell(
            _subjectNameForDayAndPeriod(scheduleByDay, day.key, periodNumber),
            textColor: AppColors.textPrimary,
          ),
      ],
    );
  }

  String _subjectNameForDayAndPeriod(
    Map<String, List<SchedulePeriodModel>> scheduleByDay,
    String dayKey,
    int periodNumber,
  ) {
    final periods = scheduleByDay[dayKey] ?? [];
    final match = periods.where((p) => p.periodNumber == periodNumber);
    if (match.isEmpty) return '';
    return match.first.subject.name;
  }

  String _formatTime(String rawTime) {
    if (rawTime.isEmpty) return '';
    final parts = rawTime.split(':');
    if (parts.length < 2) return rawTime;
    final hour = int.tryParse(parts[0]) ?? 0;
    return '$hour:${parts[1]}';
  }

  Widget _buildCell(
    String text, {
    required Color textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 3),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontSize: 20, fontWeight: fontWeight),
      ),
    );
  }
}