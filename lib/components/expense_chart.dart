import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final double maxValue;

  const ExpenseChart({super.key, required this.data, required this.maxValue});

  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Weekly Spending',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
              ),
              Text(
                '\$${maxValue.toStringAsFixed(0)}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 120.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((item) {
                final barHeight = ((item['value'] as num) / maxValue) * 100;
                final maxBarHeight =
                    80.0; // Maximum bar height in logical pixels
                final actualBarHeight = (barHeight * 0.8).clamp(
                  0.0,
                  maxBarHeight,
                );
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 30.w,
                          height: actualBarHeight.h,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.blue.withValues(alpha: 0.8),
                                Colors.blue,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          item['day'],
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
