import 'package:equatable/equatable.dart';

import '../../child_classes/post/story.dart';

// ignore: must_be_immutable
class UserPersonalInfo extends Equatable {
  dynamic userId;
  String name;
  String userName;
  String email;
  String bio;
  List<dynamic>? bioLinks;
  String profileImageUrl;
  List<dynamic> followedPeople;
  List<dynamic> followerPeople;
  List<dynamic> posts;
  List<dynamic> chatsOfGroups;
  String deviceToken;
  List<dynamic> stories;
  List<Story>? storiesInfo;
  List<dynamic> charactersOfName;
  int numberOfNewNotifications;
  int numberOfNewMessages;
  String channelId;
  List<dynamic> lastThreePostUrls;

  UserPersonalInfo({
    required this.followedPeople,
    required this.followerPeople,
    required this.posts,
    required this.chatsOfGroups,
    required this.stories,
    required this.charactersOfName,
    required this.lastThreePostUrls,
    this.bioLinks,
    this.storiesInfo,
    this.userId,
    this.name = "",
    this.userName = "",
    this.bio = "",
    this.email = "",
    this.profileImageUrl = "",
    this.channelId = "",
    this.deviceToken = "",
    this.numberOfNewNotifications = 0,
    this.numberOfNewMessages = 0,
  });

  static UserPersonalInfo fromDocSnap(Map<String, dynamic>? snap) {
    return UserPersonalInfo(
      followedPeople: snap?["following"] ?? [],
      followerPeople: snap?["followers"] ?? [],
      posts: snap?["posts"] ?? [],
      chatsOfGroups: snap?["chatsOfGroups"] ?? [],
      stories: snap?["stories"] ?? [],
      charactersOfName: snap?["charactersOfName"] ?? [],
      lastThreePostUrls: snap?["lastThreePostUrls"] ?? [],
      // storiesInfo: snap?["storiesInfo"] ?? [],
      userId: snap?["uid"] ?? "",
      name: snap?["name"] ?? "",
      userName: snap?["userName"] ?? "",
      bio: snap?["bio"] ?? "",
      bioLinks: snap?["bioLinks"] ?? [],
      email: snap?["email"] ?? "",
      profileImageUrl: snap?["profileImageUrl"] ?? "",
      channelId: snap?["channelId"] ?? "",
      deviceToken: snap?["deviceToken"] ?? "",
      numberOfNewMessages: snap?["numberOfNewMessages"] ?? 0,
      numberOfNewNotifications: snap?["numberOfNewNotifications"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "following": followerPeople,
        "followers": followerPeople,
        "posts": posts,
        "chartsOfGroups": chatsOfGroups,
        "stories": stories,
        "charactersOfName": charactersOfName,
        "lastThreePostUrls": lastThreePostUrls,
        // "storiesInfo": storiesInfo,
        "uid": userId,
        "name": name,
        "userName": userName,
        "bio": bio,
        "bioLinks": bioLinks,
        "email": email,
        "profileImageUrl": profileImageUrl,
        "channelId": channelId,
        "deviceToken": deviceToken,
        "numberOfNewMessages": numberOfNewMessages,
        "numberOfNewNotifications": numberOfNewNotifications,
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        userId,
        name,
        userName,
        email,
        bio,
        bioLinks,
        profileImageUrl,
        followedPeople,
        followerPeople,
        posts,
        stories,
        storiesInfo,
        chatsOfGroups,
        charactersOfName,
        numberOfNewNotifications,
        numberOfNewMessages,
        deviceToken,
        channelId,
        lastThreePostUrls,
      ];
}
