import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/constants.dart';
import '../../cubit/postInfo_cubit/post_cubit.dart';
import '../../pages/comments/widgets/comment_of_post.dart';
import '../other_widgets/image_of_post.dart';
import 'custom_appbar.dart';
import 'custom_circulars_progress_indicators.dart';
import 'custom_posts_display.dart';

class GetsPostInfoAndDisplay extends StatelessWidget {
  final String postId;
  final String appBarText;
  final bool fromHeroRoute;

  const GetsPostInfoAndDisplay(
      {super.key,
      required this.postId,
      required this.appBarText,
      this.fromHeroRoute = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isThatMobile
          ? CustomAppBar.oneTitleAppBar(context, appBarText,
              logoOfInstagram: true)
          : null,
      body: BlocBuilder<PostCubit, PostState>(
        bloc: PostCubit.get(context)
          ..getPostsInfo(postIds: [postId], isThatMyPosts: false),
        buildWhen: (previous, current) {
          if (previous != current && current is PostFailed) {
            return true;
          }
          return previous != current && current is PostsInfoLoaded;
        },
        builder: (context, state) {
          if (state is PostsInfoLoaded) {
            if (isThatMobile) {
              if (state.postsInfo.isNotEmpty &&
                  state.postsInfo[0].comments.length < 10) {
                return CommentsOfPost(
                  postInfo: ValueNotifier(state.postsInfo[0]),
                  textController: ValueNotifier(TextEditingController()),
                  selectedCommentInfo: ValueNotifier(null),
                  showImage: true,
                );
              } else {
                return CustomPostsDisplay(
                  postsInfo: state.postsInfo,
                  showCatchUp: false,
                );
              }
            } else {
              return ImageOfPost(
                postInfo: ValueNotifier(state.postsInfo[0]),
                textController: ValueNotifier(TextEditingController()),
                selectedCommentInfo: ValueNotifier(null),
                playTheVideo: true,
                indexOfPost: 0,
                popupWebContainer: true,
                postsInfo: ValueNotifier(state.postsInfo),
              );
            }
          } else {
            return ThineCircularProgress(
              strokeWidth: 1.5,
              color: Theme.of(context).iconTheme.color,
              backgroundColor: Theme.of(context).dividerColor,
            );
          }
        },
      ),
    );
  }
}
