import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../firebase_options.dart';

const clientId =
    '661850068763-09ivm7v2ffl1i4opumf4s37u1hpnotch.apps.googleusercontent.com';

void main() async {
  // Add from here...
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}
