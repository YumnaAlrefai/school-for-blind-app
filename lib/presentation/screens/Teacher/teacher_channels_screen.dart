import 'package:flutter/material.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_channel_screen.dart';

/// قناة (مادة يدرّسها المعلّم)
class ChannelItem {
  final int id;
  final String subjectName;

  const ChannelItem({required this.id, required this.subjectName});
}

/// قنواتي: قائمة المواد، كل مادة قناة بثّ بأيقونتها الخاصة
class TeacherChannelsScreen extends StatefulWidget {
  const TeacherChannelsScreen({super.key});

  @override
  State<TeacherChannelsScreen> createState() => _TeacherChannelsScreenState();
}

class _TeacherChannelsScreenState extends State<TeacherChannelsScreen> {
  bool _loading = true;
  List<ChannelItem> _channels = [];

  @override
  void initState() {
    super.initState();
    _loadChannels();
  }

  Future<void> _loadChannels() async {
    setState(() => _loading = true);

    final result = await getIt<TeacherRepo>().getChannels();

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final list = (map['data'] is List) ? map['data'] as List : const [];

        final items = <ChannelItem>[];
        for (final e in list) {
          if (e is! Map) continue;
          final m = Map<String, dynamic>.from(e);
          if ((m['type'] ?? '').toString() != 'channel') continue;

          items.add(ChannelItem(
            id: int.tryParse('${m['id']}') ?? 0,
            subjectName: _cleanName((m['name'] ?? '').toString()),
          ));
        }

        setState(() {
          _channels = items;
          _loading = false;
        });
      },
      failure: (_) => setState(() => _loading = false),
    );
  }

  /// "قناة مادة الفلسفة - غالية الياسين" -> "الفلسفة"
  String _cleanName(String raw) {
    var name = raw.replaceAll('قناة مادة', '');
    final dash = name.indexOf('-');
    if (dash != -1) name = name.substring(0, dash);
    return name.trim().isEmpty ? raw : name.trim();
  }

  /// أيقونة خاصة لكل مادة
  IconData _subjectIcon(String name) {
    if (name.contains('فلسف')) return Icons.psychology;
    if (name.contains('تاريخ')) return Icons.history_edu;
    if (name.contains('جغراف')) return Icons.public;
    if (name.contains('عرب')) return Icons.menu_book;
    if (name.contains('إنكل') || name.contains('انكل') || name.contains('انجل')) {
      return Icons.translate;
    }
    if (name.contains('رياض')) return Icons.calculate;
    if (name.contains('فيزياء')) return Icons.science;
    if (name.contains('كيمياء')) return Icons.biotech;
    if (name.contains('أحياء') || name.contains('احياء')) return Icons.eco;
    if (name.contains('دين') || name.contains('إسلام')) return Icons.mosque;
    return Icons.menu_book;
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
          'قنواتي',
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

    if (_channels.isEmpty) {
      return Center(
        child: Text('لا توجد قنوات بعد',
            style:
                TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22)),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: _channels.length + 1,
      itemBuilder: (context, i) {
        if (i == 0) return _buildLine();
        return _buildChannelRow(_channels[i - 1]);
      },
    );
  }

  Widget _buildChannelRow(ChannelItem item) {
    final icon = _subjectIcon(item.subjectName);
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeacherChannelScreen(
                  channelId: item.id,
                  channelName: item.subjectName,
                  icon: icon,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                Container(
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
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.subjectName,
                    style: const TextStyle(color: Colors.white, fontSize: 22),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildLine(),
      ],
    );
  }
}