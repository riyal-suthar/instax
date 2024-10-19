class FollowedUserInfoEntity {
  final String followedId;
  final String name;
  final String profileImageUrl;
  final String userName;

  FollowedUserInfoEntity(
      {this.followedId = "",
      this.name = "",
      this.profileImageUrl = "",
      this.userName = ""});
}
