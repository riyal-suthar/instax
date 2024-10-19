part of 'add_new_user_cubit.dart';

@immutable
abstract class AddNewUserState {}

class AddNewUserInitial extends AddNewUserState {}

class UserAdding extends AddNewUserState {}

class UserAdded extends AddNewUserState {}

class AddNewUserFailed extends AddNewUserState {
  final String error;

  AddNewUserFailed(this.error);
}
