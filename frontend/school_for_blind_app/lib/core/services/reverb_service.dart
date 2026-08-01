import 'package:pusher_client_socket/pusher_client_socket.dart';

/// خدمة الاتصال اللحظي بالمحادثات عبر Laravel Reverb.
/// تستخدم حزمة pusher_client_socket (تدعم host + private channels).
class ReverbService {
  ReverbService._();
  static final ReverbService instance = ReverbService._();

  PusherClient? _client;
  bool _initialized = false;

  // ===== إعدادات Reverb =====
  static const String _appKey = 'my-secret-key'; // REVERB_APP_KEY
  static const String _host = '192.168.1.103'; // IP الكمبيوتر (نفس الشبكة)
  static const int _wsPort = 8080; // REVERB_PORT
  static const bool _encrypted = false; // http (ليس wss)

  // مصادقة القنوات الخاصة (على الـ API عبر ngrok)
  static const String _authEndpoint =
      'https://average-mutilator-untrained.ngrok-free.dev/broadcasting/auth';

  /// تهيئة الاتصال مرة واحدة مع توكن المعلّم.
  Future<void> init(String token) async {
    if (_initialized) return;

    _client = PusherClient(
      options: PusherOptions(
        key: _appKey,
        host: _host,
        wsPort: _wsPort,
        encrypted: _encrypted,
      authOptions: PusherAuthOptions(
          _authEndpoint,
          headers: () async {
            return {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            };
          },
        ),
        enableLogging: true,
        autoConnect: false,
      ),
    );

    _client!.onConnectionEstablished((data) {
      // ignore: avoid_print
      print('🟢 Reverb connected - socketId: ${_client!.socketId}');
    });
    _client!.onConnectionError((error) {
      // ignore: avoid_print
      print('🔴 Reverb connection error: $error');
    });
    _client!.onError((error) {
      // ignore: avoid_print
      print('🔴 Reverb error: $error');
    });

    _client!.connect();
    _initialized = true;
  }

  /// الاشتراك بقناة محادثة واستقبال الرسائل الجديدة.
  void subscribeToConversation(
    int conversationId,
    void Function(Map<String, dynamic> data) onMessage,
  ) {
    if (_client == null) return;

    final channelName = 'private-conversation.$conversationId';
    final channel = _client!.private(channelName);

    // الحدث يصل كـ MessageSent (اسم الكلاس، لا يوجد broadcastAs)
    channel.bind('MessageSent', (data) {
      onMessage(_parseData(data));
    });
    // احتياطاً: الاسم الكامل مع namespace
    channel.bind('App\\Events\\MessageSent', (data) {
      onMessage(_parseData(data));
    });
  }

  Map<String, dynamic> _parseData(dynamic raw) {
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  void unsubscribe(int conversationId) {
    _client?.unsubscribe('private-conversation.$conversationId');
  }

  void disconnect() {
    _client?.disconnect();
    _initialized = false;
  }
}