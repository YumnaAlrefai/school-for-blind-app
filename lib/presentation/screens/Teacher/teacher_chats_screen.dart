import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
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

  // بيانات مؤقتة — تُستبدل ببيانات الباك عند جاهزيته
  static const List<ChatItem> _adminChats = [
    ChatItem(id: 1, name: 'المدير', isGroup: true),
    ChatItem(id: 2, name: 'الموجه'),
  ];

  List<ChatItem> get _currentList => switch (_tab) {
    ChatTab.admin => _adminChats,
    ChatTab.channels => const [],
    ChatTab.groups => const [],
  };

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
            if (_tab == t) return;
            setState(() => _tab = t);
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
