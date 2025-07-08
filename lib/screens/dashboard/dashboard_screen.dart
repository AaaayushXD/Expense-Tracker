import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../components/stat_card.dart';
import '../../components/expense_chart.dart';
import '../../components/category_filter.dart';
import '../../components/expense_card.dart';
import '../../components/custom_button.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Food',
    'Transport',
    'Shopping',
    'Bills',
  ];

  final List<Map<String, dynamic>> chartData = [
    {'day': 'Mon', 'value': 120},
    {'day': 'Tue', 'value': 85},
    {'day': 'Wed', 'value': 200},
    {'day': 'Thu', 'value': 150},
    {'day': 'Fri', 'value': 180},
    {'day': 'Sat', 'value': 220},
    {'day': 'Sun', 'value': 95},
  ];

  final List<Map<String, dynamic>> recentExpenses = [
    {
      'title': 'Grocery Shopping',
      'amount': '-\$45.20',
      'category': 'Food',
      'date': 'Today, 2:30 PM',
      'icon': Icons.shopping_cart,
      'color': Colors.orange,
    },
    {
      'title': 'Uber Ride',
      'amount': '-\$12.50',
      'category': 'Transport',
      'date': 'Today, 1:15 PM',
      'icon': Icons.directions_car,
      'color': Colors.blue,
    },
    {
      'title': 'Netflix Subscription',
      'amount': '-\$15.99',
      'category': 'Entertainment',
      'date': 'Yesterday, 8:00 PM',
      'icon': Icons.tv,
      'color': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hello, John!',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Welcome back to your expense tracker',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  CircleAvatar(
                    radius: 25.r,
                    backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    child: Icon(Icons.person, color: Colors.blue, size: 30.sp),
                  ),
                ],
              ),
              SizedBox(height: 30.h),

              // Stats Cards
              SizedBox(
                height: 120.h,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: StatCard(
                        title: 'Total Spent',
                        value: '\$1,234',
                        subtitle: '+12% from last month',
                        icon: Icons.trending_up,
                        color: Colors.green,
                        isPositive: true,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    SizedBox(
                      width: 160.w,
                      child: StatCard(
                        title: 'Budget Left',
                        value: '\$766',
                        subtitle: '65% of budget remaining',
                        icon: Icons.account_balance_wallet,
                        color: Colors.blue,
                        isPositive: true,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Chart
              ExpenseChart(data: chartData, maxValue: 250),
              SizedBox(height: 24.h),

              // Category Filter
              Text(
                'Filter by Category',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 12.h),
              CategoryFilter(
                categories: categories,
                selectedCategory: selectedCategory,
                onCategorySelected: (category) {
                  setState(() {
                    selectedCategory = category;
                  });
                },
              ),
              SizedBox(height: 24.h),

              // Recent Expenses
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Expenses',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to all expenses
                    },
                    child: Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ...recentExpenses
                  .map(
                    (expense) => ExpenseCard(
                      title: expense['title'],
                      amount: expense['amount'],
                      category: expense['category'],
                      date: expense['date'],
                      icon: expense['icon'],
                      color: expense['color'],
                      onTap: () {
                        // Navigate to expense details
                      },
                    ),
                  )
                  .toList()
                  .cast<Widget>(),
              SizedBox(height: 20.h),

              // Add Expense Button
              CustomButton(
                text: 'Add New Expense',
                onPressed: () {
                  Navigator.pushNamed(context, '/add-expense');
                },
                icon: Icon(Icons.add, color: Colors.white, size: 20.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
