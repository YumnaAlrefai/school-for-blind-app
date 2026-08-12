import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:parent_project/features/reports/data/datasource/reports_remote_datasource.dart';
import 'package:parent_project/features/reports/data/repositories/reports_repository.dart';
import 'package:parent_project/features/reports/data/models/attendance_model.dart';
import 'package:parent_project/features/reports/data/models/punishment_model.dart';
import 'package:parent_project/features/reports/data/models/grade_model.dart';
import 'package:parent_project/features/reports/logic/cubit/reports_cubit.dart';
import 'package:parent_project/features/reports/logic/cubit/reports_state.dart';
import 'package:parent_project/features/reports/logic/cubit/excuse_cubit.dart';
import 'package:parent_project/Widget/app_colors.dart';


class DailyTab1 extends StatelessWidget {
  const DailyTab1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportsCubit(
        ReportsRepository(ReportsRemoteDataSource()),
      )..fetchDailyReports(),
      child: const _DailyTab1View(),
    );
  }
}

class _DailyTab1View extends StatelessWidget {
  const _DailyTab1View();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReportsCubit, ReportsState>(
      builder: (context, state) {
        if (state is ReportsLoading || state is ReportsInitial) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ReportsFailure) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                Text(
                  state.message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 30),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () =>
                      context.read<ReportsCubit>().fetchDailyReports(),
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          );
        }

        final response = (state as DailyReportsSuccess).response;

        if (response.data.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: Text(
                'لا يوجد تقرير لهذا اليوم',
                style: TextStyle(color: Colors.white70, fontSize: 30),
              ),
            ),
          );
        }

        // ------- نبني قسم كامل لكل طالب موجود بالاستجابة -------
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final student in response.data) ...[
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  student.greetingMessage,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                ),
              ),
              const SizedBox(height: 8),

              // ------- تاريخ اليوم -------
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'تقرير يوم: ${student.reportData.date}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // ------- الحضور -------
              for (final att in student.reportData.attendance) ...[
                att.isAttended
                    ? _AttendedCard(
                        roomName: att.roomName,
                        totalRoomMinutes: '${att.totalRoomMinutes} دقيقة',
                        studentPresenceMinutes:
                            '${att.studentPresenceMinutes} دقيقة',
                        studentName: student.studentName,
                      )
                    : _AbsentCard(
                        studentId: student.studentId,
                        roomId: att.roomId,
                        roomName: att.roomName,
                        canExcuse: att.canExcuse,
                        excuseStatus: att.excuseStatus,
                        totalRoomMinutes: '${att.totalRoomMinutes} دقيقة',
                        studentPresenceMinutes:
                            '${att.studentPresenceMinutes} دقيقة',
                      ),
                const SizedBox(height: 20),
              ],

              // ------- العلامات اليومية -------
              for (final grade in student.reportData.gradesToday) ...[
                _AchievementCard(
                  studentName: student.studentName,
                  score: grade.score,
                  title: grade.title,
                  subjectName: grade.subjectName,
                  type: grade.type,
                ),
                const SizedBox(height: 20),
              ],

              // ------- الإنذارات -------
              for (final punishment in student.reportData.punishments) ...[
                _WarningCard(
                  title: punishment.name,
                  description: punishment.description,
                ),
                const SizedBox(height: 20),
              ],

              const SizedBox(height: 10),
            ],
          ],
        );
      },
    );
  }
}

// ------------------------------------------------------------
// بطاقة حصة تم حضورها
// ------------------------------------------------------------
class _AttendedCard extends StatelessWidget {
  final String roomName;
  final String totalRoomMinutes;
  final String studentPresenceMinutes;
  final String studentName;

  const _AttendedCard({
    required this.roomName,
    required this.totalRoomMinutes,
    required this.studentPresenceMinutes,
    required this.studentName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(roomName, style: const TextStyle(color: Colors.white, fontSize: 40)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text('تم الحضور', style: TextStyle(color: AppColors.accentGreen, fontSize: 32)),
              const SizedBox(width: 5),
              const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 22),
            ],
          ),
          const SizedBox(height: 5),
          Text('المدة الكلية للحصة: $totalRoomMinutes', style: const TextStyle(color: Colors.white70, fontSize: 32)),
          const SizedBox(height: 6),
          Text('مدة حضور الطالبة $studentName: $studentPresenceMinutes', style: const TextStyle(color: Colors.white70, fontSize: 32)),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// بطاقة حصة لم يتم حضورها + زري "يوجد / لا يوجد مبرر"
// عند الضغط يظهر Popup لتأكيد الاختيار قبل الإرسال للسيرفر
// ------------------------------------------------------------
class _AbsentCard extends StatefulWidget {
  final int studentId;
  final int roomId;
  final String roomName;
  final bool canExcuse;
  final String? excuseStatus;
  final String totalRoomMinutes;
  final String studentPresenceMinutes;

  const _AbsentCard({
    required this.studentId,
    required this.roomId,
    required this.roomName,
    required this.canExcuse,
    required this.excuseStatus,
    required this.totalRoomMinutes,
    required this.studentPresenceMinutes,
  });

