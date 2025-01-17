import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instax/config/routes/hero_dialog_route.dart';
import 'package:instax/core/functions/date_reformats.dart';
import 'package:instax/core/resources/assets_manager.dart';
import 'package:instax/core/resources/styles_manager.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/presentation/cubit/follow_unfollow_cubit/follow_un_follow_cubit.dart';
import 'package:instax/presentation/pages/comments/comments_for_mobile.dart';
import 'package:instax/presentation/pages/profile/widgets/which_profile_page.dart';
import 'package:instax/presentation/widgets/other_widgets/play_this_video.dart';
import 'package:instax/presentation/widgets/other_widgets/share_button.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/resources/color_manager.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../data/models/child_classes/notification.dart';
import '../../../data/models/child_classes/post/post.dart';
import '../../../data/models/parent_classes/without_sub_classes/comment.dart';
import '../../../data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import '../../../domain/entities/notification_check.dart';
import '../../cubit/notification_cubit/notification_cubit.dart';
import '../../cubit/postInfo_cubit/like_cubit/post_likes_cubit.dart';
import '../../cubit/postInfo_cubit/post_cubit.dart';
import '../../cubit/user_info/user_info_cubit.dart';
import '../../pages/comments/widgets/comment_box.dart';
import '../../pages/comments/widgets/comment_of_post.dart';
import '../../pages/profile/widgets/bottom_sheet.dart';
import '../../pages/time_line/my_own_timeline/update_post_info.dart';
import '../../pages/time_line/widgets/image_slider.dart';
import '../../pages/time_line/widgets/points_scroll_bar.dart';
import '../aniamtion/like_popup_animation.dart';
import '../circle_avatar_image/circle_avatar_name.dart';
import '../circle_avatar_image/circle_avatar_of_profile_image.dart';
import '../custom_widgets/custom_network_image_display.dart';
import '../popup_widgets/common/jump_arrow.dart';
import '../popup_widgets/common/volume_icon.dart';
import '../popup_widgets/web/menu_card.dart';
import 'count_of_likes.dart';
import 'package:get/get.dart';

class ImageOfPost extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final bool playTheVideo;
  final VoidCallback? reloadData;
  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;
  final VoidCallback? rebuildPreviousWidget;

  final bool popupWebContainer;
  final bool showSliderArrow;
  final ValueNotifier<TextEditingController> textController;
  final ValueNotifier<Comment?> selectedCommentInfo;
  final ValueChanged<int>? removeThisPost;

  const ImageOfPost(
      {super.key,
      required this.postInfo,
      required this.playTheVideo,
      this.reloadData,
      required this.indexOfPost,
      required this.postsInfo,
      this.rebuildPreviousWidget,
      this.popupWebContainer = false,
      this.showSliderArrow = false,
      required this.textController,
      required this.selectedCommentInfo,
      this.removeThisPost});

  @override
  State<ImageOfPost> createState() => _ImageOfPostState();
}

