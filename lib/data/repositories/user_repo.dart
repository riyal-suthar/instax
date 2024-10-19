import 'dart:io';
import 'dart:typed_data';

import 'package:instax/data/data_sources/remote/fiirebase_firestore/user/firestore_user.dart';
import 'package:instax/data/models/child_classes/post/post.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/sender_receiver_info.dart';
import 'package:instax/domain/entities/specific_user_info.dart';
import 'package:instax/domain/repositories/user_repository.dart';

import '../../core/utils/constants.dart';
import '../data_sources/remote/fiirebase_firestore/chat/group_chat.dart';
import '../data_sources/remote/fiirebase_firestore/chat/single_chat.dart';
import '../data_sources/remote/fiirebase_firestore/firebase_storage.dart';
import '../data_sources/remote/fiirebase_firestore/notification/firebase_notification.dart';

class FirebaseUserRepoImpl implements FireStoreUserRepository {
  final FireStoreUser _fireStoreUser;
  final FireStoreNotification _fireStoreNotification;
  final FirebaseStoragePost _firebaseStoragePost;

  final FireStoreSingleChat _singleChat;
  final FireStoreGroupChat _groupChat;

  FirebaseUserRepoImpl(
    this._fireStoreUser,
    this._fireStoreNotification,
    this._firebaseStoragePost,
    this._singleChat,
    this._groupChat,
  );

