import 'package:flutter/material.dart';
import 'package:instax/core/functions/date_reformats.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/presentation/cubit/user_info/message/cubit/message_cubit.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_circulars_progress_indicators.dart';

import '../../../core/resources/color_manager.dart';
import '../../../data/models/child_classes/post/post.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../cubit/user_info/user_info_cubit.dart';

class CustomShareButton extends StatefulWidget {
  final Post postInfo;
  final String textOfButton;
  final UserPersonalInfo? publisherInfo;
  final String publisherId;
  final TextEditingController messageTextController;
  final List<UserPersonalInfo> selectedUsersInfo;
  final ValueChanged<bool> clearTexts;
  const CustomShareButton(
      {super.key,
      required this.postInfo,
      required this.textOfButton,
      this.publisherInfo,
      required this.messageTextController,
      required this.selectedUsersInfo,
      required this.clearTexts,
      required this.publisherId});

  @override
  State<CustomShareButton> createState() => _CustomShareButtonState();
}

class _CustomShareButtonState extends State<CustomShareButton> {
  late UserPersonalInfo myPersonalInfo;
  final isThatLoading = ValueNotifier(false);

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Builder(builder: (context) {
        MessageCubit messageCubit = MessageCubit.get(context);
        return InkWell(
          onTap: () async {
            isThatLoading.value = true;
            for (final selectedUser in widget.selectedUsersInfo) {
              await messageCubit.sendMessage(
                  messageInfo: createSharedMessage(
                      widget.postInfo.blurHash, selectedUser));
              if (widget.messageTextController.text.isNotEmpty) {
                await messageCubit.sendMessage(
                    messageInfo: createCaptionMessage(selectedUser));
              }
            }

            await Navigator.of(context).maybePop();
            widget.clearTexts(true);
          },
          child: buildDoneButton(),
        );
      }),
    );
  }

  Message createCaptionMessage(UserPersonalInfo userInfoWhoIShared) {
    return Message(
      datePublished: DateReformat.dateOfNow(),
      message: widget.messageTextController.text,
      senderId: myPersonalId,
      receiversIds: [userInfoWhoIShared.userId],
      blurHash: "",
      isThatImage: false,
    );
  }

  Message createSharedMessage(
      String blurHash, UserPersonalInfo userInfoWhoIShared) {
    bool isThatImage = widget.postInfo.isThatImage;
    String imageUrl = isThatImage
        ? widget.postInfo.imagesUrls.length > 1
            ? widget.postInfo.imagesUrls[0]
            : widget.postInfo.postUrl
        : widget.postInfo.coverOfVideoUrl;
    var userId = userInfoWhoIShared.userId;

    return Message(
      datePublished: DateReformat.dateOfNow(),
      message: widget.postInfo.caption,
      senderId: myPersonalId,
      senderInfo: myPersonalInfo,
      blurHash: blurHash,
      receiversIds: [userId],
      isThatImage: true,
      isThatVideo: !isThatImage,
      sharedPostId: widget.postInfo.postUid,
      imageUrl: imageUrl,
      isThatPost: true,
      // ownerOfSharedPostId: widget.publisherInfo.userId,
      ownerOfSharedPostId: widget.publisherId,
      multiImages: widget.postInfo.imagesUrls.length > 1,
    );
  }

  Widget buildDoneButton() {
    return ValueListenableBuilder(
      valueListenable: isThatLoading,
      builder: (context, bool isThatLoadingValue, child) {
        return Container(
          height: 50,
          width: double.infinity,
          padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
          decoration: BoxDecoration(
            color:
                isThatLoadingValue ? ColorManager.lightBlue : ColorManager.blue,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Center(
            child: !isThatLoadingValue
                ? Text(
                    widget.textOfButton,
                    style: const TextStyle(
                        fontSize: 15.0,
                        color: ColorManager.white,
                        fontWeight: FontWeight.w500),
                  )
                : circularProgress(),
          ),
        );
      },
    );
  }

  Widget circularProgress() {
    return const Center(
      child: SizedBox(
        height: 20,
        width: 20,
        child: ThineCircularProgress(
          color: ColorManager.white,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
