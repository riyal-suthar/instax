part of 'search_about_user_bloc.dart';

abstract class SearchAboutUserState extends Equatable {
  const SearchAboutUserState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SearchAboutUserInitial extends SearchAboutUserState {}

class SearchAboutUserLoading extends SearchAboutUserState {}

class SearchAboutUserLoaded extends SearchAboutUserState {
  final List<UserPersonalInfo> users;

  const SearchAboutUserLoaded({this.users = const <UserPersonalInfo>[]});

  @override
  // TODO: implement props
  List<Object> get props => [users];
}
