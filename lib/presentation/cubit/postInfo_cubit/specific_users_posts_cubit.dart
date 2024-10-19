import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/post/get/get_specific_user_posts_usecase.dart';

part 'specific_users_posts_state.dart';

class SpecificUsersPostsCubit extends Cubit<SpecificUsersPostsState> {
  final GetSpecificUsersPostsUseCase _getSpecificUsersPostsUseCase;
  SpecificUsersPostsCubit(this._getSpecificUsersPostsUseCase)
      : super(SpecificUsersPostsInitial());
  List usersPostsInfo = [];

  static SpecificUsersPostsCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<void> getSpecificUsersPostsInfo(
      {required List<dynamic> usersIds}) async {
    emit(SpecificUsersPostsLoading());
    await _getSpecificUsersPostsUseCase.call(params: usersIds).then((value) {
      usersPostsInfo = value;
      emit(SpecificUsersPostsLoaded(value));
    }).catchError((e) {
      usersPostsInfo = [];
      emit(SpecificUsersPostsFailed(e));
    });
  }
}
