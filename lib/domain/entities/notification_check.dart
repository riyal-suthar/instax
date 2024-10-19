import 'package:equatable/equatable.dart';

class NotificationCheck extends Equatable {
  final String receiverId;
  final String senderId;
  final String postId;
  final bool isThatPost;
  final bool isThatLike;

  const NotificationCheck({
    required this.receiverId,
    required this.senderId,
    this.postId = "",
    this.isThatPost = true,
    this.isThatLike = true,
  });

  @override
  // TODO: implement props
  List<Object?> get props =>
      [receiverId, senderId, postId, isThatLike, isThatPost];
}
