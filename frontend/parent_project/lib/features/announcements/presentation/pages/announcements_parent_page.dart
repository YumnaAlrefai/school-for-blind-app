/*import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/Widget/app_colors.dart';
import 'package:parent_project/screens/reports_parent.dart';

import 'package:parent_project/features/announcements/data/datasource/announcements_remote_datasource.dart';
import 'package:parent_project/features/announcements/data/repositories/announcements_repository.dart';
import 'package:parent_project/features/announcements/data/models/announcement_list_item_model.dart';
import 'package:parent_project/features/announcements/logic/cubit/announcements_cubit.dart';
import 'package:parent_project/features/announcements/logic/cubit/announcements_state.dart';
import 'package:parent_project/features/announcements/presentation/pages/announcement_detail_page.dart';

class AnnouncementsParent1 extends StatelessWidget {
  const AnnouncementsParent1({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnnouncementsCubit(
        AnnouncementsRepository(AnnouncementsRemoteDataSource()),
      )..fetchAnnouncements(),
      child: const _Announcements1View(),
    );
  }
}

class _Announcements1View extends StatefulWidget {
  const _Announcements1View();

  @override
  State<_Announcements1View> createState() => _AnnouncementsViewState();
}

class _AnnouncementsViewState extends State<_Announcements1View> {
  // تتبع حالة الفتح/الطي لكل إعلان عبر مفتاح فريد
  final Map<int, bool> _expandedMap = {};

  // ------------------------------------------------------------
  // تحديد الأيقونة المناسبة تلقائيًا حسب نوع الإعلان أو كلمات بمحتواه
  // ------------------------------------------------------------
  IconData _iconResolver(String type, String? content) {
    if (type == 'exam_schedule') return Icons.assignment_rounded;
    if (type == 'school_timetable') return Icons.table_chart_rounded;

    final text = content ?? '';
    const Map<String, IconData> keywordIcons = {
      'دوام': Icons.table_chart_rounded,
      'امتحان': Icons.assignment_rounded,
      'إمتحان': Icons.assignment_rounded,
      'عطلة': Icons.calendar_month_rounded,
      'اجتماع': Icons.groups_rounded,
      'رحلة': Icons.directions_bus_rounded,
      'دفعة': Icons.payments_rounded,
      'دفع': Icons.payments_rounded,
      'صيانة': Icons.build_rounded,
      'تنبيه': Icons.warning_amber_rounded,
      'إنذار': Icons.warning_amber_rounded,
    };

    for (final entry in keywordIcons.entries) {
      if (text.contains(entry.key)) return entry.value;
    }
    return Icons.campaign_rounded;
  }

  // ------------------------------------------------------------
  // بيانات عرض كل إعلان حسب نوعه (عنوان + أسطر وصف + رابط)
  // ------------------------------------------------------------
  String _titleFor(AnnouncementListItemModel item) {
    switch (item.type) {
      case 'exam_schedule':
        return 'برنامج الامتحان';
      case 'school_timetable':
        return 'برنامج الدوام';
      default:
        return 'إعلان';
    }
  }

  List<String> _descriptionLinesFor(AnnouncementListItemModel item) {
    if (item.type == 'exam_schedule') {
      return ['تم نشر برنامج الامتحان', 'أنقر هنا للإطلاع عليه'];
    }
    if (item.type == 'school_timetable') {
      return ['تم نشر برنامج الدوام الأسبوعي', 'أنقر هنا للإطلاع عليه'];
    }
    return [item.content ?? ''];
  }

  String? _linkTextFor(AnnouncementListItemModel item) {
    if (item.type == 'exam_schedule' || item.type == 'school_timetable') {
      return 'هنا';
    }
    return null;
  }

  // ------------------------------------------------------------
  // تنسيق تاريخ العرض (رأس المجموعة) من created_at الخام
  // "2026-06-14T14:40:45.000000Z" → "14/6/2026"
  // ------------------------------------------------------------
  String _formatDateGroup(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final parsed = DateTime.parse(rawDate);
      return '${parsed.day}/${parsed.month}/${parsed.year}';
    } catch (_) {
      return rawDate;
    }
  }

  // ------------------------------------------------------------
  // تنسيق وقت العرض داخل البطاقة الموسّعة
  // ------------------------------------------------------------
  String _formatTime(String rawDate) {
    if (rawDate.isEmpty) return '';
    try {
      final parsed = DateTime.parse(rawDate).toLocal();
      final hour = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
      final minute = parsed.minute.toString().padLeft(2, '0');
      final period = parsed.hour >= 12 ? 'م' : 'ص';
      return '$hour:$minute $period';
    } catch (_) {
      return '';
    }
  }

  void _onLinkTap(AnnouncementListItemModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AnnouncementDetailPage(
          id: item.id,
          type: item.type,
          fallbackTitle: _titleFor(item),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
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
                                    style: const TextStyle(color: Colors.white70, fontSize: 26),
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

                          final items = (state as AnnouncementsSuccess).items;

                          if (items.isEmpty) {
                            return const Center(
                              child: Text(
                                'لا توجد إعلانات متاحة حاليًا',
                                style: TextStyle(color: Colors.white70, fontSize: 28),
                              ),
                            );
                          }

                          // نجمع الإعلانات حسب تاريخ إنشائها
                          final Map<String, List<AnnouncementListItemModel>> grouped = {};
                          for (final item in items) {
                            final dateKey = _formatDateGroup(item.createdAt);
                            grouped.putIfAbsent(dateKey, () => []).add(item);
                          }

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
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 3),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        border: Border(bottom: BorderSide(color: Colors.white12, width: 1), top: BorderSide(color: Colors.white12, width: 1)),
      ),
      child: const Text(
        'الإعلانات',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white, fontSize: 40),
      ),
    );
  }

  List<Widget> _buildAnnouncementsList(
    Map<String, List<AnnouncementListItemModel>> grouped,
  ) {
    final List<Widget> widgets = [];

    grouped.forEach((date, announcements) {
      widgets.add(_buildDateLabel(date));
      widgets.add(const SizedBox(height: 10));

      for (final item in announcements) {
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
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildAnnouncementCard(AnnouncementListItemModel item) {
    final bool isExpanded = _expandedMap[item.id] ?? false;
    final title = _titleFor(item);
    final descriptionLines = _descriptionLinesFor(item);
    final linkText = _linkTextFor(item);

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
                _expandedMap[item.id] = !isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(_iconResolver(item.type, item.content), color: AppColors.accentGreen, size: 25),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 30),
                  ),
                  const Spacer(),
                  AnimatedRotation(
                    turns: isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white70,
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
            firstChild: _buildExpandedContent(item, descriptionLines, linkText),
            secondChild: const SizedBox(width: double.infinity, height: 0),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandedContent(
    AnnouncementListItemModel item,
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
              child: _buildDescriptionLine(descriptionLines[i], linkText, item),
            ),
          const SizedBox(height: 6),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              _formatTime(item.createdAt),
              style: const TextStyle(color: Colors.white38, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  // سطر وصف واحد، مع تلوين كلمة الرابط (linkText) وربطها بالضغط الفعلي
  Widget _buildDescriptionLine(
    String line,
    String? linkText,
    AnnouncementListItemModel item,
  ) {
    if (linkText == null || !line.contains(linkText)) {
      return Text(
        line,
        textAlign: TextAlign.right,
        style: const TextStyle(color: Colors.white70, fontSize: 25, height: 1.5, fontFamily: 'ArabicTypesetting'),
      );
    }

    final parts = line.split(linkText);
    return RichText(
      textAlign: TextAlign.right,
      text: TextSpan(
        style: const TextStyle(color: Colors.white70, fontSize: 25, fontFamily: 'ArabicTypesetting', height: 1.5),
        children: [
          TextSpan(text: parts[0]),
          TextSpan(
            text: linkText,
            style: const TextStyle(
              color: AppColors.accentGreen,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => _onLinkTap(item),
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
            color: Colors.white.withOpacity(0.5),
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
              color: Colors.white54,
              size: 36,
            ),
          ),
          const SizedBox(width: 20),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.campaign_rounded,
              color: AppColors.accentGreen,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}*/