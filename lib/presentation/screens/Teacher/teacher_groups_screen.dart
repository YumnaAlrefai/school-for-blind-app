import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_chat_conversation_screen.dart';

/// مجموعة (مناقشة مادة — الطلاب يتفاعلون)
class GroupItem {
  final int id;
  final String subjectName;

  const GroupItem({required this.id, required this.subjectName});
}

/// مجموعاتي: قائمة المناقشات، كل مادة مجموعة نقاش + زر كتم إشعارات
class TeacherGroupsScreen extends StatefulWidget {
  const TeacherGroupsScreen({super.key});

  @override
  State<TeacherGroupsScreen> createState() => _TeacherGroupsScreenState();
}

class _TeacherGroupsScreenState extends State<TeacherGroupsScreen> {
  bool _loading = true;
  List<GroupItem> _groups = [];

  /// كتم الإشعارات (وهمي محلياً لحين جاهزية الباك)
  final Set<int> _muted = {};

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() => _loading = true);

    final result = await getIt<TeacherRepo>().getChannels();

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final list = (map['data'] is List) ? map['data'] as List : const [];

        final items = <GroupItem>[];
        final seen = <int>{};
        for (final e in list) {
          if (e is! Map) continue;
          final m = Map<String, dynamic>.from(e);
          if ((m['type'] ?? '').toString() != 'channel') continue;

          // المناقشة موجودة داخل القناة بحقل discussion
          final disc = m['discussion'];
          if (disc is! Map) continue;
          final d = Map<String, dynamic>.from(disc);

          final subjectId = int.tryParse('${m['subject_id']}') ?? 0;
          if (!seen.add(subjectId)) continue; // مادة واحدة لكل subject_id

          items.add(GroupItem(
            id: int.tryParse('${d['id']}') ?? 0, // id المناقشة (للمحادثة)
            subjectName: _cleanName((m['name'] ?? '').toString()),
          ));
        }

        setState(() {
          _groups = items;
          _loading = false;
        });
      },
      failure: (_) => setState(() => _loading = false),
    );
  }

  /// "مناقشة مادة الفلسفة - غالية الياسين" -> "الفلسفة"
  String _cleanName(String raw) {
    var name = raw.replaceAll('مناقشة مادة', '').replaceAll('قناة مادة', '');
    final dash = name.indexOf('-');
    if (dash != -1) name = name.substring(0, dash);
    return name.trim().isEmpty ? raw : name.trim();
  }

  IconData _subjectIcon(String name) {
    if (name.contains('فلسف')) return Icons.psychology;
    if (name.contains('تاريخ')) return Icons.history_edu;
    if (name.contains('جغراف')) return Icons.public;
    if (name.contains('إنكل') || name.contains('انكل') || name.contains('انجل')) {
      return Icons.language;
    }
    if (name.contains('فرنس')) return Icons.translate;
    if (name.contains('عرب')) return Icons.menu_book;
    if (name.contains('رياض') || name.contains('جبر')) return Icons.calculate;
    if (name.contains('فيزياء')) return Icons.bolt;
    if (name.contains('كيمياء')) return Icons.science;
    if (name.contains('أحياء') || name.contains('احياء')) return Icons.eco;
    if (name.contains('دين') || name.contains('إسلام')) return Icons.mosque;
    return Icons.school;
  }

  void _toggleMute(int id) {
    setState(() {
      if (_muted.contains(id)) {
        _muted.remove(id);
      } else {
        _muted.add(id);
      }
    });
    // TODO: ربط كتم الإشعارات بالباك عند جاهزية الـ endpoint
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
          'مجموعاتي',
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

  Widget _buildLine() {
    return Container(
      height: 0.1,
      color: const Color(0xFFFFFFFF).withOpacity(0.5),
    );
  }

  Widget _buildList() {
    if (_loading) {
      return const Center(
          child: CircularProgressIndicator(color: Colors.white));
    }
    if (_groups.isEmpty) {
      return Center(
        child: Text('لا توجد مجموعات بعد',
            style:
                TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22)),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _groups.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) return _buildLine();
        return _buildGroupRow(_groups[i - 1]);
      },
    );
  }

  Widget _buildGroupRow(GroupItem item) {
    final icon = _subjectIcon(item.subjectName);
    final isMuted = _muted.contains(item.id);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              // أيقونة المادة (تفتح المناقشة عند الضغط)
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => _openGroup(item, icon),
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: Icon(icon, color: AppColors.kPrimaryColor, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              // اسم المادة (يفتح المناقشة)
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _openGroup(item, icon),
                  child: Text(
                    item.subjectName,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              // زر كتم الإشعارات
              GestureDetector(
                onTap: () => _toggleMute(item.id),
                child: Icon(
                  isMuted
                      ? Icons.notifications_off
                      : Icons.notifications_active_outlined,
                  color: isMuted
                      ? Colors.white38
                      : AppColors.kPrimaryColor,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        _buildLine(),
      ],
    );
  }

  void _openGroup(GroupItem item, IconData icon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TeacherChatConversationScreen(
          chatId: item.id,
          title: item.subjectName,
          isGroup: true,
          icon: icon,
        ),
      ),
    );
  }
}