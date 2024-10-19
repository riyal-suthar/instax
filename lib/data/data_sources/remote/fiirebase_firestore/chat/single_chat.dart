import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';

abstract class FireStoreSingleChat {
  Future<Message> sendMessage(
      {required Message message,
      required String chatId,
      required String userId});
  Future<void> updateLastMessage(
      {required String userId,
      required String chatId,
      required Message? message,
      required bool isThatOnlyMessageInChat});
  Stream<List<Message>> getMessages({required String receiverId});
  Future<void> deleteMessage(
      {required String userId,
      required String chatId,
      required String messageId});
}

class FireStoreSingleChatImpl implements FireStoreSingleChat {
  final _userCollection = FirebaseFirestore.instance.collection("users");

  @override
  Future<void> deleteMessage(
      {required String userId,
      required String chatId,
      required String messageId}) async {
    await _userCollection
        .doc(userId)
        .collection("chats")
        .doc(chatId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  @override
  Stream<List<Message>> getMessages({required String receiverId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = _userCollection
        .doc(myPersonalId)
        .collection("chats")
        .doc(receiverId)
        .collection("messages")
        .orderBy("datePublished", descending: false)
        .snapshots();
    return snap.map((snapshot) =>
        snapshot.docs.map((e) => Message.fromJson(query: e)).toList());
  }

  @override
  Future<Message> sendMessage(
      {required Message message,
      required String chatId,
      required String userId}) async {
    DocumentReference<Map<String, dynamic>> userCollection =
        _userCollection.doc(userId);
    DocumentReference<Map<String, dynamic>> chatCollection =
        userCollection.collection("chats").doc(chatId);
    chatCollection.set(message.toMap());
    CollectionReference<Map<String, dynamic>> messageCollection =
        chatCollection.collection("messages");

    if (message.messageUid.isEmpty) {
      DocumentReference<Map<String, dynamic>> messageRef =
          await messageCollection.add(message.toMap());
      message.messageUid = messageRef.id;
      await messageCollection
          .doc(messageRef.id)
          .update({"messageUid": messageRef.id});
    } else {
      await messageCollection.doc(message.messageUid).set(message.toMap());
    }
    return message;
  }

  @override
  Future<void> updateLastMessage(
      {required String userId,
      required String chatId,
      required Message? message,
      required bool isThatOnlyMessageInChat}) async {
    DocumentReference<Map<String, dynamic>> chatCollection =
        _userCollection.doc(userId).collection("chats").doc(chatId);
    if (message != null) {
      Map<String, dynamic> toMap =
          isThatOnlyMessageInChat ? {"": ""} : message.toMap();
      await chatCollection.set(toMap);
    }
  }
}
