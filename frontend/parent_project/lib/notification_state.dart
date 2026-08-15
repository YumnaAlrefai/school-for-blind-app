import 'package:equatable/equatable.dart';
import 'package:parent_project/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationTokenLoading extends NotificationState {}

class NotificationTokenSuccess extends NotificationState {}

class NotificationTokenFailure extends NotificationState {
  final String message;
  const NotificationTokenFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class NotificationListLoading extends NotificationState {}

class NotificationListLoaded extends NotificationState {
  final int unreadCount;
  final List<NotificationModel> notifications;
  const NotificationListLoaded(this.unreadCount, this.notifications);
  @override
  List<Object?> get props => [unreadCount, notifications];
}

class NotificationListFailure extends NotificationState {
  final String message;
  const NotificationListFailure(this.message);
  @override
  List<Object?> get props => [message];
}
