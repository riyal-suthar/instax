import 'package:get_it/get_it.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/calling_rooms/calling_rooms.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/chat/group_chat.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/chat/single_chat.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/firebase_auth.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/firebase_storage.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/notification/firebase_notification.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/post/comment/firestore_comment.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/post/comment/firestore_reply_comment.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/story/firestore_story.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/user/firestore_user.dart';
import 'package:instax/data/repositories/post/comment/comment_repo.dart';
import 'package:instax/data/repositories/post/post_repo.dart';
import 'package:instax/domain/repositories/post/comment_repository.dart';
import 'package:instax/domain/repositories/post/post_repository.dart';
import 'package:instax/domain/usecases/auth/email_verification_usecase.dart';
import 'package:instax/domain/usecases/auth/sign_in_usecase.dart';
import 'package:instax/domain/usecases/auth/sign_out_usecase.dart';
import 'package:instax/domain/usecases/auth/sign_up_usecase.dart';
import 'package:instax/presentation/cubit/agora_cubit/agora/agora_cubit.dart';
import 'package:instax/presentation/cubit/auth_cubit/firebase_auth_cubit.dart';
import 'package:instax/presentation/cubit/callingRomms/bloc/calling_status_bloc.dart';
import 'package:instax/presentation/cubit/callingRomms/calling_rooms_cubit.dart';
import 'package:instax/presentation/cubit/follow_unfollow_cubit/follow_un_follow_cubit.dart';
import 'package:instax/presentation/cubit/notification_cubit/notification_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/comment_cubit/comment_like_cubit/comment_likes_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/comment_cubit/comments_info_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/comment_cubit/reply_cubit/reply_info_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/comment_cubit/reply_cubit/reply_like_cubit/reply_like_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/like_cubit/post_likes_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/post_cubit.dart';
import 'package:instax/presentation/cubit/postInfo_cubit/specific_users_posts_cubit.dart';
import 'package:instax/presentation/cubit/story_cubit/story_cubit.dart';
import 'package:instax/presentation/cubit/user_info/add_new_user_cubit.dart';
import 'package:instax/presentation/cubit/user_info/message/bloc/message_bloc.dart';
import 'package:instax/presentation/cubit/user_info/message/cubit/group_chat/message_for_group_chat_cubit.dart';
import 'package:instax/presentation/cubit/user_info/message/cubit/message_cubit.dart';
import 'package:instax/presentation/cubit/user_info/search_about_user/search_about_user_bloc.dart';
import 'package:instax/presentation/cubit/user_info/specifc_users_info_cubit.dart';
import 'package:instax/presentation/cubit/user_info/user_info_cubit.dart';
import 'package:instax/presentation/cubit/user_info/users_info_in_reel_time/users_info_in_reel_time_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/data_sources/remote/fiirebase_firestore/post/firestore_post.dart';
import '../../data/repositories/auth_repo.dart';
import '../../data/repositories/calling_room_repo.dart';
import '../../data/repositories/group_message_repo.dart';
import '../../data/repositories/notification_repo.dart';
import '../../data/repositories/post/story/story_repo.dart';
import '../../data/repositories/user_repo.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/calling_room_repository.dart';
import '../../domain/repositories/firestore_notification_repository.dart';
import '../../domain/repositories/group_message_repository.dart';
import '../../domain/repositories/post/story_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/calling_room/create_calling_room_usecase.dart';
import '../../domain/usecases/calling_room/delete_room_usecase.dart';
import '../../domain/usecases/calling_room/get_calling_status.dart';
import '../../domain/usecases/calling_room/get_user_info_in_room.dart';
import '../../domain/usecases/calling_room/join_to_calling_room_usecase.dart';
import '../../domain/usecases/calling_room/leave_room_usecase.dart';
import '../../domain/usecases/follow/follow_this_user_usecase.dart';
import '../../domain/usecases/follow/unfollow_this_user_usecase.dart';
import '../../domain/usecases/message/commen/get_chats_users_info.dart';
import '../../domain/usecases/message/commen/get_specific_chat_info.dart';
import '../../domain/usecases/message/group_message/add_message.dart';
import '../../domain/usecases/message/group_message/delete_messages.dart';
import '../../domain/usecases/message/group_message/get_messages.dart';
import '../../domain/usecases/message/single_message/add_message.dart';
import '../../domain/usecases/message/single_message/delete_message.dart';
import '../../domain/usecases/message/single_message/get_messages.dart';
import '../../domain/usecases/notification/create_notification.dart';
import '../../domain/usecases/notification/delete_notification.dart';
import '../../domain/usecases/notification/get_notifications.dart';
import '../../domain/usecases/post/comments/add_comment_usecase.dart';
import '../../domain/usecases/post/comments/getComments/get_specific_comments_usecase.dart';
import '../../domain/usecases/post/comments/put_like_on_comment.dart';
import '../../domain/usecases/post/comments/remove_like_on_comment.dart';
import '../../domain/usecases/post/comments/replies/get_replies_on_comment.dart';
import '../../domain/usecases/post/comments/replies/likesOnReply/put_like_on_reply_usecase.dart';
import '../../domain/usecases/post/comments/replies/likesOnReply/remove_like_on_reply_usecase.dart';
import '../../domain/usecases/post/comments/replies/reply_on_comment_usecase.dart';
import '../../domain/usecases/post/create_post_usecase.dart';
import '../../domain/usecases/post/delete/delete_post_usecase.dart';
import '../../domain/usecases/post/get/get_all_posts_usecase.dart';
import '../../domain/usecases/post/get/get_post_info_usecase.dart';
import '../../domain/usecases/post/get/get_specific_user_posts_usecase.dart';
import '../../domain/usecases/post/likes/put_like_on_post_usecase.dart';
import '../../domain/usecases/post/likes/remove_like_on_post.dart';
import '../../domain/usecases/post/update/update_post_usecase.dart';
import '../../domain/usecases/story/create_story_usecase.dart';
import '../../domain/usecases/story/delete/delete_story_usecase.dart';
import '../../domain/usecases/story/get_specific_story_usecase.dart';
import '../../domain/usecases/story/get_stories_info_usecase.dart';
import '../../domain/usecases/user/add_new_user_usecase.dart';
import '../../domain/usecases/user/add_post_to_user_usecase.dart';
import '../../domain/usecases/user/getUseInfo/get_all_unfollowers_usecase.dart';
import '../../domain/usecases/user/getUseInfo/get_all_users_usecase.dart';
import '../../domain/usecases/user/getUseInfo/get_followers_following_usecase.dart';
import '../../domain/usecases/user/getUseInfo/get_specific_users_usecase.dart';
import '../../domain/usecases/user/getUseInfo/get_user_from_username_usecase.dart';
import '../../domain/usecases/user/getUseInfo/get_user_info_usecase.dart';
import '../../domain/usecases/user/getUseInfo/search_about_user_usecase.dart';
import '../../domain/usecases/user/my_personal_info_usecase.dart';
import '../../domain/usecases/user/update_user_info_usecase.dart';
import '../../domain/usecases/user/upload_profile_image_usecase.dart';

