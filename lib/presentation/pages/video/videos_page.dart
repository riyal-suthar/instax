import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/resources/assets_manager.dart';
import 'package:instax/core/resources/color_manager.dart';
import 'package:instax/core/resources/styles_manager.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/presentation/cubit/follow_unfollow_cubit/follow_un_follow_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/like_cubit/post_likes_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/post_cubit.dart';
import 'package:instax/presentation/cubit/user_info/user_info_cubit.dart';
import 'package:instax/presentation/widgets/other_widgets/share_button.dart';
import 'package:shimmer/shimmer.dart';
import 'package:video_player/video_player.dart';

import '../../../config/routes/app_routes.dart';
import '../../../core/resources/strings_manager.dart';
import '../../../data/models/child_classes/post/post.dart';
import '../../widgets/aniamtion/fade_animation.dart';
import '../../widgets/custom_widgets/custom_circulars_progress_indicators.dart';
import '../../widgets/custom_widgets/custom_gallery_display.dart';
import '../comments/comments_for_mobile.dart';
import '../profile/users_who_like_for_mobile.dart';
import '../profile/widgets/which_profile_page.dart';
import 'package:get/get.dart';

part 'widgets/reel_video_play.dart';

class VideosPage extends StatefulWidget {
  final ValueNotifier<bool> stopVideo;
  final Post? clickedVideo;
  const VideosPage({super.key, required this.stopVideo, this.clickedVideo});

  @override
  State<VideosPage> createState() => _VideosPageState();
}

class _VideosPageState extends State<VideosPage> {
  ValueNotifier<Uint8List?> videoFile = ValueNotifier(null);
  ValueNotifier<bool> rebuildUserInfo = ValueNotifier(false);
  final ValueNotifier<bool> stopVideo = ValueNotifier(false);

