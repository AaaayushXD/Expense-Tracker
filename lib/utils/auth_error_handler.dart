import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthErrorHandler {
  /// Convert Firebase Auth exceptions to user-friendly messages
  static String getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        // Login errors
        case 'user-not-found':
          return 'No account found with this email address. Please check your email or sign up.';
        case 'wrong-password':
          return 'Incorrect password. Please try again.';
        case 'invalid-email':
          return 'Please enter a valid email address.';
        case 'user-disabled':
          return 'This account has been disabled. Please contact support.';
        case 'too-many-requests':
          return 'Too many failed attempts. Please try again later.';
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled. Please contact support.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection and try again.';

        // Signup errors
        case 'email-already-in-use':
          return 'An account with this email already exists. Please try logging in instead.';
        case 'weak-password':
          return 'Password is too weak. Please choose a stronger password (at least 6 characters).';
        case 'invalid-credential':
          return 'Invalid credentials. Please check your email and password.';

        // Google Auth errors
        case 'account-exists-with-different-credential':
          return 'An account already exists with the same email address but different sign-in credentials.';
        case 'invalid-verification-code':
          return 'Invalid verification code. Please try again.';
        case 'invalid-verification-id':
          return 'Invalid verification ID. Please try again.';

        // General errors
        case 'requires-recent-login':
          return 'This operation requires recent authentication. Please log in again.';
        case 'credential-already-in-use':
          return 'This credential is already associated with a different user account.';
        case 'provider-already-linked':
          return 'This provider is already linked to your account.';
        case 'no-such-provider':
          return 'No such provider is linked to your account.';
        case 'invalid-user-token':
          return 'Your session has expired. Please log in again.';
        case 'user-token-expired':
          return 'Your session has expired. Please log in again.';
        case 'user-mismatch':
          return 'The provided credentials do not correspond to the previously signed in user.';
        case 'invalid-api-key':
          return 'Invalid API key. Please contact support.';
        case 'app-not-authorized':
          return 'This app is not authorized to use Firebase Authentication.';
        case 'quota-exceeded':
          return 'Quota exceeded. Please try again later.';
        case 'keychain-error':
          return 'Keychain error. Please try again.';
        case 'internal-error':
          return 'An internal error occurred. Please try again.';
        case 'invalid-app-credential':
          return 'Invalid app credential. Please try again.';
        case 'invalid-app-id':
          return 'Invalid app ID. Please contact support.';
        case 'invalid-argument':
          return 'Invalid argument provided. Please try again.';
        case 'invalid-continue-uri':
          return 'Invalid continue URI. Please try again.';
        case 'invalid-custom-token':
          return 'Invalid custom token. Please try again.';
        case 'invalid-dynamic-link-domain':
          return 'Invalid dynamic link domain. Please try again.';
        case 'invalid-oauth-client-id':
          return 'Invalid OAuth client ID. Please contact support.';
        case 'invalid-oauth-provider':
          return 'Invalid OAuth provider. Please try again.';
        case 'invalid-persistence-type':
          return 'Invalid persistence type. Please try again.';
        case 'invalid-phone-number':
          return 'Invalid phone number. Please try again.';
        case 'invalid-recipient-email':
          return 'Invalid recipient email. Please try again.';
        case 'invalid-sender':
          return 'Invalid sender. Please try again.';
        case 'invalid-tenant-id':
          return 'Invalid tenant ID. Please try again.';
        case 'missing-android-pkg-name':
          return 'Missing Android package name. Please contact support.';
        case 'missing-app-credential':
          return 'Missing app credential. Please try again.';
        case 'missing-continue-uri':
          return 'Missing continue URI. Please try again.';
        case 'missing-ios-bundle-id':
          return 'Missing iOS bundle ID. Please contact support.';
        case 'missing-or-invalid-nonce':
          return 'Missing or invalid nonce. Please try again.';
        case 'missing-phone-number':
          return 'Missing phone number. Please try again.';
        case 'missing-verification-code':
          return 'Missing verification code. Please try again.';
        case 'missing-verification-id':
          return 'Missing verification ID. Please try again.';
        case 'popup-blocked':
          return 'Popup was blocked by the browser. Please allow popups and try again.';
        case 'popup-closed-by-user':
          return 'Sign-in popup was closed before completing the process. Please try again.';
        case 'redirect-cancelled-by-user':
          return 'Sign-in was cancelled. Please try again.';
        case 'redirect-operation-pending':
          return 'A redirect operation is already pending. Please wait.';
        case 'rejected-credential':
          return 'Sign-in was rejected. Please try again.';
        case 'second-factor-already-in-use':
          return 'Second factor is already in use. Please try again.';
        case 'second-factor-required':
          return 'Second factor authentication is required. Please try again.';
        case 'session-expired':
          return 'Your session has expired. Please log in again.';
        case 'sms-quota-exceeded':
          return 'SMS quota exceeded. Please try again later.';
        case 'unauthorized-domain':
          return 'This domain is not authorized for OAuth operations.';
        case 'unsupported-first-factor':
          return 'Unsupported first factor. Please try again.';
        case 'unsupported-persistence-type':
          return 'Unsupported persistence type. Please try again.';
        case 'unsupported-tenant-operation':
          return 'Unsupported tenant operation. Please try again.';
        case 'web-storage-unsupported':
          return 'Web storage is not supported. Please try again.';

        default:
          return 'Authentication failed: ${error.message ?? 'Unknown error'}';
      }
    } else if (error is Exception) {
      return error.toString().replaceAll('Exception: ', '');
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }

  /// Get appropriate snackbar color based on error type
  static Color getErrorColor(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-email':
        case 'weak-password':
        case 'email-already-in-use':
          return Colors.red;
        case 'too-many-requests':
        case 'quota-exceeded':
        case 'sms-quota-exceeded':
          return Colors.orange;
        case 'network-request-failed':
          return Colors.blue;
        default:
          return Colors.red;
      }
    }
    return Colors.red;
  }

  /// Get appropriate snackbar icon based on error type
  static IconData getErrorIcon(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-email':
        case 'weak-password':
        case 'email-already-in-use':
          return Icons.error_outline;
        case 'too-many-requests':
        case 'quota-exceeded':
        case 'sms-quota-exceeded':
          return Icons.warning_amber_outlined;
        case 'network-request-failed':
          return Icons.wifi_off_outlined;
        default:
          return Icons.error_outline;
      }
    }
    return Icons.error_outline;
  }
}
