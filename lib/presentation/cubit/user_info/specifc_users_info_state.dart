part of 'specifc_users_info_cubit.dart';

abstract class SpecificUsersInfoState {}

class SpecifcUsersInfoInitial extends SpecificUsersInfoState {}

class FollowersAndFollowingsLoading extends SpecificUsersInfoState {}

class FollowersAndFollowingsLoaded extends SpecificUsersInfoState {
  FollowersAndFollowingsInfo followersAndFollowingsInfo;
  FollowersAndFollowingsLoaded(this.followersAndFollowingsInfo);
}

class SpecificUsersLoaded extends SpecificUsersInfoState {
  List<UserPersonalInfo> specificUsersInfo;
  SpecificUsersLoaded(this.specificUsersInfo);
}

class SpecificUsersFailed extends SpecificUsersInfoState {
  final String error;

  SpecificUsersFailed(this.error);
}

class GetChatUsersInfoLoading extends SpecificUsersInfoState {}

class GetChatUsersInfoLoaded extends SpecificUsersInfoState {
  List<SenderInfo> usersInfo;
  GetChatUsersInfoLoaded(this.usersInfo);
}
