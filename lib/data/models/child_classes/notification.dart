import 'package:instax/domain/entities/notification_check.dart';

class CustomNotification extends NotificationCheck {
  String notificationUid;
  String text;
  String time;
  String personalUserName;
  String postImageUrl;
  String personalProfileImageUrl;
  String senderName;

  CustomNotification({
    this.notificationUid = "",
    required this.text,
    required this.time,
    required this.personalUserName,
    this.postImageUrl = "",
    required this.personalProfileImageUrl,
    required this.senderName,
    required super.receiverId,
    required super.senderId,
    super.postId,
    super.isThatPost = true,
    super.isThatLike = true,
  });

  static CustomNotification fromJson(Map<String, dynamic>? snap) {
    return CustomNotification(
      notificationUid: snap?["notificationUid"] ?? "",
      text: snap?["text"] ?? "",
      time: snap?["time"] ?? "",
      personalUserName: snap?["personalUserName"] ?? "",
      personalProfileImageUrl: snap?["personalProfileImageUrl"] ?? "",
      senderName: snap?["senderName"] ?? "",
      receiverId: snap?["receiverId"] ?? "",
      senderId: snap?["senderId"] ?? "",
      postId: snap?["postId"] ?? "",
      postImageUrl: snap?["postImageUrl"] ?? "",
      isThatPost: snap?["isThatPost"] ?? true,
      isThatLike: snap?["isThatLike"] ?? true,
    );
  }

  Map<String, dynamic> toMap() => {
        "text": text,
        "time": time,
        "personalUserName": personalUserName,
        "personalProfileImageUrl": personalProfileImageUrl,
        "senderName": senderName,
        "senderId": senderId,
        "receiverId": receiverId,
        "postId": postId,
        "postImageUrl": postImageUrl,
        "isThatPost": isThatPost,
        "isThatLike": isThatLike,
      };
}
