import 'dart:typed_data';

import 'package:instax/core/utils/constants.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/firebase_storage.dart';
import 'package:instax/data/models/child_classes/post/story.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/repositories/post/story_repository.dart';

import '../../../data_sources/remote/fiirebase_firestore/story/firestore_story.dart';
import '../../../data_sources/remote/fiirebase_firestore/user/firestore_user.dart';

class FireStoreStoryRepoImpl implements FireStoreStoryRepository {
  final FirebaseStoragePost _storagePost;
  final FireStoreStory _story;
  final FireStoreUser _fireStoreUser;

  FireStoreStoryRepoImpl(this._storagePost, this._story, this._fireStoreUser);

  @override
  Future<String> createStory(
      {required Story storyInfo, required Uint8List file}) async {
    try {
      String fileName = storyInfo.isThatImage ? "jpg" : "mp4";
      String postUrl =
          await _storagePost.uploadData(folderName: fileName, data: file);
      storyInfo.storyUrl = postUrl;
      String storyUid = await _story.createStory(storyInfo);
      await _fireStoreUser.updateUserStories(
          userId: storyInfo.publisherId, storyId: storyUid);

      return storyUid;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> deleteThisStory({required String storyId}) async {
    try {
      await _fireStoreUser.deleteThisStory(storyId: storyId);
      await _story.deleteThisStory(storyId: storyId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<UserPersonalInfo> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo}) async {
    try {
      return (await _story.getStoriesInfo([userInfo]))[0];
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<List<UserPersonalInfo>> getStoriesInfo({required List userIds}) async {
    try {
      List<UserPersonalInfo> usersInfo =
          await _fireStoreUser.getSpecificUsersInfo(
              usersIds: userIds, userUid: myPersonalId, fieldName: "stories");
      return await _story.getStoriesInfo(usersInfo);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> putLikeOnThisStory(
      {required String storyId, required String userId}) async {
    try {
      return await _story.putLikeOnThisPost(storyId: storyId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> removeTheLikeOnThisStory(
      {required String storyId, required String userId}) async {
    try {
      return await _story.removeLikeOnThisPost(
          storyId: storyId, userId: userId);
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
