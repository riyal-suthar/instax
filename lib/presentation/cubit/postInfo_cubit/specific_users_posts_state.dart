part of 'specific_users_posts_cubit.dart';

abstract class SpecificUsersPostsState extends Equatable {
  const SpecificUsersPostsState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SpecificUsersPostsInitial extends SpecificUsersPostsState {
  @override
  List<Object> get props => [];
}

class SpecificUsersPostsLoading extends SpecificUsersPostsState {}

class SpecificUsersPostsLoaded extends SpecificUsersPostsState {
  final List allSpecificPostInfo;

  SpecificUsersPostsLoaded(this.allSpecificPostInfo);
}

class SpecificUsersPostsFailed extends SpecificUsersPostsState {
  final String error;

  SpecificUsersPostsFailed(this.error);
}
