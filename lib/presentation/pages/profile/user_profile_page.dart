import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/domain/entities/notification_check.dart';
import 'package:instax/presentation/cubit/follow_unfollow_cubit/follow_un_follow_cubit.dart';
import 'package:instax/presentation/cubit/user_info/message/bloc/message_bloc.dart';
import 'package:instax/presentation/pages/profile/widgets/bottom_sheet.dart';
import 'package:instax/presentation/pages/profile/widgets/profile_page.dart';
import 'package:instax/presentation/pages/profile/widgets/recommendationa_people.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/functions/date_reformats.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/resources/styles_manager.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/injector.dart';
import '../../../data/models/child_classes/notification.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../domain/entities/sender_receiver_info.dart';
import '../../cubit/notification_cubit/notification_cubit.dart';
import '../../cubit/user_info/user_info_cubit.dart';
import '../../responsive/web_screen_layout.dart';
import '../../widgets/custom_widgets/custom_appbar.dart';
import '../../widgets/custom_widgets/custom_circulars_progress_indicators.dart';
import '../messages/chatting_page.dart';

class UserProfilePage extends StatefulWidget {
  final String userId;
  final String userName;

  const UserProfilePage({Key? key, required this.userId, this.userName = ''})
      : super(key: key);

  @override
  State<UserProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<UserProfilePage> {
  ValueNotifier<bool> rebuildUserInfo = ValueNotifier(false);
  late UserPersonalInfo myPersonalInfo;
  late ValueNotifier<UserPersonalInfo> userInfo;

  @override
  initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  dispose() {
    rebuildUserInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Widget scaffold() {
    return ValueListenableBuilder(
      valueListenable: rebuildUserInfo,
      builder: (context, bool rebuildUserInfoValue, child) =>
          BlocBuilder<UserInfoCubit, UserInfoState>(
        bloc: widget.userName.isNotEmpty
            ? (BlocProvider.of<UserInfoCubit>(context)
              ..getUserFromUserName(widget.userName))
            : (BlocProvider.of<UserInfoCubit>(context)
              ..getUserInfo(widget.userId, isThatMyPersonalId: false)),
        buildWhen: (previous, current) {
          if (previous != current && current is UserLoaded) {
            return true;
          }
          if (rebuildUserInfoValue && current is UserLoaded) {
            rebuildUserInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is UserLoaded) {
            userInfo = ValueNotifier(state.userInfo);
            return Scaffold(
              appBar: isThatMobile
                  ? CustomAppBar.menuOfUserAppBar(
                      context, state.userInfo.userName, bottomSheet)
                  : null,
              body: ProfilePage(
                isThatMyPersonalId: false,
                userId: widget.userId,
                userInfo: userInfo,
                widgetsAboveTapBars: isThatMobile
                    ? widgetsAboveTapBarsForMobile(state)
                    : widgetsAboveTapBarsForWeb(state),
              ),
            );
          } else if (state is GetUserInfoFailed) {
            ToastMessage.toastStateError(state);
            return Text(
              StringsManager.somethingWrong.tr,
              style: Theme.of(context).textTheme.bodyLarge,
            );
          } else {
            return const ThineCircularProgress();
          }
        },
      ),
    );
  }

  Future<void> bottomSheet() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          headIcon: Container(),
          bodyText: buildTexts(),
        );
      },
    );
  }

  Padding buildTexts() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          textOfBottomSheet(StringsManager.report.tr),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.block.tr),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.aboutThisAccount.tr),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.restrict.tr),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.hideYourStory.tr),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.copyProfileURL.tr),
          const SizedBox(height: 15),
          textOfBottomSheet(StringsManager.shareThisProfile.tr),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Text textOfBottomSheet(String text) {
    return Text(text,
        style:
            getNormalStyle(fontSize: 15, color: Theme.of(context).focusColor));
  }

  List<Widget> widgetsAboveTapBarsForMobile(UserInfoState userInfoState) {
    return [
      followButton(userInfoState),
      const SizedBox(width: 5),
      messageButton(),
      const SizedBox(width: 5),
      const RecommendationPeople(),
      const SizedBox(width: 10),
    ];
  }

  List<Widget> widgetsAboveTapBarsForWeb(UserInfoState userInfoState) {
    return [
      const SizedBox(width: 20),
      messageButtonForWeb(),
      const SizedBox(width: 10),
      followButtonForWeb(),
    ];
  }

  Widget messageButtonForWeb() {
    return GestureDetector(
      onTap: () {
        setState(() => pageOfController = 1);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                WebScreenLayout(userInfoForMessagePage: userInfo.value),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: ColorManager.transparent,
          border: Border.all(
            color: ColorManager.lowOpacityGrey,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          StringsManager.message.tr,
          style: getMediumStyle(color: ColorManager.black),
        ),
      ),
    );
  }

  Widget followButtonForWeb() {
    return BlocBuilder<FollowUnFollowCubit, FollowUnFollowState>(
      builder: (context, stateOfFollow) {
        bool isThatFollowing =
            myPersonalInfo.followedPeople.contains(userInfo.value.userId);
        bool isFollowLoading = stateOfFollow is FollowThisUserLoading;
        Widget child = isFollowLoading
            ? const CupertinoActivityIndicator(color: ColorManager.black)
            : (isThatFollowing
                ? const Icon(
                    Icons.person,
                    color: ColorManager.black,
                    size: 18,
                  )
                : Text(
                    StringsManager.follow.tr,
                    style: getMediumStyle(color: ColorManager.white),
                  ));
        return ValueListenableBuilder(
          valueListenable: userInfo,
          builder: (__, UserPersonalInfo userInfoValue, _) => GestureDetector(
            onTap: () async => onTapFollowButton(userInfoValue),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: 9, vertical: isThatFollowing ? 4 : 6),
              decoration: BoxDecoration(
                color: isThatFollowing
                    ? ColorManager.transparent
                    : ColorManager.blue,
                border: isThatFollowing
                    ? Border.all(
                        color: ColorManager.lowOpacityGrey,
                        width: 1,
                      )
                    : null,
                borderRadius: BorderRadius.circular(3),
              ),
              child: child,
            ),
          ),
        );
      },
    );
  }

  Widget followButton(UserInfoState userInfoState) {
    return BlocBuilder<FollowUnFollowCubit, FollowUnFollowState>(
      builder: (context, stateOfFollow) {
        return ValueListenableBuilder(
          valueListenable: userInfo,
          builder: (context, UserPersonalInfo userInfoValue, child) => Expanded(
            child: InkWell(
                onTap: () async => onTapFollowButton(userInfoValue),
                child: whichContainerOfText(stateOfFollow, userInfoValue)),
          ),
        );
      },
    );
  }

  Widget whichContainerOfText(
      FollowUnFollowState stateOfFollow, UserPersonalInfo userInfoValue) {
    if (stateOfFollow is FollowThisUserFailed) {
      ToastMessage.toastStateError(stateOfFollow);
    }
    bool isThatFollower =
        myPersonalInfo.followerPeople!.contains(userInfoValue.userId);
    return !myPersonalInfo.followedPeople!.contains(userInfoValue.userId)
        ? containerOfFollowText(
            text: isThatFollower
                ? StringsManager.followBack.tr
                : StringsManager.follow,
            isThatFollowers: false,
          )
        : containerOfFollowText(
            text: StringsManager.following.tr,
            isThatFollowers: true,
          );
  }

  void onTapFollowButton(UserPersonalInfo userInfoValue) {
    if (myPersonalInfo.followedPeople!.contains(userInfoValue.userId)) {
      BlocProvider.of<FollowUnFollowCubit>(context).unFollowThisUser(
          followingUserId: userInfoValue.userId, myPersonalId: myPersonalId);
      myPersonalInfo.followedPeople!.remove(userInfoValue.userId);
      userInfo.value.followerPeople!.remove(myPersonalId);
      //for notification
      BlocProvider.of<NotificationCubit>(context).deleteNotification(
          notificationCheck: createNotificationCheck(userInfoValue));
    } else {
      BlocProvider.of<FollowUnFollowCubit>(context).followThisUser(
          followingUserId: userInfoValue.userId, myPersonalId: myPersonalId);
      myPersonalInfo.followedPeople!.add(userInfoValue.userId);
      userInfo.value.followerPeople!.add(myPersonalId);
      //for notification
      BlocProvider.of<NotificationCubit>(context).createNotification(
          newNotification: createNotification(userInfoValue));
    }
    setState(() {});
  }

  NotificationCheck createNotificationCheck(UserPersonalInfo userInfo) {
    return NotificationCheck(
      senderId: myPersonalId,
      receiverId: userInfo.userId,
      isThatLike: false,
      isThatPost: false,
    );
  }

  CustomNotification createNotification(UserPersonalInfo userInfo) {
    return CustomNotification(
      text: "started following you.",
      time: DateReformat.dateOfNow(),
      senderId: myPersonalId,
      receiverId: userInfo.userId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      isThatLike: false,
      isThatPost: false,
      senderName: myPersonalInfo.userName,
    );
  }

  Expanded messageButton() {
    return Expanded(
      child: GestureDetector(
        onTap: () async {
          Go(context).push(
              page: BlocProvider<GetMessagesBloc>(
            create: (context) => injector<GetMessagesBloc>(),
            child: ChattingPage(
                messageDetails: SenderInfo(receiversInfo: [userInfo.value])),
          ));
        },
        child: containerOfFollowText(
          text: StringsManager.message.tr,
          isThatFollowers: true,
        ),
      ),
    );
  }

  Container containerOfFollowText({
    required String text,
    required bool isThatFollowers,
  }) {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: isThatFollowers
            ? Theme.of(context).primaryColor
            : ColorManager.blue,
        border: Border.all(
            color: Theme.of(context).bottomAppBarTheme.color!,
            width: isThatFollowers ? 1.0 : 0),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 17.0,
              color: isThatFollowers
                  ? Theme.of(context).focusColor
                  : ColorManager.white,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
