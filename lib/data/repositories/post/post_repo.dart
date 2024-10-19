import 'dart:io';

import 'dart:typed_data';

import 'package:image_picker/image_picker.dart';
import 'package:image_picker_plus/image_picker_plus.dart';
// import 'package:image_picker_plus/image_picker_plus.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/firebase_storage.dart';
import 'package:instax/data/models/child_classes/post/post.dart';

import '../../../core/utils/constants.dart';
import '../../../domain/repositories/post/post_repository.dart';
import '../../data_sources/remote/fiirebase_firestore/post/firestore_post.dart';
import '../../data_sources/remote/fiirebase_firestore/user/firestore_user.dart';

class FireStorePostRepositoryImpl implements FireStorePostRepository {
  final FirebaseStoragePost _storagePost;
  final FireStoreUser _fireStoreUser;
  final FireStorePost _fireStorePost;

  FireStorePostRepositoryImpl(
      this._storagePost, this._fireStoreUser, this._fireStorePost);

  @override
  Future<Post> createPost(
      {required Post postInfo,
      required List<SelectedByte> files,
      required Uint8List? coverOfVideo}) async {
    try {
      bool isFirstPostImage = files[0].isThatImage;
      bool isThatMix = false;

      postInfo.isThatImage = isFirstPostImage;
      for (int i = 0; i < files.length; i++) {
        bool isThatImage = files[i].isThatImage;
        if (!isThatMix) isThatMix = !isThatImage == isFirstPostImage;

        String fileName = isThatImage ? "jpg" : "mp4";
        String postUrl;

        if (isThatMobile) {
          postUrl = await _storagePost.uploadFile(
              folderName: fileName, postFile: files[i].selectedFile);
        } else {
          postUrl = await _storagePost.uploadData(
              folderName: fileName, data: files[i].selectedByte);
        }

        if (i == 0) postInfo.postUrl = postUrl;
        postInfo.imagesUrls.add(postUrl);
      }
      if (coverOfVideo != null) {
        String coverOfVideoUrl = await _storagePost.uploadData(
            folderName: "postsVideo", data: coverOfVideo);
        postInfo.coverOfVideoUrl = coverOfVideoUrl;
      }

      postInfo.isThatMix = isThatMix;
      Post newPostInfo = await _fireStorePost.createPost(postInfo);
      return newPostInfo;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deletePost({required Post postInfo}) async {
    try {
      await _fireStorePost.deletePost(postInfo: postInfo);
      await _storagePost.deleteImageFromStorage(postInfo.postUrl);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getAllPostsInfo(
      {required bool isVideosWantedOnly,
      required String skippedVideoUid}) async {
    try {
      return await _fireStorePost.getAllPostsInfo(
          isVideosWantedOnly: isVideosWantedOnly,
          skippedVideoUid: skippedVideoUid);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<Post>> getPostsInfo(
      {required List postsIds, required int lengthOfCurrentList}) async {
    try {
      return await _fireStorePost.getPostsInfo(
          postsIds: postsIds, lengthOfCurrentList: lengthOfCurrentList);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List> getSpecificUsersPosts(List usersIds) async {
    try {
      return await _fireStoreUser.getSpecificUsersPosts(usersIds);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisPost(
      {required String postId, required String userId}) async {
    try {
      return await _fireStorePost.putLikeOnThisPost(
          postId: postId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeTheLikeOnThisPost(
      {required String postId, required String userId}) async {
    try {
      return await _fireStorePost.removeLikeOnThisPost(
          postId: postId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<Post> updatePost({required Post postInfo}) async {
    try {
      return await _fireStorePost.updatePost(postInfo: postInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
