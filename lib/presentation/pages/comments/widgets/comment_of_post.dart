import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/functions/toast_message.dart';
import 'package:instax/core/utils/injector.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/comment_cubit/comments_info_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/comment_cubit/reply_cubit/reply_info_cubit.dart';
import 'package:instax/presentation/cubit/user_info/user_info_cubit.dart';
import 'package:instax/presentation/pages/comments/widgets/comment_box.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_circulars_progress_indicators.dart';
import 'package:instax/presentation/widgets/custom_widgets/custom_post_display.dart';

import '../../../../core/functions/date_reformats.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/strings_manager.dart';
import '../../../../core/resources/styles_manager.dart';
import '../../../../core/utils/constants.dart';
import '../../../../data/models/child_classes/post/post.dart';
import '../../../../data/models/parent_classes/without_sub_classes/comment.dart';
import 'package:get/get.dart';

import 'commentator.dart';

class CommentsOfPost extends StatefulWidget {
  final ValueNotifier<Comment?> selectedCommentInfo;
  final ValueNotifier<TextEditingController> textController;

  final ValueNotifier<Post> postInfo;
  final bool showImage;

  const CommentsOfPost(
      {super.key,
      required this.selectedCommentInfo,
      required this.textController,
      required this.postInfo,
      this.showImage = false});

  @override
  State<CommentsOfPost> createState() => _CommentsOfPostState();
}

class _CommentsOfPostState extends State<CommentsOfPost> {
  Map<int, bool> showMeReplies = {};
  List<Comment> allComments = [];
  bool addReply = false;
  bool rebuild = false;
  late UserPersonalInfo myPersonalInfo;
  ValueNotifier<FocusNode> currentFocus = ValueNotifier(FocusNode());

  @override
  void initState() {
    myPersonalInfo = UserInfoCubit.getMyPersonalInfo(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isThatMobile ? buildForMobile() : commentsList();
  }

  Widget buildForMobile() {
    return Column(
      children: [
        commentsList(),
        commentBox(),
      ],
    );
  }

  Widget commentsList() {
    return Expanded(
      child: BlocBuilder<CommentsInfoCubit, CommentsInfoState>(
          bloc: blocAction(),
          buildWhen: buildBlocWhen,
          builder: (context, state) => buildBloc(context, state)),
    );
  }

  CommentsInfoCubit blocAction() => BlocProvider.of<CommentsInfoCubit>(context)
    ..getSpecificComments(postId: widget.postInfo.value.postUid);

  bool buildBlocWhen(CommentsInfoState prev, CommentsInfoState curr) =>
      prev != curr && curr is CommentsInfoLoaded;

  Widget buildBloc(context, state) {
    if (state is CommentsInfoLoaded) {
      return blocLoaded(context, state);
    } else if (state is CommentsInfoFailed) {
      return whenBlocFailed(context, state);
    } else {
      return const ThineCircularProgress();
    }
  }

  Widget blocLoaded(BuildContext context, CommentsInfoLoaded state) {
    state.commentsOfPost
        .sort((a, b) => b.datePublished.compareTo(a.datePublished));
    allComments = state.commentsOfPost;
    return commentListView(allComments);
  }

  Widget whenBlocFailed(BuildContext context, CommentsInfoFailed state) {
    ToastMessage.toastStateError(state);
    return Text(StringsManager.somethingWrong.tr,
        style: getNormalStyle(color: Theme.of(context).focusColor));
  }

  selectedComment(Comment commentInfo) =>
      setState(() => widget.selectedCommentInfo.value = commentInfo);

  Widget commentListView(List<Comment> commentsOfThePost) {
    return allComments.isEmpty && !widget.showImage
        ? Center(
            child: Text(
              StringsManager.noComments.tr,
              style: getBoldStyle(
                  color: Theme.of(context).focusColor,
                  fontSize: 20,
                  fontStyle: FontStyle.italic),
            ),
          )
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.showImage) ...[
                    CustomPostDisplay(
                        postsInfo: ValueNotifier([widget.postInfo.value]),
                        playTheVideo: true,
                        indexOfPost: 0,
                        postInfo: widget.postInfo,
                        textController: widget.textController,
                        selectedCommentInfo: widget.selectedCommentInfo),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 11.5, top: 5.0),
                      child: Text(
                        DateReformat.fullDigitsFormat(
                            widget.postInfo.value.datePublished,
                            widget.postInfo.value.datePublished),
                        style: getNormalStyle(
                            color: Theme.of(context).bottomAppBarTheme.color!),
                      ),
                    ),
                    const Divider(
                      color: ColorManager.black26,
                    )
                  ],
                  allComments.isNotEmpty
                      ? ListView.separated(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          shrinkWrap: true,
                          primary: false,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            if (!showMeReplies.containsKey(index)) {
                              showMeReplies[index] = false;
                            }

                            return BlocProvider(
                              create: (_) => injector<ReplyInfoCubit>(),
                              child: CommentInfo(
                                commentInfo: commentsOfThePost[index],
                                index: index,
                                showMeReplies: showMeReplies,
                                textController: widget.textController,
                                selectedCommentInfo:
                                    ValueNotifier(selectedComment),
                                myPersonalInfo: myPersonalInfo,
                                addReply: addReply,
                                rebuildCallback: isScreenRebuild,
                                rebuildComment: rebuild,
                                postInfo: widget.postInfo,
                                currentFocus: currentFocus,
                              ),
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
                          itemCount: commentsOfThePost.length,
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
  }

  Widget commentBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        replyingMention(),
        customDivider(),
        commentTextField(),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  Widget replyingMention() {
    if (widget.selectedCommentInfo.value != null) {
      return Container(
        width: double.infinity,
        height: 45,
        color: Theme.of(context).splashColor,
        child: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 10.0, end: 17),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  "${StringsManager.replyingTo.tr} ${widget.selectedCommentInfo.value!.whoCommentInfo!.userName}",
                  style: getNormalStyle(color: Theme.of(context).disabledColor),
                )),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.selectedCommentInfo.value = null;
                      widget.textController.value.text = "";
                    });
                  },
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: Theme.of(context).focusColor,
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget commentTextField() => CommentBox(
        postInfo: widget.postInfo,
        selectedCommentInfo: widget.selectedCommentInfo,
        textController: widget.textController.value,
        userPersonalInfo: myPersonalInfo,
        currentFocus: currentFocus,
        makeSelectedCommentNullable: makeSelectedCommentNullable,
      );

  void isScreenRebuild(isRebuild) {
    setState(() {
      rebuild = isRebuild;
    });
  }

  makeSelectedCommentNullable(bool isThatComment) {
    setState(() {
      widget.selectedCommentInfo.value = null;
      widget.textController.value.text = '';
      if (!isThatComment) isScreenRebuild(true);
    });
  }

  Container customDivider() => Container(
      margin: const EdgeInsetsDirectional.only(bottom: 8),
      color: ColorManager.grey,
      width: double.infinity,
      height: 0.2);
}
