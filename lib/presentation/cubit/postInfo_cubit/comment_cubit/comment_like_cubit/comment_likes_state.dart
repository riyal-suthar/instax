part of 'comment_likes_cubit.dart';

abstract class CommentLikesState extends Equatable {
  const CommentLikesState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommentLikesInitial extends CommentLikesState {
  @override
  List<Object> get props => [];
}

class CommentLikesLoading extends CommentLikesState {}

class CommentLikesLoaded extends CommentLikesState {}

class CommentLikesFailed extends CommentLikesState {
  final String error;

  CommentLikesFailed(this.error);
}
