import 'package:firebase_auth/firebase_auth.dart';

abstract class FirebaseAuthRemoteDataSource {
  Future<User> signIn({required String email, required String password});
  Future<User> signUp({required String email, required String password});
  Future signOut();
  Future<bool> isThisEmailToken({required String email});
  googleAuthentication();
}

class FirebaseAuthRemoteDataSourceImpl implements FirebaseAuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  get user => _firebaseAuth.currentUser;

  @override
  Future<User> signIn({required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;
    return user;
  }

  @override
  Future<User> signUp({required String email, required String password}) async {
    UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    final user = result.user!;
    return user;
  }

  @override
  googleAuthentication() async {
    print("object");
  }

  @override
  Future signOut() async => await _firebaseAuth.signOut();

  @override
  Future<bool> isThisEmailToken({required String email}) async {
    List<String> data = await _firebaseAuth.fetchSignInMethodsForEmail(email);
    return data.isNotEmpty;
  }
}
