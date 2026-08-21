import 'package:flutter/material.dart';
import 'package:parent_project/Widget/app_colors.dart';



class ScheduleCell {
  final String? subject;
  

  const ScheduleCell({this.subject, });

  bool get isEmpty => subject == null;

  @override
  String toString() => subject == null ? '' : '$subject';
}


class ScheduleRow {
  final String time;
  final ScheduleCell sunday;
  final ScheduleCell monday;
  final ScheduleCell tuesday;
  final ScheduleCell wednesday;
  final ScheduleCell thursday;

  const ScheduleRow({
    required this.time,
    this.sunday = const ScheduleCell(),
    this.monday = const ScheduleCell(),
    this.tuesday = const ScheduleCell(),
    this.wednesday = const ScheduleCell(),
    this.thursday = const ScheduleCell(),
  });
}

class SchedulePage extends StatelessWidget {
  const SchedulePage({super.key});

 
  static final List<ScheduleRow> _raghadSchedule = [
    const ScheduleRow(
      time: '8:00',
      sunday: ScheduleCell(subject: 'تاريخ' ),
      monday: ScheduleCell(subject: 'تاريخ',),
      tuesday: ScheduleCell(subject: 'تاريخ' ),
      wednesday: ScheduleCell(subject: 'تاريخ' ),
    ),
    const ScheduleRow(
      time: '9:00',
      wednesday: ScheduleCell(subject: 'جغرافيا',),
    ),
    const ScheduleRow(
      time: '10:00',
      monday: ScheduleCell(subject: 'تاريخ', ),
      wednesday: ScheduleCell(subject: 'تاريخ', ),
    ),
    const ScheduleRow(
      time: '11:00',
      sunday: ScheduleCell(subject: 'تاريخ',),
      tuesday: ScheduleCell(subject: 'جغرافيا', ),
    ),
    const ScheduleRow(
      time: '12:00',
      wednesday: ScheduleCell(subject: 'جغرافيا', ),
    ),
    const ScheduleRow(
      time: '1:00',
      tuesday: ScheduleCell(subject: 'جغرافيا', ),
      wednesday: ScheduleCell(subject: 'تاريخ', ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTopBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildStudentSchedule(
                        studentName: 'رغد',
                        schedule: _raghadSchedule,
                      ),
                      const SizedBox(height: 30),
                      _buildStudentSchedule(
                        studentName: 'محمد',
                        schedule: _raghadSchedule, 
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.subdirectory_arrow_left_outlined, color: Colors.white, size: 34),
        ),
      ),
    );
  }

  Widget _buildStudentSchedule({
    required String studentName,
    required List<ScheduleRow> schedule,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'برنامج الدوام للطالب/ة $studentName:',
          textAlign: TextAlign.right,
          style: const TextStyle(color: Colors.white, fontSize: 32),
        ),
        const SizedBox(height: 14),
        _buildScheduleTable(schedule),
      ],
    );
  }

  Widget _buildScheduleTable(List<ScheduleRow> schedule) {
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
        },
        children: [
          _buildHeaderRow(),
          for (final row in schedule) _buildDataRow(row),
        ],
      ),
    );
  }
  TableRow _buildHeaderRow() {
    const headers = ['الوقت', 'الأحد', 'الإثنين', 'الثلاثاء', 'الأربعاء','الخميس'];
    return TableRow(
      decoration: BoxDecoration(color: AppColors.accentGreen),
      children: headers
          .map((text) => _buildCell(
                text,
                textColor: AppColors.bgDark,
              
              ))
          .toList(),
    );
  }

  TableRow _buildDataRow(ScheduleRow row) {
    return TableRow(
      decoration: const BoxDecoration(color: Colors.white),
      children: [
        _buildCell(row.time, textColor: AppColors.bgDark),
        _buildCell(row.sunday.toString(), textColor: AppColors.bgDark),
        _buildCell(row.monday.toString(), textColor: AppColors.bgDark),
        _buildCell(row.tuesday.toString(), textColor: AppColors.bgDark),
        _buildCell(row.wednesday.toString(), textColor: AppColors.bgDark),
        _buildCell(row.thursday.toString(), textColor: AppColors.bgDark),
      ],
    );
  }

  Widget _buildCell(
    String text, {
    required Color textColor,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontSize: 24, fontWeight: fontWeight),
      ),
    );
  }
}