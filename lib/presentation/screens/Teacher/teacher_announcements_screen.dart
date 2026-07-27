import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

/// إعلان من الإدارة
class Announcement {
  final int id;
  final String title;
  final String content;
  final String time;

  const Announcement({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
  });
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
  String? _error;
  List<Announcement> _items = [];

  /// الإعلانات الموسّعة (id)
  final Set<int> _expanded = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await getIt<TeacherRepo>().getAnnouncements();

    result.when(
      success: (data) {
        final list = _extractList(data);

        final items = <Announcement>[];
        for (final e in list) {
          if (e is! Map) continue;
          final m = Map<String, dynamic>.from(e);

          // نقرأ الحقول بمرونة (title/content قد تختلف تسميتها)
          final title =
              (m['title'] ?? m['type'] ?? 'إعلان').toString();
          final content =
              (m['content'] ?? m['body'] ?? m['message'] ?? '').toString();

          items.add(Announcement(
            id: int.tryParse('${m['id']}') ?? items.length,
            title: title,
            content: content,
            time: _formatTime((m['created_at'] ?? '').toString()),
          ));
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

  String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final l = dt.toLocal();
    final h = l.hour > 12 ? l.hour - 12 : (l.hour == 0 ? 12 : l.hour);
    final period = l.hour >= 12 ? 'م' : 'ص';
    final date = '${l.year}/${l.month}/${l.day}';
    return '$date  $h:${l.minute.toString().padLeft(2, '0')}$period';
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
                const Divider(
                    color: Colors.white24, thickness: 1, height: 20),
                _buildTopBar(),
                const Divider(
                    color: Colors.white24, thickness: 1, height: 20),
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
            fontSize: 30,
            fontFamily: "Arabic Typesetting",
            fontWeight: FontWeight.w300,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.subdirectory_arrow_left,
              size: 30, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }

  Widget _buildList() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
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

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // الزمن فوق الرسالة
          if (item.time.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                item.time,
                style: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: 12),
              ),
            ),

          // العنوان + سهم التوسيع
          Row(
            children: [
              Expanded(
                child: Text(
                  item.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: isExpanded ? null : 1,
                  overflow:
                      isExpanded ? null : TextOverflow.ellipsis,
                ),
              ),
              if (item.content.isNotEmpty)
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
            ],
          ),

          // المحتوى — يظهر كاملاً عند التوسيع، ومختصراً خلاف ذلك
          if (item.content.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              item.content,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: 16,
                height: 1.5,
              ),
              maxLines: isExpanded ? null : 2,
              overflow: isExpanded ? null : TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}