import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/message.dart';
import 'package:instax/presentation/cubit/story_cubit/story_cubit.dart';
import 'package:instax/presentation/cubit/user_info/message/cubit/message_cubit.dart';
import 'package:instax/presentation/custom_packages/story_view/utils.dart';
import 'package:instax/presentation/pages/story/widgets/story_swipe.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../../config/routes/app_routes.dart';
import '../../../config/routes/hero_dialog_route.dart';
import '../../../core/functions/date_reformats.dart';
import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../core/utils/constants.dart';
import '../../../core/utils/injector.dart';
import '../../../data/models/child_classes/notification.dart';
import '../../../data/models/child_classes/post/story.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../domain/entities/notification_check.dart';
import '../../cubit/notification_cubit/notification_cubit.dart';
import '../../cubit/story_cubit/story_like_cubit/story_likes_cubit.dart';
import '../../cubit/user_info/user_info_cubit.dart';
import '../../custom_packages/story_view/story_controller.dart';
import '../../custom_packages/story_view/story_view.dart';
import '../../widgets/circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../profile/users_who_like_for_mobile.dart';
import '../profile/users_who_like_for_web.dart';

class StoryPageForMobile extends StatefulWidget {
  final UserPersonalInfo user;
  final List<UserPersonalInfo> storiesOwnersInfo;
  final String hashTag;

  const StoryPageForMobile({
    required this.user,
    required this.storiesOwnersInfo,
    this.hashTag = "",
    Key? key,
  }) : super(key: key);

  @override
  StoryPageForMobileState createState() => StoryPageForMobileState();
}

class StoryPageForMobileState extends State<StoryPageForMobile> {
  late PageController controller;

