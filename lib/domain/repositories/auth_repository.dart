import 'package:firebase_auth/firebase_auth.dart';
import 'package:instax/domain/entities/register_user.dart';
import 'package:instax/domain/entities/sign_in_entity.dart';
import 'package:instax/domain/entities/sign_up_entity.dart';

abstract class FirebaseAuthRepository {
  Future<User> signUp(RegisteredUser newUser);
  Future<User> signIn(RegisteredUser user);
  Future<void> signOut({required String userId});
  Future<bool> isThisEmailToken({required String email});
}
