import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/resources/strings_manager.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/domain/entities/sender_receiver_info.dart';
import 'package:instax/presentation/cubit/user_info/message/cubit/message_cubit.dart';
import 'package:instax/presentation/pages/agora_video_call/pick_up_call_page.dart';
import 'package:instax/presentation/pages/messages/widgets/chat_messages.dart';
import 'package:instax/presentation/widgets/circle_avatar_image/circle_avatar_of_profile_image.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_appbar.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_circulars_progress_indicators.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/utils/constants.dart';
import '../../../data/models/parent_classes/without_sub_classes/message.dart';
import '../profile/user_profile_page.dart';
import 'package:get/get.dart';

class ChattingPage extends StatefulWidget {
  final SenderInfo? messageDetails;
  final String chatUid;
  final bool isThatGroup;
  const ChattingPage(
      {super.key,
      this.messageDetails,
      this.chatUid = "",
      this.isThatGroup = false});

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage>
    with TickerProviderStateMixin {
  final ValueNotifier<Message?> deleteThisMessage = ValueNotifier(null);

  final unSend = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return widget.messageDetails != null
        ? scaffold(widget.messageDetails!)
        : getUserInfo(context);
  }

  Widget getUserInfo(BuildContext context) {
    return BlocBuilder<MessageCubit, MessageState>(
      bloc: MessageCubit.get(context)
        ..getSpecificChatInfo(
            chatUid: widget.chatUid, isThatGroup: widget.isThatGroup),
      buildWhen: (prev, curr) =>
          (prev != curr && curr is GetSpecificChatLoaded),
      builder: (context, state) {
        if (state is GetSpecificChatLoaded) {
          return scaffold(state.coverMessageDetails);
        } else if (state is GetMessageFailed) {
          ToastMessage.toastStateError(state);

          return Scaffold(
            body: Center(
              child: Text(StringsManager.somethingWrong.tr),
            ),
          );
        } else {
          return const Material(child: ThineCircularProgress());
        }
      },
    );
  }

  Scaffold scaffold(SenderInfo messageDetails) {
    return Scaffold(
      appBar: isThatMobile
          ? CustomAppBar.chattingAppBar(messageDetails.receiversInfo!, context)
          : null,
      body: GestureDetector(
          onTap: () {
            unSend.value = false;
            deleteThisMessage.value = null;
          },
          child: isThatMobile
              ? ChatMessages(messageDetails: messageDetails)
              : buildBodyForWeb(messageDetails)),
    );
  }

  Widget buildBodyForWeb(SenderInfo messageDetails) {
    return Column(
      children: [
        buildUserInfo(messageDetails.receiversInfo![0]),
        ChatMessages(messageDetails: messageDetails)
      ],
    );
  }

  Widget buildUserInfo(UserPersonalInfo userInfo) {
    return Column(
      children: [
        circleAvatarOfImage(userInfo),
        const SizedBox(height: 10),
        nameOfUser(userInfo),
        const SizedBox(height: 5),
        userName(userInfo),
        const SizedBox(height: 5),
        someInfoOfUser(userInfo),
        viewProfileButton(userInfo),
      ],
    );
  }

  Widget circleAvatarOfImage(UserPersonalInfo userInfo) {
    return CircleAvatarOfProfileImage(
      userInfo: userInfo,
      bodyHeight: 1000,
      showColorfulCircle: false,
      disablePressed: false,
    );
  }

  Row userName(UserPersonalInfo userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          userInfo.userName,
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 14,
              fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          "Instagram",
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontSize: 14,
              fontWeight: FontWeight.w300),
        ),
      ],
    );
  }

  Text nameOfUser(UserPersonalInfo userInfo) {
    return Text(
      userInfo.name,
      style: TextStyle(
          color: Theme.of(context).focusColor,
          fontSize: 16,
          fontWeight: FontWeight.w400),
    );
  }

  Row someInfoOfUser(UserPersonalInfo userInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${userInfo.followerPeople.length} ${StringsManager.followers.tr}",
          style: TextStyle(
              color: Theme.of(context).textTheme.titleSmall!.color,
              fontSize: 13),
        ),
        const SizedBox(
          width: 15,
        ),
        Text(
          "${userInfo.posts.length} ${StringsManager.posts.tr}",
          style: TextStyle(
              fontSize: 13,
              color: Theme.of(context).textTheme.titleSmall!.color),
        ),
      ],
    );
  }

  TextButton viewProfileButton(UserPersonalInfo userInfo) {
    return TextButton(
      onPressed: () {
        Go(context).push(page: UserProfilePage(userId: userInfo.userId));
      },
      child: Text(StringsManager.viewProfile.tr,
          style: TextStyle(
              color: Theme.of(context).focusColor,
              fontWeight: FontWeight.normal)),
    );
  }
}
