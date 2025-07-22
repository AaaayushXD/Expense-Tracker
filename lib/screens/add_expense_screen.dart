import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import '../components/custom_button.dart';
import '../components/custom_text_field.dart';
import '../components/image_picker_widget.dart';
import '../models/expense.dart';
import '../services/ocr_service.dart';

class AddExpenseScreen extends StatefulWidget {
  final File? initialImage;
  final Map<String, dynamic>? ocrData;

  const AddExpenseScreen({super.key, this.initialImage, this.ocrData});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  String _selectedCategory = 'Food';
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  bool _isProcessingOcr = false;

  final List<String> _expenseCategories = [
    'Food',
    'Transport',
    'Shopping',
    'Entertainment',
    'Bills',
    'Health',
    'Education',
    'Other',
  ];

  final List<String> _revenueCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Other',
  ];

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDate(_selectedDate);

    // Initialize with OCR data if provided
    if (widget.ocrData != null) {
      _populateFromOcrData(widget.ocrData!);
    }

    // Set initial image if provided
    if (widget.initialImage != null) {
      _selectedImage = widget.initialImage;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _populateFromOcrData(Map<String, dynamic> ocrData) {
    setState(() {
      _titleController.text = ocrData['title'] ?? '';
      _amountController.text = (ocrData['amount'] ?? 0.0).toString();
      _descriptionController.text = ocrData['description'] ?? '';
      _selectedCategory = ocrData['category'] ?? 'Other';

      if (ocrData['date'] != null) {
        try {
          _selectedDate = DateTime.parse(ocrData['date']);
          _dateController.text = _formatDate(_selectedDate);
        } catch (e) {
          // Keep current date if parsing fails
        }
      }
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _formatDate(picked);
      });
    }
  }

  Future<void> _processImageWithOcr() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessingOcr = true;
    });

    try {
      // Use mock OCR for development
      final result = await OcrService.mockProcessReceipt(_selectedImage!);

      if (result['success']) {
        _populateFromOcrData(result['data']);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Receipt processed successfully!',
              style: TextStyle(fontSize: 14.sp),
            ),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to process receipt: ${result['error']}',
              style: TextStyle(fontSize: 14.sp),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error processing receipt: $e',
            style: TextStyle(fontSize: 14.sp),
          ),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isProcessingOcr = false;
      });
    }
  }

  void _saveExpense() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save expense to database
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${_selectedType == TransactionType.expense ? 'Expense' : 'Revenue'} saved successfully!',
            style: TextStyle(fontSize: 14.sp),
          ),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Add ${_selectedType == TransactionType.expense ? 'Expense' : 'Revenue'}',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 24.sp),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_selectedImage != null)
            IconButton(
              icon: Icon(Icons.document_scanner, size: 24.sp),
              onPressed: _isProcessingOcr ? null : _processImageWithOcr,
              tooltip: 'Process with OCR',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTypeSelector(),
                SizedBox(height: 24.h),
                _buildImageSection(),
                SizedBox(height: 24.h),
                _buildTitleSection(),
                SizedBox(height: 24.h),
                _buildAmountSection(),
                SizedBox(height: 24.h),
                _buildCategorySection(),
                SizedBox(height: 24.h),
                _buildDescriptionSection(),
                SizedBox(height: 24.h),
                _buildDateSection(),
                SizedBox(height: 40.h),
                CustomButton(
                  text:
                      'Save ${_selectedType == TransactionType.expense ? 'Expense' : 'Revenue'}',
                  onPressed: _saveExpense,
                  isLoading: _isProcessingOcr,
                  gradient: LinearGradient(
                    colors: _selectedType == TransactionType.expense
                        ? [Colors.red, Colors.orange]
                        : [Colors.green, Colors.teal],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Type',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = TransactionType.expense;
                      _selectedCategory = _expenseCategories.first;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: _selectedType == TransactionType.expense
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_circle_outline,
                          color: _selectedType == TransactionType.expense
                              ? Colors.red
                              : Colors.grey,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Expense',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: _selectedType == TransactionType.expense
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedType = TransactionType.revenue;
                      _selectedCategory = _revenueCategories.first;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    decoration: BoxDecoration(
                      color: _selectedType == TransactionType.revenue
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_circle_outline,
                          color: _selectedType == TransactionType.revenue
                              ? Colors.green
                              : Colors.grey,
                          size: 20.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Revenue',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: _selectedType == TransactionType.revenue
                                ? Colors.green
                                : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Receipt Image (Optional)',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        ImagePickerWidget(
          onImageSelected: (File image) {
            setState(() {
              _selectedImage = image;
            });
          },
          initialImagePath: _selectedImage?.path,
          width: double.infinity,
          height: 200,
          placeholderText: 'Tap to add receipt image',
        ),
        if (_selectedImage != null) ...[
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Process with OCR',
                  onPressed: _isProcessingOcr ? null : _processImageWithOcr,
                  isLoading: _isProcessingOcr,
                  gradient: const LinearGradient(
                    colors: [Colors.blue, Colors.indigo],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedImage = null;
                  });
                },
                icon: Icon(Icons.delete, color: Colors.red),
                tooltip: 'Remove image',
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Title',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: '',
          hint: 'Enter title',
          controller: _titleController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a title';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amount',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: '',
          hint: '0.00',
          controller: _amountController,
          keyboardType: TextInputType.number,
          prefixIcon: Padding(
            padding: EdgeInsets.all(16.w),
            child: Text(
              '\$',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid amount';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    final categories = _selectedType == TransactionType.expense
        ? _expenseCategories
        : _revenueCategories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Category',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCategory,
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, size: 24.sp),
              items: categories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category, style: TextStyle(fontSize: 14.sp)),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        CustomTextField(
          label: '',
          hint: 'Enter description',
          controller: _descriptionController,
          maxLines: 3,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Date',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        GestureDetector(
          onTap: _selectDate,
          child: CustomTextField(
            label: '',
            hint: 'Select date',
            controller: _dateController,
            enabled: false,
            prefixIcon: Icon(Icons.calendar_today, size: 20.sp),
            suffixIcon: Icon(Icons.keyboard_arrow_down, size: 20.sp),
          ),
        ),
      ],
    );
  }
}
