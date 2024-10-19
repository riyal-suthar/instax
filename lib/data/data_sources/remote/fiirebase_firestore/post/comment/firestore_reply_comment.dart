import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/user/firestore_user.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:get/get.dart';
import '../../../../../models/parent_classes/without_sub_classes/comment.dart';

abstract class FireStoreReplyComment {
  Future<String> replyOnThisComment({required Comment replyInfo});

  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId});
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId});

  Future<List<Comment>> getSpecificReplies({required List<dynamic> repliesIds});

  Future<Comment> getReplyInfo({required String replyId});
}

class FireStoreReplyCommentImpl implements FireStoreReplyComment {
  final _replyCollection = FirebaseFirestore.instance.collection("replies");

  @override
  Future<Comment> getReplyInfo({required String replyId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _replyCollection.doc(replyId).get();
    if (snap.exists) {
      return Comment.fromSnapReply(snap);
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future<List<Comment>> getSpecificReplies({required List repliesIds}) async {
    List<Comment> allReplies = [];

    for (int i = 0; i < repliesIds.length; i++) {
      DocumentSnapshot<Map<String, dynamic>> snap =
          await _replyCollection.doc(repliesIds[i]).get();
      Comment replyReformat = Comment.fromSnapReply(snap);

      UserPersonalInfo whoReplyInfo =
          await FireStoreUserImpl().getUserInfo(replyReformat.whoCommentId);
      replyReformat.whoCommentInfo = whoReplyInfo;

      allReplies.add(replyReformat);
    }
    return allReplies;
  }

  @override
  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    await _replyCollection.doc(replyId).update({
      "likes": FieldValue.arrayUnion([myPersonalId])
    });
  }

  @override
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    await _replyCollection.doc(replyId).update({
      "likes": FieldValue.arrayRemove([myPersonalId])
    });
  }

  @override
  Future<String> replyOnThisComment({required Comment replyInfo}) async {
    DocumentReference<Map<String, dynamic>> commentRef =
        await _replyCollection.add(replyInfo.toMapReply());

    await _replyCollection
        .doc(commentRef.id)
        .update({"replyUid": commentRef.id});
    return commentRef.id;
  }
}
