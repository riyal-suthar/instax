import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/user/firestore_user.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:get/get.dart';
import '../../../../models/child_classes/post/post.dart';

abstract class FireStorePost {
  Future<Post> createPost(Post postInfo);
  Future<void> deletePost({required Post postInfo});
  Future<Post> updatePost({required Post postInfo});
  Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds, required int lengthOfCurrentList});
  Future<List<dynamic>> getCommentsOfPost({required String postId});
  Future<List<Post>> getAllPostsInfo(
      {required bool isVideosWantedOnly, required String skippedVideoUid});

  putLikeOnThisPost({required String postId, required String userId});
  removeLikeOnThisPost({required String postId, required String userId});
  putCommentOnThisPost({required String postId, required String commentId});
  removeCommentOnThisPost({required String postId, required String commentId});
}

class FireStorePostImpl implements FireStorePost {
  final _postCollection = FirebaseFirestore.instance.collection("posts");

  @override
  Future<Post> createPost(Post postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _postCollection.add(postInfo.toMap());
    await _postCollection.doc(postRef.id).update({"postUid": postRef.id});
    postInfo.postUid = postRef.id;

    return postInfo;
  }

  @override
  Future<Post> updatePost({required Post postInfo}) async {
    await _postCollection
        .doc(postInfo.postUid)
        .update({"caption": postInfo.caption});
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _postCollection.doc(postInfo.postUid).get();

    return Post.fromQuery(doc: snap);
  }

  @override
  Future<void> deletePost({required Post postInfo}) async {
    await _postCollection.doc(postInfo.postUid).delete();
    await FireStoreUserImpl().removeUserPost(postId: postInfo.postUid);
  }

  @override
  Future<List<Post>> getAllPostsInfo(
      {required bool isVideosWantedOnly,
      required String skippedVideoUid}) async {
    List<Post> allPost = [];
    QuerySnapshot<Map<String, dynamic>> snap;

    if (isVideosWantedOnly) {
      snap = await _postCollection.where("isThatImage", isEqualTo: false).get();
    } else {
      snap = await _postCollection.get();
    }

    for (final doc in snap.docs) {
      if (skippedVideoUid == doc.id) continue;
      Post postReformat = Post.fromQuery(query: doc);
      UserPersonalInfo publisherInfo =
          await FireStoreUserImpl().getUserInfo(postReformat.publisherId);
      postReformat.publisherInfo = publisherInfo;

      allPost.add(postReformat);
    }
    return allPost;
  }

  @override
  Future<List<dynamic>> getCommentsOfPost({required String postId}) async {
    DocumentSnapshot<Map<String, dynamic>> snap =
        await _postCollection.doc(postId).get();

    if (snap.exists) {
      Post postReformat = Post.fromQuery(doc: snap);
      return postReformat.comments;
    } else {
      return Future.error(StringsManager.userNotExist.tr);
    }
  }

  @override
  Future<List<Post>> getPostsInfo(
      {required List<dynamic> postsIds,
      required int lengthOfCurrentList}) async {
    List<Post> postsInfo = [];
    int condition = postsIds.length;

    if (lengthOfCurrentList != -1) {
      int lengthOfOriginPost = postsIds.length;
      int lengthOfData = lengthOfOriginPost > 5 ? 5 : lengthOfOriginPost;
      int addMoreData = lengthOfCurrentList + 5;

      lengthOfData =
          addMoreData < lengthOfOriginPost ? addMoreData : lengthOfOriginPost;
      condition = lengthOfData;
    }

    for (int i = 0; i < condition; i++) {
      try {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _postCollection.doc(postsIds[i]).get();

        if (snap.exists) {
          Post postReformat = Post.fromQuery(doc: snap);
          if (postReformat.postUrl.isNotEmpty) {
            UserPersonalInfo publisherInfo =
                await FireStoreUserImpl().getUserInfo(postReformat.publisherId);
            postReformat.publisherInfo = publisherInfo;
            postsInfo.add(postReformat);
          } else {
            await deletePost(postInfo: postReformat);
          }
        } else {
          FireStoreUserImpl().removeUserPost(postId: postsIds[i]);
        }
      } catch (e) {
        continue;
      }
    }
    return postsInfo;
  }

  @override
  putCommentOnThisPost(
      {required String postId, required String commentId}) async {
    await _postCollection.doc(postId).update({
      "comments": FieldValue.arrayUnion([commentId])
    });
  }

  @override
  putLikeOnThisPost({required String postId, required String userId}) async {
    await _postCollection.doc(postId).update({
      "likes": FieldValue.arrayUnion([userId])
    });
  }

  @override
  removeCommentOnThisPost(
      {required String postId, required String commentId}) async {
    await _postCollection.doc(postId).update({
      "comments": FieldValue.arrayRemove([commentId])
    });
  }

  @override
  removeLikeOnThisPost({required String postId, required String userId}) async {
    await _postCollection.doc(postId).update({
      "likes": FieldValue.arrayRemove([userId])
    });
  }
}
