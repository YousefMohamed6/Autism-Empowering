import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {

  Future<void> signInWithGoogleWeb() async {
    final GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters({'login_hint': 'user@gmail.com'});
    await FirebaseAuth.instance.signInWithPopup(googleProvider);
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displyName,
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await FirebaseAuth.instance.currentUser?.updateDisplayName(displyName);
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