  @override
  Future<void> addNewUser(UserPersonalInfo newUserInfo) async {
    try {
      await _fireStoreUser.createUser(newUserInfo);
      await _fireStoreNotification.createNewDeviceToken(
          userId: newUserInfo.userId, myPersonalInfo: newUserInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getPersonalInfo(
      {required String userId, bool getDeviceToken = false}) async {
    try {
      UserPersonalInfo myPersonalInfo =
          await _fireStoreUser.getUserInfo(userId);

      if (isThatMobile && getDeviceToken) {
        UserPersonalInfo userInfo =
            await _fireStoreNotification.createNewDeviceToken(
                userId: userId, myPersonalInfo: myPersonalInfo);
        myPersonalInfo = userInfo;
      }
      return myPersonalInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> updateUserInfo(
      {required UserPersonalInfo userInfo}) async {
    try {
      await _fireStoreUser.updateUserInfo(userInfo);
      return getPersonalInfo(userId: userInfo.userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<String> uploadProfileImage(
      {required Uint8List photo,
      required String userId,
      required String previousImageUrl}) async {
    try {
      String imageUrl = await _firebaseStoragePost.uploadData(
          folderName: 'personalImage', data: photo);
      await _fireStoreUser.updateProfileImage(
          imageUrl: imageUrl, userId: userId);
      await _firebaseStoragePost.deleteImageFromStorage(previousImageUrl);

      return imageUrl;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> updateUserPostsInfo(
      {required String userId, required Post postInfo}) async {
    try {
      await _fireStoreUser.updateUserPosts(userId: userId, postInfo: postInfo);
      return await getPersonalInfo(userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  ///  if user not exits, it will be removed
  @override
  Future<List<UserPersonalInfo>> getSpecificUsersInfo(
      {required List usersIds}) async {
    try {
      return await _fireStoreUser.getSpecificUsersInfo(usersIds: usersIds);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<FollowersAndFollowingsInfo> getFollowersAndFollowingsInfo(
      {required List followersIds, required List followingsIds}) async {
    try {
      List<UserPersonalInfo> followersInfo =
          await _fireStoreUser.getSpecificUsersInfo(
              usersIds: followersIds,
              fieldName: "followers",
              userUid: myPersonalId);
      List<UserPersonalInfo> followingsInfo =
          await _fireStoreUser.getSpecificUsersInfo(
              usersIds: followingsIds,
              fieldName: "following",
              userUid: myPersonalId);

      return FollowersAndFollowingsInfo(
          followingsInfo: followingsInfo, followersInfo: followersInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> followThisUser(
      String followingUserId, String myPersonalId) async {
    try {
      await _fireStoreUser.followThisUser(followingUserId, myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> unFollowThisUser(
      String followingUserId, String myPersonalId) async {
    try {
      await _fireStoreUser.unFollowThisUser(followingUserId, myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UserPersonalInfo>> getAllUnfollowersUsers(
      UserPersonalInfo myPersonalInfo) {
    try {
      return _fireStoreUser.getAllUnfollowersUsers(myPersonalInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<UserPersonalInfo>> getAllUsers() => _fireStoreUser.getAllUsers();

  @override
  Stream<UserPersonalInfo> getMyPersonalInfo() =>
      _fireStoreUser.getMyPersonalInfoInReelTime();

  @override
  Future<UserPersonalInfo?> getUserFromUserName(
      {required String userName}) async {
    try {
      return await _fireStoreUser.getUserFromUserName(username: userName);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<UserPersonalInfo>> searchAboutUser(
          {required String name, required bool searchForSingleLetter}) =>
      _fireStoreUser.searchAboutUser(
          name: name, searchForSingleLetter: searchForSingleLetter);

  /// single(one-to-one)chat operations

  @override
  Future<Message> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      File? recordFile}) async {
    try {
      if (pathOfPhoto != null) {
        String imageUrl = await _firebaseStoragePost.uploadData(
            folderName: "messagesFiles", data: pathOfPhoto);
        messageInfo.imageUrl = imageUrl;
      }
      if (recordFile != null) {
        String recordedUrl = await _firebaseStoragePost.uploadFile(
            folderName: "messagesFiles", postFile: recordFile);
        messageInfo.recordedUrl = recordedUrl;
      }

      Message message = await _singleChat.sendMessage(
          message: messageInfo,
          chatId: messageInfo.receiversIds[0],
          userId: messageInfo.senderId);

      await _singleChat.sendMessage(
          message: messageInfo,
          chatId: messageInfo.senderId,
          userId: messageInfo.receiversIds[0]);

      await _fireStoreUser.sendNotification(
          userId: messageInfo.receiversIds[0], message: messageInfo);

      return message;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Message>> getMessages({required String receiverId}) =>
      _singleChat.getMessages(receiverId: receiverId);

  @override
  Future<void> deleteMessage(
      {required Message messageInfo,
      Message? replacedMessage,
      required bool isThatOnlyMessageInChat}) async {
    try {
      String senderId = messageInfo.senderId;
      String receiverId = messageInfo.receiversIds[0];

      for (int i = 0; i < 2; i++) {
        String userId = i == 0 ? senderId : receiverId;
        String chatId = i == 0 ? receiverId : senderId;

        await _singleChat.deleteMessage(
            userId: userId, chatId: chatId, messageId: messageInfo.messageUid!);
        if (replacedMessage != null || isThatOnlyMessageInChat) {
          await _singleChat.updateLastMessage(
              userId: userId,
              chatId: chatId,
              message: messageInfo,
              isThatOnlyMessageInChat: isThatOnlyMessageInChat);
        }
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<SenderInfo> getSpecificChatInfo(
      {required String chatUid, required bool isThatGroup}) async {
    try {
      if (isThatGroup) {
        SenderInfo coverChatInfo =
            await _groupChat.getChatInfo(chatId: chatUid);
        SenderInfo messageDetails =
            await _fireStoreUser.extractUsersForGroupChatInfo(coverChatInfo);
        return messageDetails;
      } else {
        SenderInfo coverChatInfo =
            await _fireStoreUser.getChatOfUser(chatUid: chatUid);
        SenderInfo messageDetails =
            await _fireStoreUser.extractUsersForSingleChatInfo(coverChatInfo);
        return messageDetails;
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<SenderInfo>> getChatUserInfo(
      {required UserPersonalInfo myPersonalInfo}) async {
    try {
      List<SenderInfo> allChatsOfGroupInfo = await _groupChat
          .getSpecificChatsInfo(chatIds: myPersonalInfo.chatsOfGroups!);
      List<SenderInfo> allChatsInfo =
          await _fireStoreUser.getMessagesOfChat(userId: myPersonalInfo.userId);
      List<SenderInfo> allChats = allChatsInfo + allChatsOfGroupInfo;

      List<SenderInfo> allUsersInfo =
          await _fireStoreUser.extractUsersChatInfo(messagesDetails: allChats);
      return allUsersInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
