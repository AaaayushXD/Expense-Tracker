import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/screens/auth/login_screen.dart';
import 'package:expense_tracker/screens/dashboard/dashboard_screen.dart';

class SignupController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late Rx<User?> firebaseUser = Rx<User?>(null);

  User? get user => firebaseUser.value;

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

  Future<void> signup(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAll(() => const DashboardScreen());
      Get.snackbar('Signup Successful', 'Welcome to the app!');
      print('Signup Successful');
    } catch (e) {
      print('Signup Failed: $e');
      Get.snackbar('Signup Failed', e.toString());
    }
  }

  Future<void> signupWithGoogle() async {
    try {
      await _auth.signInWithProvider(GoogleAuthProvider());
      Get.offAll(() => const DashboardScreen());
      Get.snackbar('Signup Successful', 'Welcome to the app!');
      print('Signup Successful');
    } catch (e) {
      print('Google Signup Failed: $e');
      Get.snackbar('Google Signup Failed', e.toString());
    }
  }
}
