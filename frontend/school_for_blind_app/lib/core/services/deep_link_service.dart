import 'package:app_links/app_links.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/auth_cubit.dart';
import 'package:school_for_blind_app/core/injection.dart';
import 'package:school_for_blind_app/core/routing/app_routes.dart';
import 'package:school_for_blind_app/main.dart';

class DeepLinkService {
  final _appLinks = AppLinks();

  void initDeepLinks() async {
    final initialUri = await _appLinks.getInitialLink();
    if (initialUri != null) {
      _handleUri(initialUri);
    }
    _appLinks.uriLinkStream.listen((Uri uri) {
      _handleUri(uri);
    });
  }

  void _handleUri(Uri uri) {
    if (uri.scheme == 'myapp') {
      if (uri.host == 'login' || uri.path.contains('login')) {
        getIt<AuthCubit>().emitMagicLink(uri);
        navigatorKey.currentState?.pushNamedAndRemoveUntil(
          AppRoutes.kStudentWaitingScreen,
          (route) => false,
        );
      }
    }
  }
}
