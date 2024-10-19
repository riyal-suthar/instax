import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instax/config/routes/app_routes.dart';
import 'package:instax/core/utils/injector.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/notification/device_notification.dart';
import 'package:instax/data/models/child_classes/notification.dart';
import 'package:instax/domain/usecases/agora_usecases/get_call_channelId_usecase.dart';
import 'package:instax/presentation/cubit/callingRomms/calling_rooms_cubit.dart';
import 'package:instax/presentation/cubit/user_info/specifc_users_info_cubit.dart';
import 'package:instax/presentation/cubit/user_info/user_info_cubit.dart';
import 'package:instax/presentation/cubit/user_info/users_info_in_reel_time/users_info_in_reel_time_bloc.dart';
import 'package:instax/presentation/pages/agora_video_call/call_page.dart';
import 'package:instax/presentation/pages/messages/agora/video_call_screen.dart';
import 'package:instax/presentation/pages/messages/messages_page_for_mobile.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_gallery_display.dart';
import '../../../core/functions/appLogo.dart';
import '../../../core/functions/date_reformats.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/styles_manager.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../domain/entities/call_entity.dart';
import '../../cubit/agora_cubit/call/call_cubit.dart';
import '../../pages/activity/activity_for_mobile.dart';
import '../../pages/messages/agora/wait_call_page.dart';
import '../circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:http/http.dart' as http;

