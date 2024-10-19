import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

class Comment {
  String datePublished;
  String comment;
  String commentUid;
  String postId;
  String whoCommentId;
  UserPersonalInfo? whoCommentInfo;
  List<dynamic> likes;
  String? parentCommentId;
  List<dynamic>? replies;
  bool isLoading;

  Comment({
    required this.datePublished,
    required this.comment,
    this.commentUid = "",
    required this.whoCommentId,
    this.whoCommentInfo,
    required this.postId,
    required this.likes,
    this.parentCommentId,
    this.replies,
    this.isLoading = false,
  });

  static Comment fromSnapComment(
      DocumentSnapshot<Map<String, dynamic>>? snapshot) {
    var snap = snapshot?.data();
    return Comment(
      datePublished: snap?["datePublished"] ?? "",
      comment: snap?["comment"] ?? "",
      commentUid: snap?["commentUid"] ?? "",
      whoCommentId: snap?["whoCommentId"] ?? "",
      parentCommentId: snap?["parentCommentId"] ?? "",
      postId: snap?["postId"] ?? "",
      likes: snap?["likes"] ?? [],
      replies: snap?["replies"] ?? [],
    );
  }

  Map<String, dynamic> toMapComment() => {
        "datePublished": datePublished,
        "comment": comment,
        "commentUid": commentUid,
        "whoCommentId": whoCommentId,
        "postId": postId,
        "likes": likes,
        "replies": replies,
      };

  static Comment fromSnapReply(
      DocumentSnapshot<Map<String, dynamic>>? snapshot) {
    var snap = snapshot?.data();
    return Comment(
      datePublished: snap?["datePublished"] ?? "",
      comment: snap?["reply"] ?? "",
      commentUid: snap?["replyUid"] ?? "",
      whoCommentId: snap?["whoReplyId"] ?? "",
      postId: snap?["postId"] ?? "",
      parentCommentId: snap?["parentCommentId"] ?? "",
      likes: snap?["likes"] ?? [],
    );
  }

  Map<String, dynamic> toMapReply() => {
        "datePublished": datePublished,
        "reply": comment,
        "replyUid": commentUid,
        "whoReplyId": whoCommentId,
        "postId": postId,
        "parentCommentId": parentCommentId,
        "likes": likes,
      };
}
