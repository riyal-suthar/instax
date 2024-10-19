part of 'user_info_cubit.dart';

// @immutable
abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserLoading extends UserInfoState {}

// class ImageLoading extends UserInfoState {}

class AllUnFollowersUserLoading extends UserInfoState {}

// user info loaded
class UserLoaded extends UserInfoState {
  UserPersonalInfo userInfo;
  UserLoaded(this.userInfo);
}

// personal info loaded
class CubitMyPersonalInfoLoaded extends UserInfoState {
  UserPersonalInfo userPersonalInfo;
  CubitMyPersonalInfoLoaded(this.userPersonalInfo);
}

// class ImageLoaded extends UserInfoState {
//   String imageUrl;
//   ImageLoaded(this.imageUrl);
// }

// all users info loaded
class AllUnFollowersUserLoaded extends UserInfoState {
  List<UserPersonalInfo> usersInfo;
  AllUnFollowersUserLoaded(this.usersInfo);
}

class GetUserInfoFailed extends UserInfoState {
  final String error;

  GetUserInfoFailed(this.error);
}
