import 'package:dio/dio.dart';
import 'package:school_for_blind_app/core/services/server_time_service.dart';

class ServerTimeInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final dateHeader = response.headers.value('date');
    ServerTimeService.instance.updateFromHeader(dateHeader);
    handler.next(response);
  }
}
