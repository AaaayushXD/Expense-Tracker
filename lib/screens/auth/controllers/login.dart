import 'package:expense_tracker/services/auth/auth_api_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:expense_tracker/screens/auth/login_screen.dart';
import 'package:expense_tracker/services/api_service.dart';
import 'package:expense_tracker/utils/auth_error_handler.dart';
import '../../../screens/main_navigation_screen.dart';

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
      Get.offAll(() => const MainNavigationScreen());
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      isLoading.value = true;
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            '661850068763-09ivm7v2ffl1i4opumf4s37u1hpnotch.apps.googleusercontent.com',
      );
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign-in was cancelled');
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      print('Google Sign-In Successful: ${userCredential.user}');
      if (userCredential.user != null) {
        // Call backend to check/add user and generate token
        final tokenResult = await ApiService.generateToken(
          email: userCredential.user!.email!,
          userId: userCredential.user!.uid,
          name: userCredential.user!.displayName,
        );
        print("Token Generation Result: $tokenResult");
        if (tokenResult['success']) {
          print('Google Sign-In Successful - Token generated');
          Get.offAll(() => const MainNavigationScreen());
        } else {
          print(
            'Google Sign-In Successful but token generation failed: ${tokenResult['error']}',
          );
          Get.offAll(() => const MainNavigationScreen());
          Get.snackbar(
            'Warning',
            'Google sign-in successful but token generation failed. Some features may not work properly.',
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
      errorMessage.value = e.toString();
      print('Google Sign-In Failed: $e');
      final userFriendlyMessage = AuthErrorHandler.getErrorMessage(e);
      final errorColor = AuthErrorHandler.getErrorColor(e);
      final errorIcon = AuthErrorHandler.getErrorIcon(e);
      Get.snackbar(
        'Google Sign-In Failed',
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
    } finally {
      isLoading.value = false;
    }
  }
}
