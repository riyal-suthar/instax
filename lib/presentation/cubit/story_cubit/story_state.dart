part of 'story_cubit.dart';

abstract class StoryState extends Equatable {
  const StoryState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class StoryInitial extends StoryState {
  @override
  List<Object> get props => [];
}

class StoryLoading extends StoryState {}

class StoryLoaded extends StoryState {
  final String postId;

  StoryLoaded(this.postId);
  @override
  // TODO: implement props
  List<Object?> get props => [postId];
}

class StoriesInfoLoaded extends StoryState {
  final List<UserPersonalInfo> storiesOwnersInfo;

  StoriesInfoLoaded(this.storiesOwnersInfo);
  @override
  // TODO: implement props
  List<Object?> get props => [storiesOwnersInfo];
}

class SpecificStoriesInfoLoaded extends StoryState {
  final UserPersonalInfo userInfo;

  SpecificStoriesInfoLoaded(this.userInfo);
  @override
  // TODO: implement props
  List<Object?> get props => [userInfo];
}

class DeletingStoryLoaded extends StoryState {}

class DeletingStoryLoading extends StoryState {}

class StoryFailed extends StoryState {
  final String error;

  StoryFailed(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
