import 'package:expense_tracker/services/api_service.dart';
import 'package:expense_tracker/services/expense/expense_api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // Expense controllers
  final _expenseCategoryController = TextEditingController();
  final _expenseAmountController = TextEditingController();
  final _expenseDescriptionController = TextEditingController();
  DateTime _expenseDate = DateTime.now();

  // Revenue controllers
  final _revenueCategoryController = TextEditingController();
  final _revenueAmountController = TextEditingController();
  final _revenueDescriptionController = TextEditingController();
  DateTime _revenueDate = DateTime.now();

  // Month controller
  DateTime _transactionMonth = DateTime.now();

  @override
  void dispose() {
    _expenseCategoryController.dispose();
    _expenseAmountController.dispose();
    _expenseDescriptionController.dispose();
    _revenueCategoryController.dispose();
    _revenueAmountController.dispose();
    _revenueDescriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(
      BuildContext context, Function(DateTime) onDateSelected) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        onDateSelected(picked);
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final userId = await ApiService.getStoredUserId();
        final token = await ApiService.getStoredToken();

        if (userId == null || token == null) {
          throw Exception('User not authenticated');
        }

        final expense = Expense(
          category: _expenseCategoryController.text,
          amount: double.parse(_expenseAmountController.text),
          description: _expenseDescriptionController.text,
          date: _expenseDate,
        );

        final revenue = Revenue(
          category: _revenueCategoryController.text,
          amount: double.parse(_revenueAmountController.text),
          description: _revenueDescriptionController.text,
          date: _revenueDate,
        );

        await ExpenseApiService.addMonthlyTransaction(
          userId: userId,
          expense: expense,
          revenue: revenue,
          month: _transactionMonth,
          processedBy: 'manual',
          uploadedBy: userId,
          token: token,
        );

        if (mounted) {
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to add transaction: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Manual Transaction'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Expense Details',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16.h),
                    _buildTextField(_expenseCategoryController, 'Category'),
                    SizedBox(height: 12.h),
                    _buildTextField(_expenseAmountController, 'Amount',
                        keyboardType: TextInputType.number),
                    SizedBox(height: 12.h),
                    _buildTextField(_expenseDescriptionController, 'Description'),
                    SizedBox(height: 12.h),
                    _buildDatePicker(
                        (date) => _expenseDate = date, _expenseDate, 'Expense Date'),
                    SizedBox(height: 24.h),
                    const Divider(),
                    SizedBox(height: 24.h),
                    Text('Revenue Details',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16.h),
                    _buildTextField(_revenueCategoryController, 'Category'),
                    SizedBox(height: 12.h),
                    _buildTextField(_revenueAmountController, 'Amount',
                        keyboardType: TextInputType.number),
                    SizedBox(height: 12.h),
                    _buildTextField(_revenueDescriptionController, 'Description'),
                    SizedBox(height: 12.h),
                    _buildDatePicker(
                        (date) => _revenueDate = date, _revenueDate, 'Revenue Date'),
                    SizedBox(height: 24.h),
                    const Divider(),
                    SizedBox(height: 24.h),
                    Text('Transaction Month',
                        style: Theme.of(context).textTheme.titleLarge),
                    SizedBox(height: 16.h),
                    _buildDatePicker((date) => _transactionMonth = date,
                        _transactionMonth, 'Transaction Month'),
                    SizedBox(height: 32.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                        ),
                        child: const Text('Add Transaction'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a $label';
        }
        if (keyboardType == TextInputType.number) {
          if (double.tryParse(value) == null) {
            return 'Please enter a valid number';
          }
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker(
      Function(DateTime) onDateSelected, DateTime selectedDate, String label) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '$label: ${DateFormat.yMMMd().format(selectedDate)}',
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        TextButton(
          onPressed: () => _selectDate(context, onDateSelected),
          child: const Text('Select Date'),
        ),
      ],
    );
  }
}