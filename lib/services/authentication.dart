import 'package:firebase_auth/firebase_auth.dart' as fa;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:chat_app/services/database.dart';

class Authentication {
  static final GoogleSignIn _googleSignIn = GoogleSignIn();
  static final fa.FirebaseAuth _auth = fa.FirebaseAuth.instance;

  static Future<void> handleLogin() async {
    fa.User user;
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;

    final fa.AuthCredential credential = fa.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    final fa.UserCredential authResult = await _auth.signInWithCredential(credential);
    user = authResult.user;

    if (authResult.additionalUserInfo.isNewUser)
      await Database.addUser(user);
  }

  static Future<void> handleLogout() async {
    await _auth.signOut();
  }
}