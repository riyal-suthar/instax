import 'package:instax/data/data_sources/remote/fiirebase_firestore/post/comment/firestore_comment.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:instax/domain/repositories/post/comment_repository.dart';

import '../../../data_sources/remote/fiirebase_firestore/post/firestore_post.dart';

class FireStoreCommentRepoImpl implements FirestoreCommentRepository {
  final FireStoreComment _fireStoreComment;
  final FireStorePost _fireStorePost;

  FireStoreCommentRepoImpl(this._fireStoreComment, this._fireStorePost);

  @override
  Future<Comment> addComment({required Comment commentInfo}) async {
    try {
      String commentId =
          await _fireStoreComment.addComment(commentInfo: commentInfo);
      Comment comment =
          await _fireStoreComment.getCommentInfo(commentId: commentId);

      await _fireStorePost.putCommentOnThisPost(
          postId: comment.postId!, commentId: comment.commentUid!);
      return comment;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Comment>> getSpecificComments({required String postId}) async {
    try {
      List<dynamic> commentsIds =
          await _fireStorePost.getCommentsOfPost(postId: postId);
      List<Comment> comments =
          await _fireStoreComment.getSpecificComments(commentsIds: commentsIds);

      return comments;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    try {
      return await _fireStoreComment.putLikeOnThisComment(
          commentId: commentId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeLikeOnThisComment(
      {required String commentId, required String myPersonalId}) async {
    try {
      return await _fireStoreComment.removeLikeOnThisComment(
          commentId: commentId, myPersonalId: myPersonalId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
