import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense_tracker/screens/auth/login_screen.dart';
import 'package:expense_tracker/services/api_service.dart';
import 'package:expense_tracker/utils/auth_error_handler.dart';
import '../../../screens/main_navigation_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
      Get.offAll(() => const MainNavigationScreen());
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Call backend signup API
        final response = await ApiService.registerUser(
          name: name,
          email: email,
          password: password,
        );

        if (response['success']) {
          print('Signup Successful - Backend user registered');
          Get.offAll(() => const MainNavigationScreen());
          Get.snackbar(
            'Signup Successful',
            'Welcome to the app!',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            icon: const Icon(Icons.check_circle, color: Colors.white),
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
          );
        } else {
          print(
            'Signup Successful but backend registration failed: ${response['message']}',
          );
          Get.snackbar(
            'Warning',
            'Signup successful but backend registration failed.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            icon: const Icon(Icons.warning_amber, color: Colors.white),
            duration: const Duration(seconds: 4),
            snackPosition: SnackPosition.TOP,
            margin: const EdgeInsets.all(16),
            borderRadius: 8,
            isDismissible: true,
            dismissDirection: DismissDirection.horizontal,
          );
        }
      }
    } catch (e) {
      print('Signup Failed: $e');
      final userFriendlyMessage = AuthErrorHandler.getErrorMessage(e);
      final errorColor = AuthErrorHandler.getErrorColor(e);
      final errorIcon = AuthErrorHandler.getErrorIcon(e);

      Get.snackbar(
        'Signup Failed',
        userFriendlyMessage,
        backgroundColor: errorColor,
        colorText: Colors.white,
        icon: Icon(errorIcon, color: Colors.white),
        duration: const Duration(seconds: 4),
        snackPosition: SnackPosition.TOP,
        margin: const EdgeInsets.all(16),
        borderRadius: 8,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      );
    }
  }

  Future<void> signupWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google sign-in cancelled');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // You can use googleUser.displayName, googleUser.email
      // Use googleAuth.idToken or generate a random password
      final name = googleUser.displayName ?? 'Google User';
      final email = googleUser.email;
      final password =
          googleAuth.idToken ??
          DateTime.now().millisecondsSinceEpoch.toString();

      // Register user in backend
      final response = await ApiService.registerUser(
        name: name,
        email: email,
        password: password,
      );

      if (response['success']) {
        print('Google Signup Successful - Backend user registered');
        Get.offAll(() => const MainNavigationScreen());
        Get.snackbar(
          'Signup Successful',
          'Welcome to the app!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );
      } else {
        print(
          'Google Signup Successful but backend registration failed: ${response['message']}',
        );
        Get.snackbar(
          'Warning',
          'Google signup successful but backend registration failed.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          icon: const Icon(Icons.warning_amber, color: Colors.white),
          duration: const Duration(seconds: 4),
          snackPosition: SnackPosition.TOP,
          margin: const EdgeInsets.all(16),
          borderRadius: 8,
          isDismissible: true,
          dismissDirection: DismissDirection.horizontal,
        );
      }
    } catch (e) {
      print('Google Signup Failed: $e');
      Get.snackbar(
        'Signup Failed',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