class CustomAppBar {
  static AppBar basicAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: const InstagramLogo(),
      actions: [
        _addList(context),
        _favoriteButton(context),
        _messengerButton(context),
        const SizedBox(width: 5),
      ],
    );
  }

  static Widget _messengerButton(BuildContext context) {
    return BlocBuilder<UsersInfoInReelTimeBloc, UsersInfoInReelTimeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 5.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  IconsAssets.messengerIcon,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).focusColor, BlendMode.srcIn),
                  height: 22.5,
                ),
                if (state is MyPersonalInfoLoaded &&
                    state.myPersonalInfoInReelTime.numberOfNewMessages > 0)
                  _redPoint(),
              ],
            ),
            onTap: () {
              Go(context).push(
                  page: BlocProvider<SpecificUsersInfoCubit>(
                create: (_) => injector<SpecificUsersInfoCubit>(),
                child: const MessagesPageForMobile(),
              ));
            },
          ),
        );
      },
    );
  }

  static Positioned _redPoint() {
    return Positioned(
      right: 1.5,
      top: 15,
      child: Container(
        width: 10,
        height: 10,
        decoration:
            const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
      ),
    );
  }

  static Widget _favoriteButton(BuildContext context) {
    return BlocBuilder<UsersInfoInReelTimeBloc, UsersInfoInReelTimeState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(end: 13.0),
          child: GestureDetector(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SvgPicture.asset(
                  IconsAssets.favorite,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).focusColor, BlendMode.srcIn),
                  height: 30,
                ),
                if (state is MyPersonalInfoLoaded &&
                    state.myPersonalInfoInReelTime.numberOfNewNotifications > 0)
                  _redPoint(),
              ],
            ),
            onTap: () {
              Go(context).push(page: const ActivityPage(), withoutRoot: false);
            },
          ),
        );
      },
    );
  }

  static GestureDetector _addList(BuildContext context) {
    return GestureDetector(
      onTap: () => _pushToCustomGallery(context),
      child: Padding(
        padding: const EdgeInsetsDirectional.only(end: 13.0),
        child: SvgPicture.asset(
          IconsAssets.add2Icon,
          colorFilter:
              ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          height: 22.5,
        ),
      ),
    );
  }

  static Future<void> _pushToCustomGallery(BuildContext context) async {
    await CustomImagePickerPlus.pickFromBoth(context);
  }

  static AppBar chattingAppBar(
      List<UserPersonalInfo> usersInfo, BuildContext context) {
    int length = usersInfo.length;
    length = length >= 3 ? 3 : length;
    return AppBar(
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      backgroundColor: Theme.of(context).primaryColor,
      title: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            if (length > 1) ...[
              _imagesOfGroupUsers(usersInfo)
            ] else ...[
              CircleAvatarOfProfileImage(
                  userInfo: usersInfo[0],
                  bodyHeight: 340,
                  showColorfulCircle: false),
            ],
            const SizedBox(width: 15),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(1, (index) {
                  return Text(
                    "${usersInfo[index].name}${length > 1 ? ", ..." : ""}",
                    style: TextStyle(
                        color: Theme.of(context).focusColor,
                        fontSize: 16,
                        fontWeight: FontWeight.normal),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
      actions: [
        GestureDetector(
          child: SvgPicture.asset(
            IconsAssets.phone,
            height: 27,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () async {
            UserPersonalInfo myPersonalInfo =
                UserInfoCubit.getMyPersonalInfo(context);
            amICalling = true;

            // without agora_uikit
            await Go(context).push(
                page: VideoCallPage(
                    usersInfo: usersInfo, myPersonalInfo: myPersonalInfo),
                withoutRoot: false,
                withoutPageTransition: true);

            // await CallingRoomsCubit.get(context).createCallingRoom(myPersonalInfo: myPersonalInfo, callThoseUser: usersInfo);
            // CustomNotification notification;
            //
            // usersInfo.forEach((element) async {
            //   notification = CustomNotification(
            //     text: "${myPersonalInfo.userName} is Calling you...",
            //     // postId: postInfo.postUid,
            //     // postImageUrl:
            //     // postInfo.isThatImage ? postInfo.postUrl : postInfo.coverOfVideoUrl!,
            //     time: DateReformat.dateOfNow(),
            //     personalUserName: myPersonalInfo.userName,
            //     personalProfileImageUrl: myPersonalInfo.profileImageUrl,
            //     senderName: myPersonalInfo.userName,
            //     receiverId: element.userId,
            //     senderId: myPersonalId,
            //     isThatLike: false,
            //     isThatPost: false,
            //   );
            //   await DeviceNotification.pushNotification(
            //       customNotification: notification, token: element.deviceToken);
            // });
            //
            // await Go(context).push(
            //     page: const VideoCallScreen(),
            //     withoutRoot: false,
            //     withoutPageTransition: true);

            // makeCall(context,
            //     callEntity: CallEntity(
            //       callerId: myPersonalInfo.userId,
            //       callerName: myPersonalInfo.userName,
            //       callerProfileUrl: myPersonalInfo.profileImageUrl,
            //       receiverId: usersInfo[0].userId,
            //       receiverName: usersInfo[0].userName,
            //       receiverProfileUrl: usersInfo[0].profileImageUrl,
            //     ));

            amICalling = false;
          },
          child: SvgPicture.asset(
            IconsAssets.videoPoint,
            height: 25,
            colorFilter:
                ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 15),
      ],
    );
  }

  // static Future<void> sendVideoCallPushNotification(
  //   UserPersonalInfo chatUser,
  // ) async {
  //   try {
  //     final body = {
  //       "to": chatUser.deviceToken,
  //       "notification": {
  //         "title": "me.name",
  //         "body": 'Incoming Call from ${"me.name"}',
  //         "android_channel_id": "chats",
  //       },
  //       "data": {
  //         "click_action": "FLUTTER_NOTIFICATION_CLICK",
  //         "some_data": "User ID: ${"me.id"}",
  //       },
  //     };
  //
  //     var response =
  //         await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //             headers: {
  //               HttpHeaders.contentTypeHeader:
  //                   'application/json; charset=UTF-8',
  //               HttpHeaders.authorizationHeader:
  //                   'key=AAAAfv393jU:APA91bGswPJx7mdyAgxSJH1W_qO-uxshvJYb1kAyJqCbvnPtj7I3XvKnwtbWECoDyFGIoePlzVleOsgEhC8JftHYPnO0spYH4c8cKoLVMgO8Qy1ycI7akLQcLdMQcZruueXd35Xf2RBR',
  //             },
  //             body: jsonEncode(body));
  //     print('Response status: ${response.statusCode}');
  //     print('Response body: ${response.body}');
  //   } catch (e) {
  //     print('\nsendPushNotification Error: $e');
  //   }
  // }

  // static Future<void> makeCall(BuildContext context,
  //     {required CallEntity callEntity}) async {
  //   BlocProvider.of<CallCubit>(context)
  //       .makeCall(
  //     CallEntity(
  //         callerId: callEntity.callerId,
  //         callerName: callEntity.callerName,
  //         callerProfileUrl: callEntity.callerProfileUrl,
  //         receiverId: callEntity.receiverId,
  //         receiverName: callEntity.receiverName,
  //         receiverProfileUrl: callEntity.receiverProfileUrl),
  //   )
  //       .then((value) {
  //     injector<GetCallChannelIdUseCase>()
  //         .call(callEntity.callerId!)
  //         .then((callChannelId) {
  //       Go(context).push(
  //           page: CallPage(
  //               callEntity: CallEntity(
  //         callId: callChannelId,
  //         callerId: callEntity.callerId,
  //         receiverId: callEntity.receiverId,
  //       )));
  //
  //       BlocProvider.of<CallCubit>(context).saveCallHistory(CallEntity(
  //           callId: callChannelId,
  //           callerId: callEntity.callerId,
  //           callerName: callEntity.callerName,
  //           callerProfileUrl: callEntity.callerProfileUrl,
  //           receiverId: callEntity.receiverId,
  //           receiverName: callEntity.receiverName,
  //           receiverProfileUrl: callEntity.receiverProfileUrl,
  //           isCallDialed: false,
  //           isMissed: false));
  //       print("callChannelId = $callChannelId");
  //     });
  //   });
  // }

  static Stack _imagesOfGroupUsers(List<UserPersonalInfo> userInfo) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 10,
          top: -6,
          child: CircleAvatarOfProfileImage(
            bodyHeight: 280,
            userInfo: userInfo[0],
            showColorfulCircle: false,
            disablePressed: false,
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: CircleAvatarOfProfileImage(
            bodyHeight: 280,
            userInfo: userInfo[1],
            showColorfulCircle: false,
            disablePressed: false,
          ),
        ),
      ],
    );
  }

  static AppBar oneTitleAppBar(BuildContext context, String text,
      {bool logoOfInstagram = false}) {
    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      centerTitle: false,
      iconTheme: IconThemeData(color: Theme.of(context).focusColor),
      title: logoOfInstagram
          ? const InstagramLogo()
          : Text(
              text,
              style: getMediumStyle(
                  color: Theme.of(context).focusColor, fontSize: 20),
            ),
    );
  }

  static AppBar menuOfUserAppBar(
      BuildContext context, String text, AsyncCallback bottomSheet) {
    return AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: Theme.of(context).focusColor),
        backgroundColor: Theme.of(context).primaryColor,
        title: Text(text,
            style: getMediumStyle(
                color: Theme.of(context).focusColor, fontSize: 20)),
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              IconsAssets.menuHorizontalIcon,
              colorFilter: ColorFilter.mode(
                  Theme.of(context).focusColor, BlendMode.srcIn),
              height: 22.5,
            ),
            onPressed: () => bottomSheet,
          ),
          const SizedBox(width: 5)
        ]);
  }
}
