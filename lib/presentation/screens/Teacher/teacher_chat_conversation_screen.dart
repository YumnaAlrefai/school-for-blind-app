import 'package:flutter/material.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';

/// رسالة داخل المحادثة
class ChatMessage {
  final String text;
  final String time;

  /// true = رسالة المدرّس (يمين، خضراء) ، false = رسالة الطرف الآخر
  final bool isMine;

  const ChatMessage({
    required this.text,
    required this.time,
    required this.isMine,
  });
}

/// شاشة محادثة — الواجهة فقط، تُربط بـ Reverb عند جاهزية الباك
class TeacherChatConversationScreen extends StatefulWidget {
  final int chatId;
  final String title;
  final bool isGroup;

  const TeacherChatConversationScreen({
    super.key,
    required this.chatId,
    required this.title,
    this.isGroup = false,
  });

  @override
  State<TeacherChatConversationScreen> createState() =>
      _TeacherChatConversationScreenState();
}

class _TeacherChatConversationScreenState
    extends State<TeacherChatConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  bool _hasText = false;

  // رسائل مؤقتة — تُستبدل برسائل الباك
  final List<ChatMessage> _messages = [
    const ChatMessage(
      text: 'السلام عليكم ورحمة الله وبركاته\nكيف حالك أستاذ خليل',
      time: '9:00ص',
      isMine: false,
    ),
    const ChatMessage(
      text: 'هل وصلك الراتب يوم أمس؟\nلقد أرسلناه لك',
      time: '9:28ص',
      isMine: false,
    ),
    const ChatMessage(
      text: 'وعليكم السلام ورحمة الله وبركاته\nبخير ، أنت كيف حالك',
      time: '9:30ص',
      isMine: true,
    ),
    const ChatMessage(
      text: 'نعم لقد وصل ، شكراً لكم',
      time: '9:30ص',
      isMine: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    final has = _messageController.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // TODO: إرسال الرسالة إلى الباك (Reverb) عند الجاهزية
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        time: _currentTime(),
        isMine: true,
      ));
      _messageController.clear();
    });

    // التمرير لآخر رسالة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final period = now.hour >= 12 ? 'م' : 'ص';
    return '$hour:${now.minute.toString().padLeft(2, '0')}$period';
  }

  void _onMicPressed() {
    // TODO: تسجيل رسالة صوتية (مهم لمستخدمي التطبيق)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('التسجيل الصوتي قيد الإنشاء',
            style: TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.kBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(child: _buildMessages()),
              _buildInputBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withOpacity(0.15)),
        ),
      ),
      child: Row(
        children: [
          // صورة/أيقونة الطرف الآخر
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              widget.isGroup ? Icons.groups : Icons.person,
              color: Colors.black,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontFamily: "Arabic Typesetting",
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_none,
                color: Colors.white, size: 26),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.subdirectory_arrow_left,
                color: Colors.white, size: 26),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) return _buildDateChip('اليوم');
        return _buildBubble(_messages[index - 1]);
      },
    );
  }

  Widget _buildDateChip(String label) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    return Align(
      alignment: msg.isMine ? Alignment.centerRight : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.82,
        ),
        decoration: BoxDecoration(
          color: msg.isMine
              ? const Color(0xFF5B7A0F) // أخضر زيتوني لرسائلي
              : Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 2),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                msg.time,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          // حقل الكتابة
          Expanded(
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.15)),
              ),
              child: TextField(
                controller: _messageController,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                decoration: InputDecoration(
                  hintText: 'اكتب رسالة...',
                  hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.35), fontSize: 18),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // زر الإرسال / التسجيل الصوتي
          GestureDetector(
            onTap: _hasText ? _sendMessage : _onMicPressed,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.kPrimaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _hasText ? Icons.send : Icons.mic,
                color: Colors.black,
                size: 26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}