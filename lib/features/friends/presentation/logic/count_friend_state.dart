part of 'count_friend_cubit.dart';

abstract class CountFriendState extends Equatable {
  const CountFriendState();

  @override
  List<Object> get props => [];
}

class CountFriendInitial extends CountFriendState {}

class CountFriendLoading extends CountFriendState {}

class CountFriendLoaded extends CountFriendState {
  final int friendsCount;

  const CountFriendLoaded(this.friendsCount);

  @override
  List<Object> get props => [friendsCount];
}

class CountFriendError extends CountFriendState {
  final String error;

  const CountFriendError(this.error);

  @override
  List<Object> get props => [error];
}
