import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/messages_cubit.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/core/helpers/secure_storage.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/services/realtime_service.dart';
import 'package:school_for_blind_app/data/models/student/message_model.dart';
import 'package:school_for_blind_app/presentation/widgets/student/audio_player_controls.dart';
import 'package:school_for_blind_app/presentation/widgets/student/custom_app_bar.dart';
import 'package:school_for_blind_app/presentation/widgets/student/message_bubble.dart';
import 'package:school_for_blind_app/presentation/widgets/student/message_input.dart';
import 'package:school_for_blind_app/presentation/widgets/student/voice_recording_bar.dart';

class StudentMessagesScreen extends StatefulWidget {
  final int channelId;
  final String channelName;
  final int currentUserId;
  final IconData icon;
  final bool isChannel;

  const StudentMessagesScreen({
    super.key,
    required this.channelId,
    required this.channelName,
    required this.currentUserId,
    required this.icon,
    required this.isChannel,
  });

  @override
  State<StudentMessagesScreen> createState() => _StudentMessagesScreenState();
}

class _StudentMessagesScreenState extends State<StudentMessagesScreen> {
  final TextEditingController _messageController = TextEditingController();
  File? _selectedAttachment;
  String? _attachmentType;

  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isPaused = false;
  Duration _recordDuration = Duration.zero;
  DateTime? _recordStartTime;
  Duration _pausedElapsed = Duration.zero;

  late final VoicePlayerManager _voiceManager;

  bool? _isBanned;

  @override
  void initState() {
    super.initState();

    context.read<MessagesCubit>().getChannelMessages(
      widget.channelId,
      currentUserId: widget.currentUserId,
    );
    _initRealtimeService();
    _messageController.addListener(() => setState(() {}));

    _voiceManager = VoicePlayerManager(
      onChange: () {
        if (mounted) setState(() {});
      },
    );
    _voiceManager.init();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _recorder.dispose();
    _voiceManager.dispose();
    super.dispose();
  }

