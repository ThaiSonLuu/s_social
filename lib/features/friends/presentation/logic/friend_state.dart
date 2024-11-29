part of 'friend_cubit.dart';

abstract class GetFriendState extends Equatable {
  const GetFriendState();

  @override
  List<Object?> get props => [];
}

class FriendInitial extends GetFriendState {}

class FriendLoading extends GetFriendState {}

class FriendDoneAction extends GetFriendState {
  final FriendAction action;

  const FriendDoneAction(this.action);
}

enum FriendAction { sentRequest, accept }

class FriendLoaded extends GetFriendState {
  final FriendStatusModel friendStatus;

  const FriendLoaded(this.friendStatus);

  @override
  List<Object?> get props => [friendStatus];
}

class FriendError extends GetFriendState {
  final String message;

  const FriendError(this.message);

  @override
  List<Object?> get props => [message];
}
