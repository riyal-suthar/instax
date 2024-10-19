import 'dart:typed_data';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class Message extends Equatable {
  String datePublished;
  String message;
  String senderId;
  UserPersonalInfo? senderInfo;
  List<dynamic> receiversIds;
  String messageUid;
  String blurHash;
  String imageUrl;
  Uint8List? localImage;
  String recordedUrl;
  bool isThatImage;
  bool isThatPost;
  bool isThatRecord;
  bool multiImages;
  bool isThatVideo;
  bool isThatGroup;
  String chatOfGroupId;
  String sharedPostId;
  String ownerOfSharedPostId;
  int lengthOfRecord;

  Message({
    required this.datePublished,
    required this.message,
    required this.senderId,
    this.senderInfo,
    required this.receiversIds,
    this.messageUid = "",
    required this.blurHash,
    this.imageUrl = "",
    this.localImage,
    this.recordedUrl = "",
    required this.isThatImage,
    this.isThatPost = false,
    this.isThatRecord = false,
    this.multiImages = false,
    this.isThatVideo = false,
    this.isThatGroup = false,
    this.chatOfGroupId = "",
    this.sharedPostId = "",
    this.ownerOfSharedPostId = "",
    this.lengthOfRecord = 0,
  });

  static Message fromJson(
      {DocumentSnapshot<Map<String, dynamic>>? doc,
      QueryDocumentSnapshot<Map<String, dynamic>>? query}) {
    dynamic snap = doc?.data() ?? query?.data();

    return Message(
      datePublished: snap["datePublished"] ?? "",
      message: snap["message"] ?? "",
      senderId: snap["senderId"] ?? "",
      receiversIds: snap["receiversIds"] ?? [],
      blurHash: snap["blurHash"] ?? "",
      messageUid: snap["messageUid"] ?? "",
      imageUrl: snap["imageUrl"] ?? "",
      recordedUrl: snap["recordedUrl"] ?? "",
      sharedPostId: snap["postId"] ?? "",
      ownerOfSharedPostId: snap["ownerOfSharedPostId"] ?? "",
      isThatImage: snap["isThatImage"] ?? false,
      multiImages: snap["multiImages"] ?? false,
      isThatPost: snap["isThatPost"] ?? false,
      isThatVideo: snap["isThatVideo"] ?? false,
      isThatGroup: snap["isThatGroup"] ?? false,
      isThatRecord: snap["isThatRecord"] ?? false,
      chatOfGroupId: snap["chatOfGroupId"] ?? "",
      lengthOfRecord: snap["lengthOfRecord"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
        "datePublished": datePublished,
        "message": message,
        "senderId": senderId,
        "receiversIds": receiversIds,
        "blurHash": blurHash,
        "imageUrl": imageUrl,
        "recordedUrl": recordedUrl,
        "postId": sharedPostId,
        "ownerOfSharedPostId": ownerOfSharedPostId,
        "isThatImage": isThatImage,
        "multiImages": multiImages,
        "isThatPost": isThatPost,
        "isThatVideo": isThatVideo,
        "isThatGroup": isThatGroup,
        "isThatRecord": isThatRecord,
        "chatOfGroupId": chatOfGroupId,
        "lengthOfRecord": lengthOfRecord
      };

  @override
  // TODO: implement props
  List<Object?> get props => [
        datePublished,
        message,
        senderId,
        receiversIds,
        messageUid,
        blurHash,
        imageUrl,
        recordedUrl,
        sharedPostId,
        ownerOfSharedPostId,
        isThatImage,
        multiImages,
        isThatPost,
        isThatVideo,
        isThatGroup,
        isThatRecord,
        chatOfGroupId,
        lengthOfRecord,
      ];
}
