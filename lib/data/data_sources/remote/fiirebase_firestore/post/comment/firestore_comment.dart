import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/user/firestore_user.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:get/get.dart';
import '../../../../../models/parent_classes/without_sub_classes/comment.dart';

abstract class FireStoreComment {
  Future<String> addComment({required Comment commentInfo});

  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId});
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId});

  putReplyOnThisComment({required String commentId, required String replyId});

  Future<List<dynamic>?> getRepliesOfComments({required String commentId});

  Future<List<Comment>> getSpecificComments(
      {required List<dynamic> commentsIds});

  Future<Comment> getCommentInfo({required String commentId});
}

class FireStoreCommentImpl implements FireStoreComment {
  final _commentCollection = FirebaseFirestore.instance.collection("comments");

  @override
  Future<String> addComment({required Comment commentInfo}) async {
    DocumentReference<Map<String, dynamic>> commentRef =
        await _commentCollection.add(commentInfo.toMapComment());

    await _commentCollection
        .doc(commentRef.id)
        .update({"commentUid": commentRef.id});
    return commentRef.id;
  }

  @override
  Future<Comment> getCommentInfo({required String commentId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _commentCollection.doc(commentId).get();

    if (snap.exists) {
      Comment commentInfo = Comment.fromSnapComment(snap);
      UserPersonalInfo commenterInfo =
          await FireStoreUserImpl().getUserInfo(commentInfo.whoCommentId);
      commentInfo.whoCommentInfo = commenterInfo;

      return commentInfo;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future<List?> getRepliesOfComments({required String commentId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _commentCollection.doc(commentId).get();

    if (snap.exists) {
      Comment commentReformat = Comment.fromSnapComment(snap);
      return commentReformat.replies;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future<List<Comment>> getSpecificComments(
      {required List<dynamic> commentsIds}) async {
    List<Comment> allComments = [];
    for (int i = 0; i < commentsIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _commentCollection.doc(commentsIds[i]).get();
      Comment commentReformat = Comment.fromSnapComment(snap);

      UserPersonalInfo whoCommentInfo =
          await FireStoreUserImpl().getUserInfo(commentReformat.whoCommentId);
      commentReformat.whoCommentInfo = whoCommentInfo;

      allComments.add(commentReformat);
    }
    return allComments;
  }

  @override
  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    await _commentCollection.doc(commentId).update({
      "likes": FieldValue.arrayUnion([myPersonalId])
    });
  }

  @override
  putReplyOnThisComment(
      {required String commentId, required String replyId}) async {
    await _commentCollection.doc(commentId).update({
      "replies": FieldValue.arrayUnion([replyId])
    });
  }

  @override
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    await _commentCollection.doc(commentId).update({
      "likes": FieldValue.arrayRemove([myPersonalId])
    });
  }
}