final injector = GetIt.instance;

Future<void> initializeDependencies() async {
  // shared prefs instance
  final sharedPrefs = await SharedPreferences.getInstance();

  injector.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // await callInjectionContainer();

  injector.registerLazySingleton<AgoraCubit>(() => AgoraCubit());

  /// ========================================================
  /// firebase - firestore
  // auth firebase
  injector.registerLazySingleton<FirebaseAuthRemoteDataSource>(
      () => FirebaseAuthRemoteDataSourceImpl());
  //
  // // notification firestore
  injector.registerLazySingleton<FireStoreNotification>(
      () => FireStoreNotificationImpl());
  //
  // // user firebase
  injector.registerLazySingleton<FireStoreUser>(() => FireStoreUserImpl());
  //
  // // story
  injector.registerLazySingleton<FireStoreStory>(() => FireStoreStoryImpl());
  //
  // // post
  injector.registerLazySingleton<FireStorePost>(() => FireStorePostImpl());
  //
  // // comment
  injector
      .registerLazySingleton<FireStoreComment>(() => FireStoreCommentImpl());
  //
  // // reply comment
  injector.registerLazySingleton<FireStoreReplyComment>(
      () => FireStoreReplyCommentImpl());
  //
  // //  single-chat
  injector.registerLazySingleton<FireStoreSingleChat>(
      () => FireStoreSingleChatImpl());
  //
  // // group-chat
  injector.registerLazySingleton<FireStoreGroupChat>(
      () => FireStoreGroupChatImpl());
  //
  // // calling-room
  injector.registerLazySingleton<FireStoreCallingRooms>(
      () => FireStoreCallingRoomsImpl());

  // storage
  injector.registerLazySingleton<FirebaseStoragePost>(
      () => FirebaseStoragePostImpl());

  /// ============================================================
  // Repositories

  // Post
  injector.registerLazySingleton<FireStorePostRepository>(
      () => FireStorePostRepositoryImpl(injector(), injector(), injector()));
  // comment
  injector.registerLazySingleton<FirestoreCommentRepository>(
      () => FireStoreCommentRepoImpl(injector(), injector()));
  // reply

  // injector.registerLazySingleton<FirestoreReplyOnCommentRepository>(
  //     () => FireStoreReplyCommentRepoImpl());
  // *
  // *
  // *
  injector.registerLazySingleton<FirebaseAuthRepository>(
    () => FirebaseAuthRepoImpl(injector(), injector()),
  );
  injector.registerLazySingleton<FireStoreUserRepository>(() =>
      FirebaseUserRepoImpl(
          injector(), injector(), injector(), injector(), injector()));
  // story
  injector.registerLazySingleton<FireStoreStoryRepository>(
    () => FireStoreStoryRepoImpl(injector(), injector(), injector()),
  );
  // notification
  injector.registerLazySingleton<FireStoreNotificationRepository>(
    () => FireStoreNotificationRepoImpl(injector()),
  );
  // calling rooms repository
  injector.registerLazySingleton<CallingRoomRepository>(
      () => CallingRoomRepoImpl(injector(), injector()));

  injector.registerLazySingleton<FireStoreGroupMessageRepository>(
      () => FirebaseGroupMessageRepoImpl(injector(), injector(), injector()));

  /// ==================================
  /// usecases

  // firebase auth usecases
  injector
      .registerLazySingleton<SignInUseCase>(() => SignInUseCase(injector()));
  injector
      .registerLazySingleton<SignUpUseCase>(() => SignUpUseCase(injector()));
  injector.registerLazySingleton<EmailVerificationUseCase>(
      () => EmailVerificationUseCase(injector()));
  injector
      .registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(injector()));

  // firestore user usecases
  injector.registerLazySingleton<AddNewUserUseCase>(
      () => AddNewUserUseCase(injector()));
  injector.registerLazySingleton<GetUserInfoUseCase>(
      () => GetUserInfoUseCase(injector()));

  injector.registerLazySingleton<GetFollowersAndFollowingsUseCase>(
      () => GetFollowersAndFollowingsUseCase(injector()));

  injector.registerLazySingleton<UpdateUserInfoUseCase>(
      () => UpdateUserInfoUseCase(injector()));

  injector.registerLazySingleton<UploadProfileImageUseCase>(
      () => UploadProfileImageUseCase(injector()));

  injector.registerLazySingleton<GetSpecificUsersUseCase>(
      () => GetSpecificUsersUseCase(injector()));

  injector.registerLazySingleton<AddPostToUserUseCase>(
      () => AddPostToUserUseCase(injector()));

  injector.registerLazySingleton<GetUserFromUserNameUseCase>(
      () => GetUserFromUserNameUseCase(injector()));
  injector.registerLazySingleton<GetAllUnFollowersUsersUseCase>(
      () => GetAllUnFollowersUsersUseCase(injector()));

  injector.registerLazySingleton<SearchAboutUserUseCase>(
      () => SearchAboutUserUseCase(injector()));

  injector.registerLazySingleton<GetChatUsersInfoAddMessageUseCase>(
      () => GetChatUsersInfoAddMessageUseCase(injector()));

  injector.registerLazySingleton<GetMyInfoUseCase>(
      () => GetMyInfoUseCase(injector()));

  // message use case
  injector.registerLazySingleton<AddMessageUseCase>(
      () => AddMessageUseCase(injector()));
  injector.registerLazySingleton<GetMessagesUseCase>(
      () => GetMessagesUseCase(injector()));
  injector.registerLazySingleton<DeleteMessageUseCase>(
      () => DeleteMessageUseCase(injector()));
  // *
  // *
  // FireStore Post useCases
  injector.registerLazySingleton<CreatePostUseCase>(
      () => CreatePostUseCase(injector()));
  injector.registerLazySingleton<GetPostsInfoUseCase>(
      () => GetPostsInfoUseCase(injector()));

  injector.registerLazySingleton<GetAllPostsUseCase>(
      () => GetAllPostsUseCase(injector()));

  injector.registerLazySingleton<GetSpecificUsersPostsUseCase>(
      () => GetSpecificUsersPostsUseCase(injector()));

  injector.registerLazySingleton<PutLikeOnThisPostUseCase>(
      () => PutLikeOnThisPostUseCase(injector()));

  injector.registerLazySingleton<RemoveLikeOnThisPostUseCase>(
      () => RemoveLikeOnThisPostUseCase(injector()));

  injector.registerLazySingleton<GetSpecificStoriesUseCase>(
      () => GetSpecificStoriesUseCase(injector()));

  injector.registerLazySingleton<DeletePostUseCase>(
      () => DeletePostUseCase(injector()));

  injector.registerLazySingleton<UpdatePostUseCase>(
      () => UpdatePostUseCase(injector()));
  //FireStore Comment UseCase
  injector.registerLazySingleton<GetSpecificCommentsUseCase>(
      () => GetSpecificCommentsUseCase(injector()));

  injector.registerLazySingleton<AddCommentUseCase>(
      () => AddCommentUseCase(injector()));

  injector.registerLazySingleton<PutLikeOnThisCommentUseCase>(
      () => PutLikeOnThisCommentUseCase(injector()));

  injector.registerLazySingleton<RemoveLikeOnThisCommentUseCase>(
      () => RemoveLikeOnThisCommentUseCase(injector()));

  //FireStore reply UseCase
  injector.registerLazySingleton<PutLikeOnThisReplyUseCase>(
      () => PutLikeOnThisReplyUseCase(injector()));

  injector.registerLazySingleton<RemoveLikeOnThisReplyUseCase>(
      () => RemoveLikeOnThisReplyUseCase(injector()));

  injector.registerLazySingleton<GetRepliesOnThisCommentUseCase>(
      () => GetRepliesOnThisCommentUseCase(injector()));

  injector.registerLazySingleton<ReplyOnThisCommentUseCase>(
      () => ReplyOnThisCommentUseCase(injector()));
  // *
  // *

  // follow useCases
  injector.registerLazySingleton<FollowThisUserUseCase>(
      () => FollowThisUserUseCase(injector()));
  injector.registerLazySingleton<UnFollowThisUserUseCase>(
      () => UnFollowThisUserUseCase(injector()));

  // *

  // story useCases
  injector.registerLazySingleton<GetStoriesUseCase>(
      () => GetStoriesUseCase(injector()));

  injector.registerLazySingleton<CreateStoryUseCase>(
      () => CreateStoryUseCase(injector()));
  injector.registerLazySingleton<DeleteStoryUseCase>(
      () => DeleteStoryUseCase(injector()));

  // *
  // notification useCases
  injector.registerLazySingleton<GetNotificationsUseCase>(
      () => GetNotificationsUseCase(injector()));
  injector.registerLazySingleton<CreateNotificationUseCase>(
      () => CreateNotificationUseCase(injector()));
  injector.registerLazySingleton<DeleteNotificationUseCase>(
      () => DeleteNotificationUseCase(injector()));
  // *
  // calling rooms useCases
  injector.registerLazySingleton<CreateCallingRoomUseCase>(
      () => CreateCallingRoomUseCase(injector()));
  // join room useCases
  injector.registerLazySingleton<JoinToCallingRoomUseCase>(
      () => JoinToCallingRoomUseCase(injector()));
  // cancel room useCases
  injector.registerLazySingleton<CancelJoiningToRoomUseCase>(
      () => CancelJoiningToRoomUseCase(injector()));
  injector.registerLazySingleton<GetCallingStatusUseCase>(
      () => GetCallingStatusUseCase(injector()));

  injector.registerLazySingleton<GetUsersInfoInRoomUseCase>(
      () => GetUsersInfoInRoomUseCase(injector()));

  injector.registerLazySingleton<DeleteTheRoomUseCase>(
      () => DeleteTheRoomUseCase(injector()));

  injector.registerLazySingleton<GetAllUsersUseCase>(
      () => GetAllUsersUseCase(injector()));

  injector.registerLazySingleton<DeleteMessageForGroupChatUseCase>(
      () => DeleteMessageForGroupChatUseCase(injector()));

  injector.registerLazySingleton<GetMessagesForGroupChatUseCase>(
      () => GetMessagesForGroupChatUseCase(injector()));

  injector.registerLazySingleton<AddMessageForGroupChatUseCase>(
      () => AddMessageForGroupChatUseCase(injector()));

  injector.registerLazySingleton<GetSpecificChatInfoUseCase>(
      () => GetSpecificChatInfoUseCase(injector()));

  /// ================================================================
  //    auth Blocs
  injector.registerFactory<FirebaseAuthCubit>(
      () => FirebaseAuthCubit(injector(), injector(), injector(), injector()));

  //    user Blocs
  injector.registerFactory<AddNewUserCubit>(() => AddNewUserCubit(injector()));
  injector.registerFactory<UserInfoCubit>(() => UserInfoCubit(
      injector(), injector(), injector(), injector(), injector(), injector()));
  injector.registerFactory<SpecificUsersInfoCubit>(
      () => SpecificUsersInfoCubit(injector(), injector(), injector()));
  injector.registerFactory<UsersInfoInReelTimeBloc>(
      () => UsersInfoInReelTimeBloc(injector(), injector()));
  injector.registerFactory<SearchAboutUserBloc>(
      () => SearchAboutUserBloc(injector()));

  //  message
  injector.registerFactory<MessageCubit>(
      () => MessageCubit(injector(), injector(), injector()));
  injector.registerFactory<GetMessagesBloc>(
      () => GetMessagesBloc(injector(), injector()));

  injector.registerFactory<MessageForGroupChatCubit>(
      () => MessageForGroupChatCubit(injector(), injector()));

  // follow-unfollow
  injector.registerFactory<FollowUnFollowCubit>(
      () => FollowUnFollowCubit(injector(), injector()));

  //  post like
  injector.registerFactory<PostLikesCubit>(
      () => PostLikesCubit(injector(), injector()));

  //  comments
  injector.registerFactory<CommentsInfoCubit>(
      () => CommentsInfoCubit(injector(), injector()));
  injector.registerFactory<CommentLikesCubit>(
      () => CommentLikesCubit(injector(), injector()));

  //  replies comment
  injector.registerFactory<ReplyInfoCubit>(
      () => ReplyInfoCubit(injector(), injector()));
  injector.registerFactory<ReplyLikeCubit>(
      () => ReplyLikeCubit(injector(), injector()));

  //  posts
  injector.registerFactory<PostCubit>(() =>
      PostCubit(injector(), injector(), injector(), injector(), injector()));
  injector.registerFactory<SpecificUsersPostsCubit>(
      () => SpecificUsersPostsCubit(injector()));

  //  story
  injector.registerFactory<StoryCubit>(
      () => StoryCubit(injector(), injector(), injector(), injector()));

  //  notification
  injector.registerFactory<NotificationCubit>(
      () => NotificationCubit(injector(), injector(), injector()));

  //  calling room
  injector.registerFactory<CallingRoomsCubit>(() => CallingRoomsCubit(
      injector(), injector(), injector(), injector(), injector()));
  injector
      .registerFactory<CallingStatusBloc>(() => CallingStatusBloc(injector()));
}
