import 'dart:io';

import 'dart:typed_data';

import 'package:instax/data/data_sources/remote/fiirebase_firestore/chat/group_chat.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/repositories/group_message_repository.dart';

import '../data_sources/remote/fiirebase_firestore/firebase_storage.dart';
import '../data_sources/remote/fiirebase_firestore/user/firestore_user.dart';

class FirebaseGroupMessageRepoImpl implements FireStoreGroupMessageRepository {
  final FireStoreGroupChat _groupChat;
  final FireStoreUser _fireStoreUser;
  final FirebaseStoragePost _storagePost;

  FirebaseGroupMessageRepoImpl(
      this._groupChat, this._fireStoreUser, this._storagePost);

  @override
  Future<Message> createChatForGroups(Message messageInfo) async {
    try {
      Message message = await _groupChat.createChatForGroups(messageInfo);
      await _fireStoreUser.updateChatsOfGroups(messageInfo: message);
      return message;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteMessage(
      {required Message messageInfo,
      required String chatOfGroupUid,
      Message? replacedMessage}) async {
    try {
      await _groupChat.deleteMessage(
          chatOfGroupUid: chatOfGroupUid, messageId: messageInfo.messageUid!);
      if (replacedMessage != null) {
        await _groupChat.updateLastMessage(
            chatOfGroupUid: chatOfGroupUid, message: replacedMessage);
      }
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Stream<List<Message>> getMessages({required String groupChatUid}) =>
      _groupChat.getMessages(groupChatUid: groupChatUid);

  @override
  Future<Message> sendMessage(
      {required Message messageInfo,
      Uint8List? pathOfPhoto,
      required File? recordFile}) async {
    try {
      if (pathOfPhoto != null) {
        String imageUrl = await _storagePost.uploadData(
            folderName: "messagesFiles", data: pathOfPhoto);
        messageInfo.imageUrl = imageUrl;
      }
      if (recordFile != null) {
        String recordedUrl = await _storagePost.uploadFile(
            folderName: "messagesFiles", postFile: recordFile);
        messageInfo.recordedUrl = recordedUrl;
      }
      bool updateLastMessage = true;
      if (messageInfo.chatOfGroupId!.isEmpty) {
        Message newMessage = await createChatForGroups(messageInfo);
        messageInfo = newMessage;
        updateLastMessage = false;
      }

      Message myMessageInfo = await _groupChat.sendMessage(
          message: messageInfo, updateLastMessage: updateLastMessage);

      for (final userId in messageInfo.receiversIds) {
        await _fireStoreUser.sendNotification(
            userId: userId, message: messageInfo);
      }

      return myMessageInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
