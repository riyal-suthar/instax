import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/domain/entities/register_user.dart';
import 'package:instax/domain/entities/sign_in_entity.dart';
import 'package:instax/domain/entities/sign_up_entity.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/auth/email_verification_usecase.dart';
import '../../../domain/usecases/auth/sign_in_usecase.dart';
import '../../../domain/usecases/auth/sign_out_usecase.dart';
import '../../../domain/usecases/auth/sign_up_usecase.dart';

part 'firebase_auth_state.dart';

class FirebaseAuthCubit extends Cubit<FirebaseAuthCubitState> {
  SignInUseCase signInUseCase;
  SignUpUseCase signUpUseCase;
  SignOutUseCase signOutUseCase;
  EmailVerificationUseCase emailVerificationUseCase;

  User? user;

  FirebaseAuthCubit(this.signInUseCase, this.signUpUseCase, this.signOutUseCase,
      this.emailVerificationUseCase)
      : super(CubitAuthInitial());

  static FirebaseAuthCubit get(BuildContext context) =>
      BlocProvider.of(context);

  Future<User?> signIn(RegisteredUser signIn) async {
    emit(CubitAuthConfirming());
    await signInUseCase.call(params: signIn).then((value) {
      emit(CubitAuthConfirmed(value));
      user = value;
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
    return user;
  }

  Future<User?> signUp(RegisteredUser newUser) async {
    emit(CubitAuthConfirming());
    await signUpUseCase.call(params: newUser).then((value) {
      emit(CubitAuthConfirmed(value));
      user = value;
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
    return user;
  }

  Future<void> isThisEmailToken({required String email}) async {
    if (email.isEmpty) return;

    emit(CubitEmailVerificationLoading());
    await emailVerificationUseCase.call(params: email).then((value) async {
      emit(CubitEmailVerificationLoaded(value));
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
  }

  Future<void> signOut({required String userId}) async {
    emit(CubitAuthConfirming());
    await signOutUseCase.call(params: userId).then((value) async {
      emit(CubitAuthSignOut());
    }).catchError((e) {
      emit(CubitAuthFailed(e.toString()));
    });
  }
}
