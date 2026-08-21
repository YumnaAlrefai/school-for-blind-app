import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'announcement_socket_events.dart';

/// عميل اتصال واحد بسوكيت Reverb عبر WebSocket مباشر
/// (بدون مكتبة Pusher خارجية)، متوافق مع القنوات العامة (Public Channels).
class ReverbSocketClient {
  ReverbSocketClient._internal();
  static final ReverbSocketClient instance = ReverbSocketClient._internal();

  // ===== إعدادات الاتصال =====
  // ⚠️ عدّلي هذا الرابط في كل مرة يُعاد فيها تشغيل cloudflared (رابط مؤقت عشوائي)
  static const String _host = 'upc-burke-jul-meals.trycloudflare.com';
  static const String _appKey = 'as2zodfacn3jyrc4vdhw';
  static const bool _useTls = true; // Cloudflare دائمًا HTTPS/WSS

  WebSocketChannel? _channel;
  String? _socketId;
  Timer? _reconnectTimer;
  bool _manuallyDisconnected = false;

  final Set<String> _pendingOrSubscribed = {};
  final Map<String, void Function(Map<String, dynamic> data)> _handlers = {};

  bool get isConnected => _channel != null && _socketId != null;

  Future<void> connect() async {
    if (_channel != null) return;
    _manuallyDisconnected = false;

    final scheme = _useTls ? 'wss' : 'ws';
    final uri = Uri.parse(
      '$scheme://$_host/app/$_appKey?protocol=7&client=flutter&version=8.3.0',
    );

    try {
      _channel = WebSocketChannel.connect(uri);
      _channel!.stream.listen(
        _handleMessage,
        onDone: () {
          print('Reverb: الاتصال انقطع (onDone)');
          _handleDisconnect();
        },
        onError: (e) {
          print('Reverb: خطأ بالاتصال: $e');
          _handleDisconnect();
        },
      );
    } catch (e) {
      print('Reverb: فشل الاتصال: $e');
      _handleDisconnect();
    }
  }

  void _handleDisconnect() {
    _channel = null;
    _socketId = null;
    if (!_manuallyDisconnected) {
      _scheduleReconnect();
    }
  }

  void _scheduleReconnect() {
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 3), () {
      print('Reverb: محاولة إعادة الاتصال...');
      connect();
    });
  }

  void _handleMessage(dynamic raw) {
    print('📩 REVERB RAW: $raw');
    final Map<String, dynamic> msg = jsonDecode(raw as String);
    final event = msg['event'] as String?;

    if (event == 'pusher:connection_established') {
      final data = jsonDecode(msg['data'] as String);
      _socketId = data['socket_id'] as String;
      print('Reverb: متصل، socket_id=$_socketId');
      for (final channelName in _pendingOrSubscribed) {
        _sendSubscribe(channelName);
      }
      return;
    }

    if (event == 'pusher:ping') {
      _channel?.sink.add(jsonEncode({'event': 'pusher:pong', 'data': {}}));
      return;
    }

    if (event == 'pusher:error') {
      print('Reverb: pusher:error → ${msg['data']}');
      return;
    }

    final channelName = msg['channel'] as String?;
    if (channelName == null || event == null) return;

    if (event == AnnouncementSocketEvents.newAnnouncement &&
        _handlers.containsKey(channelName)) {
      final data = msg['data'];
      final decoded = data is String ? jsonDecode(data) : data;
      _handlers[channelName]!(decoded as Map<String, dynamic>);
    }
  }

  void _sendSubscribe(String channelName) {
    if (_channel == null || _socketId == null) return;
    _channel!.sink.add(
      jsonEncode({
        'event': 'pusher:subscribe',
        'data': {'channel': channelName},
      }),
    );
  }

  void subscribe(
    String channelName,
    void Function(Map<String, dynamic> data) onEvent,
  ) {
    _handlers[channelName] = onEvent;
    _pendingOrSubscribed.add(channelName);
    if (isConnected) {
      _sendSubscribe(channelName);
    }
  }

  void unsubscribe(String channelName) {
    _channel?.sink.add(
      jsonEncode({
        'event': 'pusher:unsubscribe',
        'data': {'channel': channelName},
      }),
    );
    _pendingOrSubscribed.remove(channelName);
    _handlers.remove(channelName);
  }

  void disconnect() {
    _manuallyDisconnected = true;
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _socketId = null;
  }
}