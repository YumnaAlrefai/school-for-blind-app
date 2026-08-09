import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:school_for_blind_app/data/models/student/announcement_model.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:school_for_blind_app/data/models/student/message_model.dart';

class RealtimeService {
  static const String _host =
      'inflation-angle-texture-workshop.trycloudflare.com';
  static const int _port = 443;
  static const String _appKey = 'g43ja0cpjdcxspnfbnvd';
  static const String _authEndpoint =
      'https://stays-ability-accustom.ngrok-free.dev/broadcasting/auth';

  WebSocketChannel? _channel;
  String? _socketId;
  String? _authToken;

  final Set<String> _pendingOrSubscribed = {};
  final Map<String, void Function(MessageModel message)> _messageHandlers = {};
  final Map<String, void Function(int deletedMessageId)> _deleteHandlers = {};
  final Map<String, void Function(Announcement announcement)>
  _announcementHandlers = {};

  Future<void> init(String authToken) async {

    _authToken = authToken;
    if (_channel != null) return;

    final uri = Uri.parse(
      'wss://$_host:$_port/app/$_appKey?protocol=7&client=flutter&version=8.3.0',
    );
    _channel = WebSocketChannel.connect(uri);

    _channel!.stream.listen(
      _handleMessage,
      onDone: () {
        print('Reverb: الاتصال انقطع');
        _channel = null;
        _socketId = null;
      },
      onError: (e) => print('Reverb error: $e'),
    );
  }

  void _handleMessage(dynamic raw) async {
    final Map<String, dynamic> msg = jsonDecode(raw as String);
    final event = msg['event'] as String?;

    if (event == 'pusher:connection_established') {
      final data = jsonDecode(msg['data'] as String);
      _socketId = data['socket_id'] as String;
      print('Reverb: connected, socket_id=$_socketId');
      for (final channelName in _pendingOrSubscribed) {
        await _sendSubscribe(channelName);
      }
      return;
    }

    if (event == 'pusher:ping') {
      _channel?.sink.add(jsonEncode({'event': 'pusher:pong', 'data': {}}));
      return;
    }

    if (event == 'pusher:error') {
      print('Reverb error event: ${msg['data']}');
      return;
    }

    final channelName = msg['channel'] as String?;
    if (channelName == null) return;

    if (event == 'App\\Events\\MessageSent' &&
        _messageHandlers.containsKey(channelName)) {
      final data = msg['data'];
      final decoded = data is String ? jsonDecode(data) : data;
      _messageHandlers[channelName]!(
        MessageModel.fromJson(decoded as Map<String, dynamic>),
      );
    }

    if (event == 'App\\Events\\MessageDeleted' &&
        _deleteHandlers.containsKey(channelName)) {
      final data = msg['data'];
      final decoded = data is String ? jsonDecode(data) : data;
      final deletedId = decoded['deleted_message_id'];

      if (deletedId != null) {
        final parsedId = deletedId is int
            ? deletedId
            : int.parse(deletedId.toString());
        _deleteHandlers[channelName]!(parsedId);
      }
    }
    if (event == 'new-announcement' &&
        _announcementHandlers.containsKey(channelName)) {
      final data = msg['data'];
      final decoded = data is String ? jsonDecode(data) : data;
      _announcementHandlers[channelName]!(
        Announcement.fromJson(decoded as Map<String, dynamic>),
      );
    }
  }

  Future<void> _sendSubscribe(String channelName) async {
    if (_socketId == null || _channel == null) return;

    final bool isPrivateChannel =
        channelName.startsWith('private-') ||
        channelName.startsWith('presence-');

    String? auth;
    if (isPrivateChannel) {
      auth = await _authorize(channelName);
      if (auth == null) return;
    }

    _channel!.sink.add(
      jsonEncode({
        'event': 'pusher:subscribe',
        'data': {'channel': channelName, if (auth != null) 'auth': auth},
      }),
    );
  }

  Future<String?> _authorize(String channelName) async {
    try {
      final response = await http.post(
        Uri.parse(_authEndpoint),
        headers: {
          'Authorization': 'Bearer $_authToken',
          'Accept': 'application/json',
        },
        body: {'socket_id': _socketId, 'channel_name': channelName},
      );
      if (response.statusCode != 200) {
        print('Auth failed: ${response.statusCode} ${response.body}');
        return null;
      }
      final data = jsonDecode(response.body);
      return data['auth'] as String;
    } catch (e) {
      print('Auth error: $e');
      return null;
    }
  }

  Future<void> subscribeToConversation(
    int channelId, {
    required void Function(MessageModel message) onMessageReceived,
    required void Function(int deletedMessageId) onMessageDeleted,
  }) async {
    final channelName = 'private-conversation.$channelId';
    _messageHandlers[channelName] = onMessageReceived;
    _deleteHandlers[channelName] = onMessageDeleted;
    _pendingOrSubscribed.add(channelName);
    if (_socketId != null) {
      await _sendSubscribe(channelName);
    }
  }

  Future<void> unsubscribeFromConversation(int channelId) async {
    final channelName = 'private-conversation.$channelId';
    _channel?.sink.add(
      jsonEncode({
        'event': 'pusher:unsubscribe',
        'data': {'channel': channelName},
      }),
    );
    _pendingOrSubscribed.remove(channelName);
    _messageHandlers.remove(channelName);
    _deleteHandlers.remove(channelName);
  }

  Future<void> subscribeToAnnouncementChannel(
    String channelName, {
    required void Function(Announcement announcement) onAnnouncementReceived,
  }) async {
    _announcementHandlers[channelName] = onAnnouncementReceived;
    _pendingOrSubscribed.add(channelName);
    if (_socketId != null) {
      await _sendSubscribe(channelName);
    }
  }

  Future<void> subscribeToAnnouncements({
    required String targetAudience,
    required String level,
    required void Function(Announcement announcement) onAnnouncementReceived,
  }) async {
    await subscribeToAnnouncementChannel(
      'announcements.$targetAudience.$level',
      onAnnouncementReceived: onAnnouncementReceived,
    );
    if (level != 'all') {
      await subscribeToAnnouncementChannel(
        'announcements.$targetAudience.all',
        onAnnouncementReceived: onAnnouncementReceived,
      );
    }
  }

  Future<void> unsubscribeFromAnnouncements({
    required String targetAudience,
    required String level,
  }) async {
    for (final l in {level, 'all'}) {
      final channelName = 'announcements.$targetAudience.$l';
      _channel?.sink.add(
        jsonEncode({
          'event': 'pusher:unsubscribe',
          'data': {'channel': channelName},
        }),
      );
      _pendingOrSubscribed.remove(channelName);
      _announcementHandlers.remove(channelName);
    }
  }
}
