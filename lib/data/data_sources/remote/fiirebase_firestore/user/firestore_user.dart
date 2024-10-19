import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/notification/device_notification.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/push_notification.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/sender_receiver_info.dart';
import '../../../../../core/resources/strings_manager.dart';
import '../../../../models/child_classes/post/post.dart';
import 'package:get/get.dart';

abstract class FireStoreUser {
  Future<void> createUser(UserPersonalInfo newUserInfo);
  Future<UserPersonalInfo> getUserInfo(dynamic userId);
  Stream<UserPersonalInfo> getMyPersonalInfoInReelTime();

  Stream<List<UserPersonalInfo>> getAllUsers();
  Future<List<UserPersonalInfo>> getAllUnfollowersUsers(
      UserPersonalInfo myPersonalInfo);
  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {String fieldName = "",
      String userUid = "",
      required List<dynamic> usersIds});

  Stream<List<UserPersonalInfo>> searchAboutUser(
      {required String name, required bool searchForSingleLetter});
  Future<UserPersonalInfo?> getUserFromUserName({required String username});

  followThisUser(String followingUserId, String myPersonalId);
  unFollowThisUser(String followingUserId, String myPersonalId);

  Future<List> getSpecificUsersPosts(List<dynamic> usersIds);

  updateProfileImage({required String imageUrl, required String userId});
  updateUserInfo(UserPersonalInfo userInfo);

  Future<void> updateUserPosts(
      {required String userId, required Post postInfo});
  Future<void> updateUserStories(
      {required String userId, required String storyId});

  removeUserPost({required String postId});
  deleteThisStory({required String storyId});
  arrayRemoveOfField(
      {required String fieldName,
      required String removeThisId,
      required String userUid});

  Future<List<bool>> updateChannelId(
      {required List<UserPersonalInfo> callThoseUser,
      required String myPersonalId,
      required String channelId});

  Future<List<SenderInfo>> extractUsersChatInfo(
      {required List<SenderInfo> messagesDetails});
  Future<SenderInfo> extractUsersForSingleChatInfo(SenderInfo usersInfo);
  Future<SenderInfo> extractUsersForGroupChatInfo(SenderInfo usersInfo);

  Future<List<SenderInfo>> getMessagesOfChat({required String userId});
  Future<SenderInfo> getChatOfUser({required String chatUid});

  Future<void> updateChatsOfGroups({required Message messageInfo});

  Future<void> clearChannelsIds(
      {required List<dynamic> userIds, required String myPersonalId});

  Future<void> cancelJoiningToRoom(String userId);

  Future<void> sendNotification(
      {required String userId, required Message message});
}

class FireStoreUserImpl implements FireStoreUser {
  final _userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<void> createUser(UserPersonalInfo newUserInfo) async {
    await _userCollection.doc(newUserInfo.userId).set(newUserInfo.toMap());
  }

