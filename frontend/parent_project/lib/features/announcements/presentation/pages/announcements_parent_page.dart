import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:flutter/gestures.dart';
import 'package:parent_project/Widget/theme_controller.dart';
import 'package:parent_project/Widget/theme_listener.dart';
import 'package:parent_project/screens/reports_parent.dart';

import 'package:parent_project/features/announcements/data/datasource/announcements_remote_datasource.dart';
import 'package:parent_project/features/announcements/data/repositories/announcements_repository.dart';
import 'package:parent_project/features/announcements/data/models/announcement_model.dart';
import 'package:parent_project/features/announcements/logic/cubit/announcements_cubit.dart';
import 'package:parent_project/features/announcements/logic/cubit/announcements_state.dart';
import 'package:parent_project/features/announcements/presentation/pages/exam_schedule_detail_page.dart';

class AnnouncementsParentPage extends StatelessWidget {
  const AnnouncementsParentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnnouncementsCubit(
        AnnouncementsRepository(AnnouncementsRemoteDataSource()),
      )..startPolling(),
      child: const _AnnouncementsView(),
    );
  }
}

class _AnnouncementsView extends StatefulWidget {
  const _AnnouncementsView();

  @override
  State<_AnnouncementsView> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<_AnnouncementsView> {
  final Map<int, bool> _expandedMap = {};

  IconData _iconForType(String type) {
    switch (type) {
      case 'exam_schedule':
        return Icons.assignment_rounded;
      case 'school_timetable':
        return Icons.table_chart_rounded;
      default:
        return Icons.campaign_rounded;
    }
  }

  String _titleForType(AnnouncementModel model) {
  if (model.title != null && model.title!.trim().isNotEmpty) {
    return model.title!;
  }
  switch (model.type) {
    case 'exam_schedule':
      return 'برنامج الامتحانات';
    case 'school_timetable':
      return 'برنامج الدوام';
    default:
      return 'إعلان';
  }
}

List<String> _descriptionLinesFor(AnnouncementModel model) {
  if (model.type == 'exam_schedule' || model.type == 'school_timetable') {
    final label = _titleForType(model);
    return [
      'تم نشر $label',
      'أنقر هنا للإطلاع عليه',
    ];
  }
  return [model.content ?? ''];
}

  String? _linkTextFor(AnnouncementModel model) {
    if (model.type == 'exam_schedule' || model.type == 'school_timetable') {
      return 'هنا';
    }
    return null;
  }

  void _onLinkTap(AnnouncementModel model) {
    if (model.type == 'exam_schedule') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ExamScheduleDetailPage(announcementId: model.id),
        ),
      );
    }
  }

  String _dateKeyFrom(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) {
      return isoDate;
    }
  }

  String _timeFrom(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate).toLocal();
      final hour24 = dt.hour;
      final hour12 = hour24 % 12 == 0 ? 12 : hour24 % 12;
      final period = hour24 < 12 ? 'ص' : 'م';
      final minute = dt.minute.toString().padLeft(2, '0');
      return '$hour12:$minute $period';
    } catch (_) {
      return '';
    }
  }

  Map<String, List<AnnouncementModel>> _groupByDate(List<AnnouncementModel> items) {
    final Map<String, List<AnnouncementModel>> grouped = {};
    for (final item in items) {
      final key = _dateKeyFrom(item.createdAt);
      grouped.putIfAbsent(key, () => []).add(item);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    return ThemeListener(
  builder: (context) =>
     Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.bgDark,
        body: SafeArea(
          child: SizedBox.expand(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildTopBar(),
                    Expanded(
                      child: BlocBuilder<AnnouncementsCubit, AnnouncementsState>(
                        builder: (context, state) {
                          if (state is AnnouncementsLoading || state is AnnouncementsInitial) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (state is AnnouncementsFailure) {
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
                                        context.read<AnnouncementsCubit>().fetchAnnouncements(),
                                    child: const Text('إعادة المحاولة'),
                                  ),
                                ],
                              ),
                            );
                          }

                          final announcements = (state as AnnouncementsSuccess).announcements;

                          if (announcements.isEmpty) {
                            return Center(
                              child: Text(
                                'لا توجد إعلانات متاحة حاليًا',
                                style: TextStyle(color: AppColors.overlay70, fontSize: 28),
                              ),
                            );
                          }

                          final sorted = [...announcements]
                            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                          final grouped = _groupByDate(sorted);

                          return SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 110),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: _buildAnnouncementsList(grouped),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 15,
                  left: 0,
                  right: 0,
                  child: Center(child: _buildBottomNav()),
                ),
              ],
            ),
          ),
        ),
      ),),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        border: Border(
          bottom: BorderSide(color: AppColors.overlay12, width: 1),
          top: BorderSide(color: AppColors.overlay12, width: 1),
        ),
      ),
      child: Text(
        'الإعلانات',
        textAlign: TextAlign.center,
        style: TextStyle(color: AppColors.textPrimary, fontSize: 40),
      ),
    );
  }

  List<Widget> _buildAnnouncementsList(Map<String, List<AnnouncementModel>> grouped) {
    final List<Widget> widgets = [];

    grouped.forEach((date, items) {
      widgets.add(_buildDateLabel(date));
      widgets.add(const SizedBox(height: 10));

      for (final item in items) {
        widgets.add(_buildAnnouncementCard(item));
        widgets.add(const SizedBox(height: 14));
      }

      widgets.add(const SizedBox(height: 8));
    });

    return widgets;
  }

  Widget _buildDateLabel(String date) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.cardDark.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          date,
          style: TextStyle(color: AppColors.overlay70, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(AnnouncementModel model) {
    final bool isExpanded = _expandedMap[model.id] ?? false;
    final descriptionLines = _descriptionLinesFor(model);
    final linkText = _linkTextFor(model);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(15),
            onTap: () {
              setState(() {
                _expandedMap[model.id] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(_iconForType(model.type), color: AppColors.accentGreen, size: 25),
                  const SizedBox(width: 8),
                  Text(
                    _titleForType(model),
                    style: TextStyle(color: AppColors.textPrimary, fontSize: 30),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.overlay70,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: _buildExpandedContent(model, descriptionLines, linkText),
            secondChild: const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(
    AnnouncementModel model,
    List<String> descriptionLines,
    String? linkText,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int i = 0; i < descriptionLines.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: _buildDescriptionLine(
                descriptionLines[i],
                linkText,
                () => _onLinkTap(model),
              ),
            ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _timeFrom(model.createdAt),
              style: TextStyle(color: AppColors.overlay38, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionLine(String line, String? linkText, VoidCallback onLinkTap) {
    if (linkText == null || !line.contains(linkText)) {
      return Text(
        line,
        textAlign: TextAlign.right,
        style: TextStyle(color: AppColors.overlay70, fontSize: 25, height: 1.5, fontFamily: 'ArabicTypesetting'),
      );
    }

    final parts = line.split(linkText);
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        style: TextStyle(color: AppColors.overlay70, fontSize: 25, fontFamily: 'ArabicTypesetting', height: 1.5),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: linkText,
            style: TextStyle(
              color: AppColors.accentGreen,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = onLinkTap,
          ),
          if (parts.length > 1) TextSpan(text: parts[1]),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withOpacity(0.5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ReportsParent()),
              );
            },
            icon: Icon(
              Icons.home_rounded,
              color: AppColors.overlay54,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.campaign_rounded,
              color: AppColors.accentGreen,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}