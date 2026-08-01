import 'dart:io';

class ServerTimeService {
  ServerTimeService._();
  static final ServerTimeService instance = ServerTimeService._();

  Duration _offset = Duration.zero;

  void updateFromHeader(String? dateHeader) {
    if (dateHeader == null) return;
    try {
      final serverTimeUtc = HttpDate.parse(dateHeader);
      _offset = serverTimeUtc.difference(DateTime.now().toUtc());
    } catch (_) {}
  }

  DateTime now() => DateTime.now().toUtc().add(_offset);
}