  @override
  State<_AbsentCard> createState() => _AbsentCardState();
}

class _AbsentCardState extends State<_AbsentCard> {
  bool? _hasJustification;
  bool _alreadySubmitted = false;

  Future<void> _openConfirmDialog({required bool hasJustification}) async {
    final reasonController = TextEditingController(
      text: hasJustification ? '' : 'لا يوجد مبرر للغياب',
    );

    final excuseCubit = ExcuseCubit(
      ReportsRepository(ReportsRemoteDataSource()),
    );

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: excuseCubit,
          child: BlocConsumer<ExcuseCubit, ExcuseState>(
            listener: (context, state) {
              if (state is ExcuseSuccess) {
                Navigator.of(dialogContext).pop();
                setState(() {
                  _hasJustification = hasJustification;
                  _alreadySubmitted = true;
                });
                ScaffoldMessenger.of(this.context).showSnackBar(
                  SnackBar(content: Text(state.response.message)),
                );
              }

              if (state is ExcuseFailure) {
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: AlertDialog(
                  backgroundColor: AppColors.cardDark,
                  contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: reasonController,
                        maxLines: 1,
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          hintText: 'اكتب السبب هنا...',
                          hintStyle: TextStyle(color: Colors.white38, fontSize: 20),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromARGB(101, 212, 255, 84),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.accentGreen,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      if (state is ExcuseLoading) ...[
                        const SizedBox(height: 15),
                        const Center(child: CircularProgressIndicator()),
                      ],
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: state is ExcuseLoading
                          ? null
                          : () => Navigator.of(dialogContext).pop(),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(color: Colors.white, fontSize: 22),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accentGreen,
                      ),
                      onPressed: state is ExcuseLoading
                          ? null
                          : () {
                              final reason = reasonController.text.trim();
                              if (reason.isEmpty) return;

                              context.read<ExcuseCubit>().submitExcuse(
                                    studentId: widget.studentId,
                                    roomId: widget.roomId,
                                    reason: reason,
                                  );
                            },
                      child: const Text(
                        'تأكيد',
                        style: TextStyle(
                          color: AppColors.bgDark,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );

    excuseCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    final showButtons =
        widget.canExcuse && widget.excuseStatus == null && !_alreadySubmitted;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.roomName}:', style: const TextStyle(color: Colors.white, fontSize: 40)),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text('لم يتم الحضور', style: TextStyle(color: AppColors.redX, fontSize: 32)),
              SizedBox(width: 5),
              Icon(Icons.cancel, color: AppColors.redX, size: 22),
            ],
          ),
          const SizedBox(height: 5),
          Text('المدة الكلية للحصة: ${widget.totalRoomMinutes}', style: const TextStyle(color: Colors.white70, fontSize: 32)),
          const SizedBox(height: 6),
          Text('مدة حضور الطالب: ${widget.studentPresenceMinutes}', style: const TextStyle(color: Colors.white70, fontSize: 32)),

          if (_alreadySubmitted) ...[
            const SizedBox(height: 12),
            Text(
              _hasJustification == true
                  ? 'تم إرسال المبرر، بانتظار مراجعة الإدارة'
                  : 'تم تسجيل عدم وجود مبرر',
              style: const TextStyle(color: AppColors.accentGreen, fontSize: 26),
            ),
          ],

          if (showButtons) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _btn(
                    'يوجد مبرر',
                    false,
                    () => _openConfirmDialog(hasJustification: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _btn(
                    'لا يوجد مبرر',
                    false,
                    () => _openConfirmDialog(hasJustification: false),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _btn(String label, bool isSelected, VoidCallback onTap) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? AppColors.accentGreen : Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.accentGreen, width: 1),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8),
      ),
      child: Text(label, style: TextStyle(color: isSelected ? AppColors.bgDark : AppColors.accentGreen, fontSize: 24)),
    );
  }
}

// ------------------------------------------------------------
// بطاقة الإنجاز (نجمة + نص التهنئة)
// ------------------------------------------------------------
class _AchievementCard extends StatelessWidget {
  final String studentName;
  final String score;
  final String title;
  final String subjectName;
  final String type;

  const _AchievementCard({
    required this.studentName,
    required this.score,
    required this.title,
    required this.subjectName,
    required this.type,
  });

  String get _typeLabel {
    switch (type) {
      case 'quiz':
        return 'كويز';
      case 'exam':
        return 'اختبار';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle =
        _typeLabel.isNotEmpty ? '$_typeLabel $title' : title;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
      decoration: BoxDecoration(color: AppColors.cardDark, borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.accentGreen, size: 37),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              'حصل الطالب $studentName على علامة $score في $displayTitle في مادة $subjectName',
              textAlign: TextAlign.right,
              style: const TextStyle(color: Colors.white, fontSize: 32, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------
// بطاقة الإنذار
// ------------------------------------------------------------
class _WarningCard extends StatelessWidget {
  final String title;
  final String description;

  const _WarningCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.redX.withOpacity(0.4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.warning_amber_rounded, color: AppColors.redX, size: 30),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 36)),
            ],
          ),
          const SizedBox(height: 10),
          Text(description, style: const TextStyle(color: Colors.white70, fontSize: 28)),
        ],
      ),
    );
  }
}