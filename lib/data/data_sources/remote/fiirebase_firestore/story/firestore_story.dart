import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';

import '../../../../models/child_classes/post/story.dart';

abstract class FireStoreStory {
  Future<String> createStory(Story postInfo);
  Future<void> deleteThisStory({required String storyId});
  Future<List<UserPersonalInfo>> getStoriesInfo(
      List<UserPersonalInfo> usersInfo);

  putLikeOnThisPost({required String storyId, required String userId});
  removeLikeOnThisPost({required String storyId, required String userId});
  putCommentOnThisPost({required String storyId, required String commentId});
  removeCommentOnThisPost({required String storyId, required String commentId});
}

class FireStoreStoryImpl implements FireStoreStory {
  final _storyCollection = FirebaseFirestore.instance.collection("stories");

  @override
  Future<String> createStory(Story postInfo) async {
    DocumentReference<Map<String, dynamic>> postRef =
        await _storyCollection.add(postInfo.toMap());

    await _storyCollection.doc(postRef.id).update({"storyUid": postRef.id});
    return postRef.id;
  }

  @override
  Future<void> deleteThisStory({required String storyId}) async {
    await _storyCollection.doc(storyId).delete();
  }

  @override
  Future<List<UserPersonalInfo>> getStoriesInfo(
      List<UserPersonalInfo> usersInfo) async {
    List<Story> storiesInfo = [];
    List<String> storiesIds = [];

    for (int i = 0; i < usersInfo.length; i++) {
      storiesInfo = [];
      List<dynamic> userStories = usersInfo[i].stories;
      if (userStories.isEmpty) {
        usersInfo.removeAt(i);
        i--;
        continue;
      }
      for (int j = 0; j < userStories.length; j++) {
        DocumentSnapshot<Map<String, dynamic>> snap =
            await _storyCollection.doc(userStories[j]).get();

        if (snap.exists) {
          Story postReformat = Story.fromSnap(doc: snap);
          if (postReformat.storyUrl.isNotEmpty) {
            postReformat.publisherInfo = usersInfo[i];
            if (!storiesIds.contains(postReformat.storyUid)) {
              storiesInfo.add(postReformat);
              storiesIds.add(postReformat.storyUid);
            }
          }
        }
      }
      usersInfo[i].storiesInfo = storiesInfo;
    }
    return usersInfo;
  }

  @override
  putCommentOnThisPost(
      {required String storyId, required String commentId}) async {
    await _storyCollection.doc(storyId).update({
      "comments": FieldValue.arrayUnion([commentId])
    });
  }

  @override
  putLikeOnThisPost({required String storyId, required String userId}) async {
    await _storyCollection.doc(storyId).update({
      "likes": FieldValue.arrayUnion([userId])
    });
  }

  @override
  removeCommentOnThisPost(
      {required String storyId, required String commentId}) async {
    await _storyCollection.doc(storyId).update({
      "comments": FieldValue.arrayRemove([commentId])
    });
  }

  @override
  removeLikeOnThisPost(
      {required String storyId, required String userId}) async {
    await _storyCollection.doc(storyId).update({
      "likes": FieldValue.arrayRemove([userId])
    });
  }
}
