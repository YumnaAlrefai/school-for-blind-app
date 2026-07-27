import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/apiTeacher/teacherRepo.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/Teacher/teacher_chat_conversation_screen.dart';

/// فئات المحادثات
enum ChatTab { admin, channels, groups }

extension ChatTabX on ChatTab {
  String get label => switch (this) {
    ChatTab.admin => 'الإدارة',
    ChatTab.channels => 'قنواتي',
    ChatTab.groups => 'مجموعاتي',
  };
}

/// عنصر محادثة في القائمة
class ChatItem {
  final int id;
  final String name;
  final bool isGroup;

  const ChatItem({required this.id, required this.name, this.isGroup = false});
}

class TeacherChatsScreen extends StatefulWidget {
  const TeacherChatsScreen({super.key});

  @override
  State<TeacherChatsScreen> createState() => _TeacherChatsScreenState();
}

class _TeacherChatsScreenState extends State<TeacherChatsScreen> {
  ChatTab _tab = ChatTab.admin;

  bool _loadingAdmin = true;
  List<ChatItem> _adminChats = [];

  List<ChatItem> get _currentList => switch (_tab) {
    ChatTab.admin => _adminChats,
    ChatTab.channels => const [],
    ChatTab.groups => const [],
  };

  @override
  void initState() {
    super.initState();
    _loadAdminChats();
  }

  Future<void> _loadAdminChats() async {
    setState(() => _loadingAdmin = true);

    final result = await getIt<TeacherRepo>().getAdminChats();

    result.when(
      success: (data) {
        print('🟣 ADMIN CHATS RAW: $data');
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final list = (map['data'] is List) ? map['data'] as List : const [];

        final items = <ChatItem>[];
        for (final e in list) {
          if (e is! Map) continue;
          final m = Map<String, dynamic>.from(e);
          final admin = (m['admin'] is Map)
              ? Map<String, dynamic>.from(m['admin'])
              : {};
          final role = (admin['role'] ?? m['name'] ?? 'الإدارة').toString();

          items.add(
            ChatItem(
              id: int.tryParse('${m['id']}') ?? 0,
              name: _roleLabel(role),
              isGroup: true,
            ),
          );
        }

        setState(() {
          _adminChats = items;
          _loadingAdmin = false;
        });
      },
      failure: (error) {
        print('🔴 ADMIN CHATS FAILED: $error');
        setState(() => _loadingAdmin = false);
      },
    );
  }

  /// ترجمة دور الأدمن إلى العربية
  String _roleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'super admin':
        return 'المدير';
      case 'academic manager':
        return ' الموجه';
      default:
        return role;
    }
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
                _buildTabs(),
                const SizedBox(height: 20),
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
          'الدردشات',
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

  Widget _buildTabs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ChatTab.values.map((t) {
        final isSelected = _tab == t;
        return GestureDetector(
          onTap: () {
            if (t == ChatTab.channels) {
              Navigator.pushNamed(context, AppRoutes.kTeacherChannels);
              return;
            }
            if (t == ChatTab.groups) {
              Navigator.pushNamed(context, AppRoutes.kTeacherGroups);
              return;
            }
            if (_tab == t) return;
            setState(() => _tab = t); // الإدارة inline
          },
          child: Container(
            width: 105,
            height: 37,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.kPrimaryColor
                  : Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(50),
            ),
            alignment: Alignment.center,
            child: Text(
              t.label,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildList() {
    final items = _currentList;

    if (items.isEmpty) {
      return Center(
        child: Text(
          'لا توجد محادثات هنا بعد',
          style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 22),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      itemCount: items.length + 1, // +1 للخط العلوي
      itemBuilder: (context, i) {
        // خط فوق أول عنصر
        if (i == 0) return _buildLine();
        return _buildChatCard(items[i - 1]);
      },
    );
  }

  /// خط فاصل بمواصفات التصميم
  Widget _buildLine() {
    return Container(
      height: 0.1,
      color: const Color(0xFFFFFFFF).withOpacity(0.5),
    );
  }

  Widget _buildChatCard(ChatItem item) {
    return Column(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => TeacherChatConversationScreen(
                  chatId: item.id,
                  title: item.name,
                  isGroup: item.isGroup,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              children: [
                // أيقونة دائرية بحدود بيضاء (يمين)
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
                  child: Icon(
                    item.isGroup ? Icons.man : Icons.person,
                    color: AppColors.kPrimaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(color: Colors.white, fontSize: 40),
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
