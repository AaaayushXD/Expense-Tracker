import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, size: 24.sp),
            onPressed: () {
              // TODO: Edit profile
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              _buildProfileHeader(),
              SizedBox(height: 24.h),
              _buildStatsSection(),
              SizedBox(height: 24.h),
              _buildSettingsSection(),
              SizedBox(height: 24.h),
              _buildLogoutButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.blue.withValues(alpha: 0.1),
            child: Icon(Icons.person, size: 60.sp, color: Colors.blue),
          ),
          SizedBox(height: 16.h),
          Text(
            'John Doe',
            style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Text(
            'john.doe@example.com',
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildProfileStat('Total Expenses', '\$2,450'),
              _buildProfileStat('Total Income', '\$4,200'),
              _buildProfileStat('Savings', '\$1,750'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Statistics',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.h),
          _buildStatItem(
            'Member Since',
            'January 2024',
            Icons.calendar_today,
            Colors.blue,
          ),
          SizedBox(height: 12.h),
          _buildStatItem(
            'Total Transactions',
            '156',
            Icons.receipt_long,
            Colors.green,
          ),
          SizedBox(height: 12.h),
          _buildStatItem('Categories Used', '8', Icons.category, Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
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
          _buildSettingItem(
            'Notifications',
            Icons.notifications_outlined,
            () {},
          ),
          _buildSettingItem('Privacy & Security', Icons.security, () {}),
          _buildSettingItem('Currency', Icons.attach_money, () {}),
          _buildSettingItem('Export Data', Icons.download, () {}),
          _buildSettingItem('Help & Support', Icons.help_outline, () {}),
          _buildSettingItem('About', Icons.info_outline, () {}),
        ],
      ),
    );
  }

  Widget _buildSettingItem(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600], size: 24.sp),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.sp),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.grey, size: 20.sp),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton() {
    return CustomButton(
      text: 'Logout',
      onPressed: () {
        // TODO: Implement logout
      },
      backgroundColor: Colors.red,
      textColor: Colors.white,
      isOutlined: true,
    );
  }
}
