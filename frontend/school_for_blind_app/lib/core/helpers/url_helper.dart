class UrlHelper {
  static const String _baseHost =
      'https://stays-ability-accustom.ngrok-free.dev';

  static String fixLocalhost(String url) {
    if (url.contains('localhost')) {
      return url.replaceFirst(RegExp(r'https?://localhost'), _baseHost);
    }
    return url;
  }
}
