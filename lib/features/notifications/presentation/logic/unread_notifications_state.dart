part of 'unread_notifications_cubit.dart';

abstract class UnreadNotificationsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UnreadNotificationsInitial extends UnreadNotificationsState {}

class UnreadNotificationsLoading extends UnreadNotificationsState {}

class UnreadNotificationsLoaded extends UnreadNotificationsState {
  final int count;

  UnreadNotificationsLoaded(this.count);

  @override
  List<Object?> get props => [count];
}

class UnreadNotificationsError extends UnreadNotificationsState {
  final String message;

  UnreadNotificationsError(this.message);

  @override
  List<Object?> get props => [message];
}
