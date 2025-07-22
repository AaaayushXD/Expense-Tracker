import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/auth/login_screen.dart';
import '../screens/main_navigation_screen.dart';

StreamBuilder<User?> authStateChanges(BuildContext context) {
  return StreamBuilder<User?>(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      if (snapshot.hasData) {
        return const MainNavigationScreen();
      }
      return const LoginScreen();
    },
  );
}