  @override
  void initState() {
    if (stopVideo.value) stopVideo.value = widget.stopVideo.value;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant VideosPage oldWidget) {
    if (stopVideo.value) stopVideo.value = widget.stopVideo.value;
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    widget.stopVideo.value = false;
    stopVideo.dispose();
    videoFile.dispose();
    rebuildUserInfo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: rebuildUserInfo,
      builder: (context, bool rebuildValue, child) =>
          BlocBuilder<PostCubit, PostState>(
        bloc: BlocProvider.of<PostCubit>(context)
          ..getAllPostsInfo(
              isVideosWantedOnly: true,
              skippedVideoUid: widget.clickedVideo != null
                  ? widget.clickedVideo!.postUid
                  : ""),
        buildWhen: (prev, curr) {
          if (prev != curr && curr is AllPostsLoaded) {
            return true;
          }
          if (rebuildValue && curr is AllPostsLoaded) {
            rebuildUserInfo.value = false;
            return true;
          }
          return false;
        },
        builder: (context, state) {
          if (state is AllPostsLoaded) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: isThatMobile ? appBar() : null,
              body: buildBody(state.allPostsInfo),
            );
          } else if (state is PostFailed) {
            ToastMessage.toastStateError(state);
            return Center(
              child: Text(
                StringsManager.noVideos.tr,
                style: TextStyle(
                    color: Theme.of(context).focusColor, fontSize: 20.0),
              ),
            );
          } else {
            return loadingWidget();
          }
        },
      ),
    );
  }

  AppBar appBar() => AppBar(
        backgroundColor: ColorManager.transparent,
        actions: [
          IconButton(
            onPressed: () async {
              widget.stopVideo.value = false;
              await CustomImagePickerPlus.pickVideo(context);
              widget.stopVideo.value = true;
            },
            icon: const Icon(
              Icons.camera_alt,
              size: 30,
              color: ColorManager.white,
            ),
          )
        ],
      );

  Widget loadingWidget() {
    return Stack(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey[500]!,
          highlightColor: ColorManager.shimmerDarkGrey,
          child: Container(
            width: double.infinity,
            height: double.maxFinite,
            color: ColorManager.lightDarkGray,
          ),
        ),
        Shimmer.fromColors(
          baseColor: Colors.grey[600]!,
          highlightColor: ColorManager.shimmerDarkGrey,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(
                end: 25.0, bottom: 20, start: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: ColorManager.darkGray,
                ),
                const SizedBox(height: 5),
                Container(height: 15, width: 150, color: ColorManager.darkGray),
                const SizedBox(height: 5),
                Container(height: 15, width: 200, color: ColorManager.darkGray),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBody(List<Post> videosInfo) {
    return PageView.builder(
      scrollDirection: Axis.vertical,
      itemCount: videosInfo.length,
      itemBuilder: (context, index) {
        ValueNotifier<Post> videoInfo = ValueNotifier(videosInfo[index]);
        return Stack(
          children: [
            SizedBox(
              height: double.infinity,
              child: ValueListenableBuilder(
                valueListenable: stopVideo,
                builder: (context, bool stopVideoValue, child) =>
                    _ReelVideoPlay(
                  videoInfo: videoInfo,
                  stopVideo: stopVideoValue,
                ),
              ),
            ),
            _VerticalButtons(videoInfo: videoInfo, videoPlaying: videoPlaying),
            _HorizontalButtons(
                videoInfo: videoInfo, videoPlaying: videoPlaying),
          ],
        );
      },
    );
  }

  void videoPlaying(bool playVideo) {
    stopVideo.value = playVideo;
  }
}

class _HorizontalButtons extends StatefulWidget {
  final ValueNotifier<Post> videoInfo;
  final ValueChanged<bool> videoPlaying;
  const _HorizontalButtons(
      {Key? key, required this.videoInfo, required this.videoPlaying})
      : super(key: key);

  @override
  State<_HorizontalButtons> createState() => _HorizontalButtonsState();
}

class _HorizontalButtonsState extends State<_HorizontalButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsetsDirectional.only(end: 25.0, bottom: 20, start: 15),
      child: ValueListenableBuilder(
        valueListenable: widget.videoInfo,
        builder: (context, Post videoInfoValue, child) {
          UserPersonalInfo? userPersonalInfo = videoInfoValue.publisherInfo;
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => goToUserProfile(userPersonalInfo),
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: ColorManager.white,
                        backgroundImage: NetworkImage(
                            userPersonalInfo!.profileImageUrl ?? ""),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () => goToUserProfile(userPersonalInfo),
                      child: Text(
                        userPersonalInfo.name,
                        style: const TextStyle(color: ColorManager.white),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    if (videoInfoValue.publisherId != myPersonalId)
                      followButton(userPersonalInfo),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                videoInfoValue.caption,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: getNormalStyle(color: ColorManager.white),
              )
            ],
          );
        },
      ),
    );
  }

  goToUserProfile(UserPersonalInfo userInfo) async {
    widget.videoPlaying(false);
    await Go(context).push(
        page: WhichProfilePage(
            userId: userInfo.userId, userName: userInfo.userName));

    widget.videoPlaying(true);
  }

  Widget followButton(UserPersonalInfo userInfo) {
    return BlocBuilder<FollowUnFollowCubit, FollowUnFollowState>(
      builder: (followContext, stateOfFollow) {
        return Builder(builder: (userContext) {
          UserPersonalInfo myPersonalInfo =
              UserInfoCubit.getMyPersonalInfo(context);
          return GestureDetector(
            onTap: () async {
              if (myPersonalInfo.followedPeople.contains(userInfo.userId)) {
                await BlocProvider.of<FollowUnFollowCubit>(followContext)
                    .unFollowThisUser(
                        followingUserId: userInfo.userId,
                        myPersonalId: myPersonalId);
                if (!mounted) return;
                BlocProvider.of<UserInfoCubit>(context).updateMyFollowings(
                    userId: userInfo.userId, addThisUser: false);
              } else {
                await BlocProvider.of<FollowUnFollowCubit>(followContext)
                    .followThisUser(
                        followingUserId: userInfo.userId,
                        myPersonalId: myPersonalId);
                if (!mounted) return;
                BlocProvider.of<UserInfoCubit>(context)
                    .updateMyFollowings(userId: userInfo.userId);
              }
            },
            child: followText(userInfo, myPersonalInfo),
          );
        });
      },
    );
  }

  Container followText(
          UserPersonalInfo userInfo, UserPersonalInfo myPersonalInfo) =>
      Container(
        padding: const EdgeInsetsDirectional.only(
            start: 5, end: 5, bottom: 2, top: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: ColorManager.white, width: 1)),
        child: Text(
          myPersonalInfo.followedPeople.contains(userInfo.userId)
              ? StringsManager.following.tr
              : StringsManager.follow.tr,
          style: const TextStyle(color: ColorManager.white),
        ),
      );
}

