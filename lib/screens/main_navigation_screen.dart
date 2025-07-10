import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'dart:io';
import '../services/image_service.dart';
import 'add_expense_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'analytics/analytics_screen.dart';
import 'wallet/wallet_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const AnalyticsScreen(),
    const SizedBox(), // Placeholder for add expense
    const WalletScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildBottomNavigation() {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: Colors.white,
      buttonBackgroundColor: Colors.blue,
      height: 60.0,
      animationDuration: const Duration(milliseconds: 300),
      index: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });

        if (index == 2) {
          // Handle add expense button
          _onAddExpenseTapped();
        }
      },
      items: [
        Icon(
          Icons.home,
          size: 24.sp,
          color: _currentIndex == 0 ? Colors.white : Colors.grey[600],
        ),
        Icon(
          Icons.analytics,
          size: 24.sp,
          color: _currentIndex == 1 ? Colors.white : Colors.grey[600],
        ),
        Icon(
          Icons.add,
          size: 28.sp,
          color: _currentIndex == 2 ? Colors.white : Colors.grey[600],
        ),
        Icon(
          Icons.account_balance_wallet,
          size: 24.sp,
          color: _currentIndex == 3 ? Colors.white : Colors.grey[600],
        ),
        Icon(
          Icons.person,
          size: 24.sp,
          color: _currentIndex == 4 ? Colors.white : Colors.grey[600],
        ),
      ],
    );

    // Alternative: If you want to add labels, you can use this approach:
    // return CurvedNavigationBar(
    //   backgroundColor: Colors.transparent,
    //   color: Colors.white,
    //   buttonBackgroundColor: Colors.blue,
    //   height: 75.h,
    //   animationDuration: const Duration(milliseconds: 300),
    //   index: _currentIndex,
    //   onTap: (index) {
    //     if (index == 2) {
    //       _onAddExpenseTapped();
    //     } else {
    //       setState(() {
    //         _currentIndex = index;
    //       });
    //     }
    //   },
    //   items: [
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.home, size: 24.sp, color: Colors.white),
    //         SizedBox(height: 2.h),
    //         Text('Home', style: TextStyle(fontSize: 10.sp, color: Colors.white)),
    //       ],
    //     ),
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.analytics, size: 24.sp, color: Colors.white),
    //         SizedBox(height: 2.h),
    //         Text('Analytics', style: TextStyle(fontSize: 10.sp, color: Colors.white)),
    //       ],
    //     ),
    //     Icon(Icons.add, size: 28.sp, color: Colors.white),
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.account_balance_wallet, size: 24.sp, color: Colors.white),
    //         SizedBox(height: 2.h),
    //         Text('Wallet', style: TextStyle(fontSize: 10.sp, color: Colors.white)),
    //       ],
    //     ),
    //     Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Icon(Icons.person, size: 24.sp, color: Colors.white),
    //         SizedBox(height: 2.h),
    //         Text('Profile', style: TextStyle(fontSize: 10.sp, color: Colors.white)),
    //       ],
    //     ),
    //   ],
    // );
  }

  void _onAddExpenseTapped() async {
    // Store the previous index before navigating
    final previousIndex = _currentIndex;

    // Show image picker bottom sheet
    final File? selectedImage = await ImageService.pickImage(context);

    if (selectedImage != null) {
      // Show success message for selected image
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Receipt image selected (${ImageService.getImageSizeInMB(selectedImage).toStringAsFixed(2)} MB)',
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }

      // Navigate to add expense screen
      if (mounted) {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
        );

        // Handle result if needed
        if (result == true && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Expense added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    }

    // Reset to previous index
    setState(() {
      _currentIndex = previousIndex;
    });
  }
}
