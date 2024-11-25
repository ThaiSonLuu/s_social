part of 'friend_cubit.dart';

abstract class FriendState extends Equatable {
  const FriendState();

  @override
  List<Object> get props => [];
}

class FriendInitial extends FriendState {}

class FriendLoading extends FriendState {}

class FriendRequestSent extends FriendState {}

class FriendRequestStatusChanged extends FriendState {}

class FriendRequestsLoaded extends FriendState {
  final List<FriendModel> pendingRequests;

  const FriendRequestsLoaded(this.pendingRequests);

  @override
  List<Object> get props => [pendingRequests];
}

class FriendError extends FriendState {
  final String error;

  const FriendError(this.error);

  @override
  List<Object> get props => [error];
}
