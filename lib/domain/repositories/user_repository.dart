import 'dart:io';
import 'dart:typed_data';

import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/sender_receiver_info.dart';
import 'package:instax/domain/entities/specific_user_info.dart';

import '../../data/models/child_classes/post/post.dart';
import '../../data/models/parent_classes/without_sub_classes/message.dart';

abstract class FireStoreUserRepository {
  Future<void> addNewUser(UserPersonalInfo newUserInfo);

  Future<UserPersonalInfo> getPersonalInfo(
      {required String userId, bool getDeviceToken = false});

  Stream<UserPersonalInfo> getMyPersonalInfo();

  Future<List<UserPersonalInfo>> getAllUnfollowersUsers(
      UserPersonalInfo myPersonalInfo);

  Stream<List<UserPersonalInfo>> getAllUsers();

  Future<UserPersonalInfo?> getUserFromUserName({required String userName});

  Stream<List<UserPersonalInfo>> searchAboutUser(
      {required String name, required bool searchForSingleLetter});

  Future<UserPersonalInfo> updateUserInfo({required UserPersonalInfo userInfo});

  Future<String> uploadProfileImage(
      {required Uint8List photo,
      required String userId,
      required String previousImageUrl});

  Future<FollowersAndFollowingsInfo> getFollowersAndFollowingsInfo(
      {required List<dynamic> followersIds,
      required List<dynamic> followingsIds});

  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {required List<dynamic> usersIds});

  Future<void> followThisUser(String followingUserId, String myPersonalId);

  Future<void> unFollowThisUser(String followingUserId, String myPersonalId);

  Future<UserPersonalInfo> updateUserPostsInfo(
      {required String userId, required Post postInfo});

  Future<Message> sendMessage(
      {required Message messageInfo, Uint8List? pathOfPhoto, File? recordFile});

  Stream<List<Message>> getMessages({required String receiverId});

  Future<void> deleteMessage(
      {required Message messageInfo,
      Message? replacedMessage,
      required bool isThatOnlyMessageInChat});

  Future<SenderInfo> getSpecificChatInfo(
      {required String chatUid, required bool isThatGroup});

  Future<List<SenderInfo>> getChatUserInfo(
      {required UserPersonalInfo myPersonalInfo});
}
