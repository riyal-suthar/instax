import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/resources/color_manager.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/presentation/cubit/follow_unfollow_cubit/follow_un_follow_cubit.dart';
import 'package:instax/presentation/cubit/user_info/users_info_in_reel_time/users_info_in_reel_time_bloc.dart';
import 'package:instax/presentation/pages/profile/widgets/which_profile_page.dart';
import 'package:instax/presentation/widgets/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:get/get.dart';
import '../../../../config/routes/app_routes.dart';
import '../../../../core/utils/constants.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../cubit/user_info/user_info_cubit.dart';

class ShowMeTheUsers extends StatefulWidget {
  final List<UserPersonalInfo> usersInfo;
  final bool isThatFollower;
  final bool showColorfulCircle;
  final String emptyText;
  final bool isThatMyPersonalId;
  final VoidCallback? updateFollowedCallback;
  const ShowMeTheUsers({
    super.key,
    required this.usersInfo,
    this.isThatFollower = true,
    this.showColorfulCircle = true,
    required this.emptyText,
    required this.isThatMyPersonalId,
    this.updateFollowedCallback,
  });

  @override
  State<ShowMeTheUsers> createState() => _ShowMeTheUsersState();
}

class _ShowMeTheUsersState extends State<ShowMeTheUsers> {
  @override
  Widget build(BuildContext context) {
    if (widget.usersInfo.isNotEmpty) {
      return SingleChildScrollView(
        child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          addAutomaticKeepAlives: false,
          itemBuilder: (context, index) {
            return containerOfUserInfo(
                widget.usersInfo[index], widget.isThatFollower);
          },
          separatorBuilder: (context, index) => const SizedBox(
            height: 10,
          ),
          itemCount: widget.usersInfo.length,
        ),
      );
    } else {
      return Center(
        child: Text(
          widget.emptyText,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      );
    }
  }

  Widget containerOfUserInfo(UserPersonalInfo userInfo, bool isThatFollower) {
    String hash = "${userInfo.userId.hashCode}userInfo";
    return InkWell(
      onTap: () async {
        Navigator.of(context).maybePop();
        await Go(context).push(
            page: WhichProfilePage(userId: userInfo.userId),
            withoutRoot: false);
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.only(start: 15, top: 15),
        child: Row(
          children: [
            Hero(
                tag: hash,
                child: CircleAvatarOfProfileImage(
                  userInfo: userInfo,
                  bodyHeight: 600,
                  hashTag: hash,
                  showColorfulCircle: widget.showColorfulCircle,
                )),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo.userName,
                    style: Theme.of(context).textTheme.displayMedium,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    userInfo.name,
                    style: Theme.of(context).textTheme.displayLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
            followButton(userInfo),
          ],
        ),
      ),
    );
  }

  Widget followButton(UserPersonalInfo userInfo) {
    return BlocBuilder<FollowUnFollowCubit, FollowUnFollowState>(
      builder: (followContext, stateOfFollow) {
        return Builder(builder: (userContext) {
          UserPersonalInfo myPersonalInfo =
              UserInfoCubit.getMyPersonalInfo(context);
          UserPersonalInfo? info =
              UsersInfoInReelTimeBloc.getMyInfoInReelTime(context);

          if (isMyInfoInReelTimeReady && info != null) myPersonalInfo = info;

          if (myPersonalId == userInfo.userId) {
            return Container();
          } else {
            return GestureDetector(
              onTap: () async {
                if (myPersonalInfo.followedPeople.contains(userInfo.userId)) {
                  await BlocProvider.of<FollowUnFollowCubit>(context)
                      .unFollowThisUser(
                          followingUserId: userInfo.userId,
                          myPersonalId: myPersonalId);
                  if (!mounted) return;
                  BlocProvider.of<UserInfoCubit>(context).updateMyFollowings(
                      userId: userInfo.userId, addThisUser: false);
                } else {
                  await BlocProvider.of<FollowUnFollowCubit>(context)
                      .followThisUser(
                          followingUserId: userInfo.userId,
                          myPersonalId: myPersonalId);
                  if (!mounted) return;
                  BlocProvider.of<UserInfoCubit>(context)
                      .updateMyFollowings(userId: userInfo.userId);
                }
              },
              child: whichText(stateOfFollow, userInfo, myPersonalInfo),
            );
          }
        });
      },
    );
  }

  Widget whichText(FollowUnFollowState stateOfFollow, UserPersonalInfo userInfo,
      UserPersonalInfo myPersonalInfo) {
    if (stateOfFollow is FollowThisUserFailed) {
      ToastMessage.toastStateError(stateOfFollow);
    }

    return !myPersonalInfo.followedPeople.contains(userInfo.userId)
        ? containerOfFollowText(
            text: StringsManager.follow.tr, isThatFollower: false)
        : containerOfFollowText(
            text: StringsManager.following.tr, isThatFollower: true);
  }

  Widget containerOfFollowText(
      {required String text, required bool isThatFollower}) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 45, end: 15),
      child: Container(
        height: 32.0,
        decoration: BoxDecoration(
          color: isThatFollower
              ? Theme.of(context).primaryColor
              : ColorManager.blue,
          border: isThatFollower
              ? Border.all(
                  color: Theme.of(context).bottomAppBarTheme.color!, width: 1.0)
              : null,
          borderRadius: BorderRadius.circular(isThatMobile ? 15 : 5),
        ),
        child: Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: isThatFollower ? 10.0 : 22),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 17.0,
                  color: isThatFollower
                      ? Theme.of(context).focusColor
                      : ColorManager.white,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ),
      ),
    );
  }
}
