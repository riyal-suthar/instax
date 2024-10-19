import 'package:instax/data/data_sources/remote/fiirebase_firestore/post/comment/firestore_reply_comment.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instax/domain/repositories/post/reply_comment_repository.dart';

import '../../../data_sources/remote/fiirebase_firestore/post/comment/firestore_comment.dart';

class FireStoreRepliesOnCommentRepoImpl
    implements FirestoreReplyOnCommentRepository {
  final FireStoreReplyComment _replyComment;
  final FireStoreComment _fireStoreComment;

  FireStoreRepliesOnCommentRepoImpl(this._replyComment, this._fireStoreComment);

  @override
  Future<List<Comment>> getSpecificReplies({required String commentId}) async {
    try {
      List? repliesIds =
          await _fireStoreComment.getRepliesOfComments(commentId: commentId);
      List<Comment> repliesInfo =
          await _replyComment.getSpecificReplies(repliesIds: repliesIds!);

      return repliesInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    try {
      await _replyComment.putLikeOnThisReply(
          replyId: replyId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisReply(
      {required String replyId, required String myPersonalId}) async {
    try {
      await _replyComment.removeLikeOnThisReply(
          replyId: replyId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Comment> replyOnThisComment({required Comment replyInfo}) async {
    try {
      String replyId =
          await _replyComment.replyOnThisComment(replyInfo: replyInfo);
      Comment reply = await _replyComment.getReplyInfo(replyId: replyId);

      await _fireStoreComment.putReplyOnThisComment(
          commentId: reply.parentCommentId!, replyId: reply.commentUid!);
      return reply;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