  @override
  void initState() {
    super.initState();

    final initialPage = widget.storiesOwnersInfo.indexOf(widget.user);
    controller = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.black,
      body: SafeArea(
        child: StorySwipe(
          controller: controller,
          children: widget.storiesOwnersInfo
              .map((user) => StoryWidget(
                    storiesOwnersInfo: widget.storiesOwnersInfo,
                    user: user,
                    controller: controller,
                    hashTag: widget.hashTag,
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class StoryWidget extends StatefulWidget {
  final UserPersonalInfo user;
  final PageController controller;
  final List<UserPersonalInfo> storiesOwnersInfo;
  final String hashTag;

  const StoryWidget({
    Key? key,
    required this.user,
    required this.storiesOwnersInfo,
    required this.controller,
    required this.hashTag,
  }) : super(key: key);

  @override
  StoryWidgetState createState() => StoryWidgetState();
}

class StoryWidgetState extends State<StoryWidget> {
  final SharedPreferences _sharePrefs = injector<SharedPreferences>();

  final _textController = ValueNotifier(TextEditingController());
  final storyIndex = ValueNotifier<int>(0);
  final isSending = ValueNotifier(false);

  bool shownThem = true;
  final storyItems = <StoryItem>[];
  ValueNotifier<StoryController> controller = ValueNotifier(StoryController());
  ValueNotifier<double> opacityLevel = ValueNotifier(1.0);
  ValueNotifier<Story?> date = ValueNotifier(null);

  void addStoryItems() {
    for (final story in widget.user.storiesInfo!) {
      storyItems.add(
        StoryItem.inlineImage(
          roundedBottom: false,
          roundedTop: false,
          isThatImage: story.isThatImage,
          blurHash: story.blurHash,
          url: story.storyUrl,
          controller: controller.value,
          imageFit: BoxFit.fitWidth,
          caption: Text(story.caption),
          duration: const Duration(milliseconds: 5000),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    addStoryItems();
    date.value = widget.user.storiesInfo![0];
  }

  @override
  void dispose() {
    controller.dispose();
    isSending.dispose();
    super.dispose();
  }

  void handleCompleted() async {
    _sharePrefs.setBool(widget.user.userId, true);

    widget.controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );

    final currentIndex = widget.storiesOwnersInfo.indexOf(widget.user);
    final isLastPage = widget.storiesOwnersInfo.length - 1 == currentIndex;

    if (isLastPage) {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GestureDetector(
              onLongPressStart: (e) {
                controller.value.pause();
                opacityLevel.value = 0;
              },
              onLongPressEnd: (e) {
                opacityLevel.value = 1;
                controller.value.play();
              },
              child: ValueListenableBuilder(
                valueListenable: opacityLevel,
                builder: (context, double opacityLevelValue, child) => Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Material(
                      type: MaterialType.transparency,
                      child: ValueListenableBuilder(
                        valueListenable: controller,
                        builder: (context, StoryController storyControllerValue,
                                child) =>
                            StoryView(
                          inline: true,
                          opacityLevel: opacityLevelValue,
                          progressPosition: ProgressPosition.top,
                          storyItems: storyItems,
                          controller: storyControllerValue,
                          onComplete: handleCompleted,
                          onVerticalSwipeComplete: (direction) {
                            if (direction == Direction.down ||
                                direction == Direction.up) {
                              Navigator.of(context).maybePop();
                            }
                          },
                          onStoryShow: (storyItem) {
                            final index = storyItems.indexOf(storyItem);

                            storyIndex.value = index;

                            final isLastPage = storyItems.length - 1 == index;
                            if (isLastPage) {
                              _sharePrefs.setBool(widget.user.userId, true);
                            }
                            if (index > 0) {
                              date.value = widget.user.storiesInfo![index];
                            }
                          },
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: opacityLevelValue,
                      duration: const Duration(milliseconds: 250),
                      child: ValueListenableBuilder(
                        valueListenable: date,
                        builder: (context, Story? value, child) =>
                            ProfileWidget(
                          user: widget.user,
                          storyInfo: value!,
                          hashTag: widget.hashTag,
                        ),
                      ),
                    ),
                    AnimatedOpacity(
                      opacity: opacityLevelValue,
                      duration: const Duration(milliseconds: 250),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsetsDirectional.all(15.0),
                          child: widget.user.userId == myPersonalId
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                            '${widget.user.storiesInfo![storyIndex.value].likes.length}'),
                                        const Icon(CupertinoIcons.heart),
                                      ],
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          var storyInfo = widget.user
                                              .storiesInfo![storyIndex.value];
                                          if (isThatMobile) {
                                            Go(context).push(
                                                page: UsersWhoLikesForMobile(
                                              showSearchBar: true,
                                              usersIds: storyInfo.likes,
                                              isThatMyPersonalId:
                                                  storyInfo.publisherId ==
                                                      myPersonalId,
                                            ));
                                          } else {
                                            Navigator.of(context).push(
                                              HeroDialogRoute(
                                                builder: (context) =>
                                                    UsersWhoLikesForWeb(
                                                  usersIds: storyInfo.likes,
                                                  isThatMyPersonalId:
                                                      storyInfo.publisherId ==
                                                          myPersonalId,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        icon: const Icon(
                                            Icons.remove_red_eye_outlined)),
                                    IconButton(
                                      onPressed: () async {
                                        await BlocProvider.of<StoryCubit>(
                                                context)
                                            .deleteStory(
                                                storyId: widget
                                                    .user
                                                    .storiesInfo![
                                                        storyIndex.value]
                                                    .storyUid);
                                      },
                                      icon: const Icon(
                                        Icons.delete_rounded,
                                        color: Colors.white,
                                        size: 25,
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(35),
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 0.5,
                                          ),
                                        ),
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        height: 40,
                                        child: Padding(
                                          padding:
                                              const EdgeInsetsDirectional.only(
                                                  start: 8.0, end: 20),
                                          child: Center(
                                            child: TextFormField(
                                              controller: _textController.value,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              cursorColor: Colors.teal,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                              onTap: () {
                                                controller.value.pause();
                                              },
                                              showCursor: true,
                                              maxLines: null,
                                              decoration:
                                                  InputDecoration.collapsed(
                                                hintText: StringsManager
                                                    .sendMessage.tr,
                                                border: InputBorder.none,
                                                hintStyle: const TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              autofocus: false,
                                              cursorWidth: 1.5,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 25),
                                    loveButton(widget
                                        .user.storiesInfo![storyIndex.value]),
                                    const SizedBox(width: 25),
                                    sendButton(),
                                  ],
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget sendButton() {
    return GestureDetector(
      onTap: () async {
        if (_textController.value.text.isNotEmpty) {
          var messageCubit = MessageCubit.get(context);

          await messageCubit.sendMessage(
              messageInfo: createSharedMessage("", widget.user));
          if (_textController.value.text.isNotEmpty) {
            await messageCubit.sendMessage(
                messageInfo: createCaptionMessage(
                    _textController.value.text, widget.user));
          }
          if (!mounted) return;

          _textController.value.text = "";
        }
      },
      child: SvgPicture.asset(
        IconsAssets.send2Icon,
        colorFilter:
            const ColorFilter.mode(ColorManager.white, BlendMode.srcIn),
        height: 23,
      ),
    );
  }

  Widget loveButton(Story storyInfo) {
    bool isLiked = storyInfo.likes.contains(myPersonalId);
    return GestureDetector(
      onTap: () async {
        setState(() {
          if (isLiked) {
            BlocProvider.of<StoryLikesCubit>(context).removeLikeOnThisStory(
                storyId: storyInfo.storyUid, userId: myPersonalId);
            storyInfo.likes.remove(myPersonalId);

            BlocProvider.of<NotificationCubit>(context).deleteNotification(
                notificationCheck: createNotificationCheck(storyInfo));
          } else {
            BlocProvider.of<StoryLikesCubit>(context).putLikeOnThisStory(
                storyId: storyInfo.storyUid, userId: myPersonalId);
            storyInfo.likes.add(myPersonalId);

            BlocProvider.of<NotificationCubit>(context).createNotification(
                newNotification: createNotification(storyInfo));
          }
        });
      },
      child: !isLiked
          ? Icon(
              Icons.favorite_border,
              color: Theme.of(context).focusColor,
            )
          : const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
    );
  }

  NotificationCheck createNotificationCheck(Story storyInfo) {
    return NotificationCheck(
      senderId: myPersonalId,
      receiverId: storyInfo.publisherId,
      postId: storyInfo.storyUid,
    );
  }

  CustomNotification createNotification(Story storyInfo) {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);

    return CustomNotification(
      text: "liked your story.",
      postId: storyInfo.storyUid,
      postImageUrl: storyInfo.storyUrl,
      time: DateReformat.dateOfNow(),
      senderId: myPersonalId,
      receiverId: storyInfo.publisherId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      senderName: myPersonalInfo.userName,
    );
  }

  Message createCaptionMessage(
      messageController, UserPersonalInfo userInfoWhoIShared) {
    return Message(
      datePublished: DateReformat.dateOfNow(),
      message: messageController,
      senderId: myPersonalId,
      receiversIds: [userInfoWhoIShared.userId],
      blurHash: "",
      isThatImage: false,
    );
  }

  Message createSharedMessage(
      String blurHash, UserPersonalInfo userInfoWhoIShared) {
    var userStory = userInfoWhoIShared.storiesInfo![storyIndex.value];
    bool isThatImage = userStory.isThatImage;
    // String imageUrl = isThatImage
    //     ? userStory.imagesUrls.length > 1
    //     ? userStory.imagesUrls[0]
    //     : userStory.postUrl
    //     : userStory.coverOfVideoUrl;

    String storyUrl = userStory.storyUrl;

    var userId = userInfoWhoIShared.userId;

    return Message(
      datePublished: DateReformat.dateOfNow(),
      message: userStory.caption,
      senderId: myPersonalId,
      // senderInfo: myPersonalInfo,
      blurHash: blurHash,
      receiversIds: [userId],
      isThatImage: true,
      isThatVideo: !isThatImage,
      sharedPostId: userStory.storyUid,
      imageUrl: storyUrl,
      isThatPost: true,
      // ownerOfSharedPostId: widget.publisherInfo.userId,
      ownerOfSharedPostId: userId,
      // multiImages: userStory.imagesUrls.length > 1,
    );
  }
}

class ProfileWidget extends StatelessWidget {
  final UserPersonalInfo user;
  final Story storyInfo;
  final String hashTag;

  const ProfileWidget({
    required this.user,
    required this.storyInfo,
    required this.hashTag,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsetsDirectional.only(
              start: 16, end: 16, top: 20, bottom: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (hashTag.isEmpty) ...[
                buildCircleAvatar()
              ] else ...[
                Hero(
                  tag: hashTag,
                  child: buildCircleAvatar(),
                ),
              ],
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      DateReformat.oneDigitFormat(storyInfo.datePublished),
                      style: const TextStyle(color: Colors.white38),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget buildCircleAvatar() {
    return CircleAvatarOfProfileImage(
      bodyHeight: 500,
      userInfo: user,
      showColorfulCircle: false,
      disablePressed: true,
    );
  }
}
