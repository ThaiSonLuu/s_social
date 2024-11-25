import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:s_social/core/domain/repository/notification_repository.dart';

class UnreadNotificationsCubit extends Cubit<int> {
  final NotificationRepository _repository;

  UnreadNotificationsCubit(this._repository) : super(0);

  StreamSubscription<int>? _observer;

  void listenToUnreadCount() {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    }
    _observer = _repository.countUnreadNotifications().listen(
      (count) {
        emit(count); // Update the state with the latest unread count
      },
      onError: (error) {
        emit(0); // Handle errors gracefully by resetting the count to 0
      },
    );
  }

  void stopListenUnreadCount() {
    _observer?.cancel();
  }
}
