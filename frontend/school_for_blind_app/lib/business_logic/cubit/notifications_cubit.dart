import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:school_for_blind_app/business_logic/cubit/student/result_state.dart';
import 'package:school_for_blind_app/data/models/notifications_response_model.dart';
import 'package:school_for_blind_app/data/repository/notification_repo.dart';
import 'package:school_for_blind_app/networking/api_result.dart';

class NotificationsCubit extends Cubit<ResultState<NotificationsResponse>> {
  final NotificationRepo notificationRepo;
  bool isMuted = false; // حالة زر كتم الإشعارات بالـ UI

  NotificationsCubit(this.notificationRepo) : super(const ResultState.idle());

  void emitGetNotifications() async {
    emit(const ResultState.loading());
    final response = await notificationRepo.getNotifications();
    response.when(
      success: (NotificationsResponse data) {
        emit(ResultState.success(data));
      },
      failure: (networkException) {
        emit(ResultState.failure(networkException));
      },
    );
  }

  void toggleMute() {
    isMuted = !isMuted;
    // بإمكانك هنا إرسال API مستقبلاً لكتم الإشعارات بالسيرفر
    emit(state); // لإعادة بناء الـ UI عند التغيير
  }
}