  Future<void> _initRealtimeService() async {
    String? token = await SecureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      getIt<RealtimeService>().init(token);
    } else {
      debugPrint(' لم يتم العثور على توكن لتشغيل ال RealtimeService');
    }
  }

  Future<void> _refreshMessages() async {
    context.read<MessagesCubit>().getChannelMessages(widget.channelId);
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: CustomAppBar(helpMessage: ''),
      body: Column(
        children: [
          ListTile(
            leading: Icon(
              widget.icon,
              color: colorScheme.onSurface,
              size: 32.sp,
            ),
            title: Text(
              widget.channelName,
              style: TextStyle(color: colorScheme.onSurface, fontSize: 30.sp),
            ),
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshMessages,
              color: colorScheme.primary,
              child: BlocConsumer<MessagesCubit, ResultState<MessagesResponse>>(
                listener: (context, state) {
                  state.whenOrNull(
                    success: (messagesResponse) {
                      if (_isBanned != messagesResponse.isBanned) {
                        setState(() {
                          _isBanned = messagesResponse.isBanned;
                        });
                      }
                    },
                  );
                },
                builder: (context, state) {
                  return state.when(
                    idle: () => const SizedBox.shrink(),
                    loading: () => Center(
                      child: CircularProgressIndicator(
                        color: colorScheme.primary,
                      ),
                    ),
                    failure: (_) => Center(
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surface,
                        ),
                        onPressed: _refreshMessages,
                        icon: Icon(
                          Icons.refresh,
                          size: 38.sp,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    success: (messagesResponse) {
                      final messages = messagesResponse.data.reversed.toList();

                      return ListView.builder(
                        reverse: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 10.h,
                        ),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message.senderId == widget.currentUserId;

                          return buildMessageBubble(
                            message: message,
                            isMe: isMe,
                            context: context,
                            player: _voiceManager.player,
                            currentlyPlayingUrl: _voiceManager.currentUrl,
                            playbackPosition: _voiceManager.position,
                            playbackDuration: _voiceManager.duration,
                            togglePlay: (url) => _voiceManager.toggle(url),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),

          if (widget.isChannel)
            _buildReadOnlyBanner(colorScheme)
          else if (_isBanned == true)
            _buildBannedBanner(colorScheme)
          else if (_isBanned == false)
            _buildInputSection(colorScheme)
          else
            const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildReadOnlyBanner(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lock_outline_rounded,
              color: colorScheme.onSurface,
              size: 24.sp,
            ),
            SizedBox(width: 8.w),
            Text(
              'يمكن للمدرس فقط إرسال الرسائل',
              style: TextStyle(color: colorScheme.onSurface, fontSize: 35.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBannedBanner(ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block_rounded, color: Color(0xffff3333), size: 24.sp),
            SizedBox(width: 8.w),
            Text(
              'تم حظرك من إرسال الرسائل في هذه المجموعة',
              style: TextStyle(color: colorScheme.onSurface, fontSize: 32.sp),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(ColorScheme colorScheme) {
    if (_isRecording) {
      return buildRecordingBar(
        recordDuration: _recordDuration,
        isPaused: _isPaused,
        deleteRecording: () {
          stopRecording(
            recorder: _recorder,
            cancel: true,
            onAttachment: (_, __) {},
            onStop: () => setState(() => _isRecording = false),
          );
        },
        togglePauseResume: () {
          togglePauseResume(
            recorder: _recorder,
            isPaused: _isPaused,
            recordDuration: _recordDuration,
            onStateChange: (paused, start, pausedElapsed) {
              setState(() {
                _isPaused = paused;
                _recordStartTime = start;
                _pausedElapsed = pausedElapsed;
              });
            },
          );
        },
        confirmRecording: () {
          stopRecording(
            recorder: _recorder,
            cancel: false,
            onAttachment: (file, type) {
              setState(() {
                _selectedAttachment = file;
                _attachmentType = type;
                _isRecording = false;
              });
            },
            onStop: () => setState(() => _isRecording = false),
          );
        },
        context: context,
      );
    }

    return Column(
      children: [
        if (_selectedAttachment != null)
          buildAttachmentPreview(
            file: _selectedAttachment!,
            type: _attachmentType!,
            remove: () {
              setState(() {
                _selectedAttachment = null;
                _attachmentType = null;
              });
            },
            context: context,
          ),
        buildMessageInputField(
          controller: _messageController,
          selectedAttachment: _selectedAttachment,
          attachmentType: _attachmentType,
          sendMessage: _sendMessage,
          startRecording: _startRecording,
          showAttachmentOptions: () => showAttachmentOptions(
            context: context,
            pickImage: _pickImage,
            pickAudio: _pickAudioFile,
          ),
          context: context,
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty && _selectedAttachment == null) return;

    context.read<MessagesCubit>().sendMessage(
      text,
      attachment: _selectedAttachment,
      attachmentType: _attachmentType,
    );

    _messageController.clear();
    setState(() {
      _selectedAttachment = null;
      _attachmentType = null;
    });
  }

  Future<void> _startRecording() async {
    startRecording(
      recorder: _recorder,
      onStateChange: (rec, paused, dur, start, pausedElapsed) {
        setState(() {
          _isRecording = rec;
          _isPaused = paused;
          _recordDuration = dur;
          _recordStartTime = start;
          _pausedElapsed = pausedElapsed;
        });
      },
      tick: (dur) => setState(() => _recordDuration = dur),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    pickImageAttachment(
      source: source,
      onPick: (file, type) {
        setState(() {
          _selectedAttachment = file;
          _attachmentType = type;
        });
      },
    );
  }

  Future<void> _pickAudioFile() async {
    pickAudioAttachment(
      onPick: (file, type) {
        setState(() {
          _selectedAttachment = file;
          _attachmentType = type;
        });
      },
    );
  }
}
