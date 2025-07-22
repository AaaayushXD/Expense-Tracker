import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'controllers/login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _handleLoginWithGoogle(BuildContext context) async {
    try {
      await LoginController().signInWithGoogle();
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Google sign-in failed: ${e.toString()}',
              style: TextStyle(fontSize: 14.sp),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 120.h,
                width: 120.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF005BEA).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(60.r),
                ),
                child: Icon(
                  Icons.account_balance_wallet,
                  size: 60.sp,
                  color: const Color(0xFF005BEA),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 48.h),
              SignInButton(
                Buttons.Google,
                text: 'Sign in with Google',
                onPressed: () => _handleLoginWithGoogle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
