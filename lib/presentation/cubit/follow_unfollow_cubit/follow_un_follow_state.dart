part of 'follow_un_follow_cubit.dart';

abstract class FollowUnFollowState extends Equatable {
  const FollowUnFollowState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FollowUnFollowInitial extends FollowUnFollowState {
  @override
  List<Object> get props => [];
}

class FollowThisUserLoading extends FollowUnFollowState {}

class FollowThisUserLoaded extends FollowUnFollowState {}

class FollowThisUserFailed extends FollowUnFollowState {
  final String error;
  FollowThisUserFailed(this.error);
}
