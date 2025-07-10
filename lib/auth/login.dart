import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<void> login(String email, String password) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  }
}

Future<void> signInWithGoogle() async {
  try {
    // For web, we need to specify the client ID
    final GoogleSignIn googleSignIn = GoogleSignIn(
      clientId:
          '661850068763-09ivm7v2ffl1i4opumf4s37u1hpnotch.apps.googleusercontent.com',
    );

    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled');
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    throw Exception(e.message);
  } catch (e) {
    throw Exception('Google sign-in failed: $e');
  }
}
