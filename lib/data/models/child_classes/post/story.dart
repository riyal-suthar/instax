import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/data/models/parent_classes/post/parent_post.dart';

class Story extends ParentPost {
  String storyUrl;
  String storyUid;

  Story({
    this.storyUrl = "",
    this.storyUid = "",
    super.caption,
    super.publisherInfo,
    required super.datePublished,
    required super.publisherId,
    required super.likes,
    required super.comments,
    required super.blurHash,
    super.isThatImage = true,
  });

  static Story fromSnap(
      {required DocumentSnapshot<Map<String, dynamic>>? doc}) {
    var snap = doc?.data();

    return Story(
      storyUrl: snap?["storyUrl"] ?? "",
      storyUid: snap?["storyUid"] ?? "",
      caption: snap?["caption"] ?? "",
      isThatImage: snap?["isThatImage"] ?? "",
      datePublished: snap?["datePublished"] ?? "",
      publisherId: snap?["publisherId"] ?? "",
      likes: snap?["likes"] ?? [],
      comments: snap?["comments"] ?? [],
      blurHash: snap?["blurHash"] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        "datePublished": datePublished,
        "publisherId": publisherId,
        "caption": caption,
        "likes": likes,
        "comments": comments,
        "blurHash": blurHash,
        "storyUid": storyUid,
        "storyUrl": storyUrl,
        "isThatImage": isThatImage,
      };
}
