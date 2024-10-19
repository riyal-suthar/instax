import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/core/utils/constants.dart';
import 'package:instax/core/utils/injector.dart';
import 'package:instax/presentation/cubit/agora_cubit/agora/agora_cubit.dart';
import 'package:instax/presentation/cubit/follow_unfollow_cubit/follow_un_follow_cubit.dart';
import 'package:instax/presentation/cubit/user_info/message/bloc/message_bloc.dart';
import '../presentation/cubit/auth_cubit/firebase_auth_cubit.dart';
import '../presentation/cubit/callingRomms/bloc/calling_status_bloc.dart';
import '../presentation/cubit/callingRomms/calling_rooms_cubit.dart';
import '../presentation/cubit/notification_cubit/notification_cubit.dart';
import '../presentation/cubit/postInfo_cubit/comment_cubit/comment_like_cubit/comment_likes_cubit.dart';
import '../presentation/cubit/postInfo_cubit/comment_cubit/comments_info_cubit.dart';
import '../presentation/cubit/postInfo_cubit/comment_cubit/reply_cubit/reply_info_cubit.dart';
import '../presentation/cubit/postInfo_cubit/comment_cubit/reply_cubit/reply_like_cubit/reply_like_cubit.dart';
import '../presentation/cubit/postInfo_cubit/like_cubit/post_likes_cubit.dart';
import '../presentation/cubit/postInfo_cubit/post_cubit.dart';
import '../presentation/cubit/postInfo_cubit/specific_users_posts_cubit.dart';
import '../presentation/cubit/story_cubit/story_cubit.dart';
import '../presentation/cubit/user_info/add_new_user_cubit.dart';
import '../presentation/cubit/user_info/message/cubit/group_chat/message_for_group_chat_cubit.dart';
import '../presentation/cubit/user_info/message/cubit/message_cubit.dart';
import '../presentation/cubit/user_info/search_about_user/search_about_user_bloc.dart';
import '../presentation/cubit/user_info/specifc_users_info_cubit.dart';
import '../presentation/cubit/user_info/user_info_cubit.dart';
import '../presentation/cubit/user_info/users_info_in_reel_time/users_info_in_reel_time_bloc.dart';

class MultiBlocs extends StatelessWidget {
  final Widget materialApp;

  const MultiBlocs(this.materialApp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<FirebaseAuthCubit>(
        create: (context) => injector<FirebaseAuthCubit>(),
      ),
      BlocProvider<UserInfoCubit>(
        create: (context) => injector<UserInfoCubit>(),
      ),
      BlocProvider<AddNewUserCubit>(
        create: (context) => injector<AddNewUserCubit>(),
      ),
      BlocProvider<PostCubit>(
        create: (context) => injector<PostCubit>()..getAllPostsInfo(),
      ),
      BlocProvider<FollowUnFollowCubit>(
        create: (context) => injector<FollowUnFollowCubit>(),
      ),
      BlocProvider<SpecificUsersInfoCubit>(
        create: (context) => injector<SpecificUsersInfoCubit>(),
      ),
      BlocProvider<SpecificUsersPostsCubit>(
        create: (context) => injector<SpecificUsersPostsCubit>(),
      ),
      BlocProvider<PostLikesCubit>(
        create: (context) => injector<PostLikesCubit>(),
      ),
      BlocProvider<CommentsInfoCubit>(
        create: (context) => injector<CommentsInfoCubit>(),
      ),
      BlocProvider<CommentLikesCubit>(
        create: (context) => injector<CommentLikesCubit>(),
      ),
      BlocProvider<ReplyLikeCubit>(
        create: (context) => injector<ReplyLikeCubit>(),
      ),
      BlocProvider<ReplyInfoCubit>(
        create: (context) => injector<ReplyInfoCubit>(),
      ),
      BlocProvider<MessageCubit>(
        create: (context) => injector<MessageCubit>(),
      ),
      BlocProvider<GetMessagesBloc>(
        create: (context) => injector<GetMessagesBloc>(),
      ),
      BlocProvider<StoryCubit>(
        create: (context) => injector<StoryCubit>(),
      ),
      BlocProvider<SearchAboutUserBloc>(
        create: (context) => injector<SearchAboutUserBloc>(),
      ),
      BlocProvider<NotificationCubit>(
        create: (context) => injector<NotificationCubit>(),
      ),
      BlocProvider<CallingRoomsCubit>(
        create: (context) => injector<CallingRoomsCubit>(),
      ),
      BlocProvider<CallingStatusBloc>(
        create: (context) => injector<CallingStatusBloc>(),
      ),
      BlocProvider<MessageForGroupChatCubit>(
        create: (context) => injector<MessageForGroupChatCubit>(),
      ),
      BlocProvider<AgoraCubit>(create: (context) => injector<AgoraCubit>()),
      BlocProvider<UsersInfoInReelTimeBloc>(
        create: (context1) {
          if (myPersonalId.isNotEmpty) {
            return injector<UsersInfoInReelTimeBloc>()
              ..add(LoadMyPersonalInfo());
          } else {
            return injector<UsersInfoInReelTimeBloc>();
          }
        },
      ),
    ], child: materialApp);
  }
}
