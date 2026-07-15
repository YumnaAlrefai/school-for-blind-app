import 'package:school_for_blind_app/core/helpers/secure_storage.dart';

class UserKeyHelper {
  static const String _devFakeToken =
      '23|b8TPrk3IFD0uJLXxnBnsr1cTkrXfxvX69t7oazL9819966da';

  static Future<String> getCurrentUserKey() async {
    final token = await SecureStorage.getToken();
    final effectiveToken = token ?? _devFakeToken;
    return effectiveToken.hashCode.toString();
  }
}
