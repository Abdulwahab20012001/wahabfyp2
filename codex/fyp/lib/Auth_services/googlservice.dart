import 'package:firebase_auth/firebase_auth.dart';
//import 'package:fyp/Auth_screens/teacher_singin.dart';
import 'package:google_sign_in/google_sign_in.dart';

class google {
  final GoogleSignIn googleSignin = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> handleSignIn() async {
    try {
      GoogleSignInAccount? googleUser = await googleSignin.signIn();
      if (googleUser != null) {
        GoogleSignInAuthentication googleauth = await googleUser.authentication;
        AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleauth.accessToken,
          idToken: googleauth.idToken,
        );
        await _firebaseAuth.signInWithCredential(credential);
      }
    } catch (e) {
      print("Error $e");
    }
  }

  Future<void> handleSignOut() async {
    try {
      await googleSignin.signOut();
      await _firebaseAuth.signOut();
    } catch (e) {
      print("Error $e");
    }
  }
}
