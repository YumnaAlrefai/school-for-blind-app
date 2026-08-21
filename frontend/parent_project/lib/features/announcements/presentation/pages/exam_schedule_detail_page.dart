import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/app_colors.dart';

import 'package:parent_project/features/announcements/data/datasource/announcements_remote_datasource.dart';
import 'package:parent_project/features/announcements/data/repositories/announcements_repository.dart';
import 'package:parent_project/features/announcements/logic/cubit/exam_schedule_cubit.dart';
import 'package:parent_project/features/announcements/logic/cubit/exam_schedule_state.dart';

class ExamScheduleDetailPage extends StatelessWidget {
  final int announcementId;

  const ExamScheduleDetailPage({super.key, required this.announcementId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ExamScheduleCubit(
  AnnouncementsRepository(AnnouncementsRemoteDataSource(),
  ),
)..startPolling(announcementId),  // بدل fetchDetail(announcementId)
      child: const _ExamScheduleDetailView(),
    );
  }
}

class _ExamScheduleDetailView extends StatelessWidget {
  const _ExamScheduleDetailView();

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
                child: BlocBuilder<ExamScheduleCubit, ExamScheduleState>(
                  builder: (context, state) {
                    if (state is ExamScheduleLoading || state is ExamScheduleInitial) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is ExamScheduleFailure) {
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
                          ],
                        ),
                      );
                    }

                    final detail = (state as ExamScheduleSuccess).detail;

                    return SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            detail.title,
                            textAlign: TextAlign.right,
                            style: TextStyle(color: AppColors.textPrimary, fontSize: 32),
                          ),
                          const SizedBox(height: 16),
                          _buildTable(detail.columns, detail.rows),
                        ],
                      ),
                    );
                  },
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
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(
            Icons.subdirectory_arrow_left_outlined,
            color: AppColors.textPrimary,
            size: 34,
          ),
        ),
        const SizedBox(height: 20),
       
      ],
    ),
  );
}

  Widget _buildTable(List<String> columns, List<Map<String, String>> rows) {
    if (columns.isEmpty || rows.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Center(
          child: Text(
            'لا يوجد بيانات لعرضها',
            style: TextStyle(color: AppColors.overlay54, fontSize: 24),
          ),
        ),
      );
    }

    return ClipRRect(
      child: Table(
        border: TableBorder.all(color: AppColors.bgDark, width: 1),
        children: [
          TableRow(
            decoration: BoxDecoration(color: AppColors.accentGreen),
            children: columns
                .map((c) => _buildCell(c, textColor: AppColors.bgDark))
                .toList(),
          ),
          for (final row in rows)
            TableRow(
              decoration: BoxDecoration(color: AppColors.tableRowBg),
              children: row.values
                  .map((v) => _buildCell(v, textColor: AppColors.textPrimary))
                  .toList(),
            ),
        ],
      ),
    );
  }

  Widget _buildCell(String text, {required Color textColor}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor, fontSize: 22),
      ),
    );
  }
}