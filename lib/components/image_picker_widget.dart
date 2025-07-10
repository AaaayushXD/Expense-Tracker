import 'dart:io';
import 'package:flutter/material.dart';
import '../services/image_service.dart';

class ImagePickerWidget extends StatefulWidget {
  final Function(File) onImageSelected;
  final String? initialImagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? placeholderText;

  const ImagePickerWidget({
    super.key,
    required this.onImageSelected,
    this.initialImagePath,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholderText,
  });

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _selectedImage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialImagePath != null) {
      _selectedImage = File(widget.initialImagePath!);
    }
  }

  Future<void> _pickImage() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final File? image = await ImageService.pickImage(context);

      if (image != null) {
        // Check image size
        if (!ImageService.isImageSizeAcceptable(image, maxSizeMB: 10.0)) {
          if (mounted) {
            _showErrorDialog(
              'Image size is too large. Please select an image smaller than 10MB.',
            );
          }
          return;
        }

        setState(() {
          _selectedImage = image;
        });

        widget.onImageSelected(image);
      }
    } catch (e) {
      if (mounted) {
        _showErrorDialog('Failed to pick image. Please try again.');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isLoading ? null : _pickImage,
      child: Container(
        width: widget.width ?? 120,
        height: widget.height ?? 120,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!, width: 2),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _selectedImage!,
                  width: widget.width ?? 120,
                  height: widget.height ?? 120,
                  fit: widget.fit,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                ),
              )
            : _buildPlaceholder(),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, size: 32, color: Colors.grey[600]),
        const SizedBox(height: 8),
        Text(
          widget.placeholderText ?? 'Add Photo',
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

// Example usage widget
class ImagePickerExample extends StatefulWidget {
  const ImagePickerExample({super.key});

  @override
  State<ImagePickerExample> createState() => _ImagePickerExampleState();
}

class _ImagePickerExampleState extends State<ImagePickerExample> {
  File? _selectedImage;

  void _onImageSelected(File image) {
    setState(() {
      _selectedImage = image;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Image selected successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Picker Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select an image:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Center(
              child: ImagePickerWidget(
                onImageSelected: _onImageSelected,
                width: 200,
                height: 200,
                placeholderText: 'Tap to select image',
              ),
            ),
            const SizedBox(height: 24),
            if (_selectedImage != null) ...[
              const Text(
                'Selected Image:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(_selectedImage!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Image size: ${ImageService.getImageSizeInMB(_selectedImage!).toStringAsFixed(2)} MB',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
