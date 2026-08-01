import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/reverb_service.dart';
import 'package:school_for_blind_app/core/theme/app_colors.dart';
import 'package:school_for_blind_app/data/repository/teacher_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';
import 'package:school_for_blind_app/presentation/screens/teacher/report_message_screen.dart';
import 'package:school_for_blind_app/presentation/widgets/teacher/voice_message_player.dart';

class ChatMessage {
  final String text;
  final String time;

  final bool isMine;

  final String? audioUrl;

  final int? messageId;

  final String senderName;

  final String createdAt;

  const ChatMessage({
    required this.text,
    required this.time,
    required this.isMine,
    this.audioUrl,
    this.messageId,
    this.senderName = '',
    this.createdAt = '',
  });

  bool get isVoice => audioUrl != null && audioUrl!.isNotEmpty;
}

class TeacherChatConversationScreen extends StatefulWidget {
  final int chatId;
  final String title;
  final bool isGroup;
  final IconData? icon;

  const TeacherChatConversationScreen({
    super.key,
    required this.chatId,
    required this.title,
    this.isGroup = false,
    this.icon,
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

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  String? _recordPath;

  bool _loadingMessages = true;
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _messageController.addListener(_onTextChanged);
    _loadMessages();
    _initRealtime();
  }

  Future<void> _loadMessages() async {
    setState(() => _loadingMessages = true);

    final result = await getIt<TeacherRepo>().getChatMessages(widget.chatId);

    result.when(
      success: (data) {
        final map = (data is Map) ? Map<String, dynamic>.from(data) : {};
        final list = (map['data'] is List) ? map['data'] as List : const [];

        final items = <ChatMessage>[];
        for (final e in list) {
          if (e is! Map) continue;
          final m = Map<String, dynamic>.from(e);
          final senderType = (m['sender_type'] ?? '').toString();
          final isMine = senderType.contains('Teacher');

          // مرفق صوتي إن وُجد
          final attachPath = (m['attachment_path'] ?? '').toString();
          final attachType = (m['attachment_type'] ?? '').toString();
          final isAudio =
              attachType.contains('audio') ||
              attachPath.endsWith('.aac') ||
              attachPath.endsWith('.m4a') ||
              attachPath.endsWith('.mp3');
          final audioUrl = (attachPath.isNotEmpty && isAudio)
              ? _fullUrl(attachPath)
              : null;

          final sender = (m['sender'] is Map)
              ? Map<String, dynamic>.from(m['sender'])
              : {};
          final senderName = (sender['full_name'] ?? '').toString();

          items.add(
            ChatMessage(
              text: (m['body'] ?? '').toString(),
              time: _formatTime((m['created_at'] ?? '').toString()),
              isMine: isMine,
              audioUrl: audioUrl,
              messageId: int.tryParse('${m['id']}'),
              senderName: senderName,
              createdAt: (m['created_at'] ?? '').toString(),
            ),
          );
        }

        setState(() {
          _messages
            ..clear()
            ..addAll(items);
          _loadingMessages = false;
        });
        _scrollToBottom();
      },
      failure: (_) => setState(() => _loadingMessages = false),
    );
  }

  /// الاشتراك اللحظي بالمحادثة عبر Reverb
  Future<void> _initRealtime() async {
    // جلب توكن المعلّم من التخزين الآمن
    final token = await SecureStorage.getToken() ?? '';
    if (token.isEmpty) return;

    try {
      await ReverbService.instance.init(token);
      ReverbService.instance.subscribeToConversation(
        widget.chatId,
        _onRealtimeMessage,
      );
    } catch (e) {
      // في حال فشل الاتصال اللحظي، تبقى الرسائل تُحمّل عند فتح الشاشة
      // ignore: avoid_print
      print('🔴 Reverb init failed: ' + e.toString());
    }
  }

  /// استقبال رسالة جديدة لحظياً
  void _onRealtimeMessage(Map<String, dynamic> m) {
    if (!mounted) return;

    final senderType = (m['sender_type'] ?? '').toString();
    final isMine = senderType.contains('Teacher');
    if (isMine) return;

    final attachPath = (m['attachment_path'] ?? '').toString();
    final attachType = (m['attachment_type'] ?? '').toString();
    final isAudio =
        attachType.contains('audio') ||
        attachPath.endsWith('.aac') ||
        attachPath.endsWith('.m4a') ||
        attachPath.endsWith('.mp3');
    final audioUrl = (attachPath.isNotEmpty && isAudio)
        ? _fullUrl(attachPath)
        : null;

    final sender = (m['sender'] is Map)
        ? Map<String, dynamic>.from(m['sender'])
        : {};

    setState(() {
      _messages.add(
        ChatMessage(
          text: (m['body'] ?? '').toString(),
          time: _formatTime((m['created_at'] ?? '').toString()),
          isMine: isMine,
          audioUrl: audioUrl,
          messageId: int.tryParse('${m['id']}'),
          senderName: (sender['full_name'] ?? '').toString(),
          createdAt: (m['created_at'] ?? '').toString(),
        ),
      );
    });
    _scrollToBottom();
  }

  /// يبني رابطاً كاملاً للمرفق
  String _fullUrl(String path) {
    if (path.startsWith('http')) return path;
    // نفس أساس السيرفر — عدّلي الثابت ليطابق baseUrl في مشروعك
    const base = 'https://average-mutilator-untrained.ngrok-free.dev';
    final clean = path.startsWith('/') ? path : '/$path';
    // المرفقات عادة تحت storage
    if (clean.startsWith('/storage')) return '$base$clean';
    return '$base/storage$clean';
  }

  String _formatTime(String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    final local = dt.toLocal();
    final h = local.hour > 12
        ? local.hour - 12
        : (local.hour == 0 ? 12 : local.hour);
    final period = local.hour >= 12 ? 'م' : 'ص';
    return '$h:${local.minute.toString().padLeft(2, '0')}$period';
  }

  @override
  void dispose() {
    _messageController.removeListener(_onTextChanged);
    _messageController.dispose();
    _scrollController.dispose();
    _recorder.dispose();
    ReverbService.instance.unsubscribe(widget.chatId);
    super.dispose();
  }

  void _onTextChanged() {
    final has = _messageController.text.trim().isNotEmpty;
    if (has != _hasText) setState(() => _hasText = has);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();

    setState(() {
      _messages.add(
        ChatMessage(
          text: text,
          time: _formatTime(DateTime.now().toIso8601String()),
          isMine: true,
          createdAt: DateTime.now().toIso8601String(),
        ),
      );
    });
    _scrollToBottom();

    final result = await getIt<TeacherRepo>().sendMessage(widget.chatId, {
      'body': text,
    });

    result.when(
      success: (_) {},
      failure: (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'تعذّر إرسال الرسالة',
                style: TextStyle(fontSize: 18),
              ),
            ),
          );
        }
      },
    );
  }

  void _scrollToBottom() {
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

  Future<void> _startRecording() async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getTemporaryDirectory();
        final path =
            '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _recorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
          _recordPath = path;
        });
      } else {
        _showSnack('لا يوجد إذن للميكروفون');
      }
    } catch (e) {
      _showSnack('تعذّر بدء التسجيل');
    }
  }

  Future<void> _stopAndSendRecording() async {
    if (!_isRecording) return;
    try {
      final path = await _recorder.stop();
      setState(() => _isRecording = false);

      final finalPath = path ?? _recordPath;
      if (finalPath == null) return;
      final file = File(finalPath);
      if (!await file.exists()) return;

      // عرض فوري محلي
      setState(() {
        _messages.add(
          ChatMessage(
            text: '🎤 رسالة صوتية',
            time: _formatTime(DateTime.now().toIso8601String()),
            isMine: true,
            audioUrl: finalPath, 
            createdAt: DateTime.now().toIso8601String(),
          ),
        );
      });
      _scrollToBottom();

      // إرسال للباك
      final result = await getIt<TeacherRepo>().sendVoiceMessage(
        widget.chatId,
        file,
      );
      result.when(
        success: (_) {},
        failure: (_) => _showSnack('تعذّر إرسال الرسالة الصوتية'),
      );
    } catch (e) {
      setState(() => _isRecording = false);
      _showSnack('تعذّر إرسال التسجيل');
    }
  }

  Future<void> _cancelRecording() async {
    if (!_isRecording) return;
    await _recorder.stop();
    setState(() => _isRecording = false);
    if (_recordPath != null) {
      final f = File(_recordPath!);
      if (await f.exists()) await f.delete();
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg, style: const TextStyle(fontSize: 24))),
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
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              widget.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontFamily: "ArabicTypesetting",
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(
              Icons.subdirectory_arrow_left,
              color: Colors.white,
              size: 26,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    if (_loadingMessages) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.kPrimaryColor),
      );
    }
    if (_messages.isEmpty) {
      return Center(
        child: Text(
          'ابدأ المحادثة',
          style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 26),
        ),
      );
    }
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        // فاصل التاريخ يظهر قبل أول رسالة، أو عند تغيّر اليوم
        final showDate =
            index == 0 ||
            !_sameDay(_messages[index - 1].createdAt, msg.createdAt);

        return Column(
          children: [
            if (showDate) _buildDateChip(_dateLabel(msg.createdAt)),
            _buildBubble(msg),
          ],
        );
      },
    );
  }

  /// هل الرسالتان في نفس اليوم؟
  bool _sameDay(String isoA, String isoB) {
    final a = DateTime.tryParse(isoA)?.toLocal();
    final b = DateTime.tryParse(isoB)?.toLocal();
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// تسمية الفاصل: اليوم / أمس / التاريخ
  String _dateLabel(String iso) {
    final dt = DateTime.tryParse(iso)?.toLocal();
    if (dt == null) return '';
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final that = DateTime(dt.year, dt.month, dt.day);
    final diff = today.difference(that).inDays;

    if (diff == 0) return 'اليوم';
    if (diff == 1) return 'أمس';
    return '${dt.year}/${dt.month}/${dt.day}';
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
          style: const TextStyle(color: Colors.white70, fontSize: 20),
        ),
      ),
    );
  }

  Widget _buildBubble(ChatMessage msg) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(msg),
      child: _buildBubbleContent(msg),
    );
  }

  Widget _buildBubbleContent(ChatMessage msg) {
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
            if (msg.isVoice)
              VoiceMessagePlayer(audioUrl: msg.audioUrl!, color: Colors.white)
            else
              Text(
                msg.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 30,
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

  /// قائمة عند الضغط المطوّل على رسالة: حذف (للكل) + إبلاغ (لرسالة الطالب)
  void _showMessageOptions(ChatMessage msg) {
    if (msg.messageId == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.kBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) => Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 8),
              // حذف — متاح لرسالتي ورسالة الطالب
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: AppColors.kPrimaryColor,
                ),
                title: const Text(
                  'حذف الرسالة',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                onTap: () {
                  Navigator.pop(sheetCtx);
                  _deleteMessage(msg);
                },
              ),
              // إبلاغ — فقط لرسائل الطلاب (ليست رسالتي)
              if (!msg.isMine)
                ListTile(
                  leading: const Icon(
                    Icons.flag_outlined,
                    color: AppColors.kPrimaryColor,
                  ),
                  title: const Text(
                    'إبلاغ عن الرسالة',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  ),
                  onTap: () {
                    Navigator.pop(sheetCtx);
                    _openReport(msg);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _deleteMessage(ChatMessage msg) async {
    if (msg.messageId == null) return;

    // إزالة فورية محلياً
    setState(() => _messages.remove(msg));

    final result = await getIt<TeacherRepo>().deleteMessage(msg.messageId!);
    result.when(
      success: (_) {},
      failure: (_) {
        _showSnack('تعذّر حذف الرسالة');
        _loadMessages(); // إعادة التحميل لاستعادة الحالة
      },
    );
  }

  void _openReport(ChatMessage msg) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportMessageScreen(messageId: msg.messageId!),
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
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 25,
                  ),
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
            onTap: _hasText ? _sendMessage : null,
            onLongPressStart: _hasText ? null : (_) => _startRecording(),
            onLongPressEnd: _hasText ? null : (_) => _stopAndSendRecording(),
            onLongPressCancel: _hasText ? null : _cancelRecording,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: _isRecording ? Colors.red : AppColors.kPrimaryColor,
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
