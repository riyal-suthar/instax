import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/utils/constants.dart';
import '../../../../data/models/child_classes/post/post.dart';
import '../../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../cubit/user_info/specifc_users_info_cubit.dart';
import '../../../cubit/user_info/user_info_cubit.dart';
import '../../../widgets/custom_widgets/custom_linears_progress.dart';
import '../../../widgets/custom_widgets/custom_share_button.dart';
import 'package:get/get.dart';

class SendToUsers extends StatefulWidget {
  final TextEditingController messageTextController;
  final UserPersonalInfo publisherInfo;
  final String publisherId;
  final Post postInfo;
  final ValueChanged<bool> clearTexts;
  final ValueNotifier<List<UserPersonalInfo>> selectedUsersInfo;
  final bool checkBox;
  final bool freezeListScroll;
  final VoidCallback? maxExtentUsersList;
  const SendToUsers({
    Key? key,
    this.checkBox = false,
    this.freezeListScroll = true,
    required this.publisherInfo,
    required this.clearTexts,
    this.maxExtentUsersList,
    required this.selectedUsersInfo,
    required this.messageTextController,
    required this.postInfo,
    required this.publisherId,
  }) : super(key: key);

  @override
  State<SendToUsers> createState() => _SendToUsersState();
}

class _SendToUsersState extends State<SendToUsers> {
  late UserPersonalInfo myPersonalInfo;
  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecificUsersInfoCubit, SpecificUsersInfoState>(
      bloc: BlocProvider.of<SpecificUsersInfoCubit>(context)
        ..getFollowersAndFollowingsInfo(
            followersIds: myPersonalInfo.followerPeople,
            followingsIds: myPersonalInfo.followedPeople),
      buildWhen: (previous, current) =>
          previous != current && (current is FollowersAndFollowingsLoaded),
      builder: (context, state) {
        if (state is FollowersAndFollowingsLoaded) {
          return buildBodyOfSheet(state);
        }
        if (state is SpecificUsersFailed) {
          ToastMessage.toastStateError(state);
          return Text(StringsManager.somethingWrong.tr);
        } else {
          return isThatMobile
              ? const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 1, child: ThineLinearProgress()),
                  ],
                )
              : const Scaffold(
                  body: SizedBox(height: 1, child: ThineLinearProgress()),
                );
        }
      },
    );
  }

  Widget buildBodyOfSheet(FollowersAndFollowingsLoaded state) {
    List<UserPersonalInfo> usersInfo =
        state.followersAndFollowingsInfo.followersInfo;
    for (final i in state.followersAndFollowingsInfo.followingsInfo) {
      if (!usersInfo.contains(i)) usersInfo.add(i);
    }
    return ValueListenableBuilder(
      valueListenable: widget.selectedUsersInfo,
      builder: (context, List<UserPersonalInfo> selectedUsersValue, child) {
        if (isThatMobile) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              buildUsers(usersInfo, selectedUsersValue),
              if (selectedUsersValue.isNotEmpty)
                CustomShareButton(
                  postInfo: widget.postInfo,
                  clearTexts: widget.clearTexts,
                  publisherInfo: widget.publisherInfo,
                  publisherId: widget.publisherId,
                  messageTextController: widget.messageTextController,
                  selectedUsersInfo: selectedUsersValue,
                  textOfButton: StringsManager.done,
                ),
            ],
          );
        } else {
          return buildUsers(usersInfo, selectedUsersValue);
        }
      },
    );
  }

  Padding buildUsers(List<UserPersonalInfo> usersInfo,
      List<UserPersonalInfo> selectedUsersValue) {
    return Padding(
      padding:
          EdgeInsetsDirectional.only(start: 20, bottom: isThatMobile ? 60 : 5),
      child: ListView.separated(
        shrinkWrap: widget.freezeListScroll,
        primary: !widget.freezeListScroll,
        physics: widget.freezeListScroll
            ? const NeverScrollableScrollPhysics()
            : null,
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: false,
        itemBuilder: (context, index) =>
            buildUserInfo(context, usersInfo[index], selectedUsersValue),
        itemCount: usersInfo.length,
        separatorBuilder: (context, _) => const SizedBox(height: 15),
      ),
    );
  }

  Row buildUserInfo(BuildContext context, UserPersonalInfo userInfo,
      List<UserPersonalInfo> selectedUsersValue) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor: ColorManager.customGrey,
          backgroundImage: userInfo.profileImageUrl.isNotEmpty
              ? CachedNetworkImageProvider(userInfo.profileImageUrl!,
                  maxWidth: 92, maxHeight: 92)
              : null,
          radius: 23,
          child: userInfo.profileImageUrl.isEmpty
              ? Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                  size: 25,
                )
              : null,
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userInfo.name,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                userInfo.userName,
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(end: 20),
          child: GestureDetector(
            onTap: () async {
              List<UserPersonalInfo> selectedUsers =
                  widget.selectedUsersInfo.value;
              setState(() {
                if (!selectedUsersValue.contains(userInfo)) {
                  selectedUsers.add(userInfo);
                } else {
                  selectedUsers.remove(userInfo);
                }

                if (widget.maxExtentUsersList != null &&
                    selectedUsers.length > 5) {
                  widget.maxExtentUsersList!();
                }

                widget.clearTexts(false);
              });
            },
            child: whichChild(context, selectedUsersValue.contains(userInfo)),
          ),
        ),
      ],
    );
  }

  Widget whichChild(BuildContext context, bool selectedUserValue) {
    return widget.checkBox
        ? checkBox(context, selectedUserValue)
        : whichContainerOfText(context, selectedUserValue);
  }

  Widget checkBox(BuildContext context, bool selectedUserValue) {
    return Container(
      padding: const EdgeInsetsDirectional.all(2),
      decoration: BoxDecoration(
        color: !selectedUserValue
            ? Theme.of(context).primaryColor
            : ColorManager.blue,
        border: Border.all(
            color: !selectedUserValue
                ? ColorManager.darkGray
                : ColorManager.transparent,
            width: 2),
        borderRadius: BorderRadius.circular(50.0),
      ),
      child: const Center(
        child: Icon(Icons.check_rounded, color: ColorManager.white, size: 17),
      ),
    );
  }

  Widget whichContainerOfText(BuildContext context, bool selectedUserValue) {
    return !selectedUserValue
        ? containerOfFollowText(context, StringsManager.send, selectedUserValue)
        : containerOfFollowText(
            context, StringsManager.undo, selectedUserValue);
  }

  Widget containerOfFollowText(
      BuildContext context, String text, bool selectedUserValue) {
    return Container(
      height: 30.0,
      padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
      decoration: BoxDecoration(
        color: selectedUserValue
            ? Theme.of(context).primaryColor
            : ColorManager.blue,
        border: Border.all(
          color:
              selectedUserValue ? ColorManager.grey : ColorManager.transparent,
        ),
        borderRadius: BorderRadius.circular(6.0),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 15.0,
              color: selectedUserValue
                  ? Theme.of(context).focusColor
                  : ColorManager.white,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
