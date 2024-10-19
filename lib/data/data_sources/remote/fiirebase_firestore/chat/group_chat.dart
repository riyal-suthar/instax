import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/domain/entities/sender_receiver_info.dart';

abstract class FireStoreGroupChat {
  Future<Message> createChatForGroups(Message message);
  Future<Message> sendMessage(
      {bool updateLastMessage = true, required Message message});
  Future<void> updateLastMessage(
      {required String chatOfGroupUid, required Message message});
  Future<List<SenderInfo>> getSpecificChatsInfo(
      {required List<dynamic> chatIds});
  Future<SenderInfo> getChatInfo({required dynamic chatId});
  Stream<List<Message>> getMessages({required String groupChatUid});
  Future<void> deleteMessage(
      {required String chatOfGroupUid, required String messageId});
}

class FireStoreGroupChatImpl implements FireStoreGroupChat {
  final _groupChatCollection =
      FirebaseFirestore.instance.collection("chatsOfGroups");

  @override
  Future<Message> createChatForGroups(Message message) async {
    DocumentReference<Map<String, dynamic>> ref =
        await _groupChatCollection.add(message.toMap());
    message.chatOfGroupId = ref.id;
    await _groupChatCollection.doc(ref.id).update({"chatOfGroupId": ref.id});
    return message;
  }

  @override
  Future<void> deleteMessage(
      {required String chatOfGroupUid, required String messageId}) async {
    await _groupChatCollection
        .doc(chatOfGroupUid)
        .collection("messages")
        .doc(messageId)
        .delete();
  }

  @override
  Future<SenderInfo> getChatInfo({required chatId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _groupChatCollection.doc(chatId).get();
    Message messageInfo = Message.fromJson(doc: snap);
    return SenderInfo(lastMessage: messageInfo);
  }

  @override
  Future<List<SenderInfo>> getSpecificChatsInfo({required List chatIds}) async {
    List<SenderInfo> allUsers = [];
    for (final chatId in chatIds) {
      SenderInfo userInfo = await getChatInfo(chatId: chatId);
      allUsers.add(userInfo);
    }
    return allUsers;
  }

  @override
  Stream<List<Message>> getMessages({required String groupChatUid}) {
    Stream<QuerySnapshot<Map<String, dynamic>>> snap = _groupChatCollection
        .doc(groupChatUid)
        .collection("messages")
        .orderBy("datePublished", descending: false)
        .snapshots();
    return snap.map(
        (event) => event.docs.map((e) => Message.fromJson(query: e)).toList());
  }

  @override
  Future<Message> sendMessage(
      {bool updateLastMessage = true, required Message message}) async {
    DocumentReference<Map<String, dynamic>> chatCollection =
        _groupChatCollection.doc(message.chatOfGroupId);
    if (updateLastMessage) chatCollection.set(message.toMap());

    CollectionReference<Map<String, dynamic>> messageCollection =
        chatCollection.collection("messages");
    DocumentReference<Map<String, dynamic>> messageRef =
        await messageCollection.add(message.toMap());
    message.messageUid = messageRef.id;

    await messageCollection
        .doc(messageRef.id)
        .update({"messageUid": messageRef.id});
    return message;
  }

  @override
  Future<void> updateLastMessage(
      {required String chatOfGroupUid, required Message message}) async {
    DocumentReference<Map<String, dynamic>> chatCollection =
        _groupChatCollection.doc(chatOfGroupUid);
    await chatCollection.set(message.toMap());
  }
}
