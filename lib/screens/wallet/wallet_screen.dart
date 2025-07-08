import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Wallet',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.add, size: 24.sp),
            onPressed: () {
              // TODO: Add money to wallet
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(),
              SizedBox(height: 24.h),
              _buildQuickActions(),
              SizedBox(height: 24.h),
              _buildRecentTransactions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.blue, Colors.purple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withValues(alpha: 0.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Balance',
            style: TextStyle(color: Colors.white70, fontSize: 16.sp),
          ),
          SizedBox(height: 8.h),
          Text(
            '\$2,450.75',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem('Income', '\$4,200', Colors.green),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: _buildBalanceItem('Expenses', '\$1,749.25', Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceItem(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white70, fontSize: 14.sp),
        ),
        SizedBox(height: 4.h),
        Text(
          amount,
          style: TextStyle(
            color: color,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                'Add Money',
                Icons.add_circle_outline,
                Colors.green,
                () {},
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildActionCard(
                'Send Money',
                Icons.send,
                Colors.blue,
                () {},
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: _buildActionCard(
                'Request',
                Icons.request_page,
                Colors.orange,
                () {},
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(height: 12.h),
            Text(
              title,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTransactions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to all transactions
              },
              child: Text(
                'View All',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              _buildTransactionItem(
                'Salary',
                'Income',
                '+\$4,200',
                'Today, 9:00 AM',
                Icons.account_balance,
                Colors.green,
              ),
              _buildTransactionItem(
                'Grocery Shopping',
                'Expense',
                '-\$45.20',
                'Today, 2:30 PM',
                Icons.shopping_cart,
                Colors.red,
              ),
              _buildTransactionItem(
                'Uber Ride',
                'Expense',
                '-\$23.50',
                'Today, 1:15 PM',
                Icons.directions_car,
                Colors.blue,
              ),
              _buildTransactionItem(
                'Freelance Payment',
                'Income',
                '+\$500',
                'Yesterday, 5:30 PM',
                Icons.work,
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(
    String title,
    String type,
    String amount,
    String time,
    IconData icon,
    Color color,
  ) {
    return ListTile(
      leading: Container(
        width: 40.w,
        height: 40.h,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: color, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.sp),
      ),
      subtitle: Text(
        '$type • $time',
        style: TextStyle(color: Colors.grey[600], fontSize: 12.sp),
      ),
      trailing: Text(
        amount,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
      ),
    );
  }
}
