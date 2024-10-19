import 'package:flutter/material.dart';
import 'package:instax/presentation/widgets/other_widgets/count_of_likes.dart';

import '../../../core/translations/app_lang.dart';
import '../../../data/models/child_classes/post/post.dart';
import '../../../data/models/parent_classes/without_sub_classes/comment.dart';
import '../../pages/time_line/widgets/read_more_text.dart';
import '../other_widgets/image_of_post.dart';

class CustomPostDisplay extends StatefulWidget {
  final ValueNotifier<Post> postInfo;
  final bool playTheVideo;
  final VoidCallback? reloadData;
  final int indexOfPost;
  final ValueNotifier<List<Post>> postsInfo;
  final ValueNotifier<TextEditingController> textController;
  final ValueNotifier<Comment?> selectedCommentInfo;
  final ValueChanged<int>? removeThisPost;
  const CustomPostDisplay({
    super.key,
    required this.postInfo,
    required this.playTheVideo,
    this.reloadData,
    required this.indexOfPost,
    required this.postsInfo,
    required this.textController,
    required this.selectedCommentInfo,
    this.removeThisPost,
  });

  @override
  State<CustomPostDisplay> createState() => _CustomPostDisplayState();
}

class _CustomPostDisplayState extends State<CustomPostDisplay>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bodyHeight = mediaQuery.size.height -
        AppBar().preferredSize.height -
        mediaQuery.padding.top;
    return thePostsOfHomePage(bodyHeight: bodyHeight);
  }

  Widget thePostsOfHomePage({required double bodyHeight}) {
    return SizedBox(
      width: double.infinity,
      child: ValueListenableBuilder(
          valueListenable: widget.postInfo,
          builder: (context, Post postInfoValue, child) => Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ImageOfPost(
                    postInfo: widget.postInfo,
                    playTheVideo: widget.playTheVideo,
                    reloadData: widget.reloadData,
                    indexOfPost: widget.indexOfPost,
                    postsInfo: widget.postsInfo,
                    removeThisPost: widget.removeThisPost,
                    textController: widget.textController,
                    selectedCommentInfo: widget.selectedCommentInfo,
                    rebuildPreviousWidget: () => setState(() {}),
                  ),
                  imageCaption(postInfoValue, bodyHeight, context)
                ],
              )),
    );
  }

  Padding imageCaption(Post postInfo, double bodyHeight, BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 11.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (postInfo.likes.isNotEmpty) CountOfLikes(postInfo: postInfo),
          const SizedBox(
            height: 5,
          ),
          if (AppLanguage.getInstance().isLangEnglish) ...[
            ReadMore("${postInfo.publisherInfo!.name} ${postInfo.caption}", 2),
          ] else ...[
            ReadMore("${postInfo.caption} ${postInfo.publisherInfo!.name}", 2),
          ],
        ],
      ),
    );
  }
}
