import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
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
    const DashboardScreen(), // Use DashboardScreen as placeholder for add expense
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
        if (index == 2) {
          // Handle add expense button - don't change current index
          _onAddExpenseTapped();
        } else {
          setState(() {
            _currentIndex = index;
          });
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
    // Show options bottom sheet
    _showAddOptionsBottomSheet();
  }

  void _showAddOptionsBottomSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.r),
            topRight: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                children: [
                  Text(
                    'Add Transaction',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionCard(
                          icon: Icons.edit_note,
                          title: 'Manual Entry',
                          subtitle: 'Fill out the form',
                          onTap: () {
                            Navigator.pop(context);
                            _navigateToAddExpense();
                          },
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _buildOptionCard(
                          icon: Icons.document_scanner,
                          title: 'Scan Receipt',
                          subtitle: 'Upload and save document',
                          onTap: () async {
                            Navigator.pop(context); // Close the bottom sheet
                            await ImageService.pickAndUploadDocument(
                              context: context,
                              documentType: 'receipt',
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32.sp, color: Colors.blue),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToAddExpense() async {
    try {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AddExpenseScreen()),
      );

      if (result == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Error navigating to add expense: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}
