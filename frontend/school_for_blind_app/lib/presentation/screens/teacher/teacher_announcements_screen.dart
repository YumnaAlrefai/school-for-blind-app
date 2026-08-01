import 'dart:async';
import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/exam_schedule_screen.dart';

/// إعلان من الإدارة
class Announcement {
  final int id;
  final String type;
  final String title;
  final String content;
  final String date;
  final String time;

  const Announcement({
    required this.id,
    required this.type,
    required this.title,
    required this.content,
    required this.date,
    required this.time,
  });

  /// هل هذا الإعلان جدول امتحان؟
  bool get isExamSchedule => type == 'exam_schedule';
}

class TeacherAnnouncementsScreen extends StatefulWidget {
  const TeacherAnnouncementsScreen({super.key});

  @override
  State<TeacherAnnouncementsScreen> createState() =>
      _TeacherAnnouncementsScreenState();
}

class _TeacherAnnouncementsScreenState
    extends State<TeacherAnnouncementsScreen> {
  bool _loading = true;
  List<Announcement> _items = [];

  /// مؤقّت التحديث التلقائي
  Timer? _refreshTimer;

  /// الإعلانات الموسّعة (id)
  final Set<int> _expanded = {};

  @override
  void initState() {
    super.initState();
    _load();
    // تحديث تلقائي كل 30 ثانية (صامت) طالما الشاشة مفتوحة
    _refreshTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _load(silent: true),
    );
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) async {
    // التحديث الصامت لا يُظهر مؤشّر التحميل (تجنّباً للوميض)
    if (!silent) {
      setState(() {
        _loading = true;
      });
    }

    final result = await getIt<TeacherRepo>().getAnnouncements();

    result.when(
      success: (data) {
        final list = _extractList(data);

        final items = <Announcement>[];
        for (final e in list) {
          if (e is! Map) continue;
          final m = Map<String, dynamic>.from(e);

          // نقرأ الحقول بمرونة (title/content قد تختلف تسميتها)
          final title = (m['title'] ?? m['type'] ?? 'إعلان').toString();
          final content = (m['content'] ?? m['body'] ?? m['message'] ?? '')
              .toString();

          final createdAt = (m['created_at'] ?? '').toString();
          items.add(
            Announcement(
              id: int.tryParse('${m['id']}') ?? items.length,
              type: (m['type'] ?? 'normal').toString(),
              title: title,
              content: content,
              date: _formatDate(createdAt),
              time: _formatTimeOnly(createdAt),
            ),
          );
        }

        setState(() {
          _items = items;
          _loading = false;
        });
      },
      failure: (_) {
        setState(() {
          // نعرض "لا توجد إعلانات" بدل رسالة خطأ (الباك يرجّع رسالة عند الفراغ)
          _items = [];
          _loading = false;
        });
      },
    );
  }

  /// يستخرج قائمة الإعلانات سواء كانت data مصفوفة مباشرة أو داخل مفتاح
  List _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      if (m['data'] is List) return m['data'];
      if (m['announcements'] is List) return m['announcements'];
    }
    return const [];
  }

  String _formatDate(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final l = dt.toLocal();
    return '${l.year}/${l.month}/${l.day}';
  }

  String _formatTimeOnly(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final l = dt.toLocal();
    final h = l.hour > 12 ? l.hour - 12 : (l.hour == 0 ? 12 : l.hour);
    final period = l.hour >= 12 ? 'م' : 'ص';
    return '$h:${l.minute.toString().padLeft(2, '0')}$period';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(color: Colors.white24, thickness: 1, height: 20),
                _buildTopBar(),
                const Divider(color: Colors.white24, thickness: 1, height: 20),
                const SizedBox(height: 16),
                Expanded(child: _buildList()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'الإعلانات',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
            fontFamily: "ArabicTypesetting",
            fontWeight: FontWeight.w400,
          ),
        ),
        IconButton(
          icon: const Icon(
            Icons.subdirectory_arrow_left,
            size: 30,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildList() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    if (_items.isEmpty) {
      return Center(
        child: Text(
          'لا توجد إعلانات حالياً',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _items.length,
      itemBuilder: (context, i) => _buildAnnouncementCard(_items[i]),
    );
  }

  Widget _buildAnnouncementCard(Announcement item) {
    final isExpanded = _expanded.contains(item.id);
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // التاريخ فوق الكارد (خارجه)
        if (item.date.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Center(
              child: Text(
                item.date,
                style: TextStyle(
                  color: onSurface.withOpacity(0.6),
                  fontSize: 20,
                ),
              ),
            ),
          ),

        // الكارد
        Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFFFF).withOpacity(0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان + الأيقونة/السهم (من اليمين)
              Row(
                children: [
                  // أيقونة الجدول أو السهم — من اليمين (أول عنصر في RTL)
                  if (item.isExamSchedule)
                    GestureDetector(
                      onTap: () => _openExamSchedule(item),
                      child: const Icon(
                        Icons.calendar_month,
                        color: AppColors.kPrimaryColor,
                        size: 26,
                      ),
                    )
                  else if (item.content.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isExpanded) {
                            _expanded.remove(item.id);
                          } else {
                            _expanded.add(item.id);
                          }
                        });
                      },
                      child: Icon(
                        isExpanded
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: AppColors.kPrimaryColor,
                        size: 28,
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: onSurface,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: isExpanded ? null : 1,
                      overflow: isExpanded ? null : TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // محتوى الرسالة العادية
              if (!item.isExamSchedule && item.content.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  item.content,
                  style: TextStyle(
                    color: onSurface.withOpacity(0.85),
                    fontSize: 20,
                    height: 1.5,
                  ),
                  maxLines: isExpanded ? null : 2,
                  overflow: isExpanded ? null : TextOverflow.ellipsis,
                ),
              ],

              // التوقيت أسفل يسار الكارد
              if (item.time.isNotEmpty) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.time,
                    style: TextStyle(
                      color: onSurface.withOpacity(0.5),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _openExamSchedule(Announcement item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ExamScheduleScreen(announcementId: item.id, title: item.title),
      ),
    );
  }
}
