import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expense_tracker/screens/auth/login_screen.dart';
import 'package:expense_tracker/screens/dashboard/dashboard_screen.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser = Rx<User?>(null);

  User? get user => firebaseUser.value;

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  @override
  void onReady() {
    super.onReady();
    firebaseUser = Rx<User?>(_auth.currentUser);
    firebaseUser.bindStream(_auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAll(() => const LoginScreen());
    } else {
      Get.offAll(() => const DashboardScreen());
    }
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      print('Login Successful');
      Get.offAll(() => const DashboardScreen());
    } catch (e) {
      errorMessage.value = e.toString();
      print('Login Failed: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;

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

      await _auth.signInWithCredential(credential);
      Get.offAll(() => const DashboardScreen());
    } catch (e) {
      errorMessage.value = e.toString();
      print('Google Sign-In Failed: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
