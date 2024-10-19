part of 'post_likes_cubit.dart';

abstract class PostLikesState extends Equatable {
  const PostLikesState();
  @override
  List<Object?> get props => [];
}

class PostLikesInitial extends PostLikesState {
  @override
  List<Object> get props => [];
}

class PostLikesLoading extends PostLikesState {}

class PostLikesLoaded extends PostLikesState {}

class PostLikesFailed extends PostLikesState {
  final String error;

  const PostLikesFailed(this.error);
}
