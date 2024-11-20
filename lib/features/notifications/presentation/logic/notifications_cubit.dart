import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/model/notification_model.dart';
import 'package:s_social/core/domain/repository/notification_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationRepository _repository;

  NotificationsCubit(this._repository) : super(NotificationsInitial());

  Future<void> getNotifications() async {
    emit(NotificationsLoading());
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final notifications = await _repository.getNotifications();
      emit(NotificationsLoaded(notifications));
    } catch (e) {
      emit(NotificationsError("No notifications available"));
    }
  }

  Future<void> markNotificationsAsRead() async {
    try {
      await _repository.markAllNotificationsAsRead();
      await _loadNotifications();
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }

  Future<void> markNotificationAsRead(String id) async {
    try {
      await _repository.markNotificationAsRead(id);
      await _loadNotifications();
    } catch (e) {
      emit(NotificationsError(e.toString()));
    }
  }
}
