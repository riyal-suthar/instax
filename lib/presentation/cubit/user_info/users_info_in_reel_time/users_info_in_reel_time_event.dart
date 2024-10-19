part of 'users_info_in_reel_time_bloc.dart';

abstract class UsersInfoInReelTimeEvent extends Equatable {
  const UsersInfoInReelTimeEvent();
  @override
  List<Object?> get props => [];
}

class LoadMyPersonalInfo extends UsersInfoInReelTimeEvent {}

class LoadAllUsersInfo extends UsersInfoInReelTimeEvent {}

class UpdateMyPersonalInfo extends UsersInfoInReelTimeEvent {
  final UserPersonalInfo myPersonalInfoInReelTime;

  const UpdateMyPersonalInfo(this.myPersonalInfoInReelTime);
  @override
  List<Object?> get props => [myPersonalInfoInReelTime];
}

class UpdateAllUsersInfo extends UsersInfoInReelTimeEvent {
  final List<UserPersonalInfo> allUsersInfoInReelTime;

  const UpdateAllUsersInfo(this.allUsersInfoInReelTime);

  @override
  List<Object?> get props => [allUsersInfoInReelTime];
}
