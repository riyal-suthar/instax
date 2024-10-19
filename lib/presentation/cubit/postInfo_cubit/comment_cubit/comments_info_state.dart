part of 'comments_info_cubit.dart';

abstract class CommentsInfoState extends Equatable {
  const CommentsInfoState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CommentsInfoInitial extends CommentsInfoState {
  @override
  List<Object> get props => [];
}

class CommentsInfoLoading extends CommentsInfoState {}

class CommentsInfoLoaded extends CommentsInfoState {
  final List<Comment> commentsOfPost;

  CommentsInfoLoaded(this.commentsOfPost);
}

class CommentsInfoFailed extends CommentsInfoState {
  final String error;

  CommentsInfoFailed(this.error);
}
