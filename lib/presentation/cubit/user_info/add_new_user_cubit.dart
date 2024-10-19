import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/data/models/parent_classes/without_sub_classes/user_personal_info.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/user/add_new_user_usecase.dart';

part 'add_new_user_state.dart';

class AddNewUserCubit extends Cubit<AddNewUserState> {
  final AddNewUserUseCase _addNewUserUseCase;
  AddNewUserCubit(this._addNewUserUseCase) : super(AddNewUserInitial());

  static AddNewUserCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> addNewUser(UserPersonalInfo newUserInfo) async {
    emit(UserAdding());
    await _addNewUserUseCase.call(params: newUserInfo).then((value) {
      emit(UserAdded());
    }).catchError((e) {
      emit(AddNewUserFailed(e));
    });
  }
}
