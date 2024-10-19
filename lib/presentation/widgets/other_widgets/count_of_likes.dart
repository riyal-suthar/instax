import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../config/routes/app_routes.dart';
import '../../../config/routes/hero_dialog_route.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/child_classes/post/post.dart';
import '../../pages/profile/users_who_like_for_mobile.dart';
import '../../pages/profile/users_who_like_for_web.dart';

class CountOfLikes extends StatelessWidget {
  final Post postInfo;

  const CountOfLikes({super.key, required this.postInfo});

  @override
  Widget build(BuildContext context) {
    int likes = postInfo.likes.length;

    return InkWell(
      onTap: () {
        if (isThatMobile) {
          Go(context).push(
              page: UsersWhoLikesForMobile(
            showSearchBar: true,
            usersIds: postInfo.likes,
            isThatMyPersonalId: postInfo.publisherId == myPersonalId,
          ));
        } else {
          Navigator.of(context).push(
            HeroDialogRoute(
              builder: (context) => UsersWhoLikesForWeb(
                usersIds: postInfo.likes,
                isThatMyPersonalId: postInfo.publisherId == myPersonalId,
              ),
            ),
          );
        }
      },
      child: Text(
          '$likes ${likes > 1 ? StringsManager.likes.tr : StringsManager.like.tr}',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.displayMedium),
    );
  }
}
