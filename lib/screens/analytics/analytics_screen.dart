import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/expense_chart.dart';
import '../../components/stat_card.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> monthlyData = [
      {'day': 'Jan', 'value': 1200.0},
      {'day': 'Feb', 'value': 980.0},
      {'day': 'Mar', 'value': 1450.0},
      {'day': 'Apr', 'value': 1100.0},
      {'day': 'May', 'value': 1350.0},
      {'day': 'Jun', 'value': 1600.0},
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Analytics',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewCards(),
              SizedBox(height: 24.h),
              _buildMonthlyChart(monthlyData),
              SizedBox(height: 24.h),
              _buildCategoryBreakdown(),
              SizedBox(height: 24.h),
              _buildSpendingInsights(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCards() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: StatCard(
                title: 'This Month',
                value: '\$2,450',
                subtitle: 'Total spending',
                icon: Icons.calendar_month,
                color: Colors.blue,
                isPositive: true,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: StatCard(
                title: 'Average/Day',
                value: '\$81.67',
                subtitle: 'Daily spending',
                icon: Icons.trending_up,
                color: Colors.orange,
                isPositive: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMonthlyChart(List<Map<String, dynamic>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Monthly Spending',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        ExpenseChart(data: data, maxValue: 1600),
      ],
    );
  }

  Widget _buildCategoryBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category Breakdown',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Container(
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
              _buildCategoryItem('Food & Dining', 35, Colors.orange),
              SizedBox(height: 16.h),
              _buildCategoryItem('Transportation', 25, Colors.blue),
              SizedBox(height: 16.h),
              _buildCategoryItem('Shopping', 20, Colors.purple),
              SizedBox(height: 16.h),
              _buildCategoryItem('Entertainment', 15, Colors.red),
              SizedBox(height: 16.h),
              _buildCategoryItem('Bills', 5, Colors.green),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String category, double percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 12.w,
          height: 12.h,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            category,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          '${percentage.toInt()}%',
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildSpendingInsights() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spending Insights',
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        Container(
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
              _buildInsightItem(
                Icons.trending_up,
                'Your spending is 15% higher than last month',
                Colors.orange,
              ),
              SizedBox(height: 16.h),
              _buildInsightItem(
                Icons.restaurant,
                'Food expenses increased by 25%',
                Colors.red,
              ),
              SizedBox(height: 16.h),
              _buildInsightItem(
                Icons.savings,
                'You saved \$300 more than last month',
                Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInsightItem(IconData icon, String text, Color color) {
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
            text,
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}