class _ImageOfPostState extends State<ImageOfPost>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<TextEditingController> commentTextController =
      ValueNotifier(TextEditingController());
  ValueChanged<Post>? selectedPostInfo;

  ValueNotifier<bool> isSaved = ValueNotifier(false);
  ValueNotifier<int> initPosition = ValueNotifier(0);
  bool showCommentBox = false;
  bool isSoundOn = true;

  late bool playTheVideo;

  bool isHeartAnimation = false;

  @override
  void initState() {
    playTheVideo = widget.playTheVideo;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ImageOfPost oldWidget) {
    playTheVideo = widget.playTheVideo;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    commentTextController.dispose();
    initPosition.dispose();
    isSaved.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.popupWebContainer
        ? buildPostForMobile(bodyHeight: 700)
        : buildPostForWeb(bodyHeight: 700);
  }

  pushToProfilePage(Post postInfo) {
    if (widget.popupWebContainer) {
      Navigator.of(context).maybePop();
    }
    return Go(context)
        .push(page: WhichProfilePage(userId: postInfo.publisherId));
  }

  Widget buildPostForMobile({required double bodyHeight}) {
    return SizedBox(
      width: double.infinity,
      child: buildNormalPostDisplay(bodyHeight),
    );
  }

  ValueListenableBuilder<Post> buildNormalPostDisplay(double bodyHeight) {
    return ValueListenableBuilder(
      valueListenable: widget.postInfo,
      builder: (context, Post postInfoValue, child) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
            child: buildPublisherInfo(bodyHeight, postInfoValue),
          ),
          imageOfPost(postInfoValue),
          Padding(
            padding:
                const EdgeInsetsDirectional.only(start: 8, top: 10, bottom: 8),
            child: buildPostInteraction(postInfoValue, showScrollBar: true),
          ),
          if (!isThatMobile && widget.popupWebContainer)
            ...likesAndCommentBox(postInfoValue),
        ],
      ),
    );
  }

  List<Widget> likesAndCommentBox(Post postInfoValue) {
    double withOfScreen = MediaQuery.of(context).size.width;
    bool minimumWidth = withOfScreen > 800;
    return [
      if (postInfoValue.likes.isNotEmpty)
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10),
          child: CountOfLikes(postInfo: postInfoValue),
        ),
      Padding(
        padding: const EdgeInsetsDirectional.all(10),
        child: Text(
          DateReformat.fullDigitsFormat(
              postInfoValue.datePublished, postInfoValue.datePublished),
          style:
              getNormalStyle(color: Theme.of(context).bottomAppBarTheme.color!),
        ),
      ),
      if (showCommentBox || minimumWidth)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: CommentBox(
            postInfo: widget.postInfo,
            selectedCommentInfo: widget.selectedCommentInfo,
            textController: widget.textController.value,
            userPersonalInfo: UserInfoCubit.getMyPersonalInfo(context),
            expandCommentBox: true,
            currentFocus: ValueNotifier(FocusScopeNode()),
            makeSelectedCommentNullable: makeSelectedCommentNullable,
          ),
        ),
    ];
  }

  Row buildPostInteraction(Post postInfoValue, {bool showScrollBar = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        loveButton(postInfoValue),
        const SizedBox(width: 5),
        commentButton(context, postInfoValue),
        ShareButton(postInfo: ValueNotifier(postInfoValue)),
        const Spacer(),
        if (postInfoValue.imagesUrls.length > 1 && showScrollBar)
          scrollBar(postInfoValue),
        const Spacer(),
        const Spacer(),
        saveButton(),
      ],
    );
  }

  buildPublisherInfo(double bodyHeight, Post postInfoValue,
      {bool makeCircleAvatarBigger = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatarOfProfileImage(
          bodyHeight:
              makeCircleAvatarBigger ? bodyHeight * .6 : bodyHeight * .5,
          userInfo: postInfoValue.publisherInfo,
        ),
        const SizedBox(width: 5),
        GestureDetector(
          onTap: () => pushToProfilePage(postInfoValue),
          child: NameOfCircleAvatar(postInfoValue.publisherInfo!.name, false),
        ),
        const Spacer(),
        menuButton()
      ],
    );
  }

  Widget buildPostForWeb({required double bodyHeight}) {
    return GestureDetector(
      onTap: () {
        showCommentBox = false;
        Navigator.of(context).maybePop();
      },
      child: Scaffold(
        backgroundColor: ColorManager.black38,
        body: GestureDetector(
          /// Don't remove this,it's for avoid pop when tap in popup post
          onTap: () {},
          child: Stack(
            alignment: Alignment.center,
            children: [
              buildPopupContainer(bodyHeight),
              closeButton(),
              if (widget.showSliderArrow) ...[
                if (widget.indexOfPost != 0) buildJumpArrow(),
                if (widget.indexOfPost < widget.postsInfo.value.length - 1)
                  buildJumpArrow(isThatBack: false),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildJumpArrow({bool isThatBack = true}) {
    return GestureDetector(
      onTap: () async {
        int index =
            isThatBack ? widget.indexOfPost - 1 : widget.indexOfPost + 1;
        await Navigator.of(context).maybePop();
        if (!mounted) return;
        Navigator.of(context).push(
          HeroDialogRoute(
            builder: (context) => ImageOfPost(
              postInfo: ValueNotifier(widget.postsInfo.value[index]),
              playTheVideo: playTheVideo,
              indexOfPost: index,
              postsInfo: widget.postsInfo,
              rebuildPreviousWidget: widget.rebuildPreviousWidget,
              reloadData: widget.reloadData,
              removeThisPost: widget.removeThisPost,
              popupWebContainer: true,
              showSliderArrow: true,
              selectedCommentInfo: widget.selectedCommentInfo,
              textController: ValueNotifier(TextEditingController()),
            ),
          ),
        );
      },
      child: ArrowJump(isThatBack: isThatBack, makeArrowBigger: true),
    );
  }

  Padding buildPopupContainer(double bodyHeight) {
    double withOfScreen = MediaQuery.of(context).size.width;
    bool minimumWidth = withOfScreen > 800;
    Post postInfoValue = widget.postInfo.value;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80.0),
      child: Center(
        child: !minimumWidth
            ? Container(
                width: 300,
                padding: const EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: ColorManager.white),
                child: buildNormalPostDisplay(bodyHeight))
            : SizedBox(
                height: withOfScreen / 2,
                width: minimumWidth ? 1270 : 800,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => playTheVideo = !playTheVideo);
                        },
                        child: Container(
                          height: double.infinity,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                topLeft: Radius.circular(5)),
                            color: ColorManager.black,
                          ),
                          child: imageOfPost(widget.postInfo.value),
                        ),
                      ),
                    ),
                    Container(
                      height: withOfScreen / 2,
                      width: 500,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(5),
                            topRight: Radius.circular(5)),
                        color: ColorManager.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                    color: ColorManager.black38, width: 0.08),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: buildPublisherInfo(
                                bodyHeight,
                                postInfoValue,
                                makeCircleAvatarBigger: true,
                              ),
                            ),
                          ),
                          CommentsOfPost(
                            postInfo: widget.postInfo,
                            selectedCommentInfo: widget.selectedCommentInfo,
                            textController: widget.textController,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    color: ColorManager.black38, width: 0.08),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(
                                  start: 10, top: 10, bottom: 8),
                              child: buildPostInteraction(postInfoValue),
                            ),
                          ),
                          ...likesAndCommentBox(postInfoValue),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Padding closeButton() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GestureDetector(
        onTap: () {
          showCommentBox = false;
          Navigator.of(context).maybePop();
        },
        child: const Align(
          alignment: Alignment.topRight,
          child: Icon(
            Icons.close_rounded,
            size: 26,
            color: ColorManager.white,
          ),
        ),
      ),
    );
  }

  makeSelectedCommentNullable(bool isThatComment) {
    setState(() {
      widget.selectedCommentInfo.value = null;
      widget.textController.value.text = '';
    });
  }

  SizedBox buildSizedBox() => SizedBox(
        width: double.infinity,
        height: 50,
        child: Text("Yes", style: getNormalStyle(color: ColorManager.black)),
      );

  Widget loveButton(Post postInfo) {
    bool isLiked = postInfo.likes.contains(myPersonalId);
    return GestureDetector(
      onTap: () async {
        setState(() {
          if (isLiked) {
            BlocProvider.of<PostLikesCubit>(context).removeLikeOnThisPost(
                postId: postInfo.postUid, userId: myPersonalId);
            postInfo.likes.remove(myPersonalId);
            if (widget.rebuildPreviousWidget != null) {
              widget.rebuildPreviousWidget!();
            }

            BlocProvider.of<NotificationCubit>(context).deleteNotification(
                notificationCheck: createNotificationCheck(postInfo));
          } else {
            BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                postId: postInfo.postUid, userId: myPersonalId);
            postInfo.likes.add(myPersonalId);
            if (widget.rebuildPreviousWidget != null) {
              widget.rebuildPreviousWidget!();
            }
            BlocProvider.of<NotificationCubit>(context).createNotification(
                newNotification: createNotification(postInfo));
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

  NotificationCheck createNotificationCheck(Post postInfo) {
    return NotificationCheck(
      senderId: myPersonalId,
      receiverId: postInfo.publisherId,
      postId: postInfo.postUid,
    );
  }

  CustomNotification createNotification(Post postInfo) {
    UserPersonalInfo myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);

    return CustomNotification(
      text: " liked your photo.",
      postId: postInfo.postUid,
      postImageUrl: postInfo.isThatImage
          ? (postInfo.imagesUrls.length > 1
              ? postInfo.imagesUrls[0]
              : postInfo.postUrl)
          : postInfo.coverOfVideoUrl,
      time: DateReformat.dateOfNow(),
      senderId: myPersonalId,
      receiverId: postInfo.publisherId,
      personalUserName: myPersonalInfo.userName,
      personalProfileImageUrl: myPersonalInfo.profileImageUrl,
      senderName: myPersonalInfo.userName,
    );
  }

  ValueListenableBuilder<int> scrollBar(Post postInfoValue) {
    return ValueListenableBuilder(
      valueListenable: initPosition,
      builder: (context, int positionValue, child) => PointsScrollBar(
        photoCount: postInfoValue.imagesUrls.length,
        activePhotoIndex: positionValue,
      ),
    );
  }

  SvgPicture iconsOfImagePost(String path, {bool lowHeight = false}) {
    return SvgPicture.asset(
      path,
      colorFilter:
          ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
      height: lowHeight ? 22 : 28,
    );
  }

  Widget imageOfPost(Post postInfo) {
    bool isLiked = postInfo.likes.contains(myPersonalId);
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: GestureDetector(
            onDoubleTap: () {
              setState(() {
                isHeartAnimation = true;
                if (!isLiked) {
                  BlocProvider.of<PostLikesCubit>(context).putLikeOnThisPost(
                      postId: postInfo.postUid, userId: myPersonalId);
                  postInfo.likes.add(myPersonalId);

                  if (widget.rebuildPreviousWidget != null) {
                    widget.rebuildPreviousWidget!();
                  }
                  BlocProvider.of<NotificationCubit>(context)
                      .createNotification(
                          newNotification: createNotification(postInfo));
                }
              });
            },
            child: Padding(
              padding: const EdgeInsetsDirectional.only(top: 8.0),
              child: postInfo.imagesUrls.length > 1
                  ? ImagesSlider(
                      blurHash: postInfo.blurHash,
                      aspectRatio: postInfo.aspectRatio!,
                      imagesUrls: postInfo.imagesUrls,
                      updateImageIndex: _updateImageIndex,
                      showPointsScrollBar: widget.popupWebContainer,
                    )
                  : (postInfo.isThatImage
                      ? buildSingleImage(postInfo)
                      : videoPlayer(postInfo)),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Opacity(
            opacity: isHeartAnimation ? 1 : 0,
            child: LikePopupAnimation(
              isAnimating: isHeartAnimation,
              duration: const Duration(milliseconds: 700),
              child: const Icon(Icons.favorite,
                  color: ColorManager.white, size: 100),
              onEnd: () => setState(() => isHeartAnimation = false),
            ),
          ),
        ),
      ],
    );
  }

  Stack videoPlayer(Post postInfo) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PlayThisVideo(
          videoUrl: postInfo.postUrl,
          blurHash: postInfo.blurHash,
          play: playTheVideo,
          withoutSound: !isSoundOn,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: GestureDetector(
              onTap: () => setState(() => isSoundOn = !isSoundOn),
              child: VolumeIcon(isVolumeOn: isSoundOn),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Icon(
            Icons.play_arrow_rounded,
            color: playTheVideo ? ColorManager.transparent : ColorManager.white,
            size: isThatMobile ? 100 : 200,
          ),
        ),

        // Positioned(
        //   top: 10,
        //   child: SizedBox(
        //       width: MediaQuery.of(context).size.width,
        //       child: Padding(
        //         padding: const EdgeInsetsDirectional.only(start: 10, end: 10),
        //         child: buildPublisherInfo(700, postInfo),
        //       )),
        // ),
      ],
    );
  }

  Widget buildSingleImage(Post postInfo) {
    return NetworkDisplay(
      blurHash: postInfo.blurHash,
      aspectRatio: postInfo.aspectRatio!,
      url: postInfo.postUrl,
      isThatImage: postInfo.isThatImage,
    );
  }

  void _updateImageIndex(int index, _) {
    initPosition.value = index;
  }

  Widget menuButton() {
    return GestureDetector(
      child: SvgPicture.asset(
        !isThatMobile
            ? IconsAssets.menuHorizontal2Icon
            : IconsAssets.menuHorizontalIcon,
        colorFilter:
            ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
        height: 23,
      ),
      onTap: () async => isThatMobile ? bottomSheet() : popupContainerForWeb(),
    );
  }

  Future<void> bottomSheet() async {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return CustomBottomSheet(
          headIcon: ShareButton(
            postInfo: widget.postInfo,
            shareWidget: shareWidget(),
          ),
          bodyText: widget.postInfo.value.publisherId == myPersonalId
              ? ordersOfMyPost()
              : ordersOfOtherUser(),
        );
      },
    );
  }

  popupContainerForWeb() => Navigator.of(context).push(
        HeroDialogRoute(
          builder: (context) => const PopupMenuCard(),
        ),
      );

  Column shareWidget() {
    return Column(
      children: [
        SvgPicture.asset(
          IconsAssets.shareCircle,
          height: 50,
          colorFilter:
              ColorFilter.mode(Theme.of(context).focusColor, BlendMode.srcIn),
        ),
        const SizedBox(height: 10),
        buildText(StringsManager.share.tr),
      ],
    );
  }

  Widget ordersOfMyPost() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textOfOrders(StringsManager.archive.tr),
            deletePost(postInfoValue),
            editPost(postInfoValue),
            textOfOrders(StringsManager.hideLikeCount.tr),
            textOfOrders(StringsManager.turnOffCommenting.tr),
            Container(height: 10)
          ],
        ),
      ),
    );
  }

  BlocBuilder<PostCubit, PostState> deletePost(Post postInfoValue) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return GestureDetector(
          onTap: () async {
            Navigator.of(context).maybePop();
            await PostCubit.get(context).deletePost(postInfo: postInfoValue);
            if (widget.reloadData != null) widget.reloadData!();
            if (widget.removeThisPost != null) {
              widget.removeThisPost!(widget.indexOfPost);
            }
          },
          child: textOfOrders(StringsManager.delete.tr));
    });
  }

  BlocBuilder<PostCubit, PostState> editPost(Post postInfoValue) {
    return BlocBuilder<PostCubit, PostState>(builder: (context, state) {
      return GestureDetector(
          onTap: () async {
            Navigator.maybePop(context);
            await Go(context)
                .push(page: UpdatePostInfo(oldPostInfo: postInfoValue));
          },
          child: textOfOrders(StringsManager.edit.tr));
    });
  }

  Widget ordersOfOtherUser() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [hideButton(), unFollowButton(), const SizedBox(height: 10)],
      ),
    );
  }

  Builder unFollowButton() {
    return Builder(builder: (context) {
      FollowUnFollowCubit followCubit =
          BlocProvider.of<FollowUnFollowCubit>(context);
      UserPersonalInfo myPersonalInfo =
          UserInfoCubit.getMyPersonalInfo(context);
      List iFollowThem = myPersonalInfo.followedPeople;
      return ValueListenableBuilder(
        valueListenable: widget.postInfo,
        builder: (context, Post postInfoValue, child) => GestureDetector(
            onTap: () async {
              await Navigator.of(context).maybePop();
              await followCubit.unFollowThisUser(
                  followingUserId: widget.postInfo.value.publisherId,
                  myPersonalId: myPersonalId);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  if (widget.reloadData != null) widget.reloadData!();
                  if (widget.removeThisPost != null) {
                    widget.removeThisPost!(widget.indexOfPost);
                  }
                });
              });
            },
            child: textOfOrders(iFollowThem.contains(postInfoValue.publisherId)
                ? StringsManager.unfollow.tr
                : StringsManager.follow.tr)),
      );
    });
  }

  GestureDetector hideButton() {
    return GestureDetector(child: textOfOrders(StringsManager.hide.tr));
  }

  Widget textOfOrders(String text) {
    return SizedBox(
      height: 40,
      child: Row(
        children: [
          buildText(text),
        ],
      ),
    );
  }

  Widget buildText(String text) {
    return Text(text,
        style:
            getNormalStyle(color: Theme.of(context).focusColor, fontSize: 15));
  }

  ValueListenableBuilder<bool> saveButton() {
    return ValueListenableBuilder(
      valueListenable: isSaved,
      builder: (context, bool isSavedValue, child) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 12.0),
        child: GestureDetector(
          child: isSavedValue
              ? Icon(
                  Icons.bookmark_border,
                  color: Theme.of(context).focusColor,
                )
              : Icon(
                  Icons.bookmark,
                  color: Theme.of(context).focusColor,
                ),
          onTap: () {
            isSaved.value = !isSaved.value;
          },
        ),
      ),
    );
  }

  Padding commentButton(BuildContext context, Post postInfoValue) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 5),
      child: GestureDetector(
        child: iconsOfImagePost(IconsAssets.commentIcon),
        onTap: () {
          if (isThatMobile) {
            /// comment page
            Go(context)
                .push(page: CommentsPageForMobile(postInfo: widget.postInfo));

            /// comment bottom sheet
            // commentBottomSheet();
          } else {
            if (!widget.popupWebContainer) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => playTheVideo = false);
              });

              Navigator.of(context).push(
                HeroDialogRoute(
                  builder: (context) => ImageOfPost(
                    postInfo: widget.postInfo,
                    playTheVideo: true,
                    indexOfPost: widget.indexOfPost,
                    postsInfo: widget.postsInfo,
                    removeThisPost: widget.removeThisPost,
                    rebuildPreviousWidget: widget.rebuildPreviousWidget,
                    reloadData: widget.reloadData,
                    popupWebContainer: true,
                    selectedCommentInfo: widget.selectedCommentInfo,
                    textController: widget.textController,
                  ),
                ),
              );
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() => playTheVideo = true);
              });
            } else {
              setState(() => showCommentBox = true);
            }
          }
        },
      ),
    );
  }

  /// not implemented comment bottom sheet
  Future<void> commentBottomSheet({bool createNewData = true}) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => CustomBottomSheet(
        bodyText: postCommentsBottomSheet(createNewData),
        headIcon: commentBottomSheetHeadIcon(),
      ),
    );
  }

  ValueListenableBuilder<bool> commentBottomSheetHeadIcon() {
    return ValueListenableBuilder(
        valueListenable: ValueNotifier(true),
        builder: (context, bool themeValue, child) {
          Color themeOfApp =
              themeValue ? ColorManager.white : ColorManager.black;
          return Text(StringsManager.comment.tr,
              style: getBoldStyle(color: themeOfApp, fontSize: 17));
        });
  }

  Padding postCommentsBottomSheet(bool createNewData) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0),
      child: CommentsOfPost(
          selectedCommentInfo: ValueNotifier(null),
          textController: ValueNotifier(TextEditingController()),
          postInfo: widget.postInfo),
    );
  }
}
