import 'dart:typed_data';

import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

import '../../../data/models/child_classes/post/story.dart';

abstract class FireStoreStoryRepository {
  Future<String> createStory(
      {required Story storyInfo, required Uint8List file});

  Future<List<UserPersonalInfo>> getStoriesInfo(
      {required List<dynamic> userIds});

  Future<UserPersonalInfo> getSpecificStoriesInfo(
      {required UserPersonalInfo userInfo});

  Future<void> deleteThisStory({required String storyId});

  Future<void> putLikeOnThisStory(
      {required String storyId, required String userId});
  Future<void> removeTheLikeOnThisStory(
      {required String storyId, required String userId});
}
