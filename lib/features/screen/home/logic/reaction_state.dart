part of 'reaction_cubit.dart';

abstract class ReactionState extends Equatable {
  const ReactionState();

  @override
  List<Object> get props => [];
}

class ReactionInitial extends ReactionState {}

class ReactionLoading extends ReactionState {}

class ReactionLoaded extends ReactionState {
  final List<ReactionModel> reactions;

  const ReactionLoaded(this.reactions);

  @override
  List<Object> get props => [reactions];
}

class ReactionError extends ReactionState {
  final String message;

  const ReactionError(this.message);

  @override
  List<Object> get props => [message];
}
