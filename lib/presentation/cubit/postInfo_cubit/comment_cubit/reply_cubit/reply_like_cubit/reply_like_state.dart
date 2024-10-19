part of 'reply_like_cubit.dart';

abstract class ReplyLikeState extends Equatable {
  const ReplyLikeState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ReplyLikeInitial extends ReplyLikeState {
  @override
  List<Object> get props => [];
}

class ReplyLikeLoading extends ReplyLikeState {}

class ReplyLikeLoaded extends ReplyLikeState {}

class ReplyLikeFailed extends ReplyLikeState {
  final String error;

  ReplyLikeFailed(this.error);
}