  @override
  Future<UserPersonalInfo> getUserInfo(userId) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _userCollection.doc(userId).get();
    if (snap.exists) {
      return UserPersonalInfo.fromDocSnap(snap.data());
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  /// For notifications in home app bar and video chat either wise, i get my info from [getUserInfo]
  @override
  Stream<UserPersonalInfo> getMyPersonalInfoInReelTime() {
    if (myPersonalId.isNotEmpty) {
      Stream<DocumentSnapshot<Map<String, dynamic>>> snapInfo =
          _userCollection.doc(myPersonalId).snapshots();

      return snapInfo.map((snap) {
        UserPersonalInfo user = UserPersonalInfo.fromDocSnap(snap.data());
        return user;
      });
    } else {
      return Stream.error("no personal id");
    }
  }

  @override
  Stream<List<UserPersonalInfo>> getAllUsers() {
    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        _userCollection.snapshots();

    return snapshots.map((snap) {
      List<UserPersonalInfo> usersInfo = [];
      for (final doc in snap.docs) {
        UserPersonalInfo userInfo = UserPersonalInfo.fromDocSnap(doc.data());
        if (userInfo.userId != myPersonalId) usersInfo.add(userInfo);
      }
      return usersInfo;
    });
  }

  @override
  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {String fieldName = "",
      String userUid = "",
      required List usersIds}) async {
    List<UserPersonalInfo> usersInfo = [];
    List<dynamic> ids = [];

    for (final userId in usersIds) {
      if (!ids.contains(userId)) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _userCollection.doc(userId).get();
        if (snap.exists) {
          UserPersonalInfo userReformat =
              UserPersonalInfo.fromDocSnap(snap.data());
          usersInfo.add(userReformat);
        } else {
          if (fieldName.isNotEmpty && userUid.isNotEmpty) {
            arrayRemoveOfField(
                fieldName: fieldName, removeThisId: userId, userUid: userUid);
          }
        }
        ids.add(userId);
      }
    }
    return usersInfo;
  }

  @override
  arrayRemoveOfField(
      {required String fieldName,
      required String removeThisId,
      required String userUid}) async {
    await _userCollection.doc(userUid).update({
      fieldName: FieldValue.arrayRemove([removeThisId])
    });
  }

  @override
  Future<List<UserPersonalInfo>> getAllUnfollowersUsers(
      UserPersonalInfo myPersonalInfo) async {
    QuerySnapshot<Map<String, dynamic>> snap = await _userCollection.get();
    List<UserPersonalInfo> usersInfo = [];

    for (final doc in snap.docs) {
      UserPersonalInfo userInfo = UserPersonalInfo.fromDocSnap(doc.data());
      bool isThatMe = userInfo.userId == myPersonalInfo.userId;
      bool isThatFollowedByMe =
          myPersonalInfo.followedPeople.contains(userInfo.userId);
      if (!isThatMe && !isThatFollowedByMe) {
        usersInfo.add(userInfo);
      }
    }
    return usersInfo;
  }

  @override
  Future<UserPersonalInfo?> getUserFromUserName(
      {required String username}) async {
    UserPersonalInfo? userInfo;
    await _userCollection
        .where("userName", isEqualTo: username)
        .get()
        .then((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot<Map<String, dynamic>> snap = snapshot.docs[0];
        userInfo = UserPersonalInfo.fromDocSnap(snap.data());
      }
    });
    return userInfo;
  }

  @override
  Stream<List<UserPersonalInfo>> searchAboutUser(
      {required String name, required bool searchForSingleLetter}) {
    name = name.toLowerCase();
    Stream<QuerySnapshot<Map<String, dynamic>>> snapSearch;

    if (searchForSingleLetter) {
      snapSearch =
          _userCollection.where("userName", isEqualTo: name).snapshots();
    } else {
      snapSearch = _userCollection
          .where("charactersOfName", arrayContains: name)
          .snapshots();
    }

    return snapSearch.map((event) => event.docs.map((e) {
          UserPersonalInfo userInfo = UserPersonalInfo.fromDocSnap(e.data());
          return userInfo;
        }).toList());
  }

  @override
  followThisUser(String followingUserId, String myPersonalId) async {
    await _userCollection.doc(followingUserId).update({
      "followers": FieldValue.arrayUnion([myPersonalId])
    });
    await _userCollection.doc(myPersonalId).update({
      "following": FieldValue.arrayUnion([followingUserId])
    });
  }

  @override
  unFollowThisUser(String followingUserId, String myPersonalId) async {
    await _userCollection.doc(followingUserId).update({
      "followers": FieldValue.arrayRemove([myPersonalId])
    });
    await _userCollection.doc(myPersonalId).update({
      "following": FieldValue.arrayRemove([followingUserId])
    });
  }

  @override
  updateProfileImage({required String imageUrl, required String userId}) async {
    await _userCollection.doc(userId).update({"profileImageUrl": imageUrl});
  }

  @override
  updateUserInfo(UserPersonalInfo userInfo) async {
    await _userCollection.doc(userInfo.userId).update(userInfo.toMap());
  }

  @override
  Future<List> getSpecificUsersPosts(List usersIds) async {
    List postsInfo = [];
    List<dynamic> usersIdsUnique = [];

    for (int i = 0; i < usersIds.length; i++) {
      if (!usersIdsUnique.contains(usersIds[i])) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _userCollection.doc(usersIds[i]).get();
        if (snap.exists) {
          postsInfo += snap.get("posts");
        }
        usersIdsUnique.add(usersIds[i]);
      }
    }
    return postsInfo;
  }

  @override
  Future<void> updateUserPosts(
      {required String userId, required Post postInfo}) async {
    await _userCollection.doc(userId).update({
      "posts": FieldValue.arrayUnion([postInfo.postUid])
    });
    return await _updateThreeLastPostUrl(userId, postInfo);
  }

  Future<void> _updateThreeLastPostUrl(String userId, Post postInfo) async {
    DocumentReference<Map<String, dynamic>> collection =
        _userCollection.doc(userId);
    Map<String, dynamic>? snap = (await collection.get()).data();
    List<dynamic> lastPosts = snap?["lastThreePostUrls"] ?? [];

    if (lastPosts.length >= 3) lastPosts = lastPosts.sublist(0, 3);
    bool isThatImage = postInfo.isThatImage;

    if (isThatImage) {
      lastPosts.add(postInfo.postUrl);
    } else {
      if (postInfo.coverOfVideoUrl.isEmpty) return;
      lastPosts.add(postInfo.coverOfVideoUrl);
    }
    return await collection
        .update({"lastThreePostUrls": FieldValue.arrayUnion(lastPosts)});
  }

  @override
  removeUserPost({required String postId}) async {
    QuerySnapshot<Map<String, dynamic>> snap =
        await _userCollection.where("posts", arrayContains: postId).get();
    for (var doc in snap.docs) {
      _userCollection.doc(doc.id).update({
        "posts": FieldValue.arrayRemove([postId])
      });
    }
  }

  @override
  Future<void> updateUserStories(
      {required String userId, required String storyId}) async {
    await _userCollection.doc(userId).update({
      "stories": FieldValue.arrayUnion([storyId])
    });
  }

  @override
  deleteThisStory({required String storyId}) async {
    await _userCollection.doc(myPersonalId).update({
      "stories": FieldValue.arrayRemove([storyId])
    });
  }

  @override
  Future<void> cancelJoiningToRoom(String userId) async {
    await _userCollection.doc(userId).update({"channelId": ""});
  }

  @override
  Future<List<bool>> updateChannelId(
      {required List<UserPersonalInfo> callThoseUser,
      required String myPersonalId,
      required String channelId}) async {
    await _userCollection.doc(myPersonalId).update({"channelId": channelId});
    List<bool> isUsersAvailable = [];

    for (final user in callThoseUser) {
      DocumentSnapshot<Map<String, dynamic>> collection =
          await _userCollection.doc(user.userId).get();
      UserPersonalInfo userInfo =
          UserPersonalInfo.fromDocSnap(collection.data());
      if (userInfo.channelId.isEmpty) {
        isUsersAvailable.add(true);
        await _userCollection.doc(user.userId).update({"channelId": channelId});
      } else {
        isUsersAvailable.add(false);
      }
    }
    return isUsersAvailable;
  }

  @override
  Future<void> clearChannelsIds(
      {required List<dynamic> userIds, required String myPersonalId}) async {
    await _userCollection.doc(myPersonalId).update({"channelId": ""});
    for (final userId in userIds) {
      await _userCollection.doc(userId).update({"channelId": ""});
    }
  }

  @override
  Future<List<SenderInfo>> extractUsersChatInfo(
      {required List<SenderInfo> messagesDetails}) async {
    for (int i = 0; i < messagesDetails.length; i++) {
      if (messagesDetails[i].lastMessage!.isThatGroup) {
        messagesDetails[i] =
            await extractUsersForGroupChatInfo(messagesDetails[i]);
      } else {
        messagesDetails[i] =
            await extractUsersForSingleChatInfo(messagesDetails[i]);
      }
    }
    return messagesDetails;
  }

  @override
  Future<SenderInfo> extractUsersForGroupChatInfo(SenderInfo usersInfo) async {
    if (usersInfo.lastMessage != null) {
      for (final receiverId in usersInfo.lastMessage!.receiversIds) {
        UserPersonalInfo userInfo = await getUserInfo(receiverId);
        if (usersInfo.receiversInfo == null) {
          usersInfo.receiversInfo = [userInfo];
          usersInfo.receiversIds = [userInfo.userId];
        } else {
          usersInfo.receiversInfo!.add(userInfo);
          usersInfo.receiversIds!.add(userInfo.userId);
        }
      }
      String userId = usersInfo.lastMessage!.senderId;
      UserPersonalInfo userInfo = await getUserInfo(userId);
      usersInfo.receiversInfo!.add(userInfo);
      usersInfo.receiversIds!.add(userInfo.userId);
    }
    return usersInfo;
  }

  @override
  Future<SenderInfo> extractUsersForSingleChatInfo(SenderInfo usersInfo) async {
    if (usersInfo.lastMessage != null) {
      String userId;
      if (usersInfo.lastMessage!.senderId != myPersonalId) {
        userId = usersInfo.lastMessage!.senderId;
      } else {
        userId = usersInfo.lastMessage!.receiversIds[0];
      }
      UserPersonalInfo userInfo = await getUserInfo(userId);
      usersInfo.receiversInfo = [userInfo];
      usersInfo.receiversIds = [userInfo.userId];
    }
    return usersInfo;
  }

  @override
  Future<SenderInfo> getChatOfUser({required String chatUid}) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _userCollection.doc(myPersonalId);
    userCollection.update({"numberOfNewMessages": 0});
    DocumentSnapshot<Map<String, dynamic>> doc =
        await userCollection.collection("chats").doc(chatUid).get();
    Message messageInfo = Message.fromJson(doc: doc);

    return SenderInfo(lastMessage: messageInfo);
  }

  @override
  Future<List<SenderInfo>> getMessagesOfChat({required String userId}) async {
    List<SenderInfo> allUsers = [];

    DocumentReference<Map<String, dynamic>> userCollection =
        _userCollection.doc(userId);
    userCollection.update({"numberOfNewMessages": 0});
    QuerySnapshot<Map<String, dynamic>> snap =
        await userCollection.collection("chats").get();

    for (final chatInfo in snap.docs) {
      QueryDocumentSnapshot<Map<String, dynamic>> query = chatInfo;
      Message messageInfo = Message.fromJson(query: query);
      allUsers.add(SenderInfo(lastMessage: messageInfo));
    }

    return allUsers;
  }

  @override
  Future<void> updateChatsOfGroups({required Message messageInfo}) async {
    for (final userId in messageInfo.receiversIds) {
      await _userCollection.doc(userId).update({
        "chatsOfGroup": FieldValue.arrayUnion([messageInfo.chatOfGroupId])
      });
      await sendNotification(userId: userId, message: messageInfo);
      await _userCollection.doc(messageInfo.senderId).update({
        "chatsOfGroups": FieldValue.arrayUnion([messageInfo.chatOfGroupId])
      });
    }
  }

  @override
  Future<void> sendNotification(
      {required String userId, required Message message}) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _userCollection.doc(userId);
    if (userId != myPersonalId) {
      userCollection.update({"numberOfNewMessages": FieldValue.increment(1)});
      UserPersonalInfo receiverInfo = await getUserInfo(userId);
      String token = receiverInfo.deviceToken;
      if (token.isNotEmpty) {
        String body = message.message.isNotEmpty
            ? message.message
            : (message.isThatImage
                ? "Send image"
                : (message.isThatPost
                    ? "Share with you a post"
                    : "Send message"));
        PushNotification detail = PushNotification(
          body: body,
          title: message.senderInfo?.name ?? "A user",
          deviceToken: token,
          routeParameterId:
              message.isThatGroup ? message.chatOfGroupId : message.senderId,
          notificationRoute: "message",
        );

        await DeviceNotification.sendPopupNotification(
            pushNotification: detail);
      }
    }
  }
}
