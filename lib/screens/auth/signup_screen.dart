import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/custom_text_field.dart';
import '../../components/custom_button.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'controllers/signup.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    try {
      await SignupController().signup(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
    } catch (e) {
      print('Signup Failed: $e');
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString(), style: TextStyle(fontSize: 14.sp)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleSignupWithGoogle() async {
    try {
      await SignupController().signupWithGoogle();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Signup Successful',
              style: TextStyle(fontSize: 14.sp),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Signup Failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString(), style: TextStyle(fontSize: 14.sp)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToLogin() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 60.h),
                // App Logo/Icon
                Container(
                  height: 120.h,
                  width: 120.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF005BEA).withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(60.r),
                  ),
                  child: Icon(
                    Icons.account_balance_wallet,
                    size: 60.sp,
                    color: const Color(0xFF005BEA),
                  ),
                ),
                SizedBox(height: 32.h),
                // Welcome Text
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  'Sign up to start tracking your expenses',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 48.h),
                // Name Field
                CustomTextField(
                  label: 'Name',
                  hint: 'Enter your name',
                  controller: _nameController,
                  validator: _validateName,
                  prefixIcon: Icon(
                    Icons.person_outline,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                // Email Field
                CustomTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  prefixIcon: Icon(
                    Icons.email_outlined,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                // Password Field
                CustomTextField(
                  label: 'Password',
                  hint: 'Create a password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: _validatePassword,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: 20.h),
                // Confirm Password Field
                CustomTextField(
                  label: 'Confirm Password',
                  hint: 'Re-enter your password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  validator: _validateConfirmPassword,
                  prefixIcon: Icon(
                    Icons.lock_outline,
                    color: Colors.grey,
                    size: 20.sp,
                  ),
                ),
                SizedBox(height: 32.h),
                // Signup Button
                CustomButton(
                  text: 'Sign Up',
                  onPressed: _handleSignup,
                  isLoading: false,
                  icon: Icon(
                    Icons.person_add,
                    size: 20.sp,
                    color: Colors.white,
                  ),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF005BEA), Color(0xFF00C6FB)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16.h),
                SignInButton(
                  Buttons.Google,
                  text: 'Sign up with Google',
                  onPressed: _handleSignupWithGoogle,
                ),
                SizedBox(height: 32.h),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: _navigateToLogin,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
