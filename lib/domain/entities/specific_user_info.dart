import '../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class FollowersAndFollowingsInfo {
  final List<UserPersonalInfo> followingsInfo;
  final List<UserPersonalInfo> followersInfo;

  FollowersAndFollowingsInfo({
    required this.followingsInfo,
    required this.followersInfo,
  });
}
