import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instax/data/models/parent_classes/post/parent_post.dart';

import '../../parent_classes/without_sub_classes/user_personal_info.dart';

// enum isPost { isThatImage, isThatVideo, isThatMix }

class Post extends ParentPost {
  String postUid;
  String postUrl;
  List<dynamic> imagesUrls;
  String coverOfVideoUrl;
  double? aspectRatio;
  bool isThatMix = false;
  Post({
    required String datePublished,
    required String publisherId,
    String? publisherName,
    String? publisherProfileUrl,
    UserPersonalInfo? publisherInfo,
    this.postUid = "",
    this.coverOfVideoUrl = "",
    this.isThatMix = false,
    this.postUrl = "",
    required this.imagesUrls,
    required this.aspectRatio,
    String caption = "",
    required List<dynamic> comments,
    required String blurHash,
    required List<dynamic> likes,
    bool isThatImage = true,
  }) : super(
          datePublished: datePublished,
          likes: likes,
          comments: comments,
          publisherId: publisherId,
          caption: caption,
          blurHash: blurHash,
          publisherInfo: publisherInfo,
          isThatImage: isThatImage,
        );

  static Post fromQuery(
      {DocumentSnapshot<Map<String, dynamic>>? doc,
      QueryDocumentSnapshot<Map<String, dynamic>>? query}) {
    dynamic snap = doc?.data() ?? query?.data();
    dynamic aspect = snap["aspectRatio"];
    if (aspect is int) aspect = aspect.toDouble();

    return Post(
      datePublished: snap["datePublished"] ?? "",
      publisherId: snap["publisherId"] ?? "",
      caption: snap["caption"] ?? "",
      likes: snap["likes"] ?? [],
      comments: snap["comments"] ?? [],
      blurHash: snap["blurHash"] ?? "",
      coverOfVideoUrl: snap["coverOfVideoUrl"] ?? "",
      postUid: snap["postUid"] ?? "",
      postUrl: snap["postUrl"] ?? "",
      imagesUrls: snap["imagesUrls"] ?? [],
      isThatImage: snap["isThatImage"] ?? true,
      isThatMix: snap["isThatMix"] ?? false,
      aspectRatio: aspect ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() => {
        "datePublished": datePublished,
        "publisherId": publisherId,
        "caption": caption,
        "likes": likes,
        "comments": comments,
        "blurHash": blurHash,
        "coverOfVideoUrl": coverOfVideoUrl,
        "postUid": postUid,
        "postUrl": postUrl,
        "imagesUrls": imagesUrls,
        "isThatImage": isThatImage,
        "isThatMix": isThatMix,
        "aspectRatio": aspectRatio,
      };
}
