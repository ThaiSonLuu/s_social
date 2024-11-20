import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/repository/notification_repository.dart';

part 'unread_notifications_state.dart';

class UnreadNotificationsCubit extends Cubit<UnreadNotificationsState> {
  final NotificationRepository _repository;

  UnreadNotificationsCubit(this._repository)
      : super(UnreadNotificationsInitial());

  Future<void> fetchUnreadNotificationsCount(String uid) async {
    emit(UnreadNotificationsLoading());
    try {
      final count = await _repository.countUnreadNotifications();
      emit(UnreadNotificationsLoaded(count));
    } catch (e) {
      emit(UnreadNotificationsError(e.toString()));
    }
  }
}