class _VerticalButtons extends StatefulWidget {
  final ValueNotifier<Post> videoInfo;
  final ValueChanged<bool> videoPlaying;
  const _VerticalButtons(
      {super.key, required this.videoInfo, required this.videoPlaying});

  @override
  State<_VerticalButtons> createState() => _VerticalButtonsState();
}

class _VerticalButtonsState extends State<_VerticalButtons> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 15.0, bottom: 8),
      child: Align(
        alignment: AlignmentDirectional.bottomEnd,
        child: ValueListenableBuilder(
          valueListenable: widget.videoInfo,
          builder: (context, Post videoInfoValue, child) => Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              loveButton(videoInfoValue),
              const SizedBox(
                height: 5,
              ),
              numberOfLikes(videoInfoValue),
              commentButton(videoInfoValue),
              const SizedBox(
                height: 5,
              ),
              numberOfComments(videoInfoValue),
              ShareButton(
                postInfo: widget.videoInfo,
                isThatForVideoPage: true,
              ),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                child: SvgPicture.asset(
                  IconsAssets.menuHorizontalIcon,
                  colorFilter: const ColorFilter.mode(
                      ColorManager.white, BlendMode.srcIn),
                  height: 25,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget numberOfComments(Post videoInfo) {
    return InkWell(
      onTap: () async => goToCommentPage(videoInfo),
      child: SizedBox(
        width: 30,
        height: 40,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "${videoInfo.comments.length}",
            style: const TextStyle(color: ColorManager.white),
          ),
        ),
      ),
    );
  }

  goToCommentPage(Post videoInfo) async {
    widget.videoPlaying(false);
    await Go(context)
        .push(page: CommentsPageForMobile(postInfo: ValueNotifier(videoInfo)));
    widget.videoPlaying(true);
  }

  Widget commentButton(Post videoInfo) {
    return GestureDetector(
      child: SvgPicture.asset(
        IconsAssets.commentIcon,
        colorFilter:
            const ColorFilter.mode(ColorManager.white, BlendMode.srcIn),
        height: 35,
      ),
    );
  }

  Widget numberOfLikes(Post videoInfo) {
    return InkWell(
      onTap: () async {
        widget.videoPlaying(false);
        await Go(context).push(
            page: UsersWhoLikesForMobile(
          showSearchBar: true,
          usersIds: videoInfo.likes,
          isThatMyPersonalId: videoInfo.publisherId == myPersonalId,
        ));
        widget.videoPlaying(true);
      },
      child: SizedBox(
        width: 30,
        height: 40,
        child: Align(
          alignment: Alignment.topCenter,
          child: Text(
            "${videoInfo.likes.length}",
            style: const TextStyle(color: ColorManager.white),
          ),
        ),
      ),
    );
  }

  Widget loveButton(Post videoInfo) {
    bool isLiked = videoInfo.likes.contains(myPersonalId);
    return Builder(builder: (context) {
      var likeCubit = BlocProvider.of<PostLikesCubit>(context);
      return GestureDetector(
        child: isLiked
            ? const Icon(
                Icons.favorite,
                color: ColorManager.red,
                size: 32,
              )
            : const Icon(
                Icons.favorite_border,
                color: ColorManager.white,
                size: 32,
              ),
        onTap: () {
          setState(() {
            if (isLiked) {
              likeCubit.removeLikeOnThisPost(
                  postId: videoInfo.postUid, userId: myPersonalId);
              videoInfo.likes.remove(myPersonalId);
            } else {
              likeCubit.putLikeOnThisPost(
                  postId: videoInfo.postUid, userId: myPersonalId);
              videoInfo.likes.add(myPersonalId);
            }
          });
        },
      );
    });
  }
}
