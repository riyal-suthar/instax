part of 'post_cubit.dart';

@immutable
abstract class PostState {}

class PostInitial extends PostState {}

class PostLoading extends PostState {}

class PostLoaded extends PostState {
  Post postInfo;
  PostLoaded(this.postInfo);
}

class UpdatePostLoading extends PostState {}

class UpdatePostLoaded extends PostState {
  Post postUpdatedInfo;
  UpdatePostLoaded(this.postUpdatedInfo);
}

class DeletePostLoading extends PostState {}

class DeletePostLoaded extends PostState {}

class MyPersonalPostsLoaded extends PostState {
  List<Post> postsInfo;
  MyPersonalPostsLoaded(this.postsInfo);
}

class PostsInfoLoaded extends PostState {
  List<Post> postsInfo;
  PostsInfoLoaded(this.postsInfo);
}

class AllPostsLoaded extends PostState {
  List<Post> allPostsInfo;
  AllPostsLoaded(this.allPostsInfo);
}

class PostFailed extends PostState {
  final String error;

  PostFailed(this.error);
}
