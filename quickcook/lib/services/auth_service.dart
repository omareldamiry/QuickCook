import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth;

  AuthService(this._firebaseAuth);

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return "Signed in";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      return "Signed up";
    } on FirebaseAuthException catch (e) {
      print("Sign Up Failed");
      return e.message;
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    AuthCredential credential = EmailAuthProvider.credential(
      email: FirebaseAuth.instance.currentUser!.email!,
      password: oldPassword,
    );

// Reauthenticate
    try {
      await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(credential);

      await _firebaseAuth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      print(e.message);
    }
  }

  Future<void> deleteUser() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print(
            'The user must reauthenticate before this operation can be executed.');
      }
    }
  }
}
