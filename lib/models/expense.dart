import 'dart:io';
import 'package:flutter/material.dart';

enum TransactionType { expense, revenue }

class Expense {
  final String? id;
  final String title;
  final String category;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;
  final String? imagePath;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Expense({
    this.id,
    required this.title,
    required this.category,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
    this.imagePath,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      type: json['type'] == 'revenue'
          ? TransactionType.revenue
          : TransactionType.expense,
      imagePath: json['image_path'],
      userId: json['user_id'] ?? '',
      createdAt: DateTime.parse(
        json['created_at'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updated_at'] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'type': type == TransactionType.revenue ? 'revenue' : 'expense',
      'image_path': imagePath,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Expense copyWith({
    String? id,
    String? title,
    String? category,
    double? amount,
    String? description,
    DateTime? date,
    TransactionType? type,
    String? imagePath,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Expense(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      date: date ?? this.date,
      type: type ?? this.type,
      imagePath: imagePath ?? this.imagePath,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Helper methods
  String get formattedAmount {
    final prefix = type == TransactionType.expense ? '-\$' : '+\$';
    return '$prefix${amount.toStringAsFixed(2)}';
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final expenseDate = DateTime(date.year, date.month, date.day);

    if (expenseDate == today) {
      return 'Today, ${_formatTime(date)}';
    } else if (expenseDate == yesterday) {
      return 'Yesterday, ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year}, ${_formatTime(date)}';
    }
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Color get amountColor {
    return type == TransactionType.expense ? Colors.red : Colors.green;
  }

  IconData get categoryIcon {
    switch (category.toLowerCase()) {
      case 'food':
        return Icons.restaurant;
      case 'transport':
        return Icons.directions_car;
      case 'shopping':
        return Icons.shopping_cart;
      case 'entertainment':
        return Icons.movie;
      case 'bills':
        return Icons.receipt;
      case 'health':
        return Icons.local_hospital;
      case 'education':
        return Icons.school;
      case 'salary':
        return Icons.work;
      case 'freelance':
        return Icons.computer;
      case 'investment':
        return Icons.trending_up;
      case 'other':
      default:
        return Icons.category;
    }
  }

  Color get categoryColor {
    switch (category.toLowerCase()) {
      case 'food':
        return Colors.orange;
      case 'transport':
        return Colors.blue;
      case 'shopping':
        return Colors.purple;
      case 'entertainment':
        return Colors.red;
      case 'bills':
        return Colors.indigo;
      case 'health':
        return Colors.green;
      case 'education':
        return Colors.teal;
      case 'salary':
        return Colors.green;
      case 'freelance':
        return Colors.blue;
      case 'investment':
        return Colors.amber;
      case 'other':
      default:
        return Colors.grey;
    }
  }
}
