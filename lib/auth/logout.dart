import 'package:firebase_auth/firebase_auth.dart';
import '../services/api_service.dart';

Future<void> logout() async {
  // Clear stored token and user data
  await ApiService.clearStoredAuth();

  // Sign out from Firebase
  await FirebaseAuth.instance.signOut();
}
