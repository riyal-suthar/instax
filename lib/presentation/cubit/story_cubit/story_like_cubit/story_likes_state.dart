part of 'story_likes_cubit.dart';

abstract class StoryLikesState extends Equatable {
  const StoryLikesState();
}

class StoryLikesInitial extends StoryLikesState {
  @override
  List<Object> get props => [];
}

class StoryLikesLoading extends StoryLikesState {
  @override
  List<Object?> get props => [];
}

class StoryLikesLoaded extends StoryLikesState {
  @override
  List<Object?> get props => [];
}

class StoryLikesFailed extends StoryLikesState {
  final String error;

  const StoryLikesFailed(this.error);

  @override
  List<Object?> get props => [error];
}
