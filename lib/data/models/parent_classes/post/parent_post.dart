import '../without_sub_classes/user_personal_info.dart';

abstract class ParentPost {
  String datePublished;
  String caption;
  String publisherId;
  List<dynamic> likes;
  List<dynamic> comments;
  UserPersonalInfo? publisherInfo;
  String blurHash;
  bool isThatImage;

  ParentPost({
    required this.datePublished,
    required this.publisherId,
    required this.likes,
    required this.comments,
    required this.blurHash,
    required this.isThatImage,
    this.caption = "",
    this.publisherInfo,
  });
}
