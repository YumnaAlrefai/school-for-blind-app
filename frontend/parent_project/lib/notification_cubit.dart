import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:parent_project/notification_repository.dart';
import 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repo;
  NotificationCubit(this.repo) : super(NotificationInitial());

  Future<void> sendToken(String token) async {
    emit(NotificationTokenLoading());
    try {
      await repo.sendFcmToken(token);
      emit(NotificationTokenSuccess());
    } catch (e) {
      emit(NotificationTokenFailure(e.toString()));
    }
  }

  Future<void> deleteToken(String token) async {
    emit(NotificationTokenLoading());
    try {
      await repo.deleteFcmToken(token);
      emit(NotificationTokenSuccess());
    } catch (e) {
      emit(NotificationTokenFailure(e.toString()));
    }
  }

  Future<void> fetchNotifications() async {
    emit(NotificationListLoading());
    try {
      final res = await repo.getNotifications();
      emit(NotificationListLoaded(res.unreadCount, res.notifications));
    } catch (e) {
      emit(NotificationListFailure(e.toString()));
    }
  }
}
