part of 'users_info_in_reel_time_bloc.dart';

abstract class UsersInfoInReelTimeState extends Equatable {
  const UsersInfoInReelTimeState();
  @override
  List<Object?> get props => [];
}

class UsersInfoInReelTimeInitial extends UsersInfoInReelTimeState {
  @override
  List<Object> get props => [];
}

class MyPersonalInfoLoaded extends UsersInfoInReelTimeState {
  final UserPersonalInfo myPersonalInfoInReelTime;

  const MyPersonalInfoLoaded({required this.myPersonalInfoInReelTime});
  @override
  List<Object?> get props => [myPersonalInfoInReelTime];
}

class AllUsersInfoLoaded extends UsersInfoInReelTimeState {
  final List<UserPersonalInfo> allUsersInfoInReelTime;

  const AllUsersInfoLoaded({required this.allUsersInfoInReelTime});
  @override
  List<Object?> get props => [allUsersInfoInReelTime];
}

class MyPersonalInfoFailed extends UsersInfoInReelTimeState {
  final String error;

  const MyPersonalInfoFailed(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
