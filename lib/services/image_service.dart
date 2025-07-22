import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  static final ImagePicker _picker = ImagePicker();

  /// Opens camera and returns the captured image
  /// Returns null if user cancels or permission is denied
  static Future<File?> openCamera() async {
    try {
      // Check camera permission
      final cameraStatus = await Permission.camera.status;

      if (cameraStatus.isDenied) {
        final result = await Permission.camera.request();
        if (result.isDenied || result.isPermanentlyDenied) {
          _showPermissionDialog('Camera permission is required to take photos');
          return null;
        }
      }

      // Take picture
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80, // Compress image to reduce size
        maxWidth: 1920, // Limit max width
        maxHeight: 1080, // Limit max height
      );

      if (image != null) {
        return File(image.path);
      }

      return null;
    } catch (e) {
      debugPrint('Error opening camera: $e');
      _showErrorDialog('Failed to open camera. Please try again.');
      return null;
    }
  }

  /// Opens gallery and returns the selected image
  /// Returns null if user cancels or permission is denied
  static Future<File?> openGallery() async {
    try {
      // Check storage permission
      final storageStatus = await Permission.storage.status;
      final photosStatus = await Permission.photos.status;

      if (storageStatus.isDenied && photosStatus.isDenied) {
        final storageResult = await Permission.storage.request();
        final photosResult = await Permission.photos.request();

        if ((storageResult.isDenied || storageResult.isPermanentlyDenied) &&
            (photosResult.isDenied || photosResult.isPermanentlyDenied)) {
          _showPermissionDialog(
            'Storage permission is required to access gallery',
          );
          return null;
        }
      }

      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80, // Compress image to reduce size
        maxWidth: 1920, // Limit max width
        maxHeight: 1080, // Limit max height
      );

      if (image != null) {
        return File(image.path);
      }

      return null;
    } catch (e) {
      debugPrint('Error opening gallery: $e');
      _showErrorDialog('Failed to open gallery. Please try again.');
      return null;
    }
  }

  /// Shows image source selection dialog (Camera or Gallery)
  /// Returns the selected image file or null if cancelled
  static Future<File?> showImageSourceDialog(BuildContext context) async {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await openCamera();
                  if (context.mounted) {
                    Navigator.of(context).pop(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await openGallery();
                  if (context.mounted) {
                    Navigator.of(context).pop(image);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  /// Shows a simple image picker with camera and gallery options
  /// Returns the selected image file or null if cancelled
  static Future<File?> pickImage(BuildContext context) async {
    return showModalBottomSheet<File?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await openCamera();
                  if (image != null && context.mounted) {
                    Navigator.of(context).pop(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final image = await openGallery();
                  if (image != null && context.mounted) {
                    Navigator.of(context).pop(image);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(null),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Check if camera permission is granted
  static Future<bool> hasCameraPermission() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if storage permission is granted
  static Future<bool> hasStoragePermission() async {
    final storageStatus = await Permission.storage.status;
    final photosStatus = await Permission.photos.status;
    return storageStatus.isGranted || photosStatus.isGranted;
  }

  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final result = await Permission.camera.request();
    return result.isGranted;
  }

  /// Request storage permission
  static Future<bool> requestStoragePermission() async {
    final storageResult = await Permission.storage.request();
    final photosResult = await Permission.photos.request();
    return storageResult.isGranted || photosResult.isGranted;
  }

  /// Show permission dialog
  static void _showPermissionDialog(String message) {
    // This would typically show a dialog, but since we don't have context here,
    // we'll just print the message. In a real app, you'd want to pass context
    // or use a global navigator key.
    debugPrint('Permission Required: $message');
  }

  /// Show error dialog
  static void _showErrorDialog(String message) {
    // This would typically show a dialog, but since we don't have context here,
    // we'll just print the message. In a real app, you'd want to pass context
    // or use a global navigator key.
    debugPrint('Error: $message');
  }

  /// Get image size in MB
  static double getImageSizeInMB(File imageFile) {
    final bytes = imageFile.lengthSync();
    return bytes / (1024 * 1024); // Convert to MB
  }

  /// Check if image size is within acceptable limits (e.g., 10MB)
  static bool isImageSizeAcceptable(File imageFile, {double maxSizeMB = 10.0}) {
    final sizeInMB = getImageSizeInMB(imageFile);
    return sizeInMB <= maxSizeMB;
  }
}
