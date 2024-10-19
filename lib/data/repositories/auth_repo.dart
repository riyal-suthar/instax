import 'package:firebase_auth/firebase_auth.dart';
import 'package:instax/data/data_sources/remote/fiirebase_firestore/firebase_auth.dart';
import 'package:instax/data/models/user/sign_in_model.dart';
import 'package:instax/domain/entities/register_user.dart';
import 'package:instax/domain/entities/sign_in_entity.dart';
import 'package:instax/domain/entities/sign_up_entity.dart';
import 'package:instax/domain/repositories/auth_repository.dart';

import '../data_sources/remote/fiirebase_firestore/notification/firebase_notification.dart';

class FirebaseAuthRepoImpl implements FirebaseAuthRepository {
  final FirebaseAuthRemoteDataSource _auth;
  final FireStoreNotification _notification;

  FirebaseAuthRepoImpl(this._auth, this._notification);

  @override
  Future<bool> isThisEmailToken({required String email}) async {
    try {
      bool isThisEmailToken = await _auth.isThisEmailToken(email: email);
      return isThisEmailToken;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<User> signIn(RegisteredUser userInfo) async {
    try {
      User user = await _auth.signIn(
          email: userInfo.email, password: userInfo.password);
      return user;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<void> signOut({required String userId}) async {
    try {
      await _auth.signOut();
      await _notification.deleteDeviceToken(userId: userId);
      return;
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  @override
  Future<User> signUp(RegisteredUser userInfo) async {
    try {
      User newUser = await _auth.signUp(
          email: userInfo.email, password: userInfo.password);
      return newUser;
    } catch (e) {
      return Future.error(e.toString());
    }
  }
}
